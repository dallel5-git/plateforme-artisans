import { z } from 'zod';

// BE-18 : mêmes conventions que providerSearchQuerySchema (search.ts) pour cursor/limit.
export const providerReviewsQuerySchema = z.object({
  cursor: z.string().optional(),
  limit: z.coerce.number().int().min(1).max(50).optional().default(20),
});
export type ProviderReviewsQuery = z.infer<typeof providerReviewsQuerySchema>;

// Volontairement absents : les sous-notes (ratingPunctuality/Quality/Value — différées, 🟠 P1,
// backlog séparé) et tout champ de réponse artisan ("réponse de l'artisan" — aucun modèle de
// données n'existe encore pour ça côté schema.prisma ; backlog séparé, hors périmètre BE-18).
// Pas d'identifiants internes (providerId/clientId/contactEventId/status) : déjà garanti côté
// repository par `reviewListSelect` (packages/db, BE-18b), pas seulement par omission ici.
export const providerReviewListItemSchema = z.object({
  id: z.uuid(),
  rating: z.number().int().min(1).max(5),
  comment: z.string().nullable(),
  isVerifiedContact: z.boolean(),
  createdAt: z.date(),
  authorDisplayName: z.string(),
});

// AC BE-18 (cf. providerSearchResponseSchema, BE-16) : jamais un tableau nu.
export const providerReviewListResponseSchema = z.object({
  items: z.array(providerReviewListItemSchema),
  nextCursor: z.string().nullable(),
});
