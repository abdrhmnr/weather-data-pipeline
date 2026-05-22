'use client';
import React from 'react';
import { SectionWrapper } from './SectionWrapper';
import { motion } from 'framer-motion';

const teamMembers = [
  {
    name: 'Abdelrahman',
    role: 'Data Engineer',
    responsibilities: ['API Extraction', 'Open-Meteo Integration', 'Data Collection Layer'],
    color: 'from-blue-500 to-cyan-400'
  },
  {
    name: 'Aya Farg',
    role: 'ETL Engineer',
    responsibilities: ['ETL Transformation', 'Data Cleaning', 'PostgreSQL Loading'],
    color: 'from-purple-500 to-pink-500'
  },
  {
    name: 'Rana Elamir',
    role: 'Data Architect',
    responsibilities: ['Database Schema', 'ERD Design', 'Documentation', 'Presentation Architecture'],
    color: 'from-emerald-400 to-cyan-500'
  }
];

export const TeamSection = () => {
  return (
    <SectionWrapper 
      id="team"
      title="CLS ONL4_AIS5_G2 · Group 5" 
      subtitle="A Data Engineering team delivering a real-world weather ETL platform."
    >
      <div className="grid md:grid-cols-3 gap-8 mt-12">
        {teamMembers.map((member, idx) => (
          <motion.div
            key={member.name}
            initial={{ opacity: 0, y: 30 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.5, delay: idx * 0.2 }}
            className="group relative p-[1px] rounded-2xl bg-gradient-to-b from-white/10 to-transparent hover:from-white/20 transition-all"
          >
            <div className="absolute inset-0 bg-gradient-to-br opacity-0 group-hover:opacity-20 transition-opacity rounded-2xl blur-xl -z-10" />
            <div className="bg-slate-950/80 backdrop-blur-xl rounded-2xl p-8 h-full border border-white/5">
              <div className={\`w-16 h-16 rounded-full bg-gradient-to-br \${member.color} mb-6 flex items-center justify-center text-2xl font-bold text-white shadow-lg\`}>
                {member.name.charAt(0)}
              </div>
              <h3 className="text-2xl font-bold text-white mb-1">{member.name}</h3>
              <p className="text-blue-400 font-medium mb-6">{member.role}</p>
              
              <ul className="space-y-3">
                {member.responsibilities.map((task, i) => (
                  <li key={i} className="flex items-start text-sm text-slate-300">
                    <span className="text-blue-500 mr-2">▹</span>
                    {task}
                  </li>
                ))}
              </ul>
            </div>
          </motion.div>
        ))}
      </div>
    </SectionWrapper>
  );
};
