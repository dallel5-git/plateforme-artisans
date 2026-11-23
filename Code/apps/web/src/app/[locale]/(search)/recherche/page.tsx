import React, { Suspense } from 'react';
import type { Metadata } from 'next';
import { sanayaApi } from '@/lib/api/client';
import { SearchFilterClient } from './SearchFilterClient';
import { Skeleton } from '@/components/ui/Skeleton';

interface PageProps {
  params: Promise<{ locale: string }>;
  searchParams: Promise<{ [key: string]: string | string[] | undefined }>;
}

export async function generateMetadata({ params, searchParams }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  const sp = await searchParams;
  const isAr = locale === 'ar';
  const q = typeof sp.q === 'string' ? sp.q : '';

  const title = q
    ? isAr
      ? `البحث عن "${q}" في تونس | صَنَايعِيّة`
      : `Recherche "${q}" en Tunisie | Sanaya`
    : isAr
      ? 'البحث عن حرفي موثوق في الساحل | صَنَايعِيّة'
      : 'Trouver un artisan qualifié au Sahel | Sanaya';

  const description = isAr
    ? 'اعثر على أفضل السباكين والكهربائيين والنجارين في سوسة، المنستير، والمهدية مع أرقام الهاتف المباشرة والتقييمات.'
    : 'Trouvez et contactez directement les meilleurs artisans au Sahel (Sousse, Monastir, Mahdia) : plomberie, électricité, climatisation, peinture.';

  return {
    title,
    description,
    openGraph: {
      title,
      description,
      type: 'website',
    },
  };
}

export default async function SearchPage({ params, searchParams }: PageProps) {
  const { locale } = await params;
  const sp = await searchParams;

  const initialQuery = typeof sp.q === 'string' ? sp.q : '';
  const initialCategory = typeof sp.categorie === 'string' ? sp.categorie : '';
  const initialGovernorate = typeof sp.gouvernorat === 'string' ? sp.gouvernorat : '';
  const initialDelegation = typeof sp.delegation === 'string' ? sp.delegation : '';
  const verifiedOnly = sp.verifie === '1';
  const emergencyOnly = sp.urgence === '1';
  const minRating = typeof sp.note === 'string' ? Number(sp.note) : undefined;

  // Récupération simultanée des données de base et des artisans initiaux
  const [categories, governorates, searchResult] = await Promise.all([
    sanayaApi.getCategories(),
    sanayaApi.getGovernorates(),
    sanayaApi.searchProviders({
      query: initialQuery,
      categorySlug: initialCategory,
      governorateSlug: initialGovernorate,
      delegationSlug: initialDelegation,
      verifiedOnly,
      emergencyOnly,
      minRating,
    }),
  ]);

  return (
    <div className="container mx-auto px-4 py-8">
      <Suspense
        fallback={
          <div className="space-y-6">
            <Skeleton className="h-16 w-full rounded-2xl" />
            <div className="grid grid-cols-1 lg:grid-cols-4 gap-6">
              <Skeleton className="h-96 w-full rounded-2xl hidden lg:block" />
              <div className="lg:col-span-3 grid grid-cols-1 md:grid-cols-2 gap-4">
                <Skeleton className="h-64 w-full rounded-2xl" />
                <Skeleton className="h-64 w-full rounded-2xl" />
                <Skeleton className="h-64 w-full rounded-2xl" />
                <Skeleton className="h-64 w-full rounded-2xl" />
              </div>
            </div>
          </div>
        }
      >
        <SearchFilterClient
          locale={locale}
          categories={categories}
          governorates={governorates}
          initialProviders={searchResult.items}
          initialQuery={initialQuery}
          initialCategory={initialCategory}
          initialGovernorate={initialGovernorate}
        />
      </Suspense>
    </div>
  );
}
