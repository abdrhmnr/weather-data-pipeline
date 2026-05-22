'use client';
import React from 'react';
import { SectionWrapper } from './SectionWrapper';
import { CodeBlock } from './CodeBlock';
import { Settings, Zap, Compass, CheckCircle } from 'lucide-react';
import { motion } from 'framer-motion';

const transformCode = `def transform_reading(self, raw_data):
    transformed = raw_data.copy()

    # 1. DATA CLEANING
    numeric_fields = ['wind_speed_ms', 'temp_avg_c', 'humidity_pct', 'pressure_hpa']
    for field in numeric_fields:
        if transformed.get(field) is None:
            transformed[field] = 0.0
            
    # Validation / Bounds Checking for temperature
    if not (-60 <= transformed['temp_avg_c'] <= 60):
        transformed['temp_avg_c'] = max(-60, min(transformed['temp_avg_c'], 60))

    # 2. DATA TRANSFORMATION
    # Unit conversions: m/s to km/h (Multiply by 3.6)
    transformed['wind_speed_kmh'] = round(transformed['wind_speed_ms'] * 3.6, 2)

    # 3. ML PREDICTION
    # Predict Rain Tomorrow (Fit to schema: BOOLEAN)
    if self.rain_model:
        features = pd.DataFrame([{
            'MinTemp': transformed['temp_min_c'],
            'MaxTemp': transformed['temp_max_c'],
            'Humidity': transformed['humidity_pct'],
            'WindGustDir': wind_dir_encoded,
            'WindGustSpeed': transformed['wind_gust_ms'],
            'Pressure': transformed['pressure_hpa'],
            'Temp': transformed['temp_avg_c']
        }])
        
        prediction = self.rain_model.predict(features)[0]
        transformed['rain_tomorrow'] = bool(prediction)
    else:
        transformed['rain_tomorrow'] = False

    return transformed`;

export const TransformationSection = () => {
  return (
    <SectionWrapper 
      id="transformation"
      title="Data Transformation & ML" 
      subtitle="Raw JSON is rigorously cleaned, normalized, and passed through a pre-trained Random Forest model to predict rainfall."
    >
      <div className="grid md:grid-cols-2 gap-12 items-center">
        
        <motion.div 
          initial={{ opacity: 0, x: -20 }}
          whileInView={{ opacity: 1, x: 0 }}
          viewport={{ once: true }}
          className="order-2 md:order-1 relative"
        >
          <div className="absolute -inset-1 bg-gradient-to-r from-cyan-500 to-blue-500 rounded-2xl blur opacity-20" />
          <CodeBlock 
            code={transformCode} 
            language="python" 
            filename="src/transform.py"
          />
        </motion.div>

        <div className="space-y-8 order-1 md:order-2">
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <div className="p-4 rounded-xl bg-white/5 border border-white/10 hover:bg-white/10 transition-colors">
              <CheckCircle className="text-green-400 mb-3" />
              <h4 className="font-bold text-white mb-1">Null Handling</h4>
              <p className="text-sm text-slate-400">Safely imputes missing numeric values to prevent database constraint failures.</p>
            </div>
            <div className="p-4 rounded-xl bg-white/5 border border-white/10 hover:bg-white/10 transition-colors">
              <Settings className="text-blue-400 mb-3" />
              <h4 className="font-bold text-white mb-1">Bounds Clamping</h4>
              <p className="text-sm text-slate-400">Restricts temperatures to physical realities (-60°C to +60°C) dropping outliers.</p>
            </div>
            <div className="p-4 rounded-xl bg-white/5 border border-white/10 hover:bg-white/10 transition-colors">
              <Compass className="text-purple-400 mb-3" />
              <h4 className="font-bold text-white mb-1">Unit Normalization</h4>
              <p className="text-sm text-slate-400">Maps 360-degree vectors to 16-point compass directions and m/s to km/h.</p>
            </div>
            <div className="p-4 rounded-xl bg-white/5 border border-white/10 hover:bg-white/10 transition-colors">
              <Zap className="text-yellow-400 mb-3" />
              <h4 className="font-bold text-white mb-1">ML Inference</h4>
              <p className="text-sm text-slate-400">Injects 'rain_tomorrow' boolean via a live scikit-learn model evaluation.</p>
            </div>
          </div>
        </div>

      </div>
    </SectionWrapper>
  );
};
