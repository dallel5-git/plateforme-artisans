# DOING — en cours

> ⚠️ **Maximum 2 tâches par développeur.** Si vous en avez 3, vous n'en finissez aucune.
> Mise à jour obligatoire **en fin de chaque journée**.

_Sprint S1 · dernière mise à jour : 2026-08-23_

## DEV-1

| ID | Tâche | Démarré le | Branche | État / blocage |
|---|---|---|---|---|

## DEV-2

| ID | Tâche | Démarré le | Branche | État / blocage |
|---|---|---|---|---|
| `QA-01` | Tests d'intégration API sur base jetable (routes qui écrivent) | 2026-08-23 | `test/QA-01a-db-integration-harness` → `…b` → `…c` → `…d` → `…e` | 5 PRs atomiques prévues, empilées (chaque PR cible la précédente, comme BE-19a→b→c→d). **QA-01a absorbe `BE-02b`** : PR #138 ouverte (harnais `@repo/testing/db-test-utils` + `@repo/db/testing`, correction CI `migrate:deploy` manquant + `DIRECT_DATABASE_URL`, ordonnancement Turborepo `@repo/db#test` → `@repo/testing#test` → `api#test`). **QA-01b (auth)** : PR #139 ouverte sur #138 — `otp/request` (SIGNUP/LOGIN, rate-limit 5/h numéro+IP), `otp/verify` (création de compte, code consommé/faux/expiré, 3 tentatives max), `refresh`/`logout` (rotation, 🔒 rejeu → révocation de la famille, idempotence). Reste : QA-01c (contact-events), QA-01d (reviews + trigger `prevent_self_review` + concurrence `ratingAvg`), QA-01e (onboarding = `providers/me*`, BE-19). Arbitrage Oussama 2026-08-23 : absorption de BE-02b actée. |

*(BE-18 et BE-24 : bookkeeping de retard corrigé dans ce même commit — les deux étaient déjà mergées sur `develop`, déplacées vers `DONE.md`.)*

## En binôme

| ID | Tâche | Démarré le | Branche | État / blocage |
|---|---|---|---|---|
| `BE-15` | ⭐ Ranking — géo, bayésien (C=8), confiance, complétude, réactivité, plan, pénalités, rotation ±2 % | 2026-08-21 | `feat/BE-15-ranking-algorithm` | Mergée (PR #92, `dd2af2d`) — 🔒 garde-fou ADR-002 vert. Ligne à déplacer vers `DONE.md`. |
| `BE-27` | 🚦 GATE 1 — recette backend en `curl` (8 appels, §6.4) | 2026-08-23 | `chore/BE-27a-gate1-seed-fixture` → `…b-gate1-script` | 2 PRs atomiques ouvertes : #134 (fixture de seed — un contact déjà éligible >12h pour l'étape 7, sinon `403 REVIEW_REQUIRES_CONTACT` garanti), #135 (script `tooling/scripts/gate1-recette.sh`, empilé sur #134). **Bloqué avant clôture** : pas de Docker disponible dans cet environnement pour lancer `db:up`/l'API et exécuter réellement les 8 appels + `api:contract:check` + `mobile:client:check` + `pnpm test` — à faire par un développeur avec Docker local avant de couper la ligne vers `DONE.md`. Ne pas démarrer le lot Flutter avant ce vert. |

---

## 🔴 Bloqués

| ID | Bloqué par | Depuis | Qui débloque | Action attendue |
|---|---|---|---|---|
| `BE-33` | Question 2 du cadrage non tranchée (moyens de paiement) | 2026-08-15 | Oussama | Rédiger ADR-003 avant S2 |
| `BE-38` | Question 3 du cadrage non tranchée (annuaire ou marketplace) | 2026-08-15 | Oussama | Rédiger un ADR avant S2 — **numéro à revoir : ADR-004 est pris par le git flow `develop`/`main` (2026-08-19), utiliser ADR-005** |

> Une tâche bloquée depuis **plus de 24 h** remonte automatiquement dans `#a_vue_générale` au daily.
