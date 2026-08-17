#!/usr/bin/env node
// Compare récursivement les jeux de clés des catalogues FR/AR, namespace par namespace
// (packages/i18n/src/locales/{fr,ar}/<namespace>.json). Principe P7 (CLAUDE.md §2) : une clé
// ajoutée dans une langue sans son équivalent dans l'autre ne doit jamais passer inaperçue.
import { readdirSync, readFileSync } from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const LOCALES = ['fr', 'ar'];

const scriptDir = path.dirname(fileURLToPath(import.meta.url));
const localesDir = path.resolve(scriptDir, '../../packages/i18n/src/locales');

function flattenKeys(value, prefix = '') {
  if (value === null || typeof value !== 'object' || Array.isArray(value)) {
    return prefix ? [prefix] : [];
  }
  return Object.entries(value).flatMap(([key, child]) =>
    flattenKeys(child, prefix ? `${prefix}.${key}` : key),
  );
}

function readJsonFile(filePath) {
  const raw = readFileSync(filePath, 'utf8');
  try {
    return JSON.parse(raw);
  } catch (err) {
    throw new Error(`JSON invalide dans ${filePath} : ${err instanceof Error ? err.message : err}`);
  }
}

function main() {
  const [localeA, localeB] = LOCALES;
  const dirA = path.join(localesDir, localeA);
  const dirB = path.join(localesDir, localeB);

  const namespacesA = new Set(readdirSync(dirA).filter((file) => file.endsWith('.json')));
  const namespacesB = new Set(readdirSync(dirB).filter((file) => file.endsWith('.json')));
  const allNamespaces = [...new Set([...namespacesA, ...namespacesB])].sort();

  const problems = [];

  for (const namespace of allNamespaces) {
    if (!namespacesA.has(namespace)) {
      problems.push(`${localeA}/${namespace} : fichier absent (présent côté ${localeB})`);
      continue;
    }
    if (!namespacesB.has(namespace)) {
      problems.push(`${localeB}/${namespace} : fichier absent (présent côté ${localeA})`);
      continue;
    }

    const keysA = new Set(flattenKeys(readJsonFile(path.join(dirA, namespace))));
    const keysB = new Set(flattenKeys(readJsonFile(path.join(dirB, namespace))));

    const missingInB = [...keysA].filter((key) => !keysB.has(key)).sort();
    const missingInA = [...keysB].filter((key) => !keysA.has(key)).sort();

    if (missingInB.length > 0) {
      problems.push(`${namespace} : manquantes côté ${localeB} → ${missingInB.join(', ')}`);
    }
    if (missingInA.length > 0) {
      problems.push(`${namespace} : manquantes côté ${localeA} → ${missingInA.join(', ')}`);
    }
  }

  if (problems.length > 0) {
    console.error('✖ Parité i18n rompue :\n');
    for (const problem of problems) {
      console.error(`  - ${problem}`);
    }
    console.error(`\n${problems.length} problème(s) à corriger avant de continuer (principe P7).`);
    process.exit(1);
  }

  console.log(`✓ Parité i18n OK — ${allNamespaces.length} namespace(s) (${LOCALES.join('/')}).`);
}

main();
