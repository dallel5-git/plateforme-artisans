// ⚠️ FICHIER GÉNÉRÉ — NE PAS ÉDITER À LA MAIN.
// Source : packages/design-tokens/tokens.json
// Régénérer : pnpm tokens:build

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
