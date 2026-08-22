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
