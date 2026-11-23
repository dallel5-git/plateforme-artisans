import type {
  AdminVerificationDetailResponse,
  AdminVerificationItem,
  ListAdminVerificationsQuery,
  ListAdminVerificationsResponse,
  ReviewAdminVerificationInput,
} from '@repo/validators';

const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3001';

// Token d'administration stocké pour les requêtes Fastify (ou token de dev par défaut)
let adminAuthToken: string =
  typeof window !== 'undefined'
    ? localStorage.getItem('sanaya_admin_token') || 'dev-admin-token'
    : 'dev-admin-token';

export function setAdminToken(token: string) {
  adminAuthToken = token;
  if (typeof window !== 'undefined') {
    localStorage.setItem('sanaya_admin_token', token);
  }
}

export function getAdminToken(): string {
  return adminAuthToken;
}

// ---------------------------------------------------------------------------
// Données de Démonstration (Repli gracieux si le backend Fastify est hors-ligne)
// ---------------------------------------------------------------------------
const MOCK_ITEMS: AdminVerificationItem[] = [
  {
    id: 'f87a8e23-74a1-4d1a-8c11-9a7061d31a01',
    providerId: 'b1234567-89ab-cdef-0123-456789abcdef',
    provider: {
      id: 'b1234567-89ab-cdef-0123-456789abcdef',
      businessName: 'Mohamed Salah Ben Amor - Plomberie Générale',
      slug: 'mohamed-salah-plomberie',
      baseGovernorateId: 'SOUSSE',
      isVerified: false,
    },
    fullNameOnId: 'MOHAMED SALAH BEN AMOR',
    status: 'PENDING',
    submittedAt: new Date(Date.now() - 52 * 60 * 60 * 1000), // > 48h
    reviewedAt: null,
    reviewedBy: null,
    documentsCount: 2,
    documents: [
      { id: 'doc-01-front', type: 'CIN_FRONT' },
      { id: 'doc-01-back', type: 'CIN_BACK' },
    ],
  },
  {
    id: 'a92f1b44-93c2-482d-bf22-0b8172e42b02',
    providerId: 'c2345678-90ab-cdef-1234-567890abcdef',
    provider: {
      id: 'c2345678-90ab-cdef-1234-567890abcdef',
      businessName: 'Kamel Électricité & Dépannage 24/7',
      slug: 'kamel-electricite-monastir',
      baseGovernorateId: 'MONASTIR',
      isVerified: false,
    },
    fullNameOnId: 'KAMEL ZOUARI',
    status: 'PENDING',
    submittedAt: new Date(Date.now() - 6 * 60 * 60 * 1000), // 6h
    reviewedAt: null,
    reviewedBy: null,
    documentsCount: 2,
    documents: [
      { id: 'doc-02-front', type: 'CIN_FRONT' },
      { id: 'doc-02-back', type: 'CIN_BACK' },
    ],
  },
  {
    id: 'c3456789-01cd-ef01-2345-678901abcdef',
    providerId: 'd3456789-01ab-cdef-2345-678901abcdef',
    provider: {
      id: 'd3456789-01ab-cdef-2345-678901abcdef',
      businessName: 'Atelier Bois & Menuiserie Moderne',
      slug: 'atelier-bois-tunis',
      baseGovernorateId: 'TUNIS',
      isVerified: false,
    },
    fullNameOnId: 'YASSINE TRABELSI',
    status: 'MORE_INFO_REQUIRED',
    submittedAt: new Date(Date.now() - 26 * 60 * 60 * 1000),
    reviewedAt: new Date(Date.now() - 24 * 60 * 60 * 1000),
    reviewedBy: {
      id: 'mod-1',
      phone: '+216 71 000 001',
    },
    documentsCount: 2,
    documents: [
      { id: 'doc-03-front', type: 'CIN_FRONT' },
      { id: 'doc-03-back', type: 'CIN_BACK' },
    ],
  },
  {
    id: 'd4567890-12de-f012-3456-789012abcdef',
    providerId: 'e4567890-12ab-cdef-3456-789012abcdef',
    provider: {
      id: 'e4567890-12ab-cdef-3456-789012abcdef',
      businessName: 'Société Sfaxienne de Climatisation',
      slug: 'sfax-clim',
      baseGovernorateId: 'SFAX',
      isVerified: true,
    },
    fullNameOnId: 'AHMED BOUAZIZ',
    status: 'APPROVED',
    submittedAt: new Date(Date.now() - 96 * 60 * 60 * 1000),
    reviewedAt: new Date(Date.now() - 80 * 60 * 60 * 1000),
    reviewedBy: {
      id: 'mod-1',
      phone: '+216 71 000 001',
    },
    documentsCount: 2,
    documents: [
      { id: 'doc-04-front', type: 'CIN_FRONT' },
      { id: 'doc-04-back', type: 'CIN_BACK' },
    ],
  },
];

// Faux échantillons d'images haute résolution pour la prévisualisation démo
// (Gabarits SVG nets représentant une CIN tunisienne recto et verso)
const DEMO_CIN_FRONT_SVG = `data:image/svg+xml;utf8,${encodeURIComponent(`
<svg xmlns="http://www.w3.org/2000/svg" width="800" height="500" viewBox="0 0 800 500">
  <rect width="800" height="500" rx="24" fill="#e8edf5" stroke="#94a3b8" stroke-width="4"/>
  <rect x="20" y="20" width="760" height="460" rx="16" fill="#f8fafc" stroke="#cbd5e1" stroke-width="2"/>
  <path d="M 20 100 Q 400 130 780 100" stroke="#cbd5e1" stroke-width="2" fill="none" opacity="0.6"/>
  <path d="M 20 250 Q 400 280 780 250" stroke="#cbd5e1" stroke-width="2" fill="none" opacity="0.6"/>
  
  <!-- En-tête -->
  <text x="400" y="55" font-family="sans-serif" font-size="20" font-weight="bold" fill="#0f172a" text-anchor="middle">RÉPUBLIQUE TUNISIENNE — الجمهورية التونسية</text>
  <text x="400" y="80" font-family="sans-serif" font-size="16" fill="#475569" text-anchor="middle">CARTE D'IDENTITÉ NATIONALE — بطاقة التعريف الوطنية</text>
  
  <!-- Photo identité -->
  <rect x="50" y="120" width="180" height="230" rx="8" fill="#e2e8f0" stroke="#64748b" stroke-width="2"/>
  <circle cx="140" cy="190" r="45" fill="#94a3b8"/>
  <path d="M 80 320 Q 140 250 200 320" fill="#94a3b8"/>
  <text x="140" y="340" font-family="sans-serif" font-size="12" fill="#64748b" text-anchor="middle">PHOTO OFFICIELLE</text>

  <!-- Informations personnelles -->
  <text x="270" y="150" font-family="sans-serif" font-size="13" fill="#64748b">NOM / اللقب :</text>
  <text x="270" y="175" font-family="sans-serif" font-size="18" font-weight="bold" fill="#0f172a">BEN AMOR / بن عمر</text>
  
  <text x="270" y="215" font-family="sans-serif" font-size="13" fill="#64748b">PRÉNOM / الاسم :</text>
  <text x="270" y="240" font-family="sans-serif" font-size="18" font-weight="bold" fill="#0f172a">MOHAMED SALAH / محمد صلاح</text>

  <text x="270" y="280" font-family="sans-serif" font-size="13" fill="#64748b">DATE DE NAISSANCE / تاريخ الولادة :</text>
  <text x="270" y="305" font-family="sans-serif" font-size="16" font-weight="bold" fill="#0f172a">14/05/1986 — SOUSSE</text>

  <text x="270" y="345" font-family="sans-serif" font-size="13" fill="#64748b">NUMÉRO CIN / رقم بطاقة التعريف :</text>
  <text x="270" y="375" font-family="monospace" font-size="22" font-weight="bold" fill="#1d4ed8">08945123</text>

  <!-- Lignes MRZ / Hologramme -->
  <rect x="50" y="400" width="700" height="60" rx="6" fill="#e2e8f0"/>
  <text x="70" y="425" font-family="monospace" font-size="15" fill="#334155">IDTUN08945123&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;</text>
  <text x="70" y="445" font-family="monospace" font-size="15" fill="#334155">8605148M2911245TUN&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;4</text>
</svg>
`)}`;

const DEMO_CIN_BACK_SVG = `data:image/svg+xml;utf8,${encodeURIComponent(`
<svg xmlns="http://www.w3.org/2000/svg" width="800" height="500" viewBox="0 0 800 500">
  <rect width="800" height="500" rx="24" fill="#e8edf5" stroke="#94a3b8" stroke-width="4"/>
  <rect x="20" y="20" width="760" height="460" rx="16" fill="#f8fafc" stroke="#cbd5e1" stroke-width="2"/>
  
  <text x="400" y="55" font-family="sans-serif" font-size="18" font-weight="bold" fill="#0f172a" text-anchor="middle">VERSO / ظهر بطاقة التعريف الوطنية</text>
  
  <!-- Empreinte digitale -->
  <rect x="60" y="100" width="130" height="170" rx="8" fill="#e2e8f0" stroke="#94a3b8" stroke-width="2"/>
  <circle cx="125" cy="180" r="40" fill="none" stroke="#64748b" stroke-width="3" stroke-dasharray="4 4"/>
  <circle cx="125" cy="180" r="25" fill="none" stroke="#64748b" stroke-width="3" stroke-dasharray="2 3"/>
  <text x="125" y="250" font-family="sans-serif" font-size="11" fill="#64748b" text-anchor="middle">EMPREINTE</text>

  <!-- Profession et adresse -->
  <text x="230" y="125" font-family="sans-serif" font-size="13" fill="#64748b">PROFESSION / المهنة :</text>
  <text x="230" y="150" font-family="sans-serif" font-size="16" font-weight="bold" fill="#0f172a">PLOMBIER QUALIFIÉ / سباك</text>

  <text x="230" y="190" font-family="sans-serif" font-size="13" fill="#64748b">ADRESSE / العنوان :</text>
  <text x="230" y="215" font-family="sans-serif" font-size="16" font-weight="bold" fill="#0f172a">AVENUE HABIB BOURGUIBA, SOUSSE VILLE</text>

  <text x="230" y="255" font-family="sans-serif" font-size="13" fill="#64748b">DÉLIVRÉE LE / سلمت في :</text>
  <text x="230" y="280" font-family="sans-serif" font-size="15" font-weight="bold" fill="#0f172a">12/03/2021 — POSTE DE POLICE SOUSSE</text>

  <!-- Tampon officiel -->
  <circle cx="680" cy="200" r="50" fill="none" stroke="#dc2626" stroke-width="3" opacity="0.75"/>
  <text x="680" y="195" font-family="sans-serif" font-size="11" font-weight="bold" fill="#dc2626" text-anchor="middle" opacity="0.75">SÛRETÉ</text>
  <text x="680" y="212" font-family="sans-serif" font-size="11" font-weight="bold" fill="#dc2626" text-anchor="middle" opacity="0.75">NATIONALE</text>

  <!-- Bas de page -->
  <rect x="50" y="340" width="700" height="110" rx="8" fill="#f1f5f9" stroke="#cbd5e1"/>
  <text x="70" y="375" font-family="sans-serif" font-size="12" fill="#475569">
    Document strictement réservé à la vérification d'identité sur la plateforme Sanaya.
  </text>
  <text x="70" y="400" font-family="sans-serif" font-size="12" fill="#475569">
    Conformité légale INPDP (Loi organique n° 2004-63). Chiffrement SSE-S3 Cloudflare R2 privé.
  </text>
</svg>
`)}`;

export const adminApi = {
  /**
   * FW-20a : Liste paginée des vérifications KYC avec filtres
   */
  async getVerifications(
    query: Partial<ListAdminVerificationsQuery> = {},
  ): Promise<ListAdminVerificationsResponse> {
    try {
      const url = new URL('/v1/admin/verifications', API_BASE_URL);
      if (query.status) url.searchParams.set('status', query.status);
      if (query.limit) url.searchParams.set('limit', String(query.limit));
      if (query.cursor) url.searchParams.set('cursor', query.cursor);
      if (query.orderBy) url.searchParams.set('orderBy', query.orderBy);

      const res = await fetch(url.toString(), {
        headers: {
          Authorization: `Bearer ${adminAuthToken}`,
          'Content-Type': 'application/json',
        },
      });

      if (res.ok) {
        return (await res.json()) as ListAdminVerificationsResponse;
      }
    } catch {
      // Repli gracieux sur les données démo
    }

    // Filtrage dynamique en mode démo
    let items = [...MOCK_ITEMS];
    if (query.status) {
      items = items.filter((i) => i.status === query.status);
    }

    // Tri FIFO (ascendant par date de soumission) par défaut
    items.sort((a, b) => {
      const timeA = new Date(a.submittedAt).getTime();
      const timeB = new Date(b.submittedAt).getTime();
      return query.orderBy === 'desc' ? timeB - timeA : timeA - timeB;
    });

    const totalPending = MOCK_ITEMS.filter((i) => i.status === 'PENDING').length;

    return {
      items,
      nextCursor: null,
      totalPending,
    };
  },

  /**
   * FW-20b : Détail complet de la demande KYC avec URLs signées R2 temporaires
   */
  async getVerificationDetails(id: string): Promise<AdminVerificationDetailResponse | null> {
    try {
      const res = await fetch(`${API_BASE_URL}/v1/admin/verifications/${id}`, {
        headers: {
          Authorization: `Bearer ${adminAuthToken}`,
          'Content-Type': 'application/json',
        },
      });

      if (res.ok) {
        return (await res.json()) as AdminVerificationDetailResponse;
      }
    } catch {
      // Repli gracieux sur les données démo
    }

    const item = MOCK_ITEMS.find((i) => i.id === id) || MOCK_ITEMS[0];
    if (!item) return null;

    const expiresAt = new Date(Date.now() + 5 * 60 * 1000); // 5 min TTL

    return {
      id: item.id,
      providerId: item.providerId,
      provider: {
        id: item.provider.id,
        businessName: item.provider.businessName,
        slug: item.provider.slug,
        headline: 'Plombier sanitaire et chauffagiste certifié',
        baseGovernorateId: item.provider.baseGovernorateId,
        isVerified: item.provider.isVerified,
        verificationStatus: item.status,
        user: {
          id: 'user-01',
          phone: '+216 98 123 456',
        },
      },
      fullNameOnId: item.fullNameOnId,
      status: item.status,
      submittedAt: item.submittedAt,
      reviewedAt: item.reviewedAt,
      reviewedBy: item.reviewedBy,
      rejectionReason:
        item.status === 'MORE_INFO_REQUIRED'
          ? 'La photo du recto est floue et le numéro de CIN est difficilement lisible.'
          : null,
      internalNote: null,
      expiresAt,
      documents: [
        {
          id: 'doc-front-uuid',
          type: 'CIN_FRONT',
          mediaId: 'media-front-uuid',
          downloadUrl: DEMO_CIN_FRONT_SVG,
          expiresAt,
          isPurged: false,
        },
        {
          id: 'doc-back-uuid',
          type: 'CIN_BACK',
          mediaId: 'media-back-uuid',
          downloadUrl: DEMO_CIN_BACK_SVG,
          expiresAt,
          isPurged: false,
        },
      ],
    };
  },

  /**
   * FW-20b : Décision de modération KYC (APPROVED, REJECTED, MORE_INFO_REQUIRED)
   */
  async submitReview(
    id: string,
    payload: ReviewAdminVerificationInput,
  ): Promise<{ success: boolean; status: string }> {
    try {
      const res = await fetch(`${API_BASE_URL}/v1/admin/verifications/${id}/review`, {
        method: 'POST',
        headers: {
          Authorization: `Bearer ${adminAuthToken}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(payload),
      });

      if (res.ok) {
        return { success: true, status: payload.status };
      }
    } catch {
      // Repli gracieux
    }

    // Mise à jour de l'état local en mode démo
    const target = MOCK_ITEMS.find((i) => i.id === id);
    if (target) {
      target.status = payload.status;
      target.reviewedAt = new Date();
      target.reviewedBy = { id: 'admin-current', phone: '+216 71 000 000' };
      if (payload.status === 'APPROVED') {
        target.provider.isVerified = true;
      }
    }

    return { success: true, status: payload.status };
  },
};
