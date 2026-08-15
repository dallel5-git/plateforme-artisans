# ADR-001 — Mobile en Flutter, contrat d'API en REST/OpenAPI

- **Statut** : Accepté
- **Date** : 2026-08-15
- **Décideurs** : Oussama Dallel (product/tech lead), DEV-1, DEV-2
- **Remplace** : §3.1 (ligne « Mobile ») et §3.3 décision n°2 du *Document de Cadrage Technique v1.0*
- **Impacte** : `Code/apps/mobile`, `Code/packages/api`, `Code/packages/ui-native`, `Code/packages/ui-logic`, CI mobile

---

## 1. Contexte

Le cadrage technique v1.0 retenait **Expo / React Native + tRPC v11**, avec pour argument principal le
*max code sharing* : le même routeur typé consommé par le Web, le Mobile et l'Admin, sans client HTTP
écrit à la main (principe **P2**).

Le document de stratégie produit (`strategie_plateforme_artisans.md`) retient **Flutter**, pour trois
raisons : fluidité native perçue sur Android d'entrée de gamme, stabilité sur réseau dégradé, et un
seul rendu identique iOS/Android.

**Arbitrage rendu le 2026-08-15 : Flutter pour le mobile, Next.js pour le web et l'admin.**

Cette décision n'est pas neutre : elle invalide mécaniquement le pilier technique du cadrage. Il faut
donc reconstruire le contrat d'API sur une autre base, sinon on hérite du pire des deux mondes
(un typage tRPC que le mobile ne peut pas consommer, et un client Dart écrit à la main qui dérive).

---

## 2. Conséquence directe : tRPC devient inutilisable côté mobile

tRPC n'est pas un protocole, c'est une astuce de typage TypeScript : le client **importe le type**
`AppRouter` du serveur. Il n'existe pas d'équivalent en Dart, et il n'y en aura pas.

Conserver tRPC signifierait :

| Option écartée | Pourquoi |
|---|---|
| tRPC + client Dart écrit à la main | Retour exact au problème que tRPC devait résoudre : dérive de contrat garantie, et cette fois sur la plateforme **principale** du produit. |
| tRPC + `trpc-to-openapi` (façade REST) | Deux surfaces à maintenir, annotations `.meta({openapi})` sur chaque procédure, support partiel des types complexes, et un décalage permanent entre ce que voit le Web et ce que voit le Mobile. La complexité est payée deux fois. |
| GraphQL | Résout le typage multi-langage, mais ajoute schéma + résolveurs + codegen + N+1 pour **un seul consommateur contrôlé**. Coût d'apprentissage non budgétable sur un sprint d'une semaine. |

---

## 3. Décision

### 3.1 Un serveur d'API autonome : `apps/api` (Fastify + Zod + OpenAPI)

Le serveur tRPC hébergé dans `apps/web` (cadrage §3.3 décision n°3) est remplacé par une application
Node autonome :

```
Code/apps/api/            Fastify 5 + @fastify/swagger + fastify-type-provider-zod
  src/
    server.ts             bootstrap, plugins, graceful shutdown
    plugins/              cors, helmet, rate-limit, jwt, request-id, sentry
    routes/               une route = un module métier, schéma Zod in/out
    openapi.ts            génération du fichier openapi.json
```

**Zod reste la source unique de vérité** (principe P4 préservé) : les schémas de
`packages/validators` valident les entrées **et** produisent le document OpenAPI 3.1 automatiquement
via `fastify-type-provider-zod`. Aucun schéma n'est écrit deux fois, aucun YAML OpenAPI n'est
maintenu à la main.

### 3.2 Le contrat n'est plus un type TypeScript, c'est `openapi.json`

```
packages/validators (Zod)
        │
        ▼
  apps/api  ──────► contracts/openapi.json  (versionné dans git, généré par `pnpm api:contract`)
                            │
              ┌─────────────┴─────────────┐
              ▼                           ▼
    openapi-typescript            openapi-generator-cli (dart-dio)
              │                           │
              ▼                           ▼
   apps/web + apps/admin           apps/mobile/lib/api/ (client Dart généré)
   (openapi-fetch, typé)           (Dio + Retrofit + freezed)
```

**Règle absolue** : `contracts/openapi.json` est **généré**, jamais édité à la main. La CI échoue si
le fichier commité diffère de celui régénéré depuis les schémas Zod (`pnpm api:contract --check`).
C'est le remplaçant du garde-fou que tRPC offrait gratuitement.

### 3.3 Ce qui reste inchangé

Les principes **P1, P3, P4, P5, P6, P7, P8, P9, P10** du cadrage sont intégralement préservés :

| Package | Statut | Consommé par |
|---|---|---|
| `packages/db` (Prisma 6 / PostgreSQL 16) | ✅ inchangé | `apps/api`, `apps/worker` |
| `packages/core` (domaine pur : ranking, policies, éligibilité) | ✅ inchangé, **c'est le vrai actif** | `apps/api` |
| `packages/validators` (Zod) | ✅ inchangé, devient aussi la source OpenAPI | `apps/api`, `apps/web`, `apps/admin` |
| `packages/constants`, `packages/utils` | ✅ inchangé côté TS | web/admin/api |
| `packages/design-tokens` | 🔄 devient **multi-cible** : génère `.ts` (Tailwind) **et** `.dart` | web/admin/mobile |
| `packages/i18n` | 🔄 catalogues FR/AR en JSON neutre, consommés par i18next (web) **et** `flutter_localizations`/`slang` (mobile) |
| `packages/ui-native` (NativeWind) | ❌ **supprimé** | — |
| `packages/ui-logic` (hooks headless RN/Web) | ⚠️ **réduit au web uniquement** | web/admin |

Le principe **P3** (« la logique métier ne connaît ni React ni HTTP ») est ce qui sauve cette bascule :
tout ce qui coûte cher à écrire — l'algorithme de ranking (Annexe A), la note bayésienne, les policies
RBAC, l'éligibilité au boost — vit dans `packages/core` et n'est pas concerné par le choix Flutter.

### 3.4 Stack mobile Flutter retenue

| Besoin | Choix | Justification |
|---|---|---|
| SDK | **Flutter 3.24+ / Dart 3.5+** | Stable, Impeller par défaut sur Android (rendu fluide sur entrée de gamme — l'argument même de la bascule) |
| Navigation | **go_router** | Routing déclaratif par URL, deep links `tel:` / `wa.me`, aligne le modèle mental sur celui du Web |
| État serveur | **Riverpod 2 (AsyncNotifier)** | Équivalent Dart de TanStack Query : cache, invalidation, états loading/error normalisés |
| HTTP | **Dio + Retrofit**, généré depuis OpenAPI | Intercepteurs (JWT, refresh rotatif, retry, offline), client jamais écrit à la main |
| Modèles | **freezed + json_serializable** | Immutabilité, `copyWith`, union types pour les états — générés depuis le contrat |
| Stockage sécurisé | **flutter_secure_store** | Keystore Android / Keychain iOS pour le refresh token (jamais en `SharedPreferences`) |
| Images | **cached_network_image** + WebP servi par le CDN | Principe P5 (low-bandwidth-first) |
| i18n / RTL | **slang** + `Directionality` | FR/AR dès le jour 1 (principe P7) |
| Push | **firebase_messaging** | Remplace Expo Push Notifications (hors périmètre semaine 1) |
| Tests | `flutter_test` + `mocktail`, E2E **Maestro** | Maestro était déjà le choix du cadrage, il est agnostique du framework |

---

## 4. Conséquences

### 4.1 Positives

- Un **contrat d'API explicite, versionné et lisible** (`openapi.json`) — un atout pour l'audit, pour un futur partenaire, et pour l'onboarding d'un 3ᵉ développeur.
- Le rendu mobile est **identique et prévisible** sur tous les Android, sans dépendre du pont JS.
- `apps/api` autonome supprime le point de vigilance du cadrage §3.3-3 (trafic mobile pesant sur le rendu web). Le déploiement se fait sur un conteneur dédié.
- Le worker BullMQ partage le même conteneur de base que l'API : une image Docker, deux commandes.

### 4.2 Négatives — assumées

- **Le partage de code chute de ~70 % à ~40 %.** Seuls le backend, le web et l'admin partagent du TypeScript. Tout l'écran mobile est réécrit en Dart.
- **Deux langages, deux outillages, deux CI.** Avec 2 développeurs, cela signifie qu'un seul portera le mobile après la semaine 1 : c'est un risque de bus factor à documenter.
- La logique de présentation (formatage TND, libellés de statuts, règles d'affichage) doit être **portée manuellement** en Dart. Mitigation : elle est concentrée dans `packages/core` côté serveur et exposée par l'API sous forme déjà calculée (`displayPrice`, `badgeLabel`) plutôt que recalculée sur deux clients.
- Perte du hot-reload cross-plateforme unifié et des mises à jour OTA d'Expo Updates. Un correctif mobile passe par un build EAS-équivalent (Codemagic / GitHub Actions + Fastlane) et une review store.

### 4.3 Points de non-retour

Cette décision est **coûteuse à annuler après le jour 4** de la semaine 1 : au-delà, du code Dart de
présentation existe. Les jours 1 à 3 (backend) sont en revanche **totalement réversibles** — c'est
exactement pourquoi le plan de la semaine 1 place le backend en premier, les deux développeurs
ensemble.

---

## 5. Règles d'application (guard-rails)

1. Aucun `fetch` / `http.get` écrit à la main dans `apps/mobile`, `apps/web` ou `apps/admin`. On passe par le client généré.
2. `contracts/openapi.json` est régénéré et commité dans la **même PR** que tout changement de route ou de schéma Zod.
3. Aucune règle métier dans `apps/api/src/routes/` : la route valide, appelle `packages/core`, sérialise. Si un `if` métier apparaît dans une route, il descend dans `core`.
4. Aucune règle métier dupliquée en Dart. Si le mobile a besoin d'un calcul, l'API le renvoie.
5. `packages/ui-native` est supprimé du workspace, pas laissé vide (sinon il sera importé par erreur).

---

## 6. Références

- Cadrage technique v1.0 — §3.1, §3.2, §3.3, §4
- `strategie_plateforme_artisans.md` — §3.C « Choix technologiques »
- ADR-002 — Nature du badge « Artisan Vérifié »
