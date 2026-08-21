import { z } from 'zod';

// Partagé par plusieurs modules (search BE-16, provider à venir) — un seul point de vérité pour
// l'énumération `AvailabilityStatus` côté validation, miroir de l'enum Prisma du même nom.
export const availabilityStatusSchema = z.enum(['AVAILABLE', 'BUSY', 'ON_HOLIDAY']);

// BE-17 : miroir de l'enum Prisma `PriceUnit` — partagé par la fiche publique (BE-17) et, plus
// tard, l'édition d'offres côté artisan (BE-19+).
export const priceUnitSchema = z.enum([
  'FIXED',
  'HOUR',
  'DAY',
  'SQUARE_METER',
  'LINEAR_METER',
  'ON_QUOTE',
]);
