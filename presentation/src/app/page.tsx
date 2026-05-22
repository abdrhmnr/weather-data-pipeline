import React from 'react';
import { HeroSection } from '../components/HeroSection';
import { ETLFlowSection } from '../components/ETLFlowSection';
import { ExtractionSection } from '../components/ExtractionSection';
import { TransformationSection } from '../components/TransformationSection';
import { DatabaseSection } from '../components/DatabaseSection';
import { TeamSection } from '../components/TeamSection';

export default function Home() {
  return (
    <main className="min-h-screen bg-slate-950 text-white selection:bg-blue-500/30 font-sans">
      <HeroSection />
      
      {/* Overview Wrapper */}
      <section className="py-24 px-6 md:px-12 relative border-b border-white/5">
        <div className="max-w-6xl mx-auto">
          <div className="text-center mb-16">
            <h2 className="text-3xl md:text-5xl font-bold bg-clip-text text-transparent bg-gradient-to-r from-blue-400 via-cyan-300 to-purple-400">
              Pipeline Flow
            </h2>
            <p className="mt-4 text-slate-400 text-lg max-w-2xl mx-auto">
              A bird's-eye view of the end-to-end data lifecycle.
            </p>
          </div>
          <ETLFlowSection />
        </div>
      </section>

      <ExtractionSection />
      <TransformationSection />
      <DatabaseSection />
      <TeamSection />
      
      <footer className="py-12 text-center text-slate-500 text-sm">
        <p>WeatherFlow Project &middot; DEPI &copy; 2026</p>
      </footer>
    </main>
  );
}
