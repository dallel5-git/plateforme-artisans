import { z } from 'zod';

import { contactSourceScreenSchema } from './contact.js';

// `source` réutilise le même vocabulaire que `ContactEvent.sourceScreen` (contact.js) — "où a eu
// lieu l'action", pas dupliqué en une seconde énumération qui dériverait avec le temps.
export const createProfileViewSchema = z.object({
  providerId: z.uuid(),
  source: contactSourceScreenSchema.optional(),
});
export type CreateProfileViewBody = z.infer<typeof createProfileViewSchema>;
