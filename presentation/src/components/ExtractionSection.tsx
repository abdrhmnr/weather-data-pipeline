'use client';
import React from 'react';
import { SectionWrapper } from './SectionWrapper';
import { CodeBlock } from './CodeBlock';
import { Database, ArrowDown, ExternalLink } from 'lucide-react';
import { motion } from 'framer-motion';

const extractCode = `def get_current_weather(city):
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
            'country': (data.get('sys', {}).get('country') or '').strip().rstrip('.').upper(),
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
            'description': data.get('weather', [{}])[0].get('description'),
            'observation_timestamp': datetime.fromtimestamp(data.get('dt'), tz=pytz.utc)
        }
    except requests.exceptions.HTTPError as e:
        logger.warning(f"HTTP error for {city}: {e.response.status_code}")
    except Exception as e:
        logger.error(f"Unexpected error: {e}")

    return None`;

export const ExtractionSection = () => {
  return (
    <SectionWrapper 
      id="extraction"
      title="API Extraction Layer" 
      subtitle="Robust extraction logic fetching live weather metrics from Open-Meteo across 10 Arab cities, equipped with automatic retries and exponential backoff."
    >
      <div className="grid md:grid-cols-2 gap-12 items-center">
        <div className="space-y-8">
          <div className="flex flex-col space-y-4">
            <div className="flex items-center space-x-4 p-4 rounded-lg bg-blue-500/10 border border-blue-500/20">
              <div className="p-3 rounded-full bg-blue-500/20 text-blue-400">
                <ExternalLink size={24} />
              </div>
              <div>
                <h4 className="text-white font-bold">Open-Meteo API</h4>
                <p className="text-sm text-slate-400">Source System</p>
              </div>
            </div>
            
            <div className="flex justify-center">
              <ArrowDown className="text-slate-600 animate-bounce" />
            </div>

            <div className="flex items-center space-x-4 p-4 rounded-lg bg-purple-500/10 border border-purple-500/20">
              <div className="p-3 rounded-full bg-purple-500/20 text-purple-400">
                <Database size={24} />
              </div>
              <div>
                <h4 className="text-white font-bold">Python Requests Session</h4>
                <p className="text-sm text-slate-400">Extraction script</p>
              </div>
            </div>
          </div>

          <div className="prose prose-invert max-w-none text-slate-300">
            <p>
              The extraction layer uses the <code className="text-blue-400 bg-blue-400/10 px-1 py-0.5 rounded">requests</code> library coupled with <code className="text-purple-400 bg-purple-400/10 px-1 py-0.5 rounded">urllib3.util.retry</code> to ensure network resilience.
            </p>
            <ul className="list-disc pl-5 space-y-2 mt-4 text-sm">
              <li><strong>Resilience:</strong> Automatic retries on 500, 502, 503, and 504 status codes.</li>
              <li><strong>Normalization:</strong> Standardizes country codes and parses UTC timestamps.</li>
              <li><strong>Fault Tolerance:</strong> Wraps requests in try-except blocks ensuring pipeline continuity even if one city fails.</li>
            </ul>
          </div>
        </div>

        <motion.div 
          initial={{ opacity: 0, x: 20 }}
          whileInView={{ opacity: 1, x: 0 }}
          viewport={{ once: true }}
          className="relative"
        >
          <div className="absolute -inset-1 bg-gradient-to-r from-blue-500 to-purple-500 rounded-2xl blur opacity-20" />
          <CodeBlock 
            code={extractCode} 
            language="python" 
            filename="src/extract.py"
          />
        </motion.div>
      </div>
    </SectionWrapper>
  );
};
