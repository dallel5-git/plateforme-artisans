# DOING — en cours

> ⚠️ **Maximum 2 tâches par développeur.** Si vous en avez 3, vous n'en finissez aucune.
> Mise à jour obligatoire **en fin de chaque journée**.

_Sprint S1 · dernière mise à jour : 2026-08-22_

## DEV-1

| ID | Tâche | Démarré le | Branche | État / blocage |
|---|---|---|---|---|

## DEV-2

| ID | Tâche | Démarré le | Branche | État / blocage |
|---|---|---|---|---|
| `BE-18` | `GET /providers/:slug/reviews` paginé | 2026-08-21 | `feat/BE-18c-provider-reviews-route` | 3 PRs atomiques (core → repository → route, découpage BE-16a/b/c) : #103 (core, mergée), #104 (repository, CI verte), #105 (route + contrat, CI en cours). |
| `BE-25` | Favoris (`PUT`/`DELETE`/`GET /favorites`) — 3 PRs atomiques (core → repository/pagination → route) | 2026-08-22 | `feat/BE-25a-favorites-core` → `…b-favorites-pagination` → `…c-favorites-route` | 3/3 sous-tâches codées : #120 (core, CI en cours) ← #122 (repository/pagination, CI en cours) ← #126 (route + contrat, CI en cours). Vérifié manuellement en local contre le seed de démo (`pnpm dev` + `curl` : ajout idempotent, liste paginée sur 3 favoris avec `nextCursor` stable sur 2 pages, retrait idempotent, 404 sur `providerId` inexistant, 401 sans token) — voir description de la PR #126. En attente de revue/merge par Oussama, dans l'ordre a→b→c. |

## En binôme

| ID | Tâche | Démarré le | Branche | État / blocage |
|---|---|---|---|---|
| `BE-15` | ⭐ Ranking — géo, bayésien (C=8), confiance, complétude, réactivité, plan, pénalités, rotation ±2 % | 2026-08-21 | `feat/BE-15-ranking-algorithm` | PR #92 ouverte (CI en cours). 18/18 tests pré-écrits + 3 additifs, 🔒 garde-fou ADR-002 vert. |

---

## 🔴 Bloqués

| ID | Bloqué par | Depuis | Qui débloque | Action attendue |
|---|---|---|---|---|
| `BE-33` | Question 2 du cadrage non tranchée (moyens de paiement) | 2026-08-15 | Oussama | Rédiger ADR-003 avant S2 |
| `BE-38` | Question 3 du cadrage non tranchée (annuaire ou marketplace) | 2026-08-15 | Oussama | Rédiger un ADR avant S2 — **numéro à revoir : ADR-004 est pris par le git flow `develop`/`main` (2026-08-19), utiliser ADR-005** |

> Une tâche bloquée depuis **plus de 24 h** remonte automatiquement dans `#a_vue_générale` au daily.
