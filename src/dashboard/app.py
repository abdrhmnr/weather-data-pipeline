import streamlit as st
import pandas as pd
import plotly.graph_objects as go
import os

st.set_page_config(page_title="الطقس", page_icon="⛅", layout="centered")

# --- Custom CSS for Google Weather UI (Dark Mode & RTL) ---
st.markdown("""
<style>
    /* Global styles for dark theme and Arabic RTL */
    .stApp {
        background-color: #202124 !important;
        direction: rtl;
    }
    
    /* Override Streamlit's default container padding and text color */
    .block-container {
        padding-top: 2rem;
        color: #e8eaed;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }

    /* Hide Streamlit components headers if any */
    header {visibility: hidden;}
    footer {visibility: hidden;}
    
    /* Top Weather Widget */
    .weather-widget {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 20px 0;
    }
    .weather-left {
        display: flex;
        flex-direction: column;
    }
    .city-name {
        font-size: 28px;
        font-weight: bold;
        color: #ffffff;
        margin-bottom: 5px;
    }
    .current-time {
        font-size: 14px;
        color: #9aa0a6;
    }
    .condition {
        font-size: 16px;
        color: #bdc1c6;
    }
    
    .weather-right {
        display: flex;
        align-items: center;
        gap: 20px;
    }
    .temp-huge {
        font-size: 64px;
        font-weight: 400;
        color: #ffffff;
        display: flex;
    }
    .details {
        font-size: 14px;
        color: #9aa0a6;
        display: flex;
        flex-direction: column;
        gap: 3px;
        margin-left: 20px;
    }
    
    /* Daily Forecast Cards */
    .daily-forecast-container {
        display: flex;
        justify-content: space-around;
        margin-top: 0px;
        padding-top: 20px;
        border-top: 1px solid #3c4043;
    }
    .day-card {
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 8px;
    }
    .day-name {
        font-size: 14px;
        color: #e8eaed;
    }
    .day-icon {
        font-size: 28px;
        color: #fbbc04; /* Yellow sun color */
    }
    .day-temps {
        font-size: 14px;
        color: #e8eaed;
    }
    .day-temps span {
        color: #9aa0a6;
        margin-right: 5px;
    }
    
    /* Style Selectbox label */
    .stSelectbox label {
        color: #9aa0a6 !important;
    }
</style>
""", unsafe_allow_html=True)

# Load Data
@st.cache_data
def load_data():
    csv_path = 'exported_weather_data.csv'
    if not os.path.exists(csv_path):
        return pd.DataFrame()
    df = pd.read_csv(csv_path)
    df['observation_timestamp'] = pd.to_datetime(df['observation_timestamp'])
    return df

df = load_data()

if df.empty:
    st.error("لم يتم العثور على بيانات في ملف exported_weather_data.csv")
    st.stop()

# City Selector
cities = df['city'].unique()

col1, col2 = st.columns(2)
with col1:
    selected_city = st.selectbox("اختر المدينة:", cities)

# Filter data for selected city and sort by time
city_data = df[df['city'] == selected_city].sort_values('observation_timestamp').copy()
city_data['date'] = city_data['observation_timestamp'].dt.date

# Date Selector
available_dates = sorted(city_data['date'].unique(), reverse=True)
with col2:
    selected_date = st.selectbox("اختر التاريخ:", available_dates)

# Filter data for the selected date
date_data = city_data[city_data['date'] == selected_date]
latest = date_data.iloc[-1]

# --- 1. Current Weather Section ---
# Map rain to chance
rain_chance = "100%" if latest['rain_tomorrow'] == 't' or latest['rain_tomorrow'] == True else "0%"
wind = latest['wind_speed_kmh']
humidity = latest['humidity_pct']
temp = int(round(latest['temp_avg_c']))

# Arabic Days
days_ar = {0: "الاثنين", 1: "الثلاثاء", 2: "الأربعاء", 3: "الخميس", 4: "الجمعة", 5: "السبت", 6: "الأحد"}
current_day = days_ar[latest['observation_timestamp'].weekday()]
current_time = latest['observation_timestamp'].strftime('%I:%M')
am_pm = "ص" if latest['observation_timestamp'].hour < 12 else "م"

html_widget = f"""
<div class="weather-widget">
    <div class="weather-left">
        <div class="city-name">الطقس في {selected_city}</div>
        <div class="current-time">{current_day} {current_time} {am_pm}</div>
        <div class="condition">صافٍ</div>
    </div>
    <div class="weather-right">
        <div class="details">
            <div>الأمطار: {rain_chance}</div>
            <div>الرطوبة: {humidity}%</div>
            <div>الرياح: {wind} كم/ساعة</div>
        </div>
        <div class="temp-huge">{temp}<span style="font-size:32px; vertical-align: super; margin-top: 10px;">°C</span></div>
        <div style="font-size: 64px; line-height: 1;">🌙</div>
    </div>
</div>
"""
st.markdown(html_widget, unsafe_allow_html=True)

# --- 2. Area Chart (Plotly) ---
# Format time for the x-axis
def format_time(dt):
    hr = dt.strftime('%I').lstrip('0')
    ap = "ص" if dt.hour < 12 else "م"
    return f"{hr} {ap}"

date_data['time_label'] = date_data['observation_timestamp'].apply(format_time)

# Use all readings for the selected date
chart_data = date_data

fig = go.Figure()

# Plotly Area Chart matching Google Style
fig.add_trace(go.Scatter(
    x=chart_data['time_label'],
    y=chart_data['temp_avg_c'],
    fill='tozeroy',
    mode='lines+markers+text',
    line=dict(color='#fbbc04', width=3),
    fillcolor='rgba(251, 188, 4, 0.2)', # Yellowish transparent fill
    marker=dict(size=8, color='#fbbc04'),
    text=[f"{int(round(t))}" for t in chart_data['temp_avg_c']],
    textposition="top center",
    textfont=dict(color='white', size=14)
))

# Calculate y-axis range to give space for text on top
y_min = chart_data['temp_avg_c'].min() - 2
y_max = chart_data['temp_avg_c'].max() + 5

fig.update_layout(
    plot_bgcolor='rgba(0,0,0,0)',
    paper_bgcolor='rgba(0,0,0,0)',
    margin=dict(l=0, r=0, t=10, b=0),
    xaxis=dict(showgrid=False, zeroline=False, showticklabels=True, color='#9aa0a6'),
    yaxis=dict(showgrid=False, zeroline=False, showticklabels=False, range=[y_min, y_max]),
    height=150,
    hovermode=False
)

st.plotly_chart(fig, use_container_width=True, config={'displayModeBar': False})

# --- 3. Daily Summary Section ---
# Group by date to get daily min/max
city_data['date'] = city_data['observation_timestamp'].dt.date
daily_data = city_data.groupby('date').agg(
    temp_max=('temp_avg_c', 'max'),
    temp_min=('temp_avg_c', 'min')
).reset_index().tail(7) # Last 7 days

daily_html = '<div class="daily-forecast-container">\n'

for _, row in daily_data.iterrows():
    day_name = days_ar[row['date'].weekday()]
    t_max = int(round(row['temp_max']))
    t_min = int(round(row['temp_min']))
    
    # DO NOT indent the HTML, otherwise Streamlit markdown parser treats it as a code block!
    daily_html += f"""<div class="day-card">
<div class="day-name">{day_name}</div>
<div class="day-icon">☀️</div>
<div class="day-temps">{t_max}° <span>{t_min}°</span></div>
</div>
"""

daily_html += '</div>'

st.markdown(daily_html, unsafe_allow_html=True)
