import { z } from 'zod';

import { availabilityStatusSchema, priceUnitSchema } from './common.js';
import { delegationSchema, governorateSchema } from './catalog.js';

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
  spokenLanguages: z.array(z.enum(['FR', 'AR', 'EN'])),
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
