# DONE — terminé

> Une tâche n'arrive ici que si **toute** la *Definition of Done* est remplie
> (`Code/docs/POLITIQUE-PROJET.md` §5). Pas de « fini à 90 % ».

## Sprint S0 — Cadrage (avant le 2026-08-15)

| ID | Tâche | Qui | PR | Terminé le |
|---|---|---|---|---|
| `DOC-00` | Document de cadrage technique v1.0 (user stories, schéma Prisma complet, index SQL, arborescence) | Oussama | — | 2026-08-12 |
| `DOC-00b` | Étude de marché & stratégie (concurrence, failles, go-to-market Sahel, modèle économique) | Oussama | — | 2026-08-12 |
| `SO-00` | Squelette d'arborescence du monorepo + workflows CI (fichiers vides) | Oussama | — | 2026-08-12 |
| `DES-00` | Maquettes Sanaya — web, mobile, back-office, thèmes clair et sombre | Oussama / Claude Design | — | 2026-08-12 |
| `DOC-01` | **ADR-001** — Mobile en Flutter, contrat d'API REST/OpenAPI | Oussama / Claude | — | 2026-08-15 |
| `DOC-02` | **ADR-002** — Badge « Vérifié » gratuit, fondé sur l'identité | Oussama / Claude | — | 2026-08-15 |
| `DOC-02b` | **ADR-003** — Périmètre S1 mobile-first, `apps/web` reporté en S2 | Oussama / Claude | — | 2026-08-15 |
| `DOC-03` | Politique de projet v1.0 | Claude | — | 2026-08-15 |
| `DOC-04` | Mémoire projet + guard-rails (`CLAUDE.md` racine et par lot) | Claude | — | 2026-08-15 |
| `DOC-05` | Plan MVP semaine 1 découpé en lots et en tâches | Claude | — | 2026-08-15 |
| `DOC-06` | Mise en place des backlogs TODO / DOING / DONE | Claude | — | 2026-08-15 |
| `SO-04a` | Design tokens extraits de la maquette (`tokens.json` → TS + Dart) | Claude | — | 2026-08-15 |

## Sprint S1 — MVP (17/08 → 23/08)

| ID | Tâche | Qui | PR | Terminé le |
|---|---|---|---|---|
| `SO-01` | Monorepo pnpm + Turborepo | Oussama | #59 | 2026-08-17 |
| `SO-02` | Docker Compose : PostgreSQL 16 + Redis 7 | Oussama | #60 | 2026-08-17 |
| `SO-03` | Bootstrap `apps/api` : Fastify 5 + Zod + OpenAPI | Oussama | #61 | 2026-08-17 |
| `SO-04` | Générateur de design tokens : `tokens.json` → TS et Dart | Chayma | #62 | 2026-08-17 |
| `SO-06` | CI GitHub Actions : lint, typecheck, test, contrat, tokens | Oussama | #65 | 2026-08-17 |
| `BE-01` | Schéma Prisma — sous-ensemble MVP (19 modèles) | Oussama | #68 | 2026-08-18 |
| `BE-06` | `phone-tn.ts` — normalisation `+216XXXXXXXX` | Claude | #73 | 2026-08-19 |
| `SO-07` | CODEOWNERS + docs git flow develop/main (ADR-004) + protection des branches | Oussama / Claude | #74 | 2026-08-19 |
| `BE-07` | OTP : génération, hachage argon2, TTL et tentatives (+ logique pure de session, portion BE-09) | Claude | #76 | 2026-08-19 |
| `BE-08` | Adaptateur SMS derrière une interface `SmsProvider` | Claude | #77 | 2026-08-19 |
| `BE-02` | Migration SQL manuelle : contraintes et index essentiels | Oussama | #69 (revue) → atterrit sur `develop` via la PR de réconciliation BE-05 | 2026-08-19 |
| `BE-03` | Seed du référentiel : gouvernorats, délégations du Sahel, catégories FR/AR | Oussama | #70 (revue) → idem | 2026-08-19 |
| `BE-04` | Seed de démonstration : 30 artisans du Sahel | Oussama | #71 (revue) → idem | 2026-08-19 |
| `BE-05` | Repositories — la seule couche qui parle à Prisma, curseur générique | Oussama | #72 (revue) → idem | 2026-08-19 |
| `BE-09` | JWT : access court + refresh rotatif avec détection de rejeu | Claude | #79 | 2026-08-19 |
| `BE-13` | Erreurs normalisées + codes + `requestId` | Claude | #80 | 2026-08-19 |
| `BE-10a` | Fondations auth (schémas Zod, deps) + `GET /v1/auth/me` | Claude | #82 | 2026-08-21 |
| `BE-10b` | `POST /v1/auth/otp/request` — anti-énumération | Claude | #83 | 2026-08-21 |
| `BE-10c` | `POST /v1/auth/otp/verify` — création de compte, tokens | Claude | #84 | 2026-08-21 |
| `BE-10d` | `POST /v1/auth/refresh` + `POST /v1/auth/logout` — rotation, détection de rejeu | Claude | #85 | 2026-08-21 |
| `BE-10` | Routes d'authentification — parcours complet `otp/request`→`otp/verify`→`me`→`refresh`→`logout` (4 PRs atomiques ci-dessus) | Claude | #82–#85 | 2026-08-21 |
| `BE-11` | Rate limiting Redis — OTP (5/h) + primitif contacts (30/j), par téléphone et IP | Claude | #86 | 2026-08-21 |
| `BE-12` | RBAC centralisé `packages/core/policies` (`can()`) + preHandlers `requireAuth`/`requireRole` (`requireAuth` renommé depuis `authenticate`, BE-10a) | Claude | #87 | 2026-08-21 |
| `BE-14a` | Cache-aside Redis générique (`getOrSetCache`), infra sans surface API | Claude | #88 | 2026-08-21 |
| `BE-14b` | `GET /v1/categories` — arbre complet FR/AR, une seule requête, exception P5 documentée | Claude | #89 | 2026-08-21 |
| `BE-14c` | `GET /v1/governorates` + `GET /v1/governorates/:id/delegations` (404 si id inconnu) | Claude | #90 | 2026-08-21 |
| `BE-14d` | Invalidation cache catalogue au seed (`tooling/scripts/flush-catalog-cache.ts`) | Claude | #91 | 2026-08-21 |
| `BE-14` | Catalogue (catégories / gouvernorats / délégations) + cache Redis — parcours complet (4 PRs atomiques ci-dessus) | Claude | #88–#91 | 2026-08-21 |
| `BE-16a` | Recherche — scoring et pagination en mémoire | Claude | #94 | 2026-08-21 |
| `BE-16b` | Recherche — `searchProviderProfiles` (candidats) | Claude | #95 | 2026-08-21 |
| `BE-16c` | `GET /v1/providers/search` — filtres, tri, curseur | Claude | #96 | 2026-08-21 |
| `BE-16` | `GET /providers/search` — filtres + tri + curseur — parcours complet (3 PRs atomiques ci-dessus) | Claude | #94–#96 | 2026-08-21 |
| `BE-17a` | Règles pures fiche publique (publicationStatus, displayPrice, agrégat d'avis) | Claude | #100 | 2026-08-21 |
| `BE-17b` | `findGovernoratesByIds`/`findDelegationsByIds`/`findMediaAssetsByIds` — hydratation par lots | Claude | #101 | 2026-08-21 |
| `BE-17c` | `GET /v1/providers/:slug` — fiche publique, jamais de téléphone (404 si non publié) | Claude | #102 | 2026-08-21 |
| `BE-17` | Fiche artisan publique — sans le numéro de téléphone — parcours complet (3 PRs atomiques ci-dessus) | Claude | #100–#102 | 2026-08-21 |
| `BE-15` | ⭐ Ranking — géo, bayésien (C=8), confiance, complétude, réactivité, plan, pénalités, rotation ±2 % — 🔒 garde-fou ADR-002 vert | Claude | #92 | 2026-08-21 |
| `BE-19a` | Onboarding artisan — `calculateCompletionScore` pure et testée | Claude | #93 | 2026-08-22 |
| `BE-19b` | Onboarding artisan — `POST`/`PATCH /v1/providers/me` | Claude | #97 | 2026-08-22 |
| `BE-19c` | Onboarding artisan — `PUT /v1/providers/me/categories` | Claude | #98 | 2026-08-22 |
| `BE-19d` | Onboarding artisan — `PUT /v1/providers/me/coverage-areas` | Claude | #99 | 2026-08-22 |
| `BE-19` | Onboarding artisan : profil, catégories, zones, complétude — parcours complet (4 PRs atomiques ci-dessus, empilées sur #93) | Claude | #93/#97-#99 | 2026-08-22 |
| `BE-20a` | Médias — `packages/storage` : client R2, presign, pipeline sharp (variantes WebP) | Claude | #106 | 2026-08-22 |
| `BE-20b` | Médias — `POST /v1/media/presign` | Claude | #110 | 2026-08-22 |
| `BE-20c` | Médias — `POST /v1/media/:id/process` (téléchargement + variantes + upload R2) | Claude | #112 | 2026-08-22 |
| `BE-20d` | Médias — `POST`/`DELETE /v1/providers/me/portfolio` (rattachement au profil, quota FREE) | Claude | #113 | 2026-08-22 |
| `BE-20` | Upload de médias : URL pré-signées et variantes WebP — parcours complet (4 PRs atomiques ci-dessus, empilées sur #106) | Claude | #106/#110/#112/#113 | 2026-08-22 |
| `BE-21a` | Contacts — module core dédup + empreinte + message WhatsApp | Claude | #107 | 2026-08-21 |
| `BE-21b` | `findRecentContactEventByFingerprint` + index `sessionHash` | Claude | #108 | 2026-08-21 |
| `BE-21c` | `tryAuth` + `enforceContactEventRateLimit` | Claude | #109 | 2026-08-21 |
| `BE-21d` | `POST /v1/contact-events` — route | Claude | #111 | 2026-08-21 |
| `BE-21` | ⭐ `POST /contact-events` — dédup 30 min, empreinte de session, révélation du numéro, agrégat transactionnel — parcours complet (4 PRs atomiques ci-dessus) | Claude | #107–#109/#111 | 2026-08-21 |
| `BE-22a` | Fenêtre d'éligibilité pour le dépôt d'avis | Claude | #115 | 2026-08-22 |
| `BE-22c` | `findEligibleContactEventForReview` + agrégat concurrency-safe | Claude | #116 | 2026-08-22 |
| `BE-22d` | `POST /v1/providers/:id/reviews` — route | Claude | #117 | 2026-08-22 |
| `BE-22` | `POST /providers/:id/reviews` — rattaché à un `ContactEvent`, agrégats en transaction — parcours complet (3 PRs atomiques ci-dessus) | Claude | #115–#117 | 2026-08-22 |
| `BE-23a` | Vues de profil — `DailyProviderStat` (schéma + migration) + repositories `ProfileView` | Claude | #119 | 2026-08-22 |
| `BE-23b` | Vues de profil — `resolveViewDate` (core, pur) + quota + schéma Zod | Claude | #121 | 2026-08-22 |
| `BE-23c` | Vues de profil — `POST /v1/profile-views` (dédup 24 h, agrégat transactionnel) | Claude | #123 | 2026-08-22 |
| `BE-23` | Traçage des vues de profil et agrégat journalier — parcours complet (3 PRs atomiques ci-dessus, empilées sur #119) | Claude | #119/#121/#123 | 2026-08-22 |
| `BE-25a` | Favoris — assemblage pur de ligne de liste + quota | Claude | #120 | 2026-08-22 |
| `BE-25b` | Favoris — pagination curseur + hydratation par lots | Claude | #122 | 2026-08-22 |
| `BE-25c` | `PUT`/`DELETE`/`GET /v1/favorites` — route + contrat | Claude | #126 | 2026-08-22 |
| `BE-25` | Favoris (`PUT`/`DELETE`/`GET /favorites`) — parcours complet (3 PRs atomiques ci-dessus) | Claude | #120/#122/#126 | 2026-08-22 |
| `BE-24a` | Stats artisan — `DailyProviderStat`/`ContactEvent` : requêtes d'agrégation par plage de dates | Claude | #129 | 2026-08-22 |
| `BE-24b` | Stats artisan — `resolveProviderStatsRange`/`buildProviderStats` (core, purs) + schéma Zod | Claude | #131 | 2026-08-22 |
| `BE-24c` | `GET /v1/providers/me/stats` — route | Claude | #133 | 2026-08-23 |
| `BE-24` | `GET /providers/me/stats` — vues, contacts, ratio, série 30 j — parcours complet (3 PRs atomiques ci-dessus) | Claude | #129/#131/#133 | 2026-08-23 |
| `BE-26a` | Client Dart généré depuis `openapi.json` (`mobile:client`, dart-dio, package autonome) | Claude | #130 | 2026-08-23 |
| `BE-26b` | Types TS générés depuis `openapi.json` (`web:client`, openapi-typescript) | Claude | #132 | 2026-08-23 |
| `BE-26` | ⭐ Contrat : `api:contract` (déjà livré) + `mobile:client` + `web:client` — parcours complet (2 PRs atomiques ci-dessus) | Claude | #130/#132 | 2026-08-23 |
| `BE-18a` | Assemblage pur du nom d'auteur d'avis (`buildReviewAuthorDisplayName`) | Claude | #103 | 2026-08-21 |
| `BE-18b` | `listPublishedReviewsForProvider` — repository paginé par curseur | Claude | #104 | 2026-08-21 |
| `BE-18c` | `GET /v1/providers/:slug/reviews` — route | Claude | #105 | 2026-08-21 |
| `BE-18` | `GET /providers/:slug/reviews` paginé — parcours complet (3 PRs atomiques ci-dessus) | Claude | #103–#105 | 2026-08-21 |
| `BE-24a` | Stats artisan — repository `DailyProviderStat` (totaux + série 30 j) | Claude | #129 | 2026-08-22 |
| `BE-24b` | Stats artisan — assemblage pur (ratio, série sans trou) + schémas Zod | Claude | #131 | 2026-08-23 |
| `BE-24c` | `GET /v1/providers/me/stats` — route | Claude | #133 | 2026-08-23 |
| `BE-24` | `GET /providers/me/stats` — vues, contacts, ratio, série 30 j — parcours complet (3 PRs atomiques ci-dessus) | Claude | #129/#131/#133 | 2026-08-23 |
| `QA-01a` | Harnais Vitest + Postgres jetable pour les tests d'intégration (absorbe `BE-02b`) | Claude | #138/#140 | 2026-08-23 |
| `QA-01b` | Tests d'intégration sur base réelle — `otp/request`, `otp/verify`, `refresh`, `logout` | Claude | #139 | 2026-08-23 |
| `QA-01c` | Tests d'intégration sur base réelle — `POST /contact-events` | Claude | #141 | 2026-08-23 |
| `QA-01d` | Tests d'intégration sur base réelle — `POST /providers/:id/reviews` (🔒 trigger `prevent_self_review` + concurrence `ratingAvg`) | Claude | #142 | 2026-08-23 |
| `QA-01e` | Tests d'intégration sur base réelle — onboarding `providers/me*` (`POST`/`PATCH /providers/me`, catégories, zones) | Claude | #143 | 2026-08-23 |
| `QA-01` | Tests d'intégration API sur base jetable (routes qui écrivent) — parcours complet (5 PRs atomiques ci-dessus) | Claude | #138/#140/#139/#141–#143 | 2026-08-23 |

---

## Compteur du sprint S1

| Métrique | Valeur |
|---|---|
| Tâches 🔴 P0 planifiées | 43 |
| Tâches 🔴 P0 terminées | 20 *(+ BE-18, backfill bookkeeping du 2026-08-23)* |
| Tâches 🟠 P1 terminées | 1 / 7 *(l'amortisseur : 18 h — BE-24 mergée, backfill bookkeeping du 2026-08-23)* |
| Heures-homme 🔴 P0 estimées / consommées | 109 h / 3 h *(capacité 112 h)* |

> Mettre à jour ce compteur **au daily**. C'est le seul indicateur qui dira mercredi si le périmètre
> tient — et mercredi est le dernier jour où couper coûte encore peu.
