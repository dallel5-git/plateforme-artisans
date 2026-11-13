'use client';

import React, { useState, use } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { ArrowRight, User, Briefcase } from 'lucide-react';
import { Button } from '@/components/ui/Button';
import { Input } from '@/components/ui/Input';

interface PageProps {
  params: Promise<{ locale: string }>;
}

export default function LoginPage({ params }: PageProps) {
  const { locale } = use(params);
  const router = useRouter();
  const isAr = locale === 'ar';

  const [role, setRole] = useState<'customer' | 'provider'>('customer');
  const [phone, setPhone] = useState('');
  const [isLoading, setIsLoading] = useState(false);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!phone) return;

    setIsLoading(true);
    setTimeout(() => {
      setIsLoading(false);
      router.push(`/${locale}/verification-otp?phone=${encodeURIComponent(phone)}&role=${role}`);
    }, 600);
  };

  return (
    <div className="container mx-auto px-4 py-16 flex items-center justify-center">
      <div className="w-full max-w-md bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-3xl p-6 md:p-8 shadow-sm space-y-6">
        {/* Header */}
        <div className="text-center space-y-2">
          <div className="w-12 h-12 rounded-2xl bg-blue-600 text-white font-extrabold text-2xl flex items-center justify-center mx-auto shadow-md shadow-blue-500/20">
            S
          </div>
          <h1 className="text-2xl font-bold text-slate-900 dark:text-white">
            {isAr ? 'تسجيل الدخول إلى صَنَايعِيّة' : 'Connexion à Sanaya'}
          </h1>
          <p className="text-xs text-slate-500 dark:text-slate-400">
            {isAr
              ? 'أدخل رقم هاتفك لاستلام رمز التحقق الفوري (SMS)'
              : 'Saisissez votre numéro de téléphone pour recevoir un code SMS sécurisé'}
          </p>
        </div>

        {/* Role Switcher */}
        <div className="grid grid-cols-2 gap-2 p-1 bg-slate-100 dark:bg-slate-800 rounded-xl">
          <button
            type="button"
            onClick={() => setRole('customer')}
            className={`flex items-center justify-center gap-2 py-2 rounded-lg text-xs font-bold transition-all ${
              role === 'customer'
                ? 'bg-white dark:bg-slate-900 text-blue-600 shadow-sm'
                : 'text-slate-600 dark:text-slate-400'
            }`}
          >
            <User className="w-3.5 h-3.5" />
            <span>{isAr ? 'حريف' : 'Particulier'}</span>
          </button>
          <button
            type="button"
            onClick={() => setRole('provider')}
            className={`flex items-center justify-center gap-2 py-2 rounded-lg text-xs font-bold transition-all ${
              role === 'provider'
                ? 'bg-white dark:bg-slate-900 text-blue-600 shadow-sm'
                : 'text-slate-600 dark:text-slate-400'
            }`}
          >
            <Briefcase className="w-3.5 h-3.5" />
            <span>{isAr ? 'حرفي مهني' : 'Artisan Pro'}</span>
          </button>
        </div>

        {/* Form */}
        <form onSubmit={handleSubmit} className="space-y-4">
          <div className="space-y-1">
            <label className="text-xs font-semibold text-slate-700 dark:text-slate-300">
              {isAr ? 'رقم الهاتف الجوال' : 'Numéro de téléphone'}
            </label>
            <div className="flex gap-2">
              <span className="px-3.5 py-2.5 bg-slate-100 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-sm font-semibold text-slate-600 dark:text-slate-300 flex items-center">
                +216
              </span>
              <Input
                type="tel"
                required
                autoFocus
                placeholder="Ex: 98 123 456"
                value={phone}
                onChange={(e) => setPhone(e.target.value)}
                className="flex-1"
              />
            </div>
          </div>

          <Button
            type="submit"
            variant="primary"
            size="lg"
            disabled={isLoading || !phone.trim()}
            className="w-full font-bold justify-center gap-2"
          >
            {isLoading ? (
              <span>{isAr ? 'جاري الإرسال...' : 'Envoi en cours...'}</span>
            ) : (
              <>
                <span>{isAr ? 'متابعة واستلام الرمز' : 'Recevoir mon code OTP'}</span>
                <ArrowRight className="w-4 h-4 rtl:rotate-180" />
              </>
            )}
          </Button>

          <div className="text-center">
            <p className="text-[11px] text-slate-400">
              {isAr
                ? 'اتصالك محمي ومشفر وفق معايير الأمان الوطنية.'
                : 'Connexion 100% sécurisée sans mot de passe à retenir.'}
            </p>
          </div>
        </form>

        {role === 'provider' && (
          <div className="pt-4 border-t border-slate-100 dark:border-slate-800 text-center">
            <p className="text-xs text-slate-600 dark:text-slate-400">
              {isAr ? 'لست مسجلاً كحرفي بعد ؟' : 'Vous n’avez pas encore de profil pro ?'}{' '}
              <Link
                href={`/${locale}/devenir-artisan`}
                className="text-blue-600 font-bold hover:underline"
              >
                {isAr ? 'سجّل حرفتك مجاناً' : 'Créer ma vitrine pro'}
              </Link>
            </p>
          </div>
        )}
      </div>
    </div>
  );
}
