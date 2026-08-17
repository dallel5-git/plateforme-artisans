# Politique de projet — Sanaya

> Version 1.0 — 2026-08-15
> S'applique à : Oussama Dallel (lead), DEV-1, DEV-2.
> Cette politique prime sur les habitudes individuelles. Elle se modifie par PR, pas par message Slack.

---

## 1. Principes de fonctionnement

1. **Le code écrit sans trace de décision sera réécrit.** Toute décision structurante → un ADR dans `Code/docs/01-architecture-decision-records/`.
2. **On ne code que ce qui est dans le backlog du sprint.** Une bonne idée hors périmètre est une ligne dans `backlog/TODO.md`, pas un commit.
3. **`main` est toujours déployable.** Si `main` est rouge, c'est la priorité n°1 de toute l'équipe, avant toute autre tâche.
4. **La revue de code n'est pas optionnelle**, même à deux, même sous pression. Une PR non relue est une dette contractée sans en connaître le taux.
5. **Le silence n'est pas un accord.** Une PR sans réponse sous 4 h ouvrées se relance en Slack.
6. **On mesure avant d'optimiser**, et on trace avant de monétiser (principe P9).

---

## 2. Rôles

| Rôle | Titulaire | Responsabilité |
|---|---|---|
| Product / Tech lead | Oussama Dallel | Arbitrage de périmètre, validation des ADR, priorisation du backlog |
| DEV-1 | à assigner | Voir `PLAN-MVP-SEMAINE-1.md` |
| DEV-2 | à assigner | Voir `PLAN-MVP-SEMAINE-1.md` |
| Astreinte `main` rouge | rotation quotidienne | Répare la CI avant toute autre tâche |
| Gardien du contrat d'API | rotation hebdomadaire | Vérifie qu'aucune PR ne casse `contracts/openapi.json` sans version |

**Pair-programmer IA** : chaque développeur travaille avec Claude en local. Le fichier `CLAUDE.md`
racine + le `CLAUDE.md` de son lot constituent le contexte partagé. Ils sont versionnés : une
correction de guard-rail bénéficie immédiatement aux deux postes.

---

## 3. Git

### 3.1 Branches

```
main                    protégée · déployable · squash-merge uniquement
├── feat/BE-03-auth-otp
├── feat/FW-07-search-page
├── fix/BE-11-phone-normalization
└── chore/CI-02-turbo-cache
```

- Format : `<type>/<ID-tâche>-<slug-court>`. **L'ID du backlog est obligatoire** — c'est ce qui relie le code au plan.
- Types : `feat` · `fix` · `chore` · `refactor` · `docs` · `test` · `perf`
- Durée de vie d'une branche : **≤ 2 jours**. Au-delà, on découpe la tâche.
- On rebase sur `main` avant d'ouvrir la PR. Pas de merge commit dans une branche de feature.

### 3.2 Commits — Conventional Commits

```
<type>(<scope>): <description à l'impératif, en français, sans point final>

[corps optionnel : le POURQUOI, pas le QUOI — le diff dit déjà le quoi]

Refs: BE-03
```

Exemples :
```
feat(auth): ajouter la vérification OTP avec hachage et TTL de 5 minutes
fix(search): normaliser les numéros +216 avant la recherche d'unicité
refactor(core): extraire le calcul bayésien du ranking dans une fonction pure
```

Scopes autorisés : `auth` `catalog` `providers` `search` `contacts` `reviews` `billing` `ads`
`moderation` `analytics` `db` `api` `web` `admin` `mobile` `ci` `docs` `design-tokens`

### 3.3 Protection de `main`

- Push direct **interdit**, y compris pour le lead.
- 1 approbation obligatoire.
- CI verte obligatoire : `lint` + `typecheck` + `test` + `api:contract --check` + `flutter analyze`.
- Squash-merge uniquement. Le titre de la PR devient le message de commit.
- La branche est supprimée après merge.

---

## 4. Pull requests

### 4.1 Taille

**Cible : < 400 lignes de diff.** Au-delà de 800 lignes, la PR est refusée et découpée — la qualité de
revue s'effondre au-delà de ce seuil, c'est mesuré et ce n'est pas une question de bonne volonté.

Exception explicite : fichiers générés (`openapi.json`, `*.freezed.dart`, `*.g.dart`, migrations
Prisma), qui ne comptent pas dans le total mais doivent être signalés dans la description.

### 4.2 Modèle de description

```markdown
## Tâche
BE-03 — Authentification OTP SMS

## Ce que fait cette PR
<2-4 phrases, orientées comportement observable>

## Ce qu'elle ne fait pas (volontairement)
<le périmètre exclu, pour éviter le débat en review>

## Contrat d'API
- [ ] Aucun changement
- [x] `openapi.json` régénéré · 2 routes ajoutées · aucun breaking change

## Tests
7 tests unitaires (core) · 2 tests d'intégration (api)

## Guard-rails
- [ ] Aucune donnée sensible loggée (téléphone, OTP, CIN, token)
- [ ] Aucun secret commité
- [ ] Pagination par curseur sur les listes
- [ ] Chaînes i18n ajoutées en FR **et** AR
- [ ] Aucune règle métier hors de `packages/core`

## Comment tester
1. …
```

### 4.3 Revue

- **Délai cible : 4 h ouvrées.** Une PR en attente bloque un développeur sur deux.
- Le relecteur distingue explicitement :
  - `[bloquant]` — doit être corrigé avant merge
  - `[suggestion]` — à considérer, l'auteur tranche
  - `[question]` — demande de compréhension, pas un reproche
- On commente le code, **jamais la personne**. « Cette fonction fait deux choses » et non « tu mélanges tout ».
- L'auteur répond à **chaque** commentaire, même par « ok, corrigé ».
- Si un désaccord dure plus de deux allers-retours : appel de 5 minutes, puis décision du lead, puis ADR si c'est structurant.

---

## 5. Definition of Ready / Definition of Done

### Definition of Ready — une tâche ne démarre pas sans

- [ ] Un ID (`BE-xx`, `FW-xx`, `FM-xx`, `CI-xx`)
- [ ] Un lien vers la ou les user stories du cadrage (`US-C-01`…)
- [ ] Des critères d'acceptation **observables** (pas « ça marche »)
- [ ] Une estimation en heures (max 8 h ; au-delà, découper)
- [ ] Ses dépendances identifiées et en `DONE`

### Definition of Done — une tâche n'est finie que si

- [ ] Le code est mergé sur `main`, CI verte
- [ ] Les critères d'acceptation sont vérifiés **manuellement** par l'auteur
- [ ] Les tests couvrent le cas passant **et** au moins un cas d'erreur
- [ ] Le contrat d'API est régénéré si nécessaire
- [ ] Les chaînes i18n existent en FR **et** AR
- [ ] La ligne est déplacée de `backlog/DOING.md` vers `backlog/DONE.md` avec la date et le n° de PR
- [ ] Rien de sensible n'a été loggé ni commité

> Une tâche « finie à 90 % » compte pour **0 %** dans le suivi. Il n'y a pas de statut intermédiaire.

---

## 6. Qualité & tests

| Niveau | Outil | Périmètre | Obligatoire ? |
|---|---|---|---|
| Unitaire | Vitest | `packages/core` — ranking, policies, éligibilité, montants, dates | ✅ **Oui, sans exception** |
| Unitaire | `flutter_test` + `mocktail` | widgets critiques, mappers, providers Riverpod | ✅ sur les écrans de conversion |
| Intégration | Vitest + base de test | routes `apps/api` avec une vraie PostgreSQL jetable | ✅ sur toute route qui écrit |
| E2E web | Playwright | parcours recherche → fiche → contact | ✅ 1 parcours minimum |
| E2E mobile | Maestro | parcours OTP → recherche → contact | ⚠️ à partir de la semaine 2 |

**Règles — opposables en revue, vérifiées par la CI (ADR-006) :**

1. **Tout changement de comportement s'accompagne d'un test.** Cas passant **et** au moins un cas
   d'erreur. Sont exemptés : documentation, fichiers générés, renommage pur, formatage, montée de
   version sans changement d'appel, configuration d'outillage. **L'exemption se déclare** en cochant
   la case dédiée dans la PR — elle ne se suppose pas. Le contrôle `Tests exigés` refuse le merge
   sinon.
2. **Toute correction de bug commence par un test qui reproduit le bug**, dans cet ordre : écrire le
   test → **le voir échouer** → corriger → committer les deux ensemble. Un test écrit après la
   correction ne prouve rien : on ne l'a jamais vu rouge. Le test porte `// régression #<issue>`.
3. **Les tests marqués `🔒 NON-RÉGRESSION` ne se suppriment pas.** Ils encodent une décision d'ADR,
   pas un détail d'implémentation. Les retirer exige un ADR qui annule la décision d'origine **et**
   la revue des deux développeurs. La CI compte ces marqueurs et bloque s'il en manque.
4. **Aucun seuil de couverture chiffré** — un pourcentage se triche : on atteint 80 % en testant les
   getters pendant que le ranking reste à découvert. On exige des tests **sur ce qui change**, pas
   un ratio global.
5. Aucun test désactivé (`.skip`, `@Skip`) sans un `// TODO(<ID>)` et une ligne dans le backlog.
6. Les tests de `packages/core` ne touchent **jamais** la base ni le réseau. S'ils en ont besoin,
   c'est que la logique est mal placée.

> En revue, la bonne question n'est pas « y a-t-il un test ? » mais
> **« si je casse cette ligne, est-ce que ce test devient rouge ? »**

**Outillage bloquant en CI :** ESLint (dont `no-restricted-imports` inter-modules), `tsc --noEmit`,
Prettier, `flutter analyze`, `dart format --set-exit-if-changed`, `api:contract --check`.

---

## 7. Sécurité, données personnelles et conformité

> Cadre légal : loi organique n°2004-63 relative à la protection des données à caractère personnel.
> Déclaration **INPDP à effectuer avant la mise en production** — c'est un jalon bloquant, pas une formalité.

### 7.1 Secrets

- Aucun secret dans le dépôt, jamais, même temporairement, même dans une branche. Un secret commité est un secret **révoqué** : on le change, on ne se contente pas de le retirer du diff.
- `.env.example` avec des valeurs factices, versionné. `.env` dans `.gitignore`.
- Secrets en CI : GitHub Actions Secrets. En production : coffre du fournisseur.
- Rotation des clés à chaque départ d'un intervenant.

### 7.2 Données sensibles

| Donnée | Traitement obligatoire |
|---|---|
| Image de CIN | Bucket privé chiffré (SSE), URL signée **5 min**, accès journalisé dans `AuditLog`, purge automatique à J+X après décision |
| Numéro de CIN | Jamais en clair : hash, + chiffrement AES-256-GCM si conservation nécessaire |
| OTP | Haché, TTL 5 min, 3 tentatives, rate-limit par téléphone **et** par IP |
| Téléphone | Normalisé, non exposé en HTML brut, révélé par appel API tracé et limité |
| Mot de passe interne | Argon2id. 2FA **obligatoire** pour tout compte `ADMIN`/`MODERATOR` |
| Refresh token | Rotatif, révocable, cookie `httpOnly` (web) / `flutter_secure_storage` (mobile) |

### 7.3 Droits des personnes

Le droit d'accès, d'export et de suppression (`US-C-13`) n'est pas une fonctionnalité « nice to have » :
c'est une obligation légale. Prévu dès le socle : `User.deletedAt` + anonymisation, et un export JSON.

### 7.4 Infrastructure

HTTPS strict + HSTS · CSP · dépendances auditées (`pnpm audit` en CI hebdomadaire) · sauvegardes PITR
quotidiennes avec **restauration testée trimestriellement** (une sauvegarde jamais restaurée n'est pas
une sauvegarde).

---

## 8. Rituels

| Rituel | Quand | Durée | Format |
|---|---|---|---|
| **Daily** | 9h00 (Africa/Tunis) | 10 min | Dans `#a_vue_générale` : hier / aujourd'hui / bloqué par. Écrit, pas en réunion. |
| **Point de mi-sprint** | Mercredi 14h | 20 min | Le périmètre tient-il ? Que coupe-t-on ? |
| **Revue de sprint** | Vendredi 16h | 45 min | Démo sur un appareil réel, pas sur l'émulateur du développeur |
| **Rétrospective** | Vendredi 17h | 30 min | 3 colonnes : on garde / on arrête / on essaie |
| **Mise à jour du backlog** | En continu | — | `DOING.md` reflète l'instant présent. Un backlog obsolète est pire qu'aucun backlog. |

**Canaux Slack et ce qu'on y met :**

| Canal | Contenu |
|---|---|
| `#a_vue_générale` | Plan, décisions, dailies, jalons, arbitrages de périmètre |
| `#développement-du-backend` | Lot backend : tâches, schéma, contrat d'API, migrations |
| `#developpement_frontend_web_mobile` | Lot frontend : tâches web + Flutter, design, i18n |
| `#tests-et-débogage` | Stratégie de test, bugs, CI rouge, post-mortems |
| `#déploiement-et-documentation` | Environnements, releases, runbook, documentation |

Règle : **une décision prise en DM n'existe pas.** Elle est reportée dans le canal concerné.

---

## 9. Environnements & déploiement

| Env | Branche | Base | Déploiement | Données |
|---|---|---|---|---|
| `local` | — | Docker (PG16 + Redis) | `pnpm dev` | Seed + jeu de démo |
| `preview` | toute PR | base éphémère | automatique | Seed |
| `staging` | `main` | base dédiée | automatique au merge | Anonymisées |
| `production` | tag `v*` | base managée + PITR | **manuel, validé par le lead** | Réelles |

- Les migrations tournent **avant** le déploiement applicatif, jamais après.
- Toute migration destructive (drop de colonne, changement de type) suit le motif **expand → migrate → contract** en 3 déploiements. Jamais en une fois.
- Rollback : documenté dans `Code/docs/05-runbook.md`, et **testé une fois** avant le premier déploiement en production.
- Aucun déploiement en production le vendredi après 15h.

---

## 10. Gestion du périmètre et des imprévus

- Un imprévu qui coûte **> 2 h** non prévues → message dans `#a_vue_générale`, arbitrage par le lead. On ne « rattrape » pas en silence sur son temps personnel : ça masque le vrai coût du projet.
- Le périmètre d'un sprint est **figé au démarrage**. Un ajout implique un retrait de valeur équivalente, explicitement acté.
- La dette technique assumée se documente : `// TODO(BE-42): …` + une ligne dans `backlog/TODO.md`. Un TODO sans ID est un mensonge.

---

## 11. Ce qu'on ne fera pas (et pourquoi c'est écrit ici)

- ❌ **Pas de microservices.** Modular monolith jusqu'à preuve chiffrée du contraire.
- ❌ **Pas d'intermédiation de paiement de la prestation.** Cela éviterait un agrément d'établissement de paiement, du séquestre et de la gestion de litiges financiers — hors de portée d'une équipe de deux.
- ❌ **Pas de lancement national au démarrage.** Sahel d'abord (Sousse, Monastir, Mahdia). Diluer le budget marketing sur 24 gouvernorats est l'erreur classique.
- ❌ **Pas de « on le fera propre plus tard »** sur l'i18n, le RTL, la traçabilité des événements et la sécurité des données KYC. Ces quatre sujets ne sont pas rétrofittables sans réécriture.
