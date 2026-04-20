import unittest
from src.transform import WeatherTransformer

class TestWeatherTransformation(unittest.TestCase):
    def setUp(self):
        self.transformer = WeatherTransformer()

    def test_unit_conversion(self):
        # Raw data with speed in m/s (10 m/s = 36 km/h)
        raw_data = {
            'wind_speed_ms': 10,
            'wind_gust_ms': 20,
            'wind_deg': 0,
            'temp_min_c': 20,
            'temp_max_c': 30,
            'humidity_pct': 50,
            'pressure_hpa': 1013,
            'temp_avg_c': 25
        }
        
        transformed = self.transformer.transform_reading(raw_data)
        
        self.assertEqual(transformed['wind_speed_kmh'], 36.0)
        self.assertEqual(transformed['wind_gust_kmh'], 72.0)
        self.assertEqual(transformed['wind_direction'], 'N')

    def test_rain_boolean_type(self):
        raw_data = {
            'wind_speed_ms': 5,
            'wind_gust_ms': 5,
            'wind_deg': 180,
            'temp_min_c': 10,
            'temp_max_c': 15,
            'humidity_pct': 90,
            'pressure_hpa': 1000,
            'temp_avg_c': 12
        }
        transformed = self.transformer.transform_reading(raw_data)
        self.assertIsInstance(transformed['rain_tomorrow'], bool)

if __name__ == '__main__':
    unittest.main()
