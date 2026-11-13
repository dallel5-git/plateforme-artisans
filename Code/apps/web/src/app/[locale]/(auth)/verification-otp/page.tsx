'use client';

import React, { useState, useEffect, use } from 'react';
import { useRouter, useSearchParams } from 'next/navigation';
import Link from 'next/link';
import { ShieldCheck, ArrowLeft, RotateCw } from 'lucide-react';
import { Button } from '@/components/ui/Button';

interface PageProps {
  params: Promise<{ locale: string }>;
}

export default function OtpVerificationPage({ params }: PageProps) {
  const { locale } = use(params);
  const router = useRouter();
  const searchParams = useSearchParams();
  const isAr = locale === 'ar';

  const phone = searchParams.get('phone') || '+216 98 123 456';
  const role = searchParams.get('role') || 'customer';

  const [otp, setOtp] = useState(['', '', '', '', '', '']);
  const [countdown, setCountdown] = useState(45);
  const [isVerifying, setIsVerifying] = useState(false);
  const [errorMsg, setErrorMsg] = useState<string | null>(null);

  useEffect(() => {
    if (countdown > 0) {
      const timer = setTimeout(() => setCountdown(countdown - 1), 1000);
      return () => clearTimeout(timer);
    }
  }, [countdown]);

  const handleChange = (index: number, val: string) => {
    if (val.length > 1) {
      val = val.slice(-1);
    }
    const nextOtp = [...otp];
    nextOtp[index] = val;
    setOtp(nextOtp);

    // Auto-advance
    if (val && index < 5) {
      const nextInput = document.getElementById(`otp-input-${index + 1}`);
      nextInput?.focus();
    }
  };

  const handleKeyDown = (index: number, e: React.KeyboardEvent) => {
    if (e.key === 'Backspace' && !otp[index] && index > 0) {
      const prevInput = document.getElementById(`otp-input-${index - 1}`);
      prevInput?.focus();
    }
  };

  const handleVerify = (e: React.FormEvent) => {
    e.preventDefault();
    const fullCode = otp.join('');
    if (fullCode.length < 6) {
      setErrorMsg(isAr ? 'يرجى إدخال رمز التحقق كاملاً (6 أرقام)' : 'Veuillez saisir les 6 chiffres du code reçu');
      return;
    }

    setIsVerifying(true);
    setTimeout(() => {
      setIsVerifying(false);
      // Enregistrer une fausse session utilisateur pour la démo
      if (typeof window !== 'undefined') {
        localStorage.setItem(
          'sanaya_session',
          JSON.stringify({
            phone,
            role,
            isLoggedIn: true,
            loggedInAt: new Date().toISOString(),
          }),
        );
      }
      router.push(`/${locale}/favoris`);
    }, 700);
  };

  return (
    <div className="container mx-auto px-4 py-16 flex items-center justify-center">
      <div className="w-full max-w-md bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-3xl p-6 md:p-8 shadow-sm space-y-6">
        <Link
          href={`/${locale}/connexion`}
          className="inline-flex items-center gap-1.5 text-xs text-slate-500 hover:text-blue-600 transition-colors"
        >
          <ArrowLeft className="w-4 h-4 rtl:rotate-180" />
          <span>{isAr ? 'تغيير رقم الهاتف' : 'Changer de numéro'}</span>
        </Link>

        <div className="text-center space-y-2">
          <div className="w-12 h-12 rounded-2xl bg-blue-50 dark:bg-blue-950 text-blue-600 flex items-center justify-center mx-auto">
            <ShieldCheck className="w-6 h-6" />
          </div>
          <h1 className="text-2xl font-bold text-slate-900 dark:text-white">
            {isAr ? 'رمز التحقق السريع' : 'Code de confirmation'}
          </h1>
          <p className="text-xs text-slate-500 dark:text-slate-400">
            {isAr
              ? `أدخل الرمز المرسل عبر رسالة قصيرة إلى ${phone}`
              : `Saisissez le code SMS à 6 chiffres envoyé au ${phone}`}
          </p>
        </div>

        {errorMsg && (
          <div className="p-3 rounded-xl bg-rose-50 dark:bg-rose-950/40 text-rose-700 dark:text-rose-300 text-xs text-center font-medium">
            {errorMsg}
          </div>
        )}

        {/* 6 Digit Inputs */}
        <form onSubmit={handleVerify} className="space-y-6">
          <div className="flex justify-between gap-2" dir="ltr">
            {otp.map((digit, idx) => (
              <input
                key={idx}
                id={`otp-input-${idx}`}
                type="text"
                inputMode="numeric"
                maxLength={1}
                value={digit}
                onChange={(e) => handleChange(idx, e.target.value)}
                onKeyDown={(e) => handleKeyDown(idx, e)}
                className="w-12 h-14 text-center text-xl font-bold rounded-2xl bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 focus:outline-none focus:ring-2 focus:ring-blue-500 text-slate-900 dark:text-white"
              />
            ))}
          </div>

          <Button
            type="submit"
            variant="primary"
            size="lg"
            disabled={isVerifying}
            className="w-full font-bold justify-center"
          >
            {isVerifying
              ? (isAr ? 'جاري التحقق...' : 'Vérification en cours...')
              : (isAr ? 'تأكيد ودخول' : 'Confirmer et continuer')}
          </Button>

          {/* Resend code */}
          <div className="text-center text-xs text-slate-500">
            {countdown > 0 ? (
              <span>
                {isAr
                  ? `يمكنك طلب رمز جديد بعد ${countdown} ثانية`
                  : `Renvoyer un code dans ${countdown}s`}
              </span>
            ) : (
              <button
                type="button"
                onClick={() => setCountdown(45)}
                className="text-blue-600 font-bold hover:underline inline-flex items-center gap-1"
              >
                <RotateCw className="w-3.5 h-3.5" />
                <span>{isAr ? 'إعادة إرسال الرمز الآن' : 'Renvoyer le code par SMS'}</span>
              </button>
            )}
          </div>
        </form>
      </div>
    </div>
  );
}
