import pandas as pd
import numpy as np
from sklearn.ensemble import RandomForestClassifier
from sklearn.preprocessing import LabelEncoder

class WeatherTransformer:
    def __init__(self):
        self.rain_model = None
        self.label_encoder = LabelEncoder()
        
    def train_models(self, historical_df):
        """
        Trains the models using historical data.
        """
        df = historical_df.copy()
        df = df.dropna().drop_duplicates()
        
        # Prepare label encoder for wind direction
        df['WindGustDir'] = self.label_encoder.fit_transform(df['WindGustDir'].astype(str))
        
        # Prepare features for rain prediction
        # Based on notebook mapping: MinTemp, MaxTemp, Humidity, WindGustDir, WindGustSpeed, Pressure, Temp
        X = df[['MinTemp', 'MaxTemp', 'Humidity', 'WindGustDir', 'WindGustSpeed', 'Pressure', 'Temp']]
        y = df['RainTomorrow'].apply(lambda x: 1 if x == 'Yes' or x is True or x == 1 else 0)
        
        self.rain_model = RandomForestClassifier(n_estimators=100, random_state=42)
        self.rain_model.fit(X, y)
        print("Models trained successfully!")

    def transform_reading(self, raw_data):
        """
        Transforms raw API data to match schema requirements.
        """
        transformed = raw_data.copy()
        
        # 1. Unit conversions: m/s to km/h (Multiply by 3.6)
        transformed['wind_speed_kmh'] = round(raw_data['wind_speed_ms'] * 3.6, 2)
        transformed['wind_gust_kmh'] = round(raw_data['wind_gust_ms'] * 3.6, 2)
        
        # 2. Wind direction string mapping (16-point)
        deg = raw_data['wind_deg'] % 360
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
        
        # 3. Predict Rain Tomorrow (Fit to schema: BOOLEAN)
        if self.rain_model:
            # Prepare feature vector for prediction
            # We need to encode the current wind direction using the same encoder
            if wind_direction in self.label_encoder.classes_:
                wind_dir_encoded = self.label_encoder.transform([wind_direction])[0]
            else:
                wind_dir_encoded = 0
                
            features = pd.DataFrame([{
                'MinTemp': raw_data['temp_min_c'],
                'MaxTemp': raw_data['temp_max_c'],
                'Humidity': raw_data['humidity_pct'],
                'WindGustDir': wind_dir_encoded,
                'WindGustSpeed': raw_data['wind_gust_ms'], # Model was trained with m/s? Checking notebook...
                'Pressure': raw_data['pressure_hpa'],
                'Temp': raw_data['temp_avg_c']
            }])
            
            # Use same order as training
            features = features[['MinTemp', 'MaxTemp', 'Humidity', 'WindGustDir', 'WindGustSpeed', 'Pressure', 'Temp']]
            
            prediction = self.rain_model.predict(features)[0]
            transformed['rain_tomorrow'] = bool(prediction)
        else:
            transformed['rain_tomorrow'] = False
            
        return transformed
