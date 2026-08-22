import { z } from 'zod';

import { availabilityStatusSchema } from './common.js';

export const favoriteParamsSchema = z.object({
  providerId: z.uuid(),
});
export type FavoriteParams = z.infer<typeof favoriteParamsSchema>;

// BE-25 : mêmes conventions que providerReviewsQuerySchema (review.ts) pour cursor/limit.
export const favoritesQuerySchema = z.object({
  cursor: z.string().optional(),
  limit: z.coerce.number().int().min(1).max(50).optional().default(20),
});
export type FavoritesQuery = z.infer<typeof favoritesQuerySchema>;

export const favoriteResponseSchema = z.object({
  providerId: z.uuid(),
  createdAt: z.date(),
});
export type FavoriteResponse = z.infer<typeof favoriteResponseSchema>;

// Pas d'identifiant interne (userId) — même logique que providerReviewListItemSchema (review.ts).
export const favoriteListItemSchema = z.object({
  providerId: z.uuid(),
  slug: z.string(),
  businessName: z.string(),
  headline: z.string().nullable(),
  isVerified: z.boolean(),
  ratingAvg: z.number(),
  ratingCount: z.number(),
  availabilityStatus: availabilityStatusSchema,
  favoritedAt: z.date(),
});
export type FavoriteListItem = z.infer<typeof favoriteListItemSchema>;

// AC BE-25 (cf. providerReviewListResponseSchema, BE-18) : jamais un tableau nu.
export const favoriteListResponseSchema = z.object({
  items: z.array(favoriteListItemSchema),
  nextCursor: z.string().nullable(),
});
export type FavoriteListResponse = z.infer<typeof favoriteListResponseSchema>;
