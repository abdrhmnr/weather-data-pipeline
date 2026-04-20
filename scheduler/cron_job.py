import schedule
import time
import logging
from src.pipeline import run_pipeline

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler("logs/scheduler.log"),
        logging.StreamHandler()
    ]
)

def job():
    logging.info("Starting scheduled weather data collection...")
    try:
        run_pipeline()
        logging.info("Scheduled job completed successfully.")
    except Exception as e:
        logging.error(f"Scheduled job failed: {e}")

# RunEvery hour
schedule.every().hour.at(":00").do(job)

if __name__ == "__main__":
    logging.info("Weather Data Pipeline Scheduler started.")
    # Run once at startup
    job()
    
    while True:
        schedule.run_pending()
        time.sleep(60)
