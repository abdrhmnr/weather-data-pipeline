'use client';
import React from 'react';
import { motion } from 'framer-motion';
import { Database, Server, Activity, Terminal } from 'lucide-react';

export const HeroSection = () => {
  return (
    <section className="relative min-h-screen flex items-center justify-center overflow-hidden pt-20 pb-32">
      {/* Background gradients */}
      <div className="absolute inset-0 bg-slate-950 -z-20" />
      <div className="absolute inset-0 bg-[radial-gradient(circle_at_center,rgba(56,189,248,0.08)_0%,rgba(15,23,42,0)_50%)] -z-10" />
      <div className="absolute top-1/4 left-1/4 w-96 h-96 bg-blue-600/20 rounded-full blur-3xl -z-10 animate-pulse" />
      <div className="absolute bottom-1/4 right-1/4 w-96 h-96 bg-purple-600/20 rounded-full blur-3xl -z-10 animate-pulse" style={{ animationDelay: '1s' }} />

      <div className="max-w-7xl mx-auto px-6 relative z-10 w-full">
        <div className="text-center max-w-4xl mx-auto">
          <motion.div
            initial={{ opacity: 0, scale: 0.9 }}
            animate={{ opacity: 1, scale: 1 }}
            transition={{ duration: 0.8, ease: "easeOut" }}
          >
            <div className="inline-flex items-center space-x-2 px-3 py-1 rounded-full bg-blue-500/10 border border-blue-500/20 text-blue-400 mb-8">
              <Activity size={16} className="animate-pulse" />
              <span className="text-sm font-medium">System Online • Live Data Feed Active</span>
            </div>
          </motion.div>
          
          <motion.h1 
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.8, delay: 0.2 }}
            className="text-5xl md:text-7xl font-extrabold tracking-tight mb-6 text-white"
          >
            Weather data, <br className="hidden md:block" />
            <span className="text-transparent bg-clip-text bg-gradient-to-r from-blue-400 via-cyan-400 to-purple-500">
              engineered end-to-end.
            </span>
          </motion.h1>

          <motion.p 
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.8, delay: 0.4 }}
            className="text-xl md:text-2xl text-slate-400 mb-12 max-w-2xl mx-auto leading-relaxed"
          >
            Production-grade ETL pipelines powered by Python, PostgreSQL, Docker, and automated workflows.
          </motion.p>

          <motion.div 
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.8, delay: 0.6 }}
            className="flex flex-wrap justify-center gap-4"
          >
            <a href="#pipeline" className="px-8 py-4 rounded-lg bg-white text-slate-950 font-bold hover:bg-slate-200 transition-colors shadow-[0_0_20px_rgba(255,255,255,0.3)]">
              Explore Pipeline
            </a>
            <a href="#architecture" className="px-8 py-4 rounded-lg bg-slate-800/50 text-white font-medium border border-slate-700 hover:bg-slate-800 transition-colors backdrop-blur-sm">
              View Architecture
            </a>
          </motion.div>
        </div>

        {/* Metrics Bar */}
        <motion.div 
          initial={{ opacity: 0, y: 40 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 1, delay: 1 }}
          className="mt-24 grid grid-cols-2 md:grid-cols-4 gap-4 max-w-4xl mx-auto"
        >
          {[
            { label: "Cities Tracked", value: "10", icon: <Database className="text-blue-400 mb-2" /> },
            { label: "Daily Records", value: "240+", icon: <Activity className="text-cyan-400 mb-2" /> },
            { label: "Automated Workflows", value: "Hourly", icon: <Terminal className="text-purple-400 mb-2" /> },
            { label: "Infrastructure", value: "Docker", icon: <Server className="text-blue-300 mb-2" /> },
          ].map((metric, i) => (
            <div key={i} className="p-6 rounded-2xl bg-white/5 border border-white/10 backdrop-blur-md flex flex-col items-center justify-center text-center hover:bg-white/10 transition-colors cursor-default">
              {metric.icon}
              <div className="text-2xl font-bold text-white mb-1">{metric.value}</div>
              <div className="text-xs text-slate-400 uppercase tracking-wider">{metric.label}</div>
            </div>
          ))}
        </motion.div>
      </div>
    </section>
  );
};
