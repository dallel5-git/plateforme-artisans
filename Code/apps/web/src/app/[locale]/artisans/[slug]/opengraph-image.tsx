import { ImageResponse } from 'next/og';
import { sanayaApi } from '@/lib/api/client';

export const runtime = 'edge';
export const alt = 'Profil Artisan Sanaya';
export const size = {
  width: 1200,
  height: 630,
};
export const contentType = 'image/png';

interface Props {
  params: Promise<{
    locale: string;
    slug: string;
  }>;
}

export default async function Image({ params }: Props) {
  const { slug } = await params;
  const provider = await sanayaApi.getProviderBySlug(slug);

  const name = provider?.businessName || 'Artisan Qualifié';
  const category = provider?.primaryCategoryNameFr || 'Artisan';
  const location = `${provider?.baseDelegationNameFr || 'Sahel'}, ${provider?.baseGovernorateNameFr || 'Tunisie'}`;
  const rating = provider?.ratingAvg ? provider.ratingAvg.toFixed(1) : '5.0';
  const reviewsCount = provider?.ratingCount || 0;

  return new ImageResponse(
    <div
      style={{
        height: '100%',
        width: '100%',
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'flex-start',
        justifyContent: 'space-between',
        backgroundColor: '#0f172a',
        backgroundImage: 'radial-gradient(circle at 25px 25px, #1e293b 2%, transparent 0%)',
        backgroundSize: '50px 50px',
        padding: '60px 80px',
        fontFamily: 'sans-serif',
        color: '#ffffff',
      }}
    >
      {/* Top Header Logo */}
      <div style={{ display: 'flex', alignItems: 'center', gap: '16px' }}>
        <div
          style={{
            width: '48px',
            height: '48px',
            borderRadius: '12px',
            backgroundColor: '#2563eb',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            fontWeight: '900',
            fontSize: '28px',
          }}
        >
          S
        </div>
        <span style={{ fontSize: '28px', fontWeight: '800', letterSpacing: '-0.5px' }}>
          Sanaya <span style={{ color: '#60a5fa' }}>.tn</span>
        </span>
        <span
          style={{
            marginLeft: '16px',
            fontSize: '16px',
            padding: '6px 14px',
            borderRadius: '999px',
            backgroundColor: '#1e3a8a',
            color: '#93c5fd',
            fontWeight: '700',
          }}
        >
          {category}
        </span>
      </div>

      {/* Center Pro Info */}
      <div style={{ display: 'flex', flexDirection: 'column', gap: '16px', maxWidth: '900px' }}>
        <h1
          style={{
            fontSize: '56px',
            fontWeight: '900',
            lineHeight: '1.1',
            margin: '0',
            letterSpacing: '-1px',
          }}
        >
          {name}
        </h1>
        <p style={{ fontSize: '24px', color: '#94a3b8', margin: '0' }}>
          {location} • Contact direct Téléphone & WhatsApp
        </p>
      </div>

      {/* Bottom Bar Badges */}
      <div
        style={{
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'space-between',
          width: '100%',
          borderTop: '2px solid #334155',
          paddingTop: '30px',
        }}
      >
        <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
          <span style={{ fontSize: '32px', color: '#fbbf24' }}>★</span>
          <span style={{ fontSize: '28px', fontWeight: '800' }}>{rating}</span>
          <span style={{ fontSize: '20px', color: '#94a3b8' }}>
            ({reviewsCount} avis clients vérifiés)
          </span>
        </div>

        <div
          style={{
            fontSize: '18px',
            fontWeight: '700',
            color: '#34d399',
            display: 'flex',
            alignItems: 'center',
            gap: '8px',
          }}
        >
          ✓ 0% Commission • Profil Vérifié
        </div>
      </div>
    </div>,
    {
      ...size,
    },
  );
}
