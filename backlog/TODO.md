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

## LOT REFONTE — Design mobile complet · milestone M7 · ~93 h

> Sprint S1 a livré le MVP mobile fonctionnel, pas le design complet des maquettes du
> lead. Audit exhaustif + découpage détaillé : `Code/docs/PLAN-REFONTE-DESIGN-MOBILE.md`.
> Issues GitHub `FM-15`→`FM-19`, `FM-22`→`FM-43`, `BE-44`→`BE-47` (milestone M7, hors
> `BE-44`→`BE-47` qui restent en M1). Label GitHub `refonte-design-mobile` pour les
> retrouver toutes.

| ID | Tâche | Est. | Dépend de |
|---|---|---|---|
| `FM-15` | Générateur de tokens : élévation, motion, tracking, icônes, nouveaux rôles | 4 h | — |
| `FM-17` | Persistance du thème et accessibilité (contraste AA, TextScaler) | 2 h | FM-15 |
| `FM-18` | Garde-fou CI anti-valeurs-en-dur et vitrine `/_ds-preview` enrichie | 3 h | FM-15, FM-16 |
| `FM-19` | Clés i18n de navigation FR/AR | 1 h | — |
| `FM-22` | Widget partagé `AppBottomNav` | 2 h | FM-15, FM-19 |
| `FM-23` | Shell client : navigation à 4 onglets + suppression du hub de dev | 5 h | FM-22 |
| `FM-24` | Shell pro : navigation à 4 onglets, dashboard comme racine | 4 h | FM-22 |
| `FM-25` | Corriger la déconnexion + bascule Client ↔ Pro | 2 h | FM-23, FM-24 |
| `FM-26` | Câbler les écrans déjà construits mais orphelins | 2 h | FM-23 |
| `FM-27` | Widgets partagés de recherche : chip de filtre, carte artisan, barre | 3 h | FM-15, FM-16 |
| `FM-28` | Écran de résultats de recherche : pagination, filtres, cache disque | 5 h | FM-27, FM-23 |
| `FM-29` | Refonte fiche artisan : couverture plein-écran et avatar (RTL) | 3 h | FM-15 |
| `FM-30` | Refonte contact et avis : bouton contour, en-tête d'identité | 2 h | FM-15, FM-29 |
| `FM-31` | Onglet Historique client ⚠️ bloqué par `BE-45` | 3 h | FM-23 |
| `FM-32` | Onglet Profil client | 2 h | FM-23, FM-25 |
| `FM-33` | Refonte authentification : marque, mention légale, bouton Confirmer | 3 h | FM-15, FM-16 |
| `FM-34` | Refonte onboarding pro : étapes, catégories, plafonds | 4 h | FM-15, FM-16, FM-24 |
| `FM-35` | Étape photos/portfolio de l'onboarding | 3 h | FM-34 |
| `FM-36` | Reprise de l'onboarding après fermeture ⚠️ bloqué par `BE-44` | 2 h | FM-34 |
| `FM-37` | Refonte tableau de bord pro : salutation, KPI, histogramme | 4 h | FM-15, FM-16, FM-24 |
| `FM-38` | Écran Profil pro : édition et disponibilité commutable ⚠️ bloqué par `BE-44` | 3 h | FM-24 |
| `FM-39` | Écran Avis reçus (pro) ⚠️ bloqué par `BE-44` | 2 h | FM-24 |
| `FM-40` | Écran Boosts/crédits — coquille visuelle ⚠️ bloqué par EP-BILLING/ADR-004 | 3 h | FM-15, FM-16, FM-24 |
| `FM-41` | Composants partagés transverses : Badge, carte sélectionnable, bottom sheet | 3 h | FM-15, FM-16 |
| `FM-42` | Adoption systématique des états + bandeau hors ligne | 3 h | FM-23, FM-24, FM-41 |
| `FM-43` | Passe accessibilité : Semantics, TextScaler, contraste | 3 h | FM-22, FM-27, FM-29, FM-33, FM-34, FM-37 |
| `BE-44` | `GET /v1/providers/me` — lire son propre profil (débloque 4 issues mobiles) | 3 h | — |
| `BE-45` | `GET /v1/contact-events` — historique de lecture | 3 h | — |
| `BE-46` | Ventilation des contacts par canal dans les stats | 2 h | — |
| `BE-47` | Écriture des `offerings` (tarifs) sous `/providers/me/*` | 3 h | — |

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
| `BE-10e` | `OTP_INVALID` ne renvoyait pas le nombre de tentatives restantes — critère d'acceptation FM-05 (« un code invalide affiche le nombre de tentatives restantes ») impossible à satisfaire sans dupliquer `OTP_MAX_ATTEMPTS` en Dart (interdit par l'invariant P3). Ajout de `details.attemptsRemaining` dans `apps/api/src/routes/auth.ts`, calculé côté serveur qui connaît déjà `otp.attempts`/`otp.maxAttempts`. Validé avec Oussama avant démarrage (voir plan FM-05) | 2026-08-28 | Claude |
| `FM-17c` | 4 paires de couleurs sous le seuil AA, détectées par le script de contraste `test/core/theme/contrast_test.dart` (FM-17b) : `textMuted`/`background` clair (3,83:1), `textMuted`/`surface` clair (3,94:1) et sombre (4,44:1), et surtout `onAccent`/`whatsapp` clair (4,14:1) — la vraie paire texte-sur-fond du **bouton WhatsApp réel** (`app_button.dart`, variante `whatsapp`, `foreground: colors.onAccent`). Corriger touche `tokens.json` (FM-15/FM-18), hors périmètre FM-17 (pas de règle métier, mais retouche du design). Piège identifié au passage : le token `onWhatsapp` (blanc, prévu pour cette paire) n'est utilisé nulle part dans le code — le brancher sans corriger `tokens.json` casserait le mode sombre (1,98:1 au lieu des 9,81:1 actuels avec `onAccent`). Les 6 paires sont épinglées dans `contrast_test.dart` (dette documentée, pas de régression silencieuse) | 2026-09-02 | Claude |
