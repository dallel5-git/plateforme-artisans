# DOING — en cours

> ⚠️ **Maximum 2 tâches par développeur.** Si vous en avez 3, vous n'en finissez aucune.
> Mise à jour obligatoire **en fin de chaque journée**.

_Sprint S1 · dernière mise à jour : 2026-08-17_

## DEV-1

| ID | Tâche | Démarré le | Branche | État / blocage |
|---|---|---|---|---|
| `BE-09` | JWT : access court + refresh rotatif avec détection de rejeu | 2026-08-19 | `feat/BE-09-jwt` | PR #79 (CI verte) empilée sur PR #78 (CI verte aussi) — merger #78 avant #79 |
| `BE-13` | Erreurs normalisées + codes + `requestId` — prérequis bloquant de BE-10 | 2026-08-19 | `feat/BE-13-erreurs-normalisees` | PR #80 (CI en cours) — empilée sur `feat/BE-09-jwt` (PR #79, non mergée) |
| `BE-10` | Routes auth — découpée en 4 PRs atomiques (10a `me`, 10b `otp/request`, 10c `otp/verify`, 10d `refresh`+`logout`) | 2026-08-19 | `feat/BE-10a-auth-me` (+ suivantes) | 10a : PR #81 (CI en cours) — empilée sur `feat/BE-13-erreurs-normalisees` (PR #80, non mergée). *Note : 3 tâches DEV-1 en DOING (limite normale 2), mais BE-09/BE-13/BE-10 forment une seule pile de PRs empilées en attente de merge, pas 3 chantiers actifs en parallèle.* |

## DEV-2

| ID | Tâche | Démarré le | Branche | État / blocage |
|---|---|---|---|---|
| — | _rien en cours_ | | | |

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
