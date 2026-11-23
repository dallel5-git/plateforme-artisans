import createClient from 'openapi-fetch';
import type { paths } from './generated/schema';
import {
  DEMO_CATEGORIES,
  DEMO_GOVERNORATES,
  DEMO_PROVIDERS,
  type Category,
  type Governorate,
  type ProviderDetail,
  type ReviewItem,
} from './demo-data';

const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3001';

export const apiClient = createClient<paths>({
  baseUrl: API_BASE_URL,
});

/**
 * Service API unifié avec bascule gracieuse sur les données démo du Sahel
 * lorsque le backend en ligne n'est pas encore déployé (P5 / Low-bandwidth / Offline-ready).
 */
export const sanayaApi = {
  async getCategories(): Promise<Category[]> {
    try {
      const res = await apiClient.GET('/v1/categories');
      if (res.data?.categories) {
        return res.data.categories as unknown as Category[];
      }
    } catch {
      // repli gracieux
    }
    return DEMO_CATEGORIES;
  },

  async getGovernorates(): Promise<Governorate[]> {
    try {
      const res = await apiClient.GET('/v1/governorates');
      if (res.data?.governorates) {
        return res.data.governorates as unknown as Governorate[];
      }
    } catch {
      // repli gracieux
    }
    return DEMO_GOVERNORATES;
  },

  async searchProviders(params: {
    query?: string;
    categorySlug?: string;
    governorateSlug?: string;
    delegationSlug?: string;
    verifiedOnly?: boolean;
    emergencyOnly?: boolean;
    minRating?: number;
  }): Promise<{ items: ProviderDetail[]; total: number }> {
    try {
      const res = await apiClient.GET('/v1/providers/search', {
        params: {
          query: {
            query: params.query,
            category: params.categorySlug,
            governorate: params.governorateSlug || '',
            delegation: params.delegationSlug,
            isVerified: params.verifiedOnly,
          },
        },
      });
      if (res.data?.items && res.data.items.length > 0) {
        return {
          items: res.data.items as unknown as ProviderDetail[],
          total: res.data.items.length,
        };
      }
    } catch {
      // repli démo
    }

    // Filtrage dynamique sur les données de démonstration
    let filtered = [...DEMO_PROVIDERS];

    if (params.categorySlug) {
      filtered = filtered.filter(
        (p) =>
          p.primaryCategorySlug.toLowerCase() === params.categorySlug!.toLowerCase() ||
          p.categories.some((c) => c.slug.toLowerCase() === params.categorySlug!.toLowerCase()),
      );
    }

    if (params.governorateSlug) {
      filtered = filtered.filter(
        (p) => p.baseGovernorateSlug.toLowerCase() === params.governorateSlug!.toLowerCase(),
      );
    }

    if (params.delegationSlug) {
      filtered = filtered.filter((p) =>
        p.baseDelegationNameFr.toLowerCase().includes(params.delegationSlug!.toLowerCase()),
      );
    }

    if (params.verifiedOnly) {
      filtered = filtered.filter((p) => p.isVerified);
    }

    if (params.emergencyOnly) {
      filtered = filtered.filter((p) => p.acceptsEmergency);
    }

    if (params.minRating && params.minRating > 0) {
      filtered = filtered.filter((p) => p.ratingAvg >= params.minRating!);
    }

    if (params.query && params.query.trim().length > 0) {
      const q = params.query.toLowerCase().trim();
      filtered = filtered.filter(
        (p) =>
          p.businessName.toLowerCase().includes(q) ||
          p.headline.toLowerCase().includes(q) ||
          p.bio.toLowerCase().includes(q) ||
          p.primaryCategoryNameFr.toLowerCase().includes(q) ||
          p.primaryCategoryNameAr.toLowerCase().includes(q),
      );
    }

    return {
      items: filtered,
      total: filtered.length,
    };
  },

  async getProviderBySlug(slug: string): Promise<ProviderDetail | null> {
    try {
      const res = await apiClient.GET('/v1/providers/{slug}', {
        params: { path: { slug } },
      });
      if (res.data) {
        return res.data as unknown as ProviderDetail;
      }
    } catch {
      // repli démo
    }

    const found = DEMO_PROVIDERS.find((p) => p.slug.toLowerCase() === slug.toLowerCase());
    return found || null;
  },

  async recordContactEvent(params: {
    providerId: string;
    channel: 'PHONE' | 'WHATSAPP';
  }): Promise<{ phone: string; whatsappMessage: string }> {
    try {
      const res = await apiClient.POST('/v1/contact-events', {
        body: {
          providerId: params.providerId,
          channel: params.channel,
          sourceScreen: 'profile',
        },
      });
      if (res.data?.phone) {
        return {
          phone: res.data.phone,
          whatsappMessage:
            res.data.whatsappMessage ||
            'Bonjour, je vous contacte via Sanaya pour une demande de prestation.',
        };
      }
    } catch {
      // repli démo
    }

    const provider = DEMO_PROVIDERS.find((p) => p.id === params.providerId);
    return {
      phone: provider?.phone || '+21620654321',
      whatsappMessage: `Bonjour ${provider?.businessName || ''}, je vous contacte via Sanaya pour une demande de prestation.`,
    };
  },

  async addReview(
    providerId: string,
    review: { rating: number; comment: string; authorName?: string },
  ): Promise<ReviewItem> {
    try {
      const res = await apiClient.POST('/v1/providers/{id}/reviews', {
        params: { path: { id: providerId } },
        body: {
          rating: review.rating,
          comment: review.comment,
        },
      });
      if (res.data) {
        return res.data as unknown as ReviewItem;
      }
    } catch {
      // repli démo
    }

    const newRev: ReviewItem = {
      id: `rev-${Date.now()}`,
      authorName: review.authorName || 'Client vérifié',
      rating: review.rating,
      comment: review.comment,
      isVerifiedContact: true,
      createdAt: new Date().toISOString(),
    };

    const prov = DEMO_PROVIDERS.find((p) => p.id === providerId);
    if (prov) {
      prov.reviews = [newRev, ...prov.reviews];
      prov.ratingCount += 1;
      prov.ratingAvg = Number(
        (prov.reviews.reduce((acc, r) => acc + r.rating, 0) / prov.reviews.length).toFixed(1),
      );
    }

    return newRev;
  },
};
