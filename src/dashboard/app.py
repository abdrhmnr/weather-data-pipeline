import streamlit as st
import pandas as pd
from sqlalchemy import create_engine
import os

st.set_page_config(page_title="Weather Dashboard", page_icon="⛅", layout="wide")

st.title("⛅ Weather Data Pipeline Dashboard")
st.markdown("This dashboard displays the latest weather readings integrated with location data.")

@st.cache_resource
def get_db_connection():
    db_user = os.getenv("DB_USER", "postgres")
    db_password = os.getenv("DB_PASSWORD", "postgres_password")
    db_host = os.getenv("DB_HOST", "db")
    db_port = os.getenv("DB_PORT", "5432")
    db_name = os.getenv("DB_NAME", "weather_db")
    
    db_url = f"postgresql://{db_user}:{db_password}@{db_host}:{db_port}/{db_name}"
    engine = create_engine(db_url)
    return engine

def fetch_data():
    engine = get_db_connection()
    query = """
    SELECT 
        l.city, 
        l.country, 
        w.observation_timestamp as time,
        w.temp_avg_c as temp, 
        w.humidity_pct as humidity, 
        w.wind_speed_kmh as wind_speed,
        w.weather_description as description
    FROM weather_readings w 
    JOIN locations l ON w.location_id = l.id
    ORDER BY w.observation_timestamp DESC;
    """
    df = pd.read_sql(query, engine)
    return df

with st.spinner("Fetching latest data from database..."):
    df = fetch_data()

if df.empty:
    st.warning("No data found in the database. Has the pipeline run successfully?")
else:
    # Latest Data Table
    st.subheader("📋 Latest Weather Readings")
    st.dataframe(df, use_container_width=True)

    # Charts
    col1, col2 = st.columns(2)
    
    with col1:
        st.subheader("🌡️ Temperatures by City")
        # Get the latest reading for each city
        latest_temps = df.loc[df.groupby('city')['time'].idxmax()]
        st.bar_chart(data=latest_temps, x='city', y='temp')
        
    with col2:
        st.subheader("💨 Wind Speed by City (km/h)")
        st.bar_chart(data=latest_temps, x='city', y='wind_speed')
        
st.markdown("---")
st.caption("Data is pulled directly from the `weather_db` PostgreSQL database.")
