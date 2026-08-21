/**
 * BE-14a — `getOrSetCache` · vrai Redis (même justification que `rate-limit.test.ts` : Redis n'a
 * pas de schéma à migrer, le job CI `test (PostgreSQL + Redis)` expose un vrai service Redis).
 */
import { randomUUID } from 'node:crypto';
import { Redis } from 'ioredis';
import { afterAll, afterEach, beforeEach, describe, expect, it, vi } from 'vitest';
import { getOrSetCache } from '../src/infra/cache.js';
import { env } from '../src/env.js';
import { redis } from '../src/infra/redis.js';

const testRedis = new Redis(env.REDIS_URL);
let testKey: string;

beforeEach(() => {
  testKey = `catalog:test:${randomUUID()}`;
});

afterEach(async () => {
  await testRedis.del(testKey);
  vi.restoreAllMocks();
});

afterAll(() => {
  testRedis.disconnect();
});

describe('BE-14a — getOrSetCache (Redis réel)', () => {
  it('miss : appelle le fetcher, met en cache, puis sert le hit sans rappeler le fetcher', async () => {
    const fetcher = vi.fn().mockResolvedValue({ value: 'donnée' });

    const first = await getOrSetCache(testKey, 3600, fetcher);
    const second = await getOrSetCache(testKey, 3600, fetcher);

    expect(first).toEqual({ value: 'donnée' });
    expect(second).toEqual({ value: 'donnée' });
    expect(fetcher).toHaveBeenCalledTimes(1);
  });

  it('pose un TTL sur la clé — pas de fuite mémoire Redis', async () => {
    await getOrSetCache(testKey, 3600, async () => 'v');

    const ttl = await testRedis.ttl(testKey);
    expect(ttl).toBeGreaterThan(0);
    expect(ttl).toBeLessThanOrEqual(3600);
  });

  it('des clés différentes ont des entrées indépendantes', async () => {
    const otherKey = `catalog:test:${randomUUID()}`;
    const otherFetcher = vi.fn().mockResolvedValue('autre');

    await getOrSetCache(testKey, 3600, async () => 'valeur');
    const other = await getOrSetCache(otherKey, 3600, otherFetcher);

    expect(other).toBe('autre');
    expect(otherFetcher).toHaveBeenCalledTimes(1);

    await testRedis.del(otherKey);
  });

  it('le fetcher qui échoue fait échouer getOrSetCache sans écrire en cache', async () => {
    const failure = new Error('boom');
    const fetcher = vi.fn().mockRejectedValue(failure);

    await expect(getOrSetCache(testKey, 3600, fetcher)).rejects.toThrow('boom');

    const stored = await testRedis.get(testKey);
    expect(stored).toBeNull();
  });

  it('fail-open : une erreur Redis en lecture n’empêche pas d’obtenir la valeur du fetcher', async () => {
    vi.spyOn(redis, 'get').mockRejectedValueOnce(new Error('connexion Redis perdue'));
    const fetcher = vi.fn().mockResolvedValue('valeur-de-secours');

    const result = await getOrSetCache(testKey, 3600, fetcher);

    expect(result).toBe('valeur-de-secours');
    expect(fetcher).toHaveBeenCalledTimes(1);
  });
});
