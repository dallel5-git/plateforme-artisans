'use client';

import React from 'react';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import {
  ShieldCheck,
  Users,
  MessageSquare,
  FileText,
  Settings,
  Scale,
  ExternalLink,
} from 'lucide-react';
import { clsx } from 'clsx';
import { twMerge } from 'tailwind-merge';

interface NavItem {
  label: string;
  href: string;
  icon: React.ReactNode;
  badge?: number | string;
  badgeColor?: string;
}

export const AdminSidebar: React.FC<{ totalPending?: number }> = ({ totalPending = 2 }) => {
  const pathname = usePathname();

  const navigation: NavItem[] = [
    {
      label: 'Vérifications KYC',
      href: '/verifications',
      icon: <ShieldCheck className="w-5 h-5" />,
      badge: totalPending > 0 ? totalPending : undefined,
      badgeColor: 'bg-orange-500 text-white',
    },
    {
      label: 'Artisans & Fiches',
      href: '/artisans',
      icon: <Users className="w-5 h-5" />,
    },
    {
      label: 'Modération Avis',
      href: '/moderation/avis',
      icon: <MessageSquare className="w-5 h-5" />,
    },
    {
      label: 'Journal d’Audit INPDP',
      href: '/audit',
      icon: <FileText className="w-5 h-5" />,
    },
    {
      label: 'Référentiel Métiers',
      href: '/referentiel/categories',
      icon: <Settings className="w-5 h-5" />,
    },
  ];

  return (
    <aside className="w-64 bg-slate-900 text-slate-100 flex flex-col shrink-0 border-r border-slate-800 select-none">
      {/* Brand Header */}
      <div className="h-16 px-6 flex items-center justify-between border-b border-slate-800 bg-slate-950/40">
        <div className="flex items-center gap-2.5">
          <div className="w-8 h-8 rounded-lg bg-blue-600 flex items-center justify-center text-white font-black text-lg shadow-md shadow-blue-500/20">
            S
          </div>
          <div>
            <span className="font-bold text-base tracking-tight text-white">Sanaya</span>
            <span className="ml-1.5 text-xs font-semibold px-1.5 py-0.5 rounded bg-blue-900/60 text-blue-300 border border-blue-700/50">
              Admin
            </span>
          </div>
        </div>
      </div>

      {/* Navigation List */}
      <nav className="flex-1 px-3 py-4 space-y-1 overflow-y-auto">
        <div className="px-3 pb-2 text-[11px] font-bold uppercase tracking-wider text-slate-400">
          Modération & Contrôle
        </div>
        {navigation.map((item) => {
          const isActive = pathname.startsWith(item.href);
          return (
            <Link
              key={item.href}
              href={item.href}
              className={twMerge(
                clsx(
                  'flex items-center justify-between px-3 py-2.5 rounded-lg text-sm font-medium transition-colors group',
                  isActive
                    ? 'bg-blue-600 text-white shadow-sm shadow-blue-600/30'
                    : 'text-slate-300 hover:bg-slate-800/80 hover:text-white',
                ),
              )}
            >
              <div className="flex items-center gap-3">
                <span
                  className={twMerge(
                    clsx(
                      'transition-colors',
                      isActive ? 'text-white' : 'text-slate-400 group-hover:text-slate-200',
                    ),
                  )}
                >
                  {item.icon}
                </span>
                <span>{item.label}</span>
              </div>
              {item.badge !== undefined && (
                <span
                  className={twMerge(
                    clsx(
                      'text-xs font-bold px-2 py-0.5 rounded-full',
                      isActive
                        ? 'bg-white text-blue-600'
                        : item.badgeColor || 'bg-slate-700 text-slate-200',
                    ),
                  )}
                >
                  {item.badge}
                </span>
              )}
            </Link>
          );
        })}
      </nav>

      {/* Compliance Box */}
      <div className="p-4 m-3 rounded-xl bg-slate-950/60 border border-slate-800 text-xs text-slate-400">
        <div className="flex items-center gap-2 text-slate-300 font-semibold mb-1">
          <Scale className="w-4 h-4 text-emerald-400" />
          <span>Conformité INPDP</span>
        </div>
        <p className="text-[11px] leading-relaxed text-slate-400">
          Loi n° 2004-63. Tout accès aux CIN est journalisé dans la table inaltérable d’AuditLog.
        </p>
      </div>

      {/* Footer */}
      <div className="p-4 border-t border-slate-800 text-xs text-slate-400 flex items-center justify-between">
        <span>Version 1.0.0 (S2)</span>
        <a
          href="http://localhost:3000"
          target="_blank"
          rel="noopener noreferrer"
          className="flex items-center gap-1 text-slate-400 hover:text-white transition-colors"
          title="Ouvrir le portail public Sanaya"
        >
          <span>Site public</span>
          <ExternalLink className="w-3.5 h-3.5" />
        </a>
      </div>
    </aside>
  );
};
