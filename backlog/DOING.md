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
| `BE-24` | `GET /providers/me/stats` — vues, contacts, ratio, série 30 j (US-P-07/US-P-08, issue #28) | 2026-08-22 | `feat/BE-24a-provider-stats-db` → `…b` → `…c` | Démarré : 3 PRs atomiques prévues (db → core/validators → route), même découpage que BE-23/BE-25. Périmètre S1 : `searchImpressions`/`avgSearchPosition` omis (pas de module `search`, dette à tracer) ; contacts agrégés en lecture seule depuis `ContactEvent`, sans toucher au code BE-21 déjà mergé. |
| `BE-26` | ⭐ Contrat : `api:contract` + `mobile:client` (dart-dio) + `web:client` prêt pour S2 | 2026-08-22 | `feat/BE-26a-mobile-client` → `…b-web-client` | PR #130 (mobile:client, CI en cours), PR #132 (web:client, CI en cours) — `dart analyze` : 0 erreur sur le client mobile généré ; types web vérifiés `tsc --strict`. `api:contract`/`--check` déjà livrés et en CI (rien à refaire). Dépendances BE-16/BE-21/BE-22 déplacées en `DONE.md` (déjà mergées, bookkeeping seulement en retard). |

⚠️ **DEV-2 a 3 tâches en DOING (BE-18, BE-24, BE-26)** — au-dessus du maximum de 2 documenté ci-dessus. BE-25 (déjà mergée, #120/#122/#126) déplacée vers `DONE.md` dans ce même commit. BE-18 mérite la même vérification (mergée ou non ?) — à trancher au prochain daily.

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
