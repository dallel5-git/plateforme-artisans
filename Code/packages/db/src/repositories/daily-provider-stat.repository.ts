// BE-23 : agrégat journalier. `profileViews` (brut) et `uniqueProfileViews` (dédupliqué) sont
// conservés séparément (US-P-08, cadrage) — l'appelant décide lequel incrémenter selon que la
// ligne `ProfileView` correspondante était nouvelle ou non (voir profile-view.repository.ts).
import { prisma } from '../client.js';
import type { DbClient } from '../types.js';

export interface IncrementDailyProviderStatInput {
  providerId: string;
  date: Date;
  profileViewsDelta: number;
  uniqueProfileViewsDelta: number;
}

export async function incrementDailyProviderStat(
  input: IncrementDailyProviderStatInput,
  db: DbClient = prisma,
): Promise<void> {
  const { providerId, date, profileViewsDelta, uniqueProfileViewsDelta } = input;

  await db.dailyProviderStat.upsert({
    where: { providerId_date: { providerId, date } },
    create: {
      providerId,
      date,
      profileViews: profileViewsDelta,
      uniqueProfileViews: uniqueProfileViewsDelta,
    },
    update: {
      profileViews: { increment: profileViewsDelta },
      uniqueProfileViews: { increment: uniqueProfileViewsDelta },
    },
    select: { id: true },
  });
}

const dailyStatSelect = {
  date: true,
  profileViews: true,
  uniqueProfileViews: true,
} as const;

export interface DailyProviderStatPoint {
  date: Date;
  profileViews: number;
  uniqueProfileViews: number;
}

// BE-24 : lecture pour `GET /providers/me/stats`. `searchImpressions`/`avgSearchPosition` ne sont
// volontairement pas sélectionnés — aucun module `search` n'écrit encore ces colonnes (BE-43).
export async function listDailyProviderStats(
  providerId: string,
  range: { from: Date; to: Date },
  db: DbClient = prisma,
): Promise<DailyProviderStatPoint[]> {
  return db.dailyProviderStat.findMany({
    where: { providerId, date: { gte: range.from, lte: range.to } },
    select: dailyStatSelect,
    orderBy: { date: 'asc' },
  });
}
