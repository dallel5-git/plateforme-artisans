import { describe, expect, it } from 'vitest';
import { resolveTokens, buildOutputs } from '../../../tooling/scripts/build-tokens.mjs';
import { minimalTokens } from './fixtures.mjs';

describe('AppElevation + AppMotion (FM-15b, régression SO-08)', () => {
  it('génère les deux nouveaux fichiers dans outputs', () => {
    const outputs = buildOutputs(resolveTokens(minimalTokens()));
    expect(Object.keys(outputs)).toContain('apps/mobile/lib/core/theme/app_elevation.dart');
    expect(Object.keys(outputs)).toContain('apps/mobile/lib/core/theme/app_motion.dart');
  });

  it('AppElevation.light et .dark ne sont pas identiques (régression : une seule série non thématisée)', () => {
    const outputs = buildOutputs(resolveTokens(minimalTokens()));
    const out = outputs['apps/mobile/lib/core/theme/app_elevation.dart'];
    const lightBlock = out.slice(
      out.indexOf('static const light'),
      out.indexOf('static const dark'),
    );
    const darkBlock = out.slice(out.indexOf('static const dark'));
    expect(lightBlock).toContain('Color.fromRGBO(20, 26, 36, 0.06)');
    expect(darkBlock).toContain('Color.fromRGBO(0, 0, 0, 0.32)');
    expect(lightBlock).not.toBe(darkBlock);
  });

  it('AppElevation.copyWith()/lerp() honorent le contrat ThemeExtension', () => {
    const out = buildOutputs(resolveTokens(minimalTokens()))[
      'apps/mobile/lib/core/theme/app_elevation.dart'
    ];
    expect(out).toContain('AppElevation copyWith({');
    expect(out).toContain('BoxShadow.lerpList(this.sm, other.sm, t)');
  });

  it('AppMotion expose les durées et easings attendus', () => {
    const out = buildOutputs(resolveTokens(minimalTokens()))[
      'apps/mobile/lib/core/theme/app_motion.dart'
    ];
    expect(out).toContain('static const durationFast = Duration(milliseconds: 120);');
    expect(out).toContain('static const durationBase = Duration(milliseconds: 200);');
    expect(out).toContain('static const durationSlow = Duration(milliseconds: 320);');
    expect(out).toContain('static const easingStandard = Cubic(0.2, 0, 0, 1);');
    expect(out).toContain('static const easingDecelerate = Cubic(0, 0, 0, 1);');
  });
});
