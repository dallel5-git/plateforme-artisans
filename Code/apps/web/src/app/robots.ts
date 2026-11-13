import type { MetadataRoute } from 'next';

export default function robots(): MetadataRoute.Robots {
  const baseUrl = process.env.NEXT_PUBLIC_SITE_URL || 'https://sanaya.tn';

  return {
    rules: [
      {
        userAgent: '*',
        allow: '/',
        disallow: ['/api/', '/*/(account)/', '/*/verification-otp'],
      },
    ],
    sitemap: `${baseUrl}/sitemap.xml`,
  };
}
