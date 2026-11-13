import React from 'react';
import type { Metadata } from 'next';
import { notFound } from 'next/navigation';
import { sanayaApi } from '@/lib/api/client';
import { ReviewFormClient } from './ReviewFormClient';

interface PageProps {
  params: Promise<{
    locale: string;
    slug: string;
  }>;
}

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale, slug } = await params;
  const isAr = locale === 'ar';

  const provider = await sanayaApi.getProviderBySlug(slug);
  if (!provider) {
    return { title: 'Artisan introuvable | Sanaya' };
  }

  const title = isAr
    ? `تقييم ${provider.businessName} | صَنَايعِيّة`
    : `Donner un avis sur ${provider.businessName} | Sanaya`;

  return {
    title,
    description: `Partagez votre avis et notez les prestations de ${provider.businessName} sur la plateforme Sanaya.`,
  };
}

export default async function AddReviewPage({ params }: PageProps) {
  const { locale, slug } = await params;

  const provider = await sanayaApi.getProviderBySlug(slug);
  if (!provider) {
    notFound();
  }

  return (
    <div className="container mx-auto px-4 py-8">
      <ReviewFormClient provider={provider} locale={locale} />
    </div>
  );
}
