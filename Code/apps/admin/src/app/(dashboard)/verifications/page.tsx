'use client';

import React, { useEffect, useState } from 'react';
import Link from 'next/link';
import {
  ShieldCheck,
  Search,
  ArrowUpDown,
  Clock,
  ChevronRight,
  FileText,
  MapPin,
  RefreshCw,
} from 'lucide-react';
import { adminApi } from '@/lib/api';
import type { AdminVerificationItem, VerificationStatus } from '@repo/validators';
import { VerificationStatusBadge, OverdueBadge, Badge } from '@/components/ui/Badge';
import { Button } from '@/components/ui/Button';
import { Skeleton } from '@/components/ui/Skeleton';

const GOVERNORATES = [
  'TOUS',
  'TUNIS',
  'ARIANA',
  'BEN_AROUS',
  'MANOUBA',
  'NABEUL',
  'ZAGHOUAN',
  'BIZERTE',
  'BEJA',
  'JENDOUBA',
  'LE_KEF',
  'SILIANA',
  'SOUSSE',
  'MONASTIR',
  'MAHDIA',
  'SFAX',
  'KAIROUAN',
  'KASSERINE',
  'SIDI_BOUZID',
  'GABES',
  'MEDENINE',
  'TATAOUINE',
  'GAFSA',
  'TOZEUR',
  'KEBILI',
];

export default function VerificationQueuePage() {
  const [items, setItems] = useState<AdminVerificationItem[]>([]);
  const [totalPending, setTotalPending] = useState<number>(0);
  const [nextCursor, setNextCursor] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState<boolean>(true);

  // Filtres
  const [statusFilter, setStatusFilter] = useState<string>('PENDING');
  const [governorateFilter, setGovernorateFilter] = useState<string>('TOUS');
  const [searchQuery, setSearchQuery] = useState<string>('');
  const [orderBy, setOrderBy] = useState<'asc' | 'desc'>('asc'); // FIFO par défaut

  const loadData = async () => {
    setIsLoading(true);
    try {
      const res = await adminApi.getVerifications({
        status: statusFilter === 'TOUS' ? undefined : (statusFilter as VerificationStatus),
        orderBy,
        limit: 25,
      });

      setItems(res.items);
      setTotalPending(res.totalPending);
      setNextCursor(res.nextCursor);
    } catch {
      // Erreur captée gracieusement
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    loadData();
  }, [statusFilter, orderBy]);

  // Filtrage local complémentaire (gouvernorat et recherche texte)
  const filteredItems = items.filter((item) => {
    if (governorateFilter !== 'TOUS' && item.provider.baseGovernorateId !== governorateFilter) {
      return false;
    }
    if (searchQuery.trim()) {
      const q = searchQuery.toLowerCase();
      const matchName = item.provider.businessName.toLowerCase().includes(q);
      const matchCin = item.fullNameOnId?.toLowerCase().includes(q);
      return matchName || matchCin;
    }
    return true;
  });

  return (
    <div className="space-y-6 max-w-7xl mx-auto">
      {/* En-tête de la page */}
      <div className="flex flex-col md:flex-row md:items-center md:justify-between gap-4 pb-4 border-b border-slate-200 dark:border-slate-800">
        <div>
          <div className="flex items-center gap-2.5">
            <h1 className="text-2xl font-bold tracking-tight text-slate-900 dark:text-slate-100">
              File de Vérification KYC
            </h1>
            <span className="px-2.5 py-0.5 rounded-full text-xs font-semibold bg-orange-100 text-orange-800 dark:bg-orange-950/80 dark:text-orange-300 border border-orange-200 dark:border-orange-800">
              {totalPending} en attente
            </span>
          </div>
          <p className="mt-1 text-sm text-slate-500 dark:text-slate-400">
            Instruction des pièces d’identité (CIN) pour l’attribution du label officiel « Artisan
            Vérifié » (ADR-002 / INPDP 2004-63).
          </p>
        </div>

        <Button
          variant="outline"
          size="sm"
          onClick={loadData}
          isLoading={isLoading}
          leftIcon={<RefreshCw className="w-4 h-4" />}
        >
          Actualiser la file
        </Button>
      </div>

      {/* Barre de Filtres & Recherche */}
      <div className="bg-white dark:bg-slate-800 p-4 rounded-xl border border-slate-200 dark:border-slate-700 shadow-sm space-y-4">
        {/* Onglets rapides par statut */}
        <div className="flex flex-wrap items-center gap-2 pb-3 border-b border-slate-100 dark:border-slate-700">
          <span className="text-xs font-semibold text-slate-400 uppercase tracking-wider mr-1">
            Statut :
          </span>
          {[
            { label: 'Tous', value: 'TOUS' },
            { label: 'En attente', value: 'PENDING' },
            { label: 'Complément requis', value: 'MORE_INFO_REQUIRED' },
            { label: 'Validés', value: 'APPROVED' },
            { label: 'Refusés', value: 'REJECTED' },
          ].map((tab) => {
            const isSelected = statusFilter === tab.value;
            return (
              <button
                key={tab.value}
                onClick={() => setStatusFilter(tab.value)}
                className={`text-xs font-medium px-3 py-1.5 rounded-lg transition-colors ${
                  isSelected
                    ? 'bg-blue-600 text-white shadow-sm'
                    : 'text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-700'
                }`}
              >
                {tab.label}
              </button>
            );
          })}
        </div>

        {/* Contrôles de filtrage */}
        <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 gap-3">
          {/* Recherche textuelle */}
          <div className="relative">
            <Search className="w-4 h-4 absolute left-3 top-3 text-slate-400" />
            <input
              type="text"
              placeholder="Rechercher artisan ou nom CIN..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="w-full pl-9 pr-3 py-2 text-sm rounded-lg border border-slate-300 dark:border-slate-600 bg-slate-50 dark:bg-slate-900 text-slate-900 dark:text-slate-100 focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>

          {/* Filtre gouvernorat */}
          <div className="relative">
            <MapPin className="w-4 h-4 absolute left-3 top-3 text-slate-400 pointer-events-none" />
            <select
              value={governorateFilter}
              onChange={(e) => setGovernorateFilter(e.target.value)}
              className="w-full pl-9 pr-3 py-2 text-sm rounded-lg border border-slate-300 dark:border-slate-600 bg-slate-50 dark:bg-slate-900 text-slate-900 dark:text-slate-100 focus:outline-none focus:ring-2 focus:ring-blue-500 appearance-none"
            >
              {GOVERNORATES.map((gov) => (
                <option key={gov} value={gov}>
                  {gov === 'TOUS' ? 'Tous les gouvernorats' : gov}
                </option>
              ))}
            </select>
          </div>

          {/* Tri FIFO / LIFO */}
          <div className="relative">
            <ArrowUpDown className="w-4 h-4 absolute left-3 top-3 text-slate-400 pointer-events-none" />
            <select
              value={orderBy}
              onChange={(e) => setOrderBy(e.target.value as 'asc' | 'desc')}
              className="w-full pl-9 pr-3 py-2 text-sm rounded-lg border border-slate-300 dark:border-slate-600 bg-slate-50 dark:bg-slate-900 text-slate-900 dark:text-slate-100 focus:outline-none focus:ring-2 focus:ring-blue-500 appearance-none"
            >
              <option value="asc">Ordre FIFO (Anciens en premier)</option>
              <option value="desc">Ordre LIFO (Récents en premier)</option>
            </select>
          </div>

          {/* Récapitulatif résultats */}
          <div className="flex items-center justify-end text-xs text-slate-500 dark:text-slate-400">
            <span>
              {filteredItems.length} demande{filteredItems.length > 1 ? 's' : ''} affichée
              {filteredItems.length > 1 ? 's' : ''}
            </span>
          </div>
        </div>
      </div>

      {/* Tableau de la file KYC */}
      <div className="bg-white dark:bg-slate-800 rounded-xl border border-slate-200 dark:border-slate-700 shadow-sm overflow-hidden">
        {isLoading ? (
          <div className="p-6 space-y-4">
            {[1, 2, 3, 4].map((i) => (
              <div key={i} className="flex items-center gap-4">
                <Skeleton className="w-12 h-12 rounded-lg" />
                <div className="flex-1 space-y-2">
                  <Skeleton className="w-1/3 h-4" />
                  <Skeleton className="w-1/4 h-3" />
                </div>
                <Skeleton className="w-24 h-6 rounded-full" />
                <Skeleton className="w-28 h-8 rounded-lg" />
              </div>
            ))}
          </div>
        ) : filteredItems.length === 0 ? (
          <div className="text-center py-16 px-4">
            <div className="w-12 h-12 rounded-full bg-slate-100 dark:bg-slate-700 text-slate-400 flex items-center justify-center mx-auto mb-3">
              <ShieldCheck className="w-6 h-6" />
            </div>
            <h3 className="text-base font-semibold text-slate-900 dark:text-slate-100">
              Aucune demande de vérification
            </h3>
            <p className="mt-1 text-sm text-slate-500 dark:text-slate-400 max-w-sm mx-auto">
              Toutes les demandes de cette sélection ont été instruites ou aucun résultat ne
              correspond à vos critères.
            </p>
            {(statusFilter !== 'TOUS' || governorateFilter !== 'TOUS' || searchQuery) && (
              <Button
                variant="outline"
                size="sm"
                className="mt-4"
                onClick={() => {
                  setStatusFilter('TOUS');
                  setGovernorateFilter('TOUS');
                  setSearchQuery('');
                }}
              >
                Réinitialiser les filtres
              </Button>
            )}
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full text-left text-sm">
              <thead className="bg-slate-50 dark:bg-slate-900/60 border-b border-slate-200 dark:border-slate-700 text-xs font-semibold text-slate-500 dark:text-slate-400 uppercase tracking-wider">
                <tr>
                  <th scope="col" className="px-6 py-3.5">
                    Artisan & Fiche Pro
                  </th>
                  <th scope="col" className="px-6 py-3.5">
                    Nom sur CIN
                  </th>
                  <th scope="col" className="px-6 py-3.5">
                    Gouvernorat
                  </th>
                  <th scope="col" className="px-6 py-3.5">
                    Date & Délai FIFO
                  </th>
                  <th scope="col" className="px-6 py-3.5">
                    Pièces (CIN)
                  </th>
                  <th scope="col" className="px-6 py-3.5">
                    Statut
                  </th>
                  <th scope="col" className="px-6 py-3.5 text-right">
                    Action
                  </th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100 dark:divide-slate-700/60">
                {filteredItems.map((item) => {
                  const date = new Date(item.submittedAt);
                  const formattedDate = date.toLocaleDateString('fr-TN', {
                    day: 'numeric',
                    month: 'short',
                    year: 'numeric',
                    hour: '2-digit',
                    minute: '2-digit',
                  });

                  return (
                    <tr
                      key={item.id}
                      className="hover:bg-slate-50/80 dark:hover:bg-slate-700/40 transition-colors"
                    >
                      {/* Artisan */}
                      <td className="px-6 py-4">
                        <div className="font-semibold text-slate-900 dark:text-slate-100">
                          {item.provider.businessName}
                        </div>
                        <div className="text-xs text-slate-500 dark:text-slate-400">
                          slug :{' '}
                          <code className="text-slate-600 dark:text-slate-300">
                            {item.provider.slug}
                          </code>
                        </div>
                      </td>

                      {/* Nom CIN */}
                      <td className="px-6 py-4">
                        <span className="font-mono text-xs font-bold text-slate-800 dark:text-slate-200 uppercase bg-slate-100 dark:bg-slate-700/60 px-2 py-1 rounded">
                          {item.fullNameOnId || '—'}
                        </span>
                      </td>

                      {/* Gouvernorat */}
                      <td className="px-6 py-4">
                        <div className="flex items-center gap-1.5 text-slate-700 dark:text-slate-300 font-medium text-xs">
                          <MapPin className="w-3.5 h-3.5 text-slate-400" />
                          <span>{item.provider.baseGovernorateId}</span>
                        </div>
                      </td>

                      {/* Date & Overdue */}
                      <td className="px-6 py-4">
                        <div className="space-y-1">
                          <div className="text-xs text-slate-600 dark:text-slate-300 flex items-center gap-1">
                            <Clock className="w-3 h-3 text-slate-400" />
                            <span>{formattedDate}</span>
                          </div>
                          <OverdueBadge submittedAt={item.submittedAt} />
                        </div>
                      </td>

                      {/* Pièces */}
                      <td className="px-6 py-4">
                        <div className="flex items-center gap-1.5">
                          <Badge variant="outline" size="sm">
                            <FileText className="w-3 h-3 text-blue-500" />
                            <span>Recto</span>
                          </Badge>
                          <Badge variant="outline" size="sm">
                            <FileText className="w-3 h-3 text-blue-500" />
                            <span>Verso</span>
                          </Badge>
                        </div>
                      </td>

                      {/* Statut */}
                      <td className="px-6 py-4">
                        <VerificationStatusBadge status={item.status} />
                      </td>

                      {/* Bouton d'instruction */}
                      <td className="px-6 py-4 text-right">
                        <Link href={`/verifications/${item.id}`}>
                          <Button
                            size="sm"
                            variant={item.status === 'PENDING' ? 'primary' : 'outline'}
                            rightIcon={<ChevronRight className="w-4 h-4" />}
                          >
                            Instruire
                          </Button>
                        </Link>
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        )}

        {/* Pagination Keyset */}
        {nextCursor && !isLoading && (
          <div className="p-4 border-t border-slate-200 dark:border-slate-700 bg-slate-50/50 dark:bg-slate-900/40 flex items-center justify-between text-xs">
            <span className="text-slate-500">Demandes supplémentaires disponibles</span>
            <Button
              variant="outline"
              size="sm"
              onClick={async () => {
                const res = await adminApi.getVerifications({
                  status:
                    statusFilter === 'TOUS' ? undefined : (statusFilter as VerificationStatus),
                  orderBy,
                  cursor: nextCursor,
                  limit: 25,
                });
                setItems((prev) => [...prev, ...res.items]);
                setNextCursor(res.nextCursor);
              }}
            >
              Charger les demandes suivantes
            </Button>
          </div>
        )}
      </div>
    </div>
  );
}
