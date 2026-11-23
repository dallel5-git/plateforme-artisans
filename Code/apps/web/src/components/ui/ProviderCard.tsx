'use client';

import React, { useState } from 'react';
import Link from 'next/link';
import Image from 'next/image';
import { MapPin, Phone, MessageCircle, ShieldCheck, Zap } from 'lucide-react';
import { RatingStars } from './RatingStars';
import { Button } from './Button';
import { sanayaApi } from '@/lib/api/client';
import type { ProviderDetail } from '@/lib/api/demo-data';

export interface ProviderCardProps {
  provider: ProviderDetail;
  locale: string;
}

export const ProviderCard: React.FC<ProviderCardProps> = ({ provider, locale }) => {
  const [revealedPhone, setRevealedPhone] = useState<string | null>(null);
  const [isLoadingPhone, setIsLoadingPhone] = useState(false);
  const isAr = locale === 'ar';

  const categoryName = isAr ? provider.primaryCategoryNameAr : provider.primaryCategoryNameFr;
  const governorateName = isAr ? provider.baseGovernorateNameAr : provider.baseGovernorateNameFr;
  const delegationName = isAr ? provider.baseDelegationNameAr : provider.baseDelegationNameFr;

  const minPrice =
    provider.offerings.length > 0
      ? Math.min(...provider.offerings.map((o) => o.priceStartingAt)) / 1000
      : null;

  const handleRevealContact = async (channel: 'PHONE' | 'WHATSAPP') => {
    setIsLoadingPhone(true);
    try {
      const res = await sanayaApi.recordContactEvent({
        providerId: provider.id,
        channel,
      });
      setRevealedPhone(res.phone);

      if (channel === 'WHATSAPP') {
        const cleanPhone = res.phone.replace(/[^0-9]/g, '');
        window.open(
          `https://wa.me/${cleanPhone}?text=${encodeURIComponent(res.whatsappMessage)}`,
          '_blank',
        );
      } else {
        window.location.href = `tel:${res.phone}`;
      }
    } finally {
      setIsLoadingPhone(false);
    }
  };

  return (
    <div className="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 p-5 shadow-sm hover:shadow-md transition-all duration-200 flex flex-col justify-between">
      <div>
        {/* Header de la carte : Avatar + Badges + Nom */}
        <div className="flex items-start gap-4 mb-3">
          <div className="relative w-16 h-16 rounded-full overflow-hidden shrink-0 border-2 border-slate-100 dark:border-slate-800 bg-slate-100">
            <Image
              src={provider.avatarUrl}
              alt={provider.businessName}
              fill
              className="object-cover"
              sizes="64px"
            />
          </div>
          <div className="flex-1 min-w-0">
            <div className="flex items-center gap-2 flex-wrap mb-1">
              <span className="text-xs font-semibold px-2 py-0.5 rounded bg-blue-50 dark:bg-blue-950/60 text-blue-700 dark:text-blue-300">
                {categoryName}
              </span>
              {provider.isVerified && (
                <span className="inline-flex items-center gap-1 text-[11px] font-medium text-emerald-700 dark:text-emerald-400">
                  <ShieldCheck className="w-3.5 h-3.5" />
                  {isAr ? 'موثوق' : 'Vérifié'}
                </span>
              )}
              {provider.acceptsEmergency && (
                <span className="inline-flex items-center gap-1 text-[11px] font-medium text-amber-600 dark:text-amber-400">
                  <Zap className="w-3 h-3 fill-amber-500" />
                  {isAr ? '24/7 طوارئ' : '24/7 Urgence'}
                </span>
              )}
            </div>
            <Link
              href={`/${locale}/artisans/${provider.slug}`}
              className="font-bold text-base text-slate-900 dark:text-white hover:text-blue-600 transition-colors line-clamp-1"
            >
              {provider.businessName}
            </Link>
            <div className="flex items-center gap-1 text-xs text-slate-500 dark:text-slate-400 mt-0.5">
              <MapPin className="w-3.5 h-3.5 text-slate-400 shrink-0" />
              <span>
                {delegationName}, {governorateName}
              </span>
            </div>
          </div>
        </div>

        {/* Note & Avis */}
        <div className="flex items-center justify-between mb-3 pt-2 border-t border-slate-100 dark:border-slate-800">
          <RatingStars rating={provider.ratingAvg} count={provider.ratingCount} size="sm" />
          {minPrice !== null && (
            <span className="text-xs font-semibold text-slate-700 dark:text-slate-300">
              {isAr ? `من ${minPrice} د.ت` : `Dès ${minPrice} TND`}
            </span>
          )}
        </div>

        {/* Headline */}
        <p className="text-xs text-slate-600 dark:text-slate-400 line-clamp-2 mb-4 leading-relaxed">
          {provider.headline}
        </p>
      </div>

      {/* Actions */}
      <div className="flex items-center gap-2 pt-3 border-t border-slate-100 dark:border-slate-800">
        <Link href={`/${locale}/artisans/${provider.slug}`} className="flex-1">
          <Button variant="outline" size="sm" className="w-full text-xs">
            {isAr ? 'عرض الملف' : 'Voir le profil'}
          </Button>
        </Link>
        <Button
          variant="whatsapp"
          size="sm"
          className="px-2.5"
          onClick={() => handleRevealContact('WHATSAPP')}
          title={isAr ? 'واتساب' : 'WhatsApp'}
          aria-label="WhatsApp"
        >
          <MessageCircle className="w-4 h-4" />
        </Button>
        <Button
          variant="primary"
          size="sm"
          className="px-2.5"
          isLoading={isLoadingPhone}
          onClick={() => handleRevealContact('PHONE')}
          title={isAr ? 'اتصال' : 'Appeler'}
          aria-label="Appeler"
        >
          <Phone className="w-4 h-4" />
        </Button>
      </div>

      {revealedPhone && (
        <div className="mt-2 p-2 bg-emerald-50 dark:bg-emerald-950/40 rounded text-center text-xs font-semibold text-emerald-800 dark:text-emerald-300">
          {revealedPhone}
        </div>
      )}
    </div>
  );
};
