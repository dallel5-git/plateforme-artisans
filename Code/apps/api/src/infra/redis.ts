import { Redis } from 'ioredis';

import { env } from '../env.js';

const redis = new Redis(env.REDIS_URL, {
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
