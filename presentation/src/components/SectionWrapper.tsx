import React from 'react';
import { motion } from 'framer-motion';

interface SectionWrapperProps {
  id?: string;
  title: string;
  subtitle?: string;
  children: React.ReactNode;
}

export const SectionWrapper: React.FC<SectionWrapperProps> = ({ id, title, subtitle, children }) => {
  return (
    <section id={id} className="py-24 px-6 md:px-12 relative overflow-hidden border-b border-white/5">
      <div className="absolute inset-0 bg-gradient-to-b from-slate-950 to-slate-900 pointer-events-none -z-10" />
      <div className="max-w-6xl mx-auto">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true, margin: "-100px" }}
          transition={{ duration: 0.6 }}
          className="mb-16 text-center"
        >
          <h2 className="text-3xl md:text-5xl font-bold bg-clip-text text-transparent bg-gradient-to-r from-blue-400 via-cyan-300 to-purple-400">
            {title}
          </h2>
          {subtitle && (
            <p className="mt-4 text-slate-400 text-lg max-w-2xl mx-auto">
              {subtitle}
            </p>
          )}
        </motion.div>
        {children}
      </div>
    </section>
  );
};
