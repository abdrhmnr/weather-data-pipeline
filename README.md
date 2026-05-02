# Weather Data Pipeline

> **Graduation Project — DEPI** · Python · PostgreSQL · Docker · OpenWeatherMap
>
> An end-to-end ETL pipeline that extracts current weather data for 10 Arab cities, transforms and validates it, predicts whether it will rain tomorrow using a Random Forest model, and loads everything into a PostgreSQL warehouse — all containerized with Docker and scheduled to run hourly.

---

## Table of Contents

1. [Project Overview](#project-overview)
2. [Architecture](#architecture)
3. [Tech Stack](#tech-stack)
4. [Project Structure](#project-structure)
5. [Quick Start](#quick-start)
6. [Verifying the Setup](#verifying-the-setup)
7. [Configuration](#configuration)
8. [Database Schema](#database-schema)
9. [Performance Optimizations](#performance-optimizations)
10. [Pipeline Flow](#pipeline-flow)
11. [Scheduling](#scheduling)
12. [Testing](#testing)
13. [Sample Queries](#sample-queries)
14. [Troubleshooting](#troubleshooting)
15. [Documentation](#documentation)
16. [Team and Roles](#team-and-roles)
17. [License](#license)

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
- Indexed schema for fast analytical queries
- Single-command deployment with `docker-compose up`

---

## Architecture

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

The pipeline is a classic **ETL** flow split across three Python modules and orchestrated by a scheduler. Both the Python service and PostgreSQL run as Docker containers managed by a single `docker-compose.yml`.

---

## Tech Stack

| Layer          | Tool               | Version    | Why                                        |
| -------------- | ------------------ | ---------- | ------------------------------------------ |
| Language       | Python             | 3.11       | Mature ecosystem for ETL & ML              |
| HTTP client    | `requests`         | 2.31       | Retry-enabled session for API calls        |
| Data wrangling | `pandas` + `numpy` | 2.1 / 1.26 | Cleaning historical CSV                    |
| ML             | `scikit-learn`     | 1.3        | RandomForestClassifier for rain prediction |
| Database       | PostgreSQL         | 15         | ACID, UUIDs, JSONB, ENUMs                  |
| DB driver      | `psycopg2-binary`  | 2.9        | Battle-tested PG driver                    |
| Scheduling     | `schedule`         | 1.2        | Lightweight in-process cron                |
| Config         | `python-dotenv`    | 1.0        | `.env` file management                     |
| Container      | Docker + Compose   | latest     | Reproducible deployment                    |
| Timezones      | `pytz`             | 2024.1     | UTC-normalized timestamps                  |

---

## Project Structure

weather-data-pipeline/
├── src/ # Core ETL code
│ ├── extract.py # API client (with retry/backoff)
│ ├── transform.py # Cleaning + ML predictions
│ ├── load.py # PostgreSQL loader with upserts
│ └── pipeline.py # Orchestrator
├── config/
│ └── settings.py # Environment-driven config
├── database/
│ └── schema.sql # DDL — auto-applied on first DB start
├── scheduler/
│ └── cron*job.py # Hourly job runner
├── tests/
│ └── test_pipeline.py # Unit tests for transformations
├── assets/
│ ├── weather.csv # Historical training data
│ └── weather_database_erd_visualization*\*.png # ERD image
├── docs/ # Project documentation
│ ├── 01_project_planning_and_management.md
│ ├── 02_literature_review.md
│ ├── 03_requirements_gathering.md
│ └── 04_system_analysis_and_design.md
├── logs/ # Runtime log output
├── reports/ # Generated reports (gitignored)
├── Dockerfile # Python service image
├── docker-compose.yml # 2-service stack (db + pipeline)
├── requirements.txt # Python dependencies
├── .env.example # Template for required secrets
├── .gitignore
└── README.md # ← you are here

text

---

## Quick Start

### Prerequisites

Make sure you have these installed:

| Tool                   | Version   | Download                                                     |
| ---------------------- | --------- | ------------------------------------------------------------ |
| Docker Desktop         | 20.10+    | [docker.com](https://www.docker.com/products/docker-desktop) |
| Git                    | 2.30+     | [git-scm.com](https://git-scm.com/)                          |
| OpenWeatherMap account | free tier | [openweathermap.org/api](https://openweathermap.org/api)     |

Verify installations:

```bash
docker --version           # Docker version 20.x.x
docker-compose --version   # Docker Compose version 2.x.x
git --version              # git version 2.x.x
Option A — Docker (recommended)
bash
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
⚠️ Note: Newly created OpenWeatherMap API keys can take up to 2 hours to activate.

Option B — Local Python (for development)
bash
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
Verifying the Setup
After running docker-compose up --build, verify everything is working correctly:

1. Check container status
bash
docker-compose ps
Expected output: Both containers should be Up:

text
NAME                               STATUS
weather-data-pipeline-db-1         Up
weather-data-pipeline-pipeline-1   Up
2. Check pipeline logs
bash
docker-compose logs pipeline --tail=20
Expected output: You should see:

text
Pipeline finished. Status: SUCCESS. Loaded: 10, Rejected: 0
3. Verify data was loaded
bash
docker-compose exec db psql -U postgres -d weather_db \
  -c "SELECT COUNT(*) FROM weather_readings;"
Expected output: A number ≥ 10.

4. View a sample of the data
bash
docker-compose exec db psql -U postgres -d weather_db -c "
  SELECT l.city, w.temp_avg_c, w.humidity_pct, w.wind_direction, w.rain_tomorrow
  FROM weather_readings w
  JOIN locations l ON w.location_id = l.id
  ORDER BY l.city;
"
You should see one row per city with realistic weather data. ✅

Configuration
All secrets and tunables live in .env. A safe template is provided in .env.example:

ini
# Database
DB_HOST=db
DB_PORT=5432
DB_NAME=weather_db
DB_USER=postgres
DB_PASSWORD=postgres_password

# Weather API (OpenWeatherMap — free tier sufficient)
# Get a free key from: https://openweathermap.org/api
# Note: New keys take up to 2 hours to activate
WEATHER_API_KEY=your_api_key_here
API_BASE_URL=https://api.openweathermap.org/data/2.5/weather
🔒 Security: The .env file is excluded from git via .gitignore to keep secrets safe. Never commit it.

Validation thresholds and the city list live in config/settings.py and can be tweaked without touching the pipeline code.

Database Schema
The schema (in database/schema.sql) defines three tables and one custom enum type:

locations — Master table of cities. UUID-keyed, with (city, country) as the natural unique key so re-runs upsert cleanly.

weather_readings — The fact table. One row per (location, timestamp) — the unique constraint on (location_id, observation_timestamp) is what makes the pipeline idempotent.

Columns include normalized temperature (°C), humidity (%), pressure (hPa), wind speed (km/h), wind direction as both degrees and a 16-point enum, the rain_tomorrow ML prediction (boolean), and the original weather description.

pipeline_runs — The observability table. Every pipeline invocation gets a row tracking start/end time, status (RUNNING/SUCCESS/PARTIAL/FAILED), per-stage record counts, and any error message. Each weather_readings row references the pipeline_run_id that produced it — full lineage.

A rendered ERD lives at assets/weather_database_erd_visualization_*.png.

Performance Optimizations
The schema includes the following indexes for fast analytical and operational queries:

Index	Table	Purpose
idx_weather_location_time	weather_readings	Fast lookup of latest readings per city (composite index on location_id, observation_timestamp DESC)
idx_weather_observation_time	weather_readings	Time-series queries (charts, trends over time)
idx_weather_pipeline_run	weather_readings	Joins with pipeline runs (data lineage)
idx_pipeline_runs_status_time	pipeline_runs	Monitoring queries filtered by status
idx_pipeline_runs_started	pipeline_runs	Recent runs lookup for dashboards
idx_locations_city	locations	City search and autocomplete
These indexes are automatically created when the database initializes for the first time. To inspect them:

bash
docker-compose exec db psql -U postgres -d weather_db \
  -c "SELECT tablename, indexname FROM pg_indexes WHERE schemaname='public' ORDER BY tablename;"
Pipeline Flow
The pipeline (src/pipeline.py) executes the following steps:

Open a run record — INSERT into pipeline_runs with status=RUNNING.
Train the rain-tomorrow model — load assets/weather.csv and fit a RandomForestClassifier on it.
For each city in TARGET_CITIES:
Extract — call OpenWeatherMap with retry/backoff (3 retries on 5xx errors).
Transform — convert wind speed m/s → km/h, map degrees to 16-point compass, run rain prediction.
Validate — reject readings with temperature outside [-50, 60]°C or humidity outside [0, 100]%.
Load — upsert location, then INSERT … ON CONFLICT DO NOTHING the reading.
Close the run — set the final status (SUCCESS, PARTIAL, or FAILED), record counts, and finish timestamp.
Failure modes (API down, DB unreachable, single bad city) are caught at the appropriate boundary so a single bad city never aborts the whole run.

Scheduling
scheduler/cron_job.py uses the schedule library to run the pipeline once at startup, then every hour at minute :00:

python
schedule.every().hour.at(":00").do(job)
Logs are written to both stdout (visible via docker-compose logs) and logs/scheduler.log.

To change the cadence, edit the schedule.every()… line — for daily runs use schedule.every().day.at("06:00").

Testing
Unit tests live in tests/test_pipeline.py and cover the transformation logic (unit conversions, compass mapping, prediction output type):

bash
# from the repo root
python -m unittest discover -s tests -v
Inside the container:

bash
docker-compose exec pipeline python -m unittest discover -s tests -v
Sample Queries
Once the pipeline has run at least once, try these in psql or pgAdmin:

sql
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
Troubleshooting
❌ Cannot connect to Docker daemon
Make sure Docker Desktop is running before executing any docker-compose command.

❌ Port 5432 is already in use
Another PostgreSQL instance is running on your machine. Either stop it:

bash
brew services stop postgresql      # macOS
sudo systemctl stop postgresql     # Linux
Or change the port mapping in docker-compose.yml from "5432:5432" to "5433:5432".

❌ WEATHER_API_KEY not found in environment
Verify that .env exists in the project root
Verify that WEATHER_API_KEY is set with a valid value (not the placeholder)
Restart the containers:
bash
docker-compose down
docker-compose up -d
❌ 401 Unauthorized from the API
Newly created OpenWeatherMap API keys take up to 2 hours to activate. Wait and try again.

❌ relation "weather_readings" does not exist
The schema didn't load correctly. Reset the database:

bash
docker-compose down -v   # ⚠️ this deletes all data
docker-compose up -d --build
❌ Pipeline runs show PARTIAL status with 0 records loaded
Check the logs for the specific error:

bash
docker-compose logs pipeline --tail=50
Common causes:

Missing fields in the API response
Schema/code mismatch (e.g., a column name in code doesn't match the DB)
Database connection issues
❌ "Connection refused" between pipeline and database
The pipeline container started before the db container was ready. Restart:

bash
docker-compose restart pipeline
🔍 How to inspect the database manually
bash
# Open a psql session inside the db container
docker-compose exec db psql -U postgres -d weather_db

# Useful psql commands once inside:
\dt                          -- list tables
\d weather_readings          -- describe a table
\di                          -- list indexes
\q                           -- quit
Documentation
Full project documentation lives under docs/:

File	Contents
docs/01_project_planning_and_management.md	Proposal · plan · Gantt · roles · risks · KPIs
docs/02_literature_review.md	Related work · evaluation framework · grading criteria
docs/03_requirements_gathering.md	Stakeholders · use cases · functional & non-functional requirements
docs/04_system_analysis_and_design.md	Architecture · ERD · DFD · sequence/class/activity diagrams
Team and Roles
Member	Module	Role
Abdrhmn	M1 — extract.py	API & Data Collection Lead
Aya	M2 — transform.py	Data Cleaning & EDA Lead
Rana	M3 — database/schema.sql	Database Architect
Suzette	M4 — load.py, pipeline.py	ETL Engineer
Esraa	M5 — Dockerfile, cron_job.py	DevOps & Scheduling
Sofia	M6 — Logging & Docs	Monitoring & Documentation
See docs/01_project_planning_and_management.md for detailed responsibilities, weekly assignments, and the Gantt chart.

License
This is an academic project developed for the Digital Egypt Pioneers Initiative (DEPI) graduation requirements. © 2026 the team. All rights reserved.

Need help running it? Check the Troubleshooting section first, then docs/, then open an issue on GitHub.
Found a bug? Pull requests welcome — please target a feature branch, never main.

```
