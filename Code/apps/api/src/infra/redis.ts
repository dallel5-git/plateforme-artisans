import { Redis } from 'ioredis';

import { env } from '../env.js';

export const redis = new Redis(env.REDIS_URL, {
  lazyConnect: true,
  maxRetriesPerRequest: 1,
  connectTimeout: 2000,
});

redis.on('error', (err) => {
  console.error('Erreur inattendue du client Redis', err);
});

export async function checkRedis(): Promise<boolean> {
  try {
    if (redis.status === 'wait' || redis.status === 'end') {
      await redis.connect();
    }
    return (await redis.ping()) === 'PONG';
  } catch {
    return false;
  }
}

export function closeRedis(): void {
  redis.disconnect();
}

/**
 * BE-11 : compteur fenêtre-fixe pour le rate limiting. `INCR` puis `EXPIRE` défensif si la clé
 * n'a pas (ou plus) de TTL — couvre le premier appel (clé neuve) et tout état anormal, garantit
 * qu'aucune clé `ratelimit:*` ne reste sans expiration (pas de fuite mémoire Redis).
 */
export async function incrementWithExpiry(
  key: string,
  windowSeconds: number,
): Promise<{ count: number; ttlSeconds: number }> {
  const count = await redis.incr(key);
  let ttlSeconds = await redis.ttl(key);
  if (ttlSeconds < 0) {
    await redis.expire(key, windowSeconds);
    ttlSeconds = windowSeconds;
  }
  return { count, ttlSeconds };
}
