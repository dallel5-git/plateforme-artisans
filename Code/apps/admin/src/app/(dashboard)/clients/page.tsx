import React from 'react';

export default function PlaceholderModulePage() {
  return (
    <div className="bg-white dark:bg-slate-800 p-8 rounded-2xl border border-slate-200 dark:border-slate-700 text-center">
      <h2 className="text-base font-bold text-slate-900 dark:text-slate-100">
        Module en cours de développement
      </h2>
      <p className="text-xs text-slate-500 mt-1">
        Ce module sera activé lors des prochains sprints du Back-Office.
      </p>
    </div>
  );
}
