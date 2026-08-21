// Translittère les diacritiques latins (é, è, ç…) puis réduit à `[a-z0-9-]`. Un `businessName`
// entièrement en arabe (P7 : bilingue dès le jour 1) n'a pas d'équivalent latin ici — il retombe
// sur `FALLBACK_SLUG_BASE`, et c'est la boucle d'unicité du repository (`generateUniqueProviderSlug`)
// qui le rend distinct (`artisan-2`, `artisan-3`…). Pas de translittération arabe→latin dans ce
// ticket : hors périmètre BE-19, à traiter si le besoin est confirmé.
const FALLBACK_SLUG_BASE = 'artisan';

// Plage Unicode des diacritiques combinants (̀-ͯ), isolés par `normalize('NFD')`.
const COMBINING_DIACRITICS = /[̀-ͯ]/g;

export function slugify(text: string): string {
  const base = text
    .normalize('NFD')
    .replace(COMBINING_DIACRITICS, '')
    .toLowerCase()
    .trim()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '');

  return base.length > 0 ? base : FALLBACK_SLUG_BASE;
}
