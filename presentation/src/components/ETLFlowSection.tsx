'use client';
import React from 'react';
import { motion } from 'framer-motion';
import { CloudRain, Filter, RefreshCw, Database, Clock, Activity, BarChart } from 'lucide-react';

const FlowCard = ({ title, description, icon, delay }: { title: string, description: string, icon: React.ReactNode, delay: number }) => (
  <motion.div
    initial={{ opacity: 0, y: 30 }}
    whileInView={{ opacity: 1, y: 0 }}
    viewport={{ once: true }}
    transition={{ duration: 0.5, delay }}
    className="relative p-6 rounded-xl border border-white/10 bg-slate-900/50 backdrop-blur-sm z-10 hover:bg-slate-800/50 transition-colors group"
  >
    <div className="absolute inset-0 bg-gradient-to-r from-blue-500/10 to-purple-500/10 opacity-0 group-hover:opacity-100 transition-opacity rounded-xl -z-10" />
    <div className="w-12 h-12 rounded-lg bg-blue-500/20 text-blue-400 flex items-center justify-center mb-4">
      {icon}
    </div>
    <h3 className="text-xl font-bold text-white mb-2">{title}</h3>
    <p className="text-slate-400 text-sm leading-relaxed">{description}</p>
  </motion.div>
);

const Connector = () => (
  <div className="hidden md:flex flex-col items-center justify-center w-8">
    <div className="w-0.5 h-12 bg-gradient-to-b from-blue-500/50 to-purple-500/50" />
    <motion.div 
      initial={{ scale: 0 }}
      whileInView={{ scale: 1 }}
      className="w-2 h-2 rounded-full bg-blue-400 my-2 shadow-[0_0_10px_rgba(96,165,250,0.8)]" 
    />
    <div className="w-0.5 h-12 bg-gradient-to-b from-purple-500/50 to-cyan-500/50" />
  </div>
);

export const ETLFlowSection = () => {
  return (
    <div className="py-12">
      <div className="max-w-3xl mx-auto flex flex-col md:flex-row md:items-start items-center space-y-6 md:space-y-0 md:space-x-4">
        <div className="flex-1 space-y-12">
          <FlowCard 
            title="API Extraction" 
            description="Extracts live weather metrics from Open-Meteo for 10 Arab cities using robust retry policies." 
            icon={<CloudRain />} 
            delay={0.1}
          />
          <Connector />
          <FlowCard 
            title="Data Cleaning" 
            description="Normalizes timestamps, imputes missing values, and clamps invalid temperature extremes." 
            icon={<Filter />} 
            delay={0.3}
          />
          <Connector />
          <FlowCard 
            title="Transformation" 
            description="Converts m/s to km/h, applies 16-point wind directions, and executes ML rain prediction." 
            icon={<RefreshCw />} 
            delay={0.5}
          />
          <Connector />
          <FlowCard 
            title="PostgreSQL Loading" 
            description="Idempotent upserts ensuring data integrity and zero duplication across pipeline runs." 
            icon={<Database />} 
            delay={0.7}
          />
        </div>

        <div className="flex-1 space-y-12 mt-12 md:mt-24">
          <FlowCard 
            title="Automated Scheduling" 
            description="Cron-based execution running hourly intervals inside the Docker environment." 
            icon={<Clock />} 
            delay={0.2}
          />
          <Connector />
          <FlowCard 
            title="Monitoring & Logging" 
            description="Captures success/failure rates, rejected row counts, and API response metrics." 
            icon={<Activity />} 
            delay={0.4}
          />
          <Connector />
          <FlowCard 
            title="Analytics Dashboard" 
            description="Serves downstream analytics models, business intelligence tools, and custom dashboards." 
            icon={<BarChart />} 
            delay={0.6}
          />
        </div>
      </div>
    </div>
  );
};
