import { describe, expect, it } from 'vitest';
import { resolveTokens, buildOutputs } from '../../../tooling/scripts/build-tokens.mjs';
import { minimalTokens } from './fixtures.mjs';

describe('AppIconSize (FM-15c)', () => {
  it('AppIconSize.xs/sm/md/lg/xl sont générés en Dart avec les bonnes valeurs', () => {
    const t = resolveTokens(minimalTokens());
    const out = buildOutputs(t)['apps/mobile/lib/core/theme/app_spacing.dart'];
    expect(out).toContain('abstract final class AppIconSize {');
    expect(out).toContain('static const double xs = 12.0;');
    expect(out).toContain('static const double sm = 16.0;');
    expect(out).toContain('static const double md = 20.0;');
    expect(out).toContain('static const double lg = 24.0;');
    expect(out).toContain('static const double xl = 32.0;');
  });

  it('iconSize est exporté côté TypeScript (spacing.ts)', () => {
    const t = resolveTokens(minimalTokens());
    const out = buildOutputs(t)['packages/design-tokens/src/spacing.ts'];
    expect(out).toContain('export const iconSize');
    expect(out).toContain('"xs": "12px"');
  });
});
