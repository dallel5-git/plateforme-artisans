# Mémoire locale — Lot BACKEND (`apps/api`, `apps/worker`, `packages/{db,core,api,auth,validators,storage}`)

> À placer dans `Code/apps/api/CLAUDE.md`. Complète le `CLAUDE.md` racine — il ne le remplace pas.

## Rôle de cette couche

`apps/api` est **du transport, rien d'autre**. Fastify 5 + Zod + génération OpenAPI.
Toute la valeur métier vit dans `packages/core`, qui ne connaît ni HTTP ni Prisma-request-scope.

```
route (Zod in/out)  →  service de core  →  repository de db  →  Prisma
   validation             règles             requêtes            SQL
```

## Ordre de construction d'un module (à respecter, il évite 80 % des reprises)

1. **Schéma Zod** dans `packages/validators/src/<module>.ts` — entrée **et** sortie.
2. **Test unitaire** de la règle dans `packages/core/tests/<module>.test.ts` (Vitest, sans base).
3. **Service** dans `packages/core/src/<module>/` — fonctions pures, dépendances injectées.
4. **Repository** dans `packages/db/src/repositories/` — la seule couche qui parle à Prisma.
5. **Route** dans `apps/api/src/routes/<module>.ts` — 15 lignes max par handler.
6. `pnpm api:contract` → commiter `contracts/openapi.json` **dans la même PR**.

## Checklist avant d'ouvrir une PR backend

- [ ] `pnpm typecheck && pnpm lint && pnpm test` verts
- [ ] `pnpm api:contract --check` vert (contrat à jour)
- [ ] Chaque nouvelle route a : un schéma d'entrée, un schéma de sortie, un `preHandler` d'auth **ou** un commentaire `// public: <raison>`
- [ ] Chaque route qui écrit a un rate-limit explicite
- [ ] Aucun `console.log` — utiliser le logger Fastify (`request.log`)
- [ ] Aucune donnée sensible dans un log (P8) : téléphone, OTP, CIN, token
- [ ] Migration Prisma nommée `<date>_<verbe>_<objet>` et **jamais** une migration mergée modifiée
- [ ] Pagination par curseur sur toute liste (P5)
- [ ] `select` Prisma explicite — jamais l'entité complète renvoyée au client

## Pièges spécifiques à ce domaine

| Piège | Règle |
|---|---|
| Numéro de téléphone | Normaliser `+216XXXXXXXX` **avant** l'écriture ET avant la recherche d'unicité. Le format saisi varie (`22 123 456`, `0022...`, `+216...`). |
| Montants | Entiers en **millimes**. Jamais de `Float`, jamais de `parseFloat`. Prisma : `Int`. |
| OTP | Hash (bcrypt/argon2) + TTL 5 min + 3 tentatives + rate-limit **par téléphone ET par IP**. Ne jamais renvoyer si le numéro existe déjà (énumération de comptes). |
| Recherche texte FR/AR | `unaccent(lower(...))` + `pg_trgm`. Les noms arabes translittérés doivent matcher (`سامي` / `Sami`). Slug via `packages/utils/slugify.ts`. |
| Ranking | Poids stockés dans `AppSetting`, **jamais en dur**. Note bayésienne `(C·m + Σnotes)/(C+n)`, C≈8. Rotation équitable ±2 % à score égal. |
| Boosts | N'entrent **pas** dans `rankingScore`. Emplacements séparés en tête de liste, flag `sponsored: true` dans la réponse. |
| Avis | Un avis exige un `ContactEvent` correspondant. Trigger SQL `prevent_self_review` en filet de sécurité. |
| Agrégats | `ratingAvg`/`ratingCount` sont dénormalisés sur `ProviderProfile`. Toute écriture d'avis les recalcule **dans la même transaction**. |
| Soft delete | `User.deletedAt` + anonymisation. Tous les `findMany` publics filtrent `deletedAt: null`. |
| Transactions | Débit de crédits + activation de boost = **une seule** `prisma.$transaction`. Idem paiement validé + prolongation d'abonnement. |

## Modules et leur frontière

`auth` · `catalog` (catégories, géo) · `providers` · `search` · `contacts` · `reviews` · `billing` ·
`ads` · `moderation` · `analytics`

Un module n'importe d'un autre que son `index.ts`. Règle ESLint `no-restricted-imports` active :
`@repo/core/src/*/internal/*` et les chemins profonds croisés sont **interdits**. Sans cette
contrainte automatisée, la modularité se dégrade en trois mois (cadrage §3.3-4).
