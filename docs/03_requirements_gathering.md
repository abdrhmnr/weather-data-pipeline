# 3. Requirements Gathering

> **Project:** Weather Data Pipeline
> **Track:** DEPI Graduation Project — First Submission (Documentation)
> **Last Updated:** April 2026

This document captures *who* the system serves, *what* they need, and *how* the system must behave — independently of how it is implemented.

---

## 3.1 Stakeholder Analysis — تحليل الأطراف المعنية

### 3.1.1 Stakeholder Map

| # | Stakeholder | Internal / External | Influence | Interest | Engagement strategy |
|---|-------------|:-------------------:|:---------:|:--------:|---------------------|
| 1 | Project team (6 members) | Internal | High | High | Daily collaboration, weekly sync. |
| 2 | Project supervisor / lecturer | External | High | High | Milestone reviews, formal LMS submissions. |
| 3 | Data analysts (downstream) | Internal | Medium | High | Provide query examples + ERD. |
| 4 | DevOps / infra team (future) | Internal | Medium | Medium | Provide Dockerfile + run-book in README. |
| 5 | API providers (OpenWeatherMap, Open-Meteo) | External | Low | Low | Respect rate limits + ToS. |
| 6 | End-user citizens (future demo audience) | External | Low | Medium | Clear demo, public-facing dashboard (future). |
| 7 | DEPI program admins | External | Medium | Medium | Submit deliverables on time on the LMS. |

### 3.1.2 Key Stakeholders & Needs

| Stakeholder | Primary needs |
|-------------|---------------|
| **Project supervisor** | Reviewable, well-documented deliverables; on-time milestones; demonstrable end-to-end functionality. |
| **Project team** | Clear ownership, modular code, no merge conflicts, easy local setup. |
| **Data analysts** | Reliable, query-ready PostgreSQL schema; documented columns; idempotent loads. |
| **Future DevOps** | One-command deployment; sensible logging; secrets in `.env`. |

---

## 3.2 User Stories — قصص المستخدم

We use the standard format: *As a `<role>`, I want `<goal>` so that `<benefit>`.*

### 3.2.1 Epic A — Data ingestion

| ID | Story | Priority |
|----|-------|:--------:|
| US-A1 | As a **data engineer**, I want the pipeline to fetch current weather for all 10 target cities every hour so that the database always contains fresh observations. | Must |
| US-A2 | As a **data engineer**, I want failed API calls to be retried up to 3 times so that transient network issues don't cause data gaps. | Must |
| US-A3 | As a **data engineer**, I want a single bad city to not abort the whole run so that 9 cities of good data still get ingested. | Must |
| US-A4 | As a **data engineer**, I want all secrets to come from `.env` so that no credential is ever committed to GitHub. | Must |

### 3.2.2 Epic B — Data quality & enrichment

| ID | Story | Priority |
|----|-------|:--------:|
| US-B1 | As a **data analyst**, I want temperatures, humidities, and pressures outside physical ranges to be rejected so that obviously bad readings never reach the warehouse. | Must |
| US-B2 | As a **data analyst**, I want wind speed in km/h (not m/s) so that I don't have to convert in every query. | Should |
| US-B3 | As a **data analyst**, I want wind direction as a 16-point compass label (`N`, `NNE`, …) so that I can group and filter without arithmetic. | Should |
| US-B4 | As a **product manager**, I want a `rain_tomorrow` boolean for every reading so that downstream apps can surface a simple yes/no forecast. | Could |

### 3.2.3 Epic C — Storage & integrity

| ID | Story | Priority |
|----|-------|:--------:|
| US-C1 | As a **DBA**, I want each `(city, observation_time)` to appear at most once so that running the pipeline twice doesn't duplicate rows. | Must |
| US-C2 | As a **DBA**, I want all timestamps in UTC with explicit time-zone metadata so that reads from any client are unambiguous. | Must |
| US-C3 | As a **data analyst**, I want every reading to point to its `pipeline_run_id` so that I can trace any row back to the run that produced it. | Should |

### 3.2.4 Epic D — Operations

| ID | Story | Priority |
|----|-------|:--------:|
| US-D1 | As a **DevOps engineer**, I want to start the entire stack with a single `docker-compose up` so that any machine with Docker installed can run it. | Must |
| US-D2 | As a **DevOps engineer**, I want the schema applied automatically on first DB start so that I don't have to remember manual setup steps. | Must |
| US-D3 | As an **on-call engineer**, I want every run logged with its status, counts, and any error so that I can diagnose failures from the database alone. | Must |
| US-D4 | As an **on-call engineer**, I want hourly logs persisted to disk so that I can investigate after a container restart. | Should |

### 3.2.5 Epic E — Documentation & demo

| ID | Story | Priority |
|----|-------|:--------:|
| US-E1 | As a **new contributor**, I want a README that gets me from a fresh clone to a running stack in under 5 minutes. | Must |
| US-E2 | As a **lecturer**, I want a single-page ERD that summarises the schema so that I can review the design at a glance. | Must |
| US-E3 | As a **lecturer**, I want a 5-minute live demo at the end of the project so that I can verify the system end-to-end. | Must |

---

## 3.3 Use Cases — حالات الاستخدام

### 3.3.1 Actors

- **Scheduler** (system actor) — triggers the pipeline at a fixed cadence.
- **Data Engineer** (human) — runs ad-hoc pipeline executions, monitors, fixes issues.
- **Data Analyst** (human) — queries the warehouse via SQL.
- **OpenWeatherMap API** (external system) — provides weather data on request.
- **PostgreSQL** (system actor) — stores observations and audit records.

### 3.3.2 Use Case Diagram (textual)

```
              ┌────────────────────────────────────────────┐
              │       Weather Data Pipeline System         │
              │                                            │
   Scheduler ─┼─→ (UC-1: Run hourly pipeline)              │
              │         │                                  │
              │         ├─→ (UC-2: Extract weather)        │──→ OpenWeatherMap
              │         ├─→ (UC-3: Transform & validate)   │
              │         └─→ (UC-4: Load into DB)           │──→ PostgreSQL
              │                                            │
   Data Eng. ─┼─→ (UC-5: Run pipeline manually)            │
              │   (UC-6: Inspect run history)              │──→ PostgreSQL
              │                                            │
   Analyst   ─┼─→ (UC-7: Query latest readings)            │──→ PostgreSQL
              │   (UC-8: Query rain forecast)              │
              └────────────────────────────────────────────┘
```

### 3.3.3 Detailed Use Cases

#### UC-1 · Run hourly pipeline

| Field | Value |
|-------|-------|
| **Actor** | Scheduler |
| **Goal** | Refresh all weather observations every hour |
| **Trigger** | The clock reaches `:00` of any hour |
| **Pre-conditions** | Container is running; DB is reachable; `.env` is loaded |
| **Main flow** | 1. Scheduler calls `run_pipeline()`. 2. A new `pipeline_runs` row is opened with status `RUNNING`. 3. Model is trained from the historical CSV. 4. For each city: extract → transform → validate → load. 5. Run row is closed with the final status and counts. |
| **Alternate flow A1** | If the model CSV is missing → predictions are disabled, run continues, status becomes `PARTIAL_SUCCESS`. |
| **Alternate flow A2** | If a single city fails extraction → `records_rejected` is incremented, loop continues. |
| **Exception E1** | DB unreachable → run row cannot be opened → ERROR logged, scheduler retries on next tick. |
| **Post-conditions** | Up to 10 rows appended to `weather_readings`; one row appended to `pipeline_runs`. |

#### UC-2 · Extract weather

| Field | Value |
|-------|-------|
| **Actor** | Pipeline (system) |
| **Goal** | Retrieve the latest weather snapshot for one city |
| **Pre-conditions** | `WEATHER_API_KEY` is set |
| **Main flow** | 1. Build URL with city + key + `units=metric`. 2. `GET` with 10 s timeout. 3. Parse the response into a flat dict. 4. Return the dict. |
| **Alternate flow** | On 5xx error: retry up to 3 times with exponential backoff. |
| **Exception** | On 4xx or final 5xx: log a WARNING/ERROR, return `None`. |

#### UC-3 · Transform & validate

| Field | Value |
|-------|-------|
| **Actor** | Pipeline (system) |
| **Goal** | Convert raw API data into schema-ready records |
| **Pre-conditions** | Raw dict from UC-2 |
| **Main flow** | 1. Convert wind speed/gust m/s → km/h. 2. Map degrees → 16-point compass. 3. Predict `rain_tomorrow`. 4. Apply range checks. 5. Return the enriched dict (or `None` if invalid). |

#### UC-4 · Load into DB

| Field | Value |
|-------|-------|
| **Actor** | Pipeline (system) |
| **Goal** | Persist a validated reading |
| **Pre-conditions** | DB reachable; valid record |
| **Main flow** | 1. Upsert into `locations` (`ON CONFLICT (city, country)`). 2. Insert into `weather_readings` (`ON CONFLICT DO NOTHING`). 3. Commit. |
| **Post-conditions** | 0 or 1 new row in `weather_readings`. |

#### UC-5 · Run pipeline manually
Trigger: data engineer runs `python -m src.pipeline`. Same main flow as UC-1 but without the scheduler.

#### UC-6 · Inspect run history
Actor: data engineer. Goal: see why the most recent run failed.
Main flow: `SELECT * FROM pipeline_runs ORDER BY started_at DESC LIMIT 20;`.

#### UC-7 · Query latest readings
Actor: analyst. Main flow: SQL join of `weather_readings` and `locations` filtered to the latest `observation_timestamp` per city.

#### UC-8 · Query rain forecast
Actor: analyst. Main flow: `SELECT … WHERE rain_tomorrow = TRUE`.

---

## 3.4 Functional Requirements — المتطلبات الوظيفية

Each requirement is uniquely identified `FR-NN` and is **testable**.

| ID | Requirement | Acceptance criterion |
|----|-------------|----------------------|
| **FR-01** | The system shall extract current weather for the 10 cities listed in `config/settings.py` (Cairo, Riyadh, Dubai, Baghdad, Beirut, Amman, Kuwait, Doha, Casablanca, Tunis). | Running the pipeline once results in up to 10 rows in `weather_readings` with distinct `location_id`. |
| **FR-02** | The system shall retry transient API failures (HTTP 500, 502, 503, 504) up to 3 times with exponential backoff. | Mock-injected 503 errors are recovered within 3 attempts; the 4th attempt logs an ERROR and skips the city. |
| **FR-03** | The system shall reject a reading whose `temp_avg_c` is outside `[-50, 60]°C`. | A unit test passes a synthetic reading with `temp_avg_c = 100` and asserts that `validate_data()` returns `False`. |
| **FR-04** | The system shall reject a reading whose `humidity_pct` is outside `[0, 100]%`. | Symmetric unit test with `humidity_pct = 150`. |
| **FR-05** | The system shall convert wind speed and gust from m/s to km/h with 2-decimal precision. | A reading with `wind_speed_ms = 10` produces `wind_speed_kmh = 36.0`. |
| **FR-06** | The system shall map `wind_deg` to one of 16 compass directions. | `wind_deg = 0 → 'N'`; `wind_deg = 90 → 'E'`; `wind_deg = 180 → 'S'`. |
| **FR-07** | The system shall produce a `rain_tomorrow` BOOLEAN for every reading when the historical CSV is available. | `transform_reading()` returns a dict whose `rain_tomorrow` field is `True` or `False`. |
| **FR-08** | The system shall upsert into the `locations` table on `(city, country)` conflict. | Re-running the pipeline does not increase `COUNT(*) FROM locations`. |
| **FR-09** | The system shall insert into `weather_readings` with `ON CONFLICT (location_id, observation_timestamp) DO NOTHING`. | Running the pipeline twice in the same hour does not duplicate `weather_readings` rows. |
| **FR-10** | The system shall record every run in `pipeline_runs` with status, start/end time, and per-stage counts. | After a run, exactly one new row exists in `pipeline_runs` with `status IN ('SUCCESS','PARTIAL_SUCCESS','FAILED')`. |
| **FR-11** | The system shall start the pipeline once at container startup, then every hour at `:00`. | After `docker-compose up`, `pipeline_runs` shows the first row immediately and a new row at every subsequent hour. |
| **FR-12** | The system shall load all secrets from `.env`. | Running with an empty `WEATHER_API_KEY` env var causes `extract.py` to log `ERROR` and return `None`. |
| **FR-13** | The system shall apply `database/schema.sql` automatically on first PostgreSQL start. | A fresh `docker-compose up --build` from an empty volume creates the three tables without manual `psql`. |
| **FR-14** | The system shall provide a unit-test suite covering `transform_reading()` logic. | `python -m unittest discover -s tests` passes with at least 2 test cases. |
| **FR-15** | The system shall log every pipeline event to both stdout and `logs/scheduler.log`. | `docker-compose logs pipeline` and `cat logs/scheduler.log` both contain the same INFO/ERROR entries. |

---

## 3.5 Non-Functional Requirements — المتطلبات غير الوظيفية

Categorized by ISO/IEC 25010 quality attributes.

### 3.5.1 Performance

| ID | Requirement | Target |
|----|-------------|--------|
| NFR-P1 | Pipeline end-to-end latency | ≤ 60 s for 10 cities |
| NFR-P2 | Mean API call latency | ≤ 2 s per city |
| NFR-P3 | DB write latency | ≤ 100 ms per row |
| NFR-P4 | Container cold-start | ≤ 30 s |

### 3.5.2 Reliability & Availability

| ID | Requirement | Target |
|----|-------------|--------|
| NFR-R1 | Pipeline success rate (rolling 7d) | ≥ 99% |
| NFR-R2 | DB uptime within container lifetime | ≥ 99.5% |
| NFR-R3 | Single-city failure isolation | Other cities keep loading |
| NFR-R4 | Idempotency under repeat execution | Identical DB state |

### 3.5.3 Security

| ID | Requirement |
|----|-------------|
| NFR-S1 | All credentials are loaded from `.env` and never logged. |
| NFR-S2 | `.env` is listed in `.gitignore` and rejected by pre-commit. |
| NFR-S3 | The DB user used by the pipeline has only `INSERT`, `UPDATE`, `SELECT` privileges (no `DROP`). |
| NFR-S4 | The Docker image runs as a non-root user when feasible. |
| NFR-S5 | The PostgreSQL container is not exposed publicly outside the Docker network in production deployments. |

### 3.5.4 Usability

| ID | Requirement |
|----|-------------|
| NFR-U1 | A new contributor can clone, configure, and run the project in ≤ 5 minutes following the README. |
| NFR-U2 | All configuration options are documented in `.env.example` with inline comments. |
| NFR-U3 | Log messages are human-readable and include a timestamp, level, and contextual identifier. |

### 3.5.5 Maintainability

| ID | Requirement |
|----|-------------|
| NFR-M1 | Code is split into clearly-named modules: `extract`, `transform`, `load`, `pipeline`, `scheduler`. |
| NFR-M2 | All public functions have a docstring. |
| NFR-M3 | The schema is the single source of truth — runtime code does not silently assume columns that don't exist in `schema.sql`. |
| NFR-M4 | Adding a new city requires editing one constant in `config/settings.py`. |

### 3.5.6 Portability

| ID | Requirement |
|----|-------------|
| NFR-PT1 | The project runs on Linux, macOS, and Windows hosts via Docker Desktop. |
| NFR-PT2 | The Python version is pinned (3.11) and the Postgres image tag is pinned (`postgres:15`). |

### 3.5.7 Compliance

| ID | Requirement |
|----|-------------|
| NFR-C1 | API usage stays within the free tier of OpenWeatherMap (≤ 60 calls/min, ≤ 1,000,000 calls/month). |
| NFR-C2 | The repository contains a `LICENSE` file appropriate for an academic project. |

---

## 3.6 Constraints & Assumptions — قيود وافتراضات

### 3.6.1 Constraints

- The free tier of OpenWeatherMap caps us at 60 calls/min — comfortably above 10 cities/hour.
- The team has 5 weeks total; deferred features (dashboard, REST API) are explicitly out of scope.
- The deployment target is a single host with Docker Desktop installed; no cloud infrastructure is provisioned.
- All code must run on Python 3.11 + PostgreSQL 15.

### 3.6.2 Assumptions

- The historical CSV in `assets/weather.csv` is the only training data we have access to.
- Internet access is available wherever the pipeline runs.
- Hourly granularity is sufficient — we do not need sub-hour resolution.
- The 10 target cities will not change during the project's life-cycle.

---

## 3.7 Traceability Matrix — مصفوفة التتبع

This matrix links functional requirements back to user stories and forward to the test cases that verify them.

| FR | Source US | Verifying test |
|----|-----------|----------------|
| FR-01 | US-A1 | Manual run + `SELECT COUNT(*)` |
| FR-02 | US-A2 | (future) mock-based unit test |
| FR-03 | US-B1 | `tests/test_pipeline.py` (extension) |
| FR-04 | US-B1 | `tests/test_pipeline.py` (extension) |
| FR-05 | US-B2 | `tests/test_pipeline.py::test_unit_conversion` |
| FR-06 | US-B3 | `tests/test_pipeline.py::test_unit_conversion` |
| FR-07 | US-B4 | `tests/test_pipeline.py::test_rain_boolean_type` |
| FR-08 | US-C1 | Manual: run twice, assert no growth in `locations` |
| FR-09 | US-C1 | Manual: run twice, assert no growth in `weather_readings` |
| FR-10 | US-C3, US-D3 | `SELECT * FROM pipeline_runs` |
| FR-11 | US-A1 | `docker-compose logs` over a 24h window |
| FR-12 | US-A4 | Manual: unset env, observe ERROR log |
| FR-13 | US-D2 | `docker-compose down -v && docker-compose up --build` |
| FR-14 | US-E1 | `python -m unittest` |
| FR-15 | US-D4 | `tail -f logs/scheduler.log` while pipeline runs |

---

*End of Requirements Gathering document.*
