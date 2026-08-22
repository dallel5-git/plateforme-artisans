import { z } from 'zod';

// BE-24 : `searchImpressions`/`avgSearchPosition` sont volontairement absents — aucun module
// `search` n'existe encore pour les alimenter (dette tracée en `BE-43`, backlog non planifié).
export const providerStatsDayPointSchema = z.object({
  date: z.date(),
  profileViews: z.number().int().nonnegative(),
  uniqueProfileViews: z.number().int().nonnegative(),
  contacts: z.number().int().nonnegative(),
});
export type ProviderStatsDayPointResponse = z.infer<typeof providerStatsDayPointSchema>;

export const providerStatsTotalsSchema = z.object({
  profileViews: z.number().int().nonnegative(),
  uniqueProfileViews: z.number().int().nonnegative(),
  contacts: z.number().int().nonnegative(),
  viewToContactRatio: z.number().nonnegative(),
});
export type ProviderStatsTotalsResponse = z.infer<typeof providerStatsTotalsSchema>;

// AC BE-24 : « la série est renvoyée avec les jours à zéro » — toujours 30 points, jamais de trou.
export const providerStatsResponseSchema = z.object({
  totals: providerStatsTotalsSchema,
  series: z.array(providerStatsDayPointSchema),
});
export type ProviderStatsResponse = z.infer<typeof providerStatsResponseSchema>;
