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
import { pathToFileURL } from 'node:url';

const ROOT = resolve(process.cwd());
const SRC = resolve(ROOT, 'packages/design-tokens/tokens.json');
const CHECK = process.argv.includes('--check');

/* ------------------------------------------------------------------ */
/* Résolution des alias {color.brand.500}                              */
/* ------------------------------------------------------------------ */
export function resolveTokens(rawTokens) {
  const deref = (value, depth = 0) => {
    if (depth > 10) throw new Error(`Alias circulaire : ${value}`);
    if (typeof value !== 'string' || !value.startsWith('{')) return value;
    const path = value.slice(1, -1).split('.');
    let node = rawTokens;
    for (const key of path) {
      node = node?.[key];
      if (node === undefined) throw new Error(`Alias introuvable : ${value}`);
    }
    return deref(node, depth + 1);
  };

  const resolveTree = (node) => {
    if (Array.isArray(node))
      return node.map((v) => (typeof v === 'object' && v !== null ? resolveTree(v) : deref(v)));
    return Object.fromEntries(
      Object.entries(node).map(([k, v]) => [
        k,
        typeof v === 'object' && v !== null ? resolveTree(v) : deref(v),
      ]),
    );
  };

  return resolveTree(
    Object.fromEntries(Object.entries(rawTokens).filter(([k]) => !k.startsWith('$'))),
  );
}

export function buildOutputs(t) {
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
  const px = (v) => parseFloat(String(v).replace('px', ''));

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
  const cssShadow = (layers) =>
    layers.length
      ? layers.map((l) => `${l.x} ${l.y} ${l.blur} ${l.spread} ${l.color}`).join(', ')
      : 'none';

  const elevationCss = (scheme) =>
    Object.fromEntries(
      Object.entries(t.elevation[scheme]).map(([k, layers]) => [k, cssShadow(layers)]),
    );

  const tsSpacing = `${BANNER_TS}
export const spacing = ${JSON.stringify(t.spacing, null, 2)} as const;
export const radius  = ${JSON.stringify(t.radius, null, 2)} as const;
export const elevation = ${JSON.stringify({ light: elevationCss('light'), dark: elevationCss('dark') }, null, 2)} as const;
export const layout = ${JSON.stringify(t.layout, null, 2)} as const;
export const iconSize = ${JSON.stringify(t.iconSize, null, 2)} as const;
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
      // Thème clair uniquement : zéro consommateur Tailwind aujourd'hui.
      // Le mode sombre (variables CSS) est câblé par FM-18 avec design-system.html.
      boxShadow: elevation.light,
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

  const semanticCopyWithParams = Object.keys(t.color.semantic.light)
    .map((k) => `    Color? ${dartName(k)},`)
    .join('\n');

  const semanticCopyWithBody = Object.keys(t.color.semantic.light)
    .map((k) => `    ${dartName(k)}: ${dartName(k)} ?? this.${dartName(k)},`)
    .join('\n');

  const semanticLerpBody = Object.keys(t.color.semantic.light)
    .map((k) => `      ${dartName(k)}: Color.lerp(this.${dartName(k)}, other.${dartName(k)}, t)!,`)
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
  AppColors copyWith({
${semanticCopyWithParams}
  }) => AppColors(
${semanticCopyWithBody}
  );

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
${semanticLerpBody}
    );
  }
}

extension AppColorsX on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
`;

  /* ------------------------------------------------------------------ */
  /* Cible 4bis — Dart : élévation + motion                              */
  /* ------------------------------------------------------------------ */
  const rgbaToDart = (css) => {
    const m = css.match(/rgba?\(\s*([\d.]+)\s*,\s*([\d.]+)\s*,\s*([\d.]+)\s*,?\s*([\d.]+)?\s*\)/);
    if (!m) throw new Error(`Couleur d'ombre non reconnue : ${css}`);
    const [, r, g, b, a = '1'] = m;
    return `Color.fromRGBO(${r}, ${g}, ${b}, ${a})`;
  };

  const boxShadowDart = (l) =>
    `BoxShadow(offset: Offset(${px(l.x).toFixed(1)}, ${px(l.y).toFixed(1)}), blurRadius: ${px(l.blur).toFixed(1)}, spreadRadius: ${px(l.spread).toFixed(1)}, color: ${rgbaToDart(l.color)})`;

  const elevationKeys = Object.keys(t.elevation.light);

  const elevationLerpBody = elevationKeys
    .map(
      (k) =>
        `      ${dartName(k)}: BoxShadow.lerpList(this.${dartName(k)}, other.${dartName(k)}, t) ?? this.${dartName(k)},`,
    )
    .join('\n');

  const dartElevation = `${BANNER_DART}
import 'package:flutter/material.dart';

/// Ombres portées thématisées. Injecté dans le ThemeData via [ThemeExtension].
@immutable
class AppElevation extends ThemeExtension<AppElevation> {
${elevationKeys.map((k) => `  final List<BoxShadow> ${dartName(k)};`).join('\n')}

  const AppElevation({
${elevationKeys.map((k) => `    required this.${dartName(k)},`).join('\n')}
  });

  static const light = AppElevation(
${Object.entries(t.elevation.light)
  .map(([k, layers]) => `    ${dartName(k)}: const [${layers.map(boxShadowDart).join(', ')}],`)
  .join('\n')}
  );

  static const dark = AppElevation(
${Object.entries(t.elevation.dark)
  .map(([k, layers]) => `    ${dartName(k)}: const [${layers.map(boxShadowDart).join(', ')}],`)
  .join('\n')}
  );

  @override
  AppElevation copyWith({
${elevationKeys.map((k) => `    List<BoxShadow>? ${dartName(k)},`).join('\n')}
  }) => AppElevation(
${elevationKeys.map((k) => `    ${dartName(k)}: ${dartName(k)} ?? this.${dartName(k)},`).join('\n')}
  );

  @override
  AppElevation lerp(ThemeExtension<AppElevation>? other, double t) {
    if (other is! AppElevation) return this;
    return AppElevation(
${elevationLerpBody}
    );
  }
}

extension AppElevationX on BuildContext {
  AppElevation get elevation => Theme.of(this).extension<AppElevation>()!;
}
`;

  const msDart = (v) => `Duration(milliseconds: ${parseInt(v, 10)})`;
  const cubicDart = (css) => {
    const m = css.match(/cubic-bezier\(([^)]+)\)/);
    if (!m) throw new Error(`Easing non reconnu : ${css}`);
    const [a, b, c, d] = m[1].split(',').map((n) => parseFloat(n));
    return `Cubic(${a}, ${b}, ${c}, ${d})`;
  };

  const dartMotion = `${BANNER_DART}
import 'package:flutter/animation.dart';

abstract final class AppMotion {
  static const durationFast = ${msDart(t.motion.duration.fast)};
  static const durationBase = ${msDart(t.motion.duration.base)};
  static const durationSlow = ${msDart(t.motion.duration.slow)};
  static const easingStandard = ${cubicDart(t.motion.easing.standard)};
  static const easingDecelerate = ${cubicDart(t.motion.easing.decelerate)};
}
`;

  /* ------------------------------------------------------------------ */
  /* Cible 5 — Dart : espacements, rayons, typographie                   */
  /* ------------------------------------------------------------------ */
  const dartSpacing = `${BANNER_DART}
import 'package:flutter/widgets.dart';

abstract final class AppSpacing {
${Object.entries(t.spacing)
  .map(([k, v]) => `  static const double ${dartName(k)} = ${px(v).toFixed(1)};`)
  .join('\n')}
}

abstract final class AppRadius {
${Object.entries(t.radius)
  .map(([k, v]) => `  static const Radius ${dartName(k)} = Radius.circular(${px(v).toFixed(1)});`)
  .join('\n')}
}

abstract final class AppLayout {
  /// Cible tactile minimale — accessibilité et usage sur chantier (gants, écran sale).
  static const double touchTarget = ${px(t.layout.touchTarget).toFixed(1)};
  static const double containerMax = ${px(t.layout.containerMax).toFixed(1)};
  static const double breakpointSm = ${px(t.layout.breakpoint.sm).toFixed(1)};
  static const double breakpointMd = ${px(t.layout.breakpoint.md).toFixed(1)};
  static const double breakpointLg = ${px(t.layout.breakpoint.lg).toFixed(1)};
  static const double breakpointXl = ${px(t.layout.breakpoint.xl).toFixed(1)};
}

abstract final class AppIconSize {
${Object.entries(t.iconSize)
  .map(([k, v]) => `  static const double ${dartName(k)} = ${px(v).toFixed(1)};`)
  .join('\n')}
}
`;

  const trackingPx = (tracking, sizePx) => parseFloat(tracking) * sizePx;

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
        letterSpacing: ${trackingPx(s.tracking, px(s.size)).toFixed(3)},
      );`,
  )
  .join('\n\n')}
}

abstract final class AppFontWeight {
${Object.entries(t.typography.weight)
  .map(([k, v]) => `  static const ${dartName(k)} = FontWeight.w${v};`)
  .join('\n')}
}
`;

  return {
    'packages/design-tokens/src/colors.ts': tsColors,
    'packages/design-tokens/src/spacing.ts': tsSpacing,
    'packages/design-tokens/src/typography.ts': tsTypography,
    'packages/design-tokens/tailwind-preset.js': tailwindPreset,
    'apps/mobile/lib/core/theme/app_colors.dart': dartColors,
    'apps/mobile/lib/core/theme/app_elevation.dart': dartElevation,
    'apps/mobile/lib/core/theme/app_motion.dart': dartMotion,
    'apps/mobile/lib/core/theme/app_spacing.dart': dartSpacing,
    'apps/mobile/lib/core/theme/app_text.dart': dartText,
  };
}

/* ------------------------------------------------------------------ */
/* Écriture                                                            */
/* ------------------------------------------------------------------ */
function main() {
  const tokens = JSON.parse(readFileSync(SRC, 'utf8'));
  const outputs = buildOutputs(resolveTokens(tokens));

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
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) main();
