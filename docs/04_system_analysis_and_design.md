# 4. System Analysis & Design

> **Project:** Weather Data Pipeline
> **Track:** DEPI Graduation Project — First Submission (Documentation)
> **Last Updated:** April 2026

This document specifies *how* the system is structured: its components, data model, behaviour, and deployment topology. All diagrams are rendered in ASCII for portability; PNG exports live in `assets/`.

---

## 4.1 Problem Statement & Objectives — تكرار موجز

**Problem.** No automated, deduplicated, queryable repository of hourly weather observations exists for the 10 target Arab cities. Analysts and downstream applications must re-query an external API every time, with no historical record and no quality assurance.

**Objectives.**

1. Continuously ingest current weather for 10 cities.
2. Validate, normalize, and enrich observations before storage.
3. Persist observations in a relational database with full lineage to the run that produced them.
4. Provide a one-command Docker deployment.

(See `03_requirements_gathering.md` for the full requirements.)

---

## 4.2 Use Case Diagram & Descriptions

### 4.2.1 Diagram (textual)

```
                ┌───────────────────────────────────────┐
                │       Weather Data Pipeline           │
                │                                       │
   Scheduler ───┼──→  UC-1  Run hourly pipeline         │
                │           │                           │
                │           ├─→ UC-2  Extract weather   │──→  OpenWeatherMap API
                │           ├─→ UC-3  Transform & validate
                │           └─→ UC-4  Load into DB      │──→  PostgreSQL
                │                                       │
   Data Eng. ───┼──→  UC-5  Run pipeline manually       │
                │     UC-6  Inspect run history         │──→  PostgreSQL
                │                                       │
   Analyst   ───┼──→  UC-7  Query latest readings       │──→  PostgreSQL
                │     UC-8  Query rain forecast         │
                └───────────────────────────────────────┘
```

### 4.2.2 Actors

| Actor | Type | Responsibility |
|-------|------|----------------|
| Scheduler | System | Triggers UC-1 once per hour at `:00`. |
| Data Engineer | Human | Manual runs (UC-5), monitoring (UC-6). |
| Data Analyst | Human | Read-only SQL access (UC-7, UC-8). |
| OpenWeatherMap API | External system | Provides weather data on request. |
| PostgreSQL | System | Persistence layer for `locations`, `weather_readings`, `pipeline_runs`. |

(Detailed use-case templates are in `03_requirements_gathering.md` §3.3.)

---

## 4.3 Functional & Non-Functional Requirements (Summary)

A condensed view; the canonical list lives in §3.4–§3.5.

| Category | Sample requirements |
|----------|---------------------|
| Functional | Extract for 10 cities; reject out-of-range readings; idempotent upsert; record every run. |
| Performance | ≤ 60 s end-to-end; ≤ 100 ms per DB write. |
| Reliability | ≥ 99% rolling success rate; single-city failure isolation. |
| Security | `.env` only; least-privilege DB user; no secrets in logs. |
| Maintainability | Modular code; pinned versions; one source of truth for the schema. |
| Portability | Linux/macOS/Windows via Docker Desktop. |

---

## 4.4 Software Architecture — معمارية النظام

### 4.4.1 Architecture Style

**Pipes & Filters** within a **Layered** application, deployed as **two cooperating containers**.

- **Pipes & Filters** — `extract → transform → validate → load` is a linear chain where each stage transforms the data and passes it forward.
- **Layered** — clear separation of *Configuration*, *Domain logic*, *Persistence*, and *Orchestration*.
- We deliberately did **not** adopt microservices, MVC, or event-driven patterns — they would add operational complexity disproportionate to a single-host hourly batch job.

### 4.4.2 Logical Architecture (component view)

```
┌────────────────────────────────────────────────────────────────────┐
│                     Application Container                           │
│                                                                     │
│  ┌─────────────────┐                                                │
│  │ scheduler/      │   triggers run_pipeline() every hour           │
│  │ cron_job.py     │─────────────────────────────────┐              │
│  └─────────────────┘                                 │              │
│                                                      ▼              │
│  ┌─────────────────────────────────────────────────────────┐        │
│  │                   src/pipeline.py                       │        │
│  │  (orchestrator: open run → extract → transform →        │        │
│  │   validate → load → close run)                          │        │
│  └────────┬───────────────┬───────────────┬────────────────┘        │
│           │               │               │                         │
│           ▼               ▼               ▼                         │
│  ┌────────────┐  ┌────────────────┐  ┌────────────┐                 │
│  │ extract.py │  │ transform.py   │  │ load.py    │                 │
│  │ (HTTP +    │  │ (units, ML,    │  │ (psycopg2  │                 │
│  │  retries)  │  │  validation)   │  │  upserts)  │                 │
│  └─────┬──────┘  └────────┬───────┘  └─────┬──────┘                 │
│        │                  │                │                        │
│        │   ┌──────────────────────┐        │                        │
│        │   │   config/settings.py │◄───────┘                        │
│        │   │   (env-driven cfg)   │                                 │
│        │   └──────────────────────┘                                 │
└────────┼──────────────────────────────────┼─────────────────────────┘
         │ HTTPS                            │ TCP/5432 (psycopg2)
         ▼                                  ▼
┌──────────────────────┐       ┌────────────────────────┐
│  OpenWeatherMap API  │       │  PostgreSQL Container  │
│ (api.openweather...) │       │  (postgres:15)         │
└──────────────────────┘       └────────────────────────┘
```

### 4.4.3 Module Responsibilities

| Module | Responsibility | Inputs | Outputs |
|--------|----------------|--------|---------|
| `config/settings.py` | Read `.env`, define constants (cities, thresholds, paths) | OS env | Python module-level constants |
| `src/extract.py` | HTTP client with retry/backoff | City name | Flat dict of raw weather fields, or `None` |
| `src/transform.py` | Unit conversions + ML predictions | Raw dict + historical CSV | Enriched dict |
| `src/load.py` | DB writes (locations, readings, runs) | Enriched dict + run id | Boolean success |
| `src/pipeline.py` | Orchestration + validation | — | Side effects on the DB |
| `scheduler/cron_job.py` | Periodic trigger + log setup | — | Side effects on logs and DB |
| `database/schema.sql` | DDL for the three tables | — | DB schema |
| `tests/test_pipeline.py` | Unit tests for transformations | — | Pass/fail |

### 4.4.4 Architectural Decisions (ADR-style summary)

| # | Decision | Alternatives considered | Rationale |
|---|----------|-------------------------|-----------|
| ADR-1 | Use PostgreSQL | SQLite, MongoDB, CSV | ACID + JSONB + ENUM + mature ecosystem |
| ADR-2 | Use `schedule` library, not Airflow | Airflow, Prefect, system cron | Single-host, ≤ 1 job/h — Airflow's complexity is unjustified |
| ADR-3 | UUIDs as primary keys | Auto-increment integers | No collision when merging environments later; `uuid-ossp` already installed |
| ADR-4 | Idempotent upserts via `ON CONFLICT` | App-level dedup, MERGE | DB-native, atomic, no race window |
| ADR-5 | Random Forest for rain prediction | LR, XGBoost, NN | Best accuracy/simplicity ratio on historical CSV |
| ADR-6 | Two-container Compose stack | Single image, Kubernetes | Reproducibility + isolation without cluster overhead |
| ADR-7 | UTC `TIMESTAMP WITH TIME ZONE` everywhere | Local time, naive timestamps | Eliminates DST/TZ ambiguity |

---

## 4.5 Database Design — ER Diagram & Schemas

### 4.5.1 Conceptual ER Diagram (textual)

```
   ┌──────────────────┐
   │    locations     │
   ├──────────────────┤
   │ PK id (UUID)     │
   │    city          │
   │    country       │
   │    latitude      │
   │    longitude     │
   │    timezone      │
   │    elevation     │
   │    created_at    │
   │ UK (city,country)│
   └────────┬─────────┘
            │ 1..*
            │
            │
            ▼
   ┌──────────────────────────┐         ┌──────────────────────┐
   │    weather_readings      │         │    pipeline_runs     │
   ├──────────────────────────┤         ├──────────────────────┤
   │ PK id (UUID)             │         │ PK id (UUID)         │
   │ FK location_id ─────────►│         │    started_at        │
   │ FK pipeline_run_id ──────┼────────►│    finished_at       │
   │    temp_avg_c            │ *..1    │    status            │
   │    temp_min_c            │         │    records_extracted │
   │    temp_max_c            │         │    records_loaded    │
   │    humidity_pct          │         │    records_rejected  │
   │    pressure_hpa          │         │    error_message     │
   │    wind_speed_kmh        │         │    api_request_params│
   │    wind_direction_deg    │         │    created_at        │
   │    wind_direction (enum) │         └──────────────────────┘
   │    wind_gust_kmh         │
   │    rain_tomorrow         │
   │    precipitation_mm      │
   │    weather_description   │
   │    observation_timestamp │
   │    created_at            │
   │ UK (location_id,         │
   │     observation_timestamp)│
   └──────────────────────────┘
```

A rendered ERD lives at `assets/weather_database_erd_visualization_*.png`.

### 4.5.2 Logical Schema — `locations`

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | UUID | PK, default `uuid_generate_v4()` | Surrogate key |
| `city` | VARCHAR(100) | NOT NULL | English city name |
| `country` | VARCHAR(10) | NOT NULL | ISO-3166-1 alpha-2 |
| `latitude` | DECIMAL(9,6) | | WGS-84 |
| `longitude` | DECIMAL(9,6) | | WGS-84 |
| `timezone` | VARCHAR(50) | | IANA name or UTC offset |
| `elevation` | DECIMAL(10,2) | | Metres above sea level |
| `created_at` | TIMESTAMPTZ | DEFAULT `CURRENT_TIMESTAMP` | Audit |
| — | — | UNIQUE `(city, country)` | Natural key for upsert |

### 4.5.3 Logical Schema — `weather_readings`

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | UUID | PK | Surrogate key |
| `location_id` | UUID | FK → `locations.id` | The city this reading belongs to |
| `pipeline_run_id` | UUID | FK → `pipeline_runs.id` | The run that produced this reading |
| `temp_avg_c` | DECIMAL(5,2) | | Average temperature in °C |
| `temp_min_c` | DECIMAL(5,2) | | Minimum temperature in °C |
| `temp_max_c` | DECIMAL(5,2) | | Maximum temperature in °C |
| `humidity_pct` | INTEGER | | Relative humidity, 0–100 |
| `pressure_hpa` | INTEGER | | Sea-level pressure, hPa |
| `wind_speed_kmh` | DECIMAL(5,2) | | Wind speed, km/h |
| `wind_direction_deg` | INTEGER | | Wind direction, 0–359° |
| `wind_direction` | `wind_direction_enum` | | 16-point compass label |
| `wind_gust_kmh` | DECIMAL(5,2) | | Peak gust, km/h |
| `rain_tomorrow` | BOOLEAN | | ML-predicted next-day rain |
| `precipitation_mm` | DECIMAL(7,2) | | Rain or snow last hour, mm |
| `weather_description` | TEXT | | API-provided text description |
| `observation_timestamp` | TIMESTAMPTZ | NOT NULL | UTC, normalized to the hour |
| `created_at` | TIMESTAMPTZ | DEFAULT `CURRENT_TIMESTAMP` | Insertion time |
| — | — | UNIQUE `(location_id, observation_timestamp)` | **The idempotency key** |

### 4.5.4 Logical Schema — `pipeline_runs`

| Column | Type | Constraints |
|--------|------|-------------|
| `id` | UUID | PK |
| `started_at` | TIMESTAMPTZ | DEFAULT now |
| `finished_at` | TIMESTAMPTZ | nullable until run closes |
| `status` | VARCHAR(20) | `'RUNNING'`, `'SUCCESS'`, `'PARTIAL_SUCCESS'`, `'FAILED'` |
| `records_extracted` | INTEGER | DEFAULT 0 |
| `records_loaded` | INTEGER | DEFAULT 0 |
| `records_rejected` | INTEGER | DEFAULT 0 |
| `error_message` | TEXT | nullable |
| `api_request_params` | JSONB | inputs to the run, for replay |
| `created_at` | TIMESTAMPTZ | DEFAULT now |

### 4.5.5 Custom Type

```sql
CREATE TYPE wind_direction_enum AS ENUM (
    'N','NNE','NE','ENE','E','ESE','SE','SSE',
    'S','SSW','SW','WSW','W','WNW','NW','NNW'
);
```

### 4.5.6 Physical Schema Notes

- **Storage engine:** PostgreSQL 15 default (heap + BTree).
- **Indexes implied:** PKs, the unique constraints, and the foreign-key columns (PG creates BTree indexes on `UNIQUE` automatically; FK columns are indexed manually if query patterns warrant).
- **Normalization:** Third Normal Form. `locations` factors out city metadata; `weather_readings` holds only observation-time facts; `pipeline_runs` is independent.
- **Partitioning:** Not required at current scale (10 rows/hour ≈ 87,600 rows/year). When the project grows, monthly range partitioning of `weather_readings` on `observation_timestamp` is the recommended next step.

---

## 4.6 Data Flow Diagrams (DFD) — مخططات تدفق البيانات

### 4.6.1 Context Diagram (DFD Level 0)

```
                      ┌──────────────────────┐
                      │  OpenWeatherMap API  │
                      └──────────┬───────────┘
                                 │  raw weather JSON
                                 ▼
   ┌───────────┐       ┌───────────────────────┐
   │ Scheduler │──────►│   Weather Pipeline    │
   └───────────┘ tick  │       (System)        │
                       └───────────────────────┘
                                 │
                                 │ validated readings + run audit
                                 ▼
                       ┌────────────────────┐
                       │     PostgreSQL     │
                       └────────────────────┘
```

### 4.6.2 DFD Level 1 (process decomposition)

```
   [OpenWeather]
        │ raw JSON
        ▼
   ┌──────────────┐
   │ 1.0 Extract  │
   └──────┬───────┘
          │ raw dict
          ▼
   ┌──────────────────────────┐         ┌─────────────────┐
   │ 2.0 Transform & Enrich   │◄────────│ Historical CSV  │ (data store)
   └──────┬───────────────────┘ training └─────────────────┘
          │ enriched dict
          ▼
   ┌──────────────┐
   │ 3.0 Validate │
   └──────┬───────┘
          │ valid dict (else → reject + count)
          ▼
   ┌──────────────┐         ┌────────────────┐
   │ 4.0 Load     │────────►│ DB: locations  │
   └──────┬───────┘ upsert  └────────────────┘
          │                 ┌──────────────────────┐
          ├────────────────►│ DB: weather_readings │
          │                 └──────────────────────┘
          ▼
   ┌──────────────────────┐
   │ 5.0 Audit (open/close│
   │     pipeline_run)    │──► DB: pipeline_runs
   └──────────────────────┘
```

### 4.6.3 DFD Level 2 — Process 1.0 (Extract)

```
   for each city in TARGET_CITIES:
      ┌────────────────┐
      │ Build URL      │
      └─────┬──────────┘
            ▼
      ┌────────────────┐  HTTP failure?  ┌──────────┐
      │ HTTP GET       │ ─── yes ──────► │ Retry up │
      │ (10s timeout)  │                 │ to 3x    │
      └─────┬──────────┘                 └──────────┘
            │ 200 OK
            ▼
      ┌────────────────┐
      │ Parse JSON →   │
      │ flat dict      │
      └─────┬──────────┘
            │
            ▼
       (output to 2.0)
```

---

## 4.7 Sequence Diagrams — مخططات التسلسل

### 4.7.1 Hourly Pipeline Run

```
Scheduler        Pipeline           Extract           Transform        Load          PG
   │                │                   │                  │             │            │
   │── tick ───────►│                   │                  │             │            │
   │                │──open run────────────────────────────────────────►│ INSERT     │
   │                │◄──── run_id ─────────────────────────────────────│            │
   │                │── train_models()─────────────────────►│             │            │
   │                │                   │                  │             │            │
   │   loop over 10 cities:             │                  │             │            │
   │                │── get_current_weather(city) ─►│      │             │            │
   │                │                   │── HTTP GET ────────────────────►│ OWM API   │
   │                │                   │◄── 200 + JSON ─────────────────│            │
   │                │◄── raw_dict ──────│                  │             │            │
   │                │── transform_reading(raw) ──────────► │             │            │
   │                │◄── enriched_dict ────────────────────│             │            │
   │                │── validate ──┐    │                  │             │            │
   │                │              │ ok                    │             │            │
   │                │              ▼                       │             │            │
   │                │── upsert_location ────────────────────────────────►│ INSERT…UPS │
   │                │◄── location_id ─────────────────────────────────── │            │
   │                │── load_reading ───────────────────────────────────►│ INSERT…NOOP│
   │                │◄── ok ────────────────────────────────────────────│            │
   │                │                   │                  │             │            │
   │                │── close run ─────────────────────────────────────►│ UPDATE     │
   │                │                   │                  │             │            │
   │── log "done" ──│                   │                  │             │            │
```

### 4.7.2 Single-City Failure

```
Pipeline           Extract              PG
   │                  │                  │
   │─ get_current_weather("Foo") ──►     │
   │                  │── HTTP GET ───►  │ (network drops)
   │                  │     timeout      │
   │                  │── retry 1 ───►   │ 503
   │                  │── retry 2 ───►   │ 503
   │                  │── retry 3 ───►   │ 503
   │◄── None ─────────│                  │
   │── records_rejected += 1             │
   │── continue loop                     │
```

---

## 4.8 Activity Diagram — مخطط النشاط

```
        ( Start: scheduler tick )
                │
                ▼
        [ Open pipeline_runs row, status=RUNNING ]
                │
                ▼
        [ Train rain-tomorrow model ]
                │
                ▼
   ┌──── for each city ────────────────────────────┐
   │            │                                  │
   │            ▼                                  │
   │      [ Extract from API ]                     │
   │            │                                  │
   │     ┌──────┴────────┐                         │
   │     │ extract OK?   │                         │
   │     ├── no ──► [ records_rejected++ ]         │
   │     │                 │                       │
   │     └── yes           │                       │
   │            ▼          │                       │
   │      [ Transform & enrich ]                   │
   │            │                                  │
   │            ▼                                  │
   │      [ Validate ranges ]                      │
   │            │                                  │
   │     ┌──────┴────────┐                         │
   │     │ valid?        │                         │
   │     ├── no ──► [ records_rejected++ ]         │
   │     │                                         │
   │     └── yes                                   │
   │            ▼                                  │
   │      [ Upsert location ]                      │
   │            │                                  │
   │            ▼                                  │
   │      [ Insert reading (ON CONFLICT NOOP) ]    │
   │            │                                  │
   │            ▼                                  │
   │      [ records_loaded++ ]                     │
   └──────────────────────────────────────────────┘
                │
                ▼
        [ Determine final status: SUCCESS / PARTIAL_SUCCESS / FAILED ]
                │
                ▼
        [ Close pipeline_runs row ]
                │
                ▼
        [ Log summary ]
                │
                ▼
        ( End )
```

---

## 4.9 State Diagram — حالات الـ pipeline_run

```
   ┌────────────┐  open run    ┌────────────┐
   │  IDLE      │─────────────►│  RUNNING   │
   └────────────┘              └────┬───────┘
                                    │
              all cities loaded?    │
                                    │
                       ┌────────────┼─────────────┐
              yes (rejected = 0)    │       yes (extracted = 0
                       │            │              or DB error)
                       ▼            ▼              ▼
                 ┌──────────┐  ┌────────────────┐  ┌───────────┐
                 │ SUCCESS  │  │PARTIAL_SUCCESS │  │  FAILED   │
                 └────┬─────┘  └─────────┬──────┘  └─────┬─────┘
                      │                  │                │
                      └──── close run ───┴────────────────┘
                                          │
                                          ▼
                                     ┌──────────┐
                                     │ ARCHIVED │ (read-only audit)
                                     └──────────┘
```

---

## 4.10 Class Diagram — مخطط الفئات

```
┌────────────────────────────┐
│      WeatherTransformer    │
├────────────────────────────┤
│ - rain_model: RandomForest │
│ - label_encoder: LabelEnc. │
├────────────────────────────┤
│ + train_models(df)         │
│ + transform_reading(raw)   │
└────────────────────────────┘

┌────────────────────────────┐
│        WeatherLoader       │
├────────────────────────────┤
│ - conn_params: dict        │
├────────────────────────────┤
│ - _get_connection()        │
│ + start_pipeline_run(p)    │
│ + close_pipeline_run(...)  │
│ + upsert_location(...)     │
│ + load_reading(...)        │
└────────────────────────────┘

┌────────────────────────────┐       ┌─────────────────────────┐
│        Pipeline (module)   │──────►│   WeatherTransformer    │
├────────────────────────────┤       └─────────────────────────┘
│ + run_pipeline()           │       ┌─────────────────────────┐
│ + validate_data(d)         │──────►│   WeatherLoader         │
└──────────────┬─────────────┘       └─────────────────────────┘
               │
               ▼
       ┌────────────────────┐
       │  extract module    │
       │ + get_current_     │
       │   weather(city)    │
       │ + get_session()    │
       └────────────────────┘

┌────────────────────────────┐
│   config.settings (module) │
├────────────────────────────┤
│ + DB_CONFIG: dict          │
│ + API_KEY: str             │
│ + API_BASE_URL: str        │
│ + TARGET_CITIES: list[str] │
│ + WEATHER_CSV_PATH: str    │
│ + THRESHOLDS: dict         │
└────────────────────────────┘
```

**Key relationships:**

- `pipeline.run_pipeline()` *uses* `WeatherTransformer`, `WeatherLoader`, and the `extract` module.
- Both `WeatherLoader` and `extract` *depend on* `config.settings`.
- `WeatherTransformer` *depends on* `sklearn.RandomForestClassifier` and `sklearn.preprocessing.LabelEncoder`.

---

## 4.11 UI / UX Considerations

This iteration ships **no GUI** — interaction is via shell + SQL clients. We document the contract that future UIs must respect.

### 4.11.1 CLI as UI

| Surface | Audience | Tone |
|---------|----------|------|
| `docker-compose logs pipeline` | Operator | Structured, human-readable, timestamped |
| `python -m src.pipeline` stdout | Developer | Same, plus `INFO`/`WARN`/`ERROR` levels |
| `psql` queries on `pipeline_runs` | Operator/Analyst | Self-explanatory column names |

### 4.11.2 Future Dashboard (out of scope)

A follow-up Streamlit dashboard, when built, should follow:

- **Color palette:** Anthropic-style neutral whites/greys + a single accent for warnings (red) and successes (green). High WCAG AA contrast.
- **Typography:** System UI font; tabular numerals for the data tables.
- **Layout:** A latest-readings table (left), a 24-h temperature line chart (center), a pipeline-runs status timeline (right).
- **Accessibility:** All charts must have alternative tabular views; colour is never the sole information channel.

---

## 4.12 System Deployment & Integration

### 4.12.1 Technology Stack (recap)

| Tier | Technology |
|------|------------|
| Runtime | Python 3.11 |
| Storage | PostgreSQL 15 |
| Container | Docker + Docker Compose |
| Data libraries | `requests`, `pandas`, `numpy` |
| ML | `scikit-learn` |
| Driver | `psycopg2-binary` |
| Scheduler | `schedule` |
| Config | `python-dotenv` |

### 4.12.2 Deployment Diagram

```
   ┌─────────────────────────────────────────────────────────┐
   │              Host (Linux / macOS / Windows)             │
   │                                                         │
   │   ┌──────────────────────┐     ┌──────────────────────┐ │
   │   │  Container: pipeline │     │  Container: db       │ │
   │   │  ────────────────────│     │  ────────────────────│ │
   │   │  python:3.11-slim    │     │  postgres:15         │ │
   │   │  CMD: scheduler/     │ TCP │  Listens on 5432     │ │
   │   │       cron_job.py    │◄───►│  Volume: pgdata      │ │
   │   │  Volumes:            │ 5432│  Init: schema.sql    │ │
   │   │   - ./logs           │     │                      │ │
   │   │   - ./assets         │     │                      │ │
   │   └──────────┬───────────┘     └──────────┬───────────┘ │
   │              │                            │              │
   │              ▼                            ▼              │
   │   ┌──────────────────────────────────────────────┐     │
   │   │              Docker Network: default           │     │
   │   └──────────────────────────────────────────────┘     │
   │              │                                          │
   │              │ HTTPS:443                                │
   └──────────────┼──────────────────────────────────────────┘
                  ▼
   ┌──────────────────────────────────────┐
   │     OpenWeatherMap API (Internet)    │
   └──────────────────────────────────────┘
```

### 4.12.3 Component Diagram

```
   ┌─────────────────────────┐         ┌─────────────────────┐
   │  ⟨component⟩            │         │  ⟨component⟩        │
   │  Pipeline Service       │ uses    │  PostgreSQL DB      │
   │                         │────────►│                     │
   │  ports: ─               │ 5432    │  ports: 5432        │
   │  uses: requests, sklearn│         │                     │
   └─────────────────────────┘         └─────────────────────┘
              │
              │ uses
              ▼
   ┌─────────────────────────┐
   │  ⟨component⟩            │
   │  OpenWeatherMap API     │
   │  ports: 443             │
   └─────────────────────────┘
```

### 4.12.4 Configuration & Secrets Flow

```
   [Developer's .env]──┐
                       ▼
   ┌─────────────────────────────────┐
   │ docker-compose.yml              │
   │   environment:                  │
   │     WEATHER_API_KEY=${...}      │
   │     DB_HOST=db                  │
   │     ...                         │
   └────────────┬────────────────────┘
                │ injected
                ▼
   ┌─────────────────────────────────┐
   │ pipeline container env vars     │
   └────────────┬────────────────────┘
                │ load_dotenv()
                ▼
   ┌─────────────────────────────────┐
   │ config/settings.py constants    │
   └─────────────────────────────────┘
                │ imported by
                ▼
        extract.py / load.py
```

---

## 4.13 Additional Deliverables

### 4.13.1 API Documentation (External)

The pipeline consumes one external API. Internal endpoints are not yet exposed.

#### OpenWeatherMap — Current Weather

| Item | Value |
|------|-------|
| Method | GET |
| URL | `https://api.openweathermap.org/data/2.5/weather` |
| Auth | Query string `appid=<API_KEY>` |
| Required params | `q` (city), `appid`, `units=metric` |
| Success status | 200 |
| Sample response (truncated) | `{ "name": "Cairo", "sys":{"country":"EG"}, "main":{"temp":24.5, "humidity":58, "pressure":1014, "temp_min":22, "temp_max":27}, "wind":{"speed":3.6,"deg":50}, "weather":[{"description":"clear sky"}] }` |
| Rate limit (free tier) | 60 calls/min, 1,000,000 calls/month |

A normalized internal contract — the dict returned by `extract.get_current_weather()` — is documented inline in that module's docstring.

### 4.13.2 Testing & Validation Plan

| Layer | Tool | Coverage target |
|-------|------|-----------------|
| Unit | `unittest` | All pure transformations in `transform.py` |
| Integration | (manual) `docker-compose up` smoke test | 1 full run end-to-end |
| Schema | (manual) `psql -f database/schema.sql` | DDL applies cleanly on fresh DB |
| Data quality | Range checks in `validate_data()` | Every reading inserted |
| Acceptance | Live demo (Week 5) | All FRs from §3.4 demonstrated |

User Acceptance Testing scenarios:

1. Fresh `docker-compose up --build` succeeds and inserts data within 2 minutes.
2. Re-running the pipeline does not duplicate any rows.
3. Setting `WEATHER_API_KEY=""` produces a clear ERROR, no crash.
4. Disconnecting the network causes the run to be marked `FAILED` in `pipeline_runs`.
5. SQL queries from §11 of the README all return reasonable results.

### 4.13.3 Deployment Strategy

| Stage | Trigger | Action |
|-------|---------|--------|
| Local dev | Push to feature branch | Developer runs `docker-compose up --build` |
| Code review | Open PR | At least one reviewer approves; CI runs unit tests |
| Merge | PR approved | Merge to `main`; tag if a milestone |
| (Future) Staging | Tag `vX.Y.Z-rc` | GitHub Actions deploys to a staging VM |
| (Future) Production | Tag `vX.Y.Z` | GitHub Actions deploys to production VM |

For this iteration "deployment" means: a team member runs `docker-compose up --build` on their own machine. A future iteration would add a CI pipeline (GitHub Actions: lint → test → build → push image to GHCR → deploy via SSH).

---

## 4.14 Summary

| Concern | Design choice |
|---------|---------------|
| Architecture | Pipes & Filters within a layered application |
| Storage | PostgreSQL 15 with three normalized tables |
| Idempotency | DB-level unique constraint + `ON CONFLICT` |
| Orchestration | In-process `schedule` library |
| Observability | Structured logs + `pipeline_runs` audit table |
| Deployment | Two-container `docker-compose.yml` |
| Security | All secrets via `.env`; least-privilege DB user |
| Extensibility | New cities → 1-line config change; new sources → swap `extract.py` |

---

*End of System Analysis & Design document.*
