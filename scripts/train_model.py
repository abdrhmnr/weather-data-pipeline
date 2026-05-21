import os
import sys
import pandas as pd
from sklearn.ensemble import RandomForestClassifier
from sklearn.preprocessing import LabelEncoder
import joblib
import logging

# Add the project root to sys.path so we can import config
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from config.settings import WEATHER_CSV_PATH, ASSETS_DIR

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def train_and_save_model():
    if not os.path.exists(WEATHER_CSV_PATH):
        logging.error(f"Historical data not found at {WEATHER_CSV_PATH}. Cannot train model.")
        return

    logging.info(f"Loading historical data from {WEATHER_CSV_PATH}")
    historical_df = pd.read_csv(WEATHER_CSV_PATH)

    df = historical_df.copy()
    df = df.dropna().drop_duplicates()

    # Prepare label encoder for wind direction
    label_encoder = LabelEncoder()
    df['WindGustDir'] = label_encoder.fit_transform(df['WindGustDir'].astype(str))

    # Prepare features for rain prediction
    X = df[['MinTemp', 'MaxTemp', 'Humidity', 'WindGustDir', 'WindGustSpeed', 'Pressure', 'Temp']]
    y = df['RainTomorrow'].apply(lambda x: 1 if x == 'Yes' or x is True or x == 1 else 0)

    logging.info("Training Random Forest model...")
    rain_model = RandomForestClassifier(n_estimators=100, random_state=42)
    rain_model.fit(X, y)
    
    # Ensure assets directory exists
    os.makedirs(ASSETS_DIR, exist_ok=True)

    # Save models
    model_path = os.path.join(ASSETS_DIR, 'rain_model.pkl')
    encoder_path = os.path.join(ASSETS_DIR, 'label_encoder.pkl')
    
    joblib.dump(rain_model, model_path)
    joblib.dump(label_encoder, encoder_path)
    
    logging.info(f"Models saved successfully to {model_path} and {encoder_path}")

if __name__ == "__main__":
    train_and_save_model()
