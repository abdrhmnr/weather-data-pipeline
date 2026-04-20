import requests
import logging
from datetime import datetime
import pytz
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry
from config.settings import API_KEY, API_BASE_URL

logger = logging.getLogger(__name__)

def get_session():
    """Returns a requests session with retry logic."""
    session = requests.Session()
    retry = Retry(
        total=3,
        backoff_factor=1,
        status_forcelist=[500, 502, 503, 504]
    )
    adapter = HTTPAdapter(max_retries=retry)
    session.mount('http://', adapter)
    session.mount('https://', adapter)
    return session

def get_current_weather(city):
    """
    Fetches current weather data with retry logic and detailed error handling.
    """
    if not API_KEY:
        logger.error("WEATHER_API_KEY not found in environment.")
        return None

    session = get_session()
    try:
        params = {
            'q': city,
            'appid': API_KEY,
            'units': 'metric'
        }
        response = session.get(API_BASE_URL, params=params, timeout=10)
        response.raise_for_status()
        data = response.json()
        
        return {
            'city': data.get('name'),
            'country': data.get('sys', {}).get('country'),
            'lat': data.get('coord', {}).get('lat'),
            'lon': data.get('coord', {}).get('lon'),
            'timezone': data.get('timezone'),
            'temp_avg_c': data.get('main', {}).get('temp'),
            'temp_min_c': data.get('main', {}).get('temp_min'),
            'temp_max_c': data.get('main', {}).get('temp_max'),
            'humidity_pct': data.get('main', {}).get('humidity'),
            'pressure_hpa': data.get('main', {}).get('pressure'),
            'wind_speed_ms': data.get('wind', {}).get('speed', 0),
            'wind_deg': data.get('wind', {}).get('deg', 0),
            'wind_gust_ms': data.get('wind', {}).get('gust', 0),
            'description': data.get('weather', [{}])[0].get('description'),
            'precipitation_mm': data.get('rain', {}).get('1h', 0) or data.get('snow', {}).get('1h', 0) or 0,
            'observation_timestamp': datetime.now(pytz.utc).replace(minute=0, second=0, microsecond=0)
        }
    except requests.exceptions.HTTPError as e:
        logger.warning(f"HTTP error for {city}: {e.response.status_code} - {e.response.text}")
    except Exception as e:
        logger.error(f"Unexpected error fetching weather for {city}: {e}")
    
    return None
