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
| `BE-23` | `POST /v1/profile-views` + `DailyProviderStat` (dédup 24 h, issue #27) | 2026-08-22 | `feat/BE-23a-profile-view-db` → `…b` → `…c` | Démarré : 3 PRs atomiques prévues (db → core/validators → route). `DailyProviderStat` n'existe pas encore en base — nouveau modèle + migration manuelle (pas de Postgres local). |
| `BE-25` | Favoris (`PUT`/`DELETE`/`GET /favorites`) — 3 PRs atomiques (core → repository/pagination → route) | 2026-08-22 | `feat/BE-25a-favorites-core` → `…b-favorites-pagination` → `…c-favorites-route` | **Les 3 PRs (#120/#122/#126) sont mergées sur `develop`** (confirmé par `git log` — cette ligne était en retard, à déplacer vers `DONE.md`). |
| `BE-26` | ⭐ Contrat : `api:contract` + `mobile:client` (dart-dio) + `web:client` prêt pour S2 | 2026-08-22 | `feat/BE-26a-mobile-client` → `…b-web-client` | Démarré. `api:contract`/`--check` déjà livrés et en CI (rien à refaire) — reste `mobile:client` (client `dart-dio` autonome, vérifié par `dart analyze` isolément — `apps/mobile` n'est pas encore un vrai projet Flutter, FM-01 pas démarré) et `web:client` (openapi-typescript, léger). Dépendances BE-16/BE-21/BE-22 déplacées en `DONE.md` (déjà mergées, bookkeeping seulement en retard). |

⚠️ **DEV-2 a maintenant 4 tâches en DOING (BE-18, BE-23, BE-25, BE-26)** — bien au-dessus du maximum de 2. BE-25 est en réalité déjà mergée (voir ci-dessus, juste pas encore déplacée) ; BE-18 mérite la même vérification. À arbitrer au prochain daily — cette liste a besoin d'un vrai nettoyage, pas seulement d'un ajout de plus.

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
