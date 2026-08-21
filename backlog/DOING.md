# DOING — en cours

> ⚠️ **Maximum 2 tâches par développeur.** Si vous en avez 3, vous n'en finissez aucune.
> Mise à jour obligatoire **en fin de chaque journée**.

_Sprint S1 · dernière mise à jour : 2026-08-21_

## DEV-1

| ID | Tâche | Démarré le | Branche | État / blocage |
|---|---|---|---|---|
| `BE-12` | RBAC centralisé `packages/core/policies` + preHandlers `requireAuth`/`requireRole` | 2026-08-21 | `feat/BE-12-rbac` | PR #87 (CI en cours). `requireAuth` renommé depuis `authenticate` (BE-10a), vérifié en curl sans régression. ⚠️ ligne à vérifier : PR #87 semble déjà mergée sur `develop`, à confirmer et déplacer vers DONE.md. |
| `BE-16` | `GET /v1/providers/search` — filtres + tri (score calculé) + pagination curseur | 2026-08-21 | `feat/BE-16c-search-route` | 3 PRs atomiques : #94 (scoring/pagination, mergée), #95 (repository, mergée), #96 (route, CI en cours) — clôt #53 une fois #96 mergée. GATE 1 vérifié manuellement (≥5 items triés, <200ms, pagination sans doublon/trou). |

## DEV-2

| ID | Tâche | Démarré le | Branche | État / blocage |
|---|---|---|---|---|
| — | _rien en cours (BE-14a–d mergées, #88–#91)_ | | | |

## En binôme

| ID | Tâche | Démarré le | Branche | État / blocage |
|---|---|---|---|---|
| — | _rien en cours (BE-15 mergée, #92)_ | | | |

---

## 🔴 Bloqués

| ID | Bloqué par | Depuis | Qui débloque | Action attendue |
|---|---|---|---|---|
| `BE-33` | Question 2 du cadrage non tranchée (moyens de paiement) | 2026-08-15 | Oussama | Rédiger ADR-003 avant S2 |
| `BE-38` | Question 3 du cadrage non tranchée (annuaire ou marketplace) | 2026-08-15 | Oussama | Rédiger un ADR avant S2 — **numéro à revoir : ADR-004 est pris par le git flow `develop`/`main` (2026-08-19), utiliser ADR-005** |

> Une tâche bloquée depuis **plus de 24 h** remonte automatiquement dans `#a_vue_générale` au daily.
