import { describe, expect, it } from 'vitest';
import { resolveTokens, buildOutputs } from '../../../tooling/scripts/build-tokens.mjs';

const minimalTokens = () => ({
  $meta: { name: 'test', version: '0.0.0', source: 'fixture', targets: [] },
  color: {
    brand: { 500: '#3B6FE0' },
    neutral: { 0: '#FFFFFF', 900: '#141A24' },
    success: { 500: '#1E7F4C' },
    warning: { 500: '#A9640A' },
    danger: { 500: '#D93B3B' },
    info: { 500: '#2C7BE5' },
    semantic: {
      light: { background: '{color.neutral.0}', accent: '{color.brand.500}' },
      dark: { background: '{color.neutral.900}', accent: '{color.brand.500}' },
    },
  },
  spacing: { md: '12px' },
  radius: { md: '10px' },
  typography: {
    family: { latin: 'Manrope', arabic: 'Noto Kufi Arabic', mono: 'JetBrains Mono' },
    weight: { regular: 400, bold: 700 },
    scale: { body: { size: '15px', lineHeight: '22px', weight: 400, tracking: '0' } },
  },
  elevation: { none: 'none', sm: '0 1px 2px rgba(20, 26, 36, 0.06)' },
  motion: {
    duration: { fast: '120ms', base: '200ms', slow: '320ms' },
    easing: { standard: 'cubic-bezier(0.2, 0, 0, 1)', decelerate: 'cubic-bezier(0, 0, 0, 1)' },
  },
  layout: { touchTarget: '48px', containerMax: '1200px', breakpoint: { sm: '480px' } },
});

describe('resolveTokens', () => {
  it('déréférence un alias imbriqué {color.group.shade}', () => {
    const t = resolveTokens(minimalTokens());
    expect(t.color.semantic.light.accent).toBe('#3B6FE0');
    expect(t.color.semantic.dark.background).toBe('#141A24');
  });

  it('ignore les clés $meta', () => {
    const t = resolveTokens(minimalTokens());
    expect(t.$meta).toBeUndefined();
  });

  it('lève sur un alias introuvable', () => {
    const raw = minimalTokens();
    raw.color.semantic.light.accent = '{color.brand.999}';
    expect(() => resolveTokens(raw)).toThrow(/Alias introuvable/);
  });

  it('lève sur un alias circulaire', () => {
    const raw = minimalTokens();
    raw.color.semantic.light.accent = '{color.semantic.light.background}';
    raw.color.semantic.light.background = '{color.semantic.light.accent}';
    expect(() => resolveTokens(raw)).toThrow(/Alias circulaire/);
  });
});

describe('buildOutputs', () => {
  it('retourne exactement les 7 fichiers générés connus', () => {
    const t = resolveTokens(minimalTokens());
    const outputs = buildOutputs(t);
    expect(Object.keys(outputs).sort()).toEqual(
      [
        'packages/design-tokens/src/colors.ts',
        'packages/design-tokens/src/spacing.ts',
        'packages/design-tokens/src/typography.ts',
        'packages/design-tokens/tailwind-preset.js',
        'apps/mobile/lib/core/theme/app_colors.dart',
        'apps/mobile/lib/core/theme/app_spacing.dart',
        'apps/mobile/lib/core/theme/app_text.dart',
      ].sort(),
    );
  });

  it('génère la palette brute Dart avec conversion hex correcte', () => {
    const t = resolveTokens(minimalTokens());
    const out = buildOutputs(t)['apps/mobile/lib/core/theme/app_colors.dart'];
    expect(out).toContain('static const brand500 = Color(0xFF3B6FE0);');
  });
});
