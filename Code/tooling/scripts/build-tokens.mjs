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

  /* ------------------------------------------------------------------ */
  /* Cible 6 — docs/design-system.html                                   */
  /* FM-18b : élimine les 2 copies à la main de la palette (bloc CSS      */
  /* :root + objet JS SEM) qui avaient divergé de tokens.json.            */
  /* Les clés color.semantic sont déjà en kebab-case dans tokens.json —   */
  /* aucune conversion nécessaire, contrairement aux cibles Dart/TS.      */
  /* ------------------------------------------------------------------ */
  const cssVarsFor = (scheme) => {
    const colorVars = Object.entries(t.color.semantic[scheme])
      .map(([k, v]) => `  --c-${k}: ${v};`)
      .join('\n');
    const shadow = elevationCss(scheme);
    const shadowVars = ['sm', 'md', 'lg'].map((k) => `  --shadow-${k}: ${shadow[k]};`).join('\n');
    return `${colorVars}\n${shadowVars}`;
  };

  const spacingVar = (k) => `${px(t.spacing[k]).toFixed(0)}px`;
  const radiusVar = (k) => `${px(t.radius[k]).toFixed(0)}px`;

  const rootVars = `:root{
  --s-xxs:${spacingVar('xxs')}; --s-xs:${spacingVar('xs')}; --s-sm:${spacingVar('sm')}; --s-md:${spacingVar('md')}; --s-lg:${spacingVar('lg')}; --s-xl:${spacingVar('xl')}; --s-2xl:${spacingVar('2xl')}; --s-3xl:${spacingVar('3xl')};
  --r-sm:${radiusVar('sm')}; --r-md:${radiusVar('md')}; --r-lg:${radiusVar('lg')}; --r-xl:${radiusVar('xl')}; --r-pill:${radiusVar('pill')};
  --touch:${px(t.layout.touchTarget).toFixed(0)}px;
}`;

  // Regroupement éditorial des rôles pour l'affichage du nuancier (§1) —
  // ce n'est pas dérivable de tokens.json (c'est une décision de présentation),
  // donc figé ici. Tout rôle non listé atterrit automatiquement dans
  // « Autres rôles » plutôt que d'être silencieusement omis (garantit que
  // l'ajout d'un futur rôle dans tokens.json n'exige pas de toucher ce fichier).
  const SWATCH_GROUPS = [
    [
      'Fonds & surfaces',
      ['background', 'surface', 'surface-raised', 'surface-sunken', 'border', 'border-strong'],
    ],
    ['Texte', ['text-primary', 'text-secondary', 'text-muted', 'text-inverse']],
    ['Accent', ['accent', 'accent-hover', 'accent-subtle', 'on-accent']],
    [
      'Statuts',
      [
        'verified',
        'verified-subtle',
        'pending',
        'pending-subtle',
        'destructive',
        'destructive-subtle',
      ],
    ],
    ['Spécifiques produit', ['rating', 'sponsored', 'whatsapp']],
  ];
  const groupedKeys = new Set(SWATCH_GROUPS.flatMap(([, keys]) => keys));
  const remainingKeys = Object.keys(t.color.semantic.light).filter((k) => !groupedKeys.has(k));
  const swatchGroups = remainingKeys.length
    ? [...SWATCH_GROUPS, ['Autres rôles', remainingKeys]]
    : SWATCH_GROUPS;

  const designSystemHtml = `<!DOCTYPE html>
<html lang="fr" dir="ltr" data-theme="light">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Sanaya — Design System</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&family=Noto+Kufi+Arabic:wght@400;500;600;700&display=swap" rel="stylesheet">
<style>
:root[data-theme="light"] {
${cssVarsFor('light')}
}
:root[data-theme="dark"] {
${cssVarsFor('dark')}
}
${rootVars}
*{margin:0;padding:0;box-sizing:border-box}
html[dir="rtl"] body{font-family:'Noto Kufi Arabic','Manrope',sans-serif}
body{
  font-family:'Manrope',system-ui,sans-serif;
  background:var(--c-background); color:var(--c-text-primary);
  font-size:15px; line-height:1.47; -webkit-font-smoothing:antialiased;
  transition:background .2s, color .2s;
}
.wrap{max-width:1120px;margin:0 auto;padding:var(--s-xl) var(--s-lg) 96px}
header.top{
  position:sticky;top:0;z-index:20;background:var(--c-surface);
  border-bottom:1px solid var(--c-border);
  padding:var(--s-md) var(--s-lg);display:flex;align-items:center;gap:var(--s-md);flex-wrap:wrap;
}
.logo{width:32px;height:32px;border-radius:var(--r-md);background:var(--c-accent);color:var(--c-on-accent);
  display:grid;place-items:center;font-weight:800;font-size:17px;flex:none}
.brandname{font-weight:800;font-size:17px;letter-spacing:-.02em}
.brandsub{color:var(--c-text-muted);font-size:13px}
.spacer{flex:1}
.toggle{
  border:1px solid var(--c-border-strong);background:var(--c-surface);color:var(--c-text-primary);
  border-radius:var(--r-pill);padding:8px 14px;font:600 13px/1 'Manrope',sans-serif;cursor:pointer;
  min-height:36px;
}
.toggle:hover{background:var(--c-surface-sunken)}
section{margin-top:var(--s-3xl)}
h2.sec{font-size:22px;font-weight:700;letter-spacing:-.01em;margin-bottom:var(--s-xs)}
p.sec{color:var(--c-text-secondary);font-size:14px;margin-bottom:var(--s-lg);max-width:70ch}
h3.sub{font-size:13px;font-weight:600;letter-spacing:.06em;text-transform:uppercase;
  color:var(--c-text-muted);margin:var(--s-xl) 0 var(--s-md)}
.grid{display:grid;gap:var(--s-md)}
.g-swatch{grid-template-columns:repeat(auto-fill,minmax(150px,1fr))}
.g-two{grid-template-columns:repeat(auto-fit,minmax(320px,1fr));gap:var(--s-lg)}
.card{background:var(--c-surface);border:1px solid var(--c-border);border-radius:var(--r-lg);
  box-shadow:var(--shadow-sm);overflow:hidden}
.pad{padding:var(--s-lg)}
.sw{border:1px solid var(--c-border);border-radius:var(--r-md);overflow:hidden;background:var(--c-surface)}
.sw .chip{height:56px}
.sw .meta{padding:8px 10px;font-size:11px;line-height:1.35}
.sw .meta b{display:block;font-size:12px;font-weight:600}
.sw .meta code{color:var(--c-text-muted);font-family:ui-monospace,monospace;font-size:11px}
/* boutons */
.btn{display:inline-flex;align-items:center;justify-content:center;gap:8px;
  min-height:var(--touch);padding:0 20px;border-radius:var(--r-md);
  font:600 15px/1 'Manrope',sans-serif;border:1px solid transparent;cursor:pointer;
  transition:background .12s,border-color .12s}
.btn-primary{background:var(--c-accent);color:var(--c-on-accent)}
.btn-primary:hover{background:var(--c-accent-hover)}
.btn-secondary{background:var(--c-surface);color:var(--c-text-primary);border-color:var(--c-border-strong)}
.btn-secondary:hover{background:var(--c-surface-sunken)}
.btn-ghost{background:transparent;color:var(--c-accent)}
.btn-ghost:hover{background:var(--c-accent-subtle)}
.btn-wa{background:var(--c-whatsapp);color:#fff}
.btn-danger{background:transparent;color:var(--c-destructive);border-color:var(--c-destructive)}
.btn-sm{min-height:36px;padding:0 14px;font-size:13px;border-radius:var(--r-sm)}
.btn:disabled{opacity:.45;cursor:not-allowed}
.row{display:flex;gap:var(--s-md);flex-wrap:wrap;align-items:center}
/* badges */
.badge{display:inline-flex;align-items:center;gap:5px;border-radius:var(--r-pill);
  padding:4px 10px;font:600 12px/1.3 'Manrope',sans-serif}
.b-verified{background:var(--c-verified-subtle);color:var(--c-verified)}
.b-pending{background:var(--c-pending-subtle);color:var(--c-pending)}
.b-danger{background:var(--c-destructive-subtle);color:var(--c-destructive)}
.b-sponsored{background:var(--c-pending-subtle);color:var(--c-pending)}
.b-neutral{background:var(--c-surface-sunken);color:var(--c-text-secondary)}
/* champs */
.field{display:block;margin-bottom:var(--s-md)}
.field label{display:block;font-size:13px;font-weight:600;margin-bottom:6px}
.field input,.field select{width:100%;min-height:var(--touch);padding:0 14px;font:400 15px 'Manrope',sans-serif;
  background:var(--c-surface);color:var(--c-text-primary);
  border:1px solid var(--c-border-strong);border-radius:var(--r-md);outline:none}
.field input:focus,.field select:focus{border-color:var(--c-accent);box-shadow:0 0 0 3px var(--c-accent-subtle)}
.field .err{color:var(--c-destructive);font-size:12px;margin-top:5px;font-weight:600}
.field.invalid input{border-color:var(--c-destructive)}
/* carte artisan */
.pcard{display:flex;gap:var(--s-md);padding:var(--s-md);background:var(--c-surface);
  border:1px solid var(--c-border);border-radius:var(--r-lg);box-shadow:var(--shadow-sm)}
.pcard .ava{width:64px;height:64px;border-radius:var(--r-md);flex:none;
  background:linear-gradient(135deg,var(--c-accent),var(--c-accent-hover));
  color:var(--c-on-accent);display:grid;place-items:center;font-weight:800;font-size:22px}
.pcard .body{flex:1;min-width:0}
.pcard .name{font-weight:700;font-size:16px;display:flex;align-items:center;gap:6px;flex-wrap:wrap}
.pcard .meta{color:var(--c-text-secondary);font-size:13px;margin-top:3px}
.pcard .foot{display:flex;align-items:center;gap:var(--s-md);margin-top:10px;flex-wrap:wrap}
.stars{color:var(--c-rating);font-size:14px;letter-spacing:1px}
.price{font-weight:700;font-size:14px}
.price span{font-weight:400;color:var(--c-text-muted);font-size:12px}
/* etats */
.state{text-align:center;padding:var(--s-2xl) var(--s-lg)}
.state .ico{width:52px;height:52px;border-radius:var(--r-pill);margin:0 auto var(--s-md);
  display:grid;place-items:center;font-size:24px;background:var(--c-surface-sunken)}
.state h4{font-size:16px;font-weight:700;margin-bottom:6px}
.state p{color:var(--c-text-secondary);font-size:14px;margin-bottom:var(--s-lg)}
/* skeleton */
.sk{background:var(--c-surface-sunken);border-radius:var(--r-sm);animation:pulse 1.4s ease-in-out infinite}
@keyframes pulse{0%,100%{opacity:1}50%{opacity:.5}}
/* type */
.t-display{font-size:36px;line-height:42px;font-weight:800;letter-spacing:-.02em}
.t-h1{font-size:28px;line-height:34px;font-weight:800;letter-spacing:-.02em}
.t-h2{font-size:22px;line-height:28px;font-weight:700;letter-spacing:-.01em}
.t-h3{font-size:18px;line-height:24px;font-weight:700}
.t-body{font-size:15px;line-height:22px}
.t-small{font-size:13px;line-height:18px;color:var(--c-text-secondary)}
.t-caption{font-size:11px;line-height:14px;font-weight:600;letter-spacing:.04em;
  text-transform:uppercase;color:var(--c-text-muted)}
table{width:100%;border-collapse:collapse;font-size:13px}
th{text-align:start;font-size:11px;text-transform:uppercase;letter-spacing:.05em;
  color:var(--c-text-muted);padding:10px var(--s-md);border-bottom:1px solid var(--c-border);font-weight:600}
td{padding:12px var(--s-md);border-bottom:1px solid var(--c-border)}
tr:last-child td{border-bottom:none}
code.k{font-family:ui-monospace,monospace;font-size:12px;background:var(--c-surface-sunken);
  padding:2px 6px;border-radius:4px}
.note{border-inline-start:3px solid var(--c-accent);background:var(--c-accent-subtle);
  padding:var(--s-md) var(--s-lg);border-radius:0 var(--r-md) var(--r-md) 0;font-size:14px}
.note.warn{border-color:var(--c-pending);background:var(--c-pending-subtle)}
.bar{height:8px;background:var(--c-surface-sunken);border-radius:var(--r-pill);overflow:hidden}
.bar i{display:block;height:100%;background:var(--c-accent);border-radius:var(--r-pill)}
.spacescale{display:flex;align-items:flex-end;gap:var(--s-md);flex-wrap:wrap}
.spacescale div{text-align:center}
.spacescale i{display:block;background:var(--c-accent);border-radius:3px;margin-bottom:6px}
</style>
</head>
<body>
<header class="top">
  <div class="logo">S</div>
  <div>
    <div class="brandname">Sanaya — Design System</div>
    <div class="brandsub">v1.0 · généré depuis <code class="k">packages/design-tokens/tokens.json</code></div>
  </div>
  <div class="spacer"></div>
  <button class="toggle" id="theme">🌙 Sombre</button>
  <button class="toggle" id="dir">ع Arabe / RTL</button>
</header>

<div class="wrap">

<div class="note" style="margin-top:var(--s-xl)">
  <strong>Source unique de vérité.</strong> Toutes les valeurs de cette page proviennent de
  <code class="k">tokens.json</code>. Elles sont générées en TypeScript (preset Tailwind) pour le web
  et en Dart (<code class="k">ThemeExtension</code>) pour Flutter via <code class="k">pnpm tokens:build</code>.
  Ne jamais écrire une couleur ou une taille en dur dans un composant.
</div>

<section>
  <h2 class="sec">1. Couleurs sémantiques</h2>
  <p class="sec">On ne manipule jamais la palette brute dans un composant : on utilise un <em>rôle</em>.
  C'est ce qui rend le basculement clair/sombre gratuit et garantit les contrastes.</p>
  <h3 class="sub">Rôles</h3>
  <div class="grid g-swatch" id="swatches"></div>
</section>

<section>
  <h2 class="sec">2. Typographie</h2>
  <p class="sec">Manrope en latin, Noto Kufi Arabic en arabe — la substitution est automatique selon la locale.
  Aucune taille en dur : passer par l'échelle.</p>
  <div class="card pad">
    <div class="t-caption">caption · 11/14 · 600</div>
    <div class="t-display" style="margin-top:var(--s-md)">Trouve ton artisan</div>
    <div class="t-h1">Plombiers à Sousse</div>
    <div class="t-h2">Artisans vérifiés près de chez toi</div>
    <div class="t-h3">Karim Ben Salah — Plomberie</div>
    <div class="t-body" style="margin-top:var(--s-sm)">Corps de texte 15/22. Le confort de lecture prime sur la densité : la cible utilise majoritairement un téléphone Android d'entrée de gamme, souvent en extérieur.</div>
    <div class="t-small" style="margin-top:var(--s-xs)">Texte secondaire 13/18 — métadonnées, aides à la saisie.</div>
  </div>
</section>

<section>
  <h2 class="sec">3. Espacements &amp; rayons</h2>
  <p class="sec">Échelle en base 4. La cible tactile minimale est de <strong>48 px</strong> — non négociable :
  l'artisan consulte l'application sur un chantier, parfois avec des gants ou un écran sale.</p>
  <div class="card pad">
    <div class="spacescale">
      <div><i style="width:2px;height:2px"></i><code class="k">xxs 2</code></div>
      <div><i style="width:4px;height:4px"></i><code class="k">xs 4</code></div>
      <div><i style="width:8px;height:8px"></i><code class="k">sm 8</code></div>
      <div><i style="width:12px;height:12px"></i><code class="k">md 12</code></div>
      <div><i style="width:16px;height:16px"></i><code class="k">lg 16</code></div>
      <div><i style="width:24px;height:24px"></i><code class="k">xl 24</code></div>
      <div><i style="width:32px;height:32px"></i><code class="k">2xl 32</code></div>
      <div><i style="width:48px;height:48px"></i><code class="k">3xl 48</code></div>
    </div>
    <div class="row" style="margin-top:var(--s-xl)">
      <div style="width:64px;height:44px;background:var(--c-accent-subtle);border:1px solid var(--c-accent);border-radius:var(--r-sm);display:grid;place-items:center;font-size:11px">sm 6</div>
      <div style="width:64px;height:44px;background:var(--c-accent-subtle);border:1px solid var(--c-accent);border-radius:var(--r-md);display:grid;place-items:center;font-size:11px">md 10</div>
      <div style="width:64px;height:44px;background:var(--c-accent-subtle);border:1px solid var(--c-accent);border-radius:var(--r-lg);display:grid;place-items:center;font-size:11px">lg 14</div>
      <div style="width:64px;height:44px;background:var(--c-accent-subtle);border:1px solid var(--c-accent);border-radius:var(--r-xl);display:grid;place-items:center;font-size:11px">xl 20</div>
      <div style="width:88px;height:44px;background:var(--c-accent-subtle);border:1px solid var(--c-accent);border-radius:var(--r-pill);display:grid;place-items:center;font-size:11px">pill</div>
    </div>
  </div>
</section>

<section>
  <h2 class="sec">4. Boutons</h2>
  <p class="sec">Hauteur minimale 48 px partout. « Appeler » est l'action primaire du produit :
  elle ne partage jamais son niveau visuel avec une autre action sur le même écran.</p>
  <div class="card pad">
    <div class="row">
      <button class="btn btn-primary">📞 <span>Appeler l'artisan</span></button>
      <button class="btn btn-wa">💬 <span>WhatsApp</span></button>
      <button class="btn btn-secondary">Voir le profil</button>
      <button class="btn btn-ghost">Ajouter aux favoris</button>
      <button class="btn btn-danger btn-sm">Signaler</button>
      <button class="btn btn-primary" disabled>Publier le profil</button>
    </div>
    <div class="note warn" style="margin-top:var(--s-lg)">
      <strong>Guard-rail.</strong> Tout clic sur « Appeler » ou « WhatsApp » doit poster un
      <code class="k">ContactEvent</code> <em>avant</em> d'ouvrir le lien natif (principe P9).
      Sans cette trace, l'abonnement Pro est invendable.
    </div>
  </div>
</section>

<section>
  <h2 class="sec">5. Badges &amp; statuts</h2>
  <p class="sec">Le badge « Vérifié » atteste de l'identité (CIN), <strong>jamais</strong> du plan payant — voir ADR-002.
  Un emplacement sponsorisé est toujours étiqueté explicitement.</p>
  <div class="card pad">
    <div class="row">
      <span class="badge b-verified">✓ Vérifié</span>
      <span class="badge b-pending">⏳ En attente</span>
      <span class="badge b-danger">✕ Rejeté</span>
      <span class="badge b-sponsored">★ Sponsorisé</span>
      <span class="badge b-neutral">Disponible aujourd'hui</span>
      <span class="badge b-neutral">Sousse · Khezama</span>
    </div>
  </div>
</section>

<section>
  <h2 class="sec">6. Champs de saisie</h2>
  <div class="grid g-two">
    <div class="card pad">
      <label class="field"><span>Numéro de téléphone</span>
        <input type="tel" placeholder="+216 22 123 456" value="+216 22 123 456"></label>
      <label class="field"><span>Service recherché</span>
        <select><option>Plomberie</option><option>Électricité</option><option>Peinture</option><option>Climatisation</option></select></label>
      <div class="field invalid"><label>Code de vérification</label>
        <input value="1234" inputmode="numeric">
        <div class="err">Code incorrect — il vous reste 2 tentatives</div></div>
    </div>
    <div class="card pad">
      <h3 class="sub" style="margin-top:0">Complétude du profil</h3>
      <div class="row" style="justify-content:space-between;margin-bottom:8px">
        <span class="t-small">Profil artisan</span><strong style="font-size:14px">72 %</strong>
      </div>
      <div class="bar"><i style="width:72%"></i></div>
      <p class="t-small" style="margin-top:var(--s-md)">Il manque : 2 photos de réalisations, la zone de couverture, un tarif indicatif.</p>
      <p class="t-small" style="margin-top:var(--s-sm)"><strong>Publication possible à partir de 60 %.</strong></p>
    </div>
  </div>
</section>

<section>
  <h2 class="sec">7. Carte artisan</h2>
  <p class="sec">Le composant le plus vu du produit. Il doit répondre en un coup d'œil à : qui, où, quelle note, à partir de combien, et est-il vérifié.</p>
  <div class="grid g-two">
    <div class="pcard">
      <div class="ava">KB</div>
      <div class="body">
        <div class="name">Karim Ben Salah <span class="badge b-verified">✓ Vérifié</span></div>
        <div class="meta">Plomberie · Sousse, Khezama · 2,4 km</div>
        <div class="foot">
          <span class="stars">★★★★★ <span style="color:var(--c-text-secondary);font-size:13px">4,8 (63)</span></span>
          <span class="price">à partir de 40 <span>TND</span></span>
        </div>
      </div>
    </div>
    <div class="pcard" style="border-color:var(--c-pending)">
      <div class="ava" style="background:linear-gradient(135deg,var(--c-pending),var(--c-accent-hover))">HF</div>
      <div class="body">
        <div class="name">Hédi Ferjani <span class="badge b-sponsored">★ Sponsorisé</span></div>
        <div class="meta">Peinture · Monastir · 6,1 km</div>
        <div class="foot">
          <span class="stars">★★★★☆ <span style="color:var(--c-text-secondary);font-size:13px">4,2 (18)</span></span>
          <span class="price">à partir de 25 <span>TND</span></span>
        </div>
      </div>
    </div>
    <div class="pcard">
      <div class="ava sk" style="background:var(--c-surface-sunken)"></div>
      <div class="body">
        <div class="sk" style="height:16px;width:60%"></div>
        <div class="sk" style="height:12px;width:40%;margin-top:8px"></div>
        <div class="sk" style="height:12px;width:75%;margin-top:12px"></div>
      </div>
    </div>
  </div>
</section>

<section>
  <h2 class="sec">8. États vides, erreur, hors ligne</h2>
  <p class="sec">Trois écrans que l'on oublie systématiquement, et qui décident pourtant de la
  perception de qualité sur un réseau tunisien en 3G. Aucun écran blanc, jamais.</p>
  <div class="grid g-two">
    <div class="card"><div class="state">
      <div class="ico">🔍</div><h4>Aucun artisan trouvé</h4>
      <p>Aucun plombier disponible à Mahdia pour ces filtres.</p>
      <button class="btn btn-secondary btn-sm">Élargir au gouvernorat</button>
    </div></div>
    <div class="card"><div class="state">
      <div class="ico" style="background:var(--c-destructive-subtle)">⚠️</div><h4>Connexion perdue</h4>
      <p>Impossible de charger les résultats. Vérifie ta connexion.</p>
      <button class="btn btn-primary btn-sm">Réessayer</button>
    </div></div>
    <div class="card"><div class="state">
      <div class="ico" style="background:var(--c-pending-subtle)">📡</div><h4>Mode hors ligne</h4>
      <p>Tu consultes des résultats enregistrés. Ils seront actualisés au retour du réseau.</p>
      <button class="btn btn-ghost btn-sm">Compris</button>
    </div></div>
  </div>
</section>

<section>
  <h2 class="sec">9. Tableau back-office</h2>
  <div class="card">
    <table>
      <thead><tr><th>Artisan</th><th>Moyen</th><th>Montant</th><th>Statut</th><th>Action</th></tr></thead>
      <tbody>
        <tr><td>Karim Ben Salah — Pack Pro trimestriel</td><td>Virement bancaire</td><td>135,000 TND</td><td><span class="badge b-pending">À valider</span></td><td><button class="btn btn-ghost btn-sm">Valider →</button></td></tr>
        <tr><td>Ahmed Jlassi — Pack Pro mensuel</td><td>En ligne (Konnect)</td><td>45,000 TND</td><td><span class="badge b-verified">Payé</span></td><td><button class="btn btn-ghost btn-sm">Voir facture</button></td></tr>
        <tr><td>Nizar Chaabane — 25 crédits Boost</td><td>Espèces (agent)</td><td>22,500 TND</td><td><span class="badge b-verified">Payé</span></td><td><button class="btn btn-ghost btn-sm">Voir facture</button></td></tr>
      </tbody>
    </table>
  </div>
</section>

<section>
  <h2 class="sec">10. Règles d'usage — à relire avant chaque PR</h2>
  <div class="card pad">
    <ul style="padding-inline-start:20px;display:grid;gap:10px;font-size:14px">
      <li><strong>Zéro valeur en dur.</strong> <code class="k">AppColors.accent</code> / <code class="k">bg-accent</code>, jamais <code class="k">#3B6FE0</code>.</li>
      <li><strong>Zéro chaîne en dur.</strong> Toute clé ajoutée existe en <code class="k">fr.json</code> <em>et</em> <code class="k">ar.json</code>.</li>
      <li><strong>Propriétés logiques uniquement.</strong> <code class="k">ms-/me-/ps-/pe-</code> sur le web, <code class="k">EdgeInsetsDirectional</code> en Flutter. Jamais <code class="k">ml-</code> ni <code class="k">EdgeInsets.only(left:)</code> — ça casse en arabe.</li>
      <li><strong>Cible tactile ≥ 48 px</strong> sur toute action.</li>
      <li><strong>Badges :</strong> le texte utilise la teinte <code class="k">-500</code> sur le fond <code class="k">-subtle</code>, à 12 px minimum en 600. En dessous, remonter à la teinte <code class="k">-600</code>.</li>
      <li><strong>Trois états obligatoires</strong> par écran de données : <em>loading</em> (skeleton, pas spinner), <em>empty</em>, <em>error</em>.</li>
      <li><strong>Contraste :</strong> AA (4,5:1) pour le texte, 3:1 pour les éléments graphiques — vérifié en clair <em>et</em> en sombre.</li>
    </ul>
  </div>
</section>

</div>

<script>
const SEM = ${JSON.stringify({ light: t.color.semantic.light, dark: t.color.semantic.dark })};
const groups = ${JSON.stringify(swatchGroups)};
function renderSwatches(){
  const theme = document.documentElement.dataset.theme;
  const vals = SEM[theme];
  const host = document.getElementById('swatches');
  host.innerHTML = '';
  for (const [title, keys] of groups){
    const h = document.createElement('h3');
    h.className = 'sub'; h.textContent = title;
    h.style.gridColumn = '1 / -1'; h.style.margin = 'var(--s-lg) 0 0';
    host.appendChild(h);
    for (const k of keys){
      const el = document.createElement('div');
      el.className = 'sw';
      el.innerHTML = '<div class="chip" style="background:'+vals[k]+'"></div>'+
        '<div class="meta"><b>'+k+'</b><code>'+vals[k]+'</code></div>';
      host.appendChild(el);
    }
  }
}
document.getElementById('theme').addEventListener('click', (e)=>{
  const r = document.documentElement;
  const next = r.dataset.theme === 'light' ? 'dark' : 'light';
  r.dataset.theme = next;
  e.target.textContent = next === 'light' ? '🌙 Sombre' : '☀️ Clair';
  renderSwatches();
});
document.getElementById('dir').addEventListener('click', (e)=>{
  const r = document.documentElement;
  const rtl = r.dir === 'rtl';
  r.dir = rtl ? 'ltr' : 'rtl';
  r.lang = rtl ? 'fr' : 'ar';
  e.target.textContent = rtl ? 'ع Arabe / RTL' : 'FR Français / LTR';
});
renderSwatches();
</script>
</body>
</html>
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
    'docs/design-system.html': designSystemHtml,
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
