import os
import json
import logging
import pandas as pd
from src.extract import get_current_weather
from src.transform import WeatherTransformer
from src.load import WeatherLoader
from config.settings import TARGET_CITIES, WEATHER_CSV_PATH, THRESHOLDS

# Setup logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

def validate_data(data):
    """
    Performs basic data quality checks before loading into DB.
    """
    if data['temp_avg_c'] is None or not (THRESHOLDS['temp_min'] <= data['temp_avg_c'] <= THRESHOLDS['temp_max']):
        logger.warning(f"Data validation failed for {data['city']}: Temperature out of range ({data['temp_avg_c']})")
        return False
    if data['humidity_pct'] is not None and not (0 <= data['humidity_pct'] <= THRESHOLDS['humidity_max']):
        logger.warning(f"Data validation failed for {data['city']}: Humidity out of range ({data['humidity_pct']})")
        return False
    return True

def run_pipeline():
    logger.info("Initializing Weather Data Pipeline...")
    loader = WeatherLoader()
    transformer = WeatherTransformer()
    
    # 1. Start pipeline run tracking
    run_id = loader.start_pipeline_run(params=json.dumps({"cities": TARGET_CITIES}))
    
    extracted_count = 0
    loaded_count = 0
    rejected_count = 0
    
    try:
        # 2. Train transformer with historical data if available
        if os.path.exists(WEATHER_CSV_PATH):
            logger.info(f"Loading historical data from {WEATHER_CSV_PATH}")
            historical_df = pd.read_csv(WEATHER_CSV_PATH)
            transformer.train_models(historical_df)
        else:
            logger.warning("Historical data not found. Predictions will be disabled.")
        
        for city in TARGET_CITIES:
            # 3. Extract
            raw_data = get_current_weather(city)
            if not raw_data:
                rejected_count += 1
                continue
            
            extracted_count += 1
            
            # 4. Transform
            transformed_data = transformer.transform_reading(raw_data)
            
            # 5. Data Validation (Quality Check)
            if not validate_data(transformed_data):
                rejected_count += 1
                continue
                
            # 6. Load
            try:
                # First upsert location
                location_id = loader.upsert_location(
                    city=transformed_data['city'],
                    country=transformed_data['country'],
                    lat=transformed_data['lat'],
                    lon=transformed_data['lon'],
                    timezone=str(transformed_data['timezone'])
                )
                
                # Then load reading
                success = loader.load_reading(transformed_data, location_id, run_id)
                if success:
                    loaded_count += 1
                else:
                    rejected_count += 1
            except Exception as e:
                logger.error(f"Failed to process city {city}: {e}")
                rejected_count += 1
                
        # 7. Finish pipeline run
        status = 'SUCCESS' if rejected_count == 0 else 'PARTIAL_SUCCESS'
        if extracted_count == 0: status = 'FAILED'
        
        loader.close_pipeline_run(run_id, status, extracted_count, loaded_count, rejected_count)
        logger.info(f"Pipeline finished. Status: {status}. Loaded: {loaded_count}, Rejected: {rejected_count}")
        
    except Exception as e:
        logger.error(f"Pipeline critical failure: {e}")
        loader.close_pipeline_run(run_id, 'FAILED', extracted_count, loaded_count, rejected_count, error=str(e))

if __name__ == "__main__":
    run_pipeline()
