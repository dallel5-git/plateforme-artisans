/**
 * BE-25 — `packages/core/src/favorites/list-item.ts`
 *
 * Pure : assemble une ligne de `GET /v1/favorites` à partir d'un `Favorite` et d'un résumé
 * de prestataire. Aucun accès base ni réseau.
 */
import { describe, expect, it } from 'vitest';
import { buildFavoriteListItem } from '../src/favorites/list-item.js';

describe('BE-25 — buildFavoriteListItem', () => {
  it('assemble le favori et le résumé du prestataire en une ligne de réponse', () => {
    const favorite = { providerId: 'provider-1', createdAt: new Date('2026-08-20T10:00:00Z') };
    const provider = {
      slug: 'ahmed-plombier-sousse',
      businessName: 'Ahmed Plomberie',
      headline: 'Plombier certifié',
      isVerified: true,
      ratingAvg: 4.5,
      ratingCount: 12,
      availabilityStatus: 'AVAILABLE' as const,
    };

    expect(buildFavoriteListItem(favorite, provider)).toEqual({
      providerId: 'provider-1',
      slug: 'ahmed-plombier-sousse',
      businessName: 'Ahmed Plomberie',
      headline: 'Plombier certifié',
      isVerified: true,
      ratingAvg: 4.5,
      ratingCount: 12,
      availabilityStatus: 'AVAILABLE',
      favoritedAt: favorite.createdAt,
    });
  });

  it("ne divulgue aucun champ interne au-delà de providerId (pas d'userId, pas d'id de profil)", () => {
    const favorite = { providerId: 'provider-2', createdAt: new Date('2026-08-21T08:00:00Z') };
    const provider = {
      slug: 'sami-electricien',
      businessName: 'Sami Électricité',
      headline: null,
      isVerified: false,
      ratingAvg: 0,
      ratingCount: 0,
      availabilityStatus: 'BUSY' as const,
    };

    const item = buildFavoriteListItem(favorite, provider);

    expect(Object.keys(item).sort()).toEqual(
      [
        'providerId',
        'slug',
        'businessName',
        'headline',
        'isVerified',
        'ratingAvg',
        'ratingCount',
        'availabilityStatus',
        'favoritedAt',
      ].sort(),
    );
  });
});
