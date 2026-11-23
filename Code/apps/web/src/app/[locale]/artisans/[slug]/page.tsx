import React from 'react';
import type { Metadata } from 'next';
import Link from 'next/link';
import { notFound } from 'next/navigation';
import { ChevronRight } from 'lucide-react';
import { sanayaApi } from '@/lib/api/client';
import { DEMO_PROVIDERS } from '@/lib/api/demo-data';
import { ArtisanProfileClient } from './ArtisanProfileClient';

interface PageProps {
  params: Promise<{
    locale: string;
    slug: string;
  }>;
}

export async function generateStaticParams() {
  const locales = ['fr', 'ar'];
  const params: { locale: string; slug: string }[] = [];

  for (const locale of locales) {
    for (const provider of DEMO_PROVIDERS) {
      params.push({
        locale,
        slug: provider.slug,
      });
    }
  }

  return params;
}

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale, slug } = await params;
  const isAr = locale === 'ar';

  const provider = await sanayaApi.getProviderBySlug(slug);
  if (!provider) {
    return { title: 'Artisan introuvable | Sanaya' };
  }

  const categoryName = isAr ? provider.primaryCategoryNameAr : provider.primaryCategoryNameFr;
  const governorateName = isAr ? provider.baseGovernorateNameAr : provider.baseGovernorateNameFr;

  const title = isAr
    ? `${provider.businessName} - ${categoryName} à ${governorateName} | صَنَايعِيّة`
    : `${provider.businessName} - ${categoryName} à ${governorateName} (Sahel) | Sanaya`;

  const description = `${provider.headline}. Avis clients vérifiés (${provider.ratingAvg}/5 sur ${provider.ratingCount} avis). Contact direct téléphone et WhatsApp sans commission.`;

  return {
    title,
    description,
    openGraph: {
      title,
      description,
      type: 'profile',
      images: [
        {
          url: provider.avatarUrl,
          width: 400,
          height: 400,
          alt: provider.businessName,
        },
      ],
    },
    alternates: {
      canonical: `https://sanaya.tn/${locale}/artisans/${slug}`,
      languages: {
        fr: `https://sanaya.tn/fr/artisans/${slug}`,
        ar: `https://sanaya.tn/ar/artisans/${slug}`,
      },
    },
  };
}

export default async function ArtisanProfilePage({ params }: PageProps) {
  const { locale, slug } = await params;
  const isAr = locale === 'ar';

  const provider = await sanayaApi.getProviderBySlug(slug);
  if (!provider) {
    notFound();
  }

  const categoryName = isAr ? provider.primaryCategoryNameAr : provider.primaryCategoryNameFr;

  // Structured Data Schema.org
  const jsonLd = {
    '@context': 'https://schema.org',
    '@type': 'LocalBusiness',
    name: provider.businessName,
    image: provider.avatarUrl,
    telephone: provider.phone,
    description: provider.bio,
    address: {
      '@type': 'PostalAddress',
      addressLocality: provider.baseDelegationNameFr,
      addressRegion: provider.baseGovernorateNameFr,
      addressCountry: 'TN',
    },
    geo: {
      '@type': 'GeoCoordinates',
      latitude: 35.8256,
      longitude: 10.6369,
    },
    aggregateRating: {
      '@type': 'AggregateRating',
      ratingValue: provider.ratingAvg,
      reviewCount: provider.ratingCount,
      bestRating: 5,
      worstRating: 1,
    },
    makesOffer: provider.offerings.map((off) => ({
      '@type': 'Offer',
      itemOffered: {
        '@type': 'Service',
        name: off.titleFr,
        description: off.descriptionFr,
      },
      priceSpecification: {
        '@type': 'PriceSpecification',
        price: off.priceStartingAt / 1000,
        priceCurrency: 'TND',
      },
    })),
  };

  return (
    <>
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }}
      />

      <div className="container mx-auto px-4 py-8 space-y-6">
        {/* Breadcrumb */}
        <nav
          aria-label="Breadcrumb"
          className="flex items-center gap-2 text-xs text-slate-500 dark:text-slate-400"
        >
          <Link href={`/${locale}`} className="hover:text-blue-600 transition-colors">
            {isAr ? 'الرئيسية' : 'Accueil'}
          </Link>
          <ChevronRight className="w-3.5 h-3.5 rtl:rotate-180 text-slate-400" />
          <Link
            href={`/${locale}/recherche?categorie=${provider.primaryCategorySlug}`}
            className="hover:text-blue-600 transition-colors"
          >
            {categoryName}
          </Link>
          <ChevronRight className="w-3.5 h-3.5 rtl:rotate-180 text-slate-400" />
          <span className="font-semibold text-slate-800 dark:text-slate-200">
            {provider.businessName}
          </span>
        </nav>

        {/* Profile Component */}
        <ArtisanProfileClient provider={provider} locale={locale} />
      </div>
    </>
  );
}
