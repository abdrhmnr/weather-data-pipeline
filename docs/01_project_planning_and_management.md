# 1. Project Planning & Management

> **Project:** Weather Data Pipeline
> **Track:** DEPI Graduation Project — First Submission (Documentation)
> **Authors:** Project Team (6 members)
> **Last Updated:** April 2026

---

## 1.1 Project Proposal — مقترح المشروع

### 1.1.1 Title
**Weather Data Pipeline with Python and PostgreSQL**

### 1.1.2 Background — الخلفية
Weather data is consumed by a wide range of applications: agriculture, logistics, energy planning, public health, and travel. Public weather APIs (OpenWeatherMap, Open-Meteo) expose this data, but turning it into a usable analytical asset requires automation: scheduled extraction, cleaning, deduplication, and structured storage. Manual daily collection across multiple cities is time-consuming and prone to omission and error.

### 1.1.3 Problem Statement — المشكلة
Operations teams that need consistent weather observations across multiple Arab capitals currently rely on point-in-time queries, with no historical record kept locally and no quality assurance applied to the data. There is no audit trail of what was collected, when, or whether the data was complete. Analysts cannot reliably answer questions like "what was the temperature in Cairo at 09:00 last Tuesday?" without re-querying an external API — and even then, free APIs often do not expose deep historical windows.

### 1.1.4 Objectives — الأهداف
1. **Automate** the hourly collection of current weather observations for 10 major Arab cities.
2. **Standardize** the schema (units, naming, time zones) so the data is analyst-ready.
3. **Persist** every observation in a relational database with deduplication guarantees.
4. **Augment** raw observations with a `rain_tomorrow` ML prediction.
5. **Monitor** every run with a structured audit table that records success/failure and counts.
6. **Containerize** the entire stack so any team member can run it with one command.

### 1.1.5 Scope — النطاق

**In scope:**

- Extraction from a single primary weather API (OpenWeatherMap), with the architecture allowing a secondary source (Open-Meteo) to be plugged in.
- 10 Arab cities: Cairo, Riyadh, Dubai, Baghdad, Beirut, Amman, Kuwait, Doha, Casablanca, Tunis.
- Current-conditions endpoint only (not forecasts beyond the trained model).
- PostgreSQL 15 as the storage layer.
- Docker Compose deployment on a single host.
- A `RandomForestClassifier` rain-tomorrow model trained on the historical CSV in `assets/`.
- Hourly scheduled execution (`schedule` library, in-process scheduler).

**Out of scope (for this iteration):**

- A user-facing web dashboard.
- Real-time streaming (Kafka, Kinesis).
- Multi-region / multi-host deployment, Kubernetes, autoscaling.
- Forecasting beyond the next-day rain probability.
- A REST API exposing the database to external consumers.
- Mobile apps.

### 1.1.6 Expected Deliverables
- A reproducible source repository on GitHub.
- A running PostgreSQL database populated with at least one week of observations.
- All four documentation files (this folder).
- Final presentation slides + a recorded live demo.

---

## 1.2 Project Plan — خطة المشروع

### 1.2.1 Timeline (5 weeks, 1 week per milestone)

| Week | Milestone | Focus | Deliverable |
|------|-----------|-------|-------------|
| 1 | M1 — Data collection & cleaning | Refactor notebook → modular code | `extract.py`, `cleaner` logic, raw JSON in `data/raw/` |
| 2 | M2 — Database & ETL | Schema + loader | `schema.sql`, `load.py`, `pipeline.py` |
| 3 | M3 — Docker deployment | Containerize the stack | `Dockerfile`, `docker-compose.yml` |
| 4 | M4 — Scheduling & monitoring | Automation + observability | `cron_job.py`, `pipeline_runs` audit |
| 5 | M5 — Documentation & demo | README, ERD, presentation | `docs/`, slides, live demo |

### 1.2.2 Gantt Chart — مخطط جانت (text rendering)

```
Task                          | W1 | W2 | W3 | W4 | W5 |
------------------------------+----+----+----+----+----+
Project planning              | XX |    |    |    |    |
Literature review             | XX | XX |    |    |    |
Requirements gathering        | XX | XX |    |    |    |
System analysis & design      |    | XX | XX |    |    |
M1: API client (extract.py)   | XX | x  |    |    |    |
M2: Cleaner (transform.py)    | XX | x  |    |    |    |
M3: Schema (schema.sql)       | x  | XX | x  |    |    |
M4: Loader (load.py)          |    | XX | x  |    |    |
M5: Docker                    |    |  x | XX |    |    |
M6: Scheduler                 |    |    | x  | XX |    |
Logging & monitoring          |    |    | x  | XX |    |
Documentation (README, docs/) |  x |  x |  x |  x | XX |
ERD diagram                   |  x | XX |    |    |    |
Tests (unit)                  |    |  x |  x | XX |    |
Code review                   |    |    |    |  x | XX |
Final presentation + demo     |    |    |    |    | XX |
```
*Legend: `XX` = primary work week, `x` = supporting / partial work*

### 1.2.3 Milestones (acceptance criteria — معايير القبول)

| ID | Milestone | Definition of Done |
|----|-----------|--------------------|
| M1 | Data collection | `python -m src.extract` returns valid JSON for all 10 cities; failures are logged and skipped, not crashing the run. |
| M2 | DB & ETL | `psql -f database/schema.sql` runs cleanly; `python -m src.pipeline` loads data; running it twice does **not** duplicate rows. |
| M3 | Docker | `docker-compose down -v && docker-compose up --build` starts PostgreSQL, creates the schema, runs the pipeline, and inserts data — with no manual steps. |
| M4 | Scheduling | The scheduler runs without intervention for ≥ 24 h; `pipeline_runs` shows ≥ 24 SUCCESS rows; `logs/scheduler.log` contains entries for every run. |
| M5 | Documentation & demo | README walks a stranger through running the project end-to-end; ERD is exported as PNG; a 5-minute live demo runs without errors. |

---

## 1.3 Task Assignment & Roles — توزيع المهام والأدوار

### 1.3.1 Role Definitions

| Role | Responsibilities |
|------|------------------|
| **Project Lead** | Coordinates milestones, owns the GitHub repo, submits to LMS, runs the weekly stand-up. |
| **API & Data Collection Lead (M1)** | Builds `src/extract.py`, manages API keys via `.env`, handles retries and error reporting. |
| **Data Cleaner & EDA Lead (M2)** | Builds `src/transform.py`, defines validation thresholds, produces an EDA report on the historical CSV. |
| **Database Architect (M3)** | Designs the schema, writes `database/schema.sql`, produces the ERD diagram, owns naming conventions. |
| **ETL Engineer (M4)** | Writes `src/load.py` and `src/pipeline.py`, implements upserts, owns transactional correctness. |
| **DevOps & Scheduling (M5)** | Writes the Dockerfile and `docker-compose.yml`, the scheduler, and the deployment instructions. |
| **Monitoring & Docs (M6)** | Defines the logging strategy, writes the README and the `docs/` folder, prepares the final slides. |

### 1.3.2 Member Assignments

| # | Member | Primary Module | Lead Week(s) | Support Week(s) | Pair |
|---|--------|----------------|--------------|-----------------|------|
| 1 | **Abdrhmn** (Project Lead) | M1 — `src/extract.py` | W1 | W2 | Esraa |
| 2 | **Aya** | M2 — `src/transform.py` (cleaning) | W1 | W2, W5 | Sofia |
| 3 | **Rana** | M3 — `database/schema.sql` | W2 | W3, W5 | Suzette |
| 4 | **Suzette** | M4 — `src/load.py`, `src/pipeline.py` | W2 | W3, W4 | Rana |
| 5 | **Esraa** | M5 — `Dockerfile`, `scheduler/cron_job.py` | W3, W4 | W5 | Abdrhmn |
| 6 | **Sofia** | M6 — Logging, README, docs | W4, W5 | W1–W3 (observe) | Aya |

### 1.3.3 RACI Matrix (high level)

Legend: **R** = Responsible, **A** = Accountable, **C** = Consulted, **I** = Informed

| Activity | Abdrhmn | Aya | Rana | Suzette | Esraa | Sofia |
|----------|:-------:|:---:|:----:|:-------:|:-----:|:-----:|
| API integration | A/R | C | I | I | C | I |
| Data cleaning | C | A/R | I | C | I | C |
| DB schema | I | C | A/R | C | I | I |
| ETL loader | I | I | C | A/R | I | C |
| Containerization | C | I | C | C | A/R | I |
| Scheduling | I | I | I | C | A/R | C |
| Logging | C | C | I | C | C | A/R |
| Documentation | C | C | C | C | C | A/R |
| Project coordination | A/R | I | I | I | I | C |

---

## 1.4 Risk Assessment & Mitigation Plan — تقييم المخاطر

| # | Risk | Category | Likelihood | Impact | Risk Score | Mitigation |
|---|------|----------|:----------:|:------:|:---------:|------------|
| R1 | OpenWeatherMap API key revoked or rate-limited | External | Medium | High | 9 | Add Open-Meteo (no-key) as a secondary source; cache last successful response per city. |
| R2 | A team member is unavailable for ≥ 1 week | Resource | Medium | High | 9 | Pair-programming model; every module has a backup owner (RACI matrix). |
| R3 | DB schema changes break the loader mid-project | Technical | Medium | Medium | 6 | Schema PRs require a review by the ETL Engineer; CI smoke test re-applies schema on each push. |
| R4 | Docker images fail to build on Windows hosts | Technical | Medium | Medium | 6 | Document `wsl2` setup in README; pin Python and Postgres image tags. |
| R5 | Historical CSV has unexpected NaNs / wrong types | Data | High | Medium | 8 | Drop nulls + duplicates; add explicit dtype enforcement; report stats before/after cleaning. |
| R6 | `.env` accidentally committed to GitHub | Security | Low | Critical | 8 | `.gitignore` lists `.env`; secrets scanning enabled on the repo. |
| R7 | Network outage on demo day | External | Low | High | 5 | Pre-record a backup demo video; carry an offline-cached DB snapshot. |
| R8 | Time-zone bugs (UTC vs local) corrupt timestamps | Technical | Medium | Medium | 6 | Store everything in UTC (`TIMESTAMP WITH TIME ZONE`); convert at presentation layer only. |
| R9 | Pipeline runs overlap and create deadlocks | Technical | Low | Medium | 4 | Single in-process scheduler; idempotent upserts; row-level locks via PG defaults. |
| R10 | Final demo discovers a regression late | Process | Medium | Medium | 6 | Code review week (W5); end-to-end smoke test in the Definition-of-Done for every milestone. |

*Likelihood and Impact scored 1–3; Risk Score = Likelihood × Impact (max 9).*

---

## 1.5 KPIs (Key Performance Indicators) — مؤشرات الأداء

### 1.5.1 Pipeline KPIs (production metrics)

| KPI | Target | How measured |
|-----|--------|--------------|
| **Pipeline success rate** | ≥ 99% per rolling 7-day window | `SELECT COUNT(*) FILTER (WHERE status='SUCCESS')::FLOAT / COUNT(*) FROM pipeline_runs WHERE started_at > NOW() - INTERVAL '7 days'` |
| **End-to-end latency** | ≤ 60 seconds per run | `EXTRACT(EPOCH FROM (finished_at - started_at))` from `pipeline_runs` |
| **Data freshness** | Most recent reading per city ≤ 90 minutes old | `MAX(observation_timestamp)` per city compared to `NOW()` |
| **Coverage** | ≥ 95% of cities loaded per run | `records_loaded / 10` from `pipeline_runs` |
| **Validation rejection rate** | ≤ 2% of extracted rows | `records_rejected / records_extracted` |
| **API failure rate** | ≤ 1% over 7 days | Count of `WARNING`/`ERROR` log entries from `extract.py` |
| **DB uptime** | ≥ 99.5% | Health-check pings via `docker-compose` healthcheck |
| **Storage growth** | Predictable: ≤ 0.5 MB / week | `pg_total_relation_size('weather_readings')` weekly delta |

### 1.5.2 Project KPIs (delivery metrics)

| KPI | Target |
|-----|--------|
| Milestones delivered on time | 5 / 5 |
| Code review coverage | 100% of merged PRs reviewed by ≥ 1 non-author |
| Test coverage of `transform` logic | ≥ 80% line coverage |
| Mean time-to-review for a PR | ≤ 24 h |
| Documentation completeness | 4/4 docs files + README |
| Demo: zero unhandled errors | Pass / Fail |

### 1.5.3 ML Model KPIs (rain-tomorrow predictor)

| KPI | Target |
|-----|--------|
| Accuracy on hold-out set | ≥ 80% |
| Precision (rain class) | ≥ 70% |
| Recall (rain class) | ≥ 70% |
| Inference time per city | ≤ 50 ms |

---

## 1.6 Communication Plan — خطة التواصل

| Channel | Purpose | Cadence |
|---------|---------|---------|
| GitHub Issues | Bugs, feature requests, blockers | As needed |
| Pull Requests | Code review and approval | Per merge to `main` |
| Team WhatsApp/Discord | Quick questions, daily standup | Daily |
| Weekly sync (video) | Progress vs Gantt, unblockers | Once per week, fixed time |
| LMS submissions | Formal milestone deliverables | Per the schedule on page 1 of the brief |

---

## 1.7 Tools & Conventions — الأدوات والمعايير

| Concern | Tool / convention |
|---------|-------------------|
| Source control | Git + GitHub, feature-branch workflow (`feat/*`, `fix/*`, `docs/*`) |
| Branch protection | `main` requires 1 review and a passing CI build |
| Commit style | Imperative mood, short subject (≤ 72 chars): `add api retry logic`, not `added retries` |
| Code style | PEP-8, snake_case, type hints where reasonable |
| Issue tracking | GitHub Issues with labels: `bug`, `enhancement`, `docs`, `infra` |
| Diagramming | draw.io / dbdiagram.io, exported as PNG into `assets/` |
| Documentation | Markdown in `docs/`, mirrored in the README |

---

## 1.8 Definition of Done — تعريف الإنجاز

A milestone is **done** only when **all** of the following are true:

- [ ] Code is merged to `main` via a reviewed Pull Request.
- [ ] All new code is covered by at least one unit test (where applicable).
- [ ] The relevant section of the README has been updated.
- [ ] `docker-compose up --build` still starts cleanly from an empty volume.
- [ ] No secrets, API keys, or local paths are committed.
- [ ] The corresponding row in the Gantt chart is checked off in the weekly sync.

---

*End of Project Planning & Management document.*
