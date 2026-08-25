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
