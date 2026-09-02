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
