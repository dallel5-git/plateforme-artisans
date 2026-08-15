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
