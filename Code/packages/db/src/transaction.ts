// BE-05 : helper de transaction, nécessaire pour composer plusieurs appels de repositories dans
// une seule transaction Postgres (ex. BE-21 : ContactEvent + agrégats du profil en une seule
// opération atomique). Chaque fonction de repository accepte un dernier paramètre optionnel
// `db: DbClient` — passer le `tx` reçu ici la fait participer à la même transaction.
import { prisma } from './client.js';
import type { DbClient } from './types.js';

export async function withTransaction<T>(fn: (tx: DbClient) => Promise<T>): Promise<T> {
  return prisma.$transaction((tx) => fn(tx));
}
