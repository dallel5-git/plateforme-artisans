import base from '@repo/eslint-config/base.js';

// BE-05 : packages/db est la seule exception à l'interdiction d'importer @prisma/client
// (c'est tout son rôle, P1/P4) — on ne garde que la règle P1 sur les imports internes
// @repo/*/src/**, sans la restriction @prisma/client de base.js.
export default [
  ...base,
  {
    rules: {
      'no-restricted-imports': [
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
      ],
    },
  },
];
