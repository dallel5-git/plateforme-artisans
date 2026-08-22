# DOING — en cours

> ⚠️ **Maximum 2 tâches par développeur.** Si vous en avez 3, vous n'en finissez aucune.
> Mise à jour obligatoire **en fin de chaque journée**.

_Sprint S1 · dernière mise à jour : 2026-08-22_

## DEV-1

| ID | Tâche | Démarré le | Branche | État / blocage |
|---|---|---|---|---|
| `BE-12` | RBAC centralisé `packages/core/policies` + preHandlers `requireAuth`/`requireRole` | 2026-08-21 | `feat/BE-12-rbac` | PR #87 (CI en cours). `requireAuth` renommé depuis `authenticate` (BE-10a), vérifié en curl sans régression. |

## DEV-2

| ID | Tâche | Démarré le | Branche | État / blocage |
|---|---|---|---|---|
| `BE-18` | `GET /providers/:slug/reviews` paginé | 2026-08-21 | `feat/BE-18c-provider-reviews-route` | 3 PRs atomiques (core → repository → route, découpage BE-16a/b/c) : #103 (core, mergée), #104 (repository, CI verte), #105 (route + contrat, CI en cours). |
| `BE-20` | Upload de médias : URL pré-signées et variantes WebP (issue #24) — 4 PRs atomiques empilées | 2026-08-22 | `feat/BE-20a-storage-infra` → `…b` → `…c` → `…d` | 4/4 sous-tâches codées, 4 PRs ouvertes empilées : #106 (a, CI verte) ← #110 (b) ← #112 (c) ← #113 (d). b/c/d n'ont pas de CI automatique tant que leur branche de base n'est pas mergée (le workflow ne CI que les PR ciblant `develop`/`main` — même comportement déjà observé pour BE-19b/c/d) ; vérifiées localement (`typecheck`/`lint`/`test`/`format`/`api:contract --check`, tous verts). En attente de revue/merge par Oussama, dans l'ordre a→b→c→d. |

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
