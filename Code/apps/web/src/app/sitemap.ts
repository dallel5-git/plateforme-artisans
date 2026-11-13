import type { MetadataRoute } from 'next';
import { DEMO_CATEGORIES, DEMO_GOVERNORATES, DEMO_PROVIDERS } from '@/lib/api/demo-data';

const BASE_URL = process.env.NEXT_PUBLIC_SITE_URL || 'https://sanaya.tn';

export default function sitemap(): MetadataRoute.Sitemap {
  const routes: MetadataRoute.Sitemap = [];
  const locales = ['fr', 'ar'];

  // Static marketing pages
  const staticPaths = [
    '',
    '/recherche',
    '/comment-ca-marche',
    '/devenir-artisan',
    '/tarifs',
    '/legal/cgu',
    '/legal/confidentialite',
    '/legal/mentions-legales',
  ];

  for (const locale of locales) {
    for (const path of staticPaths) {
      routes.push({
        url: `${BASE_URL}/${locale}${path}`,
        lastModified: new Date(),
        changeFrequency: path === '' ? 'daily' : 'weekly',
        priority: path === '' ? 1.0 : 0.8,
      });
    }

    // SEO landing pages : category × governorate
    for (const cat of DEMO_CATEGORIES) {
      for (const gov of DEMO_GOVERNORATES) {
        routes.push({
          url: `${BASE_URL}/${locale}/${cat.slug}/${gov.slug}`,
          lastModified: new Date(),
          changeFrequency: 'weekly',
          priority: 0.9,
        });
      }
    }

    // Artisan profiles
    for (const prov of DEMO_PROVIDERS) {
      routes.push({
        url: `${BASE_URL}/${locale}/artisans/${prov.slug}`,
        lastModified: new Date(),
        changeFrequency: 'daily',
        priority: 0.85,
      });
    }
  }

  return routes;
}
