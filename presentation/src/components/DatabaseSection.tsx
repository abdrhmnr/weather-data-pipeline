'use client';
import React from 'react';
import { SectionWrapper } from './SectionWrapper';
import { CodeBlock } from './CodeBlock';
import { motion } from 'framer-motion';

const sqlCode = `-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Table: pipeline_runs
CREATE TABLE IF NOT EXISTS pipeline_runs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    started_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'RUNNING' CHECK (
        status IN ('RUNNING', 'SUCCESS', 'FAILED', 'PARTIAL')
    ),
    records_extracted INTEGER DEFAULT 0,
    records_loaded INTEGER DEFAULT 0,
    records_rejected INTEGER DEFAULT 0
);

-- Table: weather_readings
CREATE TABLE IF NOT EXISTS weather_readings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    location_id UUID NOT NULL REFERENCES locations(id),
    pipeline_run_id UUID NOT NULL REFERENCES pipeline_runs(id),
    temp_avg_c DECIMAL(5, 2),
    humidity_pct INTEGER,
    wind_speed_kmh DECIMAL(5, 2),
    rain_tomorrow BOOLEAN,
    observation_timestamp TIMESTAMP WITH TIME ZONE NOT NULL,
    -- Critical constraint for idempotency
    UNIQUE(location_id, observation_timestamp)
);

-- Index 1: Most common query - get latest readings
CREATE INDEX IF NOT EXISTS idx_weather_location_time
    ON weather_readings(location_id, observation_timestamp DESC);`;

export const DatabaseSection = () => {
  return (
    <SectionWrapper 
      id="database"
      title="Database Design & ERD" 
      subtitle="A normalized PostgreSQL 15 schema featuring UUIDs, idempotency constraints, and optimized time-series indexes."
    >
      <div className="grid md:grid-cols-2 gap-12 items-center">
        
        <div className="space-y-6 text-slate-300">
          <p className="text-lg leading-relaxed">
            The database architecture ensures analytical readiness and pipeline observability. The core <code className="text-blue-400 bg-blue-400/10 px-1 py-0.5 rounded">weather_readings</code> table is heavily indexed for fast time-series retrieval.
          </p>
          
          <div className="space-y-4">
            <div className="p-5 rounded-xl bg-slate-900 border border-slate-700 hover:border-blue-500 transition-colors">
              <h4 className="font-bold text-white mb-2 text-lg">Idempotency</h4>
              <p className="text-sm">The UNIQUE(location_id, observation_timestamp) constraint ensures that re-running the pipeline never duplicates data.</p>
            </div>
            
            <div className="p-5 rounded-xl bg-slate-900 border border-slate-700 hover:border-purple-500 transition-colors">
              <h4 className="font-bold text-white mb-2 text-lg">Observability</h4>
              <p className="text-sm">Every row connects via foreign key to the <code className="text-purple-400 text-xs bg-purple-400/10 px-1 py-0.5 rounded">pipeline_runs</code> table, providing full traceability of when and how the record was ingested.</p>
            </div>
          </div>
        </div>

        <motion.div 
          initial={{ opacity: 0, x: 20 }}
          whileInView={{ opacity: 1, x: 0 }}
          viewport={{ once: true }}
          className="relative"
        >
          <div className="absolute -inset-1 bg-gradient-to-r from-blue-600 to-indigo-600 rounded-2xl blur opacity-20" />
          <CodeBlock 
            code={sqlCode} 
            language="sql" 
            filename="database/schema.sql"
          />
        </motion.div>

      </div>
    </SectionWrapper>
  );
};
