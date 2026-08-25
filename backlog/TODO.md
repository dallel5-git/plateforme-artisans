# TODO — Sprint S1 (17/08 → 23/08/2026) · **Mobile d'abord**

> Objectif : *un habitant de Sousse installe l'APK, cherche « plombier », trouve un artisan, l'appelle — et l'appel est compté.*
> Mise à jour : 2026-08-15 (**v2.0**, re-cadré après recomptage de la charge — voir `ADR-003`)
> Critères d'acceptation détaillés : `Code/docs/PLAN-MVP-SEMAINE-1.md`

| | Heures-homme |
|---|---|
| **Capacité** (2 devs × 7 j × 8 h) | **112 h** |
| **Charge 🔴 P0** | **~109 h** |
| **Marge** | **~3 %, c'est-à-dire aucune** |
| **Amortisseur 🟠 P1** | **18 h** — à couper dans l'ordre : `BE-19`+`FM-11`, `BE-24`+`FM-12`, `BE-20`, `BE-25`+`FM-13` |

⚠️ **Une tâche en binôme compte DOUBLE** en heures-homme. C'est ce qui avait faussé la v1 de ce plan.
⚠️ **`apps/web` est reporté au sprint S2** (ADR-003). À partir de J4, les 2 devs sont sur Flutter.

---

## LOT 0 — Socle · J1 · 11,5 h

| ID | Tâche | Prio | Qui | Est. | Dépend de | US |
|---|---|---|---|---|---|---|
| `SO-07` | Protection de `main`, modèle de PR, `.env.example`, CODEOWNERS | 🔴 | DEV-1 | 0,5 h | SO-06 | US-T-05 |

## LOT BACKEND — J2 → J4 matin · ~53 h (P0) + 5,5 h (P1)

### Données — DEV-2

| ID | Tâche | Prio | Qui | Est. | Dépend de | US |
|---|---|---|---|---|---|---|

### Auth & sécurité — DEV-1

| ID | Tâche | Prio | Qui | Est. | Dépend de | US |
|---|---|---|---|---|---|---|

### Métier & API

| ID | Tâche | Prio | Qui | Est. | Dépend de | US |
|---|---|---|---|---|---|---|

## LOT MOBILE — Flutter · J4 pm → J7 · **les 2 devs** · ~43 h (P0) + 10 h (P1)

| ID | Tâche | Prio | Qui | Est. | Dépend de | US |
|---|---|---|---|---|---|---|
| `FM-02` | ⭐ Dio + Retrofit **générés**, intercepteurs (JWT, refresh, retry, offline), secure storage | 🔴 | **binôme** | 4 h *(8 h-h)* | BE-26 | ADR-001 |
| `FM-04` | Widgets DS (AppButton, ProviderCard, RatingStars, VerifiedBadge, Skeleton, Empty, Error, OfflineBanner) | 🔴 | DEV-1 | 4 h | FM-01 | — |
| `FM-05` | Auth : rôle → téléphone → OTP → session persistée | 🔴 | DEV-1 | 3,5 h | BE-10, FM-02 | US-C-02 |
| `FM-06` | Accueil client : recherche + grille de catégories (depuis l'API) | 🔴 | DEV-2 | 3 h | BE-14 | US-C-01 |
| `FM-07` | ⭐ Résultats : `ListView.builder` + curseur + filtres + **cache disque** | 🔴 | DEV-2 | 4,5 h | BE-16 | US-C-01/03, P5 |
| `FM-08` | Fiche artisan : galerie, tarifs, zones, avis, badge | 🔴 | DEV-1 | 4 h | BE-17 | US-C-04 |
| `FM-09` | ⭐⭐ Contact tel/WhatsApp + `ContactEvent` **avant** ouverture + **file offline** | 🔴 | DEV-2 | 3,5 h | BE-21 | US-C-05/06, P9 |
| `FM-10` | Dépôt d'avis après contact | 🔴 | DEV-1 | 2,5 h | BE-22 | US-C-07 |
| `FM-14` | Build Android release signé + **APK pour les beta-testeurs du Sahel** | 🔴 | DEV-2 | 2 h | FM-09 | — |
| `FM-11` | Espace Pro : assistant d'onboarding + `completionScore` en direct | 🟠 | — | 5 h | BE-19 | US-P-02→04 |
| `FM-12` | Espace Pro : tableau de bord statistiques | 🟠 | — | 3 h | BE-24 | US-P-07/US-P-08 |
| `FM-13` | Favoris + réglages (langue, déconnexion) | 🟠 | — | 2 h | BE-25 | US-C-08 |

## QUALITÉ

| ID | Tâche | Prio | Qui | Est. | Dépend de |
|---|---|---|---|---|---|
| `QA-03` | 🚦 **GATE 2** — recette (15 scénarios, Android réel, FR + AR, 3G) | 🔴 | binôme | 1 h *(2 h-h)* | FM-14 |

---

## ⚪ Reporté au sprint S2 — **ne pas commencer**

### Lot WEB — priorité n°1 de S2 (~35 h, backend déjà prêt)

| ID | Tâche | Est. |
|---|---|---|
| `FW-01` | Bootstrap Next.js 15 + Tailwind v4 + preset tokens + polices | 2 h |
| `FW-02` | Routing `[locale]` FR/AR, `dir` global, i18next, `hreflang` | 2,5 h |
| `FW-03` | Client `openapi-fetch` + TanStack Query + refresh en cookie httpOnly | 2 h |
| `FW-04` | Primitives UI (Button, Input, Badge, Card, Rating, Skeleton, Empty, Error) | 3,5 h |
| `FW-05` | Home : héro, barre de recherche, catégories populaires | 3 h |
| `FW-06` | ⭐ `/[locale]/[gouvernorat]/[service]` en **SSG + ISR** + `generateStaticParams` | 4 h |
| `FW-07` | Liste + `ProviderCard` + pagination curseur + états loading/empty/error | 3 h |
| `FW-08` | Fiche artisan + galerie + **JSON-LD LocalBusiness / AggregateRating** | 4 h |
| `FW-09` | Contact : `ContactEvent` → révélation du numéro → `tel:` / `wa.me` | 2,5 h |
| `FW-10` | Auth OTP web | 3 h |
| `FW-11` | Formulaire d'avis | 2 h |
| `FW-12` | `sitemap.xml` + `robots.txt` dynamiques + Open Graph | 2 h |
| `FW-13` | Onboarding artisan sur le web | 4 h |
| `FW-15` | Perf : `next/image`, budget bundle, **Lighthouse ≥ 90 en 3G** | 2 h |
| `QA-02` | Playwright — recherche → fiche → contact | 2 h |

### Le reste

| ID | Tâche | Note |
|---|---|---|
| `BE-30` | KYC complet : upload CIN, bucket privé chiffré, URL signées 5 min, purge, journal d'accès | Conformité INPDP — **jalon bloquant avant production** |
| `BE-31` | File de vérification back-office + décisions + notifications | Maquette déjà dessinée |
| `BE-32` | Plans, abonnements, cycle de vie, période de grâce | Plan `FREE` seul en S1 |
| `BE-33` | Passerelle de paiement (Konnect / Paymee / Flouci) derrière `PaymentGateway` | **Bloqué : question 2 du cadrage non tranchée** |
| `BE-34` | Crédits, portefeuille, transactions immuables | Dépend de BE-32 |
| `BE-35` | Boosts (emplacements sponsorisés, **hors ranking**) | Dépend de BE-34 |
| `BE-36` | Worker BullMQ : agrégats, expirations, digest hebdomadaire | Nécessaire au-delà de ~500 artisans |
| `BE-37` | Régie publicitaire B2B | Zéro annonceur au jour 1 |
| `BE-38` | `ServiceRequest` / `ServiceRequestMatch` | Entités modélisées, points d'extension préservés |
| `BE-39` | ⭐ **Recherche vocale en derja + transcription + RAG** | **La fonctionnalité différenciante du doc de stratégie. Sprint dédié — S3.** |
| `BE-40` | Signalements et modération a posteriori | P10 |
| `BE-41` | Export / suppression des données personnelles (US-C-13) | **Obligation légale** — avant production |
| `BE-42` | Index GIN trigram FR/AR (coupé de `BE-02`) | Quand le volume l'exigera |
| `FW-20` | Back-office admin complet (`apps/admin`) | Prisma Studio en contournement S1 |
| `FM-20` | Notifications push (Firebase) | Sans base d'installation, sans objet |
| `FM-21` | Build et publication iOS | Android d'abord (90 %+ du marché cible) |
| `OPS-01` | Déploiement staging + production, migrations avant déploiement | |
| `OPS-02` | Sauvegardes PITR + **restauration testée** | Une sauvegarde jamais restaurée n'est pas une sauvegarde |
| `OPS-03` | Observabilité : Sentry, logs, PostHog | Sentry coupé de `BE-13` |
| `DOC-01` | **Déclaration INPDP** | ⚠️ **Bloquant avant production** — démarche administrative, à lancer tôt |
| `DOC-04` | ADR-004 : moyens de paiement (question 2 du cadrage) | À trancher avant S2 |
| `DOC-05` | ADR-005 : annuaire ou place de marché ? (question 3 du cadrage) | Détermine si `ContactEvent` devient un cycle de vie de mission |

---

## 🆕 Backlog non planifié

_Toute idée surgie en cours de sprint atterrit ici, avec un ID, et n'est jamais prise dans le sprint courant sans arbitrage du lead._

| ID | Tâche | Ajoutée le | Par |
|---|---|---|---|
| `BE-22b` | Réponse de l'artisan à un avis — migration Prisma (colonne ou modèle `ReviewReply`) + `POST` d'écriture. Aucun champ/modèle n'existe aujourd'hui ; BE-18 (`GET /providers/:slug/reviews`) livre sans ce champ faute de donnée à exposer. Nécessaire avant que FM-08/FM-10 (mobile) n'aient besoin d'afficher une réponse artisan | 2026-08-21 | Claude |
| `BE-43` | `searchImpressions`/`avgSearchPosition` de `DailyProviderStat` — aucun module `search` n'existe encore (pas de route, pas de tracking d'impression/position). BE-24 (`GET /providers/me/stats`) livre sans ces deux champs faute de donnée à exposer. Nécessaire quand `BE-16`/`FM-07` (recherche) seront en place | 2026-08-22 | Claude |
| `QA-01f` | Tests d'intégration `POST`/`DELETE /v1/providers/me/portfolio` (BE-20d) sur base réelle — exclus de QA-01e (périmètre onboarding : `POST`/`PATCH /providers/me`, catégories, zones). Nécessite un fixture `MediaAsset` `APPROVED` appartenant à l'appelant, absent de `@repo/testing` aujourd'hui — coût de mise en place disproportionné par rapport aux 4 routes déjà couvertes par QA-01e | 2026-08-23 | Claude |
| `FM-04f` | Composant `Badge` générique (`pending`/`danger`/`neutral`) — seul `VerifiedBadge` est livré par FM-04 (seul cité par l'issue #55). Idem pour la variante « sponsorisée » de `ProviderCard` (déjà différée à S4+ par le `CLAUDE.md` racine — « ads : zéro annonceur au jour 1 »). À construire quand un écran en aura besoin (probablement FM-08 fiche artisan pour « en attente »/« rejeté », ou FW-20 back-office) | 2026-08-25 | Claude |
| `SO-08` | `packages/design-tokens` : `elevation`/`--shadow-*` existe dans `tokens.json` et est exporté en TS/Tailwind (`build-tokens.mjs`) mais jamais en Dart — seuls `colors`/`spacing`/`typography` le sont. `AppCard`/`ProviderCard` (FM-04) n'ont donc qu'une bordure, pas d'ombre portée, contrairement à `design-system.html`. À trancher : ajouter un export Dart (`AppElevation.sm/md/lg` en `List<BoxShadow>`) ou assumer le style plat comme différence intentionnelle Material/Android | 2026-08-25 | Claude |
| `SO-09` | CI `mobile-analyze` : `test/core/i18n/*_test.dart` (`format_test.dart`, `locale_persistence_test.dart`, écrits depuis FM-03) ne sont couverts par aucune étape `dart format`/`flutter test` de `ci.yml` — gap pré-existant, indépendant de FM-04, qui n'élargit que `lib/core/widgets`/`test/core/widgets`. À élargir les 2 lignes de `ci.yml` pour inclure `test/core/i18n` | 2026-08-25 | Claude |
