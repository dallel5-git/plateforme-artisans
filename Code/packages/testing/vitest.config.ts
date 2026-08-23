import { defineConfig } from 'vitest/config';

// Même geste que packages/db/vitest.config.ts et apps/api/vitest.config.ts (BE-11) : ce paquet
// compose des fixtures qui écrivent réellement en base (QA-01a), donc a besoin de DATABASE_URL.
try {
  process.loadEnvFile('../../../.env');
} catch {
  // Pas de fichier .env local — attendu en CI.
}

export default defineConfig({});
