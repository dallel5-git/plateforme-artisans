import { describe, expect, it } from 'vitest';
import { resolveTokens, buildOutputs } from '../../../tooling/scripts/build-tokens.mjs';
import { minimalTokens } from './fixtures.mjs';

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

  it('préserve les tableaux (ex. couches elevation), ne les convertit pas en objet', () => {
    const t = resolveTokens(minimalTokens());
    expect(Array.isArray(t.elevation.light.sm)).toBe(true);
    expect(t.elevation.light.sm[0].color).toBe('rgba(20, 26, 36, 0.06)');
    expect(Array.isArray(t.elevation.light.none)).toBe(true);
    expect(t.elevation.light.none).toHaveLength(0);
  });
});

describe('buildOutputs', () => {
  it('retourne exactement les 9 fichiers générés connus', () => {
    const t = resolveTokens(minimalTokens());
    const outputs = buildOutputs(t);
    expect(Object.keys(outputs).sort()).toEqual(
      [
        'packages/design-tokens/src/colors.ts',
        'packages/design-tokens/src/spacing.ts',
        'packages/design-tokens/src/typography.ts',
        'packages/design-tokens/tailwind-preset.js',
        'apps/mobile/lib/core/theme/app_colors.dart',
        'apps/mobile/lib/core/theme/app_elevation.dart',
        'apps/mobile/lib/core/theme/app_motion.dart',
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
