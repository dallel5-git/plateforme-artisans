import { z } from 'zod';

// Partagé par plusieurs modules (search BE-16, provider à venir) — un seul point de vérité pour
// l'énumération `AvailabilityStatus` côté validation, miroir de l'enum Prisma du même nom.
export const availabilityStatusSchema = z.enum(['AVAILABLE', 'BUSY', 'ON_HOLIDAY']);
