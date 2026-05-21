import os
import joblib
import pandas as pd
import numpy as np
import logging

logger = logging.getLogger(__name__)

class WeatherTransformer:
    def __init__(self):
        # Import config here to avoid circular imports if any, or just import at top.
        from config.settings import ASSETS_DIR
        
        model_path = os.path.join(ASSETS_DIR, 'rain_model.pkl')
        encoder_path = os.path.join(ASSETS_DIR, 'label_encoder.pkl')
        
        self.rain_model = None
        self.label_encoder = None
        
        if os.path.exists(model_path) and os.path.exists(encoder_path):
            try:
                self.rain_model = joblib.load(model_path)
                self.label_encoder = joblib.load(encoder_path)
                logger.info("Loaded pre-trained ML models successfully.")
            except Exception as e:
                logger.error(f"Failed to load ML models: {e}")
        else:
            logger.warning("Pre-trained ML models not found. Rain prediction will be disabled. Run scripts/train_model.py first.")

    def transform_reading(self, raw_data):
        """
        Transforms and cleans raw API data to match schema requirements.
        """
        transformed = raw_data.copy()

        # --- 1. DATA CLEANING ---
        # Handle Nulls for numeric fields
        numeric_fields = ['wind_speed_ms', 'wind_gust_ms', 'wind_deg', 'temp_avg_c', 'temp_min_c', 'temp_max_c', 'humidity_pct', 'pressure_hpa', 'precipitation_mm']
        for field in numeric_fields:
            if transformed.get(field) is None:
                transformed[field] = 0.0

        # String formatting
        if 'description' in transformed and isinstance(transformed['description'], str):
            transformed['description'] = transformed['description'].strip().lower()
            
        # Validation / Bounds Checking for temperature
        if not (-60 <= transformed['temp_avg_c'] <= 60):
            logger.warning(f"Abnormal temperature detected: {transformed['temp_avg_c']}. Clamping to realistic bounds.")
            transformed['temp_avg_c'] = max(-60, min(transformed['temp_avg_c'], 60))

        # --- 2. DATA TRANSFORMATION ---
        # Unit conversions: m/s to km/h (Multiply by 3.6)
        transformed['wind_speed_kmh'] = round(transformed['wind_speed_ms'] * 3.6, 2)
        transformed['wind_gust_kmh'] = round(transformed['wind_gust_ms'] * 3.6, 2)

        # Wind direction string mapping (16-point)
        deg = transformed['wind_deg'] % 360
        compass_points = [
            ("N", 348.75, 360), ("N", 0, 11.25),
            ("NNE", 11.25, 33.75), ("NE", 33.75, 56.25),
            ("ENE", 56.25, 78.75), ("E", 78.75, 101.25),
            ("ESE", 101.25, 123.75), ("SE", 123.75, 146.25),
            ("SSE", 146.25, 168.75), ("S", 168.75, 191.25),
            ("SSW", 191.25, 213.75), ("SW", 213.75, 236.25),
            ("WSW", 236.25, 258.75), ("W", 258.75, 281.25),
            ("WNW", 281.25, 303.75), ("NW", 303.75, 326.25),
            ("NNW", 326.25, 348.75),
        ]

        wind_direction = "N"
        for direction, start, end in compass_points:
            if start <= deg < end:
                wind_direction = direction
                break
        transformed['wind_direction'] = wind_direction
        transformed['wind_direction_deg'] = int(deg)

        # --- 3. ML PREDICTION ---
        # Predict Rain Tomorrow (Fit to schema: BOOLEAN)
        if self.rain_model:
            # Prepare feature vector for prediction
            if wind_direction in self.label_encoder.classes_:
                wind_dir_encoded = self.label_encoder.transform([wind_direction])[0]
            else:
                wind_dir_encoded = 0

            features = pd.DataFrame([{
                'MinTemp': transformed['temp_min_c'],
                'MaxTemp': transformed['temp_max_c'],
                'Humidity': transformed['humidity_pct'],
                'WindGustDir': wind_dir_encoded,
                'WindGustSpeed': transformed['wind_gust_ms'],
                'Pressure': transformed['pressure_hpa'],
                'Temp': transformed['temp_avg_c']
            }])

            # Use same order as training
            features = features[['MinTemp', 'MaxTemp', 'Humidity', 'WindGustDir', 'WindGustSpeed', 'Pressure', 'Temp']]

            prediction = self.rain_model.predict(features)[0]
            transformed['rain_tomorrow'] = bool(prediction)
        else:
            transformed['rain_tomorrow'] = False

        return transformed
