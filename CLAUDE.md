# Sanaya — Mémoire projet & Guard-rails

> Ce fichier est lu automatiquement par Claude au démarrage de chaque session, pour **DEV-1 et DEV-2**.
> Il est la mémoire longue du projet. **Ne pas le laisser dériver** : toute décision structurante prise
> en session doit y être reportée (ou dans un ADR) avant la fin de la journée, sinon elle est perdue.

---

## 0. Ce qu'il faut savoir en 30 secondes

**Sanaya** est une plateforme tunisienne de **mise en relation** entre particuliers et artisans
(plomberie, électricité, peinture, climatisation…). Modèle **lead generation, sans intermédiation de
paiement de la prestation** : la plateforme met en contact, elle n'encaisse jamais le montant du
chantier.

- **Cible de lancement** : le Sahel (Sousse, Monastir, Mahdia) avant toute expansion nationale.
- **Monétisation** : gratuit pour le particulier ; abonnement Pack Pro + crédits/boosts pour l'artisan.
- **Équipe** : 2 développeurs (DEV-1, DEV-2) + Claude en pair-programmer sur chaque poste.
- **Documents de référence, dans cet ordre de priorité** :
  1. `Code/docs/01-architecture-decision-records/` — les ADR **priment** sur tout le reste (ADR-001 Flutter · ADR-002 badge · ADR-003 périmètre S1)
  2. `Assets/cadrage-technique-plateforme-artisans-tn.md` — le contrat technique (schéma Prisma, user stories, index SQL)
  3. `Code/docs/POLITIQUE-PROJET.md` — comment on travaille
  4. `Code/docs/PLAN-MVP-SEMAINE-1.md` — ce qu'on fait cette semaine
  5. `backlog/TODO.md` / `backlog/DOING.md` / `backlog/DONE.md` — l'état réel

⚠️ **Le cadrage v1.0 dit « Expo / React Native + tRPC ». C'est OBSOLÈTE.** L'ADR-001 l'a remplacé par
**Flutter (mobile) + Next.js (web/admin) + API REST Fastify/OpenAPI**. Si tu lis une contradiction,
l'ADR gagne.

---

## 1. Architecture — vue à retenir

```
apps/web (Next.js 15)     apps/admin (Next.js 15)     apps/mobile (Flutter 3.24)
  Client + vitrine SEO      Back-office                  Client + Espace Pro
        │                        │                            │
        │  openapi-fetch typé    │                            │  Dio + Retrofit généré
        └────────────────────────┴──────────┬─────────────────┘
                                            │
                              contracts/openapi.json  ← GÉNÉRÉ, jamais édité
                                            │
                              ┌─────────────▼──────────────┐
                              │ apps/api (Fastify + Zod)   │  transport uniquement
                              │ auth · rbac · rate-limit   │
                              └─────────────┬──────────────┘
                                            │
                              ┌─────────────▼──────────────┐
                              │ packages/core              │  ⭐ LE VRAI ACTIF
                              │ ranking · policies · règles│  zéro dépendance HTTP/React
                              └─────────────┬──────────────┘
                                            │
        ┌──────────────┬────────────────────┼──────────────┬───────────────┐
   packages/db    packages/storage   packages/notif   packages/payments  apps/worker
   Prisma+PG16    R2 (S3)            SMS/Push          Konnect/…         BullMQ+Redis
```

**Modular monolith, pas de microservices.** Un seul serveur d'API découpé en modules métier étanches :
`auth`, `catalog`, `providers`, `search`, `reviews`, `billing`, `ads`, `moderation`, `analytics`.

---

## 2. Les 10 invariants (principes du cadrage — non négociables)

| # | Invariant | Ce que ça t'interdit concrètement |
|---|---|---|
| **P1** | Modules métier étanches | Ne jamais importer un fichier interne d'un autre module. Passer par son `index.ts`. |
| **P2** | Le contrat d'API est généré, pas documenté | Ne jamais écrire un client HTTP à la main, ni éditer `openapi.json`. |
| **P3** | La logique métier ignore React et HTTP | Aucun `req`, `res`, `Request`, `BuildContext` dans `packages/core`. |
| **P4** | Une seule source de vérité pour les données | Le schéma Prisma. Ne jamais redéclarer un type de domaine à la main. |
| **P5** | Mobile-first, **low-bandwidth-first** | Pagination par curseur obligatoire, images WebP + variantes, jamais de `SELECT *` renvoyé au client. |
| **P6** | Le SEO est un canal d'acquisition critique | Les pages `/[gouvernorat]/[service]` sont en SSG/ISR avec JSON-LD `LocalBusiness`. Jamais en client-side rendering. |
| **P7** | Bilingue FR/AR + RTL **dès le jour 1** | Aucune chaîne de caractères en dur dans une vue. Tout passe par une clé i18n. |
| **P8** | Conformité INPDP by design | La CIN ne transite jamais par un bucket public, ne s'affiche jamais sans URL signée courte, ne se logge jamais. |
| **P9** | Tout événement de valeur est traçable | Vue de profil, clic téléphone, clic WhatsApp, impression en recherche : si ce n'est pas tracé, l'abonnement Pro est invendable. |
| **P10** | Anti-fraude structurel | Rate limiting sur OTP/contacts/avis/uploads, déduplication par empreinte de session, avis rattaché à un `ContactEvent` réel. |

---

## 3. 🚧 GUARD-RAILS — les interdits absolus

Ces règles sont **bloquantes**. Si une tâche semble en exiger la violation, **s'arrêter et demander à
Oussama**, ne pas contourner.

### 3.1 Sécurité & données personnelles

- ❌ **Ne jamais** logger, sérialiser, ou renvoyer dans une réponse API : numéro de CIN, image de CIN, OTP, mot de passe, refresh token, numéro de téléphone complet d'un artisan non contacté.
- ❌ **Ne jamais** stocker un OTP en clair. Hash + TTL + 3 tentatives max.
- ❌ **Ne jamais** committer un secret, une clé, un `.env`, une URL de base de données. `.env.example` uniquement, avec des valeurs factices.
- ❌ **Ne jamais** exposer un numéro de téléphone dans le HTML brut d'une page SEO (scraping). Révélation via appel API tracé et rate-limité uniquement.
- ✅ Bucket `private-kyc` : chiffré, non public, URL signée **5 minutes**, chaque accès journalisé dans `AuditLog`.
- ✅ Toute autorisation est vérifiée **côté serveur** dans `packages/core/policies`. Un contrôle côté client est un confort d'UX, jamais une sécurité.

### 3.2 Base de données

- ❌ **Ne jamais** modifier une migration déjà mergée sur `main`. On ajoute une migration.
- ❌ **Ne jamais** faire `prisma db push` sur autre chose que sa base locale jetable.
- ❌ **Ne jamais** supprimer physiquement un `User` : soft delete (`deletedAt`) + anonymisation (téléphone haché, nom → « Utilisateur supprimé »). Les avis restent publiés anonymement.
- ❌ **Ne jamais** effacer une donnée comptable par cascade (`Payment`, `CreditTransaction`, `Plan`) → `onDelete: Restrict`.
- ✅ Les contraintes `CHECK`, index partiels et index GIN du cadrage §2.3 vivent dans une migration SQL manuelle dédiée. Ne pas les oublier lors d'un `prisma migrate reset`.
- ✅ `CreditTransaction` est un **journal immuable** : on insère, on ne met jamais à jour.

### 3.3 Architecture

- ❌ **Aucune règle métier dans `apps/api/src/routes/`.** Une route : valide (Zod) → appelle `core` → sérialise. Si un `if` métier apparaît, il descend dans `packages/core`.
- ❌ **Aucune règle métier dupliquée en Dart.** Si le mobile a besoin d'un calcul, l'API renvoie le résultat déjà calculé (`displayPrice`, `badgeLabel`, `distanceLabel`).
- ❌ **Aucun accès Prisma depuis `apps/web`, `apps/admin` ou une route sans passer par `core`/`db`.**
- ❌ Pas de microservice, pas de nouveau déploiement, pas de nouvelle brique d'infra sans ADR.
- ✅ Toute dépendance nouvelle en `dependencies` (pas `devDependencies`) se justifie en PR.

### 3.4 Le badge « Vérifié » (ADR-002)

- ❌ **Aucun code ne doit lire `subscription.status` pour décider de l'affichage du badge `isVerified`.** Le badge atteste de l'identité, jamais du plan payant. Test de non-régression obligatoire dans `packages/core/tests/ranking.test.ts`.

### 3.5 Périmètre

- ❌ **`apps/web` n'existe pas en S1** (ADR-003). Ne pas commencer une page Next.js cette semaine, même « vite fait pour tester ».
- ❌ **Ne pas coder ce qui n'est pas dans `backlog/TODO.md` pour le sprint courant.** Une idée qui surgit → une ligne dans `backlog/TODO.md` section « Backlog non planifié », et on continue.
- ❌ Ne pas commencer une tâche marquée `blocked-by` tant que sa dépendance n'est pas en `DONE`.

---

## 4. Conventions de code

### 4.1 TypeScript (api / web / admin / packages)

- **Nommage** : `camelCase` pour les variables et fonctions, `PascalCase` pour les types et composants, `SCREAMING_SNAKE_CASE` pour les constantes exportées.
- **Fichiers** : `kebab-case.ts`. Un composant React = `PascalCase.tsx`.
- **Pas de `any`.** Si le typage résiste, `unknown` + narrowing, jamais `any` ni `@ts-ignore` sans commentaire justifiant.
- **Pas de `export default`** sauf contrainte du framework (pages Next.js).
- **Erreurs** : jamais de `throw new Error("...")` nu côté domaine. Utiliser les erreurs typées de `packages/core/errors` avec un code de `packages/constants/error-codes.ts`.
- **Async** : `async/await`, jamais de `.then()` chaîné. Toujours gérer le cas d'erreur.
- **Dates** : tout est stocké et transporté en **UTC ISO-8601**. Le fuseau `Africa/Tunis` n'est appliqué qu'à l'affichage.
- **Argent** : jamais de `float`. Montants en **millimes** (entier, 1 TND = 1000 millimes), formatés par `packages/utils/currency.ts`.
- **Téléphone** : normalisé `+216XXXXXXXX` par `packages/utils/phone-tn.ts` avant toute écriture en base.

### 4.2 Dart / Flutter (apps/mobile)

- **Nommage** : `lowerCamelCase` variables/méthodes, `UpperCamelCase` classes, `snake_case.dart` fichiers.
- **Arborescence par feature**, pas par type :
  `lib/features/<feature>/{data,domain,presentation}/`
- **Aucun widget de plus de ~150 lignes.** Extraire.
- **`const` partout où c'est possible** (perf de rebuild sur Android d'entrée de gamme — c'est l'argument même de la bascule Flutter).
- **Aucun `setState` pour de l'état serveur** : Riverpod `AsyncNotifier`.
- **Aucune couleur ni taille en dur** : `AppColors.*` / `AppSpacing.*` générés depuis `packages/design-tokens`.
- **Aucun `String` en dur affiché** : passer par `slang` (`t.search.title`).
- Lints : `flutter_lints` + `very_good_analysis`. Zéro warning toléré en PR.

### 4.3 API REST — conventions (voir `Code/docs/02-api-conventions.md`)

- Ressources au pluriel, kebab-case : `GET /v1/providers`, `POST /v1/contact-events`.
- Pagination **par curseur** uniquement : `?cursor=<opaque>&limit=20` → `{ items, nextCursor }`.
- Réponse d'erreur normalisée :
  ```json
  { "error": { "code": "PROVIDER_NOT_FOUND", "message": "…", "details": {} }, "requestId": "…" }
  ```
- Les codes viennent de `packages/constants/error-codes.ts`. Le `message` est destiné au développeur ; le client affiche une traduction locale à partir du `code`.
- Toute route est versionnée sous `/v1`. Aucun *breaking change* dans une version publiée.

---

## 5. Commandes utiles

```bash
# --- Racine du monorepo (Code/) ---
pnpm install                 # installe tout le workspace
pnpm dev                     # api + web + admin en parallèle (turbo)
pnpm lint                    # eslint sur tout le repo
pnpm typecheck               # tsc --noEmit partout
pnpm test                    # vitest (unitaires + intégration)
pnpm api:contract            # régénère contracts/openapi.json
pnpm api:contract --check    # échoue si le contrat commité est périmé (CI)

# --- Base de données ---
pnpm db:up                   # docker compose : postgres + redis
pnpm db:migrate              # prisma migrate dev
pnpm db:seed                 # référentiel géo TN + catégories + jeu de démo
pnpm db:reset                # reset + migrate + seed (base locale uniquement !)
pnpm db:studio               # prisma studio

# --- Mobile ---
cd apps/mobile
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # freezed + retrofit + slang
flutter run
pnpm mobile:client           # (depuis la racine) régénère le client Dart depuis openapi.json
```

---

## 6. Comment travailler avec moi (Claude)

### Ce que j'attends de toi au début d'une session

Dis-moi **quel ID de tâche** tu attaques (`BE-03`, `FW-07`…). Je lis `backlog/TODO.md`, le plan de la
semaine, et je te propose un découpage avant d'écrire du code.

### Ce que je fais systématiquement

1. Je lis les ADR et ce fichier avant de proposer une architecture.
2. J'écris le **test avant** l'implémentation pour tout ce qui touche `packages/core`.
3. Je ne modifie pas de fichier hors du périmètre de la tâche annoncée sans le dire.
4. À la fin d'une tâche, je te propose la ligne à déplacer de `TODO.md` vers `DONE.md`.

### Ce que je ne ferai pas sans ton accord explicite

- Ajouter une dépendance en `dependencies`
- Créer une migration Prisma destructive
- Modifier un ADR ou ce fichier
- Toucher à `contracts/openapi.json` autrement qu'en le régénérant
- Élargir le périmètre du sprint

### Format de rapport que je te donne en fin de tâche

```
Tâche  : BE-03 — Auth OTP
Fichiers touchés : packages/auth/src/otp.ts, apps/api/src/routes/auth.ts, +2 tests
Tests  : 7 passés / 0 échoué
Contrat: openapi.json régénéré (2 routes ajoutées)
Reste  : rate-limit par IP à brancher (créé BE-03b dans TODO)
```

---

## 7. Glossaire métier

| Terme | Sens précis dans ce projet |
|---|---|
| **Prestataire / Artisan** | `ProviderProfile`, lié 1-1 à un `User` de rôle `PROVIDER` |
| **Lead / Contact** | `ContactEvent` — un clic « appeler » ou « WhatsApp » tracé. C'est l'unité de valeur vendue. |
| **Avis certifié** | `Review` rattachée à un `ContactEvent` réel (1-1, unique). Garde-fou anti-faux-avis (P10). |
| **Vérifié** | `ProviderProfile.isVerified` — identité CIN validée. **Gratuit** (ADR-002). |
| **Boost** | Emplacement sponsorisé **hors ranking**, explicitement étiqueté « Sponsorisé ». N'altère jamais le `rankingScore`. |
| **Gouvernorat / Délégation** | Découpage administratif tunisien. 24 gouvernorats, ~264 délégations. Référentiel figé, seedé. |
| **Complétude** | `completionScore` /100 — moteur d'activation de l'artisan, pondéré dans le ranking. |
| **Millime** | 1/1000 TND. Unité de stockage de tous les montants. |

---

## 8. Journal des décisions

| Date | Décision | Trace |
|---|---|---|
| 2026-08-15 | Mobile en **Flutter**, web/admin en Next.js, API REST/OpenAPI autonome | ADR-001 |
| 2026-08-15 | Badge « Vérifié » **gratuit**, fondé sur la CIN, indépendant de l'abonnement | ADR-002 |
| 2026-08-15 | Sprint 1 = **MVP mobile en 7 jours** : socle + backend à deux (J1→J4 matin), puis **les 2 devs sur Flutter** (J4 pm→J7) | ADR-003 |
| 2026-08-15 | **`apps/web` reporté au sprint S2.** Livrer web et mobile en parallèle avec 2 devs demandait 159 h-homme pour 112 disponibles | ADR-003 |
| 2026-08-15 | Périmètre coupé du MVP : KYC upload, paiements, boosts, régie pub, back-office, push, `ServiceRequest`, recherche vocale | `PLAN-MVP-SEMAINE-1.md` §3 |

> **Règle** : toute nouvelle ligne ici doit pointer vers un ADR ou un document. Une décision sans trace
> écrite sera re-débattue dans trois semaines.
