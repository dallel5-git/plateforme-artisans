#!/usr/bin/env node
// Détecte les couleurs Material littérales (`Colors.xxx`, `Color(0x...)`) en dehors de
// `lib/core/theme/` (généré depuis packages/design-tokens/tokens.json — voir build-tokens.mjs).
// CLAUDE.md mobile, règle 3 : « Aucune couleur, taille, rayon ou police en dur. » — passer par
// `context.colors.<rôle>` à la place. FM-18 : ce garde-fou aurait dû attraper les 3 littéraux
// mergés dans provider_gallery.dart ; rien ne le faisait jusqu'ici.
import { readFileSync, readdirSync, statSync } from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const scriptDir = path.dirname(fileURLToPath(import.meta.url));
const libDir = path.resolve(scriptDir, '../../apps/mobile/lib');
const excludedDir = path.join(libDir, 'core', 'theme');

// Lookbehind négatif : évite de matcher `Colors.xxx`/`Color(0x` comme sous-chaîne d'un
// identifiant plus long (ex. `AppColors.light`, `MyColor(0x...)`).
const COLORS_PATTERN = /(?<![A-Za-z])Colors\.[a-z]\w*/g;
const COLOR_HEX_PATTERN = /(?<![A-Za-z])Color\(0x/g;
const ALLOWED = new Set(['Colors.transparent']);

function walkDartFiles(dir) {
  const files = [];
  for (const entry of readdirSync(dir)) {
    const fullPath = path.join(dir, entry);
    if (fullPath === excludedDir) continue;
    const stat = statSync(fullPath);
    if (stat.isDirectory()) {
      files.push(...walkDartFiles(fullPath));
    } else if (entry.endsWith('.dart')) {
      files.push(fullPath);
    }
  }
  return files;
}

function scanFile(filePath) {
  const violations = [];
  const lines = readFileSync(filePath, 'utf8').split('\n');

  lines.forEach((line, index) => {
    if (line.trim().startsWith('//')) return;

    const colorMatches = line.match(COLORS_PATTERN) ?? [];
    for (const match of colorMatches) {
      if (!ALLOWED.has(match)) {
        violations.push({ line: index + 1, text: line.trim() });
      }
    }

    if (COLOR_HEX_PATTERN.test(line)) {
      violations.push({ line: index + 1, text: line.trim() });
    }
  });

  return violations;
}

function main() {
  const files = walkDartFiles(libDir);
  const problems = [];

  for (const filePath of files) {
    const violations = scanFile(filePath);
    if (violations.length > 0) {
      const relativePath = path.relative(path.resolve(scriptDir, '../..'), filePath);
      for (const violation of violations) {
        problems.push(`${relativePath}:${violation.line} → ${violation.text}`);
      }
    }
  }

  if (problems.length > 0) {
    console.error('✖ Couleurs Material littérales détectées (CLAUDE.md mobile, règle 3) :\n');
    for (const problem of problems) {
      console.error(`  - ${problem}`);
    }
    console.error(
      `\n${problems.length} occurrence(s) à remplacer par context.colors.<rôle> avant de continuer.`,
    );
    process.exit(1);
  }

  console.log(
    `✓ Aucune couleur littérale hors lib/core/theme/ — ${files.length} fichier(s) scanné(s).`,
  );
}

main();
