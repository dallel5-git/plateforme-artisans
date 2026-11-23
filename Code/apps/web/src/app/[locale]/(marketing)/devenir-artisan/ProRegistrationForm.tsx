'use client';

import React, { useState } from 'react';
import { CheckCircle2, Sparkles } from 'lucide-react';
import { Button } from '@/components/ui/Button';
import { Input } from '@/components/ui/Input';
import { DEMO_CATEGORIES, DEMO_GOVERNORATES } from '@/lib/api/demo-data';

interface ProRegistrationFormProps {
  locale: string;
}

export function ProRegistrationForm({ locale }: ProRegistrationFormProps) {
  const isAr = locale === 'ar';
  const [fullName, setFullName] = useState('');
  const [phone, setPhone] = useState('');
  const [selectedCategory, setSelectedCategory] = useState('');
  const [selectedGovernorate, setSelectedGovernorate] = useState('sousse');
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [isSuccess, setIsSuccess] = useState(false);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!fullName || !phone || !selectedCategory) return;

    setIsSubmitting(true);
    setTimeout(() => {
      setIsSubmitting(false);
      setIsSuccess(true);
    }, 800);
  };

  return (
    <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-3xl p-6 md:p-8 shadow-xl">
      {isSuccess ? (
        <div className="text-center py-8 space-y-4">
          <div className="w-16 h-16 rounded-full bg-emerald-100 dark:bg-emerald-950 text-emerald-600 mx-auto flex items-center justify-center">
            <CheckCircle2 className="w-8 h-8" />
          </div>
          <h3 className="text-xl font-bold text-slate-900 dark:text-white">
            {isAr ? 'تم استلام طلب تسجيلك بنجاح!' : 'Demande d’inscription bien reçue !'}
          </h3>
          <p className="text-xs md:text-sm text-slate-600 dark:text-slate-400 max-w-sm mx-auto">
            {isAr
              ? 'سيتصل بك فريق صَنَايعِيّة خلال 24 ساعة عبر الهاتف لتفعيل ملفك وإدراج خدماتك في مدينتك.'
              : 'Notre conseiller partenaire vous appellera sous 24h ouvrées pour valider vos coordonnées et activer gratuitement votre vitrine locale.'}
          </p>
        </div>
      ) : (
        <form onSubmit={handleSubmit} className="space-y-4">
          <div className="flex items-center gap-2 pb-2 border-b border-slate-100 dark:border-slate-800">
            <Sparkles className="w-5 h-5 text-emerald-600" />
            <div>
              <h3 className="font-bold text-base text-slate-900 dark:text-white">
                {isAr ? 'سجّل نشاطك المهني الآن' : 'Inscrivez votre activité pro'}
              </h3>
              <p className="text-xs text-slate-500">
                {isAr
                  ? 'مجاني وبدون التزام لمدة 14 يوماً'
                  : '100% sans commission • Activation rapide'}
              </p>
            </div>
          </div>

          <div className="space-y-1">
            <label className="text-xs font-semibold text-slate-700 dark:text-slate-300">
              {isAr ? 'الاسم الكامل أو اسم الورشة' : 'Nom & Prénom ou Nom de votre entreprise'}
            </label>
            <Input
              type="text"
              required
              placeholder={isAr ? 'مثال: سامي المنصور' : 'Ex: Sami Mansour'}
              value={fullName}
              onChange={(e) => setFullName(e.target.value)}
            />
          </div>

          <div className="space-y-1">
            <label className="text-xs font-semibold text-slate-700 dark:text-slate-300">
              {isAr ? 'رقم الهاتف المباشر' : 'Numéro de téléphone portable'}
            </label>
            <Input
              type="tel"
              required
              placeholder="Ex: 98 123 456"
              value={phone}
              onChange={(e) => setPhone(e.target.value)}
            />
          </div>

          <div className="space-y-1">
            <label className="text-xs font-semibold text-slate-700 dark:text-slate-300">
              {isAr ? 'حرفتك أو مجالك الأساسي' : 'Votre métier principal'}
            </label>
            <select
              required
              value={selectedCategory}
              onChange={(e) => setSelectedCategory(e.target.value)}
              className="w-full px-4 py-2.5 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-sm text-slate-800 dark:text-slate-200 focus:outline-none focus:ring-2 focus:ring-blue-500"
            >
              <option value="">{isAr ? 'اختر المهنة...' : 'Sélectionnez votre métier...'}</option>
              {DEMO_CATEGORIES.map((cat) => (
                <option key={cat.id} value={cat.slug}>
                  {isAr ? cat.nameAr : cat.nameFr}
                </option>
              ))}
            </select>
          </div>

          <div className="space-y-1">
            <label className="text-xs font-semibold text-slate-700 dark:text-slate-300">
              {isAr ? 'الولاية الرئيسية' : 'Votre gouvernorat de rattachement'}
            </label>
            <select
              value={selectedGovernorate}
              onChange={(e) => setSelectedGovernorate(e.target.value)}
              className="w-full px-4 py-2.5 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-sm text-slate-800 dark:text-slate-200 focus:outline-none focus:ring-2 focus:ring-blue-500"
            >
              {DEMO_GOVERNORATES.map((gov) => (
                <option key={gov.id} value={gov.slug}>
                  {isAr ? gov.nameAr : gov.nameFr}
                </option>
              ))}
            </select>
          </div>

          <div className="pt-2">
            <Button
              type="submit"
              variant="primary"
              size="lg"
              disabled={isSubmitting}
              className="w-full font-bold bg-emerald-600 hover:bg-emerald-700 border-none text-white shadow-md shadow-emerald-500/20"
            >
              {isSubmitting
                ? isAr
                  ? 'جاري الإرسال...'
                  : 'Envoi en cours...'
                : isAr
                  ? 'إنشاء ملفي المهني مجاناً'
                  : 'Créer ma vitrine artisan'}
            </Button>
          </div>

          <p className="text-[11px] text-slate-400 text-center leading-tight">
            {isAr
              ? 'بالتسجيل، أنت توافق على شروط الاستخدام وسياسة حماية البيانات التونسية.'
              : 'En validant, vous acceptez les conditions de mise en relation de la plateforme Sanaya.'}
          </p>
        </form>
      )}
    </div>
  );
}
