'use client';

import React, { useState, use } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { Heart, Phone, Star, Settings, Globe, LogOut, CheckCircle2 } from 'lucide-react';
import { Button } from '@/components/ui/Button';
import { Input } from '@/components/ui/Input';

interface PageProps {
  params: Promise<{ locale: string }>;
}

export default function AccountSettingsPage({ params }: PageProps) {
  const { locale } = use(params);
  const router = useRouter();
  const isAr = locale === 'ar';

  const [name, setName] = useState('Anis Belhadj');
  const [phone, setPhone] = useState('98 765 432');
  const [isSaved, setIsSaved] = useState(false);

  const handleSave = (e: React.FormEvent) => {
    e.preventDefault();
    setIsSaved(true);
    setTimeout(() => setIsSaved(false), 2500);
  };

  const handleLogout = () => {
    try {
      localStorage.removeItem('sanaya_session');
    } catch {}
    router.push(`/${locale}`);
  };

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
          className="px-4 py-2 rounded-xl text-xs font-bold whitespace-nowrap text-slate-600 dark:text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-800 flex items-center gap-2"
        >
          <Star className="w-3.5 h-3.5" />
          <span>{isAr ? 'تقييماتي' : 'Mes Avis'}</span>
        </Link>
        <Link
          href={`/${locale}/parametres`}
          className="px-4 py-2 rounded-xl text-xs font-bold whitespace-nowrap bg-blue-600 text-white flex items-center gap-2"
        >
          <Settings className="w-3.5 h-3.5" />
          <span>{isAr ? 'الإعدادات' : 'Paramètres'}</span>
        </Link>
      </div>

      {/* Header */}
      <div>
        <h1 className="text-2xl font-bold text-slate-900 dark:text-white">
          {isAr ? 'إعدادات الحساب والتفضيلات' : 'Paramètres de compte & Préférences'}
        </h1>
        <p className="text-xs text-slate-500 mt-1">
          {isAr
            ? 'تحديث بياناتك الشخصية، لغة الواجهة وإشعارات التدخلات.'
            : 'Gérez votre numéro de contact, la langue d’affichage et vos préférences.'}
        </p>
      </div>

      {/* Settings Form Container */}
      <div className="max-w-2xl bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-3xl p-6 md:p-8 space-y-6 shadow-sm">
        {isSaved && (
          <div className="p-3.5 rounded-xl bg-emerald-50 dark:bg-emerald-950/40 border border-emerald-200 dark:border-emerald-800 text-emerald-700 dark:text-emerald-300 text-xs flex items-center gap-2 font-medium">
            <CheckCircle2 className="w-4 h-4 shrink-0" />
            <span>{isAr ? 'تم حفظ التعديلات بنجاح !' : 'Modifications enregistrées avec succès !'}</span>
          </div>
        )}

        <form onSubmit={handleSave} className="space-y-4">
          <div className="space-y-1">
            <label className="text-xs font-semibold text-slate-700 dark:text-slate-300">
              {isAr ? 'الاسم الكامل' : 'Nom complet'}
            </label>
            <Input
              type="text"
              value={name}
              onChange={(e) => setName(e.target.value)}
            />
          </div>

          <div className="space-y-1">
            <label className="text-xs font-semibold text-slate-700 dark:text-slate-300">
              {isAr ? 'رقم الهاتف' : 'Numéro de téléphone'}
            </label>
            <Input
              type="tel"
              value={phone}
              onChange={(e) => setPhone(e.target.value)}
            />
          </div>

          {/* Langue */}
          <div className="pt-3 border-t border-slate-100 dark:border-slate-800 space-y-2">
            <label className="text-xs font-semibold text-slate-700 dark:text-slate-300 flex items-center gap-2">
              <Globe className="w-4 h-4 text-blue-600" />
              <span>{isAr ? 'لغة المنصة المفضلة' : 'Langue d’utilisation'}</span>
            </label>
            <div className="grid grid-cols-2 gap-3">
              <Link
                href="/fr/parametres"
                className={`py-2 px-3 rounded-xl border text-center text-xs font-bold transition-colors ${
                  locale === 'fr'
                    ? 'border-blue-600 bg-blue-50 dark:bg-blue-950/60 text-blue-700 dark:text-blue-300'
                    : 'border-slate-200 dark:border-slate-700 text-slate-700 dark:text-slate-300'
                }`}
              >
                Français
              </Link>
              <Link
                href="/ar/parametres"
                className={`py-2 px-3 rounded-xl border text-center text-xs font-bold transition-colors ${
                  locale === 'ar'
                    ? 'border-blue-600 bg-blue-50 dark:bg-blue-950/60 text-blue-700 dark:text-blue-300'
                    : 'border-slate-200 dark:border-slate-700 text-slate-700 dark:text-slate-300'
                }`}
              >
                العربية (تونس)
              </Link>
            </div>
          </div>

          <div className="pt-4 flex items-center justify-between">
            <Button type="submit" variant="primary" className="font-bold">
              {isAr ? 'حفظ التعديلات' : 'Enregistrer les modifications'}
            </Button>

            <Button
              type="button"
              variant="outline"
              onClick={handleLogout}
              className="text-rose-600 border-rose-200 hover:bg-rose-50 dark:hover:bg-rose-950/30 gap-1.5"
            >
              <LogOut className="w-3.5 h-3.5" />
              <span>{isAr ? 'تسجيل الخروج' : 'Déconnexion'}</span>
            </Button>
          </div>
        </form>
      </div>
    </div>
  );
}
