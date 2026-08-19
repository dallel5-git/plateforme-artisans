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
| `SO-07` | CODEOWNERS + docs git flow develop/main (ADR-004) + protection des branches | 2026-08-17 | `chore/SO-07-align-main-develop` | Le commit ADR-004 n'avait jamais atteint `main`/`develop` (resté sur la branche source). PR #74 ouverte vers `develop`, CI verte, protection `develop`+`main` déjà appliquée via `gh api` — en attente du clic Merge |

## En binôme

| ID | Tâche | Démarré le | Branche | État / blocage |
|---|---|---|---|---|
| — | _rien en cours_ | | | |

---

## 🔴 Bloqués

| ID | Bloqué par | Depuis | Qui débloque | Action attendue |
|---|---|---|---|---|
| `BE-08` | Compte SMS non ouvert chez le fournisseur | — | Oussama | Adaptateur `console` en attendant — **non bloquant pour le développement**. Lancer la démarche J1. |
| `BE-33` | Question 2 du cadrage non tranchée (moyens de paiement) | 2026-08-15 | Oussama | Rédiger ADR-003 avant S2 |
| `BE-38` | Question 3 du cadrage non tranchée (annuaire ou marketplace) | 2026-08-15 | Oussama | Rédiger un ADR avant S2 — **numéro à revoir : ADR-004 est pris par le git flow `develop`/`main` (2026-08-19), utiliser ADR-005** |

> Une tâche bloquée depuis **plus de 24 h** remonte automatiquement dans `#a_vue_générale` au daily.
