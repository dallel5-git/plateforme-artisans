import { z } from 'zod';

import { authTokensSchema } from './auth.js';
import { delegationSchema, governorateSchema } from './catalog.js';
import { availabilityStatusSchema, priceUnitSchema } from './common.js';

// Miroir de `spokenLanguages: Locale[]` (schema.prisma).
export const localeSchema = z.enum(['FR', 'AR', 'EN']);

// Sous-ensemble artisan-pilotable de `ProviderPublicationStatus` : `HIDDEN`/`SUSPENDED` sont des
// états de modération, jamais posés par une route `/me` (voir `packages/core/src/policies`).
export const providerPublicationStatusSchema = z.enum(['DRAFT', 'PUBLISHED']);

// Vue privée du propriétaire sur son propre profil — inclut `whatsappPhone`/`publicPhone`
// (contrairement à toute réponse publique, P8) puisqu'elle n'est jamais exposée à un tiers :
// gardée par `requireAuth`/`requireRole('PROVIDER')` et toujours résolue via `request.user.sub`,
// jamais via un `:id` fourni par le client.
export const providerMeSchema = z.object({
  id: z.uuid(),
  slug: z.string(),
  businessName: z.string(),
  headline: z.string().nullable(),
  bio: z.string().nullable(),
  yearsExperience: z.number().int().nullable(),
  whatsappPhone: z.string().nullable(),
  publicPhone: z.string().nullable(),
  spokenLanguages: z.array(localeSchema),
  baseGovernorateId: z.uuid(),
  baseDelegationId: z.uuid().nullable(),
  latitude: z.number().nullable(),
  longitude: z.number().nullable(),
  publicationStatus: z.enum(['DRAFT', 'PUBLISHED', 'HIDDEN', 'SUSPENDED']),
  availabilityStatus: availabilityStatusSchema,
  availableAgainAt: z.date().nullable(),
  acceptsEmergency: z.boolean(),
  workingHours: z.unknown().nullable(),
  isVerified: z.boolean(),
  verifiedAt: z.date().nullable(),
  ratingAvg: z.number(),
  ratingCount: z.number().int(),
  totalProfileViews: z.number().int(),
  totalContacts: z.number().int(),
  completionScore: z.number().int(),
  rankingScore: z.number(),
  lastActiveAt: z.date().nullable(),
  createdAt: z.date(),
  updatedAt: z.date(),
});

export const createProviderMeSchema = z.object({
  businessName: z.string().min(2).max(140),
  baseGovernorateId: z.uuid(),
  baseDelegationId: z.uuid().optional(),
  headline: z.string().max(160).optional(),
  bio: z.string().max(2000).optional(),
  yearsExperience: z.number().int().min(0).max(80).optional(),
  whatsappPhone: z.string().min(6).max(20).optional(),
  publicPhone: z.string().min(6).max(20).optional(),
  spokenLanguages: z.array(localeSchema).min(1).optional(),
});
export type CreateProviderMeInput = z.infer<typeof createProviderMeSchema>;

export const createProviderMeResponseSchema = authTokensSchema.extend({
  provider: providerMeSchema,
});

export const updateProviderMeSchema = z.object({
  businessName: z.string().min(2).max(140).optional(),
  headline: z.string().max(160).optional(),
  bio: z.string().max(2000).optional(),
  yearsExperience: z.number().int().min(0).max(80).optional(),
  whatsappPhone: z.string().min(6).max(20).optional(),
  publicPhone: z.string().min(6).max(20).optional(),
  availabilityStatus: availabilityStatusSchema.optional(),
  availableAgainAt: z.date().nullable().optional(),
  acceptsEmergency: z.boolean().optional(),
  workingHours: z.unknown().optional(),
  publicationStatus: providerPublicationStatusSchema.optional(),
});
export type UpdateProviderMeInput = z.infer<typeof updateProviderMeSchema>;

export const updateProviderMeResponseSchema = providerMeSchema;

// BE-19c : `isPrimary` doit être posé sur exactement une catégorie — ceinture et bretelles avec
// l'index partiel unique déjà en base (BE-02, `provider_categories.isPrimary`).
export const providerCategoryInputSchema = z.object({
  categoryId: z.uuid(),
  isPrimary: z.boolean(),
  yearsExperience: z.number().int().min(0).max(80).optional(),
});

export const putProviderCategoriesSchema = z
  .object({
    categories: z.array(providerCategoryInputSchema).max(8),
  })
  .refine((input) => input.categories.filter((c) => c.isPrimary).length === 1, {
    message: 'Exactement une catégorie doit être désignée comme principale (isPrimary)',
    path: ['categories'],
  });
export type PutProviderCategoriesInput = z.infer<typeof putProviderCategoriesSchema>;

export const providerCategoryResponseSchema = z.object({
  categoryId: z.uuid(),
  isPrimary: z.boolean(),
  yearsExperience: z.number().int().nullable(),
});

export const putProviderCategoriesResponseSchema = z.object({
  categories: z.array(providerCategoryResponseSchema),
  completionScore: z.number().int(),
});

// BE-19d : `delegationId` absent = « tout le gouvernorat » (voir `CoverageArea.delegationId`).
export const providerCoverageAreaInputSchema = z.object({
  governorateId: z.uuid(),
  delegationId: z.uuid().optional(),
  travelFee: z.number().int().min(0).optional(),
});

export const putProviderCoverageAreasSchema = z.object({
  coverageAreas: z.array(providerCoverageAreaInputSchema).max(24),
});
export type PutProviderCoverageAreasInput = z.infer<typeof putProviderCoverageAreasSchema>;

export const providerCoverageAreaResponseSchema = z.object({
  id: z.uuid(),
  governorateId: z.uuid(),
  delegationId: z.uuid().nullable(),
  travelFee: z.number().nullable(),
});

export const putProviderCoverageAreasResponseSchema = z.object({
  coverageAreas: z.array(providerCoverageAreaResponseSchema),
  completionScore: z.number().int(),
});

// =====================================================================
//  BE-17 : fiche artisan publique (`GET /v1/providers/:slug`)
// =====================================================================

export const providerSlugParamsSchema = z.object({
  slug: z.string().min(1),
});

const nameRefSchema = z.object({
  slug: z.string(),
  nameFr: z.string(),
  nameAr: z.string(),
});

const geoRefSchema = governorateSchema.pick({ slug: true, nameFr: true, nameAr: true });
const delegationRefSchema = delegationSchema.pick({ slug: true, nameFr: true, nameAr: true });

const providerProfileCategorySchema = nameRefSchema.extend({
  isPrimary: z.boolean(),
  yearsExperience: z.number().int().nullable(),
});

export const providerServiceOfferingSchema = z.object({
  id: z.uuid(),
  category: nameRefSchema,
  titleFr: z.string(),
  titleAr: z.string().nullable(),
  description: z.string().nullable(),
  priceMin: z.number().nullable(),
  priceMax: z.number().nullable(),
  priceUnit: priceUnitSchema,
  isNegotiable: z.boolean(),
  displayPrice: z.string(),
});

export const providerCoverageAreaSchema = z.object({
  governorate: geoRefSchema,
  delegation: delegationRefSchema.nullable(),
  travelFee: z.number().nullable(),
});

export const providerGalleryItemSchema = z.object({
  id: z.uuid(),
  url: z.string(),
  width: z.number().int().nullable(),
  height: z.number().int().nullable(),
  blurhash: z.string().nullable(),
  caption: z.string().nullable(),
  category: nameRefSchema.nullable(),
});

const reviewStarBreakdownSchema = z.object({
  '1': z.number().int().nonnegative(),
  '2': z.number().int().nonnegative(),
  '3': z.number().int().nonnegative(),
  '4': z.number().int().nonnegative(),
  '5': z.number().int().nonnegative(),
});

export const providerReviewAggregateSchema = z.object({
  average: z.number(),
  count: z.number().int(),
  breakdown: reviewStarBreakdownSchema,
});

// BE-17 : fiche artisan publique. P8 — AUCUN champ téléphone ici, jamais : garanti par
// construction, pas seulement par omission — `ProviderProfile` (@repo/db, packages/core en
// amont) n'a structurellement jamais porté whatsappPhone/publicPhone (voir header de
// provider-profile.repository.ts). Le numéro n'est révélé que par POST /contact-events (BE-21).
export const providerPublicProfileSchema = z.object({
  id: z.uuid(),
  slug: z.string(),
  businessName: z.string(),
  headline: z.string().nullable(),
  bio: z.string().nullable(),
  yearsExperience: z.number().int().nullable(),
  spokenLanguages: z.array(localeSchema),
  baseGovernorate: geoRefSchema,
  baseDelegation: delegationRefSchema.nullable(),
  latitude: z.number().nullable(),
  longitude: z.number().nullable(),
  isVerified: z.boolean(),
  availabilityStatus: availabilityStatusSchema,
  availableAgainAt: z.date().nullable(),
  acceptsEmergency: z.boolean(),
  completionScore: z.number().int(),
  categories: z.array(providerProfileCategorySchema),
  offerings: z.array(providerServiceOfferingSchema),
  coverageAreas: z.array(providerCoverageAreaSchema),
  gallery: z.array(providerGalleryItemSchema),
  reviewAggregate: providerReviewAggregateSchema,
});
