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
| `BE-01` | Schéma Prisma — sous-ensemble MVP (19 modèles) | 🔴 | DEV-2 | 3 h | SO-02 | §2.2 |
| `BE-02` | Migration SQL — **essentiel** : CHECK notes, index unique partiel, index `PUBLISHED`, trigger anti-auto-avis | 🔴 | DEV-2 | 1 h | BE-01 | §2.3 |
| `BE-03` | Seed : 24 gouvernorats + délégations **du Sahel** + arbre de catégories FR/AR (idempotent) | 🔴 | DEV-2 | 2 h | BE-01 | US-T-02 |
| `BE-04` | Seed démo : 30 artisans du Sahel, dont 20 vérifiés | 🔴 | DEV-2 | 2 h | BE-03 | US-T-02 |
| `BE-05` | Repositories — la **seule** couche qui parle à Prisma, curseur générique | 🔴 | DEV-2 | 2,5 h | BE-01 | P5 |

### Auth & sécurité — DEV-1

| ID | Tâche | Prio | Qui | Est. | Dépend de | US |
|---|---|---|---|---|---|---|
| `BE-06` | `phone-tn.ts` — normalisation `+216XXXXXXXX` (tous formats) | 🔴 | DEV-1 | 1 h | SO-01 | US-C-02 |
| `BE-07` | OTP : hash argon2, TTL 5 min, 3 tentatives | 🔴 | DEV-1 | 2 h | BE-01 | US-C-02 |
| `BE-08` | Adaptateur SMS — **`console` seul en S1**, interface prête pour Twilio | 🔴 | DEV-1 | 0,5 h | SO-03 | US-C-02 |
| `BE-09` | JWT access 15 min + **refresh rotatif**, sessions révocables, détection de rejeu | 🔴 | DEV-1 | 3 h | BE-01 | US-C-02 |
| `BE-10` | Routes auth (`otp/request`, `otp/verify`, `refresh`, `logout`, `me`) | 🔴 | DEV-1 | 2 h | BE-07, BE-09 | US-C-02 |
| `BE-11` | Rate limiting Redis — **OTP + contacts**, par téléphone **et** IP | 🔴 | DEV-1 | 1,5 h | SO-02 | P10 |
| `BE-12` | RBAC centralisé `core/policies` + preHandlers | 🔴 | DEV-1 | 2 h | BE-09 | Annexe B |
| `BE-13` | Erreurs normalisées + codes + `requestId` (**Sentry → S2**) | 🔴 | DEV-1 | 1 h | SO-03 | §4 |

### Métier & API

| ID | Tâche | Prio | Qui | Est. | Dépend de | US |
|---|---|---|---|---|---|---|
| `BE-14` | Catalogue (catégories / gouvernorats / délégations) + cache Redis | 🔴 | DEV-2 | 1,5 h | BE-03 | US-C-01 |
| `BE-15` | ⭐ **Ranking** — géo, bayésien (C=8), confiance, complétude, réactivité, plan, pénalités, rotation ±2 %. **≥12 tests** | 🔴 | **binôme** | 4 h *(8 h-h)* | BE-01 | Annexe A |
| `BE-16` | `GET /providers/search` — filtres + tri + **curseur** | 🔴 | DEV-1 | 3 h | BE-15, BE-05 | US-C-01/03 |
| `BE-17` | `GET /providers/:slug` — **sans téléphone** | 🔴 | DEV-1 | 2 h | BE-05 | US-C-04 |
| `BE-18` | `GET /providers/:slug/reviews` paginé | 🔴 | DEV-1 | 1 h | BE-05 | US-C-07 |
| `BE-19` | Onboarding artisan — **réduit** : profil + catégories + zones + `completionScore` | 🟠 | DEV-2 | 2,5 h | BE-12 | US-P-02→04 |
| `BE-21` | ⭐ `POST /contact-events` — dédup 30 min, empreinte de session, révélation du numéro, agrégat transactionnel | 🔴 | **binôme** | 3 h *(6 h-h)* | BE-11, BE-12 | US-C-05/06 |
| `BE-22` | `POST /providers/:id/reviews` — rattaché à un `ContactEvent`, agrégats en transaction | 🔴 | DEV-1 | 2,5 h | BE-21 | US-C-07 |
| `BE-23` | `POST /profile-views` + `DailyProviderStat` (dédup 24 h) | 🔴 | DEV-2 | 1,5 h | BE-21 | P9 |
| `BE-26` | ⭐ Contrat : `api:contract` + `mobile:client` (dart-dio) + `web:client` prêt pour S2 | 🔴 | DEV-1 | 2,5 h | toutes | ADR-001 |
| `BE-27` | 🚦 **GATE 1** — recette backend en `curl` (8 appels) | 🔴 | binôme | 0,75 h *(1,5 h-h)* | BE-26 | — |
| `BE-20` | Médias : presign bucket public + WebP (sharp) | 🟠 | DEV-2 | 2,5 h | BE-12 | US-P-06 |
| `BE-24` | `GET /providers/me/stats` — vues, contacts, ratio, série 30 j | 🟠 | DEV-2 | 2 h | BE-23 | US-P-12 |
| `BE-25` | Favoris (`PUT`/`DELETE`/`GET /favorites`) | 🟠 | DEV-1 | 1 h | BE-12 | US-C-08 |

## LOT MOBILE — Flutter · J4 pm → J7 · **les 2 devs** · ~43 h (P0) + 10 h (P1)

| ID | Tâche | Prio | Qui | Est. | Dépend de | US |
|---|---|---|---|---|---|---|
| `FM-01` | Bootstrap Flutter 3.24 + go_router + Riverpod + thème **généré** + polices | 🔴 | DEV-2 | 3 h | SO-04 | ADR-001 |
| `FM-02` | ⭐ Dio + Retrofit **générés**, intercepteurs (JWT, refresh, retry, offline), secure storage | 🔴 | **binôme** | 4 h *(8 h-h)* | BE-26 | ADR-001 |
| `FM-03` | i18n `slang` FR/AR + `Directionality` global + miroir des icônes | 🔴 | DEV-1 | 2,5 h | SO-05 | P7 |
| `FM-04` | Widgets DS (AppButton, ProviderCard, RatingStars, VerifiedBadge, Skeleton, Empty, Error, OfflineBanner) | 🔴 | DEV-1 | 4 h | FM-01 | — |
| `FM-05` | Auth : rôle → téléphone → OTP → session persistée | 🔴 | DEV-1 | 3,5 h | BE-10, FM-02 | US-C-02 |
| `FM-06` | Accueil client : recherche + grille de catégories (depuis l'API) | 🔴 | DEV-2 | 3 h | BE-14 | US-C-01 |
| `FM-07` | ⭐ Résultats : `ListView.builder` + curseur + filtres + **cache disque** | 🔴 | DEV-2 | 4,5 h | BE-16 | US-C-01/03, P5 |
| `FM-08` | Fiche artisan : galerie, tarifs, zones, avis, badge | 🔴 | DEV-1 | 4 h | BE-17 | US-C-04 |
| `FM-09` | ⭐⭐ Contact tel/WhatsApp + `ContactEvent` **avant** ouverture + **file offline** | 🔴 | DEV-2 | 3,5 h | BE-21 | US-C-05/06, P9 |
| `FM-10` | Dépôt d'avis après contact | 🔴 | DEV-1 | 2,5 h | BE-22 | US-C-07 |
| `FM-14` | Build Android release signé + **APK pour les beta-testeurs du Sahel** | 🔴 | DEV-2 | 2 h | FM-09 | — |
| `FM-11` | Espace Pro : assistant d'onboarding + `completionScore` en direct | 🟠 | — | 5 h | BE-19 | US-P-02→04 |
| `FM-12` | Espace Pro : tableau de bord statistiques | 🟠 | — | 3 h | BE-24 | US-P-12 |
| `FM-13` | Favoris + réglages (langue, déconnexion) | 🟠 | — | 2 h | BE-25 | US-C-08 |

## QUALITÉ

| ID | Tâche | Prio | Qui | Est. | Dépend de |
|---|---|---|---|---|---|
| `QA-01` | Tests d'intégration API sur base jetable (routes qui écrivent) | 🔴 | DEV-1 | 2 h | BE-22 |
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
| — | — | — | — |
