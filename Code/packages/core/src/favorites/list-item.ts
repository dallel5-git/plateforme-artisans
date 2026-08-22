import type { AvailabilityStatus } from '@repo/db';

export interface FavoriteRecord {
  providerId: string;
  createdAt: Date;
}

export interface FavoriteProviderSummary {
  slug: string;
  businessName: string;
  headline: string | null;
  isVerified: boolean;
  ratingAvg: number;
  ratingCount: number;
  availabilityStatus: AvailabilityStatus;
}

export interface FavoriteListItem {
  providerId: string;
  slug: string;
  businessName: string;
  headline: string | null;
  isVerified: boolean;
  ratingAvg: number;
  ratingCount: number;
  availabilityStatus: AvailabilityStatus;
  favoritedAt: Date;
}

// BE-25 : assemble une ligne de `GET /v1/favorites` — aucun identifiant interne autre que
// `providerId` (nécessaire côté client pour retirer le favori), même logique de « pas de champ
// interne dans une réponse publique » que `reviewListSelect` (packages/db, BE-18b).
export function buildFavoriteListItem(
  favorite: FavoriteRecord,
  provider: FavoriteProviderSummary,
): FavoriteListItem {
  return {
    providerId: favorite.providerId,
    slug: provider.slug,
    businessName: provider.businessName,
    headline: provider.headline,
    isVerified: provider.isVerified,
    ratingAvg: provider.ratingAvg,
    ratingCount: provider.ratingCount,
    availabilityStatus: provider.availabilityStatus,
    favoritedAt: favorite.createdAt,
  };
}
