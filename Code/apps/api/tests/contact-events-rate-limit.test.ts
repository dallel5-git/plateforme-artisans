/**
 * BE-21 — enforceContactEventRateLimit · vrai Redis.
 *
 * Même patron que `apps/api/tests/rate-limit.test.ts` (BE-11) : Redis n'a pas de schéma à
 * migrer, ce test tourne réellement en CI, pas seulement en local. `identityKey`/`ip` sont de
 * simples chaînes opaques pour `enforceContactEventRateLimit` (le hachage ne valide aucun
 * format) — `randomUUID()` convient et élimine tout risque de collision entre tests.
 */
import { randomUUID } from 'node:crypto';
import { RATE_LIMIT_EXCEEDED } from '@repo/constants';
import { DomainError } from '@repo/core';
import { Redis } from 'ioredis';
import { afterAll, beforeEach, describe, expect, it } from 'vitest';
import { env } from '../src/env.js';
import { enforceContactEventRateLimit } from '../src/plugins/rate-limit.js';

const redis = new Redis(env.REDIS_URL);
let identityKey: string;
let ip: string;

beforeEach(() => {
  identityKey = randomUUID();
  ip = randomUUID();
});

afterAll(() => {
  redis.disconnect();
});

describe('BE-21 — enforceContactEventRateLimit (Redis réel)', () => {
  it('autorise jusqu’à CONTACT_EVENT_LIMIT, bloque au-delà avec Retry-After', async () => {
    for (let i = 0; i < 30; i++) {
      await expect(enforceContactEventRateLimit({ identityKey, ip })).resolves.toBeUndefined();
    }

    let caught: unknown;
    try {
      await enforceContactEventRateLimit({ identityKey, ip });
    } catch (error) {
      caught = error;
    }

    expect(caught).toBeInstanceOf(DomainError);
    const domainError = caught as DomainError;
    expect(domainError.code).toBe(RATE_LIMIT_EXCEEDED);
    expect(domainError.httpStatus).toBe(429);
    expect(Number(domainError.headers?.['Retry-After'])).toBeGreaterThan(0);
  });

  it('une IP partagée par deux identités distinctes finit par bloquer même la seconde', async () => {
    // Propriété spécifique au double-clé : le compteur IP est partagé entre identités
    // différentes derrière la même adresse (contrairement au compteur d'identité, isolé).
    const otherIdentityKey = randomUUID();
    for (let i = 0; i < 30; i++) {
      await enforceContactEventRateLimit({ identityKey, ip });
    }

    let caught: unknown;
    try {
      await enforceContactEventRateLimit({ identityKey: otherIdentityKey, ip });
    } catch (error) {
      caught = error;
    }

    expect(caught).toBeInstanceOf(DomainError);
    expect((caught as DomainError).code).toBe(RATE_LIMIT_EXCEEDED);
  });

  it('des identités différentes sur des IP différentes ont des compteurs indépendants', async () => {
    const otherIdentityKey = randomUUID();
    const otherIp = randomUUID();

    for (let i = 0; i < 30; i++) {
      await enforceContactEventRateLimit({ identityKey, ip });
    }
    // `identityKey`/`ip` est à sa limite ; `otherIdentityKey`/`otherIp` doit rester libre.
    await expect(
      enforceContactEventRateLimit({ identityKey: otherIdentityKey, ip: otherIp }),
    ).resolves.toBeUndefined();
  });
});
