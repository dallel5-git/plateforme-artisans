import React from 'react';
import type { Metadata } from 'next';
import { Manrope, Noto_Kufi_Arabic } from 'next/font/google';
import { Navbar } from '@/components/common/Navbar';
import { Footer } from '@/components/common/Footer';
import '../globals.css';

const manrope = Manrope({
  subsets: ['latin'],
  variable: '--font-sans',
  display: 'swap',
});

const notoKufiArabic = Noto_Kufi_Arabic({
  subsets: ['arabic'],
  variable: '--font-arabic',
  display: 'swap',
});

export async function generateMetadata({
  params,
}: {
  params: Promise<{ locale: string }>;
}): Promise<Metadata> {
  const { locale } = await params;
  const isAr = locale === 'ar';

  return {
    title: {
      template: '%s | Sanaya.tn',
      default: isAr
        ? 'صنايعية تونس — أفضل الحرفيين المؤهلين في الساحل وكامل تونس'
        : 'Sanaya.tn — Trouvez les meilleurs artisans qualifiés en Tunisie',
    },
    description: isAr
      ? 'ابحث وتواصل مباشرة مع أمهر الحرفيين في السباكة، الكهرباء، التكييف، النجارة والدهان في سوسة، المنستير، المهدية وكامل تونس.'
      : 'Plombiers, électriciens, peintres, menuisiers et artisans qualifiés à Sousse, Monastir, Mahdia et toute la Tunisie. Contact direct sans intermédiaire.',
    metadataBase: new URL('https://sanaya.tn'),
    alternates: {
      canonical: `/${locale}`,
      languages: {
        fr: '/fr',
        ar: '/ar',
      },
    },
    openGraph: {
      siteName: 'Sanaya.tn',
      locale: isAr ? 'ar_TN' : 'fr_TN',
      type: 'website',
    },
  };
}

export default async function LocaleLayout({
  children,
  params,
}: {
  children: React.ReactNode;
  params: Promise<{ locale: string }>;
}) {
  const { locale } = await params;
  const isAr = locale === 'ar';

  return (
    <html
      lang={locale}
      dir={isAr ? 'rtl' : 'ltr'}
      className={`${manrope.variable} ${notoKufiArabic.variable}`}
      suppressHydrationWarning
    >
      <body className="min-h-screen flex flex-col bg-[#FCFCFA] dark:bg-[#0A0D12] text-slate-900 dark:text-slate-100 font-sans antialiased">
        <Navbar locale={locale} />
        <main className="flex-1">{children}</main>
        <Footer locale={locale} />
      </body>
    </html>
  );
}
