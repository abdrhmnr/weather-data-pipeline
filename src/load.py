import psycopg2
import logging
from config.settings import DB_CONFIG

logger = logging.getLogger(__name__)

class WeatherLoader:
    def __init__(self):
        self.conn_params = DB_CONFIG

    def _get_connection(self):
        try:
            return psycopg2.connect(**self.conn_params)
        except Exception as e:
            logger.critical(f"Database connection failed: {e}")
            raise

    def start_pipeline_run(self, params=None):
        """Creates a new entry in pipeline_runs and returns its ID."""
        try:
            with self._get_connection() as conn:
                with conn.cursor() as cur:
                    cur.execute(
                        """
                        INSERT INTO pipeline_runs (status, api_request_params)
                        VALUES ('RUNNING', %s)
                        RETURNING id;
                        """,
                        (params,)
                    )
                    run_id = cur.fetchone()[0]
                    conn.commit()
                    return run_id
        except Exception as e:
            logger.error(f"Failed to start pipeline run track: {e}")
            return None

    def close_pipeline_run(self, run_id, status, extracted, loaded, rejected, error=None):
        """Updates the pipeline_run record with final stats."""
        if not run_id: return
        try:
            with self._get_connection() as conn:
                with conn.cursor() as cur:
                    cur.execute(
                        """
                        UPDATE pipeline_runs 
                        SET finished_at = CURRENT_TIMESTAMP,
                            status = %s,
                            records_extracted = %s,
                            records_loaded = %s,
                            records_rejected = %s,
                            error_message = %s
                        WHERE id = %s;
                        """,
                        (status, extracted, loaded, rejected, error, run_id)
                    )
                    conn.commit()
        except Exception as e:
            logger.error(f"Failed to close pipeline run {run_id}: {e}")

    def upsert_location(self, city, country, lat, lon, timezone):
        """Upserts a location and returns its ID."""
        with self._get_connection() as conn:
            with conn.cursor() as cur:
                cur.execute(
                    """
                    INSERT INTO locations (city, country, latitude, longitude, timezone)
                    VALUES (%s, %s, %s, %s, %s)
                    ON CONFLICT (city, country) 
                    DO UPDATE SET 
                        latitude = EXCLUDED.latitude,
                        longitude = EXCLUDED.longitude,
                        timezone = EXCLUDED.timezone
                    RETURNING id;
                    """,
                    (city, country, lat, lon, timezone)
                )
                loc_id = cur.fetchone()[0]
                conn.commit()
                return loc_id

    def load_reading(self, reading_data, location_id, run_id):
        """Inserts a single weather reading into the database."""
        try:
            with self._get_connection() as conn:
                with conn.cursor() as cur:
                    cur.execute(
                        """
                        INSERT INTO weather_readings (
                            location_id, pipeline_run_id, temp_avg_c, temp_min_c, temp_max_c,
                            humidity_pct, pressure_hpa, wind_speed_kmh, wind_direction_deg,
                            wind_direction, wind_gust_kmh, rain_tomorrow, precipitation_mm,
                            weather_description, observation_timestamp
                        )
                        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                        ON CONFLICT (location_id, observation_timestamp) DO NOTHING;
                        """,
                        (
                            location_id, run_id, 
                            reading_data['temp_avg_c'], reading_data['temp_min_c'], reading_data['temp_max_c'],
                            reading_data['humidity_pct'], reading_data['pressure_hpa'], 
                            reading_data['wind_speed_kmh'], reading_data['wind_direction_deg'],
                            reading_data['wind_direction'], reading_data['wind_gust_kmh'], 
                            reading_data['rain_tomorrow'], reading_data['precipitation_mm'],
                            reading_data['description'], reading_data['observation_timestamp']
                        )
                    )
                    conn.commit()
                    return True
        except Exception as e:
            logger.error(f"Failed to load reading for location {location_id}: {e}")
            return False
