import { defineConfig } from 'vitest/config';

// Même geste que apps/api/vitest.config.ts (BE-11) : vitest ne relaie pas --env-file-if-exists,
// donc on charge le .env racine nous-mêmes — silencieusement absent en CI, qui fournit
// DATABASE_URL/REDIS_URL directement en variables de job. QA-01a : les tests d'intégration de ce
// paquet (packages/db/tests/*.integration.test.ts) ont besoin de DATABASE_URL pour se connecter
// à une vraie PostgreSQL, contrairement aux tests purs déjà en place.
try {
  process.loadEnvFile('../../../.env');
} catch {
  // Pas de fichier .env local — attendu en CI.
}

export default defineConfig({});
