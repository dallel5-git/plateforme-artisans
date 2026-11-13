import React from 'react';
import type { Metadata } from 'next';
import Link from 'next/link';
import { notFound } from 'next/navigation';
import { ShieldCheck, ChevronRight } from 'lucide-react';

interface PageProps {
  params: Promise<{
    locale: string;
    slug: string;
  }>;
}

export async function generateStaticParams() {
  const locales = ['fr', 'ar'];
  const slugs = ['cgu', 'confidentialite', 'mentions-legales'];
  const params: { locale: string; slug: string }[] = [];

  for (const locale of locales) {
    for (const slug of slugs) {
      params.push({ locale, slug });
    }
  }

  return params;
}

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale, slug } = await params;
  const isAr = locale === 'ar';

  const titles: Record<string, { fr: string; ar: string }> = {
    cgu: {
      fr: 'Conditions Générales d’Utilisation | Sanaya',
      ar: 'شروط الاستخدام العامة | صَنَايعِيّة',
    },
    confidentialite: {
      fr: 'Politique de Confidentialité (INPDP) | Sanaya',
      ar: 'سياسة حماية المعطيات الشخصية (INPDP) | صَنَايعِيّة',
    },
    'mentions-legales': {
      fr: 'Mentions Légales & Éditeur | Sanaya',
      ar: 'الإشعارات القانونية والناشر | صَنَايعِيّة',
    },
  };

  const item = titles[slug];
  if (!item) return { title: 'Document légal | Sanaya' };

  return {
    title: isAr ? item.ar : item.fr,
  };
}

export default async function LegalPage({ params }: PageProps) {
  const { locale, slug } = await params;
  const isAr = locale === 'ar';

  const validSlugs = ['cgu', 'confidentialite', 'mentions-legales'];
  if (!validSlugs.includes(slug)) {
    notFound();
  }

  return (
    <div className="container mx-auto px-4 py-12 max-w-4xl space-y-8">
      {/* Breadcrumb */}
      <nav
        aria-label="Breadcrumb"
        className="flex items-center gap-2 text-xs text-slate-500"
      >
        <Link href={`/${locale}`} className="hover:text-blue-600">
          {isAr ? 'الرئيسية' : 'Accueil'}
        </Link>
        <ChevronRight className="w-3.5 h-3.5 rtl:rotate-180" />
        <span className="font-semibold text-slate-800 dark:text-slate-200">
          {slug === 'cgu' && (isAr ? 'شروط الاستخدام' : 'Conditions Générales')}
          {slug === 'confidentialite' &&
            (isAr ? 'حماية المعطيات الشخصية' : 'Confidentialité INPDP')}
          {slug === 'mentions-legales' && (isAr ? 'الإشعارات القانونية' : 'Mentions Légales')}
        </span>
      </nav>

      {/* Tabs */}
      <div className="flex items-center gap-2 border-b border-slate-200 dark:border-slate-800 pb-3 overflow-x-auto">
        <Link
          href={`/${locale}/legal/cgu`}
          className={`px-4 py-2 rounded-xl text-xs font-bold whitespace-nowrap transition-colors ${
            slug === 'cgu'
              ? 'bg-blue-600 text-white'
              : 'text-slate-600 dark:text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-800'
          }`}
        >
          {isAr ? 'شروط الاستخدام (CGU)' : 'Conditions Générales (CGU)'}
        </Link>
        <Link
          href={`/${locale}/legal/confidentialite`}
          className={`px-4 py-2 rounded-xl text-xs font-bold whitespace-nowrap transition-colors ${
            slug === 'confidentialite'
              ? 'bg-blue-600 text-white'
              : 'text-slate-600 dark:text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-800'
          }`}
        >
          {isAr ? 'حماية المعطيات (INPDP)' : 'Protection Données (INPDP)'}
        </Link>
        <Link
          href={`/${locale}/legal/mentions-legales`}
          className={`px-4 py-2 rounded-xl text-xs font-bold whitespace-nowrap transition-colors ${
            slug === 'mentions-legales'
              ? 'bg-blue-600 text-white'
              : 'text-slate-600 dark:text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-800'
          }`}
        >
          {isAr ? 'الإشعارات القانونية' : 'Mentions Légales'}
        </Link>
      </div>

      {/* Content Container */}
      <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-3xl p-6 md:p-10 prose dark:prose-invert max-w-none text-slate-700 dark:text-slate-300 text-sm leading-relaxed">
        {slug === 'cgu' && (
          <div className="space-y-6">
            <h1 className="text-2xl md:text-3xl font-extrabold text-slate-900 dark:text-white">
              {isAr ? 'شروط الاستخدام العامة (CGU)' : 'Conditions Générales d’Utilisation (CGU)'}
            </h1>
            <p className="text-xs text-slate-400">
              {isAr ? 'آخر تحديث: أوت 2026' : 'Dernière mise à jour : Août 2026'}
            </p>

            <h2 className="text-lg font-bold text-slate-900 dark:text-white">
              {isAr ? '1. الغرض من الخدمة' : '1. Objet du Service'}
            </h2>
            <p>
              {isAr
                ? 'توفر منصة صَنَايعِيّة خدمة ربط مباشر بين الأفراد والحرفيين المستقلين في تونس. المنصة ليست طرفاً في التعاقد المالي أو الفني بين الحريف والحرفي ولا تقتطع أي عمولة على العمليات.'
                : 'La plateforme Sanaya met en relation directe des particuliers et des artisans indépendants exerçant en Tunisie (Sahel). Sanaya agit exclusivement en qualité d’intermédiaire technique de mise en relation et n’intervient en aucun cas dans les transactions financières ou les prestations conclues entre les parties.'}
            </p>

            <h2 className="text-lg font-bold text-slate-900 dark:text-white">
              {isAr ? '2. التزامات الحرفيين' : '2. Engagements des Professionnels'}
            </h2>
            <p>
              {isAr
                ? 'يتعهد كل حرفي مسجل بتقديم معلومات صحيحة، احترام المواعيد، وتقديم تسعيرات واضحة للمستهلك قبل مباشرة الأشغال.'
                : 'Chaque artisan inscrit s’engage à fournir des informations véridiques quant à ses qualifications, à respecter les devis établis et à réaliser ses prestations conformément aux règles de l’art.'}
            </p>

            <h2 className="text-lg font-bold text-slate-900 dark:text-white">
              {isAr ? '3. نظام التقييمات ومكافحة التزوير' : '3. Système d’Avis et Modération'}
            </h2>
            <p>
              {isAr
                ? 'تخضع جميع التقييمات لنظام تدقيق لمنع الآراء المضللة أو الكيدية. يحق لإدارة المنصة حذف أي تقييم يثبت عدم صحته.'
                : 'Tous les avis sont modérés afin d’éviter les commentaires frauduleux ou diffamatoires. Sanaya se réserve le droit de vérifier la réalité du contact avant publication.'}
            </p>
          </div>
        )}

        {slug === 'confidentialite' && (
          <div className="space-y-6">
            <div className="flex items-center gap-3 pb-4 border-b border-slate-100 dark:border-slate-800">
              <ShieldCheck className="w-8 h-8 text-blue-600" />
              <div>
                <h1 className="text-2xl md:text-3xl font-extrabold text-slate-900 dark:text-white mb-0">
                  {isAr
                    ? 'سياسة حماية المعطيات الشخصية (INPDP)'
                    : 'Politique de Confidentialité & Conformité INPDP'}
                </h1>
                <p className="text-xs text-slate-500 m-0">
                  {isAr
                    ? 'مطابقة للقانون الأساسي التونسي عدد 63 لسنة 2004'
                    : 'Conforme à la loi organique n° 2004-63 relative à la protection des données personnelles en Tunisie'}
                </p>
              </div>
            </div>

            <h2 className="text-lg font-bold text-slate-900 dark:text-white">
              {isAr ? '1. حماية أرقام الهواتف من الجمع الآلي (Anti-Scraping)' : '1. Protection des Numéros de Téléphone (Anti-Scraping)'}
            </h2>
            <p>
              {isAr
                ? 'تطبق صَنَايعِيّة تقنيات حماية متقدمة حيث لا تظهر أرقام الهواتف مباشرة في الشيفرة المصدرية (HTML) بل يتم الكشف عنها حصرياً بعد ضغط الحريف الفعلي، مما يمنع الروبوتات من سحب البيانات والتسويق المزعج.'
                : 'Les numéros de téléphone ne sont jamais exposés en texte brut non sollicité dans le code source de nos pages. Un protocole de révélation traçable (ContactEvent) assure qu’aucun robot d’aspiration ne puisse collecter massivement les données de nos artisans.'}
            </p>

            <h2 className="text-lg font-bold text-slate-900 dark:text-white">
              {isAr ? '2. حقوق المستخدم' : '2. Vos Droits d’Accès et de Rectification'}
            </h2>
            <p>
              {isAr
                ? 'يحق لكل مستخدم أو حرفي طلب النفاذ إلى معطياته الشخصية، تعديلها أو حذفها نهائياً بمجرد مراسلة فريق الدعم عبر البريد الإلكتروني.'
                : 'Conformément aux directives de l’Instance Nationale de Protection des Données Personnelles (INPDP), vous disposez d’un droit d’accès, de rectification et d’effacement de vos données personnelles sur simple demande à contact@sanaya.tn.'}
            </p>
          </div>
        )}

        {slug === 'mentions-legales' && (
          <div className="space-y-6">
            <h1 className="text-2xl md:text-3xl font-extrabold text-slate-900 dark:text-white">
              {isAr ? 'الإشعارات القانونية والناشر' : 'Mentions Légales'}
            </h1>
            <p>
              <strong>{isAr ? 'اسم المنصة :' : 'Éditeur de la plateforme :'}</strong> Sanaya Technologies TN
            </p>
            <p>
              <strong>{isAr ? 'المقر الاجتماعي :' : 'Siège social :'}</strong> Sousse Sahel, République Tunisienne
            </p>
            <p>
              <strong>{isAr ? 'الاتصال :' : 'Contact :'}</strong> contact@sanaya.tn • +216 73 000 000
            </p>
            <p>
              <strong>{isAr ? 'الاستضافة :' : 'Hébergement :'}</strong> Infrastructure Cloud sécurisée avec chiffrement des données de bout en bout.
            </p>
          </div>
        )}
      </div>
    </div>
  );
}
