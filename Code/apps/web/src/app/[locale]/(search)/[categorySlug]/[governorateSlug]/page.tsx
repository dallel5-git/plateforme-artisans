import React from 'react';
import type { Metadata } from 'next';
import Link from 'next/link';
import { notFound } from 'next/navigation';
import { ChevronRight, MapPin, ShieldCheck, Zap, Award, HelpCircle } from 'lucide-react';
import { sanayaApi } from '@/lib/api/client';
import { ProviderCard } from '@/components/ui/ProviderCard';
import { EmptyState } from '@/components/ui/EmptyState';
import { DEMO_CATEGORIES, DEMO_GOVERNORATES } from '@/lib/api/demo-data';

interface PageProps {
  params: Promise<{
    locale: string;
    categorySlug: string;
    governorateSlug: string;
  }>;
}

export async function generateStaticParams() {
  const locales = ['fr', 'ar'];
  const params: { locale: string; categorySlug: string; governorateSlug: string }[] = [];

  for (const locale of locales) {
    for (const cat of DEMO_CATEGORIES) {
      for (const gov of DEMO_GOVERNORATES) {
        params.push({
          locale,
          categorySlug: cat.slug,
          governorateSlug: gov.slug,
        });
      }
    }
  }

  return params;
}

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale, categorySlug, governorateSlug } = await params;
  const isAr = locale === 'ar';

  const category = DEMO_CATEGORIES.find((c) => c.slug.toLowerCase() === categorySlug.toLowerCase());
  const governorate = DEMO_GOVERNORATES.find(
    (g) => g.slug.toLowerCase() === governorateSlug.toLowerCase(),
  );

  if (!category || !governorate) {
    return { title: 'Artisans locaux | Sanaya' };
  }

  const catName = isAr ? category.nameAr : category.nameFr;
  const govName = isAr ? governorate.nameAr : governorate.nameFr;

  const title = isAr
    ? `أفضل حرفيي ${catName} في ${govName} | صَنَايعِيّة`
    : `Les meilleurs artisans ${catName} à ${govName} (Sahel) | Sanaya`;

  const description = isAr
    ? `ابحث وتواصل مباشرة مع أفضل الحرفيين في ${catName} في ولاية ${govName}. أرقام هاتف مباشرة، واتساب، تقييمات موثقة وبدون عمولة.`
    : `Trouvez et contactez directement les artisans qualifiés en ${catName} à ${govName}. Tarifs transparents, contact direct WhatsApp/Téléphone, 0 commission.`;

  return {
    title,
    description,
    openGraph: {
      title,
      description,
      type: 'website',
    },
    alternates: {
      canonical: `https://sanaya.tn/${locale}/${categorySlug}/${governorateSlug}`,
      languages: {
        fr: `https://sanaya.tn/fr/${categorySlug}/${governorateSlug}`,
        ar: `https://sanaya.tn/ar/${categorySlug}/${governorateSlug}`,
      },
    },
  };
}

export default async function CategoryGovPage({ params }: PageProps) {
  const { locale, categorySlug, governorateSlug } = await params;
  const isAr = locale === 'ar';

  const category = DEMO_CATEGORIES.find((c) => c.slug.toLowerCase() === categorySlug.toLowerCase());
  const governorate = DEMO_GOVERNORATES.find(
    (g) => g.slug.toLowerCase() === governorateSlug.toLowerCase(),
  );

  if (!category || !governorate) {
    notFound();
  }

  const catName = isAr ? category.nameAr : category.nameFr;
  const govName = isAr ? governorate.nameAr : governorate.nameFr;

  // Search providers for this category & governorate
  const searchResult = await sanayaApi.searchProviders({
    categorySlug,
    governorateSlug,
  });

  const providers = searchResult.items;

  // JSON-LD Structured Data
  const jsonLd = {
    '@context': 'https://schema.org',
    '@graph': [
      {
        '@type': 'BreadcrumbList',
        itemListElement: [
          {
            '@type': 'ListItem',
            position: 1,
            name: isAr ? 'الرئيسية' : 'Accueil',
            item: `https://sanaya.tn/${locale}`,
          },
          {
            '@type': 'ListItem',
            position: 2,
            name: catName,
            item: `https://sanaya.tn/${locale}/recherche?categorie=${categorySlug}`,
          },
          {
            '@type': 'ListItem',
            position: 3,
            name: govName,
            item: `https://sanaya.tn/${locale}/${categorySlug}/${governorateSlug}`,
          },
        ],
      },
      {
        '@type': 'ItemList',
        name: isAr ? `حرفيو ${catName} في ${govName}` : `Artisans ${catName} à ${govName}`,
        numberOfItems: providers.length,
        itemListElement: providers.map((p, idx) => ({
          '@type': 'ListItem',
          position: idx + 1,
          item: {
            '@type': 'LocalBusiness',
            name: p.businessName,
            image: p.avatarUrl,
            telephone: p.phone,
            address: {
              '@type': 'PostalAddress',
              addressLocality: p.baseDelegationNameFr,
              addressRegion: p.baseGovernorateNameFr,
              addressCountry: 'TN',
            },
            aggregateRating: {
              '@type': 'AggregateRating',
              ratingValue: p.ratingAvg,
              reviewCount: p.ratingCount,
            },
          },
        })),
      },
    ],
  };

  return (
    <>
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }}
      />

      <div className="container mx-auto px-4 py-8 space-y-10">
        {/* Breadcrumb Navigation */}
        <nav
          aria-label="Breadcrumb"
          className="flex items-center gap-2 text-xs text-slate-500 dark:text-slate-400"
        >
          <Link href={`/${locale}`} className="hover:text-blue-600 transition-colors">
            {isAr ? 'الرئيسية' : 'Accueil'}
          </Link>
          <ChevronRight className="w-3.5 h-3.5 rtl:rotate-180 text-slate-400" />
          <Link
            href={`/${locale}/recherche?categorie=${categorySlug}`}
            className="hover:text-blue-600 transition-colors"
          >
            {catName}
          </Link>
          <ChevronRight className="w-3.5 h-3.5 rtl:rotate-180 text-slate-400" />
          <span className="font-semibold text-slate-800 dark:text-slate-200">{govName}</span>
        </nav>

        {/* Hero SEO Header */}
        <div className="bg-gradient-to-br from-blue-50 to-indigo-50/50 dark:from-slate-900 dark:to-slate-900 border border-blue-100/60 dark:border-slate-800 rounded-3xl p-6 md:p-10 space-y-4">
          <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-blue-100 dark:bg-blue-950/80 text-blue-800 dark:text-blue-300 text-xs font-semibold">
            <MapPin className="w-3.5 h-3.5" />
            <span>
              {isAr ? `ولاية ${govName}` : `Gouvernorat de ${govName}`} • {catName}
            </span>
          </div>

          <h1 className="text-2xl md:text-4xl font-extrabold text-slate-900 dark:text-white tracking-tight">
            {isAr
              ? `أفضل محترفي ${catName} في ${govName} والساحل`
              : `Artisans ${catName} qualifiés à ${govName} et environs`}
          </h1>

          <p className="text-slate-600 dark:text-slate-300 text-sm md:text-base max-w-3xl leading-relaxed">
            {isAr
              ? `هل تحتاج إلى تدخل سريع في ${catName} في ${govName} أو إحدى معتمدياتها؟ اعثر على حرفيين موثوقين، قارن التقييمات، واطلب تدخلهم الفوري عبر الهاتف أو الواتساب دون وسيط أو عمولة.`
              : `Besoin d’un dépannage ou de travaux en ${catName.toLowerCase()} dans la région de ${govName} ? Retrouvez les professionnels répertoriés, consultez les avis clients vérifiés et contactez-les en direct par téléphone ou WhatsApp sans aucun intermédiaire.`}
          </p>

          <div className="flex flex-wrap items-center gap-4 pt-2">
            <div className="flex items-center gap-2 text-xs font-semibold text-slate-700 dark:text-slate-300">
              <ShieldCheck className="w-4 h-4 text-emerald-600" />
              <span>{isAr ? 'حرفيون مفحوصون وموثوقون' : 'Profils vérifiés'}</span>
            </div>
            <div className="flex items-center gap-2 text-xs font-semibold text-slate-700 dark:text-slate-300">
              <Zap className="w-4 h-4 text-amber-500 fill-amber-500" />
              <span>{isAr ? 'متاحون لحالات الطوارئ 24/7' : 'Disponibles 24/7 en urgence'}</span>
            </div>
            <div className="flex items-center gap-2 text-xs font-semibold text-slate-700 dark:text-slate-300">
              <Award className="w-4 h-4 text-blue-600" />
              <span>{isAr ? '0 مليم عمولة على العمليات' : '0% de commission'}</span>
            </div>
          </div>
        </div>

        {/* Local Providers Grid */}
        <div className="space-y-6">
          <div className="flex items-center justify-between">
            <h2 className="text-xl font-bold text-slate-900 dark:text-white">
              {isAr
                ? `الحرفيون المتوفرون في ${govName} (${providers.length})`
                : `Professionnels disponibles à ${govName} (${providers.length})`}
            </h2>
            <Link
              href={`/${locale}/recherche?categorie=${categorySlug}&gouvernorat=${governorateSlug}`}
              className="text-xs font-semibold text-blue-600 hover:underline"
            >
              {isAr ? 'عرض في صفحة البحث الكاملة' : 'Filtres avancés'}
            </Link>
          </div>

          {providers.length > 0 ? (
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
              {providers.map((p) => (
                <ProviderCard key={p.id} provider={p} locale={locale} />
              ))}
            </div>
          ) : (
            <EmptyState
              title={
                isAr
                  ? `لا يوجد حرفيون حالياً في ${catName} بـ ${govName}`
                  : `Aucun artisan ${catName} n’est encore répertorié à ${govName}`
              }
              description={
                isAr
                  ? 'يمكنك الاطلاع على الحرفيين في الولايات المجاورة مثل سوسة أو المنستير، أو تسجيل نشاطك إذا كنت حرفياً.'
                  : 'Consultez les professionnels des gouvernorats voisins du Sahel ou devenez le premier artisan recommandé dans cette zone.'
              }
              actionLabel={isAr ? 'تصفح كل حرفيي الساحل' : 'Voir tous les artisans du Sahel'}
              actionHref={`/${locale}/recherche?categorie=${categorySlug}`}
            />
          )}
        </div>

        {/* Delegations Cloud */}
        {governorate.delegations.length > 0 && (
          <div className="bg-slate-50 dark:bg-slate-900/60 border border-slate-200 dark:border-slate-800 rounded-2xl p-6 space-y-3">
            <h3 className="font-bold text-sm text-slate-900 dark:text-white">
              {isAr
                ? `المعتمديات المغطاة في ولاية ${govName} :`
                : `Délégations couvertes dans le gouvernorat de ${govName} :`}
            </h3>
            <div className="flex flex-wrap gap-2">
              {governorate.delegations.map((del) => (
                <Link
                  key={del.id}
                  href={`/${locale}/recherche?categorie=${categorySlug}&gouvernorat=${governorateSlug}&delegation=${encodeURIComponent(del.nameFr)}`}
                  className="px-3 py-1.5 rounded-lg text-xs bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 text-slate-700 dark:text-slate-300 hover:border-blue-500 hover:text-blue-600 transition-colors font-medium"
                >
                  {isAr ? del.nameAr : del.nameFr}
                </Link>
              ))}
            </div>
          </div>
        )}

        {/* FAQ Section */}
        <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-2xl p-6 md:p-8 space-y-6">
          <div className="flex items-center gap-2">
            <HelpCircle className="w-5 h-5 text-blue-600" />
            <h3 className="font-bold text-lg text-slate-900 dark:text-white">
              {isAr
                ? `أسئلة شائعة حول خدمات ${catName} في ${govName}`
                : `Foire aux questions : ${catName} à ${govName}`}
            </h3>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-6 text-sm">
            <div className="space-y-2">
              <h4 className="font-bold text-slate-900 dark:text-white">
                {isAr
                  ? `كم تبلغ تكلفة تدخل حرفي ${catName} في ${govName} ؟`
                  : `Combien coûte une intervention de ${catName.toLowerCase()} à ${govName} ?`}
              </h4>
              <p className="text-slate-600 dark:text-slate-400 text-xs leading-relaxed">
                {isAr
                  ? 'تختلف الأسعار حسب طبيعة التدخل والمواد المطلوبة. يمكنك الإطلاع على جدول الأسعار التقديرية في صفحة كل حرفي والتواصل معه مباشرة للحصول على تسعيرة مجانية.'
                  : 'Les tarifs dépendent de l’urgence, de la complexité et des pièces requises. Chaque artisan affiche sur son profil sa grille indicative de prix à partir de 25 DT à 40 DT pour un diagnostic standard.'}
              </p>
            </div>

            <div className="space-y-2">
              <h4 className="font-bold text-slate-900 dark:text-white">
                {isAr
                  ? 'كيف يتم التواصل وحجز الموعد ؟'
                  : 'Comment réserver un rendez-vous avec l’artisan ?'}
              </h4>
              <p className="text-slate-600 dark:text-slate-400 text-xs leading-relaxed">
                {isAr
                  ? 'التواصل مباشر 100% عبر الهاتف أو تطبيق واتساب بعد الضغط على زر الاتصال. لا نفرض وسيطاً أو عمولة على مكالمتكم.'
                  : 'Le contact est direct par appel téléphonique ou message WhatsApp immédiat. Vous convenez ensemble de l’heure de passage et des détails de votre chantier.'}
              </p>
            </div>
          </div>
        </div>
      </div>
    </>
  );
}
