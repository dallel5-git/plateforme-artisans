import { z } from 'zod';

// `mimeType`/`sizeBytes` ne sont volontairement PAS contraints ici (pas de `z.enum`/`z.max`) :
// leur rejet doit produire les codes dédiés `MEDIA_UNSUPPORTED_TYPE`/`MEDIA_TOO_LARGE` (route
// `POST /v1/media/presign`), pas un `VALIDATION_ERROR` générique qui perdrait cette distinction
// pour la traduction locale côté client (CLAUDE.md §4.3). Même geste que la limite de catégories
// FREE (BE-19c) : une règle métier se vérifie dans la route, pas dans le schéma.
export const presignMediaSchema = z.object({
  filename: z.string().min(1).max(200),
  mimeType: z.string().min(1),
  sizeBytes: z.number().int().positive(),
});
export type PresignMediaInput = z.infer<typeof presignMediaSchema>;

export const presignMediaResponseSchema = z.object({
  mediaId: z.uuid(),
  uploadUrl: z.string(),
  expiresAt: z.date(),
});

export const mediaIdParamsSchema = z.object({
  id: z.uuid(),
});

export const processMediaResponseSchema = z.object({
  id: z.uuid(),
  publicUrl: z.string(),
  thumbUrl: z.string(),
  cardUrl: z.string(),
  fullUrl: z.string(),
  width: z.number().int().positive(),
  height: z.number().int().positive(),
});
