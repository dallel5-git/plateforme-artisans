/**
 * BE-11 — Rate limiting · vrai Redis.
 *
 * Contrairement aux tests `auth-*` (bloqués par l'absence de `prisma migrate deploy` sur le
 * Postgres de CI — voir `auth-otp-verify.test.ts`), Redis n'a pas de schéma à migrer : le job CI
 * `test (PostgreSQL + Redis)` expose un vrai service Redis. Ce test tourne donc réellement en CI,
 * pas seulement en local.
 */
import { randomUUID } from 'node:crypto';
import { RATE_LIMIT_EXCEEDED } from '@repo/constants';
import { DomainError } from '@repo/core';
import { Redis } from 'ioredis';
import { afterAll, afterEach, beforeEach, describe, expect, it } from 'vitest';
import { env } from '../src/env.js';
import { enforceRateLimit } from '../src/plugins/rate-limit.js';

const redis = new Redis(env.REDIS_URL);
let testKey: string;

beforeEach(() => {
  testKey = `ratelimit:test:${randomUUID()}`;
});

afterEach(async () => {
  await redis.del(testKey);
});

afterAll(() => {
  redis.disconnect();
});

describe('BE-11 — enforceRateLimit (Redis réel)', () => {
  it('autorise jusqu’à la limite, bloque la 6ᵉ demande avec Retry-After', async () => {
    for (let i = 0; i < 5; i++) {
      await expect(
        enforceRateLimit({ key: testKey, limit: 5, windowSeconds: 3600 }),
      ).resolves.toBeUndefined();
    }

    let caught: unknown;
    try {
      await enforceRateLimit({ key: testKey, limit: 5, windowSeconds: 3600 });
    } catch (error) {
      caught = error;
    }

    expect(caught).toBeInstanceOf(DomainError);
    const domainError = caught as DomainError;
    expect(domainError.code).toBe(RATE_LIMIT_EXCEEDED);
    expect(domainError.httpStatus).toBe(429);
    expect(Number(domainError.headers?.['Retry-After'])).toBeGreaterThan(0);
  });

  it('pose un TTL sur la clé — pas de fuite mémoire Redis', async () => {
    await enforceRateLimit({ key: testKey, limit: 5, windowSeconds: 3600 });

    const ttl = await redis.ttl(testKey);
    expect(ttl).toBeGreaterThan(0);
    expect(ttl).toBeLessThanOrEqual(3600);
  });

  it('des clés différentes ont des compteurs indépendants', async () => {
    const otherKey = `ratelimit:test:${randomUUID()}`;

    for (let i = 0; i < 5; i++) {
      await enforceRateLimit({ key: testKey, limit: 5, windowSeconds: 3600 });
    }
    // `testKey` est à sa limite ; `otherKey` doit rester libre.
    await expect(
      enforceRateLimit({ key: otherKey, limit: 5, windowSeconds: 3600 }),
    ).resolves.toBeUndefined();

    await redis.del(otherKey);
  });
});
