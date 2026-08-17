# HISTORIQUE.md — Mémoire complète du projet Sanaya

> **Fichier maître.** Il contient tout ce qu'il faut savoir sur ce projet : l'architecture, les
> décisions, les règles, l'état d'avancement et l'historique daté des changements.
>
> **À qui il s'adresse** : à Oussama, à Chayma, et à **tout assistant conversationnel (Claude,
> ChatGPT, Copilot…) à qui on donne ce fichier**. Après l'avoir lu, un assistant doit pouvoir
> travailler sur Sanaya sans poser de question sur le contexte.
>
> Dernière mise à jour : **2026-08-15**
> Version du document : **1.0**

---

# ⚠️ SECTION 0 — CONSIGNES POUR L'ASSISTANT (à lire en premier, à appliquer toujours)

Si tu es un assistant IA et qu'on vient de te donner ce fichier, voici tes obligations.

### 0.1 Avant d'écrire la moindre ligne

1. **Lis ce fichier en entier.** Il prime sur ton intuition et sur tes habitudes.
2. **Vérifie la hiérarchie des sources.** En cas de contradiction, l'ordre de priorité est :
   1. Les **ADR** (§2) — ils tranchent, définitivement.
   2. Ce fichier (`HISTORIQUE.md`).
   3. `CLAUDE.md` racine et `CLAUDE.md` par lot.
   4. `docs/POLITIQUE-PROJET.md`, `docs/PLAN-MVP-SEMAINE-1.md`.
   5. Le *Document de Cadrage Technique v1.0* — **partiellement obsolète** (voir §2.1).
3. **Respecte les 10 invariants (§5) et les guard-rails (§6).** Ils sont bloquants. Si une tâche
   semble exiger leur violation : **arrête-toi et demande à Oussama**. Ne contourne jamais.
3bis. **Écris le test avec le code, jamais après** (ADR-006, §12.2). Pour une correction de bug :
   le test **d'abord**, tu le vois échouer, puis tu corriges. Un test écrit après ne prouve rien.
   Ne supprime jamais un test marqué `🔒 NON-RÉGRESSION`.
4. **Ne code que ce qui est dans le sprint courant.** Une idée hors périmètre = une ligne dans
   `backlog/TODO.md` § « Backlog non planifié », pas un commit.

### 0.2 🔴 RÈGLE ABSOLUE — mettre ce fichier à jour

> **Toute modification ou ajout au projet DOIT être inscrit dans ce fichier, dans la même session
> de travail.** Un changement non écrit ici est un changement perdu : la session suivante repartira
> d'une carte fausse.

**Ce qui déclenche obligatoirement une mise à jour :**

| Tu as… | Tu mets à jour |
|---|---|
| ajouté / supprimé / renommé un `app` ou un `package` | §3.2 (arborescence) + §3.1 (schéma) + §13 (journal) |
| modifié le schéma Prisma | §3.6 (modèle de données) + §13 |
| ajouté / modifié / supprimé une route d'API | §3.7 (surface d'API) + §13 |
| **écrit du code sans test** | ❌ **interdit** (ADR-006) — ajoute le test, ou déclare l'exemption dans la PR |
| **corrigé un bug** | écris d'abord le test qui échoue, puis §13 |
| pris une décision structurante | **crée un ADR** dans `docs/01-architecture-decision-records/`, puis §2 + §13 |
| changé une dépendance majeure, une version, un outil | §4 (stack) + §13 |
| changé une règle de travail (git, PR, CI, revue) | §7 ou §8 + §13 |
| terminé une tâche du backlog | §10 (avancement) + `backlog/DONE.md` + §13 |
| changé le périmètre d'un sprint | §9 + §13 |
| ajouté un secret, un bucket, un traitement de donnée personnelle | §11 (sécurité) + §13 |
| corrigé un bug notable ou résolu un incident | §13 |

**Comment écrire dans le journal (§13)** — une ligne, jamais plus de trois :

```markdown
### 2026-08-20
- **[BACKEND]** `BE-15` — Ranking implémenté dans `packages/core/search/ranking.ts`.
  14 tests, dont le garde-fou ADR-002. PR #61. *(Oussama + Chayma, binôme)*
```

Format imposé : `**[LOT]** <ID> — <ce qui a changé et pourquoi>. <trace : PR, ADR, fichier>. *(qui)*`
Lots possibles : `SOCLE` `BACKEND` `MOBILE` `WEB` `ADMIN` `DESIGN` `DATA` `SÉCURITÉ` `CI` `DOC`
`PROCESS` `INFRA`.

**Interdits dans ce fichier :**

- ❌ Effacer une entrée du journal. On corrige par une nouvelle entrée datée, jamais en réécrivant
  l'histoire.
- ❌ Écrire une décision sans trace (ADR, PR, ou fichier). Une décision sans trace sera re-débattue
  dans trois semaines.
- ❌ Y mettre un secret, une clé, une URL de base de données, un numéro de téléphone réel.

### 0.3 Ce que tu ne fais jamais sans accord explicite d'Oussama

- Ajouter une dépendance en `dependencies` (pas `devDependencies`)
- Créer une migration Prisma destructive
- Modifier un ADR, `CLAUDE.md`, ou les sections 1 à 12 de ce fichier (le §13 s'enrichit librement)
- Toucher à `contracts/openapi.json` autrement qu'en le régénérant
- Élargir le périmètre du sprint
- Introduire un microservice, un nouveau déploiement, une nouvelle brique d'infra

### 0.4 Format de rapport attendu en fin de tâche

```
Tâche   : BE-03 — Auth OTP
Fichiers: packages/auth/src/otp.ts, apps/api/src/routes/auth.ts, +2 tests
Tests   : 7 passés / 0 échoué
Contrat : openapi.json régénéré (2 routes ajoutées)
HISTORIQUE.md : §3.7 + §13 mis à jour
Reste   : rate-limit par IP à brancher (créé BE-03b dans TODO)
```

---

# 1. Le projet en 60 secondes

**Sanaya** est une plateforme tunisienne de **mise en relation** entre particuliers et artisans
(plomberie, électricité, peinture, climatisation, menuiserie…).

| | |
|---|---|
| **Modèle** | **Lead generation.** La plateforme met en contact ; elle **n'encaisse jamais** le montant du chantier. |
| **Pourquoi ce modèle** | Éviter l'agrément d'établissement de paiement, le séquestre et la gestion de litiges financiers — hors de portée d'une équipe de deux. |
| **Cible de lancement** | Le **Sahel** : Sousse, Monastir, Mahdia. Pas de lancement national au démarrage. |
| **Concurrent réel** | Les **groupes Facebook**. C'est eux qu'il faut battre sur la confiance et sur Google. |
| **Monétisation** | Gratuit pour le particulier. Pour l'artisan : abonnement **Pack Pro** + crédits + boosts. |
| **Unité de valeur vendue** | Le **`ContactEvent`** — un clic « Appeler » ou « WhatsApp » tracé. Sans cette trace, l'abonnement Pro est invendable. |
| **Équipe** | **Oussama Dallel** (`@dallel5-git`) — product / tech lead & dev · **Chayma Dallel** (`@yoyo2-hub`) — dev · Claude en pair-programmer sur chaque poste. |
| **Dépôt** | `github.com/dallel5-git/plateforme-artisans` (public) |
| **Langues produit** | **FR + AR avec RTL, dès le jour 1.** Non rétrofittable. |
| **Fuseau / monnaie** | Stockage UTC ISO-8601, affichage `Africa/Tunis`. Montants en **millimes** (1 TND = 1000 millimes), entiers. |

**L'objectif du sprint 1, en une phrase :**

> À la fin de la semaine, un habitant de Sousse doit pouvoir installer l'APK, chercher
> « plombier · Sousse », voir une liste classée d'artisans réels, ouvrir une fiche, et appeler
> l'artisan — **et cet appel doit être compté**.

---

# 2. Décisions structurantes (ADR)

Les ADR vivent dans `docs/01-architecture-decision-records/`. **Ils priment sur tout le reste.**

## 2.1 ADR-001 — Mobile en Flutter, contrat d'API en REST/OpenAPI

*Statut : Accepté · 2026-08-15 · Décideurs : Oussama, Chayma*

**Ce qui change** : le cadrage v1.0 retenait **Expo / React Native + tRPC v11**. → **OBSOLÈTE.**
Retenu : **Flutter (mobile) + Next.js (web/admin) + API REST Fastify/OpenAPI autonome**.

**Pourquoi** : fluidité native perçue sur Android d'entrée de gamme, stabilité sur réseau dégradé,
rendu identique iOS/Android. C'est le choix du document de stratégie produit.

**Conséquence mécanique** : tRPC devient inutilisable. tRPC n'est pas un protocole, c'est une astuce
de typage TypeScript — le client *importe le type* `AppRouter`. Il n'existe pas d'équivalent en Dart
et il n'y en aura pas. Options écartées : client Dart écrit à la main (dérive de contrat garantie),
`trpc-to-openapi` (deux surfaces à maintenir), GraphQL (coût d'apprentissage non budgétable).

**Le contrat devient un fichier** : `contracts/openapi.json`, **généré** depuis les schémas Zod,
versionné dans git, vérifié en CI par `pnpm api:contract --check`. C'est le remplaçant du garde-fou
que tRPC offrait gratuitement.

**Coût assumé** : le partage de code chute de **~70 % à ~40 %**. Deux langages, deux outillages,
deux CI. Risque de *bus factor* sur le mobile — mitigé par l'ADR-003 (les deux devs sur Flutter).

**Point de non-retour** : la décision est coûteuse à annuler **après le jour 4** de S1 — au-delà, du
code Dart de présentation existe. C'est exactement pourquoi le backend passe en premier.

## 2.2 ADR-002 — Le badge « Artisan Vérifié » est gratuit et fondé sur l'identité

*Statut : Accepté · 2026-08-15 · Décideur : Oussama*

**Décision** : tout artisan qui soumet une CIN valide obtient le badge, **y compris en offre
gratuite**. Le badge atteste de l'**identité**, jamais du niveau d'abonnement. Le Pack Pro vend la
**visibilité** (`Plan.rankingBoostFactor`, quotas, statistiques, boosts), pas la confiance.

**Pourquoi** : réserver le badge aux payants produirait une majorité d'artisans non vérifiés au
lancement — c'est-à-dire exactement le signal des groupes Facebook, donc la disparition du seul
différenciateur défendable. Le raisonnement inverse tient : plus d'artisans vérifiés → plus de
confiance → plus de contacts → l'artisan gratuit *constate* que la plateforme lui apporte des leads,
et c'est ce constat mesuré (P9) qui vend le Pack Pro.

**Conséquences techniques** :
- `ProviderProfile.isVerified` est **strictement indépendant** de `Subscription`.
- Aucun retrait automatique du badge à l'expiration d'un abonnement — simplification substantielle
  du module `billing`.
- Le ranking utilise **deux termes distincts et jamais fusionnés** : `w3 · confiance` (badge,
  gratuit) et `w6 · facteurPlan` (`Plan.rankingBoostFactor`).
- Extension future ouverte (option C) : `certificationLevel` (`NONE | IDENTITY | PRO_CERTIFIED`),
  sans toucher à `isVerified`.

**🚧 Garde-fou de test obligatoire** dans `packages/core/tests/ranking.test.ts` :

> Un artisan **gratuit, vérifié, profil à 100 %** doit obtenir un score **supérieur** à un artisan
> **Pro non vérifié au profil incomplet**, à pertinence géographique et réputation égales.

Si ce test casse, c'est que quelqu'un a re-lié le badge au plan.

## 2.3 ADR-003 — Le sprint S1 livre le mobile, pas le web

*Statut : Accepté · 2026-08-15 · Décideur : Oussama*

**Le problème** : la v1 du plan S1 mettait Oussama sur `apps/web` et Chayma sur `apps/mobile` en
parallèle à partir de J4.

| | Heures-homme |
|---|---|
| Capacité réelle (2 devs × 7 j × 8 h) | **112 h** |
| Charge 🔴 P0 planifiée en v1 | **~159 h** |
| Dépassement | **+42 %** |

**Double erreur d'origine** : (a) les tâches en binôme n'étaient comptées qu'une fois ; (b) deux
surfaces développées en parallèle coûtent **la somme** de leurs charges — l'ADR-001 §4.2 avait déjà
écrit que le partage de code chutait à ~40 %.

**Décision** : S1 livre le **socle + backend + mobile Flutter**. **`apps/web` est reporté en S2.**
À partir de J4 après-midi, **les deux développeurs sont sur Flutter**.

| Après re-cadrage | Heures-homme |
|---|---|
| Socle | ~11,5 h |
| Backend | ~53 h |
| Mobile Flutter | ~43 h |
| Qualité | ~4 h |
| **Total 🔴 P0** | **~109 h** — marge **~3 %, c'est-à-dire aucune** |

**Pourquoi le mobile passe devant** : c'est **le produit**. C'est ce qu'on installe sur le téléphone
d'un artisan pendant la tournée des quincailleries. Une URL de préproduction ne se distribue pas à
7h du matin devant une quincaillerie de Sahloul. Le web n'est pas perdu, il est **décalé** : son
délai propre est l'indexation Google, qui prend des semaines de toute façon.

**Effet secondaire souhaitable** : les deux devs sur Flutter tue le risque de bus factor de
l'ADR-001 §4.2.

**Deux règles de planification issues de cette erreur, désormais permanentes :**
1. **Une tâche en binôme compte double** en heures-homme.
2. **Deux surfaces en parallèle coûtent la somme de leurs charges.** Pas de mutualisation magique.

## 2.4 ADR-006 — Aucun changement sans test, aucun bug sans test de non-régression

*Statut : Accepté · 2026-08-15 · Décideur : Oussama*

**Le problème** : `POLITIQUE-PROJET.md` §6 décrivait déjà *quoi* tester. Rien ne l'**imposait** —
une PR sans un seul test neuf passait, CI verte, sans que personne ne le remarque. À deux
développeurs sous 109 h pour 112 h disponibles, c'est le genre de règle qui saute le mercredi soir.

**Trois règles, opposables en revue et vérifiées par la CI :**

1. **Tout changement de comportement s'accompagne d'un test** — cas passant *et* au moins un cas
   d'erreur. Les exemptions (doc, fichiers générés, renommage, formatage, montée de version,
   outillage) se **déclarent** dans la PR ; elles ne se supposent pas.
2. **Toute correction de bug commence par un test qui reproduit le bug** : écrire le test → **le
   voir échouer** → corriger → committer les deux ensemble. Un test écrit après ne prouve rien, on
   ne l'a jamais vu rouge.
3. **Les tests marqués `🔒 NON-RÉGRESSION` ne se suppriment pas** sans un ADR qui annule la décision
   d'origine, et la revue des deux développeurs. La CI compte les marqueurs et bloque s'il en manque.

**Ce que la décision exclut** : aucun seuil de couverture chiffré (on atteint 80 % en testant les
getters pendant que le ranking reste à découvert) · pas de tests de mutation en S1 (trop coûteux en
CI, à reconsidérer en S2 sur `packages/core`) · pas de E2E bloquant en S1 (Maestro démarre en S2).

**Les trois zones verrouillées** — celles où une régression est *invisible* :

| Zone | Ce qui casse | Symptôme sans test |
|---|---|---|
| Ranking | `w3` (confiance) fusionné avec `w6` (facteurPlan) → le badge redevient payant | Aucun. L'ordre change, personne ne le voit avant un mois. |
| `ContactEvent` | La dédup 30 min saute, ou l'agrégat sort de la transaction | Aucun — jusqu'aux chiffres faux présentés à un artisan qui paie. |
| Auth | La rotation du refresh cesse de révoquer la famille | Aucun, jusqu'à l'incident de sécurité. |

**Le vrai risque, assumé** : ce n'est pas qu'on n'écrive pas de tests, c'est qu'on écrive des tests
qui ne prouvent rien pour cocher la case. En revue, la question n'est pas « y a-t-il un test ? »
mais **« si je casse cette ligne, est-ce que ce test devient rouge ? »**

## 2.5 ADR à venir — questions non tranchées

| ADR | Sujet | Bloque | Échéance |
|---|---|---|---|
| **ADR-004** | Moyens de paiement (Konnect / Paymee / Flouci) — question 2 du cadrage | `BE-33`, tout le lot `billing`, milestone M5 | avant S2 |
| **ADR-005** | Annuaire **ou** place de marché ? — question 3 du cadrage | `BE-38` (`ServiceRequest`) — détermine si `ContactEvent` devient un cycle de vie de mission | avant S2 |

---

# 3. Architecture

## 3.1 Vue macro — le schéma à retenir

```
┌──────────────────────┐  ┌──────────────────────┐  ┌──────────────────────┐
│  apps/mobile   (S1)  │  │  apps/web      (S2)  │  │  apps/admin    (S3)  │
│  Flutter 3.24        │  │  Next.js 15          │  │  Next.js 15          │
│  Client + Espace Pro │  │  Client + vitrine SEO│  │  Back-office         │
│                      │  │                      │  │                      │
│  Dio + Retrofit      │  │  openapi-fetch typé  │  │  openapi-fetch typé  │
│  (client GÉNÉRÉ)     │  │  (client GÉNÉRÉ)     │  │  (client GÉNÉRÉ)     │
└──────────┬───────────┘  └──────────┬───────────┘  └──────────┬───────────┘
           │                         │                         │
           └─────────────────────────┼─────────────────────────┘
                                     │  HTTPS / JSON
                    ┌────────────────▼─────────────────┐
                    │   contracts/openapi.json         │  ⚠️ GÉNÉRÉ, jamais édité
                    │   versionné · vérifié en CI      │     (api:contract --check)
                    └────────────────┬─────────────────┘
                                     │
                    ┌────────────────▼─────────────────┐
                    │   apps/api — Fastify 5           │  TRANSPORT UNIQUEMENT
                    │  ┌───────────────────────────┐   │  Une route :
                    │  │ cors · helmet · rate-limit│   │    valide (Zod)
                    │  │ jwt · rbac · requestId    │   │    → appelle core
                    │  └───────────────────────────┘   │    → sérialise
                    │   routes/ : 1 fichier = 1 module │  Aucun `if` métier ici.
                    └────────────────┬─────────────────┘
                                     │
                    ┌────────────────▼─────────────────┐
                    │   packages/core                  │  ⭐ LE VRAI ACTIF
                    │   ranking · policies · éligibilité│  Fonctions pures.
                    │   complétude · montants · dates  │  Zéro dépendance HTTP/React.
                    │                                  │  100 % testable sans base.
                    └────────────────┬─────────────────┘
                                     │
   ┌──────────────┬──────────────────┼──────────────┬──────────────────┐
   ▼              ▼                  ▼              ▼                  ▼
┌────────┐  ┌───────────┐  ┌────────────────┐  ┌──────────┐  ┌────────────────┐
│packages│  │ packages/ │  │  packages/     │  │ packages/│  │  apps/worker   │
│  /db   │  │  storage  │  │  notifications │  │ payments │  │  BullMQ  (S3)  │
│Prisma 6│  │  R2 (S3)  │  │  SMS · Push    │  │ Konnect… │  │  agrégats,     │
│  PG16  │  │  2 buckets│  │       (S2)     │  │   (S4)   │  │  expirations   │
└───┬────┘  └───────────┘  └────────────────┘  └──────────┘  └────────────────┘
    │
    ▼
┌──────────────────────────────┐   ┌──────────────────┐
│  PostgreSQL 16               │   │  Redis 7         │
│  unaccent · pg_trgm · PostGIS│   │  rate-limit      │
└──────────────────────────────┘   │  cache · files   │
                                   └──────────────────┘

Packages partagés (TypeScript) : validators (Zod) · constants · utils · i18n · design-tokens
                                  ▲                                        ▲
                                  │ source du contrat OpenAPI              │ génère aussi le Dart
```

**Modular monolith, pas de microservices.** Un seul serveur d'API découpé en modules métier étanches.

## 3.2 Arborescence du monorepo

```
plateforme-artisans/
├── HISTORIQUE.md                ← CE FICHIER — mémoire complète
├── CLAUDE.md                    ← mémoire projet + guard-rails (lu par Claude au démarrage)
├── README.md
├── backlog/
│   ├── README.md                mode d'emploi du backlog
│   ├── TODO.md                  ce qui reste (sprint courant + reporté + non planifié)
│   ├── DOING.md                 l'instant présent — max 2 tâches par dev
│   └── DONE.md                  terminé, avec date et n° de PR
├── Code/
│   ├── contracts/
│   │   └── openapi.json         ⚠️ GÉNÉRÉ — jamais édité à la main
│   ├── apps/
│   │   ├── api/                 Fastify 5 — transport uniquement          [S1]
│   │   │   └── src/
│   │   │       ├── server.ts          bootstrap, plugins, graceful shutdown
│   │   │       ├── plugins/           cors, helmet, rate-limit, jwt, request-id, sentry
│   │   │       ├── routes/            1 fichier = 1 module métier
│   │   │       └── openapi.ts         génération d'openapi.json
│   │   ├── mobile/              Flutter 3.24 — LE PRODUIT                 [S1]
│   │   ├── web/                 Next.js 15 — vitrine SEO                  [S2]
│   │   ├── admin/               Next.js 15 — back-office                  [S3]
│   │   └── worker/              BullMQ — agrégats, expirations            [S3]
│   ├── packages/
│   │   ├── core/                ⭐ domaine pur : ranking, policies, éligibilité
│   │   ├── db/                  Prisma 6 + repositories — SEULE couche qui parle à Prisma
│   │   ├── auth/                OTP, JWT, sessions
│   │   ├── validators/          Zod — source unique du contrat OpenAPI
│   │   ├── constants/           error-codes.ts, enums partagés
│   │   ├── utils/               phone-tn.ts, currency.ts, slugify.ts
│   │   ├── i18n/                catalogues fr.json / ar.json — partagés web + mobile
│   │   ├── design-tokens/       tokens.json → TS (preset Tailwind) ET Dart
│   │   ├── storage/             R2 / S3 — 2 buckets (public-media, private-kyc)
│   │   ├── notifications/       SMS, push
│   │   ├── payments/            passerelles derrière une interface        [S4]
│   │   ├── tsconfig/            config TS partagée
│   │   └── eslint-config/       config ESLint partagée (dont no-restricted-imports)
│   ├── docs/
│   │   ├── 01-architecture-decision-records/   ADR-001, ADR-002, ADR-003
│   │   ├── 02-api-conventions.md
│   │   ├── 05-runbook.md
│   │   ├── 07-organisation-github.md
│   │   ├── POLITIQUE-PROJET.md
│   │   └── PLAN-MVP-SEMAINE-1.md
│   └── tooling/
│       └── scripts/             setup-github.sh, gh-bootstrap.sh, gh-seed-issues.sh,
│                                gh-verify.sh, issues-data.py, github-issues.json
└── .github/
    ├── CODEOWNERS               qui relit quoi — principal outil anti-conflit
    ├── ISSUE_TEMPLATE/          01-tache.yml · 02-bug.yml · 03-decision.yml · config.yml
    ├── pull_request_template.md
    └── workflows/               CI GitHub Actions
```

## 3.3 Les couches et leur responsabilité — la règle en une image

```
 route (Zod in/out)  →  service de core  →  repository de db  →  Prisma  →  PostgreSQL
    validation             règles              requêtes           SQL
    15 lignes max          fonctions pures     select explicites
    aucun `if` métier      zéro HTTP/React     curseur générique
```

**Ordre de construction d'un module backend** (à respecter — il évite 80 % des reprises) :

1. **Schéma Zod** dans `packages/validators/src/<module>.ts` — entrée **et** sortie
2. **Test unitaire** dans `packages/core/tests/<module>.test.ts` (Vitest, sans base)
3. **Service** dans `packages/core/src/<module>/` — fonctions pures, dépendances injectées
4. **Repository** dans `packages/db/src/repositories/`
5. **Route** dans `apps/api/src/routes/<module>.ts` — 15 lignes max par handler
6. `pnpm api:contract` → commiter `contracts/openapi.json` **dans la même PR**

## 3.4 Les 9 modules métier

`auth` · `catalog` (catégories, géo) · `providers` · `search` · `contacts` · `reviews` · `billing` ·
`moderation` · `analytics` — plus `ads` pour la régie B2B (S4+).

*(Divergence corrigée le 2026-08-15 : `CLAUDE.md` §1 listait `ads` à la place de `contacts`.)*

**Un module n'importe d'un autre que son `index.ts`.** La règle ESLint `no-restricted-imports` est
active et bloquante : `@repo/core/src/*/internal/*` et les chemins profonds croisés sont interdits.
Sans contrainte automatisée, la modularité se dégrade en trois mois.

## 3.5 Les flux de données qui comptent

### A. Recherche d'un artisan

```
Mobile                apps/api              packages/core         PostgreSQL
  │                       │                       │                   │
  │ GET /v1/providers/search?category=plomberie&governorate=sousse    │
  ├──────────────────────►│                       │                   │
  │                       │ valide (Zod)          │                   │
  │                       ├──────────────────────►│ calcule le score  │
  │                       │                       │  · géo 1.0/0.6/0.3│
  │                       │                       │  · bayésien C=8   │
  │                       │                       │  · vérifié        │
  │                       │                       │  · complétude     │
  │                       │                       │  · facteur de plan│
  │                       │                       ├──────────────────►│
  │                       │                       │  index partiel    │
  │                       │                       │  WHERE PUBLISHED  │
  │                       │◄──────────────────────┤◄──────────────────┤
  │ { items[], nextCursor }   ⚠️ AUCUN téléphone dans la réponse      │
  │◄──────────────────────┤                       │                   │
  │ cache disque (consultable hors ligne)         │                   │
```

### B. Le contact — **le flux critique du modèle économique**

```
Mobile                      apps/api                    PostgreSQL          Réseau
  │                             │                            │                │
  │ clic « Appeler »            │                            │                │
  │ POST /v1/contact-events     │                            │                │
  ├────────────────────────────►│ rate-limit (Redis)         │                │
  │                             │ dédup 30 min (empreinte)   │                │
  │                             ├── TRANSACTION ────────────►│                │
  │                             │   INSERT ContactEvent      │                │
  │                             │   UPSERT DailyProviderStat │                │
  │                             │◄───────────────────────────┤                │
  │ 200 { phone: "+216..." }  ← le numéro n'est révélé QUE là │                │
  │◄────────────────────────────┤                            │                │
  │                                                                           │
  │ launchUrl('tel:+216...')  ────────────────────────────────────────────────►
  │                                                                           │
  ├─ SI l'API échoue ─► file locale persistante ─► renvoi au retour du réseau ─┘
     et le composeur s'ouvre QUAND MÊME : on ne bloque jamais l'utilisateur
```

> **Sans cette trace, l'abonnement Pro est invendable.** C'est la seule preuve qu'on puisse
> présenter à un artisan pour justifier qu'il paie. D'où : déduplication (anti-gonflage), écriture
> transactionnelle (pas d'incohérence), file hors ligne (pas de perte sur réseau dégradé).

### C. La boucle de confiance

```
   Contact tracé ──► Avis autorisé ──► Note bayésienne ──► Ranking ──► Visibilité
        ▲              (1-1 unique)      (lissée, C=8)                      │
        │                                                                   │
        └───────────────────── plus de contacts ◄───────────────────────────┘

   Garde-fous :  un avis EXIGE un ContactEvent réel (anti-faux-avis)
                 un artisan ne peut pas s'auto-évaluer (trigger SQL, pas juste applicatif)
                 les agrégats sont recalculés DANS la transaction d'écriture
```

### D. Authentification OTP

```
  Client                    apps/api                  Redis        PostgreSQL
    │ POST /v1/auth/otp/request {phone}                  │              │
    ├─────────────────────────►│ normalise +216XXXXXXXX  │              │
    │                          │ rate-limit 5/h ────────►│              │
    │                          │ génère 6 chiffres       │              │
    │                          │ hash argon2 + TTL 5 min ──────────────►│ OtpCode
    │                          │ SmsProvider.send() → console en S1     │
    │ 200 (ne révèle JAMAIS si le numéro existe — anti-énumération)     │
    │◄─────────────────────────┤                         │              │
    │ POST /v1/auth/otp/verify {phone, code}             │              │
    ├─────────────────────────►│ 3 tentatives max        │              │
    │                          │ invalidation à l'usage  │              │
    │ 200 { access 15 min, refresh rotatif 30 j }        ├─────────────►│ Session
    │◄─────────────────────────┤                         │              │

  ⚠️ Rejouer un ancien refresh révoque TOUTE la famille de sessions (détection de rejeu).
```

## 3.6 Modèle de données — sous-ensemble MVP (19 modèles)

```
                          ┌──────────┐
                          │   User   │  role: CLIENT | PROVIDER | MODERATOR | ADMIN
                          │ deletedAt│  soft delete + anonymisation, JAMAIS de delete physique
                          └────┬─────┘
              ┌────────────────┼──────────────────┬────────────────┐
              ▼                ▼                  ▼                ▼
        ┌──────────┐    ┌───────────┐     ┌──────────────┐   ┌──────────┐
        │ Session  │    │  OtpCode  │     │ProviderProfile│   │ Favorite │
        │ révocable│    │ hash+TTL  │     │  1-1 si       │   └──────────┘
        └──────────┘    └───────────┘     │  role=PROVIDER│
                                          └───────┬───────┘
                    ┌─────────────────────────────┼─────────────────────────┐
                    ▼                             ▼                         ▼
          ┌───────────────────┐        ┌──────────────────┐      ┌──────────────────┐
          │ ProviderCategory  │        │ ServiceOffering  │      │  CoverageArea    │
          │ (index unique     │        │ prix en MILLIMES │      │ gouvernorat /    │
          │  partiel : 1 seule│        │                  │      │ délégation       │
          │  principale)      │        └──────────────────┘      └────────┬─────────┘
          └─────────┬─────────┘                                           │
                    ▼                                                     ▼
             ┌────────────┐                                    ┌────────────────────┐
             │  Category  │  arbre FR/AR, slug, icône          │   Governorate 24   │
             └────────────┘                                    │        │           │
                                                               │   Delegation ~264  │
        ┌──────────────┐   ┌──────────────┐                    │  (Sahel seedé S1)  │
        │ MediaAsset   │   │PortfolioItem │                    └────────────────────┘
        └──────────────┘   └──────────────┘

   ═══════════ LA BOUCLE DE VALEUR ═══════════
        ┌───────────────┐        1-1 unique       ┌──────────┐
        │ ContactEvent  │◄────────────────────────│  Review  │  note 1-5 (CHECK SQL)
        │ PHONE|WHATSAPP│                         │ trigger  │  ratingAvg/ratingCount
        │ dédup 30 min  │                         │ prevent_ │  recalculés DANS la
        │ empreinte de  │                         │ self_    │  MÊME transaction
        │ session       │                         │ review   │
        └───────┬───────┘                         └──────────┘
                │
                ▼
        ┌────────────────┐      ┌ ─ ─ ─ ─ ─ ─ ─┐      ┌────────────┐
        │ ProfileView    │─────►│DailyProvider │      │ AppSetting │ poids du ranking
        │ dédup 24 h     │      │Stat (upsert) │      │ (JAMAIS en │
        └────────────────┘      └ ─ ─ ─ ─ ─ ─ ─┘      │  dur)      │
                                 agrégat, ajouté       └────────────┘
                                 par BE-23 (hors
                                 des 19 de BE-01)
        ┌──────────┐   ┌──────────┐
        │   Plan   │   │ AuditLog │  chaque accès à une donnée KYC y est journalisé
        │ FREE seul│   └──────────┘
        │ en S1    │
        └──────────┘

   Reporté (entités modélisées, aucun écran) : ServiceRequest · ServiceRequestMatch
   Reporté S2-S4 : Subscription · Payment · CreditTransaction · Boost ·
                   VerificationRequest · VerificationDocument · Report
```

**Règles de données non négociables :**

| Règle | Détail |
|---|---|
| Argent | **Millimes**, entier (`Int`). Jamais de `Float`, jamais de `parseFloat`. |
| Téléphone | Normalisé `+216XXXXXXXX` par `packages/utils/phone-tn.ts` **avant** toute écriture ET avant toute recherche d'unicité. |
| Dates | Stockage et transport en **UTC ISO-8601**. `Africa/Tunis` uniquement à l'affichage. |
| Suppression | `User.deletedAt` + anonymisation (téléphone haché, nom → « Utilisateur supprimé »). Les avis restent publiés anonymement. |
| Comptabilité | `Payment`, `CreditTransaction`, `Plan` → `onDelete: Restrict`. Jamais de cascade. |
| `CreditTransaction` | **Journal immuable** : on insère, on ne met jamais à jour. |
| Agrégats | `ratingAvg` / `ratingCount` dénormalisés sur `ProviderProfile`, recalculés dans la transaction d'écriture de l'avis. |
| Migrations | Jamais modifier une migration déjà mergée. On **ajoute** une migration. Nom : `<date>_<verbe>_<objet>`. |
| Recherche texte | `unaccent(lower(...))` + `pg_trgm`. Les noms arabes translittérés doivent matcher (`سامي` / `Sami`). |

## 3.7 Surface d'API — parcours cœur S1

Base : `/v1`. Pagination **par curseur uniquement** : `?cursor=<opaque>&limit=20` → `{ items, nextCursor }`.

| Méthode | Route | Auth | Note |
|---|---|---|---|
| `GET` | `/v1/health` | public | `{status, db, redis}` |
| `POST` | `/v1/auth/otp/request` | public | rate-limit 5/h ; **ne révèle jamais** si le numéro existe |
| `POST` | `/v1/auth/otp/verify` | public | → access 15 min + refresh rotatif 30 j |
| `POST` | `/v1/auth/refresh` | refresh | rejeu détecté → révoque toute la famille |
| `POST` | `/v1/auth/logout` | oui | |
| `GET` | `/v1/auth/me` | oui | profil + rôles |
| `GET` | `/v1/categories` | public | arbre FR/AR, cache Redis 1 h |
| `GET` | `/v1/governorates` | public | 24 |
| `GET` | `/v1/governorates/:id/delegations` | public | Sahel seedé en S1 |
| `GET` | `/v1/providers/search` | public | filtres + tri ranking + curseur ; `score`/`matchReason` en debug |
| `GET` | `/v1/providers/:slug` | public | ⚠️ **le téléphone n'est PAS dans la réponse** |
| `GET` | `/v1/providers/:slug/reviews` | public | curseur, pagination stable |
| `POST` | `/v1/contact-events` | oui | ⭐ dédup 30 min · transaction · **révèle le numéro** |
| `POST` | `/v1/providers/:id/reviews` | oui | exige un `ContactEvent` réel → sinon `403 REVIEW_REQUIRES_CONTACT` |
| `POST` | `/v1/profile-views` | public | dédup 24 h par empreinte de session |
| `POST` `PATCH` | `/v1/providers/me` | PROVIDER | 🟠 P1 — `completionScore` recalculé à chaque écriture |
| `PUT` | `/v1/me/categories`, `/v1/me/coverage-areas` | PROVIDER | 🟠 P1 |

**Réponse d'erreur normalisée** (toujours) :

```json
{ "error": { "code": "PROVIDER_NOT_FOUND", "message": "…", "details": {} }, "requestId": "…" }
```

Les codes viennent de `packages/constants/error-codes.ts`. Le `message` est destiné au développeur ;
le client affiche une traduction locale **à partir du `code`**. Aucune stack en production.

## 3.8 Le ranking — le cœur du produit (`packages/core/search/ranking.ts`)

```
score =  w1 · pertinenceGéo        (même délégation 1.0 · même gouvernorat 0.6 · limitrophe 0.3)
       + w2 · noteBayésienne       ( (C·m + Σnotes) / (C + n) ,  C = 8 )
       + w3 · confiance            (badge isVerified — GRATUIT, ADR-002)
       + w4 · complétude           (completionScore / 100)
       + w5 · réactivité
       + w6 · facteurPlan          (Plan.rankingBoostFactor — PAYANT)
       − pénalités                 (signalements, inactivité)
       ± rotation équitable ±2 %   (à score égal, évite le gel du classement)
```

- **Les poids `w1..w7` vivent dans `AppSetting`, jamais en dur** (`w7` = pénalités). Les affiner
  plus tard ne coûte rien.
- **`w3` (confiance) et `w6` (facteurPlan) ne doivent JAMAIS être fusionnés** (ADR-002).
- **Les boosts n'entrent PAS dans `rankingScore`.** Ce sont des emplacements séparés en tête de
  liste, avec `sponsored: true` dans la réponse et une étiquette « Sponsorisé » visible.
- **≥ 12 tests unitaires sans base ni réseau**, dont le garde-fou ADR-002.

---

# 4. Stack technique

## 4.1 Backend

| Besoin | Choix | Note |
|---|---|---|
| Runtime / serveur | **Fastify 5** + `fastify-type-provider-zod` + `@fastify/swagger` | transport uniquement |
| Validation | **Zod** (`packages/validators`) | **source unique** : valide les entrées ET produit l'OpenAPI 3.1 |
| ORM / base | **Prisma 6** / **PostgreSQL 16** (`unaccent`, `pg_trgm`, `postgis`) | |
| Cache / files / rate-limit | **Redis 7** | |
| Logs | **pino** + `requestId` | Sentry reporté S2 |
| Jobs | **BullMQ** (`apps/worker`) | S3 — nécessaire au-delà de ~500 artisans |
| Stockage objets | **R2 / S3** — 2 buckets : `public-media`, `private-kyc` (chiffré) | |
| Monorepo | **pnpm workspaces + Turborepo** | |
| Tests | **Vitest** (unitaires + intégration sur base jetable) | |

## 4.2 Mobile (`apps/mobile`) — Flutter

| Besoin | Choix | Justification |
|---|---|---|
| SDK | **Flutter 3.24+ / Dart 3.5+** | Impeller par défaut sur Android — l'argument même de la bascule |
| Navigation | **go_router** | routing déclaratif par URL, deep links `tel:` / `wa.me` |
| État serveur | **Riverpod 2** (`AsyncNotifier`) | équivalent Dart de TanStack Query |
| HTTP | **Dio + Retrofit**, **générés** depuis `openapi.json` | client jamais écrit à la main |
| Modèles | **freezed + json_serializable** | immutabilité, `copyWith`, union types |
| Stockage sécurisé | **flutter_secure_storage** | Keystore / Keychain — jamais `SharedPreferences` |
| Images | **cached_network_image** + WebP servi par le CDN | P5 |
| i18n / RTL | **slang** + `Directionality` global | P7 |
| Polices | **Manrope** (latin) + **Noto Kufi Arabic** (arabe) | sélection automatique par locale |
| Push | **firebase_messaging** | S2 |
| Tests | `flutter_test` + `mocktail`, E2E **Maestro** | Maestro est agnostique du framework |
| Lints | `flutter_lints` + `very_good_analysis` | **zéro warning toléré en PR** |

**Arborescence mobile — par feature, pas par type :**

```
lib/
  main.dart
  app/            router.dart · theme.dart · providers.dart
  core/
    api/            client Dio + intercepteurs (auth, refresh, retry, offline)
    api/generated/  ⚠️ GÉNÉRÉ — ne jamais éditer
    theme/          app_colors.dart · app_spacing.dart · app_text.dart  ⚠️ GÉNÉRÉS
    i18n/           slang (généré depuis packages/i18n)
    widgets/        AppButton, AppCard, EmptyState, ErrorState…
  features/
    auth/  search/  provider_profile/  contact/  reviews/
    pro_onboarding/  pro_dashboard/
      └── chacune : data/ · domain/ · presentation/
```

**Une seule application, deux espaces** `(client)` et `(pro)`. Un artisan est aussi un client ; deux
apps signifieraient deux fiches store, deux reviews, deux bases d'installation à faire croître. Le
basculement se fait sur les **rôles portés par le compte**.

## 4.3 Web & Admin (`apps/web` [S2], `apps/admin` [S3])

Next.js 15 (App Router) · React 19 · Tailwind CSS v4 + preset `@repo/design-tokens` · shadcn/ui
(Radix) · TanStack Query v5 · `openapi-fetch` typé · React Hook Form + `@hookform/resolvers/zod` ·
i18next FR/AR.

| Surface | Rendu | Pourquoi |
|---|---|---|
| `/[locale]/[gouvernorat]/[service]` | **SSG + ISR** (`revalidate: 3600`) | C'est la page à indexer. **Jamais de CSR.** |
| Fiche artisan `/[locale]/artisan/[slug]` | **SSG + ISR** | JSON-LD `LocalBusiness` + `AggregateRating` obligatoire |
| Recherche avec filtres | Server Component + `searchParams` | filtres dans l'URL → partageable et indexable |
| Espace connecté | Client Component + TanStack Query | aucun intérêt SEO |

`sitemap.xml` et `robots.txt` **dynamiques**, générés depuis la base. `hreflang` FR/AR sur chaque
page publique. LCP < 2,5 s **sur 3G simulé**. Une page publique > 200 kB JS est refusée en review.
`apps/admin` : `X-Robots-Tag: noindex`, CSP stricte, **2FA obligatoire**.

## 4.4 Design system (`packages/design-tokens`)

Source unique : **`tokens.json`** → génère **TS (preset Tailwind)** *et* **Dart**.

**7 familles** : `color` (brand, neutral, success, warning, danger, info, semantic) · `spacing`
(0 → 5xl) · `radius` (none → pill) · `typography` (family, weight, scale) · `elevation` ·
`motion` (duration, easing) · `layout` (touchTarget, containerMax, breakpoint).

```
tokens.json ──pnpm tokens:build──┬──► packages/design-tokens/src/{colors,spacing,typography}.ts
   (LA SOURCE)                   │    + tailwind-preset.js
                                 └──► apps/mobile/lib/core/theme/{app_colors,app_spacing,app_text}.dart
```

⚠️ **Les fichiers générés ne s'éditent jamais à la main** — ils seront écrasés. La CI échoue s'ils
sont périmés.

---

# 5. Les 10 invariants — non négociables

| # | Invariant | Ce que ça interdit concrètement |
|---|---|---|
| **P1** | Modules métier étanches | Ne jamais importer un fichier interne d'un autre module. Passer par son `index.ts`. |
| **P2** | Le contrat d'API est **généré**, pas documenté | Ne jamais écrire un client HTTP à la main, ni éditer `openapi.json`. |
| **P3** | La logique métier ignore React et HTTP | Aucun `req`, `res`, `Request`, `BuildContext` dans `packages/core`. |
| **P4** | Une seule source de vérité pour les données | Le schéma Prisma. Ne jamais redéclarer un type de domaine à la main. |
| **P5** | Mobile-first, **low-bandwidth-first** | Pagination par curseur obligatoire, images WebP + variantes, jamais de `SELECT *` renvoyé au client. |
| **P6** | Le SEO est un canal d'acquisition critique | Les pages `/[gouvernorat]/[service]` sont en SSG/ISR avec JSON-LD `LocalBusiness`. Jamais en CSR. |
| **P7** | Bilingue FR/AR + RTL **dès le jour 1** | Aucune chaîne en dur dans une vue. Tout passe par une clé i18n. |
| **P8** | Conformité INPDP by design | La CIN ne transite jamais par un bucket public, ne s'affiche jamais sans URL signée courte, ne se logge jamais. |
| **P9** | Tout événement de valeur est traçable | Vue de profil, clic téléphone, clic WhatsApp, impression en recherche : si ce n'est pas tracé, l'abonnement Pro est invendable. |
| **P10** | Anti-fraude structurel | Rate limiting sur OTP/contacts/avis/uploads, déduplication par empreinte de session, avis rattaché à un `ContactEvent` réel. |

---

# 6. 🚧 Guard-rails — les interdits absolus

> Ces règles sont **bloquantes**. Si une tâche semble en exiger la violation : **s'arrêter et
> demander à Oussama**. Ne pas contourner.

## 6.1 Sécurité & données personnelles

- ❌ **Ne jamais** logger, sérialiser ou renvoyer dans une réponse API : numéro de CIN, image de CIN,
  OTP, mot de passe, refresh token, numéro de téléphone complet d'un artisan non contacté.
- ❌ **Ne jamais** stocker un OTP en clair. Hash + TTL 5 min + 3 tentatives max.
- ❌ **Ne jamais** committer un secret, une clé, un `.env`, une URL de base de données.
  `.env.example` uniquement, avec des valeurs factices.
- ❌ **Ne jamais** exposer un numéro de téléphone dans le HTML brut d'une page SEO (scraping).
  Révélation via appel API tracé et rate-limité uniquement.
- ✅ Bucket `private-kyc` : chiffré, non public, URL signée **5 minutes**, chaque accès journalisé
  dans `AuditLog`.
- ✅ Toute autorisation est vérifiée **côté serveur** dans `packages/core/policies`. Un contrôle
  côté client est un confort d'UX, jamais une sécurité.

## 6.2 Base de données

- ❌ **Ne jamais** modifier une migration déjà mergée. On **ajoute** une migration.
- ❌ **Ne jamais** faire `prisma db push` sur autre chose que sa base locale jetable.
- ❌ **Ne jamais** supprimer physiquement un `User` : soft delete + anonymisation.
- ❌ **Ne jamais** effacer une donnée comptable par cascade → `onDelete: Restrict`.
- ✅ `CHECK`, index partiels et index GIN vivent dans une migration SQL manuelle dédiée. Ne pas les
  oublier après un `prisma migrate reset`.

## 6.3 Architecture

- ❌ **Aucune règle métier dans `apps/api/src/routes/`.** Si un `if` métier apparaît, il descend
  dans `packages/core`.
- ❌ **Aucune règle métier dupliquée en Dart.** Si le mobile a besoin d'un calcul, l'API renvoie le
  résultat déjà calculé (`displayPrice`, `badgeLabel`, `distanceLabel`).
- ❌ **Aucun accès Prisma** depuis `apps/web`, `apps/admin` ou une route sans passer par `core`/`db`.
- ❌ Pas de microservice, pas de nouveau déploiement, pas de nouvelle brique d'infra **sans ADR**.
- ✅ Toute dépendance nouvelle en `dependencies` se justifie en PR.

## 6.4 Le badge « Vérifié » (ADR-002)

- ❌ **Aucun code ne doit lire `subscription.status` pour décider de l'affichage du badge
  `isVerified`.** Test de non-régression obligatoire dans `packages/core/tests/ranking.test.ts`.

## 6.5 Périmètre

- ❌ **`apps/web` n'existe pas en S1** (ADR-003). Ne pas commencer une page Next.js, même « vite
  fait pour tester ».
- ❌ **Ne pas coder ce qui n'est pas dans `backlog/TODO.md` pour le sprint courant.**
- ❌ Ne pas commencer une tâche marquée `blocked` tant que sa dépendance n'est pas en `DONE`.

## 6.6 Mobile — règles Flutter

1. Aucun `fetch`/`Dio` écrit à la main. Si une route manque, on modifie le backend et on régénère.
2. Aucune règle métier en Dart.
3. Aucune couleur, taille, rayon ou police en dur → `AppColors.*` / `AppSpacing.*` (**générés**).
4. Aucun `String` affiché en dur → `t.search.emptyState`, ajouté en **FR *et* AR**.
5. `setState` interdit pour de l'état serveur → Riverpod `AsyncNotifier`.
6. `const` partout où c'est possible — c'est l'argument même de la bascule Flutter.
7. Aucun widget > ~150 lignes. Extraire.
8. Refresh token dans `flutter_secure_storage` uniquement.
9. `EdgeInsetsDirectional` / `AlignmentDirectional` — **jamais** `EdgeInsets.only(left:)`.

## 6.7 Web — règles de rendu et de style

- Aucune propriété directionnelle CSS (`ml-`, `pr-`, `left-`, `text-left`) → propriétés logiques
  (`ms-`, `me-`, `ps-`, `pe-`). Elles cassent en arabe.
- `dir="rtl"` piloté par la locale au niveau du `<html>`, jamais par composant.
- `next/image` obligatoire, `sizes` renseigné, `priority` uniquement sur le LCP.

---

# 7. Conventions de code

## 7.1 TypeScript

- `camelCase` variables/fonctions · `PascalCase` types/composants · `SCREAMING_SNAKE_CASE` constantes
  exportées · fichiers en `kebab-case.ts` (un composant React = `PascalCase.tsx`).
- **Pas de `any`.** Si le typage résiste : `unknown` + narrowing. Jamais `@ts-ignore` sans commentaire
  justifiant.
- **Pas de `export default`**, sauf contrainte de framework (pages Next.js).
- **Erreurs** : jamais de `throw new Error("…")` nu côté domaine. Erreurs typées de
  `packages/core/errors` + code de `packages/constants/error-codes.ts`.
- **Async** : `async/await`, jamais de `.then()` chaîné. Toujours gérer le cas d'erreur.

## 7.2 Dart / Flutter

- `lowerCamelCase` variables/méthodes · `UpperCamelCase` classes · `snake_case.dart` fichiers.
- Arborescence **par feature** : `lib/features/<feature>/{data,domain,presentation}/`.
- Voir §6.6 pour les règles bloquantes.

## 7.3 API REST

- Ressources **au pluriel, kebab-case** : `GET /v1/providers`, `POST /v1/contact-events`.
- Pagination **par curseur uniquement**.
- Toute route versionnée sous `/v1`. **Aucun breaking change dans une version publiée.**

## 7.4 Commits — Conventional Commits

```
<type>(<scope>): <description à l'impératif, en français, sans point final>

[corps optionnel : le POURQUOI, pas le QUOI — le diff dit déjà le quoi]

Refs: BE-03
```

Types : `feat` · `fix` · `chore` · `refactor` · `docs` · `test` · `perf`
Scopes : `auth` `catalog` `providers` `search` `contacts` `reviews` `billing` `ads` `moderation`
`analytics` `db` `api` `web` `admin` `mobile` `ci` `docs` `design-tokens`

## 7.5 Commandes utiles

```bash
# --- Racine du monorepo (Code/) ---
pnpm install                 # installe tout le workspace
pnpm dev                     # api + web + admin en parallèle (turbo)
pnpm lint                    # eslint sur tout le repo
pnpm typecheck               # tsc --noEmit partout
pnpm test                    # vitest (unitaires + intégration)
pnpm api:contract            # régénère contracts/openapi.json
pnpm api:contract --check    # échoue si le contrat commité est périmé (CI)
pnpm tokens:build            # régénère les design tokens (TS + Dart)
pnpm i18n:check              # échoue si une clé existe en FR et pas en AR

# --- Base de données ---
pnpm db:up                   # docker compose : postgres + redis
pnpm db:migrate              # prisma migrate dev
pnpm db:seed                 # référentiel géo TN + catégories + jeu de démo
pnpm db:reset                # reset + migrate + seed (base LOCALE uniquement !)
pnpm db:studio               # prisma studio

# --- Mobile ---
cd apps/mobile
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # freezed + retrofit + slang
flutter run
pnpm mobile:client           # (depuis la racine) régénère le client Dart depuis openapi.json

# --- Organisation GitHub (idempotent, relançable) ---
GH_CHAYMA=yoyo2-hub ./Code/tooling/scripts/setup-github.sh
./Code/tooling/scripts/gh-verify.sh     # audit : issues manquantes, doublons, non assignées
```

---

# 8. Organisation GitHub & processus

## 8.1 Modèle de branches

```
main                      protégée · production · squash-merge · JAMAIS de push direct
  ▲
  │  PR de release, relue
  │
develop                   ⭐ STAGING — c'est ici que tout le monde merge
  ▲   ▲   ▲
  │   │   │  PR relue, CI verte, squash-merge
  │   │   │
  │   │   └── feat/FM-07-search-results
  │   └────── fix/BE-11-phone-normalization
  └────────── chore/CI-02-turbo-cache
```

| Branche | Rôle | Règle |
|---|---|---|
| `main` | Production. Toujours déployable. | Push direct **interdit**, y compris pour le lead. 1 approbation + CI verte. Alimentée **uniquement** par une PR depuis `develop` (ou un `hotfix/*`). |
| `develop` | **Staging.** Cible de merge par défaut de toutes les branches de travail. | 1 approbation + CI verte. Squash-merge. |
| `feat/<ID>-<slug>` | Une tâche du backlog | Part de `develop`, revient dans `develop`. |
| `fix/`, `chore/`, `refactor/`, `docs/`, `test/`, `perf/` | idem | idem |
| `hotfix/<ID>-<slug>` | Correctif urgent en production | Part de `main`, revient dans `main` **et** dans `develop`. |

- **L'ID du backlog dans le nom de branche est obligatoire** — c'est ce qui relie le code au plan.
- **Durée de vie d'une branche : ≤ 2 jours.** Au-delà, on découpe la tâche.
- On **rebase sur `develop`** avant d'ouvrir la PR. Pas de merge commit dans une branche de feature.
- La branche est supprimée après merge.

## 8.2 Pull requests

- **Cible : < 400 lignes de diff.** Au-delà de **800**, la PR est refusée et découpée. La qualité de
  revue s'effondre au-delà de ce seuil — c'est mesuré, ce n'est pas une question de bonne volonté.
- Exception : les fichiers **générés** (`openapi.json`, `*.freezed.dart`, `*.g.dart`, migrations)
  ne comptent pas dans le total, mais doivent être signalés dans la description.
- **Délai de revue cible : 4 h ouvrées.** Une PR en attente bloque un développeur sur deux.
- Le relecteur préfixe explicitement : `[bloquant]` · `[suggestion]` · `[question]`.
- On commente **le code, jamais la personne**. L'auteur répond à **chaque** commentaire.
- Désaccord > 2 allers-retours → appel de 5 min → décision du lead → ADR si c'est structurant.

**Modèle de description** (`.github/pull_request_template.md`) : Tâche · Ce que fait la PR · Ce
qu'elle ne fait pas (volontairement) · Contrat d'API · Tests · Guard-rails (checklist) · Comment
tester.

## 8.3 Definition of Ready / Done

**Ready — une tâche ne démarre pas sans :** un ID · un lien vers la ou les user stories du cadrage ·
des critères d'acceptation **observables** · une estimation en heures (max 8 h) · ses dépendances
identifiées et en `DONE`.

**Done — une tâche n'est finie que si :** code mergé, CI verte · critères vérifiés **manuellement**
par l'auteur · tests couvrant le cas passant **et** au moins un cas d'erreur · contrat régénéré si
nécessaire · i18n FR **et** AR · ligne déplacée dans `backlog/DONE.md` avec date et n° de PR ·
**`HISTORIQUE.md` §13 mis à jour** · rien de sensible loggé ni commité.

> Une tâche « finie à 90 % » compte pour **0 %**. Il n'y a pas de statut intermédiaire.

## 8.4 Labels — 6 familles, une dimension chacune (40 labels)

Convention `<famille>:<valeur>`. Une issue porte **au plus un label par famille** (sauf `domaine`).

| Famille | Valeurs |
|---|---|
| `type:` | `feat` `fix` `chore` `refactor` `test` `docs` `spike` `epic` |
| `lot:` | `socle` `backend` `mobile` `web` `admin` `design` — **c'est ce qui pilote CODEOWNERS** |
| `domaine:` | `auth` `catalog` `search` `providers` `contact` `reviews` `billing` `moderation` `analytics` |
| `prio:` | `P0` `P1` `P2` |
| `size:` | `S` (≤2 h) `M` (2-4 h) `L` (4-8 h — au-delà, découper) |
| `sprint:` | `S1` `S2` `S3+` |

**Les 8 labels transverses — ce sont eux qui font le travail :**

| Label | Sens |
|---|---|
| `contrat-api` | ⚠️ Modifie `contracts/openapi.json` — **prévenir l'autre dev AVANT le merge** |
| `binome` | À faire à deux : l'erreur y coûte trop cher pour être relue après coup |
| `securite` | Données personnelles, INPDP, secrets, anti-fraude |
| `rtl-ar` | Nécessite une vérification du rendu en arabe / RTL |
| `gate` | Porte de sprint — bloquante |
| `blocked` | Bloqué : voir le commentaire épinglé |
| `needs-decision` | Attend un arbitrage du lead — **ne pas coder** |
| `first-dart` | Bon point d'entrée pour découvrir Flutter/Dart |

## 8.5 Milestones — 7 incréments livrables et démontrables

| Milestone | Date | Contenu | Démo attendue |
|---|---|---|---|
| **M0 — Socle & Contrat** | 2026-08-17 | Monorepo, CI verte, PG+Redis, Fastify, générateurs tokens + i18n | `GET /v1/health` répond, CI verte sur une PR blanche |
| **M1 — Backend Core API** | 2026-08-20 | Auth OTP, géo, ranking, recherche, fiche, `ContactEvent`, avis, contrat publié | 🚦 **GATE 1** — les 8 appels `curl` du parcours cœur passent |
| **M2 — App Mobile MVP** | 2026-08-23 | Flutter : auth, recherche, fiche, contact tracé, avis, FR/AR + RTL | 🚦 **GATE 2** — APK signé sur un Android réel, parcours complet en 3G bridé |
| **M3 — Web SEO & Acquisition** | 2026-08-30 | `apps/web` SSG/ISR, JSON-LD, sitemap, Lighthouse ≥ 90 | Ce qui remplace les groupes Facebook dans Google |
| **M4 — Confiance & Back-office** | 2026-09-06 | KYC complet, file de vérification, modération, signalements, `apps/admin` | |
| **M5 — Monétisation** | 2026-09-13 | Plans, abonnements, crédits, boosts, 1ʳᵉ passerelle | **Bloqué tant que l'ADR-004 n'est pas tranché** |
| **M6 — Différenciation & Lancement** | 2026-09-27 | Vocal derja + RAG, push, worker BullMQ, E2E Maestro, observabilité, INPDP | ⚠️ **INPDP avant toute mise en production** |

## 8.6 Backlog et nomenclature

Flux à sens unique : `TODO.md` → `DOING.md` → `DONE.md` (et retour vers `TODO` si régression).

| Préfixe | Lot |
|---|---|
| `SO-xx` | Socle / infrastructure |
| `BE-xx` | Backend (API, domaine, données, auth) |
| `FW-xx` | Frontend Web (Next.js) |
| `FM-xx` | Frontend Mobile (Flutter) |
| `QA-xx` | Tests, recette, qualité |
| `OPS-xx` | Déploiement, environnements, observabilité |
| `DOC-xx` | Documentation, ADR |
| `EP-xxx` | Épique — à décomposer avant le sprint concerné |

**Un ID ne se réutilise jamais.** Un suffixe lettre marque un découpage a posteriori : `BE-15b`.
`DOING.md` : **maximum 2 tâches par développeur**. Si vous en avez 3, vous n'en finissez aucune.

## 8.7 Anti-conflit git — les fichiers à risque

`.gitattributes` marque les fichiers **générés** en `merge=ours -diff`. En cas de conflit, on
**régénère**, on ne fusionne jamais à la main :

| Fichier | Résolution |
|---|---|
| `contracts/openapi.json` | `git checkout --ours && pnpm api:contract && git add` |
| `*.g.dart`, `*.freezed.dart`, `*.gr.dart` | `dart run build_runner build --delete-conflicting-outputs` |
| tokens générés (`colors.ts`, `app_colors.dart`…) | `pnpm tokens:build` — la seule source à fusionner est `tokens.json` |
| `pnpm-lock.yaml` | ⚠️ **PAS** `merge=ours` (on perdrait des dépendances) → `git checkout --theirs && pnpm install` |

**Protocole de changement du contrat d'API** : label `contrat-api` sur l'issue → message dans
`#développement-du-backend` **AVANT le merge** → régénération immédiate du client Dart. Aucune
exception. `CODEOWNERS` impose la revue **des deux** développeurs sur `/Code/contracts/`.

## 8.8 CODEOWNERS — qui relit quoi

> ⚠️ **À faire** : le fichier `.github/CODEOWNERS` contient encore le placeholder
> `@CHAYMA-HANDLE`. Le remplacer par **`@yoyo2-hub`** (maintenant collaboratrice du dépôt), sinon
> les demandes de revue automatiques ne partent pas. Le tableau ci-dessous décrit l'intention.

| Chemin | Propriétaire |
|---|---|
| `*` (défaut) | `@dallel5-git` |
| `/.github/`, `/Code/tooling/`, configs racine | `@dallel5-git` |
| `/Code/apps/api/`, `/Code/packages/auth/`, `/Code/packages/validators/` | `@dallel5-git` |
| `/Code/packages/db/` **(schéma Prisma inclus)** | `@yoyo2-hub` — **seule propriétaire en S1** : c'est la règle qui évite le conflit le plus douloureux du projet, deux migrations concurrentes |
| `/Code/packages/core/` | `@yoyo2-hub` + `@dallel5-git` |
| `/Code/packages/design-tokens/`, `/Code/packages/i18n/` | les deux |
| `/Code/apps/mobile/`, `/Code/apps/mobile/lib/features/` | les deux (S1 : tout le monde dessus) |
| `/Code/apps/mobile/lib/core/api/` | `@yoyo2-hub` seule (client généré + intercepteurs) |
| `/Code/apps/mobile/lib/core/theme/` | `@dallel5-git` seul (thème généré depuis les tokens) |
| `/Code/apps/web/`, `/Code/apps/admin/` | `@dallel5-git` |
| `/Code/contracts/` | **les deux — revue obligatoire.** Un changement ici invalide le client Dart ET le futur client web |
| `/CLAUDE.md`, `/Code/docs/01-architecture-decision-records/`, `POLITIQUE-PROJET.md` | `@dallel5-git` |

## 8.9 Rituels et canaux

| Rituel | Quand | Format |
|---|---|---|
| **Daily** | 9h00 (Africa/Tunis), 10 min | **Écrit** dans `#a_vue_générale` : hier / aujourd'hui / bloqué par |
| **Point de mi-sprint** | Mercredi 14h, 20 min | Le périmètre tient-il ? Que coupe-t-on ? |
| **Revue de sprint** | Vendredi 16h, 45 min | Démo **sur un appareil réel**, pas sur l'émulateur du dev |
| **Rétrospective** | Vendredi 17h, 30 min | on garde / on arrête / on essaie |
| **Backlog** | En continu | `DOING.md` reflète l'instant présent |

| Canal Slack | Contenu |
|---|---|
| `#a_vue_générale` | Plan, décisions, dailies, jalons, arbitrages de périmètre |
| `#développement-du-backend` | Tâches backend, schéma, contrat d'API, migrations |
| `#developpement_frontend_web_mobile` | Tâches web + Flutter, design, i18n |
| `#tests-et-débogage` | Stratégie de test, bugs, CI rouge, post-mortems |
| `#déploiement-et-documentation` | Environnements, releases, runbook, documentation |

> **Une décision prise en DM n'existe pas.** Elle est reportée dans le canal concerné.

---

# 9. Sprint S1 — plan détaillé (17/08 → 23/08/2026)

## 9.1 Capacité

| | Heures-homme |
|---|---|
| Capacité (2 devs × 7 j × 8 h) | **112 h** |
| Charge 🔴 P0 | **~109 h** |
| Marge | **~3 %, c'est-à-dire aucune** |
| Amortisseur 🟠 P1 | **~18 h** |

*(Divergence corrigée le 2026-08-15 : `PLAN-MVP-SEMAINE-1.md` §2 et §10 annonçaient « ~15 h ».
La valeur exacte, cohérente avec son §3 et le backlog, est **18 h**.)*

**L'amortisseur se coupe dans cet ordre, au premier jalon manqué — pas au troisième :**
`BE-19`+`FM-11` (espace Pro, 7,5 h) → `BE-24`+`FM-12` (stats, 5 h) → `BE-20` (médias, 2,5 h) →
`BE-25`+`FM-13` (favoris, 3 h).

## 9.2 Découpage

```
          J1        J2        J3       J4 am │ J4 pm    J5        J6        J7
       ┌──────────────────────────────────────┬──────────────────────────────────┐
Oussama│      LOT 0 + LOT BACKEND             │      LOT MOBILE (Flutter)        │
Chayma │      (les 2 devs ensemble)           │      (les 2 devs ensemble)       │
       └──────────────────────────────────────┴──────────────────────────────────┘
        ▲                                    ▲                                  ▲
    Kick-off                            🚦 GATE 1                          🚦 GATE 2
                                 API figée + contrat publié              Recette sur
                                                                        Android réel
```

**Pourquoi le backend d'abord ?** C'est la partie **réversible**. Tant qu'aucune ligne de Dart de
présentation n'existe, la bascule Flutter s'annule sans coût (ADR-001 §4.3).

## 9.3 Planning jour par jour

| Jour | Date | Oussama | Chayma | Jalon du soir |
|---|---|---|---|---|
| **J1** | lun 17/08 | `SO-01` `SO-03` `SO-06` `SO-07` | `SO-02` `SO-04` `SO-05` | ✅ `GET /v1/health` répond · CI verte |
| **J2** | mar 18/08 | `BE-06` `BE-07` `BE-08` `BE-09` `BE-10` | `BE-01` `BE-02` `BE-03` `BE-04` | ✅ Parcours OTP en `curl` · 30 artisans en base |
| **J3** | mer 19/08 | `BE-11` `BE-12` `BE-13` `BE-16` `BE-17` | `BE-05` `BE-14` `BE-23` | ⭐ `BE-15` **en binôme** l'après-midi · **mi-sprint 14h** |
| **J4 am** | jeu 20/08 | `BE-18` `BE-22` `BE-26` | ⭐ `BE-21` **en binôme** | 🚦 **GATE 1** (11h) |
| **J4 pm** | jeu 20/08 | `FM-03` | `FM-01` | ⭐ `FM-02` **en binôme** · client Dart sur l'API réelle |
| **J5** | ven 21/08 | `FM-04` `FM-05` | `FM-06` `FM-07` | ✅ Auth + recherche · **revue de sprint 16h** |
| **J6** | sam 22/08 | `FM-08` | `FM-09` | ✅ **Parcours cœur complet** : recherche → fiche → appel tracé |
| **J7** | dim 23/08 | `FM-10` `QA-01` | `FM-14` `QA-03` | 🚦 **GATE 2** — recette sur Android réel |

## 9.4 Chemin critique

```
SO-02 ──► BE-01 ──► BE-03 ──► BE-04
                 │
                 └──► BE-15 (ranking) ──► BE-16 (search) ──┐
                                                           ├──► BE-26 (contrat) ──► FM-02 ──► tout Flutter
BE-09 (JWT) ──► BE-12 (RBAC) ──► BE-21 (contact) ─────────┘
```

**Les 5 tâches qui font glisser tout le sprint si elles dérapent :**
`BE-01` (schéma) · `BE-15` (ranking) · `BE-21` (contact) · `BE-26` (contrat) · `FM-02` (couche
réseau).

**Trois d'entre elles se font en binôme** (`BE-15`, `BE-21`, `FM-02`), avec les deux recettes
(`BE-27` GATE 1, `QA-03` GATE 2) — soit les **5 tâches en binôme** du sprint. Ce n'est pas un
hasard : *on met deux personnes là où l'erreur coûte le plus cher, pas là où le travail est le plus
volumineux.* `BE-01` (Chayma seule, propriétaire du schéma) et `BE-26` (Oussama seul) restent
critiques mais mono-pilotées — leur risque est couvert par `CODEOWNERS`, pas par le binôme.

## 9.5 🚦 GATE 1 — recette backend (J4 matin, 45 min)

Le parcours cœur doit passer **en `curl`, dans cet ordre**, sans intervention manuelle en base :

```bash
1. POST /v1/auth/otp/request   {phone:"+21622123456"}   → 200, OTP dans le log
2. POST /v1/auth/otp/verify    {phone, code}            → 200, access + refresh
3. GET  /v1/categories                                  → arbre FR/AR
4. GET  /v1/providers/search?category=plomberie&governorate=sousse
                                                        → ≥ 5 items triés, nextCursor
5. GET  /v1/providers/:slug                             → fiche, SANS téléphone
6. POST /v1/contact-events     {providerId, channel:"PHONE"}
                                                        → 200 + téléphone révélé
7. POST /v1/providers/:id/reviews {rating:5, comment}   → 200, ratingAvg recalculé
8. GET  /v1/auth/me                                     → profil + rôles
```

Plus : `openapi.json` commité et `--check` vert · client Dart généré sans erreur · **aucun
téléphone, OTP ou token dans les logs** · tests de ranking verts dont le garde-fou ADR-002.

> ❗ **Un seul point rouge ⇒ on ne démarre pas Flutter.** On termine le backend en J4 après-midi et
> on coupe tout le bloc 🟠 P1. Démarrer sur une API instable coûte deux fois.

## 9.6 🚦 GATE 2 — recette de fin de sprint (J7, 1 h)

Sur un **Android réel**, en **3G bridé**, en **français puis en arabe** — 15 scénarios :

APK installé sur un Android non-dev · recherche « Plombier · Sousse » ≥ 5 résultats classés · filtre
« Vérifié uniquement » · fiche complète · clic « Appeler » → composeur avec le bon numéro ·
`ContactEvent` enregistré · clic « WhatsApp » → message pré-rempli **dans la langue active** ·
connexion OTP de bout en bout · avis après contact → moyenne mise à jour · avis **sans** contact →
refusé · bascule en arabe sans casse de mise en page · mode avion → cache, **pas d'écran blanc** ·
appel **hors ligne** → composeur s'ouvre, événement envoyé au retour du réseau · défilement fluide
sur entrée de gamme · **aucune donnée sensible dans les logs**.

**Livrables du soir de J7** : `main` verte + backend déployé sur staging · **un APK Android signé,
testé sur un appareil réel** · `openapi.json` publié · backlog à jour et re-priorisé pour S2 · une
rétrospective écrite.

## 9.7 Risques et replis

| Risque | Prob. | Impact | Repli |
|---|---|---|---|
| **Aucun des deux devs ne connaît Flutter** | Élevée | Élevé | J4 pm = demi-journée de socle sans métier. `FM-02` à deux. Repli : app **client seulement** (couper `FM-11/12/13`) — le parcours cœur reste complet. |
| Backend déborde au-delà de J4 matin | Moyenne | Élevé | `BE-19` déjà hors chemin critique. Couper ensuite `BE-23`. **Ne jamais couper `BE-21`.** |
| Le ranking devient un puits de temps | Moyenne | Moyen | **Timeboxé à 4 h.** Au-delà : version simplifiée (géo + bayésien + vérifié), `BE-15b` créé. Les poids étant en base, l'affiner plus tard ne coûte rien. |
| OTP SMS non ouvert chez le fournisseur | Élevée | Faible en S1 | Adaptateur `console` suffit. Ouvrir le compte est **administratif**, à lancer J1. |
| RTL casse la mise en page en fin de semaine | Élevée | Moyen | Vérifier en AR **à chaque écran, le jour même** — pas en J7. |
| Le contrat bouge après GATE 1 | Moyenne | Élevé | Message dans `#développement-du-backend` **avant** le merge + régénération immédiate. Aucune exception. |
| Week-end non travaillé | — | Élevé | Capacité → ~80 h : couper tout le bloc 🟠 P1, GATE 2 glisse au lundi. **Décision lundi matin, pas vendredi soir.** |

## 9.8 Ce qui est reporté (et pourquoi c'est acceptable)

| Reporté | Vers | Contournement / raison |
|---|---|---|
| `apps/web` en entier | **S2** | Backend déjà prêt — S2 n'est que de la consommation d'API (~35 h) |
| Upload et vérification CIN (KYC) | S2 | `isVerified` posé **à la main en base** sur les 20 premiers artisans du Sahel — c'est exactement le « Label de Confiance » du plan terrain |
| Paiements, abonnements, crédits, boosts | S2-S3 | Rien à monétiser sans audience. `Plan` seedé avec `FREE` seul. ADR-004 non tranché |
| Régie publicitaire B2B | S4+ | Zéro annonceur au jour 1 |
| Back-office complet | S2 | **Prisma Studio** en accès restreint |
| Notifications push | S2 | Nécessite Firebase et une base d'installation |
| `ServiceRequest` | S3 | Entités modélisées, points d'extension préservés, aucun écran |
| Worker BullMQ | S2 | Agrégats recalculés en transaction. Nécessaire au-delà de ~500 artisans |
| **Recherche vocale derja + RAG** | **S3** | La fonctionnalité différenciante. Elle mérite **son propre sprint**, pas un reste de semaine |
| iOS | S3 | Android d'abord — 90 %+ du marché cible. Le code Flutter reste portable |

---

# 10. État d'avancement

*Au 2026-08-15 — sprint S1 non démarré (démarre le lundi 17/08).*

## 10.1 Terminé (Sprint S0 — cadrage)

| ID | Tâche | Terminé le |
|---|---|---|
| `DOC-00` | Document de cadrage technique v1.0 | 2026-08-12 |
| `DOC-00b` | Étude de marché & stratégie (concurrence, go-to-market Sahel, modèle économique) | 2026-08-12 |
| `SO-00` | Squelette d'arborescence du monorepo + workflows CI (fichiers vides) | 2026-08-12 |
| `DES-00` | Maquettes Sanaya — web, mobile, back-office, thèmes clair et sombre | 2026-08-12 |
| `DOC-01` | **ADR-001** — Mobile Flutter, contrat REST/OpenAPI | 2026-08-15 |
| `DOC-02` | **ADR-002** — Badge « Vérifié » gratuit | 2026-08-15 |
| `DOC-02b` | **ADR-003** — Périmètre S1 mobile-first | 2026-08-15 |
| `DOC-03` | Politique de projet v1.0 | 2026-08-15 |
| `DOC-04` | Mémoire projet + guard-rails (`CLAUDE.md` racine et par lot) | 2026-08-15 |
| `DOC-05` | Plan MVP semaine 1 découpé en lots et en tâches | 2026-08-15 |
| `DOC-06` | Backlogs TODO / DOING / DONE | 2026-08-15 |
| `SO-04a` | Design tokens extraits de la maquette (`tokens.json` → TS + Dart) | 2026-08-15 |
| `ORG-01` | **Organisation GitHub complète** : 40 labels, 7 milestones, 56 issues, templates, CODEOWNERS, `.gitattributes`, scripts idempotents | 2026-08-15 |

## 10.2 Compteur du sprint S1

| Métrique | Valeur |
|---|---|
| Tâches 🔴 P0 planifiées | 43 |
| Tâches 🔴 P0 terminées | **0** |
| Tâches 🟠 P1 terminées | **0 / 7** *(amortisseur : 18 h)* |
| Heures-homme P0 estimées / consommées | **109 h / 0 h** *(capacité 112 h)* |

> Mettre à jour ce compteur **au daily**. C'est le seul indicateur qui dira mercredi si le périmètre
> tient — et mercredi est le dernier jour où couper coûte encore peu.

## 10.3 Bloqués

| ID | Bloqué par | Qui débloque | Action attendue |
|---|---|---|---|
| `BE-08` | Compte SMS non ouvert chez le fournisseur | Oussama | Adaptateur `console` en attendant — **non bloquant**. Lancer la démarche J1. |
| `BE-33` | Question 2 du cadrage (moyens de paiement) | Oussama | Rédiger **ADR-004** avant S2 |
| `BE-38` | Question 3 du cadrage (annuaire ou marketplace) | Oussama | Rédiger **ADR-005** avant S2 |

> Une tâche bloquée depuis **plus de 24 h** remonte automatiquement dans `#a_vue_générale` au daily.

## 10.4 Issues GitHub

**56 issues** créées, réparties : `sprint:S1` **50** · `sprint:S2` **3** · `sprint:S3+` **3**.

Les 6 épiques (à décomposer avant leur sprint) : `EP-WEB` (#45) · `EP-KYC` (#46) · `EP-ADMIN` (#47)
· `EP-BILLING` (#48) · `EP-VOCAL` (#49) · `EP-DURCISSEMENT` (#50).

Répartition des 50 issues du sprint : Oussama 25 · Chayma 20 · **binôme 5** (`BE-15`, `BE-21`,
`BE-27`, `FM-02`, `QA-03`).

---

# 11. Sécurité, données personnelles, conformité

> **Cadre légal** : loi organique n°2004-63 relative à la protection des données à caractère
> personnel. **Déclaration INPDP à effectuer avant la mise en production — c'est un jalon bloquant,
> pas une formalité.**

## 11.1 Secrets

Aucun secret dans le dépôt, **jamais**, même temporairement, même dans une branche. Un secret
commité est un secret **révoqué** : on le change, on ne se contente pas de le retirer du diff.
`.env.example` versionné avec des valeurs factices. Secrets CI : GitHub Actions Secrets. Production :
coffre du fournisseur. **Rotation des clés à chaque départ d'un intervenant.**

## 11.2 Traitement des données sensibles

| Donnée | Traitement obligatoire |
|---|---|
| **Image de CIN** | Bucket privé chiffré (SSE), URL signée **5 min**, accès journalisé dans `AuditLog`, purge automatique à J+X après décision |
| **Numéro de CIN** | Jamais en clair : hash + chiffrement AES-256-GCM si conservation nécessaire |
| **OTP** | Haché, TTL 5 min, 3 tentatives, rate-limit par téléphone **et** par IP |
| **Téléphone** | Normalisé, non exposé en HTML brut, révélé par appel API tracé et limité |
| **Mot de passe interne** | Argon2id. **2FA obligatoire** pour tout compte `ADMIN` / `MODERATOR` |
| **Refresh token** | Rotatif, révocable, cookie `httpOnly` (web) / `flutter_secure_storage` (mobile) |

## 11.3 Droits des personnes

Le droit d'accès, d'export et de suppression (`US-C-13`, `BE-41`) **n'est pas une fonctionnalité
« nice to have » : c'est une obligation légale.** Prévu dès le socle : `User.deletedAt` +
anonymisation, et un export JSON.

## 11.4 Infrastructure

HTTPS strict + HSTS · CSP · dépendances auditées (`pnpm audit` en CI hebdomadaire) · sauvegardes
PITR quotidiennes avec **restauration testée trimestriellement** — *une sauvegarde jamais restaurée
n'est pas une sauvegarde*.

---

# 12. Environnements, tests, déploiement

## 12.1 Environnements

| Env | Branche | Base | Déploiement | Données |
|---|---|---|---|---|
| `local` | — | Docker (PG16 + Redis) | `pnpm dev` | Seed + jeu de démo |
| `preview` | toute PR | base éphémère | automatique | Seed |
| `staging` | **`develop`** | base dédiée | automatique au merge | Anonymisées |
| `production` | tag `v*` depuis `main` | base managée + PITR | **manuel, validé par le lead** | Réelles |

- Les migrations tournent **avant** le déploiement applicatif, jamais après.
- Toute migration destructive suit le motif **expand → migrate → contract** en **3 déploiements**.
  Jamais en une fois.
- Rollback documenté dans `docs/05-runbook.md` et **testé une fois** avant le premier déploiement
  en production.
- **Aucun déploiement en production le vendredi après 15h.**

## 12.2 Stratégie de test

| Niveau | Outil | Périmètre | Obligatoire ? |
|---|---|---|---|
| Unitaire | **Vitest** | `packages/core` — ranking, policies, éligibilité, montants, dates | ✅ **Oui, sans exception** |
| Unitaire | `flutter_test` + `mocktail` | widgets critiques, mappers, providers Riverpod | ✅ sur les écrans de conversion |
| Intégration | Vitest + base jetable | routes `apps/api` avec une vraie PostgreSQL | ✅ sur **toute route qui écrit** |
| E2E web | **Playwright** | recherche → fiche → contact | ✅ 1 parcours minimum |
| E2E mobile | **Maestro** | OTP → recherche → contact | ⚠️ à partir de S2 |

**Les règles d'application (ADR-006) :**

1. **Tout changement de comportement s'accompagne d'un test** — cas passant *et* au moins un cas
   d'erreur. Exemptions (doc, fichiers générés, renommage, formatage, montée de version, outillage)
   **déclarées** dans la PR en cochant la case. Le contrôle `Tests exigés` refuse le merge sinon.
2. **Toute correction de bug commence par un test qui reproduit le bug** : l'écrire → **le voir
   échouer** → corriger → committer les deux. Le test porte `// régression #<issue>`.
3. **Les tests `🔒 NON-RÉGRESSION` ne se suppriment pas** sans ADR annulant la décision d'origine.
4. **Aucun seuil de couverture chiffré** — un pourcentage se triche.
5. Aucun test désactivé (`.skip`, `@Skip`) sans `// TODO(<ID>)` et une ligne dans le backlog.
6. Les tests de `packages/core` ne touchent **jamais** la base ni le réseau. S'ils en ont besoin,
   c'est que la logique est mal placée.

**Les 8 tests protégés `🔒` du sprint S1** (squelettes pré-écrits, dans `tests/`) :

| Test | Tâche | Protège |
|---|---|---|
| artisan gratuit vérifié > Pro non vérifié | `BE-15` | ADR-002 — le badge reste gratuit |
| deux clics en 5 min = un seul événement | `BE-21` | P9 — statistiques vendables |
| rejeu du refresh révoque la famille | `BE-09` | sécurité — token volé inutilisable |
| toutes les écritures du numéro convergent | `BE-06` | P4 — pas de compte en double |
| événement posté **avant** l'ouverture du lien | `FM-09` | P9 — le lead n'est jamais perdu |
| le composeur s'ouvre même si l'API échoue | `FM-09` | P5 — on ne bloque jamais l'utilisateur |
| l'événement échoué part en file locale | `FM-09` | P9 — renvoi au retour du réseau |
| refresh token hors de `SharedPreferences` | `FM-02` | sécurité — Keystore uniquement |

> En revue, la question n'est pas « y a-t-il un test ? » mais
> **« si je casse cette ligne, est-ce que ce test devient rouge ? »**

## 12.3 CI bloquante — `.github/workflows/`

**`ci.yml`** — 5 jobs. Le job `verdict` agrège les quatre autres : c'est **lui seul** qu'on met en
*required status check* sur `main` et `develop`, pour ne pas avoir à toucher la protection de
branche à chaque nouveau job.

| Job | Contenu |
|---|---|
| `garde-fous` | Aucun `.env` commité · aucun secret évident dans le diff (`sk_live_`, `AKIA…`, clé privée, URL de base avec mot de passe, JWT) · aucun test désactivé sans `TODO(<ID>)` · **aucun test `🔒` supprimé** · aucun `console.log` dans `apps/api`. Volontairement en premier, sans dépendance : échouer ici doit être immédiat. |
| `qualite-ts` | `pnpm lint` (dont `no-restricted-imports` — P1) · `typecheck` · `api:contract --check` (P2) · `i18n:check` (P7) · tokens générés à jour |
| `tests-ts` | Vitest avec une **vraie PostgreSQL 16 + Redis 7** en services. Pas de mock : les `CHECK`, index partiels et le trigger `prevent_self_review` sont du SQL — un mock ne les exécute pas, donc ne prouve rien. |
| `mobile` | `dart format --set-exit-if-changed` · fichiers générés à jour · `flutter analyze --fatal-warnings` (**zéro warning**) · `flutter test`. Se saute proprement tant que `apps/mobile` n'existe pas. |
| `verdict` | Agrège. `always()` + test explicite des résultats, sinon un job **sauté** compterait comme un succès. |

**`pr-tests.yml`** — le contrôle « Où est le test ? » (ADR-006 règle 1). Il compare les fichiers de
code modifiés aux fichiers de test modifiés, en excluant doc, backlog, outillage, migrations et
fichiers générés. Sans test ni exemption cochée dans la description : **merge refusé**.

> Ce contrôle ne juge pas la *qualité* du test — aucune machine ne sait le faire. Il rend
> l'absence de test **visible et délibérée**. C'est tout son objectif.

**Cible : < 5 min** grâce au cache Turborepo. Au-delà de 10 min, la CI cesse d'être un filet et
devient un péage : on la contournera. C'est un budget, pas un souhait.

**Si `main` ou `develop` est rouge, c'est la priorité n°1 de toute l'équipe, avant toute autre
tâche.** Astreinte en rotation quotidienne.

---

# 13. 📜 JOURNAL DES CHANGEMENTS

> **Ordre antichronologique : le plus récent en haut.**
> Format : `**[LOT]** <ID> — <ce qui a changé et pourquoi>. <trace>. *(qui)*`
> **On n'efface jamais une entrée.** On corrige par une nouvelle entrée datée.

---

### 2026-08-15

- **[CI]** **Tests obligatoires et non-régression mis en application** — la stratégie de test
  existait (`POLITIQUE-PROJET.md` §6), rien ne l'imposait. Livré :
  - **`ADR-006`** — trois règles opposables : un test par changement de comportement (exemptions
    déclarées, pas supposées) · tout bug commence par un test qu'on a **vu échouer** · les tests
    `🔒 NON-RÉGRESSION` ne se suppriment pas sans ADR. Explicitement **sans seuil de couverture
    chiffré** : un pourcentage se triche. *(Numéroté 006 — 004 et 005 restent réservés aux questions
    paiements et annuaire/marketplace.)*
  - **`.github/workflows/ci.yml`** — 5 jobs (garde-fous, qualité TS, tests avec PostgreSQL 16 +
    Redis 7 réels, Flutter, verdict). Le job `verdict` est le seul *required status check* à
    déclarer sur `main` et `develop`.
  - **`.github/workflows/pr-tests.yml`** — contrôle « Où est le test ? » : refuse une PR qui touche
    du code sans toucher un test, sauf exemption cochée dans la description.
  - **5 fichiers de tests pré-écrits** (`tests/`) pour les 5 tâches du chemin critique — `BE-15`
    ranking (dont le garde-fou ADR-002), `BE-21` contact/dédup, `BE-09` JWT rejeu + `BE-07` OTP,
    `BE-06` phone-tn, `FM-09`/`FM-02` contact mobile et file hors ligne. Ils **échouent
    volontairement** : ils décrivent le comportement attendu avant que le code existe. **8 tests
    marqués `🔒`.**
  - `POLITIQUE-PROJET.md` §6 et `.github/pull_request_template.md` mis à jour en conséquence.
  *(Oussama / Claude)*
- **[DOC]** Correction de deux incohérences de documentation relevées lors de la relecture croisée
  de `HISTORIQUE.md` :
  - `CLAUDE.md` §1 listait `ads` **à la place de** `contacts` dans les 9 modules métier. La liste
    fait désormais foi partout : `auth` `catalog` `providers` `search` `contacts` `reviews`
    `billing` `moderation` `analytics`, `ads` étant explicitement daté S4+.
  - `PLAN-MVP-SEMAINE-1.md` §2 et §10 annonçaient un amortisseur 🟠 P1 de « ~15 h » alors que son
    propre §3 et `backlog/TODO.md` donnent **18 h**. Les deux occurrences sont alignées sur 18 h.
  *(Oussama / Claude)*
- **[PROCESS]** Création de la branche **`develop`**, identique à `main`, comme branche de
  **staging**. Toutes les branches de travail partent de `develop` et y sont mergées ; `main` n'est
  plus alimentée que par une PR de release depuis `develop` (ou un `hotfix/*`). Le modèle de
  branches de `POLITIQUE-PROJET.md` §3.1 est étendu en conséquence. Voir §8.1. *(Oussama)*
- **[DOC]** **Création de `HISTORIQUE.md`** (ce fichier) — mémoire complète du projet : schémas
  d'architecture, décisions, invariants, guard-rails, conventions, organisation GitHub, plan de
  sprint, état d'avancement, et consignes de maintenance pour tout assistant IA. *(Oussama / Claude)*
- **[PROCESS]** `ORG-01` — **Organisation GitHub complète mise en place**, par scripts idempotents
  (`setup-github.sh` → `gh-bootstrap.sh` → `gh-seed-issues.sh`, audit par `gh-verify.sh`) :
  - **40 labels** : 32 en 6 familles + 8 transverses ; labels GitHub par défaut supprimés
  - **7 milestones** datés (M0 → M6) avec critères de démo
  - **56 issues** générées depuis `issues-data.py` (source unique) : 50 en `sprint:S1`, 3 en `S2`,
    3 en `S3+` ; dépendances converties en liens `#N` et issues bloquées marquées `blocked`
  - Templates d'issue (`01-tache.yml`, `02-bug.yml`, `03-decision.yml`), modèle de PR,
    `CODEOWNERS`, `.gitattributes` (fichiers générés en `merge=ours -diff`)
  *(Oussama / Claude)*
- **[PROCESS]** Chayma (**@yoyo2-hub**) ajoutée comme **collaboratrice** du dépôt. Les 6 issues
  épiques créées avant son acceptation lui ont été assignées a posteriori (#45 à #50).
  `@CHAYMA-HANDLE` reste à remplacer par `@yoyo2-hub` dans `.github/CODEOWNERS`. *(Oussama)*
- **[PROCESS]** **Protection de `main` activée** : push direct interdit (y compris pour le lead),
  passage par PR obligatoire, 1 approbation. Première PR de mise en place : **#57**, approuvée par
  @yoyo2-hub. *(Oussama)*
- **[DOC]** `DOC-02b` — **ADR-003** : le sprint S1 livre le mobile, **`apps/web` reporté en S2**.
  Recomptage de la charge : 159 h-homme planifiées pour 112 h disponibles (+42 %). Deux règles de
  planification permanentes en découlent : une tâche en binôme compte double ; deux surfaces en
  parallèle coûtent la somme de leurs charges. *(Oussama / Claude)*
- **[DOC]** `DOC-05` — `PLAN-MVP-SEMAINE-1.md` **v2.0**, re-cadré : charge P0 ramenée à ~109 h,
  marge ~3 %, amortisseur 🟠 P1 de ~18 h avec ordre de coupe explicite. *(Claude)*
- **[DOC]** `DOC-02` — **ADR-002** : le badge « Artisan Vérifié » est **gratuit** et fondé sur
  l'identité, strictement indépendant de `Subscription`. Garde-fou de test obligatoire dans
  `packages/core/tests/ranking.test.ts`. *(Oussama / Claude)*
- **[DOC]** `DOC-01` — **ADR-001** : mobile en **Flutter**, web/admin en **Next.js**, API REST
  **Fastify + Zod + OpenAPI** autonome. **Rend obsolète** le « Expo / React Native + tRPC » du
  cadrage v1.0. Le contrat devient `contracts/openapi.json`, généré et vérifié en CI. *(Oussama / Claude)*
- **[DOC]** `DOC-03` / `DOC-04` / `DOC-06` — Politique de projet v1.0, `CLAUDE.md` racine + par lot
  (backend, mobile, web), backlogs `TODO`/`DOING`/`DONE`. *(Claude)*
- **[DESIGN]** `SO-04a` — Design tokens extraits de la maquette : `tokens.json` devient la source
  unique, générant le preset Tailwind (TS) **et** le thème Dart. *(Claude)*

### 2026-08-12

- **[DOC]** `DOC-00` — Document de cadrage technique v1.0 : user stories, schéma Prisma complet,
  index SQL, arborescence du monorepo. ⚠️ Ses choix mobile (`Expo/RN`) et transport (`tRPC`) ont été
  **remplacés le 15/08 par l'ADR-001**. *(Oussama)*
- **[DOC]** `DOC-00b` — Étude de marché et stratégie : concurrence (groupes Facebook), failles du
  marché, go-to-market Sahel, modèle économique. *(Oussama)*
- **[SOCLE]** `SO-00` — Squelette d'arborescence du monorepo + workflows CI (fichiers vides). *(Oussama)*
- **[DESIGN]** `DES-00` — Maquettes Sanaya : web, mobile, back-office, thèmes clair et sombre.
  *(Oussama / Claude Design)*

---

# 14. Glossaire

| Terme | Sens précis dans ce projet |
|---|---|
| **Prestataire / Artisan** | `ProviderProfile`, lié 1-1 à un `User` de rôle `PROVIDER` |
| **Lead / Contact** | `ContactEvent` — un clic « appeler » ou « WhatsApp » tracé. **C'est l'unité de valeur vendue.** |
| **Avis certifié** | `Review` rattachée à un `ContactEvent` réel (1-1, unique). Garde-fou anti-faux-avis (P10). |
| **Vérifié** | `ProviderProfile.isVerified` — identité CIN validée. **Gratuit** (ADR-002). |
| **Boost** | Emplacement sponsorisé **hors ranking**, explicitement étiqueté « Sponsorisé ». N'altère jamais le `rankingScore`. |
| **Gouvernorat / Délégation** | Découpage administratif tunisien : 24 gouvernorats, ~264 délégations. Référentiel figé, seedé. |
| **Complétude** | `completionScore` /100 — moteur d'activation de l'artisan, pondéré dans le ranking. Publication refusée sous 60 %. |
| **Millime** | 1/1000 TND. Unité de stockage de **tous** les montants. |
| **GATE** | Porte de sprint bloquante. GATE 1 = recette backend en `curl` ; GATE 2 = recette sur Android réel. |
| **Amortisseur** | La liste 🟠 P1 — le seul volant de manœuvre du sprint. À couper au **premier** jalon manqué. |
| **INPDP** | Instance nationale de protection des données personnelles (Tunisie). **Déclaration bloquante avant production.** |
| **Derja** | Dialecte tunisien. Cible de la recherche vocale différenciante (S3). |
| **Épique (`EP-`)** | Regroupement à décomposer en tâches avant le sprint concerné. |

---

*Fin de `HISTORIQUE.md`. Si tu es un assistant et que tu as modifié quoi que ce soit au projet :
**reviens au §0.2 et écris ton entrée dans le journal §13.***
