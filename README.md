# Weather Data Pipeline

> **Graduation Project — DEPI** · Python · PostgreSQL · Docker · Open-Meteo / OpenWeatherMap
>
> An end-to-end ETL pipeline that extracts current weather data for 10 Arab cities, transforms and validates it, predicts whether it will rain tomorrow using a Random Forest model, and loads everything into a PostgreSQL warehouse — all containerized with Docker and scheduled to run hourly.

---

## Table of Contents

1. [Project Overview](#project-overview)
2. [Architecture](#architecture)
3. [Tech Stack](#tech-stack)
4. [Project Structure](#project-structure)
5. [Quick Start](#quick-start)
6. [Configuration](#configuration)
7. [Database Schema](#database-schema)
8. [Pipeline Flow](#pipeline-flow)
9. [Scheduling](#scheduling)
10. [Testing](#testing)
11. [Sample Queries](#sample-queries)
12. [Documentation](#documentation)
13. [Team and Roles](#team-and-roles)
14. [License](#license)

---

## Project Overview

**Goal — الهدف:**
Build a production-grade data pipeline that automates the collection, cleaning, enrichment, and storage of weather observations for 10 Arab cities, with built-in monitoring of every pipeline run.

**Why this matters — أهمية المشروع:**
Manual weather monitoring across multiple cities is repetitive and error-prone. A scheduled pipeline guarantees fresh, validated, deduplicated data is always available for downstream analytics, dashboards, and ML models.

**Cities tracked — المدن المتابعَة:**
Cairo · Riyadh · Dubai · Baghdad · Beirut · Amman · Kuwait · Doha · Casablanca · Tunis

**Key features — الميزات الرئيسية:**

- Hourly automated extraction from a public weather API
- Data validation against physical thresholds (temperature, humidity, pressure)
- Unit normalization (m/s → km/h) and 16-point compass wind direction
- Rain-tomorrow prediction using a Random Forest classifier trained on historical data
- Idempotent upserts (running the pipeline twice never duplicates rows)
- Run-by-run observability via a `pipeline_runs` audit table
- Single-command deployment with `docker-compose up`

---

## Architecture

```
                ┌──────────────────────┐
                │   OpenWeatherMap     │
                │   (External API)     │
                └──────────┬───────────┘
                           │ HTTPS / JSON
                           ▼
        ┌──────────────────────────────────┐
        │   Python ETL Pipeline (Docker)   │
        │ ┌──────────┐ ┌──────────┐ ┌────┐ │
        │ │ Extract  │→ │Transform │→│Load│ │
        │ │extract.py│  │transform │ │load│ │
        │ └──────────┘  └──────────┘ └─┬──┘ │
        │       ▲                      │    │
        │       │      scheduler/      │    │
        │       └──── cron_job.py ─────┘    │
        └──────────────────────┬───────────┘
                               │ psycopg2
                               ▼
                  ┌────────────────────────┐
                  │  PostgreSQL 15 (Docker)│
                  │  ┌────────────────┐    │
                  │  │ locations      │    │
                  │  │ weather_readings│   │
                  │  │ pipeline_runs  │    │
                  │  └────────────────┘    │
                  └────────────────────────┘
```

The pipeline is a classic **ETL** flow split across three Python modules and orchestrated by a scheduler. Both the Python service and PostgreSQL run as Docker containers managed by a single `docker-compose.yml`.

---

## Tech Stack

| Layer | Tool | Version | Why |
|-------|------|---------|-----|
| Language | Python | 3.11 | Mature ecosystem for ETL & ML |
| HTTP client | `requests` | 2.31 | Retry-enabled session for API calls |
| Data wrangling | `pandas` + `numpy` | 2.1 / 1.26 | Cleaning historical CSV |
| ML | `scikit-learn` | 1.3 | RandomForestClassifier for rain prediction |
| Database | PostgreSQL | 15 | ACID, UUIDs, JSONB, ENUMs |
| DB driver | `psycopg2-binary` | 2.9 | Battle-tested PG driver |
| Scheduling | `schedule` | 1.2 | Lightweight in-process cron |
| Config | `python-dotenv` | 1.0 | `.env` file management |
| Container | Docker + Compose | latest | Reproducible deployment |
| Timezones | `pytz` | 2024.1 | UTC-normalized timestamps |

---

## Project Structure

```
weather-data-pipeline/
├── src/                          # Core ETL code
│   ├── extract.py                # API client (with retry/backoff)
│   ├── transform.py              # Cleaning + ML predictions
│   ├── load.py                   # PostgreSQL loader with upserts
│   └── pipeline.py               # Orchestrator
├── config/
│   └── settings.py               # Environment-driven config
├── database/
│   └── schema.sql                # DDL — auto-applied on first DB start
├── scheduler/
│   └── cron_job.py               # Hourly job runner
├── tests/
│   └── test_pipeline.py          # Unit tests for transformations
├── assets/
│   ├── weather.csv               # Historical training data
│   └── weather_database_erd_visualization_*.png  # ERD image
├── docs/                         # Project documentation
│   ├── 01_project_planning_and_management.md
│   ├── 02_literature_review.md
│   ├── 03_requirements_gathering.md
│   └── 04_system_analysis_and_design.md
├── logs/                         # Runtime log output
├── reports/                      # Generated reports (gitignored)
├── Dockerfile                    # Python service image
├── docker-compose.yml            # 2-service stack (db + pipeline)
├── requirements.txt              # Python dependencies
├── .env.example                  # Template for required secrets
├── .gitignore
└── README.md                     # ← you are here
```

---

## Quick Start

### Option A — Docker (recommended)

```bash
# 1. Clone the repo
git clone https://github.com/<your-org>/weather-data-pipeline.git
cd weather-data-pipeline

# 2. Create your .env file from the template
cp .env.example .env
# then edit .env and set WEATHER_API_KEY=<your_openweathermap_key>

# 3. Build and start the stack
docker-compose up --build

# That's it — the schema is auto-applied, the pipeline runs once on startup,
# and the scheduler then triggers it every hour.
```

### Option B — Local Python (for development)

```bash
# 1. Create a virtual env (or use conda)
python3.11 -m venv venv
source venv/bin/activate          # Windows: venv\Scripts\activate

# 2. Install dependencies
pip install -r requirements.txt

# 3. Start a local PostgreSQL and apply the schema
psql -U postgres -c "CREATE DATABASE weather_db;"
psql -U postgres -d weather_db -f database/schema.sql

# 4. Set your env vars (see .env.example) and run
export $(cat .env | xargs)
python -m src.pipeline           # one-shot run
# or
python scheduler/cron_job.py     # scheduled (hourly) run
```

---

## Configuration

All secrets and tunables live in `.env`. A safe template is provided in `.env.example`:

```ini
# Database
DB_HOST=localhost
DB_PORT=5432
DB_NAME=weather_db
DB_USER=postgres
DB_PASSWORD=your_password_here

# Weather API (OpenWeatherMap — free tier sufficient)
WEATHER_API_KEY=your_api_key_here
API_BASE_URL=https://api.openweathermap.org/data/2.5/weather
```

Get a free OpenWeatherMap key at <https://openweathermap.org/api>.

Validation thresholds and the city list live in `config/settings.py` and can be tweaked without touching the pipeline code.

---

## Database Schema

The schema (in `database/schema.sql`) defines three tables and one custom enum type:

**`locations`** — Master table of cities. UUID-keyed, with `(city, country)` as the natural unique key so re-runs upsert cleanly.

**`weather_readings`** — The fact table. One row per `(location, timestamp)` — the unique constraint on `(location_id, observation_timestamp)` is what makes the pipeline **idempotent**.

Columns include normalized temperature (°C), humidity (%), pressure (hPa), wind speed (km/h), wind direction as both degrees and a 16-point enum, the `rain_tomorrow` ML prediction (boolean), and the original weather description.

**`pipeline_runs`** — The observability table. Every pipeline invocation gets a row tracking start/end time, status (`RUNNING`/`SUCCESS`/`PARTIAL_SUCCESS`/`FAILED`), per-stage record counts, and any error message. Each `weather_readings` row references the `pipeline_run_id` that produced it — full lineage.

A rendered ERD lives at `assets/weather_database_erd_visualization_*.png`.

---

## Pipeline Flow

The pipeline (`src/pipeline.py`) executes the following steps:

1. **Open a run record** — `INSERT` into `pipeline_runs` with status=`RUNNING`.
2. **Train the rain-tomorrow model** — load `assets/weather.csv` and fit a `RandomForestClassifier` on it.
3. **For each city in `TARGET_CITIES`:**
   - **Extract** — call OpenWeatherMap with retry/backoff (3 retries on 5xx errors).
   - **Transform** — convert wind speed m/s → km/h, map degrees to 16-point compass, run rain prediction.
   - **Validate** — reject readings with temperature outside `[-50, 60]°C` or humidity outside `[0, 100]%`.
   - **Load** — upsert location, then `INSERT … ON CONFLICT DO NOTHING` the reading.
4. **Close the run** — set the final status, record counts, and finish timestamp.

Failure modes (API down, DB unreachable, single bad city) are caught at the appropriate boundary so a single bad city never aborts the whole run.

---

## Scheduling

`scheduler/cron_job.py` uses the `schedule` library to run the pipeline **once at startup, then every hour at minute :00**:

```python
schedule.every().hour.at(":00").do(job)
```

Logs are written to both stdout (visible via `docker-compose logs`) and `logs/scheduler.log`.

To change the cadence, edit the `schedule.every()…` line — for daily runs use `schedule.every().day.at("06:00")`.

---

## Testing

Unit tests live in `tests/test_pipeline.py` and cover the transformation logic (unit conversions, compass mapping, prediction output type):

```bash
# from the repo root
python -m unittest discover -s tests -v
```

Inside the container:

```bash
docker-compose exec pipeline python -m unittest discover -s tests -v
```

---

## Sample Queries

Once the pipeline has run at least once, try these in `psql` or pgAdmin:

```sql
-- 1. Latest reading per city
SELECT l.city, w.temp_avg_c, w.humidity_pct, w.observation_timestamp
FROM weather_readings w
JOIN locations l ON l.id = w.location_id
WHERE (w.location_id, w.observation_timestamp) IN (
    SELECT location_id, MAX(observation_timestamp)
    FROM weather_readings GROUP BY location_id
)
ORDER BY l.city;

-- 2. How well is the pipeline running?
SELECT status, COUNT(*) AS runs,
       AVG(records_loaded)::INT AS avg_loaded,
       AVG(records_rejected)::INT AS avg_rejected
FROM pipeline_runs
GROUP BY status;

-- 3. Cities where rain is predicted tomorrow
SELECT l.city, w.observation_timestamp, w.temp_avg_c, w.humidity_pct
FROM weather_readings w
JOIN locations l ON l.id = w.location_id
WHERE w.rain_tomorrow = TRUE
ORDER BY w.observation_timestamp DESC
LIMIT 20;

-- 4. Hottest hour ever recorded per city
SELECT l.city, MAX(w.temp_max_c) AS peak_temp
FROM weather_readings w JOIN locations l ON l.id = w.location_id
GROUP BY l.city ORDER BY peak_temp DESC;
```

---

## Documentation

Full project documentation lives under `docs/`:

| File | Contents |
|------|----------|
| [`docs/01_project_planning_and_management.md`](docs/01_project_planning_and_management.md) | Proposal · plan · Gantt · roles · risks · KPIs |
| [`docs/02_literature_review.md`](docs/02_literature_review.md) | Related work · evaluation framework · grading criteria |
| [`docs/03_requirements_gathering.md`](docs/03_requirements_gathering.md) | Stakeholders · use cases · functional & non-functional requirements |
| [`docs/04_system_analysis_and_design.md`](docs/04_system_analysis_and_design.md) | Architecture · ERD · DFD · sequence/class/activity diagrams |

---

## Team and Roles

| Member | Module | Role |
|--------|--------|------|
| **Abdrhmn** | M1 — `extract.py` | API & Data Collection Lead |
| **Aya** | M2 — `transform.py` | Data Cleaning & EDA Lead |
| **Rana** | M3 — `database/schema.sql` | Database Architect |
| **Suzette** | M4 — `load.py`, `pipeline.py` | ETL Engineer |
| **Esraa** | M5 — `Dockerfile`, `cron_job.py` | DevOps & Scheduling |
| **Sofia** | M6 — Logging & Docs | Monitoring & Documentation |

See [`docs/01_project_planning_and_management.md`](docs/01_project_planning_and_management.md) for detailed responsibilities, weekly assignments, and the Gantt chart.

---

## License

This is an academic project developed for the **Digital Egypt Pioneers Initiative (DEPI)** graduation requirements. © 2026 the team. All rights reserved.

---

> Need help running it? Check `docs/` first, then open an issue on GitHub.
> Found a bug? Pull requests welcome — please target a feature branch, never `main`.
