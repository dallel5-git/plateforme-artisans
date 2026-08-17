import js from '@eslint/js';
import prettier from 'eslint-config-prettier';
import tseslint from 'typescript-eslint';

/**
 * Invariant P1 (CLAUDE.md §2) : un module métier n'est consommé que par son
 * point d'entrée public (@repo/<nom>). Un import qui plonge dans src/*
 * — et en particulier dans un dossier internal/ — contourne cette frontière.
 */
const noRestrictedInternalImports = [
  'error',
  {
    patterns: [
      {
        group: ['@repo/*/src/**/internal/*', '@repo/*/src/**/internal/**'],
        message:
          "Un dossier internal/ est privé à son module. Importez depuis le point d'entrée public du package (@repo/<nom>), jamais un chemin interne.",
      },
      {
        group: ['@repo/*/src/**'],
        message:
          "Import interne interdit. Un module ne consomme un autre package que par son point d'entrée public (@repo/<nom>), jamais par un chemin src/* profond.",
      },
    ],
  },
];

export default tseslint.config(js.configs.recommended, ...tseslint.configs.recommended, prettier, {
  rules: {
    'no-restricted-imports': noRestrictedInternalImports,
  },
});
