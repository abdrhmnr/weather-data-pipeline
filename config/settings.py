import os
from dotenv import load_dotenv

load_dotenv()

# Database Config
DB_CONFIG = {
    'dbname': os.getenv('DB_NAME', 'weather_db'),
    'user': os.getenv('DB_USER', 'postgres'),
    'password': os.getenv('DB_PASSWORD', 'postgres'),
    'host': os.getenv('DB_HOST', 'localhost'),
    'port': os.getenv('DB_PORT', '5432')
}

# API Config
API_KEY = os.getenv("WEATHER_API_KEY")
API_BASE_URL = "https://api.openweathermap.org/data/2.5/weather"

# Pipeline Config
TARGET_CITIES = [
    "Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut",
    "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"
]

# Path Config
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ASSETS_DIR = os.path.join(BASE_DIR, 'assets')
WEATHER_CSV_PATH = os.path.join(ASSETS_DIR, 'weather.csv')

# Data Validation Thresholds
THRESHOLDS = {
    'temp_min': -50,
    'temp_max': 60,
    'humidity_max': 100,
    'pressure_min': 800,
    'pressure_max': 1100
}
