export const SUPPORTED_LOCALES = ['fr', 'ar'] as const;
export type Locale = (typeof SUPPORTED_LOCALES)[number];

export const DEFAULT_LOCALE: Locale = 'fr';

// Un namespace = un fichier de catalogue par langue (locales/<locale>/<namespace>.json).
// Ajouter un namespace ici, créer les deux fichiers correspondants (fr/ et ar/) — `pnpm i18n:check`
// (tooling/scripts/i18n-check.mjs) échoue si l'un des deux manque.
export const NAMESPACES = ['common', 'search', 'provider', 'billing', 'legal', 'errors'] as const;
export type Namespace = (typeof NAMESPACES)[number];
