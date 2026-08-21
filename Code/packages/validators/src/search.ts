import { z } from 'zod';

import { availabilityStatusSchema } from './common.js';

// BE-16 : filtres exposés en slugs (pas en UUID), cohérent avec les endpoints catalogue (BE-14)
// et GATE 1 (`?category=plomberie&governorate=sousse`) — la route résout slug → id avant de
// requêter. `governorate` est obligatoire : `GeoMatch` (BE-15) n'a pas de valeur « sans géo ».
//
// ⚠️ Jamais `z.coerce.boolean()` sur une querystring : `Boolean('false') === true` en JS. On
// contraint la valeur à 'true'/'false' puis on transforme explicitement.
const booleanQueryParam = z
  .enum(['true', 'false'])
  .optional()
  .transform((v) => v === 'true');

export const providerSearchQuerySchema = z.object({
  category: z.string().min(1).optional(),
  governorate: z.string().min(1),
  delegation: z.string().min(1).optional(),
  verified: booleanQueryParam,
  minRating: z.coerce.number().min(0).max(5).optional(),
  availability: availabilityStatusSchema.optional(),
  cursor: z.string().optional(),
  limit: z.coerce.number().int().min(1).max(50).optional().default(20),
  debug: booleanQueryParam,
});
export type ProviderSearchQuery = z.infer<typeof providerSearchQuerySchema>;

export const rankingBreakdownSchema = z.object({
  geo: z.number(),
  rating: z.number(),
  trust: z.number(),
  completion: z.number(),
  responsiveness: z.number(),
  plan: z.number(),
  penalty: z.number(),
});

const providerCategorySummarySchema = z.object({
  slug: z.string(),
  nameFr: z.string(),
  nameAr: z.string(),
  isPrimary: z.boolean(),
});

// P8 : aucun champ téléphone ici — garanti par construction côté repository (le `select` dédié
// à la recherche ne remonte jamais whatsappPhone/publicPhone), pas seulement par omission ici.
export const providerSearchResultItemSchema = z.object({
  id: z.uuid(),
  slug: z.string(),
  businessName: z.string(),
  headline: z.string().nullable(),
  isVerified: z.boolean(),
  ratingAvg: z.number(),
  ratingCount: z.number().int(),
  completionScore: z.number().int(),
  availabilityStatus: availabilityStatusSchema,
  categories: z.array(providerCategorySummarySchema),
  // Présents uniquement si `?debug=true` — un `.optional()` suffit, pas de variante de schéma.
  score: z.number().optional(),
  matchReason: rankingBreakdownSchema.optional(),
});

// AC BE-16 : jamais un tableau nu — toujours un objet racine.
export const providerSearchResponseSchema = z.object({
  items: z.array(providerSearchResultItemSchema),
  nextCursor: z.string().nullable(),
});
