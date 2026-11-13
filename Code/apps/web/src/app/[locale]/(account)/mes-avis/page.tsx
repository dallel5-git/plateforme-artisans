'use client';

import React, { use } from 'react';
import Link from 'next/link';
import { Heart, Phone, Star, Settings, CheckCircle2 } from 'lucide-react';
import { RatingStars } from '@/components/ui/RatingStars';
import { DEMO_PROVIDERS, type ProviderDetail } from '@/lib/api/demo-data';

interface PageProps {
  params: Promise<{ locale: string }>;
}

export default function MyReviewsPage({ params }: PageProps) {
  const { locale } = use(params);
  const isAr = locale === 'ar';

  const prov = DEMO_PROVIDERS[0] as ProviderDetail;

  const myReviews = [
    {
      id: 'rev-1',
      provider: prov,
      rating: 5,
      comment:
        'Intervention très rapide pour réparer une fuite d’eau complexe dans ma cuisine à Sousse. Travail très soigné, ponctuel et tarif honnête sans mauvaise surprise.',
      date: '2026-11-11T16:00:00Z',
    },
  ];

  return (
    <div className="container mx-auto px-4 py-10 space-y-8">
      {/* Account Navigation Tabs */}
      <div className="flex items-center gap-2 border-b border-slate-200 dark:border-slate-800 pb-3 overflow-x-auto">
        <Link
          href={`/${locale}/favoris`}
          className="px-4 py-2 rounded-xl text-xs font-bold whitespace-nowrap text-slate-600 dark:text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-800 flex items-center gap-2"
        >
          <Heart className="w-3.5 h-3.5" />
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
          className="px-4 py-2 rounded-xl text-xs font-bold whitespace-nowrap bg-blue-600 text-white flex items-center gap-2"
        >
          <Star className="w-3.5 h-3.5 fill-white" />
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
          {isAr ? 'التقييمات التي نشرتها' : 'Mes avis publiés'}
        </h1>
        <p className="text-xs text-slate-500 mt-1">
          {isAr
            ? 'تساعد تقييماتك الصادقة آلاف العائلات في الساحل على اختيار أفضل الحرفيين الموثوقين.'
            : 'Vos retours d’expérience aident les habitants de votre ville à trouver les meilleurs dépanneurs.'}
        </p>
      </div>

      {/* Reviews List */}
      <div className="space-y-4 max-w-3xl">
        {myReviews.map((rev) => (
          <div
            key={rev.id}
            className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-2xl p-6 space-y-3 shadow-sm"
          >
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-2 pb-3 border-b border-slate-100 dark:border-slate-800">
              <div>
                <Link
                  href={`/${locale}/artisans/${rev.provider.slug}`}
                  className="font-bold text-slate-900 dark:text-white text-base hover:text-blue-600"
                >
                  {rev.provider.businessName}
                </Link>
                <div className="text-xs text-blue-600">
                  {isAr ? rev.provider.primaryCategoryNameAr : rev.provider.primaryCategoryNameFr} •{' '}
                  {isAr ? rev.provider.baseGovernorateNameAr : rev.provider.baseGovernorateNameFr}
                </div>
              </div>
              <div className="flex items-center gap-3">
                <RatingStars rating={rev.rating} size={16} />
                <span className="text-[11px] text-slate-400">
                  {new Date(rev.date).toLocaleDateString(isAr ? 'ar-TN' : 'fr-FR', {
                    day: 'numeric',
                    month: 'short',
                    year: 'numeric',
                  })}
                </span>
              </div>
            </div>

            <p className="text-slate-700 dark:text-slate-300 text-sm leading-relaxed">
              « {rev.comment} »
            </p>

            <div className="flex items-center gap-1.5 text-xs text-emerald-600 font-medium pt-1">
              <CheckCircle2 className="w-3.5 h-3.5" />
              <span>{isAr ? 'تقييم منشور وموثق' : 'Avis public vérifié par Sanaya'}</span>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
