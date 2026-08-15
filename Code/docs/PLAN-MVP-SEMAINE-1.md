# Plan MVP — Semaine 1 (Sprint S1) · **Mobile d'abord**

> **Projet** : Sanaya — mise en relation particuliers ⇄ artisans (Tunisie)
> **Période** : lundi 17/08/2026 → dimanche 23/08/2026 (7 jours)
> **Équipe** : DEV-1, DEV-2 + Claude en pair-programmer sur chaque poste
> **Décisions applicables** : ADR-001 (Flutter + REST/OpenAPI), ADR-002 (badge vérifié gratuit), ADR-003 (périmètre S1 mobile-first)
> **Version 2.0 — re-cadrée le 15/08 après recomptage de la charge.** La v1 planifiait web + mobile en parallèle : 159 h-homme pour 112 h disponibles, soit **42 % de trop**. Le web est reporté au sprint S2.

---

## 1. Objectif du sprint — une seule phrase

> **À la fin de la semaine, un habitant de Sousse doit pouvoir installer l'APK, chercher
> « plombier · Sousse », voir une liste classée d'artisans réels, ouvrir une fiche, et appeler
> l'artisan — et cet appel doit être compté.**

Tout ce qui ne sert pas directement cette phrase est hors périmètre. C'est le seul critère
d'arbitrage de la semaine.

---

## 2. Capacité et charge — les vrais chiffres

| | Heures-homme |
|---|---|
| **Capacité** : 2 devs × 7 j × 8 h | **112 h** |
| Charge 🔴 P0 après re-cadrage | **~109 h** |
| **Marge** | **~3 %, c'est-à-dire aucune** |

Il faut le dire clairement : **il n'y a pas de marge**, et 8 h effectives par jour pendant 7 jours
consécutifs est déjà une hypothèse optimiste. Le seul amortisseur réel est la liste 🟠 P1 (~15 h) :
**au premier jalon manqué, on y coupe — pas au troisième.** Dans l'ordre : `BE-19` + `FM-11`
(espace Pro), puis `BE-24` + `FM-12` (stats), puis `BE-20` (médias), puis `BE-25` + `FM-13` (favoris).

> ⚠️ Les tâches en **binôme** comptent **double** en heures-homme. C'est la raison n°1 pour laquelle
> la v1 de ce plan était fausse.

### Pourquoi le web est reporté

La v1 planifiait `apps/web` (35,5 h) et `apps/mobile` (36,5 h) **en parallèle**, un développeur sur
chaque. C'était la cause principale du dépassement : deux surfaces à moitié finies valent moins
qu'une seule qui marche.

Le mobile passe devant parce que **c'est le produit** : c'est ce qu'on installe sur le téléphone d'un
artisan lors de la tournée des quincailleries, et c'est ce que les beta-testeurs du Sahel peuvent
essayer. Le web SEO reste critique (principe P6) mais son délai propre est l'indexation Google — qui
prend des semaines de toute façon. Le décaler d'une semaine coûte une semaine d'indexation ; livrer
deux surfaces bancales coûte le sprint.

**Conséquence pratique : à partir de J4, les deux développeurs sont sur Flutter.** DEV-1 découvre
Dart en même temps que DEV-2 — c'est aussi la meilleure façon de tuer le risque de bus factor
identifié dans l'ADR-001 §4.2.

---

## 3. Périmètre

### ✅ DANS le périmètre (🔴 P0 — non négociable)

| Domaine | Ce qu'on livre | US du cadrage |
|---|---|---|
| Socle | Monorepo, CI, PostgreSQL + Redis en Docker, contrat OpenAPI | `US-T-01` |
| Référentiel | 24 gouvernorats, délégations du **Sahel**, arbre de catégories FR/AR, seed de démo | `US-T-02` |
| Auth | Inscription/connexion **OTP SMS**, JWT access + refresh rotatif, rôles | `US-C-02`, `US-P-01` |
| Recherche | Catégorie × gouvernorat/délégation, filtres, tri par ranking, pagination curseur | `US-C-01`, `US-C-03` |
| Ranking | Score explicable, note bayésienne, rotation équitable, poids en base | Annexe A |
| Fiche artisan | Profil public, galerie, prestations tarifées, avis | `US-C-04` |
| **Contact** | Clic Appeler / WhatsApp + **`ContactEvent` tracé** | `US-C-05`, `US-C-06` |
| Avis | Dépôt rattaché à un contact réel, agrégats recalculés en transaction | `US-C-07` |
| **App Android** | APK signé, installable, distribuable aux beta-testeurs du Sahel | — |
| Bilingue | FR/AR + RTL sur tous les écrans livrés | P7 |

### 🟠 SI LE RYTHME TIENT (P1 — à couper en premier, dans cet ordre)

**À couper dans cet ordre**, ~18 h au total :
1. `BE-19` + `FM-11` — espace Pro / onboarding artisan (7,5 h)
2. `BE-24` + `FM-12` — statistiques Pro (5 h)
3. `BE-20` — upload de médias (2,5 h)
4. `BE-25` + `FM-13` — favoris et réglages (3 h)

Puis : avis avec sous-notes, réponse de l'artisan à un avis, partage de fiche.

### ❌ HORS PÉRIMÈTRE — reporté

| Reporté | Vers | Pourquoi c'est acceptable |
|---|---|---|
| **`apps/web` en entier** (vitrine SEO, pages `/[gouvernorat]/[service]`, JSON-LD, sitemap) | **S2** | Voir §2. Le backend expose déjà tout le nécessaire : le web ne sera que de la consommation d'API. |
| **Upload et vérification de CIN (KYC)** | S2 | Contournement S1 : `isVerified` posé **à la main en base** sur les 20 premiers artisans du Sahel — c'est exactement le « Label de Confiance » du plan de lancement terrain. |
| **Paiements, abonnements, crédits, boosts** | S2-S3 | Rien à monétiser sans audience. `Plan` seedé avec `FREE` uniquement. Question 2 du cadrage non tranchée. |
| **Régie publicitaire B2B** | S4+ | Zéro annonceur au jour 1. |
| **Back-office complet** | S2 | Contournement S1 : **Prisma Studio** en accès restreint. |
| **Notifications push** | S2 | Nécessite Firebase et une base d'installation. Sans objet cette semaine. |
| **`ServiceRequest`** | S3 | Entités modélisées, points d'extension préservés, aucun écran. |
| **Worker BullMQ** | S2 | Agrégats recalculés en transaction. Nécessaire au-delà de ~500 artisans. |
| **Recherche vocale en derja + RAG** | **S3** | La fonctionnalité différenciante du document de stratégie. Elle mérite son propre sprint, pas un reste de semaine. |
| **iOS** | S3 | Android d'abord — 90 %+ du marché cible. Le code Flutter reste portable. |

> **Si vous ne travaillez pas le week-end** (J6/J7), la capacité tombe à ~80 h : coupez alors tout le
> bloc 🟠 P1 et acceptez que la recette GATE 2 glisse au lundi. **Décidez-le lundi matin, pas
> vendredi soir.**

---

## 4. Découpage en lots

```
          J1        J2        J3       J4 am │ J4 pm    J5        J6        J7
       ┌──────────────────────────────────────┬──────────────────────────────────┐
DEV-1  │      LOT 0 + LOT BACKEND             │      LOT MOBILE (Flutter)        │
DEV-2  │      (les 2 devs ensemble)           │      (les 2 devs ensemble)       │
       └──────────────────────────────────────┴──────────────────────────────────┘
        ▲                                    ▲                                  ▲
    Kick-off                            🚦 GATE 1                          🚦 GATE 2
                                 API figée + contrat publié              Recette sur
                                                                       Android réel
```

**Pourquoi le backend d'abord ?** C'est la partie **réversible**. Tant qu'aucune ligne de Dart de
présentation n'existe, la bascule Flutter (ADR-001 §4.3) s'annule sans coût. Et un contrat figé à
GATE 1 permet de générer le client Dart une fois pour toutes.

**🚦 GATE 1 (J4 matin) — critère de passage, non négociable :**
`contracts/openapi.json` publié, seed de 30 artisans du Sahel, et les **8 routes du parcours cœur
répondent en `curl`**. Si ce n'est pas le cas, on termine le backend et on coupe le bloc 🟠 P1 en
entier — on ne démarre pas Flutter sur une API instable.

---

## 5. LOT 0 — Socle (J1, les 2 devs) · 11,5 h

| ID | Tâche | Qui | Est. | Critères d'acceptation |
|---|---|---|---|---|
| `SO-01` | Monorepo pnpm + Turborepo, `packages/tsconfig`, `packages/eslint-config`, Prettier | DEV-1 | 2 h | `pnpm install`, `pnpm lint`, `pnpm typecheck` passent sur un repo vide |
| `SO-02` | `docker-compose.dev.yml` : PostgreSQL 16 (`unaccent`, `pg_trgm`, `postgis`) + Redis 7 | DEV-2 | 1,5 h | `pnpm db:up` démarre les 2 services ; les 3 extensions créées par `init.sql` |
| `SO-03` | Bootstrap `apps/api` : Fastify 5, `fastify-type-provider-zod`, `@fastify/swagger`, pino, `requestId` | DEV-1 | 2,5 h | `GET /v1/health` → `200 {"status":"ok","db":"up","redis":"up"}` ; `/docs` affiche le Swagger |
| `SO-04` | Générateur de design tokens : `tokens.json` → TS (preset Tailwind) **et** Dart | DEV-2 | 2 h | `pnpm tokens:build` régénère les 2 cibles ; la CI échoue si les fichiers générés sont périmés |
| `SO-05` | Squelette i18n `fr.json`/`ar.json` + `i18n:check` (parité des clés) | DEV-2 | 1 h | Échoue si une clé existe en FR et pas en AR |
| `SO-06` | CI GitHub Actions : lint + typecheck + test + `api:contract --check` + services PG/Redis | DEV-1 | 2 h | Verte sur une PR blanche, < 5 min grâce au cache Turborepo |
| `SO-07` | Protection de `main`, modèle de PR, `.env.example`, `CODEOWNERS` | DEV-1 | 0,5 h | Push direct sur `main` refusé |

**Fin de J1 attendue** : `GET /v1/health` répond, CI verte, tokens et i18n générables.
**Aucune ligne de métier écrite — et c'est normal.**

---

## 6. LOT BACKEND (J2 → J4 matin, les 2 devs) · ~53 h en P0

### 6.1 Bloc DONNÉES — `DEV-2` pilote

| ID | Tâche | Est. | Critères d'acceptation | Dépend de |
|---|---|---|---|---|
| `BE-01` | Schéma Prisma — **sous-ensemble MVP** : `User`, `Session`, `OtpCode`, `Governorate`, `Delegation`, `Category`, `ProviderProfile`, `ProviderCategory`, `ServiceOffering`, `CoverageArea`, `MediaAsset`, `PortfolioItem`, `ContactEvent`, `ProfileView`, `Review`, `Favorite`, `Plan`, `AppSetting`, `AuditLog` | 3 h | `prisma migrate dev` passe ; enums du cadrage §2.2 respectés à l'identique | `SO-02` |
| `BE-02` | Migration SQL manuelle — **essentiel seulement** : `CHECK` notes 1-5, index unique partiel catégorie principale, index partiel `PUBLISHED`, trigger `prevent_self_review` (GIN trigram reporté si le temps manque) | 1 h | Un avis à 6 étoiles est **rejeté par la base** ; un artisan ne peut pas s'auto-évaluer | `BE-01` |
| `BE-03` | Seed référentiel — **Sahel seulement** : 24 gouvernorats + délégations de Sousse/Monastir/Mahdia + arbre de catégories FR **et** AR | 2 h | **Idempotent** (2 exécutions = même état) ; chaque catégorie a slug, `nameFr`, `nameAr`, icône | `BE-01` |
| `BE-04` | Seed de démonstration : 30 artisans plausibles du Sahel, dont 20 `isVerified`, avec avis, photos (URL), tarifs | 2 h | « plombier · Sousse » retourne ≥ 5 résultats crédibles aux notes variées | `BE-03` |
| `BE-05` | Repositories `packages/db` — la **seule** couche qui parle à Prisma. `select` explicites, curseur générique | 2,5 h | Aucun `prisma.` hors de `packages/db` (règle ESLint active) | `BE-01` |

### 6.2 Bloc AUTH & SÉCURITÉ — `DEV-1` pilote

| ID | Tâche | Est. | Critères d'acceptation | Dépend de |
|---|---|---|---|---|
| `BE-06` | `phone-tn.ts` : normalisation `+216XXXXXXXX` depuis tous les formats (`22 123 456`, `0021622…`, `+216 22…`) | 1 h | 12 cas de test, dont 4 formats invalides rejetés | — |
| `BE-07` | OTP : 6 chiffres, **hash argon2**, TTL 5 min, 3 tentatives, invalidation à l'usage | 2 h | Jamais stocké ni loggé en clair ; 4ᵉ tentative → `OTP_TOO_MANY_ATTEMPTS` | `BE-01` |
| `BE-08` | Adaptateur SMS — **`console` seul en S1**, interface `SmsProvider` prête pour Twilio | 0,5 h | En dev l'OTP s'affiche dans le log ; changer de fournisseur ne touchera aucun code métier | — |
| `BE-09` | JWT : access 15 min + refresh **rotatif** 30 j, `Session` révocable, détection de rejeu | 3 h | Rejouer un ancien refresh révoque **toute** la famille de sessions | `BE-01` |
| `BE-10` | Routes auth : `otp/request`, `otp/verify`, `refresh`, `logout`, `GET /auth/me` | 2 h | Parcours complet en `curl` ; `otp/request` ne révèle **jamais** si le numéro existe (anti-énumération) | `BE-07`, `BE-09` |
| `BE-11` | Rate limiting Redis — **OTP (5/h) et contacts (30/j)** en S1, par téléphone **et** IP | 1,5 h | 6ᵉ demande d'OTP en 1 h → `429` + `Retry-After` | `SO-02` |
| `BE-12` | RBAC centralisé `packages/core/policies` + preHandlers `requireAuth` / `requireRole` | 2 h | Sans en-tête → `401` ; mauvais rôle → `403`. Aucun contrôle uniquement côté client | `BE-09` |
| `BE-13` | Erreurs normalisées + `error-codes.ts` + handler global + `requestId` (**Sentry reporté S2**) | 1 h | Toute erreur → `{ error: {code, message, details}, requestId }` ; aucune stack en production | `SO-03` |

### 6.3 Bloc MÉTIER & API

| ID | Tâche | Qui | Est. | Critères d'acceptation | Dépend de |
|---|---|---|---|---|---|
| `BE-14` | Catalogue : `GET /categories` (arbre), `/governorates`, `/governorates/:id/delegations` + cache Redis 1 h | DEV-2 | 1,5 h | < 50 ms en cache chaud ; libellés FR **et** AR | `BE-03` |
| `BE-15` | ⭐ **Ranking** (`packages/core/search/ranking.ts`) — **le cœur du produit.** Géo (1.0 / 0.6 / 0.3), note bayésienne `(C·m+Σ)/(C+n)` C=8, confiance, complétude, réactivité, facteur de plan, pénalités. Poids dans `AppSetting`. Rotation équitable ±2 % | **binôme** (8 h-homme) | 4 h | **≥ 12 tests sans base ni réseau**, dont le garde-fou ADR-002 | `BE-01` |
| `BE-16` | `GET /v1/providers/search` : filtres catégorie × gouvernorat × délégation × vérifié × note × dispo, tri ranking, **curseur** | DEV-1 | 3 h | `{ items, nextCursor }` ; < 200 ms sur la seed ; `score` et `matchReason` en mode debug | `BE-15`, `BE-05` |
| `BE-17` | `GET /v1/providers/:slug` — fiche publique. **Le téléphone n'est PAS dans la réponse** (P8) | DEV-1 | 2 h | Un `curl` sur la fiche ne contient aucun numéro | `BE-05` |
| `BE-18` | `GET /v1/providers/:slug/reviews` — paginé par curseur | DEV-1 | 1 h | Pagination stable si un avis est ajouté entre deux pages | `BE-05` |
| `BE-19` 🟠 | Onboarding artisan — **réduit** : `POST`/`PATCH /providers/me`, `PUT /me/categories`, `/coverage-areas` + `completionScore` (tarifs et galerie → S2). **P1 : l'écran mobile qui le consomme (`FM-11`) est lui aussi P1 — livrer une API que personne n'appelle serait du gaspillage** | DEV-2 | 2,5 h | `completionScore` recalculé à chaque écriture ; publication refusée sous 60 % avec la liste des manques | `BE-12` |
| `BE-21` | ⭐ `POST /v1/contact-events` — **l'unité de valeur du produit** (P9). Canal `PHONE`/`WHATSAPP`, empreinte de session, dédup 30 min, rate-limit, agrégat **dans la transaction**, renvoie le numéro **révélé** | **binôme** (6 h-homme) | 3 h | 2 clics en 5 min = **1 seul** `ContactEvent` ; l'événement est visible dans les stats immédiatement | `BE-11`, `BE-12` |
| `BE-22` | `POST /v1/providers/:id/reviews` — **rattaché à un `ContactEvent` réel** (1-1 unique), `ratingAvg`/`ratingCount` recalculés dans la **même transaction** | DEV-1 | 2,5 h | Avis sans contact → `403 REVIEW_REQUIRES_CONTACT` ; auto-évaluation rejetée par le trigger SQL | `BE-21` |
| `BE-23` | `POST /v1/profile-views` + agrégat `DailyProviderStat` (upsert quotidien, dédup 24 h) | DEV-2 | 1,5 h | Une vue dédupliquée par empreinte de session sur 24 h | `BE-21` |
| `BE-26` | ⭐ Contrat : `pnpm api:contract` → `contracts/openapi.json` ; `pnpm mobile:client` (openapi-generator dart-dio) ; `pnpm web:client` prêt pour S2 | DEV-1 | 2,5 h | Contrat commité ; client Dart généré sans erreur ; `--check` bloque la CI si périmé | toutes |
| `BE-27` | 🚦 **GATE 1** — recette backend en `curl` | binôme | 0,75 h | voir §6.4 | `BE-26` |

**🟠 Déjà hors du chemin critique** : `BE-19` (onboarding artisan, 2,5 h) · `BE-20` (médias/presign, 2,5 h) · `BE-24` (stats Pro, 2 h) · `BE-25` (favoris, 1 h). À faire seulement si J3 est en avance.

### 6.4 🚦 GATE 1 — recette backend (J4 matin, ensemble, 45 min)

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

- [ ] Les 8 appels passent
- [ ] `contracts/openapi.json` commité, `--check` vert
- [ ] Le client Dart se génère sans erreur
- [ ] Aucun téléphone, OTP ou token dans les logs
- [ ] `pnpm test` : tests de ranking verts, dont le garde-fou ADR-002

> ❗ **Un seul point rouge ⇒ on ne démarre pas Flutter.** On termine le backend en J4 après-midi et on
> coupe tout le bloc 🟠 P1. Démarrer sur une API instable coûte deux fois.

---

## 7. LOT MOBILE — Flutter (J4 après-midi → J7, **les 2 devs**) · ~43 h en P0

Objectif : **le produit**. C'est là que se joue la fluidité sur Android d'entrée de gamme — l'argument
même de la bascule Flutter (ADR-001).

**Répartition suggérée** : DEV-2 pilote (socle, réseau, recherche), DEV-1 suit (design system, écrans,
auth). Faites `FM-02` **ensemble** : c'est la couche dont tout le reste dépend, et c'est le meilleur
moment pour que DEV-1 prenne Dart en main.

| ID | Tâche | Qui | Est. | Critères d'acceptation | Prio |
|---|---|---|---|---|---|
| `FM-01` | Bootstrap : Flutter 3.24, go_router, Riverpod 2, thème depuis `app_colors.dart`/`app_spacing.dart` **générés**, Manrope + Noto Kufi Arabic | DEV-2 | 3 h | Écran d'accueil aux couleurs Sanaya ; `flutter analyze` **zéro warning** | 🔴 |
| `FM-02` | ⭐ Réseau : Dio + Retrofit **générés depuis `openapi.json`**, intercepteurs (JWT, refresh rotatif, retry ×2 sur `GET`, détection hors ligne), `flutter_secure_storage` | **binôme** | 4 h | **Zéro appel HTTP écrit à la main** ; refresh transparent ; refresh token jamais en `SharedPreferences` | 🔴 |
| `FM-03` | i18n `slang` FR/AR généré depuis `packages/i18n`, `Directionality` global, miroir des icônes directionnelles | DEV-1 | 2,5 h | Changer la langue fait passer toute l'app en RTL sans redémarrage | 🔴 |
| `FM-04` | Widgets du design system : `AppButton`, `AppTextField`, `ProviderCard`, `RatingStars`, `VerifiedBadge`, `AppSkeleton`, `EmptyState`, `ErrorState`, `OfflineBanner` | DEV-1 | 4 h | Tous `const` où possible ; aucune couleur ni taille en dur ; rendu vérifié en FR **et** AR | 🔴 |
| `FM-05` | Auth : sélection de rôle → téléphone → OTP 6 cases → session persistée | DEV-1 | 3,5 h | Réouvrir l'app conserve la session ; erreurs traduites ; renvoi avec compte à rebours 60 s | 🔴 |
| `FM-06` | Accueil client : barre de recherche, catégories en grille (depuis l'API), détection du gouvernorat | DEV-2 | 3 h | Les catégories viennent de l'API, pas d'une liste en dur | 🔴 |
| `FM-07` | ⭐ Résultats : `ListView.builder` paginé par curseur, panneau de filtres, **cache disque** | DEV-2 | 4,5 h | 60 fps sur émulateur bridé ; résultats consultables en mode avion | 🔴 |
| `FM-08` | Fiche artisan : galerie (`cached_network_image`), prestations, zones, avis, badge vérifié | DEV-1 | 4 h | Aucun écran blanc sur erreur réseau : `ErrorState` + « Réessayer » | 🔴 |
| `FM-09` | ⭐⭐ **Contact** : Appeler / WhatsApp → `POST /contact-events` **avant** l'ouverture → `launchUrl(tel:)` / `wa.me` pré-rempli FR ou AR. **File locale de renvoi si hors ligne** | DEV-2 | 3,5 h | Le lien s'ouvre même si l'API échoue, et l'événement part au retour du réseau. **La fonctionnalité la plus critique de l'app** | 🔴 |
| `FM-10` | Dépôt d'avis (note + commentaire), accessible uniquement après un contact | DEV-1 | 2,5 h | Sans contact, le formulaire est masqué et l'API renvoie `403` | 🔴 |
| `FM-14` | Build Android release signé, **APK distribuable aux beta-testeurs du Sahel** | DEV-2 | 2 h | S'installe sur un Android réel ; le parcours cœur passe de bout en bout | 🔴 |
| `FM-11` | Espace Pro : assistant d'onboarding + `completionScore` en direct | — | 5 h | Barre de complétude en direct ; publication bloquée sous 60 % | 🟠 |
| `FM-12` | Espace Pro : tableau de bord statistiques | — | 3 h | Chiffres alignés sur `GET /providers/me/stats` | 🟠 |
| `FM-13` | Favoris + réglages (langue, déconnexion) | — | 2 h | — | 🟠 |

---

## 8. Planning jour par jour

| Jour | Date | DEV-1 | DEV-2 | Jalon du soir |
|---|---|---|---|---|
| **J1** | lun 17/08 | `SO-01` `SO-03` `SO-06` `SO-07` | `SO-02` `SO-04` `SO-05` | ✅ `GET /v1/health` répond · CI verte |
| **J2** | mar 18/08 | `BE-06` `BE-07` `BE-08` `BE-09` `BE-10` | `BE-01` `BE-02` `BE-03` `BE-04` | ✅ Parcours OTP en `curl` · 30 artisans en base |
| **J3** | mer 19/08 | `BE-11` `BE-12` `BE-13` `BE-16` `BE-17` | `BE-05` `BE-14` `BE-23` (+`BE-19` si avance) | ⭐ `BE-15` **en binôme** l'après-midi · **point de mi-sprint 14h** |
| **J4 am** | jeu 20/08 | `BE-18` `BE-22` `BE-26` | ⭐ `BE-21` **en binôme** | 🚦 **GATE 1** (11h) |
| **J4 pm** | jeu 20/08 | `FM-03` | `FM-01` | ⭐ `FM-02` **en binôme** · client Dart branché sur l'API réelle |
| **J5** | ven 21/08 | `FM-04` `FM-05` | `FM-06` `FM-07` | ✅ Auth + recherche fonctionnelles · **revue de sprint 16h** |
| **J6** | sam 22/08 | `FM-08` | `FM-09` | ✅ **Parcours cœur complet** : recherche → fiche → appel tracé |
| **J7** | dim 23/08 | `FM-10` `QA-01` | `FM-14` + `QA-03` | 🚦 **GATE 2** — recette sur Android réel |

**Rituel quotidien** : point **écrit** de 10 min à 9h00 dans `#a_vue_générale` — hier / aujourd'hui /
bloqué par. Mise à jour de `backlog/DOING.md` **en fin de journée, systématiquement**.

---

## 9. Chemin critique

```
SO-02 ──► BE-01 ──► BE-03 ──► BE-04
                 │
                 └──► BE-15 (ranking) ──► BE-16 (search) ──┐
                                                            ├──► BE-26 (contrat) ──► FM-02 ──► tout Flutter
BE-09 (JWT) ──► BE-12 (RBAC) ──► BE-21 (contact) ──────────┘
```

**Les 5 tâches qui font glisser tout le sprint si elles dérapent** :
`BE-01` (schéma) · `BE-15` (ranking) · `BE-21` (contact) · `BE-26` (contrat) · `FM-02` (couche réseau).
Ce sont exactement les quatre premières qui se font **en binôme**, et `FM-02` aussi. Ce n'est pas un
hasard : **on met deux personnes là où l'erreur coûte le plus cher, pas là où le travail est le plus
volumineux.**

---

## 10. Risques & plans de repli

| Risque | Prob. | Impact | Mitigation / repli |
|---|---|---|---|
| **Aucun des deux devs ne connaît Flutter** | Élevée | Élevé | J4 après-midi est une demi-journée de socle sans métier. `FM-02` se fait à deux. Repli : livrer une app **client seulement** (couper `FM-11`/`FM-12`/`FM-13`), le parcours cœur reste complet. |
| Le backend déborde au-delà de J4 matin | Moyenne | Élevé | `BE-19` est déjà hors du chemin critique. Couper ensuite `BE-23` (tracking des vues) : on perd de la donnée d'usage, mais pas le parcours. Ne jamais couper `BE-21`. |
| Le ranking devient un puits de temps | Moyenne | Moyen | **Timeboxé à 4 h.** Au-delà : version simplifiée (géo + bayésien + vérifié), `BE-15b` créé dans le backlog. Les poids étant en base, l'affiner plus tard ne coûte rien. |
| L'OTP SMS ne part pas (fournisseur non ouvert) | Élevée | Faible en S1 | L'adaptateur `console` suffit pour tout le développement. Ouvrir le compte est une tâche **administrative à lancer J1**, pas technique. |
| Le RTL casse la mise en page en fin de semaine | Élevée | Moyen | Vérifier en AR **à chaque écran, le jour même** — pas en J7. `EdgeInsetsDirectional` obligatoire. |
| Le contrat d'API bouge après GATE 1 | Moyenne | Élevé | Message dans `#développement-du-backend` **avant** le merge, et régénération immédiate du client Dart. Aucune exception. |
| Le week-end n'est pas travaillé | — | Élevé | Couper tout le bloc 🟠 P1 et laisser GATE 2 glisser au lundi. **Décision lundi matin.** |
| **Il n'y a pas de marge (3 %)** | Certaine | Élevé | Le seul amortisseur est la liste 🟠 P1 (~15 h). Au **premier** jalon manqué, on y coupe — pas au troisième. Et 8 h effectives × 7 jours consécutifs est déjà optimiste. |

---

## 11. 🚦 GATE 2 — Recette de fin de sprint (J7, ensemble, 1 h)

Sur un **appareil Android réel**, en **3G bridé**, en **français puis en arabe** :

| # | Scénario | ☐ |
|---|---|---|
| 1 | Installer l'APK sur un Android non-développeur | ☐ |
| 2 | Recherche « Plombier · Sousse » → ≥ 5 résultats classés | ☐ |
| 3 | Filtre « Vérifié uniquement » → seuls les artisans au badge s'affichent | ☐ |
| 4 | Ouvrir une fiche → galerie, tarifs, zones, avis | ☐ |
| 5 | Clic « Appeler » → le composeur s'ouvre avec le bon numéro | ☐ |
| 6 | Le `ContactEvent` est enregistré (vérifiable en base ou via l'API) | ☐ |
| 7 | Clic « WhatsApp » → message pré-rempli **dans la langue active** | ☐ |
| 8 | Connexion OTP de bout en bout | ☐ |
| 9 | Dépôt d'un avis après contact → la note moyenne se met à jour | ☐ |
| 10 | Déposer un avis **sans** contact préalable → refusé | ☐ |
| 11 | Bascule en arabe → aucune casse de mise en page, RTL correct | ☐ |
| 12 | Mode avion → résultats en cache, message clair, **pas d'écran blanc** | ☐ |
| 13 | Appeler **hors ligne** → le composeur s'ouvre, l'événement part au retour du réseau | ☐ |
| 14 | Défilement fluide sur un Android d'entrée de gamme | ☐ |
| 15 | Aucune donnée sensible dans les logs serveur | ☐ |

**Livrables attendus au soir du J7 :**

1. `main` verte, backend déployé sur `staging`
2. **Un APK Android signé, installable, testé sur un appareil réel**
3. `contracts/openapi.json` publié et à jour
4. `backlog/DONE.md` à jour, `backlog/TODO.md` re-priorisé pour S2
5. Une rétrospective écrite dans `#a_vue_générale`

---

## 12. Sprint S2 — déjà cadré

**Priorité n°1 : `apps/web`** (le lot reporté). Le backend l'expose déjà entièrement, ce n'est que de la
consommation d'API : bootstrap Next.js 15, routing `[locale]` FR/AR, pages
`/[gouvernorat]/[service]` en SSG/ISR, fiche artisan + JSON-LD `LocalBusiness`, contact tracé,
sitemap dynamique, Lighthouse ≥ 90. Estimé ~35 h — **un sprint web tient largement en une semaine
avec deux devs**, ce qui laisse de la place pour :

KYC / vérification CIN complète (bucket privé chiffré, URL signées 5 min, purge, journal d'accès) ·
back-office admin · espace Pro mobile si coupé en S1 · notifications push · worker BullMQ.

**S3** : plans, abonnements, première passerelle de paiement, crédits, boosts — et surtout la
**recherche vocale en derja + RAG**, la fonctionnalité différenciante du document de stratégie.
