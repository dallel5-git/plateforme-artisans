import { redis } from './redis.js';

/**
 * BE-14a : cache-aside générique. Fail-open — toute erreur Redis (lecture ou écriture) est
 * absorbée et dégrade vers un appel systématique à `fetcher` : ces endpoints sont publics et
 * non authentifiés, une panne Redis ne doit jamais faire échouer la requête. Une erreur levée
 * par `fetcher` lui-même n'est en revanche jamais absorbée, ni mise en cache.
 */
export async function getOrSetCache<T>(
  key: string,
  ttlSeconds: number,
  fetcher: () => Promise<T>,
): Promise<T> {
  const cached = await redis.get(key).catch(() => null);
  if (cached !== null) {
    return JSON.parse(cached) as T;
  }

  const value = await fetcher();
  await redis.set(key, JSON.stringify(value), 'EX', ttlSeconds).catch(() => undefined);
  return value;
}
