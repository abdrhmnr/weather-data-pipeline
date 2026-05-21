import uuid
from datetime import datetime, timezone
from sqlalchemy import Column, String, Float, Integer, Boolean, DateTime, ForeignKey, Enum, JSON, Index, UniqueConstraint
from sqlalchemy.orm import declarative_base, relationship
from sqlalchemy.dialects.postgresql import UUID, JSONB
import enum

Base = declarative_base()

class WindDirectionEnum(enum.Enum):
    N = 'N'
    NNE = 'NNE'
    NE = 'NE'
    ENE = 'ENE'
    E = 'E'
    ESE = 'ESE'
    SE = 'SE'
    SSE = 'SSE'
    S = 'S'
    SSW = 'SSW'
    SW = 'SW'
    WSW = 'WSW'
    W = 'W'
    WNW = 'WNW'
    NW = 'NW'
    NNW = 'NNW'

class Location(Base):
    __tablename__ = 'locations'

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    city = Column(String(100), nullable=False, index=True)
    country = Column(String(10), nullable=False)
    latitude = Column(Float)
    longitude = Column(Float)
    timezone = Column(String(50))
    elevation = Column(Float)
    created_at = Column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))

    __table_args__ = (
        UniqueConstraint('city', 'country', name='uix_city_country'),
    )

    weather_readings = relationship("WeatherReading", back_populates="location")


class PipelineRun(Base):
    __tablename__ = 'pipeline_runs'

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    started_at = Column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc), index=True)
    finished_at = Column(DateTime(timezone=True), nullable=True)
    status = Column(String(20), default='RUNNING')
    records_extracted = Column(Integer, default=0)
    records_loaded = Column(Integer, default=0)
    records_rejected = Column(Integer, default=0)
    error_message = Column(String, nullable=True)
    api_request_params = Column(JSONB, nullable=True)
    created_at = Column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))

    weather_readings = relationship("WeatherReading", back_populates="pipeline_run")


class WeatherReading(Base):
    __tablename__ = 'weather_readings'

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    location_id = Column(UUID(as_uuid=True), ForeignKey('locations.id'), nullable=False)
    pipeline_run_id = Column(UUID(as_uuid=True), ForeignKey('pipeline_runs.id'), nullable=False, index=True)
    
    temp_avg_c = Column(Float)
    temp_min_c = Column(Float)
    temp_max_c = Column(Float)
    humidity_pct = Column(Integer)
    pressure_hpa = Column(Integer)
    wind_speed_kmh = Column(Float)
    wind_direction_deg = Column(Integer)
    wind_direction = Column(Enum(WindDirectionEnum, name='wind_direction_enum'))
    wind_gust_kmh = Column(Float)
    rain_tomorrow = Column(Boolean)
    precipitation_mm = Column(Float)
    weather_description = Column(String)
    
    observation_timestamp = Column(DateTime(timezone=True), nullable=False, index=True)
    created_at = Column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))

    __table_args__ = (
        UniqueConstraint('location_id', 'observation_timestamp', name='uix_loc_obs_time'),
    )

    location = relationship("Location", back_populates="weather_readings")
    pipeline_run = relationship("PipelineRun", back_populates="weather_readings")
