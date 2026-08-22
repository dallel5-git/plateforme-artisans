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
