# Organisation du développement — Sanaya

> Version 1.0 — 2026-08-15 · Dépôt : `dallel5-git/plateforme-artisans`
> Équipe : **Oussama** (product/tech lead & dev) · **Chayma** (dev)
> Décisions applicables : `ADR-001` (Flutter + REST/OpenAPI) · `ADR-002` (badge vérifié) · `ADR-003` (périmètre S1)

---

# 1. Vue d'ensemble & Architecture

## 1.1 Le MVP en une phrase

**Sanaya** met en relation les particuliers tunisiens et les artisans (plomberie, électricité,
peinture, climatisation…) sur un modèle de **génération de leads, sans intermédiation de paiement de
la prestation** : la plateforme met en contact, elle n'encaisse jamais le montant du chantier.

| | |
|---|---|
| **Utilisateur qui paie** | L'artisan (abonnement Pack Pro + crédits/boosts) — le particulier ne paie jamais |
| **Unité de valeur vendue** | Le **lead** : un clic « Appeler » ou « WhatsApp » tracé (`ContactEvent`) |
| **Marché de lancement** | Le Sahel — Sousse, Monastir, Mahdia — avant toute expansion nationale |
| **Contrainte produit n°1** | Android d'entrée de gamme, réseau 3G, bilingue FR/AR avec RTL |
| **Différenciateur visé** | La confiance (badge vérifié gratuit + avis certifiés) puis, en S3, la **recherche vocale en derja** |

**Le raisonnement économique tient en une chaîne** : la confiance amène l'audience, l'audience amène
les contacts, les contacts *mesurés* prouvent la valeur à l'artisan, et cette preuve vend
l'abonnement. Si l'un des maillons n'est pas instrumenté, le modèle ne se démontre pas — d'où
l'obsession du traçage (`ContactEvent`) et de l'anti-fraude dans tout ce document.

## 1.2 Technologies retenues

| Couche | Choix | Pourquoi celui-là |
|---|---|---|
| **Monorepo** | pnpm workspaces + **Turborepo** | Cache local et distant, graphe de dépendances explicite. Nx écarté : plus puissant mais trop lourd à opérer à deux. |
| **Backend** | **Fastify 5** + **Zod** + `fastify-type-provider-zod` + `@fastify/swagger` | Un seul schéma Zod valide les entrées **et** génère le contrat OpenAPI. Zéro duplication, zéro YAML maintenu à la main. |
| **Base de données** | **PostgreSQL 16** + **Prisma 6** | Domaine intrinsèquement relationnel et transactionnel. `pg_trgm`/`unaccent` pour la recherche FR/AR, PostGIS pour le géospatial. NoSQL écarté : schéma stable, volumes très loin des limites d'une instance managée. |
| **Cache / files** | **Redis** (Upstash) + BullMQ *(S3)* | Rate limiting, sessions révocables, agrégats différés. |
| **Mobile** | **Flutter 3.24** · go_router · Riverpod 2 · Dio+Retrofit · freezed · slang | Rendu identique et fluide sur Android d'entrée de gamme (Impeller), sans pont JS. **C'est le produit principal.** |
| **Web** *(S2)* | **Next.js 15** App Router · Tailwind v4 · shadcn/ui · TanStack Query | SSG/ISR indispensable au SEO local — c'est ce qui remplace les groupes Facebook dans Google. |
| **Back-office** *(S3)* | Next.js, application **séparée** | Surface d'attaque distincte, non indexée, bundle jamais servi aux clients. |
| **Contrat d'API** | **OpenAPI 3.1 généré** → `openapi-typescript` (web) + `openapi-generator` dart-dio (mobile) | Voir §1.4. |
| **Stockage** | Cloudflare R2 — 2 buckets : `public-media` (CDN) et `private-kyc` (chiffré) | Compatible S3, pas de frais d'egress. |
| **i18n** | Catalogues JSON partagés → i18next (web) + slang (mobile) | Une seule source FR/AR pour les trois surfaces. |
| **Design** | `tokens.json` → preset Tailwind **et** `ThemeExtension` Dart | Le seul moyen de garder une identité cohérente sans code partagé. |
| **Tests** | Vitest · flutter_test + mocktail · Playwright *(S2)* · Maestro *(S3)* | Pyramide réaliste pour deux personnes. |
| **CI/CD** | GitHub Actions + cache Turborepo | Sous 5 minutes, sinon elle sera contournée. |

### ⚠️ La décision qui structure tout le reste

Le cadrage v1.0 prévoyait **Expo/React Native + tRPC**, avec le typage bout-en-bout comme pilier.
Le passage à **Flutter** l'invalide : tRPC n'est pas un protocole, c'est une astuce de typage
TypeScript — il n'existe pas d'équivalent en Dart et il n'y en aura pas.

**Le contrat d'API est donc reconstruit sur OpenAPI**, généré depuis les mêmes schémas Zod. Le
partage de code passe de ~70 % à ~40 % : c'est le prix assumé de la fluidité native (`ADR-001`).

## 1.3 Architecture logique

```
┌──────────────────────┐  ┌──────────────────────┐  ┌──────────────────────┐
│  apps/mobile         │  │  apps/web      (S2)  │  │  apps/admin    (S3)  │
│  Flutter 3.24        │  │  Next.js 15          │  │  Next.js             │
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
                    │   versionné · vérifié en CI      │     (`api:contract --check`)
                    └────────────────┬─────────────────┘
                                     │
                    ┌────────────────▼─────────────────┐
                    │   apps/api — Fastify 5           │  TRANSPORT UNIQUEMENT
                    │   ┌──────────────────────────┐   │  Une route : valide (Zod)
                    │   │ cors · helmet · rate-limit│   │  → appelle core
                    │   │ jwt · rbac · requestId    │   │  → sérialise
                    │   └──────────────────────────┘   │  Aucun `if` métier ici.
                    │   routes/ : 1 fichier = 1 module │
                    └────────────────┬─────────────────┘
                                     │
                    ┌────────────────▼─────────────────┐
                    │   packages/core                  │  ⭐ LE VRAI ACTIF
                    │   ranking · policies · éligibilité│  Fonctions pures.
                    │   complétude · montants · dates   │  Zéro dépendance HTTP/React.
                    │                                   │  100 % testable sans base.
                    └────────────────┬─────────────────┘
                                     │
   ┌──────────────┬──────────────────┼──────────────┬──────────────────┐
   ▼              ▼                  ▼              ▼                  ▼
┌────────┐  ┌───────────┐  ┌────────────────┐  ┌──────────┐  ┌────────────────┐
│packages│  │ packages/ │  │  packages/     │  │ packages/│  │  apps/worker   │
│  /db   │  │  storage  │  │  notifications │  │ payments │  │  BullMQ (S3)   │
│Prisma 6│  │  R2 (S3)  │  │  SMS · Push    │  │ Konnect… │  │  agrégats,     │
│  PG16  │  │  2 buckets│  │                │  │ (S4)     │  │  expirations   │
└───┬────┘  └───────────┘  └────────────────┘  └──────────┘  └────────────────┘
    │
    ▼
┌─────────────────────────────┐   ┌──────────────┐
│  PostgreSQL 16              │   │  Redis       │
│  unaccent · pg_trgm · PostGIS│   │  rate-limit  │
└─────────────────────────────┘   │  cache·files │
                                  └──────────────┘

Packages partagés (TypeScript) : validators (Zod) · constants · utils · i18n · design-tokens
                                  ▲                                        ▲
                                  │ source du contrat OpenAPI              │ génère aussi le Dart
```

**Modular monolith, pas de microservices.** Un seul serveur, découpé en modules métier étanches
(`auth`, `catalog`, `providers`, `search`, `contacts`, `reviews`, `billing`, `moderation`,
`analytics`). Un module n'importe d'un autre que son `index.ts` — et c'est **le linter qui
l'impose**, pas la discipline : sans contrainte automatisée, la modularité se dégrade en trois mois.

## 1.4 Flux de données — les trois qui comptent

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
> transactionnelle (pas d'incohérence), et file hors ligne (pas de perte sur réseau dégradé).

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

## 1.5 Ce qui est délibérément hors du MVP

Pas d'intermédiation de paiement de la prestation (éviterait un agrément d'établissement de
paiement, du séquestre et la gestion de litiges financiers — hors de portée à deux) · pas de
microservices · pas de lancement national · pas de messagerie interne · pas de devis ni de
réservation de créneau. Les entités `ServiceRequest` / `ServiceRequestMatch` restent **modélisées**
pour préserver le point d'extension, sans aucun écran.

---

# 2. Découpage fonctionnel

## 2.1 Les 9 modules métier

Ce découpage est celui du code (`packages/core/<module>`, `apps/api/src/routes/<module>`), celui des
labels GitHub (`domaine:*`) et celui des canaux Slack. **Une seule taxonomie pour tout le projet** :
c'est ce qui permet de passer d'une issue à un répertoire sans réfléchir.

| Module | Périmètre | Entités principales | Sprint |
|---|---|---|---|
| **auth** | OTP SMS, JWT rotatif, sessions révocables, RBAC | `User`, `Session`, `OtpCode` | **S1** |
| **catalog** | Référentiel géographique et arbre de catégories | `Governorate`, `Delegation`, `Category` | **S1** |
| **search** | Filtres, ranking explicable, pagination curseur | *(lecture)* | **S1** |
| **providers** | Profil artisan, onboarding, complétude, médias | `ProviderProfile`, `ServiceOffering`, `CoverageArea`, `MediaAsset` | **S1** |
| **contacts** | Révélation du numéro, traçage, déduplication | `ContactEvent`, `ProfileView` | **S1** |
| **reviews** | Avis certifiés, agrégats, réponses | `Review`, `ReviewReply` | **S1** |
| **moderation** | Vérification CIN, signalements, back-office | `VerificationRequest`, `Report`, `AuditLog` | S3 |
| **billing** | Plans, abonnements, crédits, boosts, paiements | `Plan`, `Subscription`, `CreditWallet`, `Boost`, `Payment` | S4 |
| **analytics** | Statistiques artisan, agrégats journaliers, KPI | `DailyProviderStat` | S1 *(collecte)* / S2 *(affichage)* |

## 2.2 Les trois parcours utilisateur

```
👤 CLIENT (particulier)                    🔧 ARTISAN                    🛡️ ADMIN
   │                                          │                             │
   ├─ Chercher un service             ├─ S'inscrire (OTP)          ├─ Vérifier une CIN
   ├─ Filtrer (zone, note, vérifié)   ├─ Compléter son profil      ├─ Modérer les avis
   ├─ Consulter une fiche             ├─ Choisir catégories/zones  ├─ Traiter un signalement
   ├─ ⭐ APPELER / WhatsApp           ├─ Voir ses statistiques      ├─ Régler les poids du ranking
   ├─ Laisser un avis                 ├─ Répondre aux avis          └─ Piloter les KPI
   └─ Mettre en favori                └─ S'abonner / acheter des crédits
   ────────────── S1 ──────────────   ──── S1 (profil) · S2-S4 ────   ──────── S3 ────────
```

Le parcours client est **entièrement livré en S1** ; c'est lui qui porte l'objectif du sprint.
Le parcours artisan est livré par tranches (profil en S1 si le rythme tient, statistiques en S2,
monétisation en S4). Le parcours admin arrive en S3 — jusque-là, Prisma Studio en accès restreint.

## 2.3 Découpage en incréments livrables

Chaque incrément est **démontrable**. Un incrément qui ne se démontre pas n'en est pas un.

| # | Incrément | Ce qu'on peut montrer | Sprint |
|---|---|---|---|
| **1** | Socle & contrat | `GET /v1/health` répond, CI verte, contrat OpenAPI généré | S1 · J1 |
| **2** | Backend du parcours cœur | Les 8 appels `curl` : OTP → recherche → fiche → contact → avis | S1 · J4 |
| **3** | **App mobile MVP** | **APK signé installé sur un Android réel, en 3G, en FR et en AR** | S1 · J7 |
| **4** | Web SEO | Une page `/fr/sousse/plomberie` indexable, Lighthouse ≥ 90 | S2 |
| **5** | Confiance & back-office | Un artisan téléverse sa CIN, un admin la valide, le badge apparaît | S3 |
| **6** | Monétisation | Un artisan souscrit au Pack Pro et sa visibilité augmente | S4 |
| **7** | Différenciation | Un client dit *« 3andi fuite fil lavabo »* et obtient 3 plombiers | S5 |

---

# 3. Organisation sur GitHub

> **Tout ce qui suit est livré sous forme de scripts idempotents.** Voir §3.5 pour les lancer.

## 3.1 Milestones

Un milestone = **un incrément démontrable**, jamais une couche technique. Les dates sont des
engagements de démo.

| Milestone | Échéance | Contenu | Critère de clôture |
|---|---|---|---|
| **M0 — Socle & Contrat** | 17/08 | Monorepo, CI, Docker, Fastify, générateurs tokens + i18n | `GET /v1/health` répond · CI verte sur une PR blanche |
| **M1 — Backend Core API** | 20/08 | Auth OTP, référentiel, ranking, recherche, fiche, contact, avis, contrat publié | **🚦 GATE 1** : les 8 appels `curl` passent |
| **M2 — App Mobile MVP** | 23/08 | Flutter complet, FR/AR + RTL, APK signé | **🚦 GATE 2** : 15 scénarios sur Android réel en 3G |
| **M3 — Web SEO & Acquisition** | 30/08 | `apps/web` : SSG/ISR, JSON-LD, sitemap | Lighthouse ≥ 90 · page indexable |
| **M4 — Confiance & Back-office** | 06/09 | KYC complet, modération, `apps/admin` | Un cycle CIN complet · **déclaration INPDP déposée** |
| **M5 — Monétisation** | 13/09 | Plans, abonnements, crédits, boosts, paiement | Un artisan paie et sa visibilité augmente |
| **M6 — Différenciation & Lancement** | 27/09 | Vocal/RAG, push, worker, observabilité, E2E | Parcours vocal fonctionnel · sauvegarde **restaurée** |

> ⛔ **M5 est bloqué** tant que l'`ADR-004` (moyens de paiement) n'est pas tranché — la question 2 du
> cadrage reste ouverte et détermine la modélisation.

## 3.2 Labels — 6 familles, une dimension chacune

Convention : `<famille>:<valeur>`. Une issue porte **au plus un label par famille**, sauf `domaine:`.
C'est ce qui rend les filtres du Project fiables.

| Famille | Valeurs | À quoi ça sert |
|---|---|---|
| **type:** | `feat` `fix` `chore` `refactor` `test` `docs` `spike` `epic` | La nature du travail |
| **lot:** | `socle` `backend` `mobile` `web` `admin` `design` | **Où vit le code** → pilote CODEOWNERS et prédit le risque de conflit |
| **domaine:** | `auth` `catalog` `search` `providers` `contact` `reviews` `billing` `moderation` `analytics` | Le module métier (0 à n) |
| **prio:** | `P0` `P1` `P2` | `P0` non négociable · `P1` **l'amortisseur** · `P2` ne pas commencer |
| **size:** | `S` (≤2 h) `M` (2-4 h) `L` (4-8 h) | Au-delà de `L`, on découpe |
| **sprint:** | `S1` `S2` `S3+` | Affectation |

### Les 8 labels transverses — ce sont eux qui font le travail

| Label | Effet concret |
|---|---|
| 🟧 **`contrat-api`** | La PR modifie `contracts/openapi.json` → **prévenir l'autre dev avant le merge** et régénérer les clients. *Le mécanisme anti-conflit n°1 du projet.* |
| 🟧 **`binome`** | À faire à deux : l'erreur y coûte trop cher pour être détectée en relecture. |
| 🟥 **`securite`** | Données personnelles, INPDP, secrets, anti-fraude. Revue obligatoire du lead. |
| 🟨 **`rtl-ar`** | Nécessite une vérification du rendu en arabe. Captures FR + AR exigées dans la PR. |
| 🟪 **`gate`** | Porte de sprint bloquante. |
| ⬛ **`blocked`** | Posé automatiquement par le script de seed sur toute issue ayant des dépendances. |
| 🟣 **`needs-decision`** | Attend un arbitrage du lead. **Ne pas coder.** |
| 🟩 **`first-dart`** | Bon point d'entrée pour découvrir Flutter — utile en J4 quand les deux devs basculent sur Dart. |

Les labels GitHub par défaut (`bug`, `enhancement`, `good first issue`…) sont **supprimés** par le
script : deux taxonomies concurrentes ne survivent jamais à un sprint.

## 3.3 Modèle d'issue

Trois formulaires (`.github/ISSUE_TEMPLATE/`), les issues vierges sont désactivées :
**🔧 Tâche** · **🐛 Bug** · **🧭 Décision à trancher** (produit un ADR).

Le formulaire *Tâche* impose la *Definition of Ready* : ID de backlog, contexte, périmètre, **hors
périmètre**, critères d'acceptation observables, guard-rails cochés, estimation, dépendances.

> Le champ **« Hors périmètre (volontairement) »** vaut le détour : c'est lui qui évite le
> « tant qu'on y est » en cours de tâche et le débat en revue.

### Exemple réel — `BE-15`, généré et prêt à créer

```markdown
[BE-15] ⭐ Algorithme de ranking : score explicable et note bayésienne

> ID backlog `BE-15` · Estimation 4 h · Dépend de `BE-01`

## Contexte
**Le cœur du produit.** Le classement conditionne directement le chiffre d'affaires :
c'est lui qui détermine quel artisan est vu, donc contacté, donc prêt à payer. Il doit
être explicable (un artisan qui appelle doit obtenir une réponse), paramétrable (sans
redéploiement) et auditable (testable sans base).

**À faire en binôme** : une erreur ici est coûteuse à détecter et se paie en revenus.

## Périmètre
- [ ] Pertinence géographique : 1.0 délégation exacte · 0.6 gouvernorat · 0.3 limitrophe
- [ ] **Note bayésienne** : (C·m + Σnotes) / (C + n) avec C ≈ 8
- [ ] Confiance : badge vérifié = 1, sinon 0
- [ ] Complétude : completionScore / 100
- [ ] Réactivité : lastActiveAt + availabilityStatus
- [ ] Facteur de plan : Plan.rankingBoostFactor (1.0 gratuit, 1.3 Pro)
- [ ] Pénalité de signalements
- [ ] **Rotation équitable** : à score égal (± 2 %), l'ordre tourne
- [ ] Poids w1…w7 lus depuis AppSetting, jamais codés en dur

## Hors périmètre (volontairement)
- Les boosts : emplacements séparés étiquetés « Sponsorisé ». Ils n'entrent PAS
  dans rankingScore (S4).

## Critères d'acceptation
- [ ] **≥ 12 tests unitaires**, sans base ni réseau
- [ ] Un artisan à 1 seul avis 5★ ne devance PAS un artisan à 80 avis / 4,7★
- [ ] 🔒 **Non-régression ADR-002** : un artisan *gratuit, vérifié, profil 100 %*
      obtient un score **supérieur** à un artisan *Pro non vérifié, incomplet*
- [ ] Changer un poids dans AppSetting change l'ordre sans redéploiement
- [ ] Chaque score est décomposable terme à terme (mode debug)

## 🚧 Guard-rails
- **Timeboxé à 4 h.** Au-delà : version simplifiée + création de `BE-15b`.
- Aucun code ne lit `subscription.status` pour décider du badge (ADR-002)

## Références
Annexe A du cadrage · ADR-002 §5

Labels : type:feat · lot:backend · domaine:search · prio:P0 · sprint:S1 · binome · size:L
Milestone : M1 — Backend Core API   ·   Assignés : Oussama + Chayma
```

**56 issues sont générées de cette qualité** : 50 tâches S1 détaillées + 6 épiques S2-S6 à
décomposer au démarrage de leur sprint. Décomposer M3-M6 dès maintenant produirait 200 issues que
personne ne lit et qui seront périmées avant d'être ouvertes.

## 3.4 Project (Kanban)

**Colonnes** — le champ `Status` :

```
Backlog  →  Ready  →  In progress  →  In review  →  Blocked  →  Done
            ▲          ▲                                        ▲
        DoR remplie   max 2 par dev                      DoD remplie
```

> **La limite de 2 tâches en cours par personne est la règle la plus rentable du tableau.**
> À trois tâches simultanées, on n'en finit aucune — et une tâche finie à 90 % compte pour 0 %.

**Champs personnalisés** : `Dev` (Oussama · Chayma · binôme) · `Estimation` (heures) ·
`Gate` (GATE 1 · GATE 2) · `Sprint` (itération d'une semaine).

**Vues** : *Sprint courant* (filtre `sprint:S1`, groupé par Status) · *Par dev* (groupé par `Dev`,
sans les Done) · *Chemin critique* (`binome` + `contrat-api`) · *Bloqués* (`blocked` +
`needs-decision`).

**Automatisations** : item ajouté → `Backlog` · PR liée ouverte → `In review` · issue fermée → `Done`.
Un `Closes #N` dans la PR ferme l'issue et la déplace : le tableau se met à jour tout seul, ce qui
est la seule façon qu'il reste à jour.

## 3.5 Mise en place — 4 commandes

```bash
# 0. Prérequis
brew install gh jq          # ou : apt install gh jq
gh auth login               # scopes : repo, project, read:org

# 1. Labels + milestones + Project   (vérifier d'abord à blanc)
DRY_RUN=1 ./tooling/scripts/gh-bootstrap.sh
./tooling/scripts/gh-bootstrap.sh

# 2. Générer le fichier d'issues depuis la source unique
python3 tooling/scripts/issues-data.py > tooling/scripts/github-issues.json

# 3. Créer les 56 issues  (idempotent : relançable sans doublon)
DRY_RUN=1 ./tooling/scripts/gh-seed-issues.sh
GH_OUSSAMA=dallel5-git GH_CHAYMA=<handle> ./tooling/scripts/gh-seed-issues.sh

# Filtrer si besoin
ONLY=sprint:S1 ./tooling/scripts/gh-seed-issues.sh
```

Il reste **trois actions manuelles** (non scriptables) : inviter Chayma au dépôt et remplacer
`@CHAYMA-HANDLE` dans `CODEOWNERS` · protéger `main` (Settings → Branches) · créer les vues et
champs du Project.

> **Le fichier `github-issues.json` est généré** depuis `issues-data.py`, lui-même aligné sur
> `backlog/TODO.md`. Ne jamais éditer le JSON à la main — même principe que `openapi.json`.

---

# 4. Répartition pour deux développeurs

## 4.1 Le principe

**On ne répartit pas par compétence, on répartit par répertoire.** Deux personnes qui éditent les
mêmes fichiers passent leur temps à résoudre des conflits ; deux personnes qui possèdent des
répertoires disjoints avancent en parallèle sans se voir.

L'exception assumée : **cinq tâches sont faites en binôme**, choisies non pas parce qu'elles sont
volumineuses, mais parce que **l'erreur y coûte trop cher pour être détectée en relecture**.

## 4.2 La répartition

```
        J1          J2          J3        J4 am │ J4 pm      J5      J6      J7
     ┌────────────────────────────────────────┬─────────────────────────────────┐
Ouss.│  SOCLE  │      AUTH & SÉCURITÉ         │    FLUTTER — surface            │
     │  api·CI │   + API métier (lecture)     │    (i18n/RTL, DS, auth, fiche)  │
     ├────────────────────────────────────────┼─────────────────────────────────┤
Chay.│  SOCLE  │      DONNÉES & DOMAINE       │    FLUTTER — chemin critique    │
     │ db·tok. │   (Prisma, seed, repos)      │    (réseau, recherche, contact) │
     └────────────────────────────────────────┴─────────────────────────────────┘
                                            ▲                                   ▲
                                      🚦 GATE 1                           🚦 GATE 2
     ⭐ binôme :   BE-15 (J3 pm)   BE-21 (J4 am)   FM-02 (J4 pm)   BE-27   QA-03
```

| | **Oussama** | **Chayma** |
|---|---|---|
| **Répertoires possédés** | `apps/api/` · `packages/auth/` · `packages/validators/` · `.github/` · `tooling/` | `packages/db/` · `packages/core/` · `packages/design-tokens/` |
| **J1 — socle** | `SO-01` monorepo · `SO-03` Fastify · `SO-06` CI · `SO-07` protection | `SO-02` Docker · `SO-04` tokens · `SO-05` i18n |
| **J2-J3 — backend** | `BE-06`→`BE-13` (phone, OTP, SMS, JWT, routes auth, rate-limit, RBAC, erreurs) · `BE-16` search · `BE-17` fiche · `BE-18` avis · `BE-22` reviews · `BE-26` contrat | `BE-01` schéma · `BE-02` migrations · `BE-03` seed géo · `BE-04` seed démo · `BE-05` repos · `BE-14` catalogue · `BE-23` vues |
| **J4-J7 — Flutter** | `FM-03` i18n/RTL · `FM-04` design system · `FM-05` auth · `FM-08` fiche · `FM-10` avis | `FM-01` bootstrap · `FM-06` accueil · `FM-07` recherche · `FM-09` **contact** · `FM-14` APK |
| **Nature du rôle** | La **surface** : ce que l'utilisateur voit et touche | Le **chemin critique** : données, réseau, ce qui bloque tout le reste |

**Pourquoi ce sens-là ?** Chayma tient la chaîne dont tout dépend (schéma → repositories → réseau →
recherche → contact → APK) : elle n'attend jamais après personne. Oussama tient ce qui se greffe
dessus et peut absorber les aléas (la CI casse, une PR à relire, un arbitrage produit) sans bloquer
Chayma.

### Les 5 tâches en binôme, et pourquoi elles seulement

| Tâche | Pourquoi à deux |
|---|---|
| `BE-15` **ranking** | Détermine qui est vu, donc les revenus. Une erreur de pondération est invisible en relecture et se paie pendant des mois. |
| `BE-21` **contact-events** | L'unité de valeur vendue. Un comptage faux ou gonflable rend l'abonnement Pro indéfendable. |
| `FM-02` **couche réseau** | Toute l'app en dépend — et c'est le meilleur moment pour qu'Oussama prenne Dart en main. |
| `BE-27` **GATE 1** | Une recette validée seul n'est pas une recette. |
| `QA-03` **GATE 2** | Idem, sur appareil réel. |

`FM-02` en binôme règle au passage le risque de *bus factor* identifié dans l'`ADR-001` §4.2 :
« un seul portera le mobile après la semaine 1 ».

## 4.3 Anti-conflit Git — les quatre fichiers qui vont poser problème

Sur un monorepo à deux, ce ne sont jamais les fichiers métier qui posent problème : ce sont les
fichiers **partagés** et les fichiers **générés**. Ils sont traités un par un.

| Fichier | Risque | Règle |
|---|---|---|
| **`schema.prisma`** | Deux migrations concurrentes → base incohérente, quasi impossible à démêler | **Chayma en est la seule propriétaire en S1** (CODEOWNERS). Oussama a besoin d'un champ ? Il le demande dans `#développement-du-backend`, Chayma pousse la migration. Non négociable. |
| **`contracts/openapi.json`** | Généré, volumineux, conflit garanti | `merge=ours` + `-diff` dans `.gitattributes`. En cas de conflit : `git checkout --ours && pnpm api:contract && git add`. **Jamais fusionné à la main.** Toute PR qui le touche porte le label `contrat-api`. |
| **`pnpm-lock.yaml`** | Conflit fréquent, et un mauvais merge fait disparaître des dépendances **silencieusement** | ⚠️ **Surtout pas `merge=ours`.** En cas de conflit : `git checkout --theirs pnpm-lock.yaml && pnpm install`. Règle d'équipe : on annonce l'ajout d'une dépendance en Slack. |
| **Fichiers Dart générés** (`*.g.dart`, `*.freezed.dart`, client API) | Volumineux, régénérés à chaque build | `merge=ours` + `linguist-generated`. En cas de conflit : `dart run build_runner build --delete-conflicting-outputs`. |

`.gitattributes` et `.github/CODEOWNERS` sont livrés. **CODEOWNERS n'est pas de la bureaucratie :
c'est le principal outil anti-conflit du projet** — il rend visible, avant même d'écrire une ligne,
qu'on entre chez quelqu'un d'autre.

### Protocole de changement du contrat d'API

C'est le seul point de couplage fort entre les deux développeurs. Il mérite son protocole :

```
1. Celui qui change un schéma Zod le dit dans #développement-du-backend  ← AVANT de coder
2. Il régénère : pnpm api:contract && pnpm mobile:client
3. Il commite openapi.json ET les clients générés dans LA MÊME PR
4. Il pose le label `contrat-api`
5. Il merge, puis prévient : « contrat à jour, faites un rebase »
6. L'autre : git pull --rebase && pnpm mobile:client
```

La CI (`api:contract --check`) rattrape les oublis, mais elle les rattrape **après** — le protocole
existe pour qu'ils n'arrivent pas.

## 4.4 Règles de branche et de PR

```
main                                   protégée · production · merge depuis develop uniquement (Oussama)
└── develop                            protégée · staging · 1 approbation · CI verte · squash-merge
    ├── feat/BE-15-ranking-bayesien
    ├── fix/BE-11-normalisation-telephone
    └── chore/SO-06-cache-turborepo
```

- **Tout collaborateur avec droit d'écriture merge vers `develop`** dès que la PR est prête (CI verte,
  1 approbation). Seul Oussama fait le merge `develop → main` (release de production). Seul Claude ne
  clique jamais sur « Merge », même vers `develop`. Voir `POLITIQUE-PROJET.md` §3.3.
- Format : `<type>/<ID>-<slug>`. **L'ID est obligatoire** — c'est ce qui relie le code au plan.
- **Durée de vie ≤ 2 jours.** Au-delà, la tâche était trop grosse : on découpe.
- Rebase sur `develop` avant d'ouvrir la PR. Pas de merge commit dans une branche de feature.
- **Diff < 400 lignes** hors fichiers générés. Au-delà de 800, la PR est refusée et découpée : la
  qualité de revue s'effondre passé ce seuil, ce n'est pas une question de bonne volonté.
- **Revue sous 4 h ouvrées.** À deux, une PR en attente bloque 50 % de l'équipe.
- Commentaires préfixés `[bloquant]` / `[suggestion]` / `[question]` — pour qu'on sache ce qui
  empêche le merge et ce qui est un avis.

## 4.5 Le rythme de la semaine

| Rituel | Quand | Format |
|---|---|---|
| **Daily écrit** | 9h00, dans `#a_vue_générale` | Hier / aujourd'hui / bloqué par. Écrit, pas en réunion. |
| **Mise à jour du tableau** | Fin de journée | `DOING.md` et le Project reflètent l'instant présent |
| **Point de mi-sprint** | Mercredi 14h | *Le périmètre tient-il ? Que coupe-t-on ?* — **le dernier jour où couper coûte peu** |
| **Revue de sprint** | Vendredi 16h | Démo sur appareil réel, jamais sur l'émulateur du développeur |
| **Rétrospective** | Vendredi 17h | On garde / on arrête / on essaie |

## 4.6 Les cinq règles qui font la différence

1. **Chayma est seule propriétaire du schéma Prisma en S1.** C'est la règle qui évite le conflit le
   plus douloureux du projet.
2. **Un changement de contrat d'API s'annonce avant, pas après.** Label `contrat-api`, message Slack,
   clients régénérés dans la même PR.
3. **Deux tâches en cours maximum par personne.** Trois, et on n'en finit aucune.
4. **Au premier jalon manqué, on coupe dans la liste 🟠 P1** — dans l'ordre écrit
   (`BE-19`+`FM-11`, puis `BE-24`+`FM-12`, puis `BE-20`, puis `BE-25`+`FM-13`). Pas au troisième
   jalon manqué : au premier.
5. **Si `develop` est rouge, c'est la priorité n°1 des deux**, avant toute autre tâche.
6. **Tout collaborateur avec droit d'écriture merge vers `develop`**, dès qu'une PR est prête (CI verte,
   approuvée) — pas besoin d'attendre Oussama. Seul Oussama fait le merge `develop → main`.
   Claude reste la seule exception pour tout merge : il ne clique jamais sur Merge.

---

## Annexe — Récapitulatif de la charge S1

| Lot | 🔴 P0 | 🟠 P1 |
|---|---|---|
| Socle (J1) | 11,5 h | — |
| Backend (J2 → J4 am) | 53 h | 5,5 h |
| Mobile Flutter (J4 pm → J7) | 43 h | 10 h |
| Qualité | 4 h | 2,5 h |
| **Total** | **109 h-homme** | **18 h** |
| Capacité (2 × 7 j × 8 h) | **112 h** | |
| **Marge** | **3 %, c'est-à-dire aucune** | |

> ⚠️ **Une tâche en binôme compte double** en heures-homme. C'est l'erreur qui avait faussé la
> première version du plan (159 h annoncées à 112 h de capacité, soit +42 %) et qui a conduit à
> l'`ADR-003` : reporter `apps/web` en S2.
>
> Le seul amortisseur réel est la liste 🟠 P1. **Et 8 h effectives par jour pendant 7 jours
> consécutifs reste une hypothèse optimiste.**
