#!/usr/bin/env node
/**
 * Sanaya — client Dart généré depuis contracts/openapi.json (BE-26, ADR-001 §3.2).
 *
 * Source unique : contracts/openapi.json
 * Cible          : apps/mobile/lib/core/api/generated/ (sous-arbre de l'app `sanaya`, dart-dio)
 *
 * Usage :
 *   node tooling/scripts/mobile-client.mjs           # génère
 *   node tooling/scripts/mobile-client.mjs --check   # échoue si le client généré est périmé (CI)
 *
 * ⚠️ Le dossier généré NE DOIT JAMAIS être édité à la main (.gitattributes le marque generated).
 *
 * FM-02b : le générateur produit d'abord un package pub autonome (openapi-generator-cli n'a pas
 * d'autre mode) — nécessaire pour que `dart pub get`/`build_runner` résolvent build_value_generator
 * isolément. Une fois le code généré et build_runner passé, `foldIntoApp()` aplatit `lib/**` à la
 * racine du dossier et réécrit les imports `package:sanaya_api_client/...` en
 * `package:sanaya/core/api/generated/...` : le résultat committé est un sous-arbre ordinaire de
 * l'app `sanaya`, plus un package séparé (voir apps/mobile/pubspec.yaml pour les dépendances
 * dio/built_value qu'il faut alors déclarer côté app).
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
// FM-02b : le client n'est plus un package pub autonome (BE-26) — il vit désormais dans
// l'arborescence de l'app réelle, importable en `package:sanaya/core/api/generated/...`.
const APP_PACKAGE_NAME = 'sanaya';
// Le shim POSIX (`#!/bin/sh`, sans extension) n'est pas exécutable directement par
// child_process.spawnSync sur Windows (pas d'interprétation de shebang) : on cible le .cmd
// généré par pnpm à côté, que Windows sait lancer nativement.
const GENERATOR_CLI = join(
  ROOT,
  process.platform === 'win32'
    ? 'node_modules/.bin/openapi-generator-cli.CMD'
    : 'node_modules/.bin/openapi-generator-cli',
);
const CHECK = process.argv.includes('--check');
const PACKAGE_NAME = 'sanaya_api_client';

// Versions exactes des dépendances du package pub.dev autonome que le générateur écrit
// (jamais committé lui-même depuis FM-02b — foldIntoApp le supprime en toute fin de pipeline,
// voir plus bas). Le générateur les déclare en range (ex. `>=8.4.0 <9.0.0`) : sans pin exact,
// `dart pub get` résout « la dernière version compatible au moment du run », qui dérive dans le
// temps à mesure que pub.dev publie — observé en pratique deux fois (BE-26c #153, puis ici :
// built_value/built_value_generator 8.4.0→8.12.7 entre deux régénérations à quelques jours
// d'écart, generated/*.dart différent alors qu'aucun schéma n'avait changé). Un pin exact rend
// la régénération déterministe indépendamment de la date d'exécution — mettre à jour ces
// versions est un choix délibéré (nouvelle PR), jamais une dérive silencieuse.
const PINNED_GENERATOR_DEPENDENCIES = {
  dio: '5.11.0',
  one_of: '1.5.0',
  one_of_serializer: '1.5.0',
  built_value: '8.12.7',
  built_collection: '5.1.1',
  built_value_generator: '8.12.7',
  build_runner: '2.16.0',
};

// Sur Windows, `dart`/`openapi-generator-cli` résolvent vers un script `.bat`/`.cmd` : depuis la
// CVE-2024-27980, spawnSync refuse de les exécuter sans `shell: true` (ENOENT/EINVAL sinon).
// Aucun argument passé ici ne contient d'espace ni de métacaractère shell (chemins temp/projet,
// noms de commande) — sûr à concaténer tel quel sous cmd.exe.
function run(cmd, args, opts = {}) {
  const result = spawnSync(cmd, args, {
    stdio: 'inherit',
    shell: process.platform === 'win32',
    ...opts,
  });
  if (result.error) {
    throw new Error(`Commande injoignable : ${cmd} ${args.join(' ')}\n${result.error.message}`);
  }
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

  const aliases = [];
  if (namesToHoist.has('V1UsersMeExportGet200ResponseUserRolesEnum')) {
    aliases.push(
      '// Rétrocompatibilité : alias pour les enums renommés lors de la déduplication openapi-generator',
      'typedef V1AuthOtpVerifyPost200ResponseUserRolesEnum = V1UsersMeExportGet200ResponseUserRolesEnum;',
      '',
    );
  }

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
      ...aliases,
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
// 3ter. Pin des dépendances du package pub.dev généré (voir PINNED_GENERATOR_DEPENDENCIES) —
//    remplace les ranges écrites par openapi-generator-cli par des versions exactes, pour que
//    `dart pub get` (juste après) résolve toujours la même chose indépendamment de la date
//    d'exécution. Doit tourner avant `dart pub get`.
// ---------------------------------------------------------------------------
function pinGeneratorDependencies(outputDir) {
  const pubspecPath = join(outputDir, 'pubspec.yaml');
  if (!existsSync(pubspecPath)) return;

  let pubspec = readFileSync(pubspecPath, 'utf8');
  for (const [name, version] of Object.entries(PINNED_GENERATOR_DEPENDENCIES)) {
    const pattern = new RegExp(`^(  ${name}:\\s*).*$`, 'm');
    if (!pattern.test(pubspec)) {
      throw new Error(
        `pinGeneratorDependencies : dépendance "${name}" attendue dans ${pubspecPath} mais introuvable — ` +
          'le générateur a peut-être changé son template pubspec.yaml, PINNED_GENERATOR_DEPENDENCIES doit être mis à jour.',
      );
    }
    pubspec = pubspec.replace(pattern, `$1'${version}'`);
  }
  pubspec += "\ndependency_overrides:\n  analyzer: '14.4.0'\n";
  writeFileSync(pubspecPath, pubspec, 'utf8');
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

  // Le parseur Swagger interne au générateur traite -i/-o comme une URI avant de les traiter
  // comme chemin fichier : un backslash Windows y est un caractère illégal
  // (`URISyntaxException: Illegal character in opaque part`). Le slash direct reste un chemin
  // Windows valide pour Node comme pour le générateur, donc sans effet côté POSIX.
  const toGeneratorPath = (p) => p.replaceAll('\\', '/');

  try {
    run(GENERATOR_CLI, [
      'generate',
      '-i',
      toGeneratorPath(tmpSpecPath),
      '-g',
      'dart-dio',
      '-o',
      toGeneratorPath(outputDir),
      '--package-name',
      PACKAGE_NAME,
      '-p',
      `pubName=${PACKAGE_NAME},pubAuthor=Sanaya,pubVersion=0.1.0`,
    ]);
  } finally {
    rmSync(tmpSpecPath, { force: true });
  }

  // Ce package n'est pas une lib publiée indépendamment (consommateurs multiples, résolution
  // de versions à leur discrétion) — c'est un artefact de build interne, vendu tel quel
  // (généré ici, committé, jamais régénéré par un consommateur). `pubspec.lock` doit donc être
  // committé et non ignoré (contrairement à la recommandation par défaut du générateur pour un
  // package "library") : sans lui, `dart pub get` résout les versions indépendamment à chaque
  // exécution, et un `built_value`/`built_value_generator` plus récent en CI qu'en local peut
  // produire un code différent de ce qui a été vérifié ici — observé en pratique (CI a résolu
  // une version dont le générateur produit des `@override` invalides que `dart analyze` refuse).
  const gitignorePath = join(outputDir, '.gitignore');
  if (existsSync(gitignorePath)) {
    const gitignore = readFileSync(gitignorePath, 'utf8');
    writeFileSync(
      gitignorePath,
      gitignore.replace(/^# Don't commit pubspec lock file[\s\S]*?\npubspec\.lock\n/m, ''),
      'utf8',
    );
  }

  pinGeneratorDependencies(outputDir);
  dedupeGeneratedEnums(outputDir);
  fixMissingNestedBuilderConversions(outputDir);

  run('dart', ['pub', 'get'], { cwd: outputDir });
  run('dart', ['run', 'build_runner', 'build', '--delete-conflicting-outputs'], { cwd: outputDir });
  run('dart', ['format', '.'], { cwd: outputDir });

  foldIntoApp(outputDir);
}

// ---------------------------------------------------------------------------
// 3bis. Fusion dans l'app réelle (FM-02b) — appelée en dernier, une fois pub get/build_runner/
//    format passés sur le package autonome ci-dessus (ils ont besoin de cette forme pour
//    résoudre leurs dépendances). Aplati lib/** à la racine, réécrit les imports
//    package:sanaya_api_client/... en package:sanaya/core/api/generated/..., renomme le barrel
//    en api.dart (chemin exigé par contact_flow_test.dart), puis supprime ce qui n'a de sens que
//    pour un package pub autonome.
// ---------------------------------------------------------------------------
function listAllFiles(dir) {
  const out = [];
  for (const entry of readdirSync(dir, { withFileTypes: true })) {
    const full = join(dir, entry.name);
    if (entry.isDirectory()) out.push(...listAllFiles(full));
    else out.push(full);
  }
  return out;
}

function foldIntoApp(outputDir) {
  const libDir = join(outputDir, 'lib');
  if (!existsSync(libDir)) return;

  const oldImportPrefix = `package:${PACKAGE_NAME}/`;
  const newImportPrefix = `package:${APP_PACKAGE_NAME}/core/api/generated/`;
  for (const file of listAllFiles(libDir)) {
    if (!file.endsWith('.dart')) continue;
    const content = readFileSync(file, 'utf8');
    if (content.includes(oldImportPrefix)) {
      writeFileSync(file, content.split(oldImportPrefix).join(newImportPrefix), 'utf8');
    }
  }

  // cpSync+rmSync plutôt que renameSync : sur Windows, un `rename` de répertoire échoue
  // (EPERM) dès qu'un watcher externe (serveur d'analyse Dart de l'IDE, notamment) a un
  // descripteur ouvert quelque part dans l'arborescence — un simple `flutter analyze` ou
  // `dart analyze` lancé en tâche de fond suffit à déclencher ça de façon intermittente.
  // Copier puis supprimer n'a pas besoin d'un verrou exclusif sur le répertoire source.
  for (const entry of readdirSync(libDir)) {
    cpSync(join(libDir, entry), join(outputDir, entry), { recursive: true });
  }
  rmSync(libDir, { recursive: true, force: true });

  // lib/sanaya_api_client.dart -> api.dart : chemin d'import exigé tel quel par
  // contact_flow_test.dart (package:sanaya/core/api/generated/api.dart).
  const oldBarrel = join(outputDir, `${PACKAGE_NAME}.dart`);
  const newBarrel = join(outputDir, 'api.dart');
  if (existsSync(oldBarrel)) {
    cpSync(oldBarrel, newBarrel);
    rmSync(oldBarrel, { force: true });
  }

  // FM-02c : contact_flow_test.dart importe NetworkException/UnauthorizedException depuis ce
  // même barrel (package:sanaya/core/api/generated/api.dart), pas depuis leur fichier
  // hand-written — ré-exportées ici, écrit par l'outillage (jamais par une main humaine dans ce
  // dossier). lib/core/api/exceptions.dart lui-même reste un fichier ordinaire, non généré.
  if (existsSync(newBarrel)) {
    const exportLine = "export 'package:sanaya/core/api/exceptions.dart';\n";
    const barrel = readFileSync(newBarrel, 'utf8');
    if (!barrel.includes(exportLine)) {
      writeFileSync(newBarrel, `${barrel}${exportLine}`, 'utf8');
    }
  }

  // Artefacts d'un package pub autonome — sans objet une fois fusionné : dio/built_value/... se
  // résolvent désormais via apps/mobile/pubspec.yaml et son propre pubspec.lock.
  for (const name of [
    'pubspec.yaml',
    'pubspec.lock',
    '.gitignore',
    'analysis_options.yaml',
    'test',
    '.dart_tool',
    'build',
    '.packages',
  ]) {
    rmSync(join(outputDir, name), { recursive: true, force: true });
  }
}

// ---------------------------------------------------------------------------
// 5. --check : régénère dans un dossier temporaire, diff fichier par fichier
//    (chemins + contenu) contre le dossier committé — même philosophie que
//    build-tokens.mjs/openapi.ts, appliquée à une arborescence entière.
// ---------------------------------------------------------------------------
// Artefacts de build locaux et non déterministes (chemins/horodatages), déjà exclus par le
// .gitignore que le générateur écrit lui-même dans le package — jamais comparés ni committés.
// `pubspec.lock` n'en fait volontairement PAS partie : il est committé (voir generateInto) et
// doit donc être comparé comme le reste — une dérive de version doit faire échouer `--check`.
const IGNORED_TOP_LEVEL_ENTRIES = new Set(['.dart_tool', 'build', '.packages']);

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
