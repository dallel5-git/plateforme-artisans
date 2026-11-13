'use client';

import React, { useState } from 'react';
import Image from 'next/image';
import Link from 'next/link';
import {
  Phone,
  MessageCircle,
  ShieldCheck,
  Zap,
  MapPin,
  Clock,
  Award,
  CheckCircle2,
  Share2,
  Heart,
  X,
  Star,
} from 'lucide-react';
import { RatingStars } from '@/components/ui/RatingStars';
import { Button } from '@/components/ui/Button';
import { sanayaApi } from '@/lib/api/client';
import type { ProviderDetail } from '@/lib/api/demo-data';

interface ArtisanProfileClientProps {
  provider: ProviderDetail;
  locale: string;
}

export function ArtisanProfileClient({ provider, locale }: ArtisanProfileClientProps) {
  const isAr = locale === 'ar';
  const [revealedPhone, setRevealedPhone] = useState<string | null>(null);
  const [isLoadingContact, setIsLoadingContact] = useState(false);
  const [activeGalleryImg, setActiveGalleryImg] = useState<string | null>(null);
  const [isCopied, setIsCopied] = useState(false);
  const [isFavorite, setIsFavorite] = useState(false);

  const categoryName = isAr ? provider.primaryCategoryNameAr : provider.primaryCategoryNameFr;
  const governorateName = isAr ? provider.baseGovernorateNameAr : provider.baseGovernorateNameFr;
  const delegationName = isAr ? provider.baseDelegationNameAr : provider.baseDelegationNameFr;

  const handleContact = async (channel: 'PHONE' | 'WHATSAPP') => {
    setIsLoadingContact(true);
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
      setIsLoadingContact(false);
    }
  };

  const handleShare = () => {
    if (navigator.share) {
      navigator
        .share({
          title: `${provider.businessName} - Sanaya`,
          text: `Découvrez le profil de ${provider.businessName} sur Sanaya`,
          url: window.location.href,
        })
        .catch(() => {});
    } else {
      navigator.clipboard.writeText(window.location.href);
      setIsCopied(true);
      setTimeout(() => setIsCopied(false), 2000);
    }
  };

  const toggleFavorite = () => {
    setIsFavorite(!isFavorite);
    // Persist in localStorage for customer space
    try {
      const stored = localStorage.getItem('sanaya_favorites') || '[]';
      let favs: string[] = JSON.parse(stored);
      if (favs.includes(provider.id)) {
        favs = favs.filter((id) => id !== provider.id);
      } else {
        favs.push(provider.id);
      }
      localStorage.setItem('sanaya_favorites', JSON.stringify(favs));
    } catch {
      // LocalStorage fallback
    }
  };

  return (
    <div className="space-y-8">
      {/* Profile Header Card */}
      <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-3xl overflow-hidden shadow-sm">
        {/* Cover Banner */}
        <div className="h-44 md:h-64 bg-gradient-to-r from-blue-700 via-blue-800 to-indigo-900 relative">
          <div className="absolute inset-0 bg-black/20" />
          <div className="absolute top-4 end-4 flex items-center gap-2">
            <button
              type="button"
              onClick={handleShare}
              className="p-2.5 rounded-full bg-white/20 backdrop-blur-md text-white hover:bg-white/30 transition-colors"
              title={isAr ? 'مشاركة' : 'Partager'}
            >
              <Share2 className="w-4 h-4" />
            </button>
            <button
              type="button"
              onClick={toggleFavorite}
              className={`p-2.5 rounded-full backdrop-blur-md transition-colors ${
                isFavorite
                  ? 'bg-rose-500 text-white'
                  : 'bg-white/20 text-white hover:bg-white/30'
              }`}
              title={isAr ? 'حفظ في المفضلة' : 'Ajouter aux favoris'}
            >
              <Heart className={`w-4 h-4 ${isFavorite ? 'fill-white' : ''}`} />
            </button>
          </div>
          {isCopied && (
            <div className="absolute top-16 end-4 px-3 py-1.5 rounded-lg bg-black/80 text-white text-xs font-medium">
              {isAr ? 'تم نسخ الرابط!' : 'Lien copié dans le presse-papier !'}
            </div>
          )}
        </div>

        {/* Profile Content Bar */}
        <div className="px-6 md:px-10 pb-8 pt-0 relative">
          <div className="flex flex-col md:flex-row md:items-end justify-between gap-6 -mt-16 md:-mt-20 mb-6">
            {/* Avatar & Badges */}
            <div className="flex items-end gap-5">
              <div className="relative w-28 h-28 md:w-36 md:h-36 rounded-2xl md:rounded-3xl overflow-hidden border-4 border-white dark:border-slate-900 shadow-xl bg-slate-100 dark:bg-slate-800 shrink-0">
                <Image
                  src={provider.avatarUrl}
                  alt={provider.businessName}
                  fill
                  className="object-cover"
                  sizes="144px"
                  priority
                />
              </div>

              <div className="space-y-1 mb-2">
                <div className="flex items-center gap-2 flex-wrap">
                  <span className="px-2.5 py-0.5 rounded-full text-xs font-bold bg-blue-100 dark:bg-blue-950 text-blue-700 dark:text-blue-300">
                    {categoryName}
                  </span>
                  {provider.isVerified && (
                    <span className="inline-flex items-center gap-1 text-xs font-semibold px-2 py-0.5 rounded-full bg-emerald-100 dark:bg-emerald-950 text-emerald-800 dark:text-emerald-300">
                      <ShieldCheck className="w-3.5 h-3.5" />
                      {isAr ? 'حرفي موثق' : 'Artisan Vérifié'}
                    </span>
                  )}
                  {provider.acceptsEmergency && (
                    <span className="inline-flex items-center gap-1 text-xs font-semibold px-2 py-0.5 rounded-full bg-amber-100 dark:bg-amber-950 text-amber-800 dark:text-amber-300">
                      <Zap className="w-3.5 h-3.5 fill-amber-500" />
                      {isAr ? 'تدخل عاجل 24/7' : 'Urgence 24/7'}
                    </span>
                  )}
                </div>

                <h1 className="text-2xl md:text-3xl font-extrabold text-slate-900 dark:text-white">
                  {provider.businessName}
                </h1>
                <p className="text-slate-600 dark:text-slate-400 text-sm md:text-base font-medium">
                  {provider.headline}
                </p>
              </div>
            </div>

            {/* Direct Contact Buttons (Desktop) */}
            <div className="flex items-center gap-3">
              <Button
                variant="primary"
                size="lg"
                onClick={() => handleContact('PHONE')}
                disabled={isLoadingContact}
                className="flex items-center gap-2.5 font-bold shadow-md shadow-blue-500/20"
              >
                <Phone className="w-5 h-5" />
                <span>
                  {revealedPhone ? revealedPhone : isAr ? 'اتصال مباشر' : 'Appeler l’artisan'}
                </span>
              </Button>

              <Button
                variant="outline"
                size="lg"
                onClick={() => handleContact('WHATSAPP')}
                disabled={isLoadingContact}
                className="flex items-center gap-2.5 font-bold border-emerald-500 text-emerald-700 dark:text-emerald-400 hover:bg-emerald-50 dark:hover:bg-emerald-950/40"
              >
                <MessageCircle className="w-5 h-5 text-emerald-600" />
                <span>WhatsApp</span>
              </Button>
            </div>
          </div>

          {/* Location & Quick Meta Row */}
          <div className="grid grid-cols-2 sm:grid-cols-4 gap-4 py-4 border-y border-slate-100 dark:border-slate-800 text-sm">
            <div className="flex items-center gap-2.5 text-slate-600 dark:text-slate-400">
              <MapPin className="w-4 h-4 text-blue-600 shrink-0" />
              <div>
                <div className="text-[11px] text-slate-400 uppercase font-semibold">
                  {isAr ? 'المقر الرئيسي' : 'Localisation'}
                </div>
                <div className="font-semibold text-slate-900 dark:text-white text-xs">
                  {delegationName}, {governorateName}
                </div>
              </div>
            </div>

            <div className="flex items-center gap-2.5 text-slate-600 dark:text-slate-400">
              <Star className="w-4 h-4 text-amber-500 fill-amber-500 shrink-0" />
              <div>
                <div className="text-[11px] text-slate-400 uppercase font-semibold">
                  {isAr ? 'التقييم العام' : 'Avis clients'}
                </div>
                <div className="font-semibold text-slate-900 dark:text-white text-xs flex items-center gap-1">
                  <span>{provider.ratingAvg.toFixed(1)} / 5</span>
                  <span className="text-slate-400">({provider.ratingCount})</span>
                </div>
              </div>
            </div>

            <div className="flex items-center gap-2.5 text-slate-600 dark:text-slate-400">
              <Clock className="w-4 h-4 text-blue-600 shrink-0" />
              <div>
                <div className="text-[11px] text-slate-400 uppercase font-semibold">
                  {isAr ? 'سرعة الاستجابة' : 'Délai de réponse'}
                </div>
                <div className="font-semibold text-slate-900 dark:text-white text-xs">
                  {isAr ? 'أقل من 30 دقيقة' : '< 30 minutes'}
                </div>
              </div>
            </div>

            <div className="flex items-center gap-2.5 text-slate-600 dark:text-slate-400">
              <Award className="w-4 h-4 text-blue-600 shrink-0" />
              <div>
                <div className="text-[11px] text-slate-400 uppercase font-semibold">
                  {isAr ? 'الخبرة الميدانية' : 'Expérience'}
                </div>
                <div className="font-semibold text-slate-900 dark:text-white text-xs">
                  {isAr ? 'أكثر من 8 سنوات' : '+8 ans d’activité'}
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Grid: Main Details (Left) + Pricing/Sticky Contact (Right) */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        {/* Left Column: Bio, Zones, Portfolio, Reviews */}
        <div className="lg:col-span-2 space-y-8">
          {/* Bio / À propos */}
          <section className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-3xl p-6 md:p-8 space-y-4">
            <h2 className="text-lg font-bold text-slate-900 dark:text-white">
              {isAr ? 'نبذة عن الحرفي والخدمات' : 'À propos de cet artisan'}
            </h2>
            <p className="text-slate-700 dark:text-slate-300 leading-relaxed text-sm md:text-base whitespace-pre-line">
              {provider.bio}
            </p>

            <div className="pt-4 border-t border-slate-100 dark:border-slate-800 grid grid-cols-1 sm:grid-cols-2 gap-3 text-xs">
              <div className="flex items-center gap-2 text-slate-700 dark:text-slate-300">
                <CheckCircle2 className="w-4 h-4 text-emerald-600" />
                <span>{isAr ? 'ضمان العمل المتقن والتشطيب' : 'Garantie de travail soigné'}</span>
              </div>
              <div className="flex items-center gap-2 text-slate-700 dark:text-slate-300">
                <CheckCircle2 className="w-4 h-4 text-emerald-600" />
                <span>{isAr ? 'فحص أولي وتسعيرة واضحة' : 'Devis clair avant intervention'}</span>
              </div>
              <div className="flex items-center gap-2 text-slate-700 dark:text-slate-300">
                <CheckCircle2 className="w-4 h-4 text-emerald-600" />
                <span>{isAr ? 'معدات فحص واكتشاف حديثة' : 'Outillage professionnel adapté'}</span>
              </div>
              <div className="flex items-center gap-2 text-slate-700 dark:text-slate-300">
                <CheckCircle2 className="w-4 h-4 text-emerald-600" />
                <span>{isAr ? 'التزام بالمواعيد المحددة' : 'Ponctualité et respect des délais'}</span>
              </div>
            </div>
          </section>

          {/* Offerings / Prestations détaillées */}
          {provider.offerings.length > 0 && (
            <section className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-3xl p-6 md:p-8 space-y-5">
              <div className="flex items-center justify-between">
                <h2 className="text-lg font-bold text-slate-900 dark:text-white">
                  {isAr ? 'الخدمات والأسعار التقديرية' : 'Prestations et tarifs indicatifs'}
                </h2>
                <span className="text-xs text-slate-500">
                  {isAr ? 'بالدينار التونسي (DT)' : 'En Dinars Tunisiens (DT)'}
                </span>
              </div>

              <div className="divide-y divide-slate-100 dark:divide-slate-800">
                {provider.offerings.map((off) => (
                  <div key={off.id} className="py-3.5 flex items-start justify-between gap-4">
                    <div>
                      <h3 className="font-semibold text-slate-900 dark:text-white text-sm">
                        {isAr ? off.titleAr : off.titleFr}
                      </h3>
                      {(isAr ? off.descriptionAr : off.descriptionFr) && (
                        <p className="text-xs text-slate-500 dark:text-slate-400 mt-0.5">
                          {isAr ? off.descriptionAr : off.descriptionFr}
                        </p>
                      )}
                    </div>
                    <div className="text-end shrink-0">
                      <div className="font-extrabold text-blue-600 dark:text-blue-400 text-sm">
                        {isAr ? `ابتداءً من ${off.priceStartingAt / 1000} د.ت` : `À partir de ${off.priceStartingAt / 1000} DT`}
                      </div>
                      <div className="text-[11px] text-slate-400">
                        {isAr ? 'بدون قطع الغيار' : 'Hors fournitures'}
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            </section>
          )}

          {/* Portfolio Photos Gallery */}
          {provider.portfolio.length > 0 && (
            <section className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-3xl p-6 md:p-8 space-y-4">
              <h2 className="text-lg font-bold text-slate-900 dark:text-white">
                {isAr ? 'معرض الأعمال السابقة' : 'Réalisations récentes'}
              </h2>
              <div className="grid grid-cols-2 sm:grid-cols-3 gap-3">
                {provider.portfolio.map((photo, idx) => (
                  <button
                    key={photo.id || idx}
                    type="button"
                    onClick={() => setActiveGalleryImg(photo.url)}
                    className="relative aspect-square rounded-2xl overflow-hidden group focus:outline-none focus:ring-2 focus:ring-blue-500"
                  >
                    <Image
                      src={photo.url}
                      alt={photo.caption || `Chantier ${provider.businessName}`}
                      fill
                      className="object-cover group-hover:scale-105 transition-transform duration-300"
                      sizes="(max-width: 640px) 50vw, 33vw"
                    />
                    <div className="absolute inset-0 bg-black/0 group-hover:bg-black/30 transition-colors flex items-center justify-center">
                      <span className="text-white text-xs font-bold opacity-0 group-hover:opacity-100 transition-opacity bg-black/60 px-2.5 py-1 rounded-full">
                        {isAr ? 'تكبير' : 'Agrandir'}
                      </span>
                    </div>
                  </button>
                ))}
              </div>
            </section>
          )}

          {/* Customer Reviews Section */}
          <section
            id="avis"
            className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-3xl p-6 md:p-8 space-y-6"
          >
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-4 border-b border-slate-100 dark:border-slate-800">
              <div>
                <h2 className="text-lg font-bold text-slate-900 dark:text-white">
                  {isAr
                    ? `تقييمات الحرفاء (${provider.ratingCount})`
                    : `Avis clients vérifiés (${provider.ratingCount})`}
                </h2>
                <div className="flex items-center gap-2 mt-1">
                  <RatingStars rating={provider.ratingAvg} size={18} />
                  <span className="font-extrabold text-sm text-slate-900 dark:text-white">
                    {provider.ratingAvg.toFixed(1)} / 5
                  </span>
                </div>
              </div>

              <Link href={`/${locale}/artisans/${provider.slug}/avis`}>
                <Button variant="outline" size="sm" className="font-bold">
                  {isAr ? 'أضف تقييمك' : 'Donner mon avis'}
                </Button>
              </Link>
            </div>

            {/* Reviews List */}
            {provider.reviews.length > 0 ? (
              <div className="space-y-4">
                {provider.reviews.map((rev) => (
                  <div
                    key={rev.id}
                    className="p-4 rounded-2xl bg-slate-50 dark:bg-slate-800/50 space-y-2 border border-slate-100 dark:border-slate-800"
                  >
                    <div className="flex items-center justify-between">
                      <div className="flex items-center gap-2">
                        <div className="w-8 h-8 rounded-full bg-blue-100 dark:bg-blue-900/60 text-blue-700 dark:text-blue-300 font-bold flex items-center justify-center text-xs">
                          {rev.authorName.charAt(0)}
                        </div>
                        <div>
                          <div className="font-bold text-xs text-slate-900 dark:text-white flex items-center gap-1.5">
                            <span>{rev.authorName}</span>
                            {rev.isVerifiedContact && (
                              <span className="text-[10px] text-emerald-600 dark:text-emerald-400 font-medium flex items-center gap-0.5">
                                <CheckCircle2 className="w-3 h-3" />
                                {isAr ? 'عميل موثق' : 'Client vérifié'}
                              </span>
                            )}
                          </div>
                          <div className="text-[10px] text-slate-400">
                            {new Date(rev.createdAt).toLocaleDateString(locale === 'ar' ? 'ar-TN' : 'fr-FR', {
                              year: 'numeric',
                              month: 'long',
                              day: 'numeric',
                            })}
                          </div>
                        </div>
                      </div>
                      <RatingStars rating={rev.rating} size={14} />
                    </div>

                    <p className="text-slate-700 dark:text-slate-300 text-xs md:text-sm leading-relaxed">
                      {rev.comment}
                    </p>
                  </div>
                ))}
              </div>
            ) : (
              <div className="text-center py-8 text-slate-500 text-xs">
                {isAr
                  ? 'لم يتم تسجيل تقييمات بعد لهذا الحرفي. كن أول من يشارك تجربته!'
                  : 'Aucun avis publié pour le moment. Soyez le premier client à laisser un avis après intervention !'}
              </div>
            )}
          </section>
        </div>

        {/* Right Sidebar: Service Areas & Guarantees */}
        <div className="space-y-6">
          {/* Zones d'intervention */}
          <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-3xl p-6 space-y-4">
            <h3 className="font-bold text-slate-900 dark:text-white text-base flex items-center gap-2">
              <MapPin className="w-4 h-4 text-blue-600" />
              {isAr ? 'نطاق التدخل والتنقل' : 'Zones d’intervention'}
            </h3>
            <p className="text-xs text-slate-500 dark:text-slate-400">
              {isAr
                ? `يتنقل الحرفي في ولاية ${governorateName} والمعتمديات التالية :`
                : `Cet artisan intervient rapidement dans le gouvernorat de ${governorateName} et les délégations suivantes :`}
            </p>
            <div className="flex flex-wrap gap-2 pt-1">
              {provider.coverageAreas.map((area, idx) => (
                <span
                  key={idx}
                  className="px-2.5 py-1 rounded-lg text-xs bg-slate-100 dark:bg-slate-800 text-slate-700 dark:text-slate-300 font-medium"
                >
                  {area}
                </span>
              ))}
            </div>
          </div>

          {/* Charte de Confiance Sanaya */}
          <div className="bg-gradient-to-br from-blue-50 to-indigo-50/50 dark:from-slate-900 dark:to-slate-900 border border-blue-100 dark:border-slate-800 rounded-3xl p-6 space-y-3">
            <h3 className="font-bold text-slate-900 dark:text-white text-sm flex items-center gap-2">
              <ShieldCheck className="w-4 h-4 text-blue-600" />
              {isAr ? 'ميثاق الجودة صَنَايعِيّة' : 'Charte de Confiance Sanaya'}
            </h3>
            <ul className="space-y-2 text-xs text-slate-600 dark:text-slate-300">
              <li className="flex items-start gap-2">
                <span className="text-blue-600 font-bold">•</span>
                <span>{isAr ? 'رقم هاتف مباشر دون وسطاء' : 'Numéro direct et sans intermédiaire'}</span>
              </li>
              <li className="flex items-start gap-2">
                <span className="text-blue-600 font-bold">•</span>
                <span>{isAr ? 'حماية بياناتكم الشخصية وفق قانون INPDP' : 'Protection des données conforme INPDP'}</span>
              </li>
              <li className="flex items-start gap-2">
                <span className="text-blue-600 font-bold">•</span>
                <span>{isAr ? 'تقييمات موثقة من حرفاء حقيقيين' : 'Avis vérifiés par code de traçabilité'}</span>
              </li>
              <li className="flex items-start gap-2">
                <span className="text-blue-600 font-bold">•</span>
                <span>{isAr ? '0 مليم رسوم أو اقتطاعات' : 'Aucune commission sur votre facture'}</span>
              </li>
            </ul>
          </div>
        </div>
      </div>

      {/* Sticky Mobile Bottom Bar */}
      <div className="md:hidden fixed bottom-0 start-0 end-0 z-40 bg-white/95 dark:bg-slate-900/95 backdrop-blur-md border-t border-slate-200 dark:border-slate-800 p-3 flex items-center gap-2">
        <Button
          variant="primary"
          onClick={() => handleContact('PHONE')}
          disabled={isLoadingContact}
          className="flex-1 flex items-center justify-center gap-2 font-bold py-3 text-sm shadow-md"
        >
          <Phone className="w-4 h-4" />
          <span>{revealedPhone ? revealedPhone : isAr ? 'اتصال مباشر' : 'Appeler'}</span>
        </Button>

        <Button
          variant="outline"
          onClick={() => handleContact('WHATSAPP')}
          disabled={isLoadingContact}
          className="flex-1 flex items-center justify-center gap-2 font-bold py-3 text-sm border-emerald-500 text-emerald-600 dark:text-emerald-400"
        >
          <MessageCircle className="w-4 h-4 text-emerald-600" />
          <span>WhatsApp</span>
        </Button>
      </div>

      {/* Lightbox Modal for Portfolio Photos */}
      {activeGalleryImg && (
        <div
          role="dialog"
          aria-modal="true"
          className="fixed inset-0 z-50 bg-black/90 backdrop-blur-md flex items-center justify-center p-4"
          onClick={() => setActiveGalleryImg(null)}
        >
          <button
            type="button"
            onClick={() => setActiveGalleryImg(null)}
            className="absolute top-5 end-5 p-2 rounded-full bg-white/20 text-white hover:bg-white/30"
          >
            <X className="w-6 h-6" />
          </button>
          <div
            className="relative w-full max-w-4xl h-[70vh] rounded-2xl overflow-hidden"
            onClick={(e) => e.stopPropagation()}
          >
            <Image
              src={activeGalleryImg}
              alt="Agrandissement photo chantier"
              fill
              className="object-contain"
              sizes="100vw"
            />
          </div>
        </div>
      )}
    </div>
  );
}
