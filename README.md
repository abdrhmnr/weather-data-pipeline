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

* Hourly automated extraction from a public weather API
* Data validation against physical thresholds (temperature, humidity, pressure)
* Unit normalization (m/s → km/h) and 16-point compass wind direction
* Rain-tomorrow prediction using a Random Forest classifier trained on historical data
* Idempotent upserts (running the pipeline twice never duplicates rows)
* Run-by-run observability via a `pipeline_runs` audit table
* Indexed schema for fast analytical queries
* Single-command deployment with `docker-compose up`

---

## Architecture

```text
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

```bash
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
│ └── cron_job.py # Hourly job runner
├── tests/
│ └── test_pipeline.py # Unit tests for transformations
├── assets/
│ ├── weather.csv # Historical training data
│ └── weather_database_erd_visualization_*.png # ERD image
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
```

---

## Quick Start

### Prerequisites

Make sure you have these installed:

| Tool                   | Version   | Download                                       |
| ---------------------- | --------- | ---------------------------------------------- |
| Docker Desktop         | 20.10+    | https://www.docker.com/products/docker-desktop |
| Git                    | 2.30+     | https://git-scm.com/                           |
| OpenWeatherMap account | free tier | https://openweathermap.org/api                 |

Verify installations:

```bash
docker --version
docker-compose --version
git --version
```

### Option A — Docker (recommended)

```bash
# 1. Clone the repo
git clone https://github.com/<your-org>/weather-data-pipeline.git
cd weather-data-pipeline

# 2. Create your .env file from the template
cp .env.example .env

# 3. Build and start the stack
docker-compose up --build
```

⚠️ Note: Newly created OpenWeatherMap API keys can take up to 2 hours to activate.

---

### Option B — Local Python (for development)

```bash
python3.11 -m venv venv
source venv/bin/activate

pip install -r requirements.txt

psql -U postgres -c "CREATE DATABASE weather_db;"
psql -U postgres -d weather_db -f database/schema.sql

export $(cat .env | xargs)
python -m src.pipeline
```

---

## Verifying the Setup

```bash
docker-compose ps
docker-compose logs pipeline --tail=20
```

---

## Configuration

```ini
DB_HOST=db
DB_PORT=5432
DB_NAME=weather_db
DB_USER=postgres
DB_PASSWORD=postgres_password

WEATHER_API_KEY=your_api_key_here
API_BASE_URL=https://api.openweathermap.org/data/2.5/weather
```

---

## Database Schema

* locations
* weather_readings
* pipeline_runs

---

## Performance Optimizations

* Indexed queries
* Fast lookup per city
* Time-series optimization

---

## Pipeline Flow

1. Start run
2. Train model
3. Extract
4. Transform
5. Validate
6. Load
7. Finish

---

## Scheduling

```python
schedule.every().hour.at(":00").do(job)
```

---

## Testing

```bash
python -m unittest discover -s tests -v
```

---

## Sample Queries

```sql
SELECT * FROM weather_readings LIMIT 10;
```

---

## Troubleshooting

* تأكد من Docker
* تأكد من API key
* راجع logs

---

## Documentation

Full project documentation lives under `docs/`

---

## Team and Roles

* Extract
* Transform
* Load
* DevOps

---

## License

Academic project — DEPI © 2026
