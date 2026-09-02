import { describe, expect, it } from 'vitest';
import { resolveTokens, buildOutputs } from '../../../tooling/scripts/build-tokens.mjs';
import { minimalTokens } from './fixtures.mjs';

const withTypographyFixture = () => {
  const raw = minimalTokens();
  raw.typography.weight = { regular: 400, bold: 700 };
  raw.typography.scale = {
    display: { size: '36px', lineHeight: '42px', weight: 800, tracking: '-0.02em' },
    subtitle: { size: '16px', lineHeight: '24px', weight: 600, tracking: '0' },
  };
  raw.layout.breakpoint = { sm: '480px', md: '768px', lg: '1024px', xl: '1280px' };
  return raw;
};

describe('Typographie + layout Dart (FM-15f)', () => {
  it("exporte letterSpacing par palier, converti de l'unité em vers des px absolus", () => {
    const out = buildOutputs(resolveTokens(withTypographyFixture()))[
      'apps/mobile/lib/core/theme/app_text.dart'
    ];
    expect(out).toContain('letterSpacing: -0.720,');
    expect(out).toContain('letterSpacing: 0.000,');
  });

  it('ajoute le palier subtitle (16px) entre body et h3', () => {
    const out = buildOutputs(resolveTokens(withTypographyFixture()))[
      'apps/mobile/lib/core/theme/app_text.dart'
    ];
    expect(out).toContain('static TextStyle subtitle(Locale locale)');
    expect(out).toContain('fontSize: 16.0,');
  });

  it('exporte AppFontWeight à partir de typography.weight', () => {
    const out = buildOutputs(resolveTokens(withTypographyFixture()))[
      'apps/mobile/lib/core/theme/app_text.dart'
    ];
    expect(out).toContain('abstract final class AppFontWeight {');
    expect(out).toContain('static const regular = FontWeight.w400;');
    expect(out).toContain('static const bold = FontWeight.w700;');
  });

  it('exporte layout.breakpoint dans AppLayout', () => {
    const out = buildOutputs(resolveTokens(withTypographyFixture()))[
      'apps/mobile/lib/core/theme/app_spacing.dart'
    ];
    expect(out).toContain('static const double breakpointSm = 480.0;');
    expect(out).toContain('static const double breakpointMd = 768.0;');
    expect(out).toContain('static const double breakpointLg = 1024.0;');
    expect(out).toContain('static const double breakpointXl = 1280.0;');
  });
});
