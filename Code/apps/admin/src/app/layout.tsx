import React from 'react';
import type { Metadata } from 'next';
import './globals.css';

export const metadata: Metadata = {
  title: 'Sanaya Back-Office — Modération & Vérification KYC',
  description:
    'Portail de modération administrative et vérification d’identité KYC pour Sanaya Tunisie',
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="fr" className="h-full antialiased">
      <body className="h-full flex flex-col font-sans bg-slate-50 text-slate-900 dark:bg-slate-900 dark:text-slate-100">
        {children}
      </body>
    </html>
  );
}
