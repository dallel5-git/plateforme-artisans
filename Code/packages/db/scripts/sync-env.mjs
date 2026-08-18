// Copie le .env racine du monorepo vers prisma/.env : c'est l'un des emplacements que le CLI
// Prisma charge automatiquement (https://pris.ly/d/prisma-schema-location), ce qui évite de
// dupliquer DATABASE_URL/DIRECT_DATABASE_URL dans un .env spécifique à ce package.
// Silencieux si le .env racine n'existe pas encore (première install, ou CI qui injecte les
// variables autrement) — jamais bloquant.
import { copyFileSync, existsSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { dirname, resolve } from 'node:path';

const here = dirname(fileURLToPath(import.meta.url));
const rootEnv = resolve(here, '../../../../.env');
const target = resolve(here, '../prisma/.env');

if (existsSync(rootEnv)) {
  copyFileSync(rootEnv, target);
}
