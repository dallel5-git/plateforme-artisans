# DOING — en cours

> ⚠️ **Maximum 2 tâches par développeur.** Si vous en avez 3, vous n'en finissez aucune.
> Mise à jour obligatoire **en fin de chaque journée**.

_Sprint S1 · dernière mise à jour : 2026-08-21_

## DEV-1

| ID | Tâche | Démarré le | Branche | État / blocage |
|---|---|---|---|---|
| `BE-12` | RBAC centralisé `packages/core/policies` + preHandlers `requireAuth`/`requireRole` | 2026-08-21 | `feat/BE-12-rbac` | PR #87 (CI en cours). `requireAuth` renommé depuis `authenticate` (BE-10a), vérifié en curl sans régression. |

## DEV-2

| ID | Tâche | Démarré le | Branche | État / blocage |
|---|---|---|---|---|
| `BE-14a` | Cache-aside Redis générique (`getOrSetCache`) — infra, sans surface API | 2026-08-21 | `feat/BE-14a-cache-infra` | PR #88 ouverte (CI en cours) |
| `BE-14b` | `GET /v1/categories` — arbre complet FR/AR, une seule requête, exception P5 documentée | 2026-08-21 | `feat/BE-14b-categories` | PR #89 ouverte (empilée sur #88, CI en cours) |
| `BE-14c` | `GET /v1/governorates` + `/:id/delegations` — 404 si id inconnu | 2026-08-21 | `feat/BE-14c-governorates` | PR #90 ouverte (empilée sur #88/#89, CI en cours) |
| `BE-14d` | Invalidation cache catalogue au seed (`tooling/scripts/flush-catalog-cache.ts`) | 2026-08-21 | `feat/BE-14d-seed-cache-invalidation` | PR #91 ouverte (empilée sur #88/#89/#90, CI en cours) — **dernière sous-tâche, clôt #52 une fois les 4 mergées dans l'ordre** |
| `BE-19a` | Onboarding artisan — `packages/core` : fonction pure `calculateCompletionScore` + tests | 2026-08-21 | `feat/BE-19a-completion-score` | PR #93 ouverte (CI en cours) — première des 4 sous-tâches de BE-19 (issue #23) |
| `BE-19b` | Onboarding artisan — `POST`/`PATCH /v1/providers/me` : création, promotion de rôle, complétude, garde de publication | 2026-08-21 | `feat/BE-19b-provider-me-profile` | PR #97 ouverte (empilée sur #93, CI en cours) |
| `BE-19c` | Onboarding artisan — `PUT /v1/providers/me/categories` : remplacement atomique, `isPrimary`, quota FREE | 2026-08-21 | `feat/BE-19c-provider-categories` | PR #98 ouverte (empilée sur #97, CI en cours) |
| `BE-19d` | Onboarding artisan — `PUT /v1/providers/me/coverage-areas` : remplacement atomique, quota FREE | 2026-08-21 | `feat/BE-19d-provider-coverage-areas` | PR #99 ouverte (empilée sur #98, CI en cours) — **dernière sous-tâche, clôt #23 une fois les 4 mergées dans l'ordre** |

## En binôme

| ID | Tâche | Démarré le | Branche | État / blocage |
|---|---|---|---|---|
| — | _rien en cours_ | | | |

---

## 🔴 Bloqués

| ID | Bloqué par | Depuis | Qui débloque | Action attendue |
|---|---|---|---|---|
| `BE-33` | Question 2 du cadrage non tranchée (moyens de paiement) | 2026-08-15 | Oussama | Rédiger ADR-003 avant S2 |
| `BE-38` | Question 3 du cadrage non tranchée (annuaire ou marketplace) | 2026-08-15 | Oussama | Rédiger un ADR avant S2 — **numéro à revoir : ADR-004 est pris par le git flow `develop`/`main` (2026-08-19), utiliser ADR-005** |

> Une tâche bloquée depuis **plus de 24 h** remonte automatiquement dans `#a_vue_générale` au daily.
