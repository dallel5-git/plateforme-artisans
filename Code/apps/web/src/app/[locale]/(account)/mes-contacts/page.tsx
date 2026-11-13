'use client';

import React, { use } from 'react';
import Link from 'next/link';
import Image from 'next/image';
import { Heart, Phone, Star, Settings, Calendar } from 'lucide-react';
import { Button } from '@/components/ui/Button';
import { DEMO_PROVIDERS, type ProviderDetail } from '@/lib/api/demo-data';

interface PageProps {
  params: Promise<{ locale: string }>;
}

export default function ContactsHistoryPage({ params }: PageProps) {
  const { locale } = use(params);
  const isAr = locale === 'ar';

  const prov1 = DEMO_PROVIDERS[0] as ProviderDetail;
  const prov2 = (DEMO_PROVIDERS[2] || DEMO_PROVIDERS[0]) as ProviderDetail;

  const demoContacts = [
    {
      id: 'c1',
      provider: prov1,
      channel: 'PHONE' as const,
      date: '2026-11-12T14:30:00Z',
    },
    {
      id: 'c2',
      provider: prov2,
      channel: 'WHATSAPP' as const,
      date: '2026-11-10T09:15:00Z',
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
          className="px-4 py-2 rounded-xl text-xs font-bold whitespace-nowrap bg-blue-600 text-white flex items-center gap-2"
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
          {isAr ? 'سجل الحرفيين الذين تواصلت معهم' : 'Historique des artisans contactés'}
        </h1>
        <p className="text-xs text-slate-500 mt-1">
          {isAr
            ? 'تتبع تاريخ اتصالاتك ورسائلك المباشرة عبر صَنَايعِيّة لإعادة الاتصال أو تقييم الخدمة.'
            : 'Historique de vos révélations de coordonnées par téléphone ou WhatsApp.'}
        </p>
      </div>

      {/* Contacts List */}
      <div className="space-y-4 max-w-3xl">
        {demoContacts.map((contact) => (
          <div
            key={contact.id}
            className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-2xl p-5 flex flex-col sm:flex-row sm:items-center justify-between gap-4 shadow-sm"
          >
            <div className="flex items-center gap-4">
              <div className="relative w-14 h-14 rounded-2xl overflow-hidden shrink-0 border border-slate-100 dark:border-slate-800">
                <Image
                  src={contact.provider.avatarUrl}
                  alt={contact.provider.businessName}
                  fill
                  className="object-cover"
                  sizes="56px"
                />
              </div>
              <div>
                <Link
                  href={`/${locale}/artisans/${contact.provider.slug}`}
                  className="font-bold text-slate-900 dark:text-white text-base hover:text-blue-600 transition-colors"
                >
                  {contact.provider.businessName}
                </Link>
                <div className="text-xs text-blue-600 font-medium">
                  {isAr
                    ? contact.provider.primaryCategoryNameAr
                    : contact.provider.primaryCategoryNameFr}
                </div>
                <div className="flex items-center gap-3 text-[11px] text-slate-400 mt-1">
                  <span className="flex items-center gap-1">
                    <Calendar className="w-3 h-3" />
                    {new Date(contact.date).toLocaleDateString(isAr ? 'ar-TN' : 'fr-FR', {
                      day: 'numeric',
                      month: 'short',
                      hour: '2-digit',
                      minute: '2-digit',
                    })}
                  </span>
                  <span
                    className={`px-2 py-0.5 rounded text-[10px] font-bold ${
                      contact.channel === 'WHATSAPP'
                        ? 'bg-emerald-100 text-emerald-800 dark:bg-emerald-950 dark:text-emerald-300'
                        : 'bg-blue-100 text-blue-800 dark:bg-blue-950 dark:text-blue-300'
                    }`}
                  >
                    {contact.channel === 'WHATSAPP' ? 'WhatsApp' : isAr ? 'هاتف' : 'Appel direct'}
                  </span>
                </div>
              </div>
            </div>

            <div className="flex items-center gap-2">
              <Link href={`/${locale}/artisans/${contact.provider.slug}/avis`}>
                <Button variant="outline" size="sm" className="text-xs font-semibold">
                  {isAr ? 'تقييم الخدمة' : 'Noter l’artisan'}
                </Button>
              </Link>
              <a href={`tel:${contact.provider.phone}`}>
                <Button variant="primary" size="sm" className="text-xs font-bold gap-1.5">
                  <Phone className="w-3.5 h-3.5" />
                  <span>{contact.provider.phone}</span>
                </Button>
              </a>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
