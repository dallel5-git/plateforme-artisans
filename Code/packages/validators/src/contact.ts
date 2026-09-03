import { z } from 'zod';

export const contactChannelSchema = z.enum(['PHONE', 'WHATSAPP']);

// Reflète le commentaire de ContactEvent.sourceScreen (schema.prisma) — promeut une convention
// jusqu'ici documentée-mais-non-validée en validation réelle.
export const contactSourceScreenSchema = z.enum(['search', 'profile', 'boost', 'ad', 'seo_page']);

export const createContactEventSchema = z.object({
  providerId: z.uuid(),
  channel: contactChannelSchema,
  categoryId: z.uuid().optional(),
  sourceScreen: contactSourceScreenSchema.optional(),
});
export type CreateContactEventBody = z.infer<typeof createContactEventSchema>;

export const contactEventResponseSchema = z.object({
  contactEventId: z.uuid(),
  providerId: z.uuid(),
  channel: contactChannelSchema,
  phone: z.string(),
  // Présent uniquement pour channel === 'WHATSAPP' — texte brut, non encodé : le client
  // construit lui-même l'URL wa.me (cf. apps/mobile/CLAUDE.md, "Deep links natifs").
  whatsappMessage: z.string().optional(),
  deduplicated: z.boolean(),
});
export type ContactEventResponse = z.infer<typeof contactEventResponseSchema>;

// BE-26c : sans id enregistré, fastify-type-provider-zod inline ce schéma dans openapi.json
// (une définition par point d'usage) — le générateur Dart produit alors un nom anonyme
// (`V1ContactEventsPost200Response`) au lieu de `ContactEventResponse`. Même mécanisme que
// `categoryTreeNodeSchema` (packages/validators/src/catalog.ts).
z.globalRegistry.add(contactEventResponseSchema, { id: 'ContactEventResponse' });

// BE-45 : mêmes conventions que favoritesQuerySchema (favorite.ts) pour cursor/limit.
export const contactEventsQuerySchema = z.object({
  cursor: z.string().optional(),
  limit: z.coerce.number().int().min(1).max(50).optional().default(20),
});
export type ContactEventsQuery = z.infer<typeof contactEventsQuerySchema>;

// BE-45 : historique de lecture (US-C-09) — libellés déjà calculés (P3, pas de second appel
// GET /providers/:slug par item côté mobile). `categoryName` est null quand le contact n'a pas
// précisé de catégorie (POST /contact-events, `categoryId` optionnel). `hasReview` pilote le CTA
// conditionnel « déposer un avis » de FM-31.
export const contactEventHistoryItemSchema = z.object({
  id: z.uuid(),
  providerId: z.uuid(),
  slug: z.string(),
  businessName: z.string(),
  categoryName: z.string().nullable(),
  channel: contactChannelSchema,
  contactedAt: z.date(),
  hasReview: z.boolean(),
});
export type ContactEventHistoryItem = z.infer<typeof contactEventHistoryItemSchema>;

// AC BE-45 (cf. favoriteListResponseSchema, BE-25) : jamais un tableau nu.
export const contactEventHistoryListResponseSchema = z.object({
  items: z.array(contactEventHistoryItemSchema),
  nextCursor: z.string().nullable(),
});
export type ContactEventHistoryListResponse = z.infer<typeof contactEventHistoryListResponseSchema>;
