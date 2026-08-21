import { INTERNAL_ERROR, NOT_FOUND } from '@repo/constants';
import type {
  AvailabilityStatus,
  Category,
  CoverageArea,
  Delegation,
  Governorate,
  Locale,
  MediaAsset,
  PortfolioItem,
  ProviderCategoryLink,
  ProviderProfile,
  ServiceOffering,
} from '@repo/db';
import { DomainError } from '../errors/domain-error.js';
import { buildReviewAggregate, type ReviewAggregate } from '../reviews/aggregate.js';
import { formatDisplayPrice } from './pricing.js';

/**
 * BE-17 : un profil non PUBLISHED (DRAFT/HIDDEN/SUSPENDED) — ou absent — doit répondre 404,
 * jamais 403 : ne pas révéler l'existence d'un profil non public. `findProviderProfileBySlug`
 * (BE-05) ne filtre volontairement pas sur `publicationStatus` — cette règle métier n'a pas
 * d'autre foyer : elle vit ici, pas dans la route (pas de `if` métier dans une route).
 */
export function requirePublishedProfile(profile: ProviderProfile | null): ProviderProfile {
  if (!profile || profile.publicationStatus !== 'PUBLISHED') {
    throw new DomainError(NOT_FOUND, 'Profil introuvable', { field: 'slug' });
  }
  return profile;
}

export interface NameRef {
  slug: string;
  nameFr: string;
  nameAr: string;
}

function toNameRef(entity: { slug: string; nameFr: string; nameAr: string }): NameRef {
  return { slug: entity.slug, nameFr: entity.nameFr, nameAr: entity.nameAr };
}

export interface PublicProviderCategory extends NameRef {
  isPrimary: boolean;
  yearsExperience: number | null;
}

export interface PublicServiceOffering {
  id: string;
  category: NameRef;
  titleFr: string;
  titleAr: string | null;
  description: string | null;
  priceMin: number | null;
  priceMax: number | null;
  priceUnit: ServiceOffering['priceUnit'];
  isNegotiable: boolean;
  displayPrice: string;
}

export interface PublicCoverageArea {
  governorate: NameRef;
  delegation: NameRef | null;
  travelFee: number | null;
}

export interface PublicGalleryItem {
  id: string;
  url: string;
  width: number | null;
  height: number | null;
  blurhash: string | null;
  caption: string | null;
  category: NameRef | null;
}

export interface PublicProviderProfile {
  id: string;
  slug: string;
  businessName: string;
  headline: string | null;
  bio: string | null;
  yearsExperience: number | null;
  spokenLanguages: Locale[];
  baseGovernorate: NameRef;
  baseDelegation: NameRef | null;
  latitude: number | null;
  longitude: number | null;
  isVerified: boolean;
  availabilityStatus: AvailabilityStatus;
  availableAgainAt: Date | null;
  acceptsEmergency: boolean;
  completionScore: number;
  categories: PublicProviderCategory[];
  offerings: PublicServiceOffering[];
  coverageAreas: PublicCoverageArea[];
  gallery: PublicGalleryItem[];
  reviewAggregate: ReviewAggregate;
}

export interface PublicProviderProfileInput {
  profile: ProviderProfile;
  categoryLinks: ProviderCategoryLink[];
  categoriesById: Map<string, Category>;
  offerings: ServiceOffering[];
  coverageAreas: CoverageArea[];
  governoratesById: Map<string, Governorate>;
  delegationsById: Map<string, Delegation>;
  portfolioItems: PortfolioItem[];
  mediaById: Map<string, MediaAsset>;
  // Passé explicitement plutôt que lu sur `profile.reviewCountByStar` : ce champ est un `Json?`
  // Prisma (BE-17b l'ajoute à `profileSelect`) — le découpler du type `ProviderProfile` garde
  // cet assemblage testable avec un objet `profile` minimal, sans dépendre du moment où BE-17b
  // merge.
  reviewCountByStarRaw: unknown;
}

/**
 * Assemblage pur de la fiche publique — aucun accès Prisma ici, tout est déjà chargé par
 * l'appelant (route). P8 : aucun champ téléphone lu ni transmis — structurellement impossible,
 * `ProviderProfile` (type `@repo/db`) n'en porte jamais (voir provider-profile.repository.ts).
 *
 * Un id orphelin (catégorie désactivée depuis, média démodéré...) est ignoré silencieusement :
 * une incohérence référentielle ailleurs ne doit jamais faire 500 une fiche publique. Seule la
 * référence géographique de base du profil (FK NOT NULL, référentiel figé) est considérée assez
 * fiable pour justifier un 500 explicite si elle manque — un vrai bug d'intégrité, pas un cas
 * attendu.
 */
export function buildPublicProviderProfile(
  input: PublicProviderProfileInput,
): PublicProviderProfile {
  const { profile } = input;

  const baseGovernorate = input.governoratesById.get(profile.baseGovernorateId);
  if (!baseGovernorate) {
    throw new DomainError(INTERNAL_ERROR, 'Gouvernorat de base introuvable pour ce profil', {
      field: 'baseGovernorateId',
    });
  }
  const baseDelegation = profile.baseDelegationId
    ? (input.delegationsById.get(profile.baseDelegationId) ?? null)
    : null;

  const categories: PublicProviderCategory[] = input.categoryLinks.flatMap((link) => {
    const category = input.categoriesById.get(link.categoryId);
    if (!category) return [];
    return [
      { ...toNameRef(category), isPrimary: link.isPrimary, yearsExperience: link.yearsExperience },
    ];
  });

  const offerings: PublicServiceOffering[] = input.offerings.flatMap((offering) => {
    const category = input.categoriesById.get(offering.categoryId);
    if (!category) return [];
    return [
      {
        id: offering.id,
        category: toNameRef(category),
        titleFr: offering.titleFr,
        titleAr: offering.titleAr,
        description: offering.description,
        priceMin: offering.priceMin,
        priceMax: offering.priceMax,
        priceUnit: offering.priceUnit,
        isNegotiable: offering.isNegotiable,
        displayPrice: formatDisplayPrice(offering),
      },
    ];
  });

  const coverageAreas: PublicCoverageArea[] = input.coverageAreas.flatMap((area) => {
    const governorate = input.governoratesById.get(area.governorateId);
    if (!governorate) return [];
    const delegation = area.delegationId
      ? (input.delegationsById.get(area.delegationId) ?? null)
      : null;
    return [
      {
        governorate: toNameRef(governorate),
        delegation: delegation ? toNameRef(delegation) : null,
        travelFee: area.travelFee,
      },
    ];
  });

  const gallery: PublicGalleryItem[] = input.portfolioItems.flatMap((item) => {
    const media = input.mediaById.get(item.mediaId);
    if (!media || !media.publicUrl) return [];
    const category = item.categoryId ? (input.categoriesById.get(item.categoryId) ?? null) : null;
    return [
      {
        id: item.id,
        url: media.publicUrl,
        width: media.width,
        height: media.height,
        blurhash: media.blurhash,
        caption: item.caption,
        category: category ? toNameRef(category) : null,
      },
    ];
  });

  return {
    id: profile.id,
    slug: profile.slug,
    businessName: profile.businessName,
    headline: profile.headline,
    bio: profile.bio,
    yearsExperience: profile.yearsExperience,
    spokenLanguages: profile.spokenLanguages,
    baseGovernorate: toNameRef(baseGovernorate),
    baseDelegation: baseDelegation ? toNameRef(baseDelegation) : null,
    latitude: profile.latitude,
    longitude: profile.longitude,
    isVerified: profile.isVerified,
    availabilityStatus: profile.availabilityStatus,
    availableAgainAt: profile.availableAgainAt,
    acceptsEmergency: profile.acceptsEmergency,
    completionScore: profile.completionScore,
    categories,
    offerings,
    coverageAreas,
    gallery,
    reviewAggregate: buildReviewAggregate(
      profile.ratingAvg,
      profile.ratingCount,
      input.reviewCountByStarRaw,
    ),
  };
}
