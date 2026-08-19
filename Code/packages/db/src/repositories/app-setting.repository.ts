// BE-05 : agrégat AppSetting — clé/valeur JSON générique (ex. poids de ranking, BE-03). Le
// typage de `value` reste `unknown` côté repository : chaque appelant sait quelle forme
// attendre pour sa propre clé (ex. packages/core validera la forme des poids de ranking).
import type { Prisma } from '@prisma/client';
import { prisma } from '../client.js';
import type { DbClient } from '../types.js';

const select = {
  key: true,
  value: true,
  description: true,
  updatedAt: true,
} as const;

export interface AppSetting {
  key: string;
  value: unknown;
  description: string | null;
  updatedAt: Date;
}

export async function findAppSetting(
  key: string,
  db: DbClient = prisma,
): Promise<AppSetting | null> {
  return db.appSetting.findUnique({ where: { key }, select });
}

export async function upsertAppSetting(
  key: string,
  value: unknown,
  description: string | undefined,
  db: DbClient = prisma,
): Promise<AppSetting> {
  // `value` est volontairement `unknown` côté API publique (une AppSetting est un JSON générique
  // par clé) ; Prisma exige `InputJsonValue` en écriture — cast local justifié, pas un `any`.
  const jsonValue = value as Prisma.InputJsonValue;

  return db.appSetting.upsert({
    where: { key },
    create: { key, value: jsonValue, description },
    update: { value: jsonValue, ...(description !== undefined ? { description } : {}) },
    select,
  });
}
