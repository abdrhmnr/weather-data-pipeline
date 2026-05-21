import logging
from sqlalchemy.orm import Session
from sqlalchemy.dialects.postgresql import insert
from datetime import datetime, timezone
from src.database.models import Location, PipelineRun, WeatherReading

logger = logging.getLogger(__name__)

class WeatherLoader:
    def __init__(self, db_session: Session):
        self.db = db_session

    def start_pipeline_run(self, params=None):
        """Creates a new entry in pipeline_runs and returns its ID."""
        try:
            new_run = PipelineRun(status='RUNNING', api_request_params=params)
            self.db.add(new_run)
            self.db.commit()
            self.db.refresh(new_run)
            return new_run.id
        except Exception as e:
            self.db.rollback()
            logger.error(f"Failed to start pipeline run track: {e}")
            return None

    def close_pipeline_run(self, run_id, status, extracted, loaded, rejected, error=None):
        """Updates the pipeline_run record with final stats."""
        if not run_id: return
        try:
            run = self.db.query(PipelineRun).filter(PipelineRun.id == run_id).first()
            if run:
                run.finished_at = datetime.now(timezone.utc)
                run.status = status
                run.records_extracted = extracted
                run.records_loaded = loaded
                run.records_rejected = rejected
                run.error_message = error
                self.db.commit()
        except Exception as e:
            self.db.rollback()
            logger.error(f"Failed to close pipeline run {run_id}: {e}")

    def upsert_location(self, city, country, lat, lon, timezone_str):
        """Upserts a location and returns its ID."""
        try:
            stmt = insert(Location).values(
                city=city,
                country=country,
                latitude=lat,
                longitude=lon,
                timezone=timezone_str
            )
            stmt = stmt.on_conflict_do_update(
                index_elements=['city', 'country'],
                set_=dict(
                    latitude=stmt.excluded.latitude,
                    longitude=stmt.excluded.longitude,
                    timezone=stmt.excluded.timezone
                )
            ).returning(Location.id)
            
            result = self.db.execute(stmt)
            loc_id = result.scalar()
            self.db.commit()
            return loc_id
        except Exception as e:
            self.db.rollback()
            logger.error(f"Failed to upsert location {city}: {e}")
            raise

    def load_reading(self, reading_data, location_id, run_id):
        """Inserts a single weather reading into the database."""
        try:
            stmt = insert(WeatherReading).values(
                location_id=location_id,
                pipeline_run_id=run_id,
                temp_avg_c=reading_data['temp_avg_c'],
                temp_min_c=reading_data['temp_min_c'],
                temp_max_c=reading_data['temp_max_c'],
                humidity_pct=reading_data['humidity_pct'],
                pressure_hpa=reading_data['pressure_hpa'],
                wind_speed_kmh=reading_data['wind_speed_kmh'],
                wind_direction_deg=reading_data['wind_direction_deg'],
                wind_direction=reading_data['wind_direction'],
                wind_gust_kmh=reading_data['wind_gust_kmh'],
                rain_tomorrow=reading_data['rain_tomorrow'],
                precipitation_mm=reading_data['precipitation_mm'],
                weather_description=reading_data['description'],
                observation_timestamp=reading_data['observation_timestamp']
            )
            stmt = stmt.on_conflict_do_nothing(
                index_elements=['location_id', 'observation_timestamp']
            )
            
            result = self.db.execute(stmt)
            self.db.commit()
            
            # If rowcount is 0, it means it hit the conflict and did nothing.
            # We still consider it a successful operation overall, or we can check result.rowcount
            # For backward compatibility, returning True
            return True
        except Exception as e:
            self.db.rollback()
            logger.error(f"Failed to load reading for location {location_id}: {e}")
            return False
