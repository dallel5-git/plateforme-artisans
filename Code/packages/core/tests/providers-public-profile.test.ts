/**
 * BE-17 — `packages/core/src/providers/public-profile.ts`
 *
 * Pure : `requirePublishedProfile` (garde-fou 404 sur profil non publié) et
 * `buildPublicProviderProfile` (assemblage de la fiche publique à partir de données déjà
 * chargées). Aucun accès base ni réseau — tout est fourni en mémoire par l'appelant.
 */
import type {
  Category,
  CoverageArea,
  Governorate,
  MediaAsset,
  PortfolioItem,
  ProviderCategoryLink,
  ProviderProfile,
  ProviderPublicationStatus,
  ServiceOffering,
} from '@repo/db';
import { describe, expect, it } from 'vitest';
import { DomainError } from '../src/errors/domain-error.js';
import {
  buildPublicProviderProfile,
  requirePublishedProfile,
  type PublicProviderProfileInput,
} from '../src/providers/public-profile.js';

function buildProfile(overrides: Partial<ProviderProfile> = {}): ProviderProfile {
  return {
    id: 'provider-1',
    userId: 'user-1',
    slug: 'ahmed-plombier-sousse',
    businessName: 'Ahmed Plomberie',
    headline: 'Plombier de confiance',
    bio: null,
    yearsExperience: 8,
    spokenLanguages: ['FR', 'AR'],
    baseGovernorateId: 'gov-sousse',
    baseDelegationId: null,
    latitude: null,
    longitude: null,
    publicationStatus: 'PUBLISHED',
    availabilityStatus: 'AVAILABLE',
    availableAgainAt: null,
    acceptsEmergency: false,
    workingHours: null,
    isVerified: true,
    verifiedAt: null,
    ratingAvg: 4.5,
    ratingCount: 12,
    totalProfileViews: 0,
    totalContacts: 0,
    completionScore: 80,
    rankingScore: 0,
    lastActiveAt: null,
    createdAt: new Date('2026-01-01'),
    updatedAt: new Date('2026-01-01'),
    ...overrides,
  };
}

function buildGovernorate(overrides: Partial<Governorate> = {}): Governorate {
  return {
    id: 'gov-sousse',
    code: 'SO',
    nameFr: 'Sousse',
    nameAr: 'سوسة',
    slug: 'sousse',
    latitude: null,
    longitude: null,
    isActive: true,
    sortOrder: 1,
    ...overrides,
  };
}

function baseInput(
  overrides: Partial<PublicProviderProfileInput> = {},
): PublicProviderProfileInput {
  return {
    profile: buildProfile(),
    categoryLinks: [],
    categoriesById: new Map(),
    offerings: [],
    coverageAreas: [],
    governoratesById: new Map([['gov-sousse', buildGovernorate()]]),
    delegationsById: new Map(),
    portfolioItems: [],
    mediaById: new Map(),
    reviewCountByStarRaw: null,
    ...overrides,
  };
}

describe('BE-17 — requirePublishedProfile', () => {
  it('lève NOT_FOUND si le profil est `null`', () => {
    expect(() => requirePublishedProfile(null)).toThrow(DomainError);
    try {
      requirePublishedProfile(null);
    } catch (error) {
      expect((error as DomainError).code).toBe('NOT_FOUND');
    }
  });

  it.each(['DRAFT', 'HIDDEN', 'SUSPENDED'] as ProviderPublicationStatus[])(
    'lève NOT_FOUND (jamais FORBIDDEN) si publicationStatus === %s',
    (status) => {
      const profile = buildProfile({ publicationStatus: status });
      expect(() => requirePublishedProfile(profile)).toThrow(DomainError);
      try {
        requirePublishedProfile(profile);
      } catch (error) {
        expect((error as DomainError).code).toBe('NOT_FOUND');
      }
    },
  );

  it('renvoie le profil inchangé si PUBLISHED', () => {
    const profile = buildProfile({ publicationStatus: 'PUBLISHED' });
    expect(requirePublishedProfile(profile)).toBe(profile);
  });
});

describe('BE-17 — buildPublicProviderProfile', () => {
  it('ne porte jamais de champ téléphone dans le résultat', () => {
    const result = buildPublicProviderProfile(baseInput());
    expect(result).not.toHaveProperty('whatsappPhone');
    expect(result).not.toHaveProperty('publicPhone');
    expect(result).not.toHaveProperty('phone');
  });

  it('lève INTERNAL_ERROR si le gouvernorat de base est introuvable (incohérence FK)', () => {
    expect(() => buildPublicProviderProfile(baseInput({ governoratesById: new Map() }))).toThrow(
      DomainError,
    );
  });

  it('ignore silencieusement une catégorie liée dont l’id est orphelin (désactivée)', () => {
    const link: ProviderCategoryLink = {
      providerId: 'provider-1',
      categoryId: 'cat-missing',
      isPrimary: true,
      yearsExperience: 5,
    };
    const result = buildPublicProviderProfile(baseInput({ categoryLinks: [link] }));
    expect(result.categories).toEqual([]);
  });

  it('inclut une catégorie liée résolue', () => {
    const category: Category = {
      id: 'cat-plomberie',
      parentId: null,
      slug: 'plomberie',
      nameFr: 'Plomberie',
      nameAr: 'سباكة',
      descriptionFr: null,
      descriptionAr: null,
      iconKey: null,
      colorHex: null,
      isActive: true,
      sortOrder: 1,
    };
    const link: ProviderCategoryLink = {
      providerId: 'provider-1',
      categoryId: 'cat-plomberie',
      isPrimary: true,
      yearsExperience: 5,
    };
    const result = buildPublicProviderProfile(
      baseInput({
        categoryLinks: [link],
        categoriesById: new Map([['cat-plomberie', category]]),
      }),
    );
    expect(result.categories).toEqual([
      {
        slug: 'plomberie',
        nameFr: 'Plomberie',
        nameAr: 'سباكة',
        isPrimary: true,
        yearsExperience: 5,
      },
    ]);
  });

  it('omet une offre dont la catégorie est orpheline', () => {
    const offering: ServiceOffering = {
      id: 'offer-1',
      providerId: 'provider-1',
      categoryId: 'cat-missing',
      titleFr: 'Dépannage',
      titleAr: null,
      description: null,
      priceMin: 50,
      priceMax: 50,
      priceUnit: 'FIXED',
      isNegotiable: false,
      sortOrder: 1,
      isActive: true,
    };
    const result = buildPublicProviderProfile(baseInput({ offerings: [offering] }));
    expect(result.offerings).toEqual([]);
  });

  it('calcule displayPrice pour une offre résolue', () => {
    const category: Category = {
      id: 'cat-plomberie',
      parentId: null,
      slug: 'plomberie',
      nameFr: 'Plomberie',
      nameAr: 'سباكة',
      descriptionFr: null,
      descriptionAr: null,
      iconKey: null,
      colorHex: null,
      isActive: true,
      sortOrder: 1,
    };
    const offering: ServiceOffering = {
      id: 'offer-1',
      providerId: 'provider-1',
      categoryId: 'cat-plomberie',
      titleFr: 'Dépannage',
      titleAr: null,
      description: null,
      priceMin: 50,
      priceMax: 80,
      priceUnit: 'HOUR',
      isNegotiable: true,
      sortOrder: 1,
      isActive: true,
    };
    const result = buildPublicProviderProfile(
      baseInput({ offerings: [offering], categoriesById: new Map([['cat-plomberie', category]]) }),
    );
    expect(result.offerings[0]?.displayPrice).toBe('50 - 80 DT/heure');
  });

  it('remplace une délégation de couverture orpheline par `null` sans exclure la zone', () => {
    const area: CoverageArea = {
      id: 'area-1',
      providerId: 'provider-1',
      governorateId: 'gov-sousse',
      delegationId: 'del-missing',
      travelFee: null,
    };
    const result = buildPublicProviderProfile(baseInput({ coverageAreas: [area] }));
    expect(result.coverageAreas).toEqual([
      {
        governorate: { slug: 'sousse', nameFr: 'Sousse', nameAr: 'سوسة' },
        delegation: null,
        travelFee: null,
      },
    ]);
  });

  it('exclut une zone de couverture dont le gouvernorat est orphelin', () => {
    const area: CoverageArea = {
      id: 'area-1',
      providerId: 'provider-1',
      governorateId: 'gov-missing',
      delegationId: null,
      travelFee: null,
    };
    const result = buildPublicProviderProfile(baseInput({ coverageAreas: [area] }));
    expect(result.coverageAreas).toEqual([]);
  });

  it('exclut un élément de galerie dont le média est introuvable', () => {
    const item: PortfolioItem = {
      id: 'item-1',
      providerId: 'provider-1',
      mediaId: 'media-missing',
      categoryId: null,
      caption: null,
      sortOrder: 1,
      status: 'APPROVED',
    };
    const result = buildPublicProviderProfile(baseInput({ portfolioItems: [item] }));
    expect(result.gallery).toEqual([]);
  });

  it('exclut un élément de galerie dont le média n’a pas d’URL publique', () => {
    const media: MediaAsset = {
      id: 'media-1',
      uploadedById: null,
      bucket: 'public',
      storageKey: 'key',
      publicUrl: null,
      type: 'IMAGE',
      mimeType: 'image/webp',
      sizeBytes: 100,
      width: null,
      height: null,
      blurhash: null,
      isPrivate: false,
      moderationStatus: 'APPROVED',
      createdAt: new Date('2026-01-01'),
    };
    const item: PortfolioItem = {
      id: 'item-1',
      providerId: 'provider-1',
      mediaId: 'media-1',
      categoryId: null,
      caption: null,
      sortOrder: 1,
      status: 'APPROVED',
    };
    const result = buildPublicProviderProfile(
      baseInput({ portfolioItems: [item], mediaById: new Map([['media-1', media]]) }),
    );
    expect(result.gallery).toEqual([]);
  });

  it('inclut un élément de galerie résolu avec URL publique', () => {
    const media: MediaAsset = {
      id: 'media-1',
      uploadedById: null,
      bucket: 'public',
      storageKey: 'key',
      publicUrl: 'https://cdn.example.tn/media-1.webp',
      type: 'IMAGE',
      mimeType: 'image/webp',
      sizeBytes: 100,
      width: 800,
      height: 600,
      blurhash: 'abc',
      isPrivate: false,
      moderationStatus: 'APPROVED',
      createdAt: new Date('2026-01-01'),
    };
    const item: PortfolioItem = {
      id: 'item-1',
      providerId: 'provider-1',
      mediaId: 'media-1',
      categoryId: null,
      caption: 'Chantier terminé',
      sortOrder: 1,
      status: 'APPROVED',
    };
    const result = buildPublicProviderProfile(
      baseInput({ portfolioItems: [item], mediaById: new Map([['media-1', media]]) }),
    );
    expect(result.gallery).toEqual([
      {
        id: 'item-1',
        url: 'https://cdn.example.tn/media-1.webp',
        width: 800,
        height: 600,
        blurhash: 'abc',
        caption: 'Chantier terminé',
        category: null,
      },
    ]);
  });

  it('remplace une délégation de base orpheline par `null` sans lever d’erreur', () => {
    const profile = buildProfile({ baseDelegationId: 'del-missing' });
    const result = buildPublicProviderProfile(baseInput({ profile }));
    expect(result.baseDelegation).toBeNull();
  });

  it('assemble l’agrégat d’avis à partir de ratingAvg/ratingCount/reviewCountByStarRaw', () => {
    const result = buildPublicProviderProfile(baseInput({ reviewCountByStarRaw: { '5': 12 } }));
    expect(result.reviewAggregate).toEqual({
      average: 4.5,
      count: 12,
      breakdown: { '1': 0, '2': 0, '3': 0, '4': 0, '5': 12 },
    });
  });
});
