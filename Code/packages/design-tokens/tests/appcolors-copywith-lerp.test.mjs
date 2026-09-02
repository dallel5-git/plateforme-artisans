import { describe, expect, it } from 'vitest';
import { resolveTokens, buildOutputs } from '../../../tooling/scripts/build-tokens.mjs';
import { minimalTokens } from './fixtures.mjs';

describe('AppColors.copyWith()/lerp() (régression #214/SO-08)', () => {
  const dartColors = () =>
    buildOutputs(resolveTokens(minimalTokens()))['apps/mobile/lib/core/theme/app_colors.dart'];

  it('copyWith() a un paramètre nullable par rôle sémantique, pas un no-op', () => {
    const out = dartColors();
    expect(out).toContain('AppColors copyWith({');
    expect(out).toContain('Color? background,');
    expect(out).toContain('Color? accent,');
    expect(out).toContain('background: background ?? this.background,');
    expect(out).not.toMatch(/AppColors copyWith\(\)\s*=>\s*this;/);
  });

  it('lerp() interpole chaque rôle avec Color.lerp(), pas un saut binaire', () => {
    const out = dartColors();
    expect(out).toContain('Color.lerp(this.background, other.background, t)!');
    expect(out).toContain('Color.lerp(this.accent, other.accent, t)!');
    expect(out).not.toMatch(/t < 0\.5 \? this : other/);
  });

  it("lerp() retourne this si other n'est pas un AppColors (contrat ThemeExtension)", () => {
    const out = dartColors();
    expect(out).toContain('if (other is! AppColors) return this;');
  });
});
