# Mémoire locale — Lot WEB (`apps/web`, `apps/admin`)

> À placer dans `Code/apps/web/CLAUDE.md`. Complète le `CLAUDE.md` racine.

## Rôle

`apps/web` n'est **pas un miroir du mobile**. C'est le canal d'acquisition SEO (principe P6) : c'est
lui qui remplace les groupes Facebook dans les résultats Google. `apps/admin` est le back-office,
volontairement séparé (surface d'attaque, bundle, indexation).

## Stack

Next.js 15 (App Router) · React 19 · Tailwind CSS v4 + preset `@repo/design-tokens` · shadcn/ui
(Radix) · TanStack Query v5 · `openapi-fetch` typé depuis `contracts/openapi.json` · React Hook Form
+ `@hookform/resolvers/zod` (schémas de `@repo/validators`) · i18next FR/AR.

## Règles de rendu — non négociables

| Surface | Rendu | Pourquoi |
|---|---|---|
| `/[locale]/[gouvernorat]/[service]` | **SSG + ISR** (`revalidate: 3600`) | C'est la page qui doit être indexée. Jamais de CSR. |
| Fiche artisan `/[locale]/artisan/[slug]` | **SSG + ISR** | JSON-LD `LocalBusiness` + `AggregateRating` obligatoire. |
| Recherche avec filtres | Server Component + `searchParams` | Les filtres sont dans l'URL — partageable et indexable. |
| Espace connecté | Client Component + TanStack Query | Pas d'intérêt SEO. |

- `sitemap.xml` et `robots.txt` **dynamiques**, générés depuis la base (gouvernorats × catégories publiés).
- Balises `hreflang` FR/AR sur chaque page publique.
- Core Web Vitals : LCP < 2,5 s **sur 3G simulé**, pas sur ta fibre. Tester avec throttling.

## i18n & RTL (P7)

- Aucune chaîne en dur dans un composant. Tout via `t('cle.explicite')`.
- Les catalogues vivent dans `packages/i18n/src/locales/{fr,ar}.json` et sont **partagés avec le mobile**.
- `dir="rtl"` piloté par la locale au niveau du `<html>`, pas par composant.
- Utiliser les propriétés logiques CSS : `ms-4`/`me-4`, `ps-2`/`pe-2` — **jamais** `ml-4`/`pl-2`, qui cassent en arabe.
- Nombres et dates via `Intl` avec la locale active. TND formaté par `@repo/utils/currency`.

## Performance (P5 — low-bandwidth-first)

- `next/image` obligatoire, `sizes` renseigné, format WebP/AVIF, `priority` uniquement sur le LCP.
- Pagination par curseur (`useInfiniteQuery`), jamais de « charger tout ».
- Vérifier le poids du bundle avant merge : une page publique > 200 kB JS est refusée en review.
- Aucune police auto-hébergée non sous-ensemblée. Manrope (latin) + Noto Kufi Arabic (arabe), `font-display: swap`.

## Sécurité

- Session : cookie `httpOnly` + `Secure` + `SameSite=Lax`. Le refresh token n'est **jamais** en `localStorage`.
- Le numéro de téléphone d'un artisan n'apparaît **jamais** dans le HTML rendu (P8/scraping). Il est révélé par un appel API tracé au clic, avec rate-limit.
- Aucun contrôle d'autorisation uniquement côté client : le middleware Next protège l'UX, l'API protège les données.
- `apps/admin` : `X-Robots-Tag: noindex`, CSP stricte, 2FA obligatoire.

## Checklist avant PR web

- [ ] `pnpm typecheck && pnpm lint && pnpm test` verts
- [ ] Client API régénéré si le contrat a bougé (`pnpm web:client`)
- [ ] Aucune chaîne en dur ; clés ajoutées **dans `fr.json` ET `ar.json`**
- [ ] Rendu vérifié en `dir="rtl"` (les cartes et les icônes de chevron sont les premiers à casser)
- [ ] Aucune propriété directionnelle (`ml-`, `pr-`, `left-`, `text-left`)
- [ ] États `loading` / `empty` / `error` implémentés — pas seulement le cas passant
- [ ] Contraste AA vérifié en thème clair **et** sombre
- [ ] Lighthouse ≥ 90 en Performance et SEO sur une page publique
