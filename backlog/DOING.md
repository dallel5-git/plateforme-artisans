# DOING — en cours

> ⚠️ **Maximum 2 tâches par développeur.** Si vous en avez 3, vous n'en finissez aucune.
> Mise à jour obligatoire **en fin de chaque journée**.

_Sprint S1 · dernière mise à jour : 2026-08-17_

## DEV-1

| ID | Tâche | Démarré le | Branche | État / blocage |
|---|---|---|---|---|
| — | _rien en cours_ | | | |

## DEV-2

| ID | Tâche | Démarré le | Branche | État / blocage |
|---|---|---|---|---|
| `SO-07` | Protection de `main`, CODEOWNERS, modèle de PR | 2026-08-17 | `chore/SO-07-branch-protection-codeowners` | En revue (PR #66) — `gh api` bloqué sur SO-06 → main |
| `BE-01` | Schéma Prisma — sous-ensemble MVP (19 modèles) | 2026-08-18 | `feat/BE-01-schema-prisma-mvp` | Repris par Oussama, Chayma absente. PR #68 ouverte (non mergée), Chayma en reviewer (CODEOWNERS) dès son retour. |
| `BE-02` | Migration SQL manuelle : contraintes et index essentiels | 2026-08-18 | `feat/BE-02-migration-sql-contraintes` (empilée sur BE-01) | Repris par Oussama, Chayma absente. PR #69 ouverte (non mergée). |
| `BE-03` | Seed du référentiel : gouvernorats, délégations du Sahel, catégories FR/AR | 2026-08-18 | `feat/BE-03-seed-referentiel` (empilée sur BE-02) | Repris par Oussama, Chayma absente. PR #70 ouverte (non mergée). |
| `BE-04` | Seed de démonstration : 30 artisans du Sahel | 2026-08-18 | `feat/BE-04-seed-demo-artisans` (empilée sur BE-03) | Repris par Oussama, Chayma absente. PR #71 ouverte (non mergée). |
| `BE-05` | Couche repositories : la seule qui parle à Prisma | 2026-08-19 | `feat/BE-05-repositories` (empilée sur BE-04) | Repris par Oussama, Chayma absente. 12 repositories (1 par agrégat DDD), pagination par curseur générique (keyset, stable à l'insertion — vérifié manuellement), helper de transaction, `select` explicite partout (aucun champ sensible/téléphone renvoyé hors flux ContactEvent). Règle ESLint `no-restricted-imports` sur `@prisma/client` ajoutée à `packages/eslint-config/base.js`, réautorisée uniquement dans `packages/db` — vérifiée en la faisant volontairement échouer puis en annulant. 17 tests Vitest purs sur la pagination (premier package du repo à introduire `vitest`). PR à ouvrir sur `feat/BE-04-seed-demo-artisans` en attendant les merges en amont. |

## En binôme

| ID | Tâche | Démarré le | Branche | État / blocage |
|---|---|---|---|---|
| — | _rien en cours_ | | | |

---

## 🔴 Bloqués

| ID | Bloqué par | Depuis | Qui débloque | Action attendue |
|---|---|---|---|---|
| `SO-07` | SO-06 pas encore sur `main` → le workflow CI absent → `gh api` branch-protection échouera | 2026-08-17 | Merger PR #65 (SO-06) | Une fois SO-06 mergé, lancer `gh api repos/dallel5-git/plateforme-artisans/branches/main/protection ...` |
| `BE-08` | Compte SMS non ouvert chez le fournisseur | — | Oussama | Adaptateur `console` en attendant — **non bloquant pour le développement**. Lancer la démarche J1. |
| `BE-33` | Question 2 du cadrage non tranchée (moyens de paiement) | 2026-08-15 | Oussama | Rédiger ADR-003 avant S2 |
| `BE-38` | Question 3 du cadrage non tranchée (annuaire ou marketplace) | 2026-08-15 | Oussama | Rédiger ADR-004 avant S2 |

> Une tâche bloquée depuis **plus de 24 h** remonte automatiquement dans `#a_vue_générale` au daily.
