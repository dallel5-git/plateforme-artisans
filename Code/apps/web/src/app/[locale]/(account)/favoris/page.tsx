'use client';

import React, { useState, useEffect, use } from 'react';
import Link from 'next/link';
import { Heart, Phone, Star, Settings } from 'lucide-react';
import { ProviderCard } from '@/components/ui/ProviderCard';
import { EmptyState } from '@/components/ui/EmptyState';
import { DEMO_PROVIDERS, type ProviderDetail } from '@/lib/api/demo-data';

interface PageProps {
  params: Promise<{ locale: string }>;
}

export default function FavoritesPage({ params }: PageProps) {
  const { locale } = use(params);
  const isAr = locale === 'ar';

  const [favorites, setFavorites] = useState<ProviderDetail[]>([]);
  const [isLoaded, setIsLoaded] = useState(false);

  useEffect(() => {
    try {
      const stored = localStorage.getItem('sanaya_favorites');
      if (stored) {
        const ids: string[] = JSON.parse(stored);
        const matched = DEMO_PROVIDERS.filter((p) => ids.includes(p.id));
        setFavorites(matched.length > 0 ? matched : DEMO_PROVIDERS.slice(0, 2));
      } else {
        // Démo par défaut avec 2 artisans
        setFavorites(DEMO_PROVIDERS.slice(0, 2));
      }
    } catch {
      setFavorites(DEMO_PROVIDERS.slice(0, 1));
    } finally {
      setIsLoaded(true);
    }
  }, []);

  return (
    <div className="container mx-auto px-4 py-10 space-y-8">
      {/* Account Navigation Tabs */}
      <div className="flex items-center gap-2 border-b border-slate-200 dark:border-slate-800 pb-3 overflow-x-auto">
        <Link
          href={`/${locale}/favoris`}
          className="px-4 py-2 rounded-xl text-xs font-bold whitespace-nowrap bg-blue-600 text-white flex items-center gap-2"
        >
          <Heart className="w-3.5 h-3.5 fill-white" />
          <span>{isAr ? 'حرفيوني المفضلون' : 'Mes Artisans Favoris'}</span>
        </Link>
        <Link
          href={`/${locale}/mes-contacts`}
          className="px-4 py-2 rounded-xl text-xs font-bold whitespace-nowrap text-slate-600 dark:text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-800 flex items-center gap-2"
        >
          <Phone className="w-3.5 h-3.5" />
          <span>{isAr ? 'سجل الاتصالات' : 'Historique des Contacts'}</span>
        </Link>
        <Link
          href={`/${locale}/mes-avis`}
          className="px-4 py-2 rounded-xl text-xs font-bold whitespace-nowrap text-slate-600 dark:text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-800 flex items-center gap-2"
        >
          <Star className="w-3.5 h-3.5" />
          <span>{isAr ? 'تقييماتي' : 'Mes Avis'}</span>
        </Link>
        <Link
          href={`/${locale}/parametres`}
          className="px-4 py-2 rounded-xl text-xs font-bold whitespace-nowrap text-slate-600 dark:text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-800 flex items-center gap-2"
        >
          <Settings className="w-3.5 h-3.5" />
          <span>{isAr ? 'الإعدادات' : 'Paramètres'}</span>
        </Link>
      </div>

      {/* Header */}
      <div>
        <h1 className="text-2xl font-bold text-slate-900 dark:text-white">
          {isAr ? 'الحرفيون المحفوظون' : 'Mes artisans enregistrés'}
        </h1>
        <p className="text-xs text-slate-500 mt-1">
          {isAr
            ? 'احفظ أرقام الحرفيين الموثوقين لتجدهم بسهولة عند حدوث أي طارئ في منزلك.'
            : 'Retrouvez en un clic les numéros de vos artisans de confiance pour vos urgences ou futurs travaux.'}
        </p>
      </div>

      {/* Favorites List */}
      {isLoaded && favorites.length > 0 ? (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {favorites.map((prov) => (
            <ProviderCard key={prov.id} provider={prov} locale={locale} />
          ))}
        </div>
      ) : (
        <EmptyState
          title={isAr ? 'لم تحفظ أي حرفي في المفضلة بعد' : 'Vous n’avez aucun artisan en favoris'}
          description={
            isAr
              ? 'اضغط على زر القلب في صفحة أي حرفي لحفظه والرجوع إليه بسرعة.'
              : 'Cliquez sur l’icône cœur sur les fiches des artisans pour les enregistrer dans votre carnet.'
          }
          actionLabel={isAr ? 'استكشاف الحرفيين' : 'Parcourir les artisans'}
          actionHref={`/${locale}/recherche`}
        />
      )}
    </div>
  );
}
