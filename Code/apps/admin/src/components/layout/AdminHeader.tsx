'use client';

import React from 'react';
import { UserCheck, Shield, HelpCircle } from 'lucide-react';

export const AdminHeader: React.FC = () => {
  return (
    <header className="h-16 bg-white dark:bg-slate-800 border-b border-slate-200 dark:border-slate-700 px-8 flex items-center justify-between shrink-0">
      <div className="flex items-center gap-3">
        <div className="inline-flex items-center gap-2 px-2.5 py-1 rounded-md bg-blue-50 dark:bg-blue-950/60 text-blue-700 dark:text-blue-300 text-xs font-semibold border border-blue-200 dark:border-blue-800">
          <Shield className="w-3.5 h-3.5" />
          <span>Espace Modération Sécurisé (ADR-002)</span>
        </div>
      </div>

      <div className="flex items-center gap-4">
        {/* Help button */}
        <button
          className="p-2 text-slate-400 hover:text-slate-600 dark:hover:text-slate-200 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-700 transition-colors"
          title="Guide modérateur"
        >
          <HelpCircle className="w-5 h-5" />
        </button>

        {/* User profile */}
        <div className="flex items-center gap-3 pl-4 border-l border-slate-200 dark:border-slate-700">
          <div className="w-9 h-9 rounded-full bg-slate-100 dark:bg-slate-700 flex items-center justify-center text-slate-700 dark:text-slate-200 border border-slate-300 dark:border-slate-600">
            <UserCheck className="w-5 h-5 text-blue-600 dark:text-blue-400" />
          </div>
          <div className="text-left text-sm">
            <div className="font-semibold text-slate-900 dark:text-slate-100 leading-tight">
              Modérateur Sanaya
            </div>
            <div className="text-xs text-slate-500 dark:text-slate-400">Rôle : ADMIN_KYC</div>
          </div>
        </div>
      </div>
    </header>
  );
};
