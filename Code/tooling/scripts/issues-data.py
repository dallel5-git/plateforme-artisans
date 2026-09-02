#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Sanaya — source unique des issues GitHub du sprint S1 (+ épiques S2-S6).

    python3 tooling/scripts/issues-data.py > tooling/scripts/github-issues.json

Le fichier JSON produit est consommé par `gh-seed-issues.sh`.
Ne pas éditer le JSON à la main : éditer ce fichier et régénérer.

Cohérence : les IDs (SO-xx, BE-xx, FM-xx, FW-xx, QA-xx) sont ceux de
backlog/TODO.md. Un ID absent du backlog est un bug de ce fichier.
"""
import json, sys

OUSSAMA, CHAYMA, BINOME = "oussama", "chayma", "binome"

M0 = "M0 — Socle & Contrat"
M1 = "M1 — Backend Core API"
M2 = "M2 — App Mobile MVP"
M3 = "M3 — Web SEO & Acquisition"
M4 = "M4 — Confiance & Back-office"
M5 = "M5 — Monétisation"
M6 = "M6 — Différenciation & Lancement"
M7 = "M7 — Refonte design mobile complète"

# Label technique servant UNIQUEMENT à scoper `gh-seed-issues.sh` sur ce lot
# (ONLY=refonte-design-mobile) sans toucher aux ~90 issues déjà créées pour
# S1-S6. Ne pas réutiliser pour autre chose.
REFONTE = "refonte-design-mobile"


def size(h):
    return "size:S" if h <= 2 else ("size:M" if h <= 4 else "size:L")


def I(id, title, ms, labels, who, est, deps, context, scope, out, accept, refs, guard=None):
    return dict(id=id, title=f"[{id}] {title}", milestone=ms,
                labels=labels + [size(est)], assignee=who, est=est, deps=deps,
                context=context, scope=scope, out=out, accept=accept,
                refs=refs, guard=guard or [])


ISSUES = []
A = ISSUES.append

# =============================================================================
# M0 — SOCLE (J1)
# =============================================================================
A(I("SO-01", "Initialiser le monorepo pnpm + Turborepo", M0,
    ["type:chore", "lot:socle", "prio:P0", "sprint:S1"], OUSSAMA, 2, [],
    "Tout le reste en dépend. Un monorepo mal câblé au jour 1 se paie en frictions "
    "quotidiennes pendant tout le projet (résolutions de dépendances, tâches qui ne "
    "se cachent pas, configs dupliquées).",
    ["`pnpm-workspace.yaml` : `apps/*`, `packages/*`",
     "`turbo.json` : pipelines `build`, `lint`, `typecheck`, `test` avec dépendances explicites",
     "`packages/tsconfig` : `base.json`, `node.json`, `nextjs.json`",
     "`packages/eslint-config` : `base.js` + règle `no-restricted-imports` inter-modules",
     "Prettier + `.editorconfig` à la racine"],
    ["La configuration Flutter (`analysis_options.yaml`) — elle arrive avec FM-01"],
    ["`pnpm install` réussit sur un clone propre",
     "`pnpm lint` et `pnpm typecheck` passent sur un dépôt encore vide de métier",
     "Un import de `@repo/core/src/*/internal/*` est **refusé par ESLint**"],
    "US-T-01 · cadrage §4 · CLAUDE.md §2 (P1)"))

A(I("SO-02", "Docker Compose : PostgreSQL 16 + Redis 7", M0,
    ["type:chore", "lot:socle", "prio:P0", "sprint:S1"], CHAYMA, 1.5, [],
    "L'environnement de développement doit être reproductible en une commande. "
    "Trois extensions PostgreSQL sont nécessaires et faciles à oublier : sans elles, "
    "les migrations de BE-02 échoueront de façon obscure.",
    ["`tooling/docker/docker-compose.dev.yml` : PostgreSQL 16 + Redis 7",
     "`tooling/docker/postgres/init.sql` : `CREATE EXTENSION` pour `unaccent`, `pg_trgm`, `postgis`",
     "Volumes nommés pour la persistance",
     "Scripts `db:up`, `db:down`, `db:reset` dans le `package.json` racine"],
    [],
    ["`pnpm db:up` démarre les deux services et ils répondent",
     "`SELECT extname FROM pg_extension;` retourne bien `unaccent`, `pg_trgm`, `postgis`",
     "`pnpm db:reset` remet une base propre sans intervention manuelle"],
    "US-T-01 · cadrage §2.1"))

A(I("SO-03", "Bootstrap apps/api : Fastify 5 + Zod + OpenAPI", M0,
    ["type:feat", "lot:socle", "lot:backend", "prio:P0", "sprint:S1", "contrat-api"], OUSSAMA, 2.5, ["SO-01"],
    "C'est le remplaçant du serveur tRPC du cadrage (voir ADR-001). Le point clé est "
    "`fastify-type-provider-zod` : il fait que les schémas Zod valident les entrées **et** "
    "produisent le document OpenAPI, sans qu'on écrive quoi que ce soit deux fois.",
    ["`apps/api/src/server.ts` : bootstrap + arrêt propre (graceful shutdown)",
     "Plugins : `@fastify/cors`, `@fastify/helmet`, `fastify-type-provider-zod`, `@fastify/swagger` + UI",
     "Logger `pino` avec `requestId` injecté dans chaque log et chaque réponse",
     "`GET /v1/health` : vérifie réellement PostgreSQL et Redis, pas juste `{ok:true}`",
     "Script `api:contract` qui écrit `contracts/openapi.json`"],
    ["Les routes métier — elles arrivent au fil de M1"],
    ["`GET /v1/health` renvoie `200 {\"status\":\"ok\",\"db\":\"up\",\"redis\":\"up\"}`",
     "Couper PostgreSQL fait passer `/v1/health` en `503` (et non en 200 mensonger)",
     "`GET /docs` affiche le Swagger",
     "`pnpm api:contract` écrit un `openapi.json` valide"],
    "ADR-001 §3.1 · US-T-01",
    ["`contracts/openapi.json` est **généré** — jamais édité à la main"]))

A(I("SO-04", "Générateur de design tokens : un JSON → TypeScript et Dart", M0,
    ["type:chore", "lot:design", "prio:P0", "sprint:S1"], CHAYMA, 2, ["SO-01"],
    "Avec Flutter, le web et le mobile ne peuvent plus partager de code de style. "
    "Le seul moyen de garder une identité visuelle cohérente est de générer les deux "
    "cibles depuis une source unique. Sans ça, les couleurs divergent en trois semaines.",
    ["`packages/design-tokens/tokens.json` — la source unique (déjà extrait de la maquette)",
     "`tooling/scripts/build-tokens.mjs` — résout les alias `{color.brand.500}` et écrit les cibles",
     "Cibles TS : `colors.ts`, `spacing.ts`, `typography.ts`, `tailwind-preset.js`",
     "Cibles Dart : `app_colors.dart` (`ThemeExtension`), `app_spacing.dart`, `app_text.dart`",
     "Mode `--check` pour la CI"],
    ["Les composants eux-mêmes (FM-04)"],
    ["`pnpm tokens:build` régénère les 7 fichiers",
     "`pnpm tokens:build --check` **échoue** si un fichier généré est périmé",
     "Les fichiers générés portent un bandeau « NE PAS ÉDITER À LA MAIN »",
     "Le thème sombre est présent dans les deux cibles"],
    "ADR-001 §3.3 · `Code/docs/design-system.html`"))

A(I("SO-05", "Squelette i18n FR/AR + contrôle de parité des clés", M0,
    ["type:chore", "lot:design", "domaine:catalog", "prio:P0", "sprint:S1", "rtl-ar"], CHAYMA, 1, ["SO-01"],
    "Le bilingue n'est pas rétrofittable proprement (principe P7). Le piège classique : "
    "on ajoute une clé en français, on oublie l'arabe, et on découvre les trous trois "
    "semaines plus tard sur un écran de démo. Le contrôle de parité rend l'oubli impossible.",
    ["`packages/i18n/src/locales/fr.json` et `ar.json`",
     "Helpers de formatage : dates, nombres, TND, direction RTL",
     "Script `i18n:check` : compare récursivement les jeux de clés",
     "Branchement du script dans la CI"],
    ["Le contenu des traductions — il se remplit au fil des écrans"],
    ["Ajouter une clé dans `fr.json` sans son équivalent arabe fait **échouer** `pnpm i18n:check`",
     "Le message d'erreur liste les clés manquantes, par fichier"],
    "US-T-04 · CLAUDE.md §2 (P7)"))

A(I("SO-06", "CI GitHub Actions : lint, typecheck, test, contrat", M0,
    ["type:chore", "lot:socle", "prio:P0", "sprint:S1"], OUSSAMA, 2, ["SO-01"],
    "La CI est ce qui rend la règle « `main` est toujours déployable » réelle plutôt que "
    "déclarative. Elle doit rester sous 5 minutes, sinon elle sera contournée.",
    ["`.github/workflows/ci.yml` : `lint`, `typecheck`, `test`, `api:contract --check`, `tokens:build --check`, `i18n:check`",
     "Services PostgreSQL + Redis pour les tests d'intégration",
     "Cache Turborepo et cache du store pnpm",
     "`flutter analyze` + `dart format --set-exit-if-changed` (activés à partir de FM-01)"],
    ["Le déploiement — voir OPS-01 (S2)"],
    ["La CI est verte sur une PR blanche en **moins de 5 minutes**",
     "Un `openapi.json` périmé fait **échouer** la CI",
     "Une clé i18n manquante en arabe fait **échouer** la CI"],
    "US-T-05"))

A(I("SO-07", "Protéger main, templates de PR/issues, CODEOWNERS", M0,
    ["type:chore", "lot:socle", "prio:P0", "sprint:S1"], OUSSAMA, 0.5, ["SO-06"],
    "À deux développeurs, la tentation de pousser directement sur `main` est forte et "
    "le coût invisible — jusqu'au jour où une régression passe sans relecture. La "
    "protection de branche transforme une bonne intention en contrainte.",
    ["Règle de protection sur `main` : push direct interdit, 1 approbation, CI verte, squash-merge",
     "`.github/pull_request_template.md`",
     "`.github/ISSUE_TEMPLATE/` : tâche, bug, décision",
     "`.github/CODEOWNERS` — **remplacer `@CHAYMA-HANDLE` par le vrai identifiant**",
     "`.gitattributes` pour les fichiers générés",
     "`.env.example` avec des valeurs factices"],
    [],
    ["Un `git push origin main` est **refusé**, y compris pour le lead",
     "Ouvrir une PR pré-remplit la checklist",
     "Une PR touchant `packages/db/` demande automatiquement la revue de Chayma"],
    "POLITIQUE-PROJET.md §3.3 et §4"))

# =============================================================================
# M1 — BACKEND (J2 → J4 matin)
# =============================================================================
A(I("BE-01", "Schéma Prisma — sous-ensemble MVP (19 modèles)", M1,
    ["type:feat", "lot:backend", "prio:P0", "sprint:S1"], CHAYMA, 3, ["SO-02"],
    "Le schéma est la source unique de vérité du projet (principe P4). Le cadrage en "
    "contient la version complète (§2.2, ~50 modèles) ; on n'en implémente que le "
    "sous-ensemble du parcours cœur, **sans dévier des noms ni des enums** — pour que "
    "la suite s'ajoute sans migration de renommage.",
    ["`User`, `Session`, `OtpCode`", "`Governorate`, `Delegation`, `Category`",
     "`ProviderProfile`, `ProviderCategory`, `ServiceOffering`, `CoverageArea`",
     "`MediaAsset`, `PortfolioItem`", "`ContactEvent`, `ProfileView`",
     "`Review`, `Favorite`", "`Plan`, `AppSetting`, `AuditLog`",
     "Politiques de suppression du cadrage §2.5 : `Cascade` / `Restrict` / `SetNull` / soft delete"],
    ["`VerificationRequest`, `Subscription`, `Boost`, `Payment`, `Advertiser`, `ServiceRequest` — modélisés en S2+"],
    ["`prisma migrate dev` passe sur une base vierge",
     "`prisma generate` produit les types",
     "Les enums sont **identiques** à ceux du cadrage §2.2 (noms et valeurs)",
     "Aucune donnée comptable en `onDelete: Cascade`"],
    "cadrage §2.2 et §2.5",
    ["Chayma est **seule propriétaire** de `schema.prisma` en S1 (CODEOWNERS)"]))

A(I("BE-02", "Migration SQL manuelle : contraintes et index essentiels", M1,
    ["type:feat", "lot:backend", "prio:P0", "sprint:S1", "securite"], CHAYMA, 1, ["BE-01"],
    "Prisma ne sait pas exprimer les `CHECK`, les index partiels ni les triggers. Or ce "
    "sont eux qui garantissent l'intégrité même si le code applicatif se trompe. Une "
    "contrainte en base est un filet ; une validation applicative est une intention.",
    ["`CHECK` : note entre 1 et 5, cohérence `price_min <= price_max`",
     "Index unique partiel : une seule catégorie principale par prestataire",
     "Index partiel `ranking_score DESC WHERE publication_status='PUBLISHED'` (le cas 95 % du temps)",
     "Trigger `prevent_self_review` : un artisan ne peut pas évaluer son propre profil"],
    ["Index GIN trigram FR/AR — voir BE-42 (S2), non bloquant sur 30 artisans"],
    ["`INSERT` d'un avis à 6 étoiles → **rejeté par la base**, pas seulement par l'application",
     "Un artisan qui tente de s'auto-évaluer déclenche l'exception du trigger",
     "La migration est rejouable après un `prisma migrate reset`"],
    "cadrage §2.3 · CLAUDE.md §3.2"))

A(I("BE-03", "Seed du référentiel : gouvernorats, délégations du Sahel, catégories FR/AR", M1,
    ["type:feat", "lot:backend", "domaine:catalog", "prio:P0", "sprint:S1", "rtl-ar"], CHAYMA, 2, ["BE-01"],
    "Sans référentiel géographique, aucune recherche n'est possible. Le lancement vise "
    "le Sahel : on charge les 24 gouvernorats (pour ne pas bloquer une extension) mais "
    "seulement les délégations de Sousse, Monastir et Mahdia.",
    ["24 gouvernorats avec libellés FR et AR",
     "Toutes les délégations de Sousse, Monastir, Mahdia",
     "Arbre de catégories : Plomberie, Électricité, Peinture, Climatisation, Menuiserie, Maçonnerie, Serrurerie, Jardinage, Nettoyage… avec sous-catégories",
     "Chaque catégorie : `slug`, `nameFr`, `nameAr`, icône",
     "`Plan` : uniquement `FREE` en S1",
     "`AppSetting` : les poids du ranking (w1…w7) avec leurs valeurs par défaut"],
    ["Les délégations des autres gouvernorats — à charger quand l'expansion arrive"],
    ["`pnpm db:seed` est **idempotent** : deux exécutions donnent le même état, sans doublon",
     "Chaque catégorie a un libellé arabe réel, pas un copier-coller du français",
     "Les poids du ranking sont lisibles depuis `AppSetting`, pas codés en dur"],
    "US-T-02 · Annexe A du cadrage"))

A(I("BE-04", "Seed de démonstration : 30 artisans du Sahel", M1,
    ["type:feat", "lot:backend", "prio:P0", "sprint:S1"], CHAYMA, 2, ["BE-03"],
    "Impossible de développer une recherche, un ranking ou une fiche sans données "
    "crédibles. Ce jeu sert aussi de support de recette (GATE 1 et GATE 2) et de démo "
    "pour la tournée terrain.",
    ["30 profils répartis sur Sousse / Monastir / Mahdia, catégories variées",
     "20 marqués `isVerified` — c'est le contournement du KYC en S1, et cela correspond au « Label de Confiance » du plan de lancement",
     "Notes variées et réalistes, dont un artisan à 1 seul avis 5★ (cas test du lissage bayésien)",
     "Prestations tarifées en millimes, zones de couverture, photos (URL publiques)",
     "Quelques `ContactEvent` et `Review` historiques pour alimenter les stats"],
    ["Les vraies données d'artisans — la collecte terrain est un chantier parallèle, non bloquant"],
    ["« plombier · Sousse » retourne **au moins 5 résultats** crédibles",
     "Les noms et libellés sont plausibles en contexte tunisien",
     "Le jeu contient au moins un cas piège : artisan gratuit vérifié complet vs artisan non vérifié"],
    "US-T-02"))

A(I("BE-05", "Couche repositories : la seule qui parle à Prisma", M1,
    ["type:feat", "lot:backend", "prio:P0", "sprint:S1"], CHAYMA, 2.5, ["BE-01"],
    "Sans cette frontière, des appels Prisma finissent dans les routes, puis la logique "
    "d'accès aux données se disperse et devient impossible à optimiser. C'est aussi ce "
    "qui permet de tester `packages/core` sans base.",
    ["`packages/db/src/repositories/` : un fichier par agrégat",
     "`select` explicites — jamais l'entité complète renvoyée",
     "Helper générique de pagination par curseur (encodage opaque, stable à l'insertion)",
     "Helper de transaction",
     "Règle ESLint interdisant `prisma.` hors de `packages/db`"],
    [],
    ["Aucun `prisma.` n'existe en dehors de `packages/db` — vérifié par le lint",
     "La pagination reste stable si une ligne est insérée entre deux pages",
     "Tous les `findMany` publics filtrent `deletedAt: null`"],
    "CLAUDE.md §2 (P5)"))

A(I("BE-06", "Normalisation des numéros tunisiens (+216)", M1,
    ["type:feat", "lot:backend", "domaine:auth", "prio:P0", "sprint:S1"], OUSSAMA, 1, ["SO-01"],
    "Le numéro de téléphone est l'identifiant principal des utilisateurs (marché "
    "*phone-first*). Les formats de saisie varient énormément. Sans normalisation **avant** "
    "écriture ET avant la recherche d'unicité, on crée des comptes en double invisibles.",
    ["`packages/utils/src/phone-tn.ts` : `normalizePhoneTn(input): string | null`",
     "Accepte : `22123456`, `22 123 456`, `+216 22 123 456`, `0021622123456`, `216-22-123-456`",
     "Rejette : longueur invalide, préfixe opérateur inexistant, caractères non numériques",
     "`formatPhoneTnDisplay()` pour l'affichage"],
    [],
    ["12 cas de test passent, dont **4 formats invalides explicitement rejetés**",
     "La sortie est toujours `+216XXXXXXXX` ou `null` — jamais une chaîne partiellement nettoyée"],
    "US-C-02"))

A(I("BE-07", "OTP : génération, hachage argon2, TTL et tentatives", M1,
    ["type:feat", "lot:backend", "domaine:auth", "prio:P0", "sprint:S1", "securite"], OUSSAMA, 2, ["BE-01"],
    "L'OTP est le seul facteur d'authentification du produit. Un OTP stocké en clair ou "
    "loggé, c'est la compromission de tous les comptes.",
    ["Génération de 6 chiffres cryptographiquement sûre",
     "Hachage **argon2** avant stockage — jamais l'OTP en clair en base",
     "TTL 5 minutes, 3 tentatives maximum, invalidation à l'usage",
     "`OtpPurpose` : `LOGIN`, `PHONE_CHANGE`"],
    ["L'envoi du SMS lui-même — voir BE-08"],
    ["L'OTP n'apparaît **jamais** en clair, ni en base ni dans les logs",
     "La 4ᵉ tentative renvoie `OTP_TOO_MANY_ATTEMPTS`",
     "Un OTP expiré ou déjà consommé est refusé",
     "Le code n'est jamais renvoyé dans une réponse d'API"],
    "US-C-02 · Annexe B du cadrage",
    ["Ne jamais logger l'OTP, même en développement — utiliser le canal `console` de BE-08"]))

A(I("BE-08", "Adaptateur SMS derrière une interface SmsProvider", M1,
    ["type:feat", "lot:backend", "domaine:auth", "prio:P0", "sprint:S1"], OUSSAMA, 0.5, ["SO-03"],
    "Le compte chez l'agrégateur SMS n'est pas ouvert, et son ouverture est une démarche "
    "administrative de plusieurs jours. Une interface avec une implémentation `console` "
    "débloque tout le développement sans attendre.",
    ["Interface `SmsProvider { send(to, message): Promise<void> }`",
     "Implémentation `console` : écrit l'OTP dans le log serveur en développement",
     "Point d'extension prêt pour Twilio (implémentation en S2)",
     "Sélection par variable d'environnement `SMS_PROVIDER`"],
    ["L'implémentation Twilio et la bascule automatique en cas d'échec — S2"],
    ["En développement, l'OTP s'affiche dans le log serveur et permet de se connecter",
     "Changer `SMS_PROVIDER` ne demande de modifier **aucun** code métier"],
    "US-C-02 · ADR-003 §4"))

A(I("BE-09", "JWT : access court + refresh rotatif avec détection de rejeu", M1,
    ["type:feat", "lot:backend", "domaine:auth", "prio:P0", "sprint:S1", "securite"], OUSSAMA, 3, ["BE-01"],
    "Un refresh token volé sur un téléphone perdu doit pouvoir être neutralisé. La "
    "rotation avec détection de réutilisation est la seule mécanique qui le permet sans "
    "session serveur complète.",
    ["Access token 15 minutes, refresh token 30 jours",
     "Rotation : chaque usage d'un refresh en émet un nouveau et invalide l'ancien",
     "**Détection de rejeu** : réutiliser un refresh déjà consommé révoque toute la famille de sessions",
     "`Session` en base, révocable individuellement",
     "Rôles portés par le token : `CLIENT`, `PROVIDER`, `ADMIN`, `MODERATOR`"],
    ["La 2FA des comptes internes — S3, avec le back-office"],
    ["Rejouer un ancien refresh token révoque **toutes** les sessions de la famille",
     "Un access token expiré renvoie `401` avec un code distinct de « token invalide »",
     "La déconnexion révoque effectivement la session côté serveur"],
    "US-C-02 · Annexe B du cadrage"))

A(I("BE-10", "Routes d'authentification", M1,
    ["type:feat", "lot:backend", "domaine:auth", "prio:P0", "sprint:S1", "contrat-api", "securite"], OUSSAMA, 2, ["BE-07", "BE-09"],
    "Le premier parcours complet de l'API. Point d'attention majeur : ne jamais révéler "
    "si un numéro est déjà inscrit — sinon l'endpoint devient un outil d'énumération de "
    "la base d'utilisateurs.",
    ["`POST /v1/auth/otp/request` — normalise le numéro, génère, envoie",
     "`POST /v1/auth/otp/verify` — vérifie, crée l'utilisateur si nouveau, émet les tokens",
     "`POST /v1/auth/refresh`", "`POST /v1/auth/logout`",
     "`GET /v1/auth/me` — profil + rôles"],
    [],
    ["Le parcours complet passe en `curl`, de la demande d'OTP au `GET /me`",
     "`otp/request` renvoie **la même réponse** que le numéro existe ou non",
     "Aucun numéro, OTP ni token n'apparaît dans les logs",
     "`contracts/openapi.json` est régénéré et commité"],
    "US-C-02, US-P-01"))

A(I("BE-11", "Rate limiting Redis par téléphone et par IP", M1,
    ["type:feat", "lot:backend", "prio:P0", "sprint:S1", "securite"], OUSSAMA, 1.5, ["SO-02"],
    "Le modèle freemium se fait attaquer par le volume : demandes d'OTP en masse (coût "
    "SMS réel), gonflage artificiel des contacts, faux avis. Sans limitation, les "
    "statistiques vendues aux artisans deviennent du bruit (principe P10).",
    ["OTP : 5 par heure, par numéro **et** par IP",
     "Contacts : 30 par jour et par utilisateur",
     "Réponse `429` avec en-tête `Retry-After`",
     "Compteurs dans Redis avec expiration"],
    ["Les limites sur les avis et les uploads — arrivent avec BE-22 et BE-20"],
    ["La 6ᵉ demande d'OTP en une heure renvoie `429` + `Retry-After`",
     "Limiter par IP **et** par numéro : changer de numéro depuis la même IP ne contourne pas",
     "Les compteurs expirent bien (pas de fuite mémoire Redis)"],
    "CLAUDE.md §2 (P10) · Annexe B"))

A(I("BE-12", "RBAC centralisé dans packages/core/policies", M1,
    ["type:feat", "lot:backend", "domaine:auth", "prio:P0", "sprint:S1", "securite"], OUSSAMA, 2, ["BE-09"],
    "Les autorisations dispersées dans les routes deviennent impossibles à auditer. "
    "Centralisées dans `core/policies`, elles sont testables sans serveur et lisibles "
    "d'un coup d'œil.",
    ["`packages/core/policies/` : fonctions pures `can(user, action, resource)`",
     "preHandlers Fastify `requireAuth` et `requireRole(...)`",
     "Règles : un client ne modifie que ses avis ; un artisan que son profil ; un admin tout"],
    [],
    ["Une route protégée sans en-tête d'autorisation renvoie `401`",
     "Un rôle insuffisant renvoie `403`",
     "Les policies sont testées **sans base ni serveur**",
     "Aucune autorisation vérifiée uniquement côté client"],
    "Annexe B du cadrage · CLAUDE.md §2 (P3)"))

A(I("BE-13", "Erreurs normalisées, codes et requestId", M1,
    ["type:feat", "lot:backend", "prio:P0", "sprint:S1"], OUSSAMA, 1, ["SO-03"],
    "Le client mobile doit pouvoir traduire une erreur en arabe sans parser un message "
    "anglais. D'où la séparation : un `code` stable et machine, un `message` destiné au "
    "développeur, et un `requestId` pour retrouver la trace serveur.",
    ["`packages/core/errors/` : classes d'erreur typées",
     "`packages/constants/error-codes.ts` : le catalogue des codes",
     "Handler global : `{ error: { code, message, details }, requestId }`",
     "Aucune stack trace exposée en production"],
    ["Le branchement Sentry — reporté en S2 (OPS-03)"],
    ["Toute erreur renvoie la forme normalisée avec un `requestId` exploitable",
     "Une erreur interne en production ne fuite ni stack, ni requête SQL, ni chemin de fichier",
     "Le client peut afficher un message traduit à partir du seul `code`"],
    "CLAUDE.md §4.3"))

A(I("BE-14", "Catalogue : catégories, gouvernorats, délégations", M1,
    ["type:feat", "lot:backend", "domaine:catalog", "prio:P0", "sprint:S1", "contrat-api"], CHAYMA, 1.5, ["BE-03"],
    "Ces données sont appelées au démarrage de chaque session mobile et ne changent "
    "quasiment jamais : elles doivent être servies depuis un cache, pas depuis la base.",
    ["`GET /v1/categories` — arbre complet, libellés FR et AR",
     "`GET /v1/governorates`", "`GET /v1/governorates/:id/delegations`",
     "Cache Redis 1 heure, invalidé au seed"],
    [],
    ["Réponses en moins de 50 ms en cache chaud",
     "Les deux libellés (FR et AR) sont renvoyés — le client choisit selon sa locale",
     "L'arbre de catégories est renvoyé en une seule requête, pas en N+1"],
    "US-C-01"))

A(I("BE-15", "⭐ Algorithme de ranking : score explicable et note bayésienne", M1,
    ["type:feat", "lot:backend", "domaine:search", "prio:P0", "sprint:S1", "binome"], BINOME, 4, ["BE-01"],
    "**Le cœur du produit.** Le classement conditionne directement le chiffre d'affaires : "
    "c'est lui qui détermine quel artisan est vu, donc contacté, donc prêt à payer. Il "
    "doit être explicable (un artisan qui appelle doit obtenir une réponse), paramétrable "
    "(sans redéploiement) et auditable (testable sans base).\n\n"
    "**À faire en binôme** : une erreur ici est coûteuse à détecter et se paie en revenus.",
    ["Pertinence géographique : 1.0 délégation exacte · 0.6 gouvernorat · 0.3 limitrophe",
     "**Note bayésienne** : `(C·m + Σnotes) / (C + n)` avec C ≈ 8",
     "Confiance : badge vérifié = 1, sinon 0",
     "Complétude : `completionScore / 100`",
     "Réactivité : basée sur `lastActiveAt` et `availabilityStatus`",
     "Facteur de plan : `Plan.rankingBoostFactor` (1.0 gratuit, 1.3 Pro)",
     "Pénalité de signalements",
     "**Rotation équitable** : à score égal (± 2 %), l'ordre tourne — pour ne pas figer la 1ʳᵉ position",
     "Poids `w1…w7` lus depuis `AppSetting`, jamais codés en dur"],
    ["Les boosts : ce sont des **emplacements séparés** en tête de liste, étiquetés « Sponsorisé ». "
     "Ils n'entrent **pas** dans `rankingScore` (S4)."],
    ["**≥ 12 tests unitaires**, sans base ni réseau",
     "Test bayésien : un artisan à 1 seul avis 5★ ne devance **pas** un artisan à 80 avis / 4,7★",
     "🔒 **Test de non-régression ADR-002** : un artisan *gratuit, vérifié, profil à 100 %* obtient un score **supérieur** à un artisan *Pro non vérifié, incomplet*, à géo et réputation égales",
     "Changer un poids dans `AppSetting` change l'ordre sans redéploiement",
     "Chaque score peut être décomposé terme à terme (mode debug)"],
    "Annexe A du cadrage · ADR-002 §5",
    ["**Timeboxé à 4 h.** Au-delà : version simplifiée (géo + bayésien + vérifié) et création de `BE-15b`.",
     "Aucun code ne lit `subscription.status` pour décider du badge (ADR-002)"]))

A(I("BE-16", "Recherche d'artisans : filtres, tri et pagination par curseur", M1,
    ["type:feat", "lot:backend", "domaine:search", "prio:P0", "sprint:S1", "contrat-api"], OUSSAMA, 3, ["BE-15", "BE-05"],
    "L'écran le plus utilisé du produit. La pagination par curseur (et non par offset) "
    "est imposée par le principe P5 : sur un réseau tunisien en 3G, un offset devient "
    "instable dès qu'un artisan est ajouté entre deux pages.",
    ["`GET /v1/providers/search`",
     "Filtres : catégorie × gouvernorat × délégation × vérifié × note minimale × disponibilité",
     "Tri par `rankingScore` calculé (BE-15)",
     "Pagination par curseur : `?cursor=&limit=20` → `{ items, nextCursor }`",
     "Mode debug exposant `score` et `matchReason` par item"],
    ["La recherche plein texte — l'index GIN trigram arrive en S2 (BE-42)"],
    ["Retourne `{ items, nextCursor }` — jamais un tableau nu",
     "Réponse en moins de 200 ms sur le jeu de démonstration",
     "Aucun numéro de téléphone dans la réponse",
     "Un filtre vide ne renvoie pas la base entière : `limit` par défaut à 20, plafonné à 50"],
    "US-C-01, US-C-03"))

A(I("BE-17", "Fiche artisan publique — sans le numéro de téléphone", M1,
    ["type:feat", "lot:backend", "domaine:providers", "prio:P0", "sprint:S1", "contrat-api", "securite"], OUSSAMA, 2, ["BE-05"],
    "Le numéro de téléphone est l'actif qu'on monétise : il ne doit **jamais** être dans "
    "la réponse de la fiche, sinon un script le récupère en masse sans jamais générer de "
    "`ContactEvent`. Il est révélé uniquement par `POST /contact-events` (BE-21).",
    ["`GET /v1/providers/:slug`",
     "Profil, catégories, zones de couverture, prestations tarifées, galerie",
     "Agrégats d'avis : moyenne, nombre, répartition par étoile",
     "Badge `isVerified`, statut de disponibilité, `completionScore`"],
    ["Le numéro de téléphone — révélé exclusivement par BE-21"],
    ["Un `curl` sur la fiche ne contient **aucun** numéro de téléphone",
     "Une fiche non publiée renvoie `404`, pas `403` (ne pas révéler son existence)",
     "Les prestations sont renvoyées en millimes avec un `displayPrice` déjà formaté"],
    "US-C-04 · CLAUDE.md §2 (P8)"))

A(I("BE-18", "Liste des avis d'un artisan", M1,
    ["type:feat", "lot:backend", "domaine:reviews", "prio:P0", "sprint:S1", "contrat-api"], OUSSAMA, 1, ["BE-05"],
    "Les avis sont ce qui brise la méfiance identifiée comme faille n°2 du marché. Ils "
    "doivent être paginés séparément de la fiche : une fiche à 200 avis ne doit pas "
    "peser 400 ko sur une connexion 3G.",
    ["`GET /v1/providers/:slug/reviews` — curseur, tri par date décroissante",
     "Auteur affiché de façon anonymisée si le compte est supprimé",
     "Réponse de l'artisan incluse si elle existe"],
    ["Les sous-notes détaillées (ponctualité / qualité / rapport qualité-prix) — 🟠 P1"],
    ["Pagination stable même si un avis est ajouté entre deux pages",
     "Les avis d'un utilisateur supprimé apparaissent en « Utilisateur supprimé », pas effacés"],
    "US-C-07"))

A(I("BE-19", "Onboarding artisan : profil, catégories, zones, complétude", M1,
    ["type:feat", "lot:backend", "domaine:providers", "prio:P1", "sprint:S1", "contrat-api"], CHAYMA, 2.5, ["BE-12"],
    "Le `completionScore` est le moteur d'activation de l'artisan : c'est lui qui le "
    "pousse à finir son profil, et il pèse dans le ranking.\n\n"
    "🟠 **P1** : l'écran mobile qui consomme cette API (`FM-11`) est lui aussi P1. "
    "Livrer une API que personne n'appelle cette semaine serait du gaspillage.",
    ["`POST /v1/providers/me` et `PATCH /v1/providers/me`",
     "`PUT /v1/providers/me/categories` (avec `isPrimary`)",
     "`PUT /v1/providers/me/coverage-areas`",
     "Calcul du `completionScore` dans `packages/core` — fonction pure, testée"],
    ["Les prestations tarifées et la galerie — S2", "L'upload de photos — BE-20"],
    ["Le `completionScore` est recalculé à chaque écriture",
     "La publication est refusée sous 60 %, avec **la liste explicite des champs manquants**",
     "Un artisan ne peut modifier que son propre profil (403 sinon)"],
    "US-P-02 → US-P-04"))

A(I("BE-20", "Upload de médias : URL pré-signées et variantes WebP", M1,
    ["type:feat", "lot:backend", "domaine:providers", "prio:P1", "sprint:S1"], CHAYMA, 2.5, ["BE-12"],
    "🟠 **P1 — reporté par défaut en S2.** Les photos du jeu de démonstration suffisent "
    "pour la recette S1, et cette tâche demande d'ouvrir un compte Cloudflare R2.",
    ["`POST /v1/media/presign` — bucket **public** uniquement",
     "Traitement `sharp` : variantes WebP (thumb, card, full)",
     "`PortfolioItem` rattaché au profil"],
    ["Le bucket privé KYC — c'est M4, avec des exigences bien plus lourdes (chiffrement, URL 5 min, purge, journal d'accès)"],
    ["Une image de 4 Mo est servie en moins de 150 ko en WebP",
     "Le bucket `private-kyc` n'est **pas** touché par cette tâche"],
    "US-P-06"))

A(I("BE-21", "⭐ ContactEvent : l'unité de valeur du produit", M1,
    ["type:feat", "lot:backend", "domaine:contact", "prio:P0", "sprint:S1", "binome", "contrat-api", "securite"], BINOME, 3, ["BE-11", "BE-12"],
    "**Sans cette route, il n'y a rien à vendre à l'artisan.** Le modèle économique repose "
    "entièrement sur la capacité à prouver « la plateforme t'a apporté 14 contacts ce "
    "mois-ci ». Si le comptage est faux ou gonflable, l'abonnement Pro est indéfendable "
    "(principes P9 et P10).\n\n"
    "**À faire en binôme.**",
    ["`POST /v1/contact-events` — canal `PHONE` ou `WHATSAPP`",
     "**C'est cette route qui révèle le numéro de téléphone** dans sa réponse",
     "Déduplication : deux clics du même utilisateur sur le même artisan en 30 min = 1 seul événement",
     "Empreinte de session (hash) pour la déduplication anonyme",
     "Rate limiting (BE-11)",
     "Incrément de l'agrégat `DailyProviderStat` **dans la même transaction**"],
    ["La confirmation « l'intervention a-t-elle eu lieu ? » — dépend de l'ADR-005 (annuaire ou marketplace)"],
    ["Deux clics en 5 minutes produisent **un seul** `ContactEvent`",
     "La réponse contient le numéro de téléphone révélé",
     "L'événement est visible immédiatement dans les statistiques de l'artisan",
     "L'agrégat et l'événement sont écrits atomiquement (pas d'incohérence en cas d'échec)",
     "Un utilisateur non authentifié peut contacter (empreinte de session) mais est rate-limité par IP"],
    "US-C-05, US-C-06 · CLAUDE.md §2 (P9, P10)"))

A(I("BE-22", "Dépôt d'avis rattaché à un contact réel", M1,
    ["type:feat", "lot:backend", "domaine:reviews", "prio:P0", "sprint:S1", "contrat-api", "securite"], OUSSAMA, 2.5, ["BE-21"],
    "Le garde-fou anti-faux-avis du produit : un avis exige un `ContactEvent` "
    "correspondant. C'est ce qui distingue Sanaya d'un groupe Facebook où n'importe qui "
    "note n'importe qui.",
    ["`POST /v1/providers/:id/reviews`",
     "Relation 1-1 **unique** avec un `ContactEvent` de l'auteur",
     "Recalcul de `ratingAvg` et `ratingCount` **dans la même transaction**",
     "Un seul avis par `ContactEvent`"],
    ["La modération a posteriori — M4", "Les sous-notes détaillées — 🟠 P1"],
    ["Déposer un avis sans contact préalable renvoie `403 REVIEW_REQUIRES_CONTACT`",
     "S'auto-évaluer est **rejeté par le trigger SQL**, pas seulement par l'application",
     "`ratingAvg` est exact après 10 avis concurrents (test de concurrence)",
     "Un second avis sur le même `ContactEvent` est refusé"],
    "US-C-07 · cadrage §2.3"))

A(I("BE-23", "Traçage des vues de profil et agrégat journalier", M1,
    ["type:feat", "lot:backend", "domaine:analytics", "prio:P0", "sprint:S1"], CHAYMA, 1.5, ["BE-21"],
    "Le ratio vue → contact est l'indicateur qui dit à l'artisan si son profil convertit. "
    "Si on ne le trace pas dès le jour 1, on ne pourra pas le reconstituer plus tard — "
    "c'est de la donnée définitivement perdue.",
    ["`POST /v1/profile-views`",
     "Déduplication par empreinte de session sur 24 h",
     "Upsert quotidien sur `DailyProviderStat`"],
    ["L'exposition de ces chiffres à l'artisan — BE-24 (🟠 P1)"],
    ["Une vue est comptée une seule fois par session et par jour",
     "L'agrégat journalier est cohérent avec le nombre d'événements bruts"],
    "CLAUDE.md §2 (P9)"))

A(I("BE-24", "Tableau de bord statistiques de l'artisan (API)", M1,
    ["type:feat", "lot:backend", "domaine:analytics", "prio:P1", "sprint:S1", "contrat-api"], CHAYMA, 2, ["BE-23"],
    "C'est **l'argument de vente du Pack Pro**. 🟠 P1 en S1 : la donnée est déjà collectée "
    "par BE-23, on ne perd rien à exposer l'écran en S2.",
    ["`GET /v1/providers/me/stats`",
     "Vues, contacts, ratio vue → contact, position moyenne en recherche",
     "Série journalière sur 30 jours, directement exploitable par un graphe"],
    [],
    ["Les chiffres correspondent aux événements bruts",
     "La série est renvoyée avec les jours à zéro (pas de trous, sinon le graphe ment)"],
    "US-P-12"))

A(I("BE-25", "Favoris", M1,
    ["type:feat", "lot:backend", "domaine:providers", "prio:P1", "sprint:S1"], OUSSAMA, 1, ["BE-12"],
    "🟠 P1. Fonctionnalité de confort : elle améliore la rétention mais ne fait pas "
    "partie du parcours cœur.",
    ["`PUT /v1/favorites/:providerId` (idempotent)", "`DELETE /v1/favorites/:providerId`",
     "`GET /v1/favorites` paginé"],
    [],
    ["Ajouter deux fois le même favori ne crée pas de doublon (clé primaire composite)"],
    "US-C-08"))

A(I("BE-26", "⭐ Publier le contrat OpenAPI et générer les clients", M1,
    ["type:chore", "lot:backend", "prio:P0", "sprint:S1", "contrat-api", "gate"], OUSSAMA, 2.5, ["BE-16", "BE-17", "BE-21", "BE-22"],
    "C'est le remplaçant du garde-fou que tRPC offrait gratuitement (ADR-001). Sans le "
    "contrôle `--check` en CI, le contrat dérive silencieusement et le client Dart casse "
    "sans prévenir.",
    ["`pnpm api:contract` → `contracts/openapi.json` (OpenAPI 3.1)",
     "`pnpm api:contract --check` → échoue si le fichier commité est périmé",
     "`pnpm mobile:client` → `openapi-generator` (dart-dio) vers `apps/mobile/lib/core/api/generated/`",
     "`pnpm web:client` → `openapi-typescript` (prêt pour S2, non utilisé cette semaine)",
     "Les deux contrôles branchés dans la CI"],
    [],
    ["`contracts/openapi.json` est commité et à jour",
     "Modifier un schéma Zod sans régénérer fait **échouer la CI**",
     "Le client Dart se génère sans erreur et compile",
     "Aucun `openapi.json` n'a été édité à la main"],
    "ADR-001 §3.2",
    ["`contracts/openapi.json` est **généré** — toute PR qui le modifie porte le label `contrat-api` et prévient l'autre dev avant le merge"]))

A(I("BE-27", "🚦 GATE 1 — recette backend", M1,
    ["type:test", "lot:backend", "prio:P0", "sprint:S1", "gate", "binome"], BINOME, 0.75, ["BE-26"],
    "Porte de sprint bloquante. **Si un seul point échoue, on ne démarre pas Flutter.** "
    "Démarrer le mobile sur une API instable coûte deux fois : une fois pour l'écrire, "
    "une fois pour la reprendre.",
    ["Exécuter les 8 appels `curl` du parcours cœur, dans l'ordre, sans intervention manuelle en base",
     "Vérifier le contrat et la génération des deux clients",
     "Vérifier l'absence de données sensibles dans les logs"],
    [],
    ["1. `POST /v1/auth/otp/request` → 200, OTP dans le log",
     "2. `POST /v1/auth/otp/verify` → access + refresh",
     "3. `GET /v1/categories` → arbre FR/AR",
     "4. `GET /v1/providers/search?category=plomberie&governorate=sousse` → ≥ 5 items + `nextCursor`",
     "5. `GET /v1/providers/:slug` → fiche **sans téléphone**",
     "6. `POST /v1/contact-events` → 200 + téléphone révélé",
     "7. `POST /v1/providers/:id/reviews` → `ratingAvg` recalculé",
     "8. `GET /v1/auth/me` → profil + rôles",
     "✅ `api:contract --check` vert · client Dart généré",
     "✅ Aucun téléphone / OTP / token dans les logs",
     "✅ `pnpm test` vert, dont le garde-fou ADR-002"],
    "PLAN-MVP-SEMAINE-1.md §6.4"))

# =============================================================================
# M2 — MOBILE (J4 pm → J7)
# =============================================================================
A(I("FM-01", "Bootstrap Flutter : go_router, Riverpod, thème généré", M2,
    ["type:chore", "lot:mobile", "prio:P0", "sprint:S1", "first-dart"], CHAYMA, 3, ["SO-04"],
    "Première ligne de Dart du projet. Lire **ADR-001** avant de commencer : le cadrage "
    "v1.0 dit « Expo / React Native », c'est obsolète.",
    ["Flutter 3.24+, structure `lib/{app,core,features}` — **par feature, pas par type**",
     "`go_router` : groupes de routes `(auth)`, `(client)`, `(pro)`",
     "Riverpod 2 : `ProviderScope` racine",
     "`ThemeData` construit depuis `app_colors.dart` / `app_spacing.dart` **générés** (SO-04)",
     "Polices Manrope (latin) + Noto Kufi Arabic (arabe)",
     "`analysis_options.yaml` : `flutter_lints` + `very_good_analysis`"],
    [],
    ["`flutter run` affiche un écran d'accueil aux couleurs Sanaya",
     "`flutter analyze` : **zéro warning**",
     "Le thème sombre fonctionne",
     "Aucune couleur ni taille écrite en dur dans le code"],
    "ADR-001 §3.4 · `Code/apps/mobile/CLAUDE.md`"))

A(I("FM-02", "⭐ Couche réseau : client Dio/Retrofit généré + intercepteurs", M2,
    ["type:feat", "lot:mobile", "prio:P0", "sprint:S1", "binome", "securite"], BINOME, 4, ["BE-26"],
    "**Tout le reste de l'app en dépend.** C'est aussi la meilleure occasion pour Oussama "
    "de prendre Dart en main — d'où le binôme, qui règle au passage le risque « une seule "
    "personne sait faire du mobile » identifié dans l'ADR-001 §4.2.",
    ["Client généré depuis `contracts/openapi.json` — jamais écrit à la main",
     "Intercepteur JWT + **refresh rotatif transparent** (une seule tentative concurrente)",
     "Retry ×2 avec backoff, sur les `GET` idempotents **uniquement**",
     "Détection hors ligne + bandeau global non bloquant",
     "`flutter_secure_storage` pour le refresh token",
     "Timeouts : 10 s connect, 20 s receive",
     "Mapping des erreurs API (`code`) vers des exceptions Dart typées"],
    [],
    ["**Zéro appel HTTP écrit à la main** dans tout le projet",
     "Un access token expiré déclenche un refresh transparent, sans déconnecter l'utilisateur",
     "Deux requêtes simultanées avec un token expiré ne déclenchent qu'**un seul** refresh",
     "Le refresh token n'est **jamais** en `SharedPreferences`",
     "Couper le réseau affiche le bandeau hors ligne sans crasher"],
    "ADR-001 §3.2 · CLAUDE.md",
    ["Aucune règle métier en Dart : si le mobile a besoin d'un calcul, l'API le renvoie"]))

A(I("FM-03", "i18n FR/AR avec slang, RTL global et miroir des icônes", M2,
    ["type:feat", "lot:mobile", "prio:P0", "sprint:S1", "rtl-ar", "first-dart"], OUSSAMA, 2.5, ["SO-05"],
    "Le RTL n'est pas un thème qu'on active à la fin : c'est une contrainte de mise en "
    "page qui doit être vraie dès le premier widget. Rétrofiter le RTL en fin de sprint "
    "signifie reprendre tous les écrans.",
    ["`slang` généré depuis `packages/i18n/src/locales/*.json`",
     "`Directionality` piloté au niveau de `MaterialApp`, jamais par écran",
     "Sélection automatique de la police selon la locale",
     "Miroir des icônes directionnelles (chevrons, flèches de retour)",
     "Persistance du choix de langue"],
    [],
    ["Changer la langue fait basculer **toute l'app** en RTL sans redémarrage",
     "Les icônes de navigation sont miroitées en arabe",
     "Les dates et les montants TND sont formatés selon la locale",
     "Aucune chaîne affichée n'est écrite en dur"],
    "CLAUDE.md §2 (P7)",
    ["`EdgeInsetsDirectional` et `AlignmentDirectional` obligatoires — jamais `EdgeInsets.only(left:)`"]))

A(I("FM-04", "Widgets du design system", M2,
    ["type:feat", "lot:mobile", "lot:design", "prio:P0", "sprint:S1", "rtl-ar", "first-dart"], OUSSAMA, 4, ["FM-01"],
    "Construire ces widgets d'abord évite que chaque écran réinvente son bouton et sa "
    "carte. C'est aussi le meilleur endroit pour imposer une fois pour toutes la cible "
    "tactile de 48 px et les trois états de chargement.",
    ["`AppButton` (primary / secondary / ghost / whatsapp / danger), hauteur min 48 px",
     "`AppTextField`, `AppCard`", "`ProviderCard` — le composant le plus vu du produit",
     "`RatingStars`, `VerifiedBadge`", "`AppSkeleton`, `EmptyState`, `ErrorState`, `OfflineBanner`"],
    [],
    ["Tous `const` là où c'est possible (perf de rebuild sur Android d'entrée de gamme)",
     "Aucune couleur, taille ou rayon en dur — tout vient des tokens générés",
     "Chaque widget rendu correctement en **FR et en AR** (captures dans la PR)",
     "Contraste AA vérifié en thème clair et sombre"],
    "`Code/docs/design-system.html`"))

A(I("FM-05", "Parcours d'authentification OTP", M2,
    ["type:feat", "lot:mobile", "domaine:auth", "prio:P0", "sprint:S1", "rtl-ar"], OUSSAMA, 3.5, ["BE-10", "FM-02"],
    "Premier contact de l'utilisateur avec le produit. Sur un marché *phone-first* où "
    "beaucoup d'artisans sont peu à l'aise avec l'écrit, chaque friction ici est un "
    "utilisateur perdu.",
    ["Écran de sélection de rôle (client / artisan)",
     "Saisie du téléphone avec masque `+216`",
     "Saisie de l'OTP à 6 cases, avancement automatique, collage supporté",
     "Renvoi du code avec compte à rebours de 60 s",
     "Session persistée, restaurée au démarrage"],
    [],
    ["Fermer et rouvrir l'app conserve la session",
     "Les messages d'erreur sont traduits en FR **et** en AR",
     "Le compte à rebours de renvoi survit à une rotation d'écran",
     "Un code invalide affiche le nombre de tentatives restantes"],
    "US-C-02, US-P-01"))

A(I("FM-06", "Écran d'accueil client : recherche et catégories", M2,
    ["type:feat", "lot:mobile", "domaine:catalog", "prio:P0", "sprint:S1", "rtl-ar"], CHAYMA, 3, ["BE-14"],
    "Le point d'entrée. Les catégories doivent être visuelles (icônes larges, contrastes "
    "forts) : la cible inclut des artisans peu à l'aise avec le texte, et des clients "
    "pressés.",
    ["Barre de recherche : service + localisation",
     "Grille de catégories avec icônes, **chargée depuis l'API** (BE-14)",
     "Détection ou sélection du gouvernorat, mémorisée",
     "État de chargement en skeleton"],
    ["La géolocalisation GPS précise — S2 ; le gouvernorat suffit en S1"],
    ["Les catégories viennent de l'API, jamais d'une liste codée en dur",
     "Le gouvernorat choisi est mémorisé entre deux lancements",
     "Rendu correct en arabe (grille inversée)"],
    "US-C-01"))

A(I("FM-07", "⭐ Résultats de recherche : pagination, filtres et cache disque", M2,
    ["type:feat", "lot:mobile", "domaine:search", "prio:P0", "sprint:S1", "rtl-ar"], CHAYMA, 4.5, ["BE-16"],
    "L'écran qui doit être irréprochable sur un Android d'entrée de gamme en 3G : c'est "
    "précisément l'argument qui a justifié la bascule vers Flutter (ADR-001).",
    ["`ListView.builder` — jamais `Column` + `map`",
     "Pagination par curseur, chargement à l'approche du bas",
     "Panneau de filtres : catégorie, zone, vérifié, note minimale, disponibilité",
     "**Cache disque** des résultats et des fiches consultées",
     "États : skeleton, vide (avec action « élargir au gouvernorat »), erreur (avec « Réessayer »)"],
    [],
    ["Défilement fluide (60 fps) sur émulateur bridé en CPU",
     "Les résultats restent consultables **en mode avion**",
     "L'état vide propose une action utile, pas seulement un message",
     "Aucun écran blanc sur erreur réseau"],
    "US-C-01, US-C-03 · CLAUDE.md §2 (P5)"))

A(I("FM-08", "Fiche artisan", M2,
    ["type:feat", "lot:mobile", "domaine:providers", "prio:P0", "sprint:S1", "rtl-ar"], OUSSAMA, 4, ["BE-17"],
    "L'écran de décision : c'est ici que le client choisit d'appeler ou non. Tout ce qui "
    "réduit l'incertitude (photos, avis, badge, tarif indicatif) augmente le taux de "
    "contact — donc la valeur vendue à l'artisan.",
    ["Galerie avec `cached_network_image` et placeholders",
     "Prestations tarifées, zones de couverture, disponibilité",
     "Badge vérifié, note moyenne, liste d'avis (paginée)",
     "Boutons de contact en barre fixe basse (toujours atteignables)"],
    ["L'action de contact elle-même — FM-09"],
    ["Aucun écran blanc en cas d'erreur réseau : `ErrorState` avec « Réessayer »",
     "Les images se chargent progressivement sans faire sauter la mise en page",
     "Rendu vérifié en arabe"],
    "US-C-04"))

A(I("FM-09", "⭐⭐ Contact téléphone / WhatsApp avec traçage et file hors ligne", M2,
    ["type:feat", "lot:mobile", "domaine:contact", "prio:P0", "sprint:S1", "rtl-ar"], CHAYMA, 3.5, ["BE-21"],
    "**La fonctionnalité la plus critique de l'application.** Elle porte à la fois la "
    "valeur pour le client (joindre l'artisan) et la valeur pour le modèle économique "
    "(prouver le lead). Les deux doivent tenir même quand le réseau lâche.",
    ["Bouton « Appeler » → `POST /v1/contact-events` → `launchUrl('tel:+216…')`",
     "Bouton « WhatsApp » → `POST /v1/contact-events` → `https://wa.me/216…?text=…` **pré-rempli dans la langue active**",
     "**File locale persistante** : si l'API échoue, l'événement est stocké et renvoyé au retour du réseau",
     "Le lien natif s'ouvre **même si l'appel API échoue** — on ne bloque jamais l'utilisateur"],
    [],
    ["Le `ContactEvent` est posté **avant** l'ouverture du lien (principe P9)",
     "En mode avion : le composeur s'ouvre quand même, et l'événement part au retour du réseau",
     "Le message WhatsApp est pré-rempli en français ou en arabe selon la locale",
     "Deux clics rapprochés ne créent qu'un seul événement (déduplication serveur BE-21)"],
    "US-C-05, US-C-06 · CLAUDE.md §2 (P9)",
    ["Sans cette trace, l'abonnement Pro est invendable. Ne jamais ouvrir le lien sans tenter l'événement d'abord."]))

A(I("FM-10", "Dépôt d'avis après contact", M2,
    ["type:feat", "lot:mobile", "domaine:reviews", "prio:P0", "sprint:S1", "rtl-ar"], OUSSAMA, 2.5, ["BE-22"],
    "Boucle la valeur : le contact génère l'avis, l'avis alimente la réputation, la "
    "réputation alimente le ranking, le ranking génère le contact suivant.",
    ["Formulaire : note en étoiles + commentaire",
     "Accessible **uniquement** si un `ContactEvent` existe",
     "Invitation à laisser un avis après un contact (non intrusive)"],
    ["Les sous-notes détaillées — 🟠 P1"],
    ["Sans contact préalable, le formulaire n'est pas proposé — et l'API renvoie `403` si on force",
     "Après envoi, la note moyenne de la fiche se met à jour immédiatement"],
    "US-C-07"))

A(I("FM-11", "Espace Pro : assistant d'onboarding artisan", M2,
    ["type:feat", "lot:mobile", "domaine:providers", "prio:P1", "sprint:S1", "rtl-ar"], CHAYMA, 5, ["BE-19"],
    "🟠 **P1 — premier élément de l'amortisseur.** Sans lui, les artisans de la seed "
    "suffisent pour la recette S1 ; on livre une app **client seulement**.",
    ["Assistant en étapes : profil → catégories → zones → tarifs → photos",
     "Barre de complétude mise à jour en direct",
     "Sauvegarde à chaque étape (reprise possible)"],
    [],
    ["La barre de complétude reflète le `completionScore` renvoyé par l'API",
     "La publication est bloquée sous 60 % avec la liste explicite des manques"],
    "US-P-02 → US-P-05"))

A(I("FM-12", "Espace Pro : tableau de bord statistiques", M2,
    ["type:feat", "lot:mobile", "domaine:analytics", "prio:P1", "sprint:S1"], CHAYMA, 3, ["BE-24"],
    "🟠 P1. C'est l'écran qui vendra le Pack Pro, mais il n'y a rien à vendre en S1.",
    ["Vues, contacts, ratio vue → contact", "Courbe sur 30 jours", "Comparaison au mois précédent"],
    [],
    ["Les chiffres correspondent exactement à `GET /v1/providers/me/stats`"],
    "US-P-12"))

A(I("FM-13", "Favoris et réglages", M2,
    ["type:feat", "lot:mobile", "prio:P1", "sprint:S1"], OUSSAMA, 2, ["BE-25"],
    "🟠 P1. Confort et rétention.",
    ["Liste des favoris", "Réglages : langue, déconnexion, mentions légales"],
    [], ["Changer la langue depuis les réglages bascule immédiatement l'interface"],
    "US-C-08"))

A(I("FM-14", "Build Android signé et APK de test", M2,
    ["type:chore", "lot:mobile", "prio:P0", "sprint:S1"], CHAYMA, 2, ["FM-09"],
    "**Le seul livrable utilisateur du sprint.** ⚠️ Le keystore doit être généré **dès J1** : "
    "sa perte empêche définitivement toute mise à jour de l'application, et découvrir un "
    "problème de signature le dimanche soir fait rater la livraison.",
    ["Keystore de release généré et **sauvegardé hors du dépôt**",
     "Configuration de signature Gradle via variables d'environnement",
     "Build release, minification activée",
     "APK distribuable aux beta-testeurs du Sahel"],
    ["La publication sur le Play Store — S3"],
    ["L'APK s'installe sur un Android **non-développeur**",
     "Le parcours cœur passe de bout en bout sur l'appareil",
     "Aucun secret n'est présent dans l'APK (vérifié par `strings`)",
     "Le keystore est sauvegardé dans un coffre, hors du dépôt"],
    "PLAN-MVP-SEMAINE-1.md §7",
    ["⚠️ Faire un build de bout en bout **dès J5**, même sur une app à moitié vide."]))

A(I("QA-01", "Tests d'intégration API sur base jetable", M1,
    ["type:test", "lot:backend", "prio:P0", "sprint:S1"], OUSSAMA, 2, ["BE-22"],
    "Les tests unitaires de `packages/core` ne touchent pas la base — c'est voulu. Mais "
    "les contraintes SQL, les triggers et les transactions ne se testent que contre une "
    "vraie PostgreSQL.",
    ["Base de test jetable via Docker, réinitialisée entre les suites",
     "Couverture de toutes les routes qui **écrivent** : auth, contact-events, reviews, onboarding",
     "Test de concurrence sur le recalcul de `ratingAvg`"],
    [],
    ["Chaque route qui écrit a au moins un test du cas passant **et** un test du cas d'erreur",
     "Le trigger anti-auto-avis est testé au niveau base",
     "Les tests tournent en CI en moins de 3 minutes"],
    "POLITIQUE-PROJET.md §6"))

A(I("QA-03", "🚦 GATE 2 — recette de fin de sprint sur Android réel", M2,
    ["type:test", "lot:mobile", "prio:P0", "sprint:S1", "gate", "binome", "rtl-ar"], BINOME, 1, ["FM-14"],
    "La recette se fait sur un **vrai téléphone bas de gamme en 3G bridé**, pas sur "
    "l'émulateur de la machine de développement. C'est la seule façon de valider les deux "
    "promesses qui ont justifié Flutter et la file hors ligne.",
    ["Exécuter les 15 scénarios, en français **puis** en arabe",
     "Sur un Android d'entrée de gamme réel, réseau bridé en 3G",
     "Consigner les résultats dans l'issue"],
    [],
    ["1. Installer l'APK sur un Android non-développeur",
     "2. Recherche « Plombier · Sousse » → ≥ 5 résultats classés",
     "3. Filtre « Vérifié uniquement »",
     "4. Ouvrir une fiche → galerie, tarifs, zones, avis",
     "5. Clic « Appeler » → composeur avec le bon numéro",
     "6. Le `ContactEvent` est enregistré",
     "7. WhatsApp → message pré-rempli **dans la langue active**",
     "8. Connexion OTP de bout en bout",
     "9. Avis après contact → la note moyenne se met à jour",
     "10. Avis **sans** contact → refusé",
     "11. Bascule en arabe → aucune casse, RTL correct",
     "12. Mode avion → résultats en cache, message clair, pas d'écran blanc",
     "13. **Appeler hors ligne** → composeur ouvert, événement envoyé au retour du réseau",
     "14. **Défilement fluide** sur Android d'entrée de gamme",
     "15. Aucune donnée sensible dans les logs serveur"],
    "PLAN-MVP-SEMAINE-1.md §11"))

# =============================================================================
# ÉPIQUES S2 → S6 — à décomposer au début du sprint concerné
# =============================================================================
def E(id, title, ms, labels, context, contains, refs, est=0):
    return dict(id=id, title=f"[ÉPIQUE {id}] {title}", milestone=ms,
                labels=labels + ["type:epic"], assignee=None, est=est, deps=[],
                context=context, scope=contains, out=[],
                accept=["Décomposée en issues au démarrage du sprint concerné",
                        "Chaque issue fille respecte la Definition of Ready"],
                refs=refs, guard=[])

A(E("EP-WEB", "apps/web — vitrine SEO et acquisition", M3,
    ["lot:web", "prio:P0", "sprint:S2"],
    "**Priorité n°1 du sprint S2.** Reporté de S1 par l'ADR-003. Le backend expose déjà "
    "tout le nécessaire : ce lot n'est que de la consommation d'API (~35 h). C'est ce qui "
    "remplace les groupes Facebook dans les résultats Google (principe P6).",
    ["`FW-01` Bootstrap Next.js 15 + Tailwind v4 + preset tokens (2 h)",
     "`FW-02` Routing `[locale]` FR/AR, `dir` global, `hreflang` (2,5 h)",
     "`FW-03` Client `openapi-fetch` + TanStack Query + cookie httpOnly (2 h)",
     "`FW-04` Primitives UI shadcn/Radix (3,5 h)",
     "`FW-05` Home : héro, recherche, catégories populaires (3 h)",
     "`FW-06` ⭐ `/[locale]/[gouvernorat]/[service]` en **SSG + ISR** (4 h)",
     "`FW-07` Liste + `ProviderCard` + curseur (3 h)",
     "`FW-08` Fiche artisan + **JSON-LD LocalBusiness / AggregateRating** (4 h)",
     "`FW-09` Contact tracé → `tel:` / `wa.me` (2,5 h)",
     "`FW-10` Auth OTP web (3 h)", "`FW-11` Formulaire d'avis (2 h)",
     "`FW-12` `sitemap.xml` + `robots.txt` dynamiques (2 h)",
     "`FW-13` Onboarding artisan sur le web (4 h)",
     "`FW-15` Perf : Lighthouse ≥ 90 en 3G (2 h)",
     "`QA-02` Playwright : recherche → fiche → contact (2 h)"],
    "ADR-003 · CLAUDE.md §2 (P6) · `Code/apps/web/CLAUDE.md`"))

A(E("EP-KYC", "Vérification d'identité (CIN) et conformité INPDP", M4,
    ["lot:backend", "domaine:moderation", "prio:P0", "sprint:S2", "securite"],
    "La CIN est une donnée personnelle **sensible** au sens de la loi organique n°2004-63. "
    "C'est le lot le plus exigeant du projet sur le plan juridique. En S1, `isVerified` est "
    "posé à la main sur 20 artisans — ce contournement n'est pas tenable au-delà de la "
    "phase de test terrain.",
    ["`BE-30` Bucket privé chiffré (SSE), URL signées **5 minutes**, journal d'accès dans `AuditLog`",
     "`BE-30b` Upload depuis le mobile avec compression préalable",
     "`BE-30c` Purge automatique des images à J+X après décision",
     "`BE-31` File de vérification côté back-office : approuver / rejeter / demander un complément",
     "`BE-41` Export et suppression des données personnelles (US-C-13) — **obligation légale**",
     "`DOC-01` **Déclaration INPDP** — démarche administrative, jalon bloquant avant production"],
    "Annexe B du cadrage · ADR-002 · maquette « File de vérification CIN »"))

A(E("EP-ADMIN", "Back-office de modération", M4,
    ["lot:admin", "domaine:moderation", "prio:P0", "sprint:S2"],
    "En S1, Prisma Studio sert de contournement. Il ne passe pas l'échelle et n'offre "
    "aucune traçabilité des décisions de modération.",
    ["`FW-20` Bootstrap `apps/admin` (Next.js séparé, `X-Robots-Tag: noindex`, CSP stricte)",
     "Comptes internes avec **2FA obligatoire**",
     "File de vérification CIN", "Modération des avis et signalements (`BE-40`)",
     "Gestion des comptes artisans", "Réglage des poids du ranking depuis `AppSetting` (US-A-09)",
     "Tableau de bord de pilotage"],
    "US-A-* du cadrage · maquettes back-office"))

A(E("EP-BILLING", "Monétisation : plans, abonnements, crédits, boosts", M5,
    ["lot:backend", "domaine:billing", "prio:P0", "sprint:S3+", "needs-decision"],
    "⛔ **Bloqué** tant que l'ADR-004 (moyens de paiement) n'est pas tranché. La question 2 "
    "du cadrage reste ouverte : répartition espèces / virement / en ligne, équipe terrain, "
    "prélèvement récurrent. Chacune de ces réponses change la modélisation.",
    ["`BE-32` Plans, abonnements, cycle de vie, période de grâce",
     "`BE-33` Passerelle de paiement derrière l'interface `PaymentGateway` (Konnect / Paymee / Flouci)",
     "`BE-34` Portefeuille de crédits, transactions **immuables**",
     "`BE-35` Boosts — emplacements sponsorisés **hors ranking**, étiquetés explicitement",
     "Facturation et réconciliation",
     "`DOC-04` **ADR-004 — moyens de paiement** (préalable bloquant)"],
    "cadrage §6 question 2 · Annexe A (le boost ne modifie pas le score)"))

A(E("EP-VOCAL", "Recherche vocale en derja + RAG", M6,
    ["lot:backend", "lot:mobile", "domaine:search", "prio:P0", "sprint:S3+"],
    "**La fonctionnalité différenciante** du document de stratégie. La majorité des artisans "
    "tunisiens ne sont pas à l'aise pour taper de longs textes : le client appuie sur un "
    "bouton et dit *« 3andi fuite fil lavabo mta3 el coujina »*. Le système transcrit, "
    "extrait le métier et le degré d'urgence, et structure la demande.\n\n"
    "Elle mérite un sprint dédié, pas un reste de semaine.",
    ["Enregistrement et compression audio côté mobile",
     "Transcription derja → texte (évaluer les moteurs disponibles pour l'arabe tunisien)",
     "Pipeline RAG : extraction du métier, de la zone et de l'urgence",
     "Restitution structurée à l'artisan",
     "Repli manuel si la transcription échoue — jamais de cul-de-sac"],
    "`strategie_plateforme_artisans.md` §3.B"))

A(E("EP-DURCISSEMENT", "Durcissement, observabilité et préparation au lancement", M6,
    ["lot:socle", "prio:P0", "sprint:S3+", "securite"],
    "Ce qui sépare une application qui marche d'une application qu'on peut exploiter.",
    ["`BE-36` Worker BullMQ : agrégats, expirations, digest hebdomadaire (nécessaire au-delà de ~500 artisans)",
     "`BE-42` Index GIN trigram FR/AR pour la recherche plein texte",
     "`FM-20` Notifications push (Firebase)", "`FM-21` Build et publication iOS",
     "`OPS-01` Déploiement staging et production, migrations avant déploiement",
     "`OPS-02` Sauvegardes PITR + **restauration testée trimestriellement**",
     "`OPS-03` Observabilité : Sentry, logs, PostHog",
     "E2E Maestro sur le parcours cœur mobile",
     "`DOC-05` **ADR-005 — annuaire ou place de marché ?** (question 3 du cadrage)"],
    "Annexe B et D du cadrage"))


# =============================================================================
# REFONTE DESIGN MOBILE COMPLÈTE — audit du 2026-08-31 (Claude, cf. session)
#
# Contexte : audit exhaustif de apps/mobile confronté aux planches de
# maquette fournies par le lead (A. thème sombre — 6 écrans, B. espace
# client clair — 5 écrans dont 1 en arabe/RTL, C. espace artisan clair —
# 3 écrans, D. back-office web — hors périmètre mobile). Conclusion de
# l'audit : le design system existe (tokens, thème clair/sombre, RTL au
# niveau MaterialApp, parité i18n FR/AR) mais n'est presque pas consommé,
# et la moitié des écrans centraux (résultats de recherche, barre de
# navigation, historique, profil client/pro, boosts) n'existent pas.
# Détail complet : `Code/docs/PLAN-REFONTE-DESIGN-MOBILE.md`.
#
# Séquence : Fondations (FM-15→18) → Shell de navigation (FM-19,22→25) →
# câblage des écrans orphelins (FM-26) → Résultats (FM-27→28) → Fiche/
# contact/avis (FM-29→32) → Auth (FM-33) → Onboarding pro (FM-34→36) →
# Pilotage pro (FM-37→39) → Monétisation coquille (FM-40) → Transverse
# (FM-41→43). 4 issues backend (BE-44→47) débloquent des écrans pro.
#
# Assignation : "oussama" partout (DEV-2 sur ce lot, cf. mémoire de
# session) — à corriger à la main si Chayma en reprend une partie.
# =============================================================================

A(I("FM-15", "Générateur de tokens : élévation, motion, tracking, icônes, nouveaux rôles",
    M7, ["type:chore", "lot:mobile", "lot:design", "domaine:providers", "prio:P0", "sprint:S2"],
    OUSSAMA, 4, [],
    "`build-tokens.mjs` perd silencieusement `elevation`, `motion`, le `tracking` "
    "typographique, `layout.breakpoint` et les poids de police lors de l'export Dart "
    "(seuls TS et Tailwind les reçoivent) — c'est le bug SO-08 du backlog non planifié, "
    "plus large que documenté. Il manque aussi des rôles de couleur que les planches "
    "exigent et qui n'existent dans aucun jeu de rôles actuel. Ce lot est un préalable "
    "bloquant : toute la refonte visuelle en dépend et il ne touche que le générateur, "
    "pas les écrans.",
    ["`tokens.json` : thématiser `elevation` (une série claire + une sombre, aujourd'hui "
     "une seule teintée clair) et ajouter `motion` déjà déclaré mais orphelin côté Dart",
     "Ajouter une échelle `iconSize` (xs/sm/md/lg/xl) — ~40 tailles littérales relevées "
     "dans le parcours client à corriger dans les lots suivants",
     "Nouveaux rôles sémantiques `AppColors` : `onWhatsapp` (texte blanc garanti sur "
     "`whatsapp`, `onAccent` ne convient pas en sombre), `amber`/`onAmber` (fond ambre "
     "plein pour le CTA « Renouveler » et l'option de boost sélectionnée), `scrim`/"
     "`onScrim` (voile sur image de couverture), `thumbnail`/`thumbnailBorder` "
     "(vignette carrée des cartes de liste, doit être plus claire que `surface` en "
     "sombre — `surfaceSunken` ne convient pas), `chartBar`/`chartBarHighlight` "
     "(histogramme du tableau de bord), `navActive`/`navInactive`/`navBackground` "
     "(barre de navigation basse)",
     "Résoudre les deux collisions de valeur en thème sombre : `border` == "
     "`surfaceRaised` (aujourd'hui la même couleur, aucune bordure visible) et "
     "`sponsored` == `pending` (mêmes deux teintes dans les deux thèmes)",
     "Exporter `letterSpacing` par palier typographique en Dart (déjà dans `tokens.json`, "
     "perdu au générateur) et ajouter le palier 16px manquant entre body(15) et h3(18)",
     "Exporter `layout.breakpoint` et `typography.weight` en Dart",
     "Corriger `AppColors.copyWith()`/`lerp()` générés (aujourd'hui `copyWith()` sans "
     "paramètre et `lerp()` en palier binaire — le contrat `ThemeExtension` n'est pas "
     "honoré)",
     "Mettre à jour `tokens.json` `$meta.source` pour référencer les nouvelles planches "
     "(actuellement pointé sur l'extraction du 12/08, antérieure à la direction "
     "artistique demandée)"],
    ["Ajouter un palier typographique au-delà de display(36px) pour les très gros "
     "chiffres — `FontFeature.tabularFigures` suffit pour l'alignement en colonne des "
     "3 chiffres de la carte Performance, traité dans FM-37",
     "Régénérer `design-system.html` — traité dans FM-18"],
    ["`pnpm tokens:build` régénère `app_colors.dart`/`app_spacing.dart`/`app_text.dart` "
     "sans erreur, `pnpm tokens:build:check` passe en CI",
     "Les deux collisions de valeur (border/surfaceRaised, sponsored/pending) ont des "
     "valeurs distinctes dans les deux thèmes",
     "`AppElevation.sm/md/lg` (`List<BoxShadow>`) et `AppMotion.durationFast/Base/Slow` "
     "+ `easingStandard/Decelerate` existent en Dart, thématisés clair/sombre pour "
     "l'élévation",
     "`AppIconSize.*` existe et couvre au moins xs(12)/sm(16)/md(20)/lg(24)/xl(32)",
     "Aucun écran existant ne casse (pas de renommage de rôle déjà consommé)"],
    "`Code/packages/design-tokens/tokens.json` · `Code/tooling/scripts/build-tokens.mjs` · "
    "backlog non planifié SO-08 (`backlog/TODO.md`)"))

A(I("FM-16", "ThemeData complet : TextTheme M3 et sous-thèmes de composants",
    M7, ["type:refactor", "lot:mobile", "lot:design", "prio:P0", "sprint:S2"],
    OUSSAMA, 3, ["FM-15"],
    "`buildTheme()` ne renseigne que 8 des ~15 slots `TextTheme` de Material 3 — les "
    "titres d'`AppBar` (`titleLarge`) retombent sur Roboto, y compris en arabe. Aucun "
    "sous-thème de composant n'existe (`appBarTheme`, `bottomSheetTheme`, `dialogTheme`, "
    "`chipTheme`, `snackBarTheme`, `dividerTheme`, `navigationBarTheme`…), ce qui a "
    "produit 10 `AppBar(backgroundColor: colors.surface)` recopiés à l'identique et des "
    "feuilles modales/dialogues qui tombent sur la dérivation algorithmique de "
    "`ColorScheme.fromSeed` au lieu des tokens.",
    ["Compléter `_textThemeFrom` : titleLarge/Medium/Small, labelLarge/Medium, "
     "displayMedium/Small — tous mappés sur `AppText.*` avec la famille par locale",
     "`appBarTheme` (fond `surface`, `titleTextStyle` = h3, `elevation: 0`)",
     "`bottomSheetTheme` (fond `surface`, forme avec `AppRadius.xl` en haut)",
     "`dialogTheme` (fond `surface`)",
     "`chipTheme`, `dividerTheme` (couleur `border`), `snackBarTheme`",
     "`checkboxTheme` / `progressIndicatorTheme` (couleur `accent`)",
     "Supprimer les 10 `AppBar(backgroundColor: colors.surface, ...)` répétés à la main "
     "au profit du thème hérité"],
    ["`navigationBarTheme` détaillé — traité dans FM-22 avec le widget `AppBottomNav` "
     "lui-même, une fois ses rôles de couleur disponibles (FM-15)"],
    ["`flutter analyze` zéro warning après suppression des `AppBar(backgroundColor:)` "
     "répétés",
     "Un `AppBar` sans style explicite affiche son titre en Manrope (FR) / Noto Kufi "
     "Arabic (AR), jamais Roboto — vérifié par un test golden ou un test de style "
     "explicite sur `theme.dart`",
     "`showModalBottomSheet` sans `backgroundColor` explicite prend `colors.surface`, "
     "pas `surfaceContainerLow`",
     "Tests existants (`test/app/`, `test/widget_test.dart`) toujours verts"],
    "`Code/apps/mobile/lib/app/theme.dart` · Material 3 `ThemeData` component themes"))

A(I("FM-17", "Persistance du thème et accessibilité (contraste AA, TextScaler)",
    M7, ["type:feat", "lot:mobile", "lot:design", "prio:P0", "sprint:S2"],
    OUSSAMA, 2, ["FM-15"],
    "`themeModeProvider` n'est ni pré-chargé ni persisté, contrairement à la langue et "
    "au gouvernorat qui suivent le même patron établi (`readInitial*` avant `runApp`, "
    "`ref.listen` pour réécrire) — un utilisateur qui choisit « Sombre » le reperd au "
    "redémarrage. Par ailleurs aucun test ne vérifie le contraste AA des rôles "
    "sémantiques ni le comportement à `TextScaler` élevé, alors que le design system "
    "de référence en fait une règle explicite.",
    ["`persistThemeMode()`/`readInitialThemeMode()` dans `lib/core/theme/`, même patron "
     "que `locale_persistence.dart`",
     "Override dans `main()` + `ref.listen` dans `SanayaApp`, comme `localeProvider`",
     "Script ou test qui calcule le ratio de contraste AA (4,5:1 texte, 3:1 graphique) "
     "pour chaque paire rôle-sur-fond réellement utilisée dans l'app, en clair ET en "
     "sombre — au minimum `textMuted`/`background`, `rating`/`surface`, `onAccent`/"
     "`whatsapp`",
     "Au moins un test widget qui construit un écran représentatif (ex. fiche artisan) "
     "avec `MediaQuery(textScaler: TextScaler.linear(1.3))` et vérifie l'absence "
     "d'overflow"],
    ["Refaire le nuancier visuel complet — traité dans FM-18 (vitrine enrichie)"],
    ["Le thème choisi survit à un redémarrage de l'app (test d'intégration ou test "
     "unitaire de persistance)",
     "Le script de contraste échoue si une paire retombe sous le seuil AA",
     "Le test `TextScaler` 1.3 passe sur au moins 2 écrans à forte densité de texte"],
    "`Code/apps/mobile/lib/core/i18n/locale_persistence.dart` (patron à reprendre) · "
    "`Code/docs/design-system.html` §10"))

A(I("FM-18", "Garde-fou CI anti-valeurs-en-dur et vitrine /_ds-preview enrichie",
    M7, ["type:chore", "lot:mobile", "lot:design", "prio:P1", "sprint:S2"],
    OUSSAMA, 3, ["FM-15", "FM-16"],
    "Le guard-rail « aucune couleur/taille en dur » est déjà enfreint dans du code "
    "mergé (`provider_gallery.dart`, 3 couleurs Material littérales) sans que rien en "
    "CI ne l'ait vu. Complèter le design de ~25 écrans va multiplier ce risque par "
    "cinq. En parallèle, `/_ds-preview` ne couvre que les 10 widgets `core/widgets/` "
    "(aucun widget de feature) et `design-system.html` n'est pas généré depuis "
    "`tokens.json` — il a déjà divergé (ombres sombres propres, palette recopiée à la "
    "main).",
    ["Script `tooling/scripts/style-scan.mjs` (ou règle `dart_code_metrics`/`custom_lint` "
     "si plus simple) qui échoue sur `Colors\\.[a-z]` (hors `Colors.transparent`) et "
     "`Color(0x` hors `core/theme/` généré — branché en CI",
     "Enrichir `/_ds-preview` : nuancier des rôles avec bascule clair/sombre in situ, "
     "échelle typographique visible, tous les widgets de `features/*/presentation/"
     "widgets/` déjà livrés (AvailabilityChip, ReviewTile, DashboardStatCard, "
     "DashboardTrendChart, FavoriteCard, OtpCodeField, RatingStarsInput…)",
     "Passer toutes les chaînes en dur de `design_system_preview_screen.dart` en clés "
     "i18n (namespace `common.devPreview.*` ou équivalent)",
     "Régénérer `Code/docs/design-system.html` depuis `tokens.json` (ajouter comme "
     "8ᵉ cible de `build-tokens.mjs`) au lieu de la palette JS recopiée à la main"],
    ["Rendre `/_ds-preview` inaccessible en build de production — traité dans FM-23 "
     "(suppression du hub `/`, seul point d'accès actuel)"],
    ["Le job CI échoue si un fichier hors `core/theme/` contient une couleur Material "
     "littérale — testé en cassant volontairement `provider_gallery.dart` puis en le "
     "corrigeant dans la même PR",
     "`pnpm tokens:build:check` échoue si `design-system.html` est édité à la main sans "
     "régénération",
     "`/_ds-preview` affiche au moins 20 widgets (10 core + au moins 10 de feature)"],
    "backlog `TODO.md` note DONE FM-04c (précédent de test source-scan sur "
    "`verified_badge.dart`) · `Code/docs/design-system.html`"))

A(I("FM-19", "Clés i18n de navigation FR/AR (onglets, segmented control)",
    M7, ["type:feat", "lot:mobile", "lot:design", "prio:P0", "sprint:S2", "rtl-ar"],
    OUSSAMA, 1, [],
    "Les 8 libellés des deux barres de navigation (Rechercher/Favoris/Historique/Profil "
    "côté client, Tableau de bord/Boosts/Avis/Profil côté pro) et le segmented control "
    "Client|Pro n'existent dans aucun fichier de locale — seul `common.home.*` existe, "
    "et ce sont des libellés de hub de développement. P7 interdit toute chaîne en dur "
    "dans une vue : cette tâche doit précéder l'écriture du widget `AppBottomNav` "
    "(FM-22).",
    ["Ajouter `common.nav.searchTab/favoritesTab/historyTab/profileTab/"
     "dashboardTab/boostsTab/reviewsTab` (FR et AR)",
     "Ajouter `common.nav.switchToClient`/`switchToPro` (segmented control)",
     "Ajouter les micro-labels de la barre de recherche à deux champs : "
     "`search.serviceLabel`/`search.governorateLabel`",
     "Vérifier la parité avec `Code/tooling/scripts/i18n-check.mjs`"],
    [],
    ["`pnpm i18n:check` (ou équivalent) confirme zéro clé manquante entre fr/ et ar/",
     "Chaque nouvelle clé a une traduction arabe distincte, pas une copie du français"],
    "P7 (CLAUDE.md §2) · `Code/packages/i18n/src/locales/{fr,ar}/common.json`"))

A(I("FM-22", "Widget partagé AppBottomNav (RTL, accessibilité)",
    M7, ["type:feat", "lot:mobile", "lot:design", "prio:P0", "sprint:S2", "rtl-ar"],
    OUSSAMA, 2, ["FM-15", "FM-19"],
    "Aucun widget de barre de navigation n'existe dans `core/widgets/` ni dans le "
    "design system de référence (`design-system.html` n'a que 10 sections, aucune de "
    "navigation) — c'est un composant à concevoir avant de l'utiliser dans les deux "
    "shells (FM-23/FM-24), pas seulement à coder.",
    ["`AppBottomNav` : liste d'items (icône + libellé), index actif, callback de "
     "changement, hauteur et cible tactile ≥48dp, `SafeArea` basse incluse",
     "États actif (`navActive`)/inactif (`navInactive`) sur fond `navBackground` "
     "(tokens FM-15)",
     "`Semantics` par item : libellé + état sélectionné annoncé",
     "Miroir RTL automatique via `Directionality` (pas de logique manuelle par locale)",
     "Section dédiée dans `design-system.html` (ou sa régénération FM-18)"],
    ["La logique de shell (`StatefulShellRoute`) elle-même — traitée dans FM-23/FM-24"],
    ["Widget testé en FR et en AR (capture ou test de rendu), 4 items visibles, item "
     "actif visuellement distinct",
     "`flutter test` couvre : tap change l'index, `Semantics` porte le libellé et l'état "
     "sélectionné",
     "Aucune couleur/taille en dur (passe le garde-fou FM-18 s'il est déjà mergé, sinon "
     "revue manuelle)"],
    "`Code/apps/mobile/lib/core/widgets/` · maquettes A1/A2/B3 (barre basse à 4 onglets)"))

A(I("FM-23", "Shell client : navigation persistante à 4 onglets + suppression du hub de dev",
    M7, ["type:feat", "lot:mobile", "prio:P0", "sprint:S2"],
    OUSSAMA, 5, ["FM-22"],
    "`lib/app/router.dart` ne déclare que des `GoRoute` à plat : chaque bascule "
    "d'onglet détruirait l'écran et son scroll/ses filtres. Le hub `/` est un "
    "placeholder de développement livré en production (libellés « — à venir (FM-05) » "
    "visibles par l'utilisateur final) et doit disparaître. Il n'y a non plus aucun "
    "état de démarrage pendant que `AuthStatusKind.unknown` se résout (restauration de "
    "session), ce qui produit un flash d'écran visible sur réseau 3G, ni d'écran "
    "d'erreur de route thémé.",
    ["`StatefulShellRoute.indexedStack` à 4 branches : Rechercher (`/client`), Favoris "
     "(`/client/favorites`), Historique (`/client/history`, écran placeholder « bientôt "
     "disponible » tant que FM-31/BE-45 ne sont pas livrées), Profil (`/client/profile`, "
     "FM-32)",
     "Suppression de `HomeScreen`/`home_screen.dart` et de la route `/`",
     "Écran de démarrage (splash applicatif minimal, sans dépendre d'un logo — asset "
     "de marque hors périmètre, cf. plan) qui attend la résolution de `AuthStatus` "
     "avant de rediriger, en traitant explicitement `AuthStatusKind.unknown`",
     "`errorBuilder` sur le `GoRouter` réutilisant `ErrorState` (thémé, pas la page "
     "d'erreur anglaise par défaut de go_router)",
     "`initialLocation` redirige vers `/client` (anonyme) ou `/auth` selon l'état de "
     "session, jamais vers un écran de choix de rôle brut",
     "Route `/_ds-preview` retirée du routeur de production ou gardée derrière "
     "`kDebugMode`",
     "Réécrire `test/widget_test.dart` (5 cas fondés sur le hub) et "
     "`test/app/router_redirect_test.dart` (l.97-121, « `/` affiche le hub ») pour "
     "refléter le nouveau shell — ne pas les supprimer sans les remplacer (ADR-006)"],
    ["Le shell Pro (FM-24)", "Le contenu de l'onglet Historique lui-même (FM-31)",
     "Le contenu de l'onglet Profil lui-même (FM-32)",
     "Le deep-linking entrant (Android App Links / Universal Links) — décision produit "
     "et infra hors périmètre de cette refonte"],
    ["Un utilisateur anonyme qui lance l'app arrive directement sur l'onglet Rechercher "
     "sans jamais voir de hub de développement",
     "Changer d'onglet préserve le scroll et l'état de chaque branche "
     "(`IndexedStack`, pas de reconstruction)",
     "Le retour arrière Android depuis un onglet secondaire revient à l'onglet "
     "Rechercher avant de quitter l'app (double-retour)",
     "Une route inconnue affiche `ErrorState` thémé, pas la page anglaise par défaut",
     "`flutter test` vert sur les 2 fichiers de test réécrits + tous les tests "
     "existants"],
    "maquettes A1/B3 (barre basse client) · `Code/apps/mobile/lib/app/router.dart` · "
    "ADR-006 (non-régression des tests)"))

A(I("FM-24", "Shell pro : navigation persistante à 4 onglets, dashboard comme racine",
    M7, ["type:feat", "lot:mobile", "prio:P0", "sprint:S2"],
    OUSSAMA, 4, ["FM-22"],
    "`/pro` construit aujourd'hui `OnboardingScreen` sans condition : un artisan déjà "
    "publié qui rouvre l'app retombe dans l'assistant de création de profil avec des "
    "champs vides. Il n'y a aucune garde de route sur l'espace pro (`/pro`/"
    "`/pro/dashboard` accessibles à un utilisateur anonyme, provoquant un 401 affiché "
    "comme une erreur réseau générique).",
    ["`StatefulShellRoute.indexedStack` à 4 branches : Tableau de bord "
     "(`/pro/dashboard`), Boosts (`/pro/boosts`, coquille FM-40), Avis "
     "(`/pro/reviews`, FM-39), Profil (`/pro/profile`, FM-38)",
     "`/pro` (racine) redirige vers `/pro/dashboard` si un profil existe, sinon vers "
     "l'assistant d'onboarding (`/pro/onboarding`, ex-`OnboardingScreen` déplacé) — "
     "note : tant que `GET /v1/providers/me` n'existe pas (BE-44), utiliser un état "
     "local (`publicationStatus` en mémoire après publication) en repli documenté",
     "`redirect:` par branche : un utilisateur non authentifié ou sans rôle PROVIDER "
     "atteignant `/pro/*` est renvoyé vers un état « devenir prestataire », pas vers "
     "une erreur 401 générique"],
    ["Le contenu des onglets Boosts/Avis/Profil eux-mêmes — traité respectivement "
     "dans FM-40/FM-39/FM-38"],
    ["Un artisan publié qui relance l'app arrive directement sur le tableau de bord",
     "Un utilisateur anonyme qui force l'URL `/pro/dashboard` est redirigé, jamais "
     "montré un 401 brut",
     "`test/app/router_redirect_test.dart` mis à jour et vert (le cas actuel « session "
     "restaurée PROVIDER → onboarding » devient conditionnel à l'absence de profil)"],
    "maquette A2/C2 (barre basse pro) · `Code/apps/mobile/lib/app/router.dart`"))

A(I("FM-25", "Corriger la déconnexion et ajouter la bascule Client ↔ Pro",
    M7, ["type:fix", "lot:mobile", "prio:P0", "sprint:S2"],
    OUSSAMA, 2, ["FM-23", "FM-24"],
    "`SettingsScreen._confirmLogout` appelle `authRepository.logout()` SANS argument, "
    "or cette méthode est entièrement gardée par un `if (refreshToken != null)` — "
    "appelée sans argument, elle ne fait rien : ni révocation serveur, ni purge du "
    "token store, ni changement d'état. La méthode correcte, `AuthStateNotifier."
    "signOut()`, existe et révoque/purge réellement, mais n'est appelée nulle part. "
    "Par ailleurs aucune surface n'expose de bascule entre l'espace client et l'espace "
    "pro, alors que `apps/mobile/CLAUDE.md` pose « un artisan est aussi un client » "
    "comme principe fondateur.",
    ["Remplacer l'appel à `logout()` par `ref.read(authStateProvider.notifier)."
     "signOut()` dans l'écran Réglages/Profil (FM-32/FM-38)",
     "Test de régression qui reproduit le bug (déconnexion suivie d'une navigation "
     "vers une route protégée : la garde doit voir `unauthenticated`)",
     "Point de bascule Client↔Pro pour un compte avec le rôle PROVIDER : entrée dans "
     "l'écran Profil (FM-32/FM-38), pas de segmented control dédié en dehors de "
     "l'écran Boosts (A6) qui reste son propre cas (FM-40)"],
    [],
    ["Après déconnexion, toute tentative d'accès à `/client/*` ou `/pro/*` redirige "
     "vers `/auth`",
     "Test de régression écrit AVANT le correctif, vu rouge, puis corrigé — commit "
     "conjoint (POLITIQUE-PROJET §6 règle 2), porte `// régression #<issue>`",
     "Un artisan authentifié peut atteindre l'espace client et revenir à l'espace pro "
     "sans se déconnecter"],
    "`Code/apps/mobile/lib/features/auth/data/auth_repository.dart` · "
    "`Code/apps/mobile/lib/features/auth/application/auth_state_provider.dart` · "
    "`Code/apps/mobile/CLAUDE.md` §Rôle"))

A(I("FM-26", "Câbler les écrans déjà construits mais orphelins",
    M7, ["type:fix", "lot:mobile", "prio:P0", "sprint:S2"],
    OUSSAMA, 2, ["FM-23"],
    "Trois écrans complets et testés sont aujourd'hui inatteignables depuis "
    "l'interface : Favoris, la fiche artisan (deux points d'entrée déclarés mais "
    "jamais branchés) et le bouton d'ajout aux favoris (le repository et le "
    "notifier existent, aucune vue ne les appelle). C'est le gain le plus rapide de "
    "toute la refonte — quelques lignes chacun.",
    ["`CategoryGrid.onTap` dans `search_home_screen.dart` (aujourd'hui `(_) {}`) "
     "navigue vers l'écran de résultats filtré par catégorie (dépend de FM-28, sinon "
     "navigue directement vers `/providers/:slug` si une seule correspondance — à "
     "trancher au moment de FM-28)",
     "`FavoriteCard` dans `favorites_screen.dart` reçoit enfin son `onTap` "
     "(navigation vers `/providers/:slug`)",
     "Bouton cœur sur `ProviderCard` (une fois adopté par FM-27/28) et sur "
     "`ProviderProfileScreen`, appelant `addFavorite`/`removeFavorite` selon "
     "`isFavoriteProvider`",
     "L'état vide de `FavoritesScreen` (`context.go('/client')`) devient une bascule "
     "d'onglet vers Rechercher (`context.go('/client')` reste valide avec un shell à "
     "onglets, mais vérifier qu'il ne remplace pas la pile de façon incompatible)"],
    [],
    ["Un artisan peut être ajouté aux favoris depuis la fiche artisan et depuis la "
     "liste de résultats, puis retiré depuis l'écran Favoris",
     "Taper une catégorie ou une carte favori ouvre la fiche artisan correspondante",
     "Tests widget mis à jour sur les 3 points de navigation"],
    "audit du 2026-08-31 : `favorites_repository.dart:28`, `favorites_providers.dart:"
    "51-53`, `favorite_card.dart:21`"))

A(I("FM-27", "Widgets partagés de recherche : chip de filtre, carte artisan, barre de recherche",
    M7, ["type:feat", "lot:mobile", "lot:design", "prio:P0", "sprint:S2"],
    OUSSAMA, 3, ["FM-15", "FM-16"],
    "Aucun composant de filtre n'existe (4 pilules de l'app sont toutes en lecture "
    "seule). `ProviderCard` — « le composant le plus vu du produit » selon son propre "
    "commentaire — n'est monté sur AUCUN écran de production et rend un avatar "
    "d'initiales au lieu de la vignette carrée des maquettes A1/B3. "
    "`SearchHomeBar` ne correspond à aucune des deux variantes de maquette (A1 : deux "
    "champs côte à côte avec micro-labels · B3 : une seule barre arrondie).",
    ["`AppFilterChip` : état actif (pilule `accent` pleine) / inactif (contour "
     "`border`), utilisable pour Vérifié/Note 4+/Urgence",
     "Réaligner `ProviderCard` sur la maquette : vignette carrée (`thumbnail`, token "
     "FM-15) avec repli sur initiales si aucune image, badge vérifié accolé au nom, "
     "bouton favori, ligne catégorie·ville",
     "Trancher et implémenter UNE référence de barre de recherche pour l'écran de "
     "résultats : la variante à deux champs (A1), qui correspond déjà à la direction "
     "actuelle de `SearchHomeBar` — **hypothèse retenue par défaut, à corriger en "
     "revue si le lead préfère la barre unique de B3** (voir plan, section "
     "Arbitrages). Remplacer le `TextField` brut par `AppTextField`",
     "Retirer `ProviderCard`/`EmptyState`/`OfflineBanner`/`AppSkeleton` de la liste "
     "des widgets \"vitrine seulement\" en les import-testant depuis un écran réel "
     "(FM-28)"],
    ["L'écran de résultats lui-même — FM-28", "La variante barre unique B3 si elle "
     "n'est pas retenue — à consigner dans `backlog/TODO.md` comme différée"],
    ["`AppFilterChip` testé actif/inactif, FR et AR",
     "`ProviderCard` affiche une vignette carrée (image réseau avec placeholder "
     "`thumbnail` et repli erreur), pas un cercle d'initiales",
     "Aucune couleur/taille en dur (passe le garde-fou FM-18)"],
    "maquettes A1 (chips + carte), B3 (barre de recherche) · "
    "`Code/apps/mobile/lib/core/widgets/provider_card.dart`"))

A(I("FM-28", "Écran de résultats de recherche : pagination, filtres, cache disque",
    M7, ["type:feat", "lot:mobile", "prio:P0", "sprint:S2"],
    OUSSAMA, 5, ["FM-27", "FM-23"],
    "C'est l'écran central absent du produit (FM-07 jamais démarrée). Contrairement "
    "au TODO périmé du code (« dépend de BE-16, non livré »), `GET /v1/providers/"
    "search` est déjà exposé et généré côté client (`v1ProvidersSearchGet`) : rien "
    "ne bloque plus côté backend. Sans cet écran, le parcours recherche → fiche → "
    "contact reste coupé en deux et l'onglet racine du shell client (FM-23) n'a rien "
    "à afficher au-delà de la grille de catégories.",
    ["`SearchResultsScreen` (nouvelle route sous l'onglet Rechercher du shell, ex. "
     "`/client/results`) : `ListView.builder` + pagination par curseur (`cursor`/"
     "`limit`, jamais de `Column`+`map`)",
     "Rangée de `AppFilterChip` (FM-27) : Vérifié, Note 4+, Urgence — mappés sur les "
     "paramètres réels de `v1ProvidersSearchGet` (vérifier au contrat lesquels "
     "existent ; si `urgence`/`acceptsEmergency` n'est pas filtrable côté API, "
     "l'afficher désactivé avec un état « bientôt disponible » plutôt que de "
     "l'omettre silencieusement)",
     "Cache disque des résultats ET des fiches déjà consultées (`hive`/`drift`/"
     "`sqflite` à choisir — aucune dépendance de persistance structurée n'existe "
     "encore, seul `shared_preferences` pour des clés simples) : les résultats "
     "restent consultables en mode avion (critère d'acceptation de l'issue #36 "
     "d'origine)",
     "États skeleton (liste de `ProviderCard` grisées, PAS un spinner), vide avec "
     "action « élargir au gouvernorat », erreur avec « Réessayer »",
     "`OfflineBanner` monté en haut de cet écran (premier câblage réel du composant)"],
    ["Le tri (hors périmètre des maquettes fournies)",
     "La recherche vocale (EP-VOCAL, S3+)"],
    ["Défilement fluide sur émulateur bridé en CPU (critère de l'issue d'origine #36)",
     "Les résultats déjà chargés restent consultables en mode avion",
     "L'état vide propose une action utile, pas seulement un message",
     "Aucun écran blanc sur erreur réseau — `OfflineBanner` visible si le device est "
     "hors ligne au lieu de l'état d'erreur générique",
     "Test d'intégration ou widget couvrant : chargement → page suivante → mode "
     "avion → résultat encore visible"],
    "issue #36 (FM-07) · `v1ProvidersSearchGet` (`lib/core/api/generated/src/api/"
    "default_api.dart`) · P5 (CLAUDE.md §2)"))

A(I("FM-29", "Refonte fiche artisan : couverture plein-écran et avatar superposé (RTL)",
    M7, ["type:refactor", "lot:mobile", "lot:design", "prio:P0", "sprint:S2", "rtl-ar"],
    OUSSAMA, 3, ["FM-15"],
    "La fiche artisan pose aujourd'hui un `AppBar` Material au-dessus d'un carrousel "
    "de 220px, alors que A4/B4 montrent une image de couverture qui va jusqu'en haut "
    "d'écran avec un avatar rond superposé chevauchant le bas de l'image (à droite en "
    "RTL). `provider_gallery.dart` contient par ailleurs les 3 seules couleurs "
    "Material en dur de toute la couche `features/` (`Colors.black54/white/white54`), "
    "à corriger avec les rôles `scrim`/`onScrim` de FM-15.",
    ["Retirer l'`AppBar` de `ProviderProfileScreen`, laisser la couverture aller "
     "jusqu'en haut (bouton retour flottant à la place, sur voile `scrim`)",
     "Avatar rond superposé chevauchant le bas de la couverture, aligné à droite en "
     "RTL (`AlignmentDirectional`) — nécessite un champ d'avatar dédié côté API : si "
     "absent du contrat (`V1ProvidersSlugGet200Response` n'expose que `gallery`), "
     "utiliser la première image de la galerie en repli et noter l'écart en commentaire",
     "Corriger les 3 couleurs en dur avec `colors.scrim`/`colors.onScrim` (FM-15)",
     "Remplacer le squelette fait main (`_ProfileSkeleton`, hauteurs en dur) par "
     "`AppSkeleton`",
     "Remplacer le `CircularProgressIndicator.adaptive` de chargement d'image par "
     "`AppSkeleton`"],
    ["Le contenu de la barre de contact — FM-30", "Le formulaire d'avis — FM-30"],
    ["Rendu conforme en thème sombre (A4) et en arabe/RTL (B4) : avatar à droite, "
     "paragraphe de bio `textAlign` justifié à droite en arabe",
     "Aucune couleur Material littérale restante dans `provider_gallery.dart` (le "
     "garde-fou FM-18, une fois mergé, doit passer sur ce fichier)",
     "Test widget avec `Locale('ar')` vérifiant l'alignement de l'avatar"],
    "maquettes A4/B4 · `Code/apps/mobile/lib/features/provider_profile/presentation/"
    "widgets/provider_gallery.dart`"))

A(I("FM-30", "Refonte contact et avis : variante bouton contour, en-tête d'identité",
    M7, ["type:refactor", "lot:mobile", "lot:design", "prio:P1", "sprint:S2", "rtl-ar"],
    OUSSAMA, 2, ["FM-15", "FM-29"],
    "`AppButtonVariant.whatsapp` est un fond vert plein ; les maquettes A4/B4 "
    "veulent Appeler en bleu plein (action principale) et WhatsApp en contour vert "
    "(action secondaire) — l'ordre [Call, WhatsApp] déjà codé est conservé "
    "**par défaut** car il correspond à la hiérarchie voulue et se miroite "
    "correctement en RTL via `Row`+`Directionality` sans logique manuelle (voir plan, "
    "Arbitrages). Le formulaire d'avis n'a par ailleurs aucun en-tête d'identité "
    "(vignette + nom + « Contact vérifié · il y a N jours ») alors que le profil est "
    "déjà chargé en mémoire à cet endroit.",
    ["Nouvelle variante `AppButtonVariant.outlineWhatsapp` (contour `whatsapp`, texte "
     "`whatsapp`, fond transparent) dans `app_button.dart`",
     "`ContactButtons` : Appeler en `primary`, WhatsApp en `outlineWhatsapp`",
     "En-tête de `ReviewFormScreen` : vignette (avatar de FM-29 en repli), "
     "`businessName`, libellé `verifiedContact` déjà traduit mais jamais consommé ici "
     "— le « il y a 2 jours » doit venir du serveur déjà calculé (P3), sinon omettre "
     "la partie relative plutôt que de la calculer côté Dart"],
    ["Les notes par critère (Ponctualité/Qualité du travail) de B5 — nécessitent une "
     "évolution de contrat API, à ouvrir comme issue backend séparée si retenues ; "
     "non incluses ici faute de champ disponible"],
    ["`AppButton` a 6 variantes testées (ajout de `outlineWhatsapp`)",
     "La fiche artisan en arabe affiche Appeler à droite, WhatsApp à gauche "
     "(vérifié par un test widget en `Locale('ar')`)",
     "Le formulaire d'avis affiche qui l'on note avant la première étoile"],
    "maquettes A4/B4 (contact) · A5/B5 (en-tête d'avis) · "
    "`Code/apps/mobile/lib/core/widgets/app_button.dart`"))

A(I("FM-31", "Onglet Historique client",
    M7, ["type:feat", "lot:mobile", "prio:P1", "sprint:S2", "blocked"],
    OUSSAMA, 3, ["FM-23"],
    "Quatrième — en réalité troisième — onglet de la barre client (A1/B3). Aucun "
    "concept d'historique n'existe dans le produit alors que retrouver un artisan "
    "contacté est la fonction de rétention la plus évidente d'un modèle "
    "lead-generation, et le déclencheur naturel du dépôt d'avis. ⛔ Bloqué : le "
    "contrat n'expose que `POST /v1/contact-events` (écriture), aucun `GET` de "
    "lecture — voir `BE-45`.",
    ["Écran `ClientHistoryScreen` sous `/client/history` : liste des artisans "
     "contactés, triée par date de contact décroissante, avec le canal (Appel/"
     "WhatsApp) et un raccourci vers le dépôt d'avis si aucun avis n'est encore posé",
     "États skeleton/vide (« Vous n'avez encore contacté aucun artisan » + CTA vers "
     "Rechercher)/erreur",
     "En attendant `BE-45`, l'onglet peut afficher un état « Bientôt disponible » "
     "shippable dès FM-23 — cette issue couvre l'écran final une fois l'API prête"],
    [],
    ["L'écran affiche la liste réelle une fois `BE-45` livrée, avec pagination par "
     "curseur",
     "Taper une entrée ouvre la fiche artisan correspondante",
     "Le CTA de dépôt d'avis n'apparaît que si aucun avis n'a encore été posé pour ce "
     "contact"],
    "maquette A1/B3 (onglet Historique) · `BE-45` (dépendance bloquante)"))

A(I("FM-32", "Onglet Profil client",
    M7, ["type:feat", "lot:mobile", "prio:P0", "sprint:S2"],
    OUSSAMA, 2, ["FM-23", "FM-25"],
    "Quatrième onglet client. `SettingsScreen` porte déjà langue/thème/mentions "
    "légales/déconnexion mais est aujourd'hui inatteignable (aucun appelant) et ne "
    "montre aucune identité utilisateur. `GET /v1/auth/me` est déjà disponible.",
    ["`ClientProfileScreen` sous `/client/profile` : en-tête d'identité (nom/"
     "téléphone masqué depuis `GET /v1/auth/me`), puis les sections déjà construites "
     "de `SettingsScreen` (langue, thème — désormais persisté via FM-17, mentions "
     "légales, déconnexion via `signOut()` — FM-25)",
     "Fusionner `SettingsScreen` dans cet écran plutôt que de dupliquer (déplacer, "
     "pas copier) ; `/settings` peut rediriger vers `/client/profile` pour compat "
     "des liens existants ou être retiré du routeur"],
    [],
    ["Un client authentifié voit son numéro masqué et peut changer de langue/thème/"
     "se déconnecter depuis cet onglet",
     "Les tests de `settings_screen_test.dart` migrés et verts sur le nouvel écran"],
    "maquette A1/B3 (onglet Profil) · `Code/apps/mobile/lib/features/settings/"
    "presentation/settings_screen.dart` (contenu à reprendre)"))

A(I("FM-33", "Refonte de l'authentification : marque, mention légale, bouton Confirmer",
    M7, ["type:refactor", "lot:mobile", "lot:design", "prio:P0", "sprint:S2"],
    OUSSAMA, 3, ["FM-15", "FM-16"],
    "L'étape de sélection de rôle (`AuthStep.role`) n'apparaît dans aucune des "
    "maquettes A3/B1 (qui ouvrent directement sur la saisie du numéro) — "
    "**hypothèse retenue par défaut : la supprimer**, le rôle réel étant de toute "
    "façon déterminé côté serveur, pas par ce choix (voir plan, Arbitrages). Il "
    "manque par ailleurs le sous-titre, la mention légale CGU/confidentialité (B1), "
    "le bouton « Confirmer » de l'écran OTP (déjà traduit, jamais affiché — la "
    "soumission est aujourd'hui 100% automatique à la 6ᵉ touche, ce qui consomme une "
    "tentative sur 3 sans confirmation possible) et le format mm:ss du compte à "
    "rebours.",
    ["Retirer `AuthStep.role`/`RoleSelectionStep` du flux (le rôle sert uniquement à "
     "l'aiguillage post-connexion, déjà géré par la garde `redirect:` sur "
     "`GET /auth/me`) — si le lead préfère le garder, cette tâche se limite alors à "
     "le redessiner dans le style des planches",
     "`phone_entry_step.dart` : sous-titre `auth.phoneSubtitle` (nouvelle clé), filet "
     "séparant `+216` du champ (nouveau `prefix` sur `AppTextField`, FM-27/16 selon "
     "dépendance), mention légale `auth.legalConsent` centrée en bas avec lien vers "
     "`LegalNoticeScreen`",
     "`otp_step.dart` : bouton `AppButton` « Confirmer » (clé `otpCta` déjà traduite) "
     "en plus de la soumission auto à la 6ᵉ touche — les deux chemins restent valides, "
     "le bouton permet de corriger avant envoi",
     "Fonction `formatCountdown(seconds) → mm:ss` dans `lib/core/i18n/format.dart`, "
     "clé `otpResendCountdown` mise à jour au format « Renvoyer le code ({mmss}) »",
     "Remplacer `Theme.of(context).textTheme.*` par `AppText.*` dans les 3 widgets "
     "d'auth (seuls de l'app dans ce cas)",
     "Réécrire les tests d'auth cassés par le retrait de l'étape rôle"],
    ["Le logo/tuile de marque (asset visuel absent de `assets/`, à fournir par le "
     "lead — sans lui, garder un espace réservé neutre plutôt qu'une image manquante)"],
    ["La saisie du numéro affiche sous-titre + mention légale + `+216` séparé par un "
     "filet",
     "L'écran OTP affiche un bouton Confirmer ET soumet automatiquement à la 6ᵉ "
     "touche",
     "Le compte à rebours affiche `0:47`, pas `47s`",
     "`flutter test` vert sur `test/features/auth/`"],
    "maquettes A3/B1 (saisie numéro) · B2 (code OTP) · "
    "`Code/apps/mobile/lib/features/auth/presentation/`"))

A(I("FM-34", "Refonte onboarding pro : étapes, catégories sélectionnables, plafonds",
    M7, ["type:refactor", "lot:mobile", "lot:design", "prio:P0", "sprint:S2"],
    OUSSAMA, 4, ["FM-15", "FM-16", "FM-24"],
    "Quatre sources donnent quatre décomptes d'étapes différents (code : 4 · issue "
    "FM-11 d'origine : 5 · ADR-003 : 3 · maquette C1 : « sur 7 »). Le « 7 » de C1 "
    "correspond très probablement aux 7 critères de `calculateCompletionScore`, pas "
    "à des étapes — **hypothèse retenue par défaut : garder un parcours à étapes "
    "réelles (profil/catégories/zones/photos/récapitulatif = 5, cf. FM-35), afficher "
    "« Étape N sur 5 » et NE PAS reprendre le « sur 7 » littéral de la maquette, "
    "réservé à un futur indicateur de complétude séparé** (voir plan, Arbitrages, à "
    "corriger si le lead tranche autrement). Par ailleurs les plafonds serveur (3 "
    "catégories, 1 gouvernorat) ne sont ni appliqués ni expliqués côté client : "
    "l'artisan est bloqué sans comprendre pourquoi.",
    ["`OnboardingProgressHeader` : « Étape N sur 5 » + barre SEGMENTÉE (un segment "
     "par étape) + libellé de l'étape courante aligné à droite — séparé de "
     "`completionScore` qui reste affiché ailleurs (récapitulatif) mais plus ici",
     "Carte de catégorie sélectionnable (nouveau composant partagé, cf. FM-41) : fond "
     "`accentSubtle` si sélectionnée, badge « Principal » sur la catégorie "
     "principale, ✓ sur les suivantes — remplace le `Checkbox`+`ChoiceChip` bruts",
     "Plafond de 3 catégories appliqué côté UI (désactiver la sélection au-delà, "
     "sous-titre « 3 catégories maximum en offre gratuite »), avec le message "
     "d'erreur serveur (`details.limit`) affiché si l'utilisateur le dépasse malgré "
     "tout",
     "Même traitement pour le plafond de 1 gouvernorat sur l'étape zones",
     "Remplacer les deux `CircularProgressIndicator` (catégories, zones) par "
     "`AppSkeleton`, et les erreurs ad hoc par `ErrorState`",
     "Namespace `errors.json` : au moins le mapping `VALIDATION_ERROR` avec "
     "`details.limit` interpolé"],
    ["L'étape tarifs (bloquée par l'absence d'endpoint d'écriture `offerings` — voir "
     "`BE-47`, hors périmètre tant que non livré)",
     "L'étape photos (traitée séparément dans FM-35, backend déjà prêt)"],
    ["Un artisan qui essaie de sélectionner une 4ᵉ catégorie voit l'option désactivée "
     "avec une explication, pas un blocage silencieux au moment de sauvegarder",
     "Même critère pour un 2ᵉ gouvernorat",
     "L'en-tête affiche « Étape N sur 5 » avec le bon N à chaque étape",
     "`flutter test` vert sur `test/features/onboarding/`"],
    "maquette C1 · `Code/apps/api/src/routes/providers.ts:661-666,718-723` (plafonds "
    "serveur) · `Code/packages/core/src/providers/completion-score.ts`"))

A(I("FM-35", "Étape photos/portfolio de l'onboarding (upload + compression)",
    M7, ["type:feat", "lot:mobile", "prio:P0", "sprint:S2"],
    OUSSAMA, 3, ["FM-34"],
    "Contrairement aux tarifs, le backend est entièrement prêt (`POST /v1/media/"
    "presign`, `POST /v1/media/{id}/process`, `POST`/`DELETE /providers/me/"
    "portfolio`, BE-20a→d livrées) mais aucun code mobile ne les appelle — c'est un "
    "pur manque côté app. Sans upload, toute fiche hors seed de démonstration n'aura "
    "aucune photo, alors que A4/B4 ouvrent justement sur une image de couverture "
    "plein écran.",
    ["Nouvelle étape `OnboardingStep.photos` entre zones et récapitulatif",
     "`image_picker` (ou équivalent déjà dans l'écosystème Flutter standard) + "
     "compression avant upload — max 1600px, qualité 80, conforme à "
     "`apps/mobile/CLAUDE.md`",
     "Flux `presign` → upload direct → `process` → `POST /providers/me/portfolio`, "
     "avec état de progression par image et gestion d'erreur par image (pas "
     "d'échec global si une seule image échoue)",
     "Quota FREE (5 photos, `plan-limits.ts`) affiché et appliqué côté UI",
     "Suppression d'une photo déjà uploadée (`DELETE /providers/me/portfolio/{id}`)"],
    [],
    ["Un artisan peut ajouter jusqu'à 5 photos, en voir la progression d'upload, et "
     "en supprimer une",
     "Une image dépassant le quota affiche un message explicite, pas un échec "
     "silencieux",
     "Test d'intégration du flux presign→process→portfolio avec un mock du client "
     "généré"],
    "`backlog/DONE.md` (BE-20a→d livrées) · `Code/packages/core/src/billing/"
    "plan-limits.ts` · `apps/mobile/CLAUDE.md` (compression images)"))

A(I("FM-36", "Reprise de l'onboarding après fermeture de l'application",
    M7, ["type:feat", "lot:mobile", "prio:P1", "sprint:S2", "blocked"],
    OUSSAMA, 2, ["FM-34"],
    "Critère d'acceptation de l'issue FM-11 d'origine (« sauvegarde à chaque étape, "
    "reprise possible ») jamais tenu au-delà de la session en cours : "
    "`OnboardingNotifier` documente lui-même la limite (« reprise : session-memory "
    "uniquement »). ⛔ Bloqué par `GET /v1/providers/me`, absent du contrat — voir "
    "`BE-44`, la dépendance transverse la plus structurante de tout l'espace pro "
    "(elle débloque aussi FM-37/38/39).",
    ["Au montage de `OnboardingScreen`, appeler `GET /providers/me` (une fois "
     "`BE-44` livrée) et pré-remplir chaque étape depuis la réponse plutôt que depuis "
     "l'état local vide",
     "Si aucun profil n'existe encore (404 ou champ `publicationStatus` absent), "
     "démarrer à l'étape 1 comme aujourd'hui"],
    [],
    ["Un artisan qui a rempli les 2 premières étapes puis tué l'app retrouve ses "
     "données au relancement, sur la bonne étape",
     "Un nouvel artisan sans profil démarre toujours à l'étape 1"],
    "`Code/apps/mobile/lib/features/onboarding/application/onboarding_notifier.dart:17` "
    "· `BE-44` (dépendance bloquante)"))

A(I("FM-37", "Refonte tableau de bord pro : salutation, carte KPI, histogramme",
    M7, ["type:refactor", "lot:mobile", "lot:design", "prio:P0", "sprint:S2"],
    OUSSAMA, 4, ["FM-15", "FM-16", "FM-24"],
    "Le tableau de bord actuel n'a rien de la structure A2/C2 : pas de salutation "
    "« Bonjour, <nom> », pas de badge de disponibilité, 4 tuiles dispersées au lieu "
    "d'une carte bleue pleine regroupant 3 chiffres, une courbe au lieu d'un "
    "histogramme de 7 barres, aucun état vide pour l'artisan fraîchement publié (cas "
    "majoritaire au lancement avec 20 artisans de seed).",
    ["En-tête « Bonjour, <businessName ou prénom> » — nécessite de lire son propre "
     "nom : en attendant `BE-44`, replier sur `GET /auth/me` (prénom) plutôt que de "
     "bloquer tout l'écran",
     "Badge de disponibilité (`AvailabilityChip` promu en composant commutable, cf. "
     "FM-38 pour l'écriture réelle — ici l'affichage seul, en lecture, tant que "
     "`BE-44` n'expose pas l'état courant)",
     "`DashboardStatCard` : nouvelle variante `onAccent` regroupant 3 métriques dans "
     "une seule `AppCard` à fond `accent` plein (au lieu de 4 tuiles séparées) — "
     "**la ventilation Appels/WhatsApp de la maquette dépend de `BE-46`** ; en son "
     "absence, afficher Vues/Contacts/Ratio (métriques déjà disponibles)",
     "Nouveau widget `AppBarChart` (7 barres, une mise en avant en `chartBarHighlight`) "
     "remplaçant `DashboardTrendChart` pour la fenêtre 7 jours — la courbe 30 jours "
     "existante peut rester en complément ou être retirée, à trancher en revue",
     "État vide explicite si `totals.profileViews == 0` : message encourageant "
     "plutôt que des zéros bruts"],
    ["La carte Pack Pro/Renouveler — traitée dans FM-40 (dépend d'EP-BILLING)"],
    ["L'en-tête affiche un nom réel, jamais un espace vide ni un placeholder de "
     "développement",
     "Un artisan à 0 vue voit un message d'accueil, pas 3 cartes à zéro",
     "L'histogramme affiche 7 barres avec la barre du jour courant mise en avant",
     "`flutter test` vert sur `test/features/dashboard/`"],
    "maquettes A2/C2 · `BE-44` (nom/disponibilité), `BE-46` (ventilation canaux) — "
    "dépendances partielles, non totalement bloquantes"))

A(I("FM-38", "Écran Profil pro : édition post-onboarding et disponibilité commutable",
    M7, ["type:feat", "lot:mobile", "prio:P0", "sprint:S2", "blocked"],
    OUSSAMA, 3, ["FM-24"],
    "Aujourd'hui la seule façon de corriger sa bio ou son téléphone est de "
    "retraverser l'assistant d'onboarding avec des champs vides (FM-36 le corrige "
    "partiellement). Le badge de disponibilité n'a jamais d'`onChanged`, alors que "
    "`PATCH /v1/providers/me` accepte déjà `availabilityStatus`. ⛔ Bloqué en lecture "
    "par `GET /v1/providers/me` (`BE-44`) pour pré-remplir l'écran ; l'écriture "
    "(`PATCH`) est déjà disponible et peut être développée en parallèle.",
    ["`ProProfileScreen` sous `/pro/profile` (4ᵉ onglet) : formulaire d'édition "
     "réutilisant les champs de `OnboardingProfileStep`, pré-rempli depuis "
     "`GET /providers/me`",
     "Badge de disponibilité commutable (AVAILABLE/BUSY/ON_HOLIDAY) avec écriture "
     "`PATCH /providers/me`",
     "Champs de disponibilité fine (`availableAgainAt`, `acceptsEmergency`, "
     "`workingHours`) — au moins `acceptsEmergency`, qui alimente le chip « Urgence » "
     "des résultats de recherche (FM-28) et resterait sinon un filtre client sans "
     "artisan opt-in",
     "Bouton « Voir ma fiche telle que la voit un client » → `/providers/:slug` "
     "(nécessite de connaître son propre slug, donc `BE-44`)",
     "Accès aux réglages (langue/thème/déconnexion, réutilise le contenu de FM-32)"],
    [],
    ["Un artisan peut modifier sa bio sans repasser par l'onboarding et voir le "
     "changement reflété sur sa fiche publique",
     "Basculer sa disponibilité en Occupé se reflète immédiatement sur la fiche "
     "publique (invalider `providerProfileProvider`)",
     "Activer « Accepte les urgences » rend l'artisan trouvable par le futur filtre "
     "Urgence"],
    "maquette A2/C2 (4ᵉ onglet pro) · `BE-44` (dépendance bloquante pour la lecture)"))

A(I("FM-39", "Écran Avis reçus (pro)",
    M7, ["type:feat", "lot:mobile", "prio:P1", "sprint:S2", "blocked"],
    OUSSAMA, 2, ["FM-24"],
    "Troisième onglet pro. L'artisan n'a aujourd'hui aucun moyen de consulter les "
    "avis qui le concernent sans connaître son propre slug public. ⛔ Bloqué par "
    "`GET /v1/providers/me` (`BE-44`) pour connaître ce slug ; la lecture des avis "
    "elle-même réutilise `GET /providers/{slug}/reviews`, déjà au contrat.",
    ["`ProReviewsScreen` sous `/pro/reviews` : réutilise `providerReviewsProvider` "
     "avec le slug de l'artisan connecté (via `BE-44`)",
     "Skeleton/vide (« Aucun avis reçu pour l'instant »)/erreur",
     "Répondre à un avis reçu — hors périmètre tant que `BE-22b` (modèle "
     "`ReviewReply`) n'est pas livré ; noter le point d'extension dans l'écran "
     "(bouton désactivé ou masqué) sans bloquer le reste"],
    ["La réponse de l'artisan à un avis (BE-22b, backlog non planifié)"],
    ["L'artisan voit la liste paginée de ses propres avis, dans le même style que "
     "la fiche publique (`ReviewTile` réutilisé)",
     "L'écran affiche un état vide explicite pour un artisan sans avis"],
    "maquette A2 (3ᵉ onglet pro) · `BE-44` (dépendance bloquante) · `backlog/"
    "TODO.md` BE-22b (réponse aux avis, non planifiée)"))

A(I("FM-40", "Écran Boosts/crédits — coquille visuelle (sans tunnel de paiement)",
    M7, ["type:feat", "lot:mobile", "lot:design", "prio:P2", "sprint:S3+", "needs-decision"],
    OUSSAMA, 3, ["FM-15", "FM-16", "FM-24"],
    "⛔ Le tunnel d'achat réel dépend d'EP-BILLING (BE-32/34/35), bloqué par l'ADR-004 "
    "non tranchée (moyens de paiement, question 2 du cadrage). Cette issue couvre "
    "UNIQUEMENT la coquille et les états visuels des maquettes A6/C3 : solde de "
    "crédits, bouton Acheter (désactivé ou vers un état « bientôt disponible »), "
    "section Activer un boost avec options sélectionnables, sans aucune écriture "
    "réelle de paiement ou de crédit.",
    ["Segmented control Client|Pro en en-tête (nouveau composant, cf. FM-41)",
     "Carte « Solde de crédits » avec valeur figée à 0 tant que `BE-34` n'existe pas, "
     "bouton Acheter menant à un état « Bientôt disponible »",
     "Cartes d'option de boost sélectionnables (24h/7j) avec état sélectionné "
     "(fond `amber`, token FM-15) — contenu statique, aucun appel réseau",
     "Namespace i18n `billing.*` rempli pour tout le vocabulaire visible (FR et AR) "
     "— aujourd'hui `{}` dans les deux langues"],
    ["Tout appel réseau réel de crédit/paiement — dépend d'EP-BILLING/ADR-004",
     "L'écran Abonnement/Pack Pro détaillé — issue séparée à ouvrir une fois "
     "BE-32 planifiée"],
    ["Les 2 planches (A6 sombre, C3 clair) sont rendues à l'identique visuellement, "
     "sans qu'aucun bouton ne déclenche un appel réseau de paiement",
     "`billing.json` FR et AR n'est plus `{}`",
     "Revue explicite du guard-rail ADR-002 sur cet écran avant merge"],
    "maquettes A6/C3 · `EP-BILLING` (issues-data.py) · ADR-002 (badge gratuit)",
    ["⚠️ **Guard-rail ADR-002** : aucun élément de cet écran ne doit suggérer que "
     "payer rend « vérifié » — vérifié par le test de non-régression déjà actif "
     "`verified_badge_test.dart` (aucune mention de `Subscription` dans "
     "`verified_badge.dart`)",
     "Le boost est explicitement étiqueté « Sponsorisé », jamais présenté comme "
     "modifiant le classement de recherche"]))

A(I("FM-41", "Composants partagés transverses : Badge, carte sélectionnable, bottom sheet",
    M7, ["type:feat", "lot:mobile", "lot:design", "prio:P0", "sprint:S2"],
    OUSSAMA, 3, ["FM-15", "FM-16"],
    "Cinq pilules ad hoc (`AvailabilityChip`, `CoverageAreaChip`, "
    "`DashboardComparisonChip._Chip`, la copie dans `ReviewTile`, celle dans "
    "`provider_gallery.dart`) réimplémentent le même composant que FM-04f décrivait "
    "déjà et personne n'a construit. Deux feuilles modales divergentes existent pour "
    "sélectionner un gouvernorat. Trois écrans traitent différemment le même motif "
    "de barre d'action fixe en bas.",
    ["`AppBadge` générique (variantes pending/danger/neutral/sponsored/verified) — "
     "clôture FM-04f ; migrer les 5 réimplémentations pour qu'elles le consomment",
     "`AppSelectableCard` : carte avec état sélectionné (fond `accentSubtle`), badge "
     "optionnel (« Principal »), utilisée par FM-34 (catégories) et FM-40 (boosts)",
     "`AppBottomSheet` : poignée de glissement, titre, `SafeArea`, états loading/"
     "vide/erreur — remplace `governorate_picker_sheet.dart` ET le sélecteur "
     "dupliqué de `onboarding_profile_step.dart`",
     "`AppSectionHeader`/`AppDivider` partagés (aujourd'hui `_SectionHeader` privé "
     "dans `settings_screen.dart`, recopié différemment ailleurs)",
     "`StickyActionBar` : conteneur `surface` + filet supérieur + `SafeArea`, "
     "généralisant `_ContactBar` (aujourd'hui privé à la fiche artisan) — utilisé par "
     "FM-30 (contact), FM-30 (publier l'avis), FM-34 (Continuer), FM-40 (Activer le "
     "boost)"],
    [],
    ["Les 5 pilules ad hoc sont remplacées par `AppBadge` (grep négatif sur les "
     "implémentations privées)",
     "Une seule implémentation de feuille modale de sélection dans tout le dépôt",
     "`AppSelectableCard` testé sélectionné/non sélectionné, FR et AR"],
    "backlog non planifié FM-04f · audit du 2026-08-31 (doublons `etats-widgets`)"))

A(I("FM-42", "Adoption systématique EmptyState/ErrorState/AppSkeleton + bandeau hors ligne",
    M7, ["type:refactor", "lot:mobile", "prio:P0", "sprint:S2"],
    OUSSAMA, 3, ["FM-23", "FM-24", "FM-41"],
    "`EmptyState` n'est utilisé par aucun écran de production, `ErrorState` par un "
    "seul, et 3 des 4 squelettes existants recopient `Container(surfaceSunken)` à la "
    "main au lieu d'`AppSkeleton` — 8 réimplémentations locales identifiées par "
    "l'audit. `OfflineBanner` et `ConnectivityService` sont tous deux livrés et "
    "testés mais ne sont jamais reliés : le service n'a aucun consommateur.",
    ["Remplacer les 8 réimplémentations locales (`_CategoriesError`/`_CategoriesEmpty` "
     "dans `search_home_screen.dart`, `_FavoritesEmptyView`/`_FavoritesErrorView`, "
     "`_ProfileError`, les erreurs ad hoc de l'onboarding déjà traitées par FM-34, "
     "l'erreur d'avis de la fiche artisan) par `EmptyState`/`ErrorState`",
     "Corriger le bug distinct relevé en chemin : `provider_profile_screen.dart` "
     "affiche une erreur de chargement des avis comme « Aucun avis pour le moment » "
     "— la branche `error` doit utiliser `ErrorState` avec un vrai bouton Réessayer",
     "Remplacer les 3 squelettes faits main (`FavoriteCardSkeleton`, "
     "`ProviderGallerySkeleton`, `CategoryGridSkeleton`) par des compositions "
     "d'`AppSkeleton`",
     "Monter `OfflineBanner` au niveau des deux shells (FM-23/FM-24), au-dessus des "
     "onglets, piloté par `connectivityServiceProvider` — un seul point de câblage "
     "plutôt qu'un par écran"],
    [],
    ["`grep 'EmptyState('` et `grep 'ErrorState('` renvoient au moins un usage par "
     "écran de liste (résultats, favoris, avis, avis reçus pro)",
     "Couper le réseau (mode avion) fait apparaître `OfflineBanner` sur n'importe "
     "quel écran des deux shells, sans qu'aucun écran individuel n'ait à le coder",
     "Le test de régression du bug avis-erreur-affiché-comme-vide passe (écrit "
     "avant le correctif, vu rouge, `// régression #<issue>`)"],
    "audit du 2026-08-31 (`etats-widgets`, note 6a/6b) · "
    "`Code/apps/mobile/lib/core/connectivity/connectivity_provider.dart`"))

A(I("FM-43", "Passe accessibilité : Semantics, TextScaler, contraste",
    M7, ["type:chore", "lot:mobile", "prio:P1", "sprint:S2"],
    OUSSAMA, 3, ["FM-22", "FM-27", "FM-29", "FM-33", "FM-34", "FM-37"],
    "Une seule annotation `Semantics` existe dans toute l'application "
    "(`category_grid.dart:70`). Les boutons de contact, les étoiles de notation, les "
    "badges et les puces de variation sont muets pour un lecteur d'écran — un angle "
    "mort complet sur un produit visant l'usage sur chantier, potentiellement avec "
    "des gants. Cette issue passe après les refontes visuelles pour éviter de "
    "retravailler deux fois les mêmes widgets ; elle peut néanmoins démarrer en "
    "parallèle sur les widgets déjà stables (RatingStars, VerifiedBadge).",
    ["`Semantics`/`semanticLabel` sur : `RatingStars`/`RatingStarsInput` (note "
     "annoncée en texte, pas 5 icônes muettes), `VerifiedBadge`, `AppBadge` (FM-41), "
     "`ContactButtons`, `AppBottomNav` (déjà couvert par FM-22, vérifier ici), les 6 "
     "cases `OtpCodeField`",
     "Appliquer `AppLayout.touchTarget` (48dp) aux `Checkbox`/cases interactives de "
     "l'onboarding, aujourd'hui non vérifiées",
     "Étendre le test `TextScaler` 1.3 de FM-17 à au moins 3 écrans supplémentaires "
     "(résultats, tableau de bord, onboarding)",
     "Documenter la checklist d'accessibilité dans `apps/mobile/CLAUDE.md` (absente "
     "aujourd'hui de la checklist de PR) pour qu'elle soit opposable en revue comme "
     "l'i18n"],
    [],
    ["Un lecteur d'écran (TalkBack) annonce correctement la note, le badge vérifié "
     "et l'état de chaque bouton de contact",
     "`flutter analyze` ne signale aucune cible tactile sous 48dp sur les écrans "
     "audités",
     "`apps/mobile/CLAUDE.md` référence désormais une checklist a11y"],
    "audit du 2026-08-31 (`a11y-motion` partiel + occurrences relevées dans "
    "`parcours-client`/`parcours-pro`/`etats-widgets`)"))

# --- Issues backend débloquant l'espace pro (identifiées par l'audit design) -------

A(I("BE-44", "GET /v1/providers/me — lire son propre profil artisan",
    M1, ["type:feat", "lot:backend", "domaine:providers", "prio:P0", "sprint:S2", "contrat-api"],
    OUSSAMA, 3, [],
    "Dépendance transverse la plus structurante identifiée par l'audit design mobile "
    "du 2026-08-31 : sans cette route, un artisan connecté ne peut lire ni son "
    "`businessName` (salutation du tableau de bord), ni son `availabilityStatus` "
    "(badge commutable), ni son propre `slug` (aperçu de fiche, avis reçus), ni "
    "pré-remplir l'onboarding pour le reprendre après fermeture de l'app. Elle "
    "débloque à elle seule FM-36/37/38/39. Absente de `backlog/TODO.md` — ce n'est "
    "pas un report assumé, c'est un trou détecté a posteriori.",
    ["`GET /v1/providers/me` : renvoie le `ProviderProfile` complet du compte "
     "authentifié (même forme que `GET /providers/{slug}` côté champs, plus les "
     "champs privés utiles à l'édition : `availabilityStatus`, `availableAgainAt`, "
     "`acceptsEmergency`, `workingHours`, `publicationStatus`, `completionScore`)",
     "401 si non authentifié, 403 si le compte n'a pas le rôle PROVIDER",
     "Régénérer `contracts/openapi.json` et le client Dart"],
    [],
    ["Test d'intégration : profil existant → 200 avec les champs privés ; aucun "
     "profil créé → 404 explicite (pas un 500) ; rôle CLIENT → 403",
     "`pnpm api:contract --check` vert après régénération",
     "Aucune donnée d'un AUTRE artisan ne fuite (la route ne prend aucun paramètre, "
     "l'identité vient exclusivement du token)"],
    "audit design mobile 2026-08-31 (note transverse n°1, section `parcours-pro`) · "
    "P3 (CLAUDE.md §2, l'API renvoie ce que le mobile doit afficher déjà calculé)"))

A(I("BE-45", "GET /v1/contact-events — historique de lecture pour le client",
    M1, ["type:feat", "lot:backend", "domaine:contact", "prio:P1", "sprint:S2", "contrat-api"],
    OUSSAMA, 3, [],
    "`POST /v1/contact-events` existe (écriture, P9) mais aucune route de lecture ne "
    "permet à un client de retrouver les artisans qu'il a contactés — débloque "
    "l'onglet Historique côté mobile (FM-31), le déclencheur naturel du dépôt d'avis.",
    ["`GET /v1/contact-events` : pagination par curseur, filtrée sur "
     "`userId = ` l'utilisateur authentifié, triée par `createdAt` décroissant",
     "Chaque item renvoie déjà les libellés calculés nécessaires à l'affichage "
     "(nom/slug/vignette de l'artisan, canal, date) — P3 : pas de second appel "
     "`GET /providers/:slug` par item côté mobile",
     "Champ indiquant si un avis a déjà été posé pour ce contact (pour le CTA "
     "conditionnel de FM-31)"],
    [],
    ["Test d'intégration : un utilisateur ne voit que SES propres contacts, jamais "
     "ceux d'un autre compte",
     "Pagination par curseur testée sur >1 page",
     "`pnpm api:contract --check` vert"],
    "audit design mobile 2026-08-31 (`navigation`, gap « Onglet Historique ») · P9 "
    "(CLAUDE.md §2)"))

A(I("BE-46", "Ventilation des contacts par canal dans GET /providers/me/stats",
    M1, ["type:feat", "lot:backend", "domaine:analytics", "prio:P2", "sprint:S2", "contrat-api"],
    OUSSAMA, 2, [],
    "La maquette A2 affiche « 47 Appels / 63 WhatsApp » ; l'API n'expose aujourd'hui "
    "qu'un total `contacts` agrégé. La donnée est déjà collectée (`ContactEvent."
    "channel: PHONE|WHATSAPP`), seule l'agrégation par canal manque — voisin de "
    "`BE-43` déjà noté au backlog non planifié pour `DailyProviderStat`.",
    ["Étendre `GET /v1/providers/me/stats` avec `contactsByChannel: { phone, "
     "whatsapp }` dans `totals` (et éventuellement dans la série journalière si "
     "l'histogramme de FM-37 en a besoin)",
     "`packages/core/src/analytics/provider-stats.ts` : ventiler l'agrégation "
     "existante par `channel` sans dupliquer la logique de comptage"],
    [],
    ["Test unitaire `packages/core` : un jeu de `ContactEvent` mixte produit le bon "
     "compte par canal",
     "Aucun changement de forme cassant pour les consommateurs existants du champ "
     "`contacts` agrégé (additif, pas de breaking change)"],
    "audit design mobile 2026-08-31 (`parcours-pro`, gap « Ventilation des "
    "contacts ») · voisin de `BE-43` (backlog non planifié)"))

A(I("BE-47", "Écriture des offerings (tarifs) sous /providers/me/*",
    M1, ["type:feat", "lot:backend", "domaine:providers", "prio:P2", "sprint:S2", "contrat-api"],
    OUSSAMA, 3, [],
    "La fiche artisan publique lit déjà `offerings` avec `displayPrice`, mais aucune "
    "route d'écriture n'existe sous `/providers/me/*` — c'est le seul vrai manque "
    "BACKEND (non planifié) qui bloque une étape entière des maquettes (tarifs, "
    "listée au périmètre de l'issue FM-11 d'origine mais jamais livrée).",
    ["`POST`/`PATCH`/`DELETE /v1/providers/me/offerings` : titre, description, prix "
     "en millimes (jamais de float, P4/§4.1), affichage optionnel du prix",
     "Validation métier dans `packages/core` (pas dans la route, P3) — au minimum un "
     "prix positif et un titre non vide",
     "Régénérer `contracts/openapi.json` et le client Dart"],
    [],
    ["Test d'intégration cas passant + au moins un cas d'erreur (prix négatif "
     "rejeté)",
     "`pnpm api:contract --check` vert",
     "`calculateCompletionScore` peut être étendu pour noter ce champ si le lead le "
     "décide — hors périmètre de cette issue, à ouvrir séparément"],
    "audit design mobile 2026-08-31 (`parcours-pro`, gap « Étape Tarifs ») · "
    "`backlog/DONE.md:149`"))

# =============================================================================
# Rendu du corps d'issue
# =============================================================================
def body(it):
    p = []
    p.append(f"> **ID backlog** `{it['id']}`"
             + (f" · **Estimation** {it['est']} h" if it["est"] else "")
             + (f" · **Dépend de** {', '.join('`'+d+'`' for d in it['deps'])}" if it["deps"] else ""))
    p.append("")
    p.append("## Contexte\n\n" + it["context"])
    if it["scope"]:
        head = "## Contient" if "type:epic" in it["labels"] else "## Périmètre"
        p.append(f"\n{head}\n\n" + "\n".join(f"- [ ] {s}" for s in it["scope"]))
    if it["out"]:
        p.append("\n## Hors périmètre (volontairement)\n\n" + "\n".join(f"- {s}" for s in it["out"]))
    p.append("\n## Critères d'acceptation\n\n" + "\n".join(f"- [ ] {s}" for s in it["accept"]))
    if it["guard"]:
        p.append("\n## 🚧 Guard-rails\n\n" + "\n".join(f"- {s}" for s in it["guard"]))
    p.append("\n## Références\n\n" + it["refs"])
    p.append("\n---\n<sub>Issue générée depuis `tooling/scripts/issues-data.py` — "
             "source unique : `backlog/TODO.md`. Voir `CLAUDE.md` pour les guard-rails globaux.</sub>")
    return "\n".join(p)


# Marque toutes les issues du lot "refonte design mobile" avec le label REFONTE,
# pour que `ONLY=refonte-design-mobile gh-seed-issues.sh` ne touche qu'elles —
# les ~90 issues S1-S6 déjà créées sur GitHub restent intactes.
REFONTE_IDS = {
    "FM-15", "FM-16", "FM-17", "FM-18", "FM-19", "FM-22", "FM-23", "FM-24",
    "FM-25", "FM-26", "FM-27", "FM-28", "FM-29", "FM-30", "FM-31", "FM-32",
    "FM-33", "FM-34", "FM-35", "FM-36", "FM-37", "FM-38", "FM-39", "FM-40",
    "FM-41", "FM-42", "FM-43", "BE-44", "BE-45", "BE-46", "BE-47",
}
for _it in ISSUES:
    if _it["id"] in REFONTE_IDS:
        _it["labels"].append(REFONTE)
missing = REFONTE_IDS - {it["id"] for it in ISSUES}
if missing:
    sys.exit(f"issues-data.py: REFONTE_IDS introuvables dans ISSUES : {sorted(missing)}")


out = []
for it in ISSUES:
    out.append({
        "id": it["id"], "title": it["title"], "milestone": it["milestone"],
        "labels": it["labels"], "assignee": it["assignee"],
        "estimate": it["est"], "deps": it["deps"], "body": body(it),
    })

json.dump(out, sys.stdout, ensure_ascii=False, indent=2)
sys.stdout.write("\n")
print(f"\n… {len(out)} issues générées", file=sys.stderr)
