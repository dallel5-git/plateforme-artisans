#!/usr/bin/env node
/**
 * Sanaya — types TypeScript générés depuis contracts/openapi.json (BE-26, ADR-001 §3.2).
 *
 * Source unique : contracts/openapi.json
 * Cible          : apps/web/src/lib/api/generated/schema.d.ts
 *
 * Usage :
 *   node tooling/scripts/web-client.mjs           # génère
 *   node tooling/scripts/web-client.mjs --check   # échoue si le fichier généré est périmé (CI)
 *
 * apps/web est reporté au sprint S2 (ADR-003) — ce fichier n'a aucun consommateur cette semaine,
 * "prêt pour S2" au sens du ticket. Consommé plus tard par `openapi-fetch` (FW-03).
 *
 * ⚠️ Le fichier généré NE DOIT JAMAIS être édité à la main.
 */
import { mkdirSync, readFileSync, writeFileSync } from 'node:fs';
import { dirname, join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import openapiTS, { astToString } from 'openapi-typescript';

const ROOT = resolve(dirname(fileURLToPath(import.meta.url)), '../..');
const SPEC_PATH = join(ROOT, 'contracts/openapi.json');
const TARGET_PATH = join(ROOT, 'apps/web/src/lib/api/generated/schema.d.ts');
const CHECK = process.argv.includes('--check');

const BANNER = `// ⚠️ FICHIER GÉNÉRÉ — NE PAS ÉDITER À LA MAIN.
// Source : contracts/openapi.json
// Régénérer : pnpm web:client

`;

async function main() {
  const spec = JSON.parse(readFileSync(SPEC_PATH, 'utf8'));
  const ast = await openapiTS(spec);
  const content = BANNER + astToString(ast);

  if (CHECK) {
    let existing = null;
    try {
      existing = readFileSync(TARGET_PATH, 'utf8');
    } catch {
      existing = null;
    }
    if (existing !== content) {
      console.error(
        `✗ client web périmé : ${TARGET_PATH} diffère des schémas Zod actuels.\n` +
          'Lancer `pnpm web:client` et commiter le résultat.',
      );
      process.exitCode = 1;
      return;
    }
    console.log('✓ client web à jour');
    return;
  }

  mkdirSync(dirname(TARGET_PATH), { recursive: true });
  writeFileSync(TARGET_PATH, content, 'utf8');
  console.log(`client web écrit : ${TARGET_PATH}`);
}

main().catch((err) => {
  console.error(err);
  process.exitCode = 1;
});
