'use client';

import React, { useState } from 'react';
import Link from 'next/link';
import Image from 'next/image';
import { useRouter } from 'next/navigation';
import { Star, ArrowLeft, CheckCircle2, ShieldCheck, AlertCircle } from 'lucide-react';
import { Button } from '@/components/ui/Button';
import { Input } from '@/components/ui/Input';
import { sanayaApi } from '@/lib/api/client';
import type { ProviderDetail } from '@/lib/api/demo-data';

interface ReviewFormClientProps {
  provider: ProviderDetail;
  locale: string;
}

export function ReviewFormClient({ provider, locale }: ReviewFormClientProps) {
  const router = useRouter();
  const isAr = locale === 'ar';

  const [rating, setRating] = useState<number>(5);
  const [hoverRating, setHoverRating] = useState<number | null>(null);
  const [authorName, setAuthorName] = useState('');
  const [phone, setPhone] = useState('');
  const [comment, setComment] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [isSuccess, setIsSuccess] = useState(false);
  const [errorMsg, setErrorMsg] = useState<string | null>(null);

  const starLabelsFr = ['Mauvais', 'Passable', 'Bien', 'Très bien', 'Excellent'];
  const starLabelsAr = ['سيء', 'مقبول', 'جيد', 'جيد جداً', 'ممتاز'];

  const currentDisplayRating = hoverRating !== null ? hoverRating : rating;

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setErrorMsg(null);

    if (comment.trim().length < 10) {
      setErrorMsg(
        isAr
          ? 'يرجى كتابة تعليق لا يقل عن 10 أحرف لشرح تجربتك.'
          : 'Veuillez écrire un commentaire d’au moins 10 caractères pour détailler votre expérience.',
      );
      return;
    }

    setIsSubmitting(true);
    try {
      await sanayaApi.addReview(provider.id, {
        rating,
        comment: comment.trim(),
        authorName: authorName.trim() || undefined,
      });
      setIsSuccess(true);
    } catch {
      setErrorMsg(
        isAr
          ? 'حدث خطأ أثناء إرسال التقييم، يرجى المحاولة مرة أخرى.'
          : 'Une erreur est survenue lors de l’envoi de votre avis. Veuillez réessayer.',
      );
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="max-w-2xl mx-auto space-y-6">
      {/* Return to profile button */}
      <Link
        href={`/${locale}/artisans/${provider.slug}`}
        className="inline-flex items-center gap-2 text-xs font-semibold text-slate-500 hover:text-blue-600 transition-colors"
      >
        <ArrowLeft className="w-4 h-4 rtl:rotate-180" />
        <span>
          {isAr
            ? `العودة إلى ملف ${provider.businessName}`
            : `Retour au profil de ${provider.businessName}`}
        </span>
      </Link>

      <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-3xl p-6 md:p-10 shadow-sm">
        {/* Artisan Header Mini */}
        <div className="flex items-center gap-4 pb-6 border-b border-slate-100 dark:border-slate-800">
          <div className="relative w-14 h-14 rounded-2xl overflow-hidden shrink-0 border border-slate-200 dark:border-slate-700 bg-slate-100">
            <Image
              src={provider.avatarUrl}
              alt={provider.businessName}
              fill
              className="object-cover"
              sizes="56px"
            />
          </div>
          <div>
            <div className="text-xs text-blue-600 dark:text-blue-400 font-semibold">
              {isAr ? provider.primaryCategoryNameAr : provider.primaryCategoryNameFr}
            </div>
            <h1 className="text-lg font-bold text-slate-900 dark:text-white">
              {isAr
                ? `تقييم خدمة ${provider.businessName}`
                : `Évaluer l’intervention de ${provider.businessName}`}
            </h1>
          </div>
        </div>

        {isSuccess ? (
          <div className="py-8 text-center space-y-4">
            <div className="w-16 h-16 rounded-full bg-emerald-100 dark:bg-emerald-950/60 text-emerald-600 mx-auto flex items-center justify-center">
              <CheckCircle2 className="w-8 h-8" />
            </div>
            <h2 className="text-xl font-bold text-slate-900 dark:text-white">
              {isAr ? 'شكراً جزيلاً على تقييمك!' : 'Merci pour votre retour d’expérience !'}
            </h2>
            <p className="text-slate-600 dark:text-slate-400 text-sm max-w-md mx-auto">
              {isAr
                ? 'تم تسجيل تقييمك بنجاح وسيساعد باقي سكان الساحل على اختيار أفضل الحرفيين الموثوقين.'
                : 'Votre avis a été enregistré avec succès et contribue à éclairer la communauté des usagers de Sanaya.'}
            </p>
            <div className="pt-4">
              <Button
                variant="primary"
                onClick={() => router.push(`/${locale}/artisans/${provider.slug}`)}
              >
                {isAr ? 'الرجوع إلى الملف الشخصي' : 'Retourner sur la fiche artisan'}
              </Button>
            </div>
          </div>
        ) : (
          <form onSubmit={handleSubmit} className="space-y-6 pt-6">
            {errorMsg && (
              <div className="p-4 rounded-xl bg-rose-50 dark:bg-rose-950/40 border border-rose-200 dark:border-rose-800 text-rose-700 dark:text-rose-300 text-xs flex items-start gap-2">
                <AlertCircle className="w-4 h-4 shrink-0 mt-0.5" />
                <span>{errorMsg}</span>
              </div>
            )}

            {/* Interactive Stars Selector */}
            <div className="space-y-2 text-center py-2">
              <label className="block text-xs font-bold text-slate-600 dark:text-slate-400 uppercase tracking-wider">
                {isAr ? 'تقييمك الإجمالي للتجربة' : 'Votre note globale'}
              </label>
              <div className="flex items-center justify-center gap-2">
                {[1, 2, 3, 4, 5].map((starVal) => {
                  const isFilled = starVal <= currentDisplayRating;
                  return (
                    <button
                      key={starVal}
                      type="button"
                      onClick={() => setRating(starVal)}
                      onMouseEnter={() => setHoverRating(starVal)}
                      onMouseLeave={() => setHoverRating(null)}
                      className="p-1.5 focus:outline-none transition-transform hover:scale-125"
                    >
                      <Star
                        className={`w-8 h-8 transition-colors ${
                          isFilled
                            ? 'text-amber-400 fill-amber-400'
                            : 'text-slate-300 dark:text-slate-700'
                        }`}
                      />
                    </button>
                  );
                })}
              </div>
              <div className="text-sm font-bold text-slate-800 dark:text-slate-200">
                {isAr
                  ? starLabelsAr[currentDisplayRating - 1]
                  : starLabelsFr[currentDisplayRating - 1]}
              </div>
            </div>

            {/* Name Input */}
            <div className="space-y-1">
              <label className="text-xs font-semibold text-slate-700 dark:text-slate-300">
                {isAr ? 'اسمك أو اللقب' : 'Votre nom ou prénom'}
              </label>
              <Input
                type="text"
                placeholder={isAr ? 'مثال: كريم م.' : 'Ex: Karim M.'}
                value={authorName}
                onChange={(e) => setAuthorName(e.target.value)}
              />
            </div>

            {/* Phone verification input */}
            <div className="space-y-1">
              <label className="text-xs font-semibold text-slate-700 dark:text-slate-300 flex items-center justify-between">
                <span>
                  {isAr ? 'رقم الهاتف (للتحقق فقط)' : 'Numéro de téléphone (pour vérification)'}
                </span>
                <span className="text-[10px] text-slate-400 font-normal">
                  {isAr ? 'لن ينشر للعموم' : 'Ne sera jamais affiché publiquement'}
                </span>
              </label>
              <Input
                type="tel"
                placeholder="Ex: 98 123 456"
                value={phone}
                onChange={(e) => setPhone(e.target.value)}
              />
            </div>

            {/* Comment Area */}
            <div className="space-y-1">
              <label className="text-xs font-semibold text-slate-700 dark:text-slate-300">
                {isAr
                  ? 'تفاصيل تجربتك ورأيك'
                  : 'Détaillez votre expérience et la qualité du travail'}
              </label>
              <textarea
                rows={4}
                value={comment}
                onChange={(e) => setComment(e.target.value)}
                placeholder={
                  isAr
                    ? 'اشرح جودة العمل، الدقة في المواعيد، ووضوح الأسعار لمساعدة الآخرين...'
                    : 'Expliquez la ponctualité, la propreté du chantier, la clarté du tarif et la qualité du travail...'
                }
                className="w-full px-4 py-3 bg-slate-50 dark:bg-slate-800/80 border border-slate-200 dark:border-slate-700 rounded-xl text-sm text-slate-900 dark:text-white placeholder:text-slate-400 focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
              <div className="text-end text-[11px] text-slate-400">
                {comment.length} / 10 caractères min.
              </div>
            </div>

            {/* Quality & Anti-Fraud Notice */}
            <div className="p-4 rounded-2xl bg-blue-50/60 dark:bg-blue-950/30 border border-blue-100 dark:border-blue-900/40 text-xs text-slate-600 dark:text-slate-400 flex items-start gap-2.5">
              <ShieldCheck className="w-4 h-4 text-blue-600 shrink-0 mt-0.5" />
              <span>
                {isAr
                  ? 'منصة صَنَايعِيّة تطبق نظام تحقق صارم لمنع التقييمات الوهمية ولضمان نزاهة ومصداقية الآراء المنشورة.'
                  : 'Sanaya applique un protocole anti-triche strict. Les avis sont modérés afin de garantir une totale authenticité pour la communauté.'}
              </span>
            </div>

            {/* Submit Button */}
            <Button
              type="submit"
              variant="primary"
              size="lg"
              disabled={isSubmitting}
              className="w-full font-bold"
            >
              {isSubmitting
                ? isAr
                  ? 'جاري الإرسال...'
                  : 'Publication en cours...'
                : isAr
                  ? 'نشر التقييم'
                  : 'Publier mon avis'}
            </Button>
          </form>
        )}
      </div>
    </div>
  );
}
