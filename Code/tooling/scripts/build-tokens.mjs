#!/usr/bin/env node
/**
 * Sanaya — générateur de design tokens.
 *
 * Source unique : tokens.json
 * Cibles        : TypeScript (web/admin, preset Tailwind) + Dart (mobile Flutter)
 *
 * Usage :
 *   node tooling/scripts/build-tokens.mjs           # génère
 *   node tooling/scripts/build-tokens.mjs --check   # échoue si les fichiers générés sont périmés (CI)
 *
 * ⚠️ Les fichiers générés NE DOIVENT JAMAIS être édités à la main.
 */

import { readFileSync, writeFileSync, mkdirSync, existsSync } from 'node:fs';
import { dirname, resolve } from 'node:path';

const ROOT = resolve(process.cwd());
const SRC = resolve(ROOT, 'packages/design-tokens/tokens.json');
const CHECK = process.argv.includes('--check');

const tokens = JSON.parse(readFileSync(SRC, 'utf8'));

/* ------------------------------------------------------------------ */
/* Résolution des alias {color.brand.500}                              */
/* ------------------------------------------------------------------ */
const deref = (value, depth = 0) => {
  if (depth > 10) throw new Error(`Alias circulaire : ${value}`);
  if (typeof value !== 'string' || !value.startsWith('{')) return value;
  const path = value.slice(1, -1).split('.');
  let node = tokens;
  for (const key of path) {
    node = node?.[key];
    if (node === undefined) throw new Error(`Alias introuvable : ${value}`);
  }
  return deref(node, depth + 1);
};

const resolveTree = (node) =>
  Object.fromEntries(
    Object.entries(node).map(([k, v]) => [
      k,
      typeof v === 'object' && v !== null ? resolveTree(v) : deref(v),
    ]),
  );

const t = resolveTree(
  Object.fromEntries(Object.entries(tokens).filter(([k]) => !k.startsWith('$'))),
);

const BANNER_TS = `// ⚠️ FICHIER GÉNÉRÉ — NE PAS ÉDITER À LA MAIN.
// Source : packages/design-tokens/tokens.json
// Régénérer : pnpm tokens:build
`;
const BANNER_DART = `// ⚠️ FICHIER GÉNÉRÉ — NE PAS ÉDITER À LA MAIN.
// Source : packages/design-tokens/tokens.json
// Régénérer : pnpm tokens:build
// ignore_for_file: constant_identifier_names
`;

const camel = (s) => s.replace(/[-_](\w)/g, (_, c) => c.toUpperCase());
const dartName = (s) => {
  const c = camel(s);
  return /^\d/.test(c) ? `s${c}` : c;
};
const hexToDart = (hex) => `Color(0xFF${hex.replace('#', '').toUpperCase()})`;

/* ------------------------------------------------------------------ */
/* Cible 1 — TypeScript : couleurs                                     */
/* ------------------------------------------------------------------ */
const tsColors = `${BANNER_TS}
export const palette = ${JSON.stringify(
  Object.fromEntries(Object.entries(t.color).filter(([k]) => k !== 'semantic')),
  null,
  2,
)} as const;

export const semantic = ${JSON.stringify(t.color.semantic, null, 2)} as const;

export type ColorScheme = keyof typeof semantic;
export type SemanticColor = keyof typeof semantic.light;
`;

/* ------------------------------------------------------------------ */
/* Cible 2 — TypeScript : espacements, rayons, typographie             */
/* ------------------------------------------------------------------ */
const tsSpacing = `${BANNER_TS}
export const spacing = ${JSON.stringify(t.spacing, null, 2)} as const;
export const radius  = ${JSON.stringify(t.radius, null, 2)} as const;
export const elevation = ${JSON.stringify(t.elevation, null, 2)} as const;
export const layout = ${JSON.stringify(t.layout, null, 2)} as const;
`;

const tsTypography = `${BANNER_TS}
export const typography = ${JSON.stringify(t.typography, null, 2)} as const;
export const motion = ${JSON.stringify(t.motion, null, 2)} as const;
`;

/* ------------------------------------------------------------------ */
/* Cible 3 — Preset Tailwind                                           */
/* ------------------------------------------------------------------ */
const tailwindPreset = `${BANNER_TS}
const { palette, semantic } = require('./src/colors');
const { spacing, radius, elevation } = require('./src/spacing');
const { typography } = require('./src/typography');

/** @type {import('tailwindcss').Config} */
module.exports = {
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        ...palette,
        // Les couleurs sémantiques sont exposées en variables CSS afin que
        // le basculement clair/sombre ne recompile rien.
        bg:        'rgb(var(--c-background) / <alpha-value>)',
        surface:   'rgb(var(--c-surface) / <alpha-value>)',
        border:    'rgb(var(--c-border) / <alpha-value>)',
        fg:        'rgb(var(--c-text-primary) / <alpha-value>)',
        'fg-muted':'rgb(var(--c-text-secondary) / <alpha-value>)',
        accent:    'rgb(var(--c-accent) / <alpha-value>)',
        verified:  'rgb(var(--c-verified) / <alpha-value>)',
        rating:    'rgb(var(--c-rating) / <alpha-value>)',
        whatsapp:  'rgb(var(--c-whatsapp) / <alpha-value>)',
      },
      spacing,
      borderRadius: radius,
      boxShadow: elevation,
      fontFamily: {
        sans:   [typography.family.latin, 'system-ui', 'sans-serif'],
        arabic: [typography.family.arabic, typography.family.latin, 'sans-serif'],
        mono:   [typography.family.mono, 'monospace'],
      },
      minHeight: { touch: '48px' },
      minWidth:  { touch: '48px' },
    },
  },
};
`;

/* ------------------------------------------------------------------ */
/* Cible 4 — Dart : couleurs                                           */
/* ------------------------------------------------------------------ */
const dartScheme = (scheme) =>
  Object.entries(t.color.semantic[scheme])
    .map(([k, v]) => `    ${dartName(k)}: const ${hexToDart(v)},`)
    .join('\n');

const semanticFields = Object.keys(t.color.semantic.light)
  .map((k) => `  final Color ${dartName(k)};`)
  .join('\n');

const semanticCtor = Object.keys(t.color.semantic.light)
  .map((k) => `    required this.${dartName(k)},`)
  .join('\n');

const paletteConsts = Object.entries(t.color)
  .filter(([k]) => k !== 'semantic')
  .map(
    ([group, shades]) =>
      `  // ${group}\n` +
      Object.entries(shades)
        .map(([shade, hex]) => `  static const ${dartName(group)}${shade} = ${hexToDart(hex)};`)
        .join('\n'),
  )
  .join('\n\n');

const dartColors = `${BANNER_DART}
import 'package:flutter/material.dart';

/// Palette brute. À n'utiliser que pour construire un [AppColors].
/// Dans les widgets, passer par \`context.colors.<role>\`.
abstract final class Palette {
${paletteConsts}
}

/// Rôles sémantiques. Injecté dans le ThemeData via [ThemeExtension],
/// ce qui rend le basculement clair/sombre automatique.
@immutable
class AppColors extends ThemeExtension<AppColors> {
${semanticFields}

  const AppColors({
${semanticCtor}
  });

  static const light = AppColors(
${dartScheme('light')}
  );

  static const dark = AppColors(
${dartScheme('dark')}
  );

  @override
  AppColors copyWith() => this;

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) =>
      other is AppColors ? (t < 0.5 ? this : other) : this;
}

extension AppColorsX on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
`;

/* ------------------------------------------------------------------ */
/* Cible 5 — Dart : espacements, rayons, typographie                   */
/* ------------------------------------------------------------------ */
const px = (v) => parseFloat(String(v).replace('px', ''));

const dartSpacing = `${BANNER_DART}
import 'package:flutter/widgets.dart';

abstract final class AppSpacing {
${Object.entries(t.spacing)
  .map(([k, v]) => `  static const double ${dartName(k)} = ${px(v).toFixed(1)};`)
  .join('\n')}
}

abstract final class AppRadius {
${Object.entries(t.radius)
  .map(
    ([k, v]) =>
      `  static const Radius ${dartName(k)} = Radius.circular(${px(v).toFixed(1)});`,
  )
  .join('\n')}
}

abstract final class AppLayout {
  /// Cible tactile minimale — accessibilité et usage sur chantier (gants, écran sale).
  static const double touchTarget = ${px(t.layout.touchTarget).toFixed(1)};
  static const double containerMax = ${px(t.layout.containerMax).toFixed(1)};
}
`;

const dartText = `${BANNER_DART}
import 'package:flutter/material.dart';

/// Échelle typographique. \`fontFamily\` est choisi automatiquement selon la
/// locale active : Manrope en latin, Noto Kufi Arabic en arabe.
abstract final class AppText {
  static const latinFamily = '${t.typography.family.latin}';
  static const arabicFamily = '${t.typography.family.arabic}';

  static String familyFor(Locale locale) =>
      locale.languageCode == 'ar' ? arabicFamily : latinFamily;

${Object.entries(t.typography.scale)
  .map(
    ([name, s]) => `  static TextStyle ${dartName(name)}(Locale locale) => TextStyle(
        fontFamily: familyFor(locale),
        fontSize: ${px(s.size).toFixed(1)},
        height: ${(px(s.lineHeight) / px(s.size)).toFixed(3)},
        fontWeight: FontWeight.w${s.weight},
      );`,
  )
  .join('\n\n')}
}
`;

/* ------------------------------------------------------------------ */
/* Écriture                                                            */
/* ------------------------------------------------------------------ */
const outputs = {
  'packages/design-tokens/src/colors.ts': tsColors,
  'packages/design-tokens/src/spacing.ts': tsSpacing,
  'packages/design-tokens/src/typography.ts': tsTypography,
  'packages/design-tokens/tailwind-preset.js': tailwindPreset,
  'apps/mobile/lib/core/theme/app_colors.dart': dartColors,
  'apps/mobile/lib/core/theme/app_spacing.dart': dartSpacing,
  'apps/mobile/lib/core/theme/app_text.dart': dartText,
};

let stale = [];
for (const [rel, content] of Object.entries(outputs)) {
  const path = resolve(ROOT, rel);
  if (CHECK) {
    if (!existsSync(path) || readFileSync(path, 'utf8') !== content) stale.push(rel);
  } else {
    mkdirSync(dirname(path), { recursive: true });
    writeFileSync(path, content, 'utf8');
    console.log(`✓ ${rel}`);
  }
}

if (CHECK) {
  if (stale.length) {
    console.error('✗ Design tokens périmés. Lancer `pnpm tokens:build` et commiter :');
    stale.forEach((f) => console.error(`  - ${f}`));
    process.exit(1);
  }
  console.log('✓ Design tokens à jour');
}
