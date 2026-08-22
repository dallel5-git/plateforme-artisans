#!/usr/bin/env node
/**
 * Sanaya — client Dart généré depuis contracts/openapi.json (BE-26, ADR-001 §3.2).
 *
 * Source unique : contracts/openapi.json
 * Cible          : apps/mobile/lib/core/api/generated/ (package Dart autonome, dart-dio)
 *
 * Usage :
 *   node tooling/scripts/mobile-client.mjs           # génère
 *   node tooling/scripts/mobile-client.mjs --check   # échoue si le client généré est périmé (CI)
 *
 * ⚠️ Le dossier généré NE DOIT JAMAIS être édité à la main (.gitattributes le marque generated).
 *
 * apps/mobile n'est pas encore le vrai projet Flutter (FM-01 pas démarré, cadrage — voir
 * pnpm-workspace.yaml) : le client est généré comme un package Dart autonome, avec son propre
 * pubspec.yaml, vérifié isolément par `dart analyze`. FM-01/FM-02 l'intègreront plus tard dans
 * l'app réelle.
 */
import { spawnSync } from 'node:child_process';
import {
  cpSync,
  existsSync,
  mkdirSync,
  mkdtempSync,
  readdirSync,
  readFileSync,
  rmSync,
  writeFileSync,
} from 'node:fs';
import { tmpdir } from 'node:os';
import { dirname, join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const ROOT = resolve(dirname(fileURLToPath(import.meta.url)), '../..');
const SPEC_PATH = join(ROOT, 'contracts/openapi.json');
const TARGET_DIR = join(ROOT, 'apps/mobile/lib/core/api/generated');
const GENERATOR_CLI = join(ROOT, 'node_modules/.bin/openapi-generator-cli');
const CHECK = process.argv.includes('--check');
const PACKAGE_NAME = 'sanaya_api_client';

function run(cmd, args, opts = {}) {
  const result = spawnSync(cmd, args, { stdio: 'inherit', ...opts });
  if (result.status !== 0) {
    throw new Error(`Commande échouée (${result.status}) : ${cmd} ${args.join(' ')}`);
  }
}

// ---------------------------------------------------------------------------
// 1. Normalisation du spec pour le générateur Dart — jamais appliquée au
//    contrat committé, seulement à la copie temporaire passée au générateur.
// ---------------------------------------------------------------------------
// openapi-generator (dart-dio) a un support OpenAPI 3.1 encore bêta : il plante
// (ClassCastException) sur l'idiome JSON Schema `anyOf: [X, {type: 'null'}]` que
// fastify-type-provider-zod émet pour tout champ `.nullable()`. On le redescend
// en `nullable: true` (style OpenAPI 3.0), équivalent sémantique que le
// générateur sait traiter. Un schéma totalement vide (`{}`, ex. `z.unknown()`)
// fait planter le générateur de la même façon : traduit en objet libre.
function isNullBranch(schema) {
  return typeof schema === 'object' && schema !== null && schema.type === 'null';
}

function normalizeForDartGenerator(node) {
  if (Array.isArray(node)) return node.map(normalizeForDartGenerator);
  if (node && typeof node === 'object') {
    const normalized = {};
    for (const [key, value] of Object.entries(node)) {
      normalized[key] = normalizeForDartGenerator(value);
    }
    if (Array.isArray(normalized.anyOf)) {
      const nullBranches = normalized.anyOf.filter(isNullBranch);
      const otherBranches = normalized.anyOf.filter((b) => !isNullBranch(b));
      if (nullBranches.length > 0 && otherBranches.length === 1) {
        const { anyOf: _anyOf, ...rest } = normalized;
        return { ...rest, ...otherBranches[0], nullable: true };
      }
    }
    if (Object.keys(normalized).length === 0) {
      return { type: 'object', additionalProperties: true };
    }
    return normalized;
  }
  return node;
}

// ---------------------------------------------------------------------------
// 2. Dédoublonnage des enums générés — openapi-generator (dart-dio) émet une
//    définition de classe enum par point d'usage au lieu de réutiliser un
//    schéma nommé (le spec source n'a aucun composant partagé, tout est
//    inline — fastify-swagger). Quand la même forme d'enum (ex. `roles`,
//    `spokenLanguages`) apparaît dans 2 réponses distinctes, il arrive que le
//    générateur choisisse le même nom de classe pour les deux, mais écrive
//    quand même le corps dans chaque fichier → `ambiguous_import` sous
//    `built_value` (registre de sérialiseurs global, noms de classe uniques
//    exigés). On regroupe les définitions identiques dans un fichier partagé.
// ---------------------------------------------------------------------------
function extractEnumClassBlocks(content) {
  const blocks = [];
  const pattern = /class (\w+) extends EnumClass \{/g;
  let match;
  while ((match = pattern.exec(content))) {
    const className = match[1];
    const start = match.index;
    let depth = 1;
    let i = pattern.lastIndex;
    while (depth > 0 && i < content.length) {
      if (content[i] === '{') depth++;
      else if (content[i] === '}') depth--;
      i++;
    }
    blocks.push({ className, text: content.slice(start, i) });
  }
  return blocks;
}

function dedupeGeneratedEnums(outputDir) {
  const modelDir = join(outputDir, 'lib', 'src', 'model');
  if (!existsSync(modelDir)) return;
  const files = readdirSync(modelDir).filter(
    (f) => f.endsWith('.dart') && f !== 'shared_enums.dart',
  );

  const perFile = new Map();
  const byName = new Map();

  for (const file of files) {
    const filePath = join(modelDir, file);
    const content = readFileSync(filePath, 'utf8');
    const blocks = extractEnumClassBlocks(content);
    perFile.set(file, content);
    for (const block of blocks) {
      if (!byName.has(block.className)) byName.set(block.className, []);
      byName.get(block.className).push({ file, text: block.text });
    }
  }

  const duplicateNames = [...byName.entries()].filter(([, occurrences]) => occurrences.length > 1);
  if (duplicateNames.length === 0) return;

  const sharedBodies = [];
  const namesToHoist = new Set();
  for (const [className, occurrences] of duplicateNames) {
    const distinctBodies = new Set(occurrences.map((o) => o.text));
    if (distinctBodies.size !== 1) {
      // Collision de nom entre deux enums de contenu différent — cas non attendu (le générateur
      // ne réutilise un nom qu'à contenu identique) et non géré : laissé tel quel, dart analyze
      // le signalera plutôt que de risquer un dédoublonnage incorrect.
      continue;
    }
    sharedBodies.push(occurrences[0].text);
    namesToHoist.add(className);
  }
  if (sharedBodies.length === 0) return;

  const sharedContent =
    [
      '//',
      '// AUTO-GENERATED FILE, DO NOT MODIFY!',
      '//',
      "// BE-26 : enums réutilisés par plusieurs réponses de l'API (ex. rôles, langues parlées).",
      "// openapi-generator (dart-dio) émet une définition par point d'usage au lieu de réutiliser",
      "// un schéma nommé (le contrat source n'a aucun composant partagé) — regroupées ici pour",
      '// éviter un conflit de nom (built_value exige des noms de classe uniques dans tout le',
      '// package). Regroupement fait par tooling/scripts/mobile-client.mjs, pas par le générateur.',
      '//',
      '',
      "import 'package:built_collection/built_collection.dart';",
      "import 'package:built_value/built_value.dart';",
      "import 'package:built_value/serializer.dart';",
      '',
      "part 'shared_enums.g.dart';",
      '',
      sharedBodies.join('\n\n'),
      '',
    ].join('\n') + '\n';
  writeFileSync(join(modelDir, 'shared_enums.dart'), sharedContent, 'utf8');

  for (const [file, content] of perFile) {
    let updated = content;
    let touched = false;
    for (const name of namesToHoist) {
      const occurrence = byName.get(name).find((o) => o.file === file);
      if (occurrence) {
        updated = updated.replace(occurrence.text, '');
        touched = true;
      }
    }
    if (!touched) continue;

    const stillReferenced = [...namesToHoist].some((name) =>
      new RegExp(`\\b${name}\\b`).test(updated),
    );
    if (stillReferenced && !updated.includes("import 'shared_enums.dart';")) {
      updated = updated.replace(
        /^(import 'package:built_value\/built_value\.dart';\n)/m,
        `$1import 'shared_enums.dart';\n`,
      );
    }
    writeFileSync(join(modelDir, file), updated, 'utf8');
  }

  const barrelPath = join(outputDir, 'lib', `${PACKAGE_NAME}.dart`);
  if (existsSync(barrelPath)) {
    let barrel = readFileSync(barrelPath, 'utf8');
    const exportLine = `export 'package:${PACKAGE_NAME}/src/model/shared_enums.dart';\n`;
    if (!barrel.includes('model/shared_enums.dart')) {
      barrel = barrel.replace(/(export 'package:[^']+\/src\/model\/[^']+';\n)/, `$1${exportLine}`);
      writeFileSync(barrelPath, barrel, 'utf8');
    }
  }

  // build_runner détecte les enums de shared_enums.dart au niveau du paquet (indépendamment des
  // imports) et génère des références vers elles dans serializers.g.dart — mais serializers.dart
  // (le fichier qui le `part`) n'a lui-même aucune raison d'importer shared_enums.dart puisqu'il
  // n'y référence jamais ces enums directement (elles ne sont pas listées dans @SerializersFor,
  // seuls les modèles composés le sont). Sans cet import, serializers.g.dart référence un nom
  // hors de portée de son propre library. Symétrique au patch des fichiers modèles ci-dessus.
  const serializersPath = join(outputDir, 'lib', 'src', 'serializers.dart');
  if (existsSync(serializersPath)) {
    let serializers = readFileSync(serializersPath, 'utf8');
    if (!serializers.includes("import 'package:sanaya_api_client/src/model/shared_enums.dart';")) {
      serializers = serializers.replace(
        /^(import 'package:sanaya_api_client\/src\/model\/[^']+';\n)/m,
        `$1import 'package:sanaya_api_client/src/model/shared_enums.dart';\n`,
      );
      writeFileSync(serializersPath, serializers, 'utf8');
    }
  }
}

// ---------------------------------------------------------------------------
// 3. `.toBuilder()` manquant sur les propriétés objet imbriquées — même cause
//    racine que les deux bugs précédents (le contrat source n'utilise jamais
//    `$ref`/`components.schemas`, tout est un schéma anonyme inliné). Quand
//    une propriété est elle-même un type Built composé (ex. `provider` sur
//    POST /providers/me, `reviewAggregate` sur GET /providers/:slug), le
//    champ builder correspondant est typé `XBuilder?`, mais le désérialiseur
//    généré assigne la valeur immuable brute (`X`) sans la convertir —
//    `result.x = valueDes;` au lieu de `result.x = valueDes.toBuilder();`.
//    Repéré précisément : la propriété manquante suit toujours le même
//    patron dans le code généré, indépendant de tout schéma imbriqué à
//    référence nommée (absente ici).
// ---------------------------------------------------------------------------
function fixMissingNestedBuilderConversions(outputDir) {
  const modelDir = join(outputDir, 'lib', 'src', 'model');
  if (!existsSync(modelDir)) return;

  const files = readdirSync(modelDir).filter((f) => f.endsWith('.dart'));
  const contents = new Map(files.map((f) => [f, readFileSync(join(modelDir, f), 'utf8')]));

  // Ensemble de tous les types Built composés du package (toute classe déclarée
  // `implements Built<X, XBuilder>`) — le builder qui les contient reçoit automatiquement un
  // champ nommé `XBuilder?` (convention built_value pour les propriétés objet imbriquées),
  // jamais visible tel quel dans le code source tant que build_runner n'a pas tourné.
  const builtTypeNames = new Set();
  for (const content of contents.values()) {
    for (const m of content.matchAll(/Built<(\w+),\s*\1Builder>/g)) {
      builtTypeNames.add(m[1]);
    }
  }

  for (const [file, content] of contents) {
    const pattern = /\) as (\w+);(\s*\n\s*result\.\w+ = valueDes)(;)/g;
    const updated = content.replace(pattern, (full, type, mid, semi) =>
      builtTypeNames.has(type) ? `) as ${type};${mid}.toBuilder()${semi}` : full,
    );
    if (updated !== content) writeFileSync(join(modelDir, file), updated, 'utf8');
  }
}

// ---------------------------------------------------------------------------
// 4. Pipeline complet : génération -> dédoublonnage -> correctifs -> pub get
//    -> build_runner -> dart format. Le résultat (y compris les .g.dart, cf.
//    .gitattributes) est ce qui est committé — un `git pull` seul suffit,
//    personne n'a besoin de rejouer build_runner localement.
// ---------------------------------------------------------------------------
function generateInto(outputDir) {
  const spec = normalizeForDartGenerator(JSON.parse(readFileSync(SPEC_PATH, 'utf8')));
  const tmpSpecPath = join(tmpdir(), `sanaya-openapi-dart-${process.pid}.json`);
  writeFileSync(tmpSpecPath, JSON.stringify(spec, null, 2));

  try {
    run(GENERATOR_CLI, [
      'generate',
      '-i',
      tmpSpecPath,
      '-g',
      'dart-dio',
      '-o',
      outputDir,
      '--package-name',
      PACKAGE_NAME,
      '-p',
      `pubName=${PACKAGE_NAME},pubAuthor=Sanaya,pubVersion=0.1.0`,
    ]);
  } finally {
    rmSync(tmpSpecPath, { force: true });
  }

  dedupeGeneratedEnums(outputDir);
  fixMissingNestedBuilderConversions(outputDir);

  run('dart', ['pub', 'get'], { cwd: outputDir });
  run('dart', ['run', 'build_runner', 'build', '--delete-conflicting-outputs'], { cwd: outputDir });
  run('dart', ['format', '.'], { cwd: outputDir });
}

// ---------------------------------------------------------------------------
// 5. --check : régénère dans un dossier temporaire, diff fichier par fichier
//    (chemins + contenu) contre le dossier committé — même philosophie que
//    build-tokens.mjs/openapi.ts, appliquée à une arborescence entière.
// ---------------------------------------------------------------------------
// Artefacts de build locaux et non déterministes (chemins/horodatages), déjà exclus par le
// .gitignore que le générateur écrit lui-même dans le package — jamais comparés ni committés.
const IGNORED_TOP_LEVEL_ENTRIES = new Set(['.dart_tool', 'build', '.packages', 'pubspec.lock']);

function listFilesRecursive(dir, base = dir) {
  const out = [];
  for (const entry of readdirSync(dir, { withFileTypes: true })) {
    if (dir === base && IGNORED_TOP_LEVEL_ENTRIES.has(entry.name)) continue;
    const full = join(dir, entry.name);
    if (entry.isDirectory()) {
      out.push(...listFilesRecursive(full, base));
    } else {
      out.push(full.slice(base.length + 1));
    }
  }
  return out;
}

function diffDirectories(expectedDir, actualDir) {
  const expectedFiles = new Set(listFilesRecursive(expectedDir));
  const actualFiles = new Set(existsSync(actualDir) ? listFilesRecursive(actualDir) : []);

  const stale = [];
  for (const rel of expectedFiles) {
    if (!actualFiles.has(rel)) {
      stale.push(`manquant : ${rel}`);
      continue;
    }
    const expected = readFileSync(join(expectedDir, rel));
    const actual = readFileSync(join(actualDir, rel));
    if (!expected.equals(actual)) stale.push(`différent : ${rel}`);
  }
  for (const rel of actualFiles) {
    if (!expectedFiles.has(rel)) stale.push(`en trop : ${rel}`);
  }
  return stale;
}

async function main() {
  if (!CHECK) {
    rmSync(TARGET_DIR, { recursive: true, force: true });
    mkdirSync(dirname(TARGET_DIR), { recursive: true });
    generateInto(TARGET_DIR);
    console.log(`client mobile écrit : ${TARGET_DIR}`);
    return;
  }

  const tmpDir = mkdtempSync(join(tmpdir(), 'sanaya-mobile-client-check-'));
  try {
    generateInto(tmpDir);
    const stale = diffDirectories(tmpDir, TARGET_DIR);
    if (stale.length > 0) {
      console.error(
        `✗ client mobile périmé : ${TARGET_DIR} diffère de ce que régénère le contrat actuel.\n` +
          'Lancer `pnpm mobile:client` et commiter le résultat.\n' +
          stale.map((s) => `  - ${s}`).join('\n'),
      );
      process.exitCode = 1;
      return;
    }
    console.log('✓ client mobile à jour');
  } finally {
    rmSync(tmpDir, { recursive: true, force: true });
  }
}

main().catch((err) => {
  console.error(err);
  process.exitCode = 1;
});
