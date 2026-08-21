import { defineConfig } from 'vitest/config';

// Miroir de `--env-file-if-exists` utilisé par les scripts dev/start/api:contract (package.json) :
// vitest ne relaie pas ce flag CLI à Node, donc on charge `.env` nous-mêmes, silencieusement s'il
// est absent (cas de la CI, qui fournit DATABASE_URL/REDIS_URL directement en variables de job).
// BE-11 : premier test `apps/api` qui touche réellement Redis (`infra/redis.ts` importe `env.ts`,
// dont le `safeParse` échoue tout le process si `REDIS_URL`/`DATABASE_URL` sont absents).
try {
  process.loadEnvFile('../../../.env');
} catch {
  // Pas de fichier .env local — attendu en CI.
}

export default defineConfig({});
