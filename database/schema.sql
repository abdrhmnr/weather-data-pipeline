-- Weather Data Pipeline Schema
-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
-- Enum for 16-point wind directions
CREATE TYPE wind_direction_enum AS ENUM (
    'N',
    'NNE',
    'NE',
    'ENE',
    'E',
    'ESE',
    'SE',
    'SSE',
    'S',
    'SSW',
    'SW',
    'WSW',
    'W',
    'WNW',
    'NW',
    'NNW'
);
-- Table: locations
CREATE TABLE IF NOT EXISTS locations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    city VARCHAR(100) NOT NULL,
    country VARCHAR(10) NOT NULL,
    latitude DECIMAL(9, 6),
    longitude DECIMAL(9, 6),
    timezone VARCHAR(50),
    elevation DECIMAL(10, 2),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(city, country)
);
-- Table: pipeline_runs
CREATE TABLE IF NOT EXISTS pipeline_runs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    started_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    finished_at TIMESTAMP WITH TIME ZONE,
    status VARCHAR(20) DEFAULT 'RUNNING' CHECK (
        status IN ('RUNNING', 'SUCCESS', 'FAILED', 'PARTIAL')
    ),
    records_extracted INTEGER DEFAULT 0,
    records_loaded INTEGER DEFAULT 0,
    records_rejected INTEGER DEFAULT 0,
    error_message TEXT,
    api_request_params JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
-- Table: weather_readings
CREATE TABLE IF NOT EXISTS weather_readings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    location_id UUID NOT NULL REFERENCES locations(id),
    -- عدلته بقيمة not null
    pipeline_run_id UUID NOT NULL REFERENCES pipeline_runs(id),
    temp_avg_c DECIMAL(5, 2),
    temp_min_c DECIMAL(5, 2),
    temp_max_c DECIMAL(5, 2),
    humidity_pct INTEGER,
    pressure_hpa INTEGER,
    wind_speed_kmh DECIMAL(5, 2),
    wind_direction_deg INTEGER,
    wind_direction wind_direction_enum,
    wind_gust_kmh DECIMAL(5, 2),
    rain_tomorrow BOOLEAN,
    precipitation_mm DECIMAL(7, 2),
    weather_description TEXT,
    observation_timestamp TIMESTAMP WITH TIME ZONE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    -- Critical constraint as requested in the analysis
    UNIQUE(location_id, observation_timestamp)
);
-- ============================================
-- Indexes for Performance Optimization
-- ============================================

-- Index 1: Most common query - get latest readings for a specific location
-- Used in: Dashboard "current weather per city"
CREATE INDEX IF NOT EXISTS idx_weather_location_time
    ON weather_readings(location_id, observation_timestamp DESC);

-- Index 2: Time-based queries (charts, trends over time)
-- Used in: Dashboard "temperature trends"
CREATE INDEX IF NOT EXISTS idx_weather_observation_time
    ON weather_readings(observation_timestamp DESC);

-- Index 3: Join with pipeline_runs for monitoring
-- Used in: "which readings came from which run"
CREATE INDEX IF NOT EXISTS idx_weather_pipeline_run
    ON weather_readings(pipeline_run_id);

-- Index 4: Pipeline monitoring queries
-- Used in: Dashboard "pipeline health monitoring"
CREATE INDEX IF NOT EXISTS idx_pipeline_runs_status_time
    ON pipeline_runs(status, started_at DESC);

-- Index 5: Recent pipeline runs (for dashboard)
CREATE INDEX IF NOT EXISTS idx_pipeline_runs_started
    ON pipeline_runs(started_at DESC);

-- Index 6: Search locations by city (autocomplete in dashboard)
CREATE INDEX IF NOT EXISTS idx_locations_city
    ON locations(city);
