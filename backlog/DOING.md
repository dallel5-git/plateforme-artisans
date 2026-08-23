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
| `QA-01` | Tests d'intégration API sur base jetable (routes qui écrivent) | 2026-08-23 | `test/QA-01a-…`/`…b`/`…c`/`…d` (mergées) → `test/QA-01e-onboarding-integration-tests` | 5/5 PRs atomiques, chacune ciblant `develop` directement (voir note ci-dessous). **QA-01a** (absorbe `BE-02b`), **QA-01b** (auth), **QA-01c** (contact-events), **QA-01d** (reviews + 🔒 trigger `prevent_self_review` + concurrence `ratingAvg`) — **mergées** (#138/#140, #139, #141, #142). **QA-01e (onboarding, dernière sous-tâche)** : PR ouverte — `POST /providers/me` (promotion CLIENT→PROVIDER, US-P-01) + 409 profil déjà existant ; `PATCH /providers/me` (recalcul `completionScore`) + 403 `PROVIDER_PROFILE_INCOMPLETE` sous 60 % ; `PUT /providers/me/categories` et `PUT /providers/me/coverage-areas` (remplacement de set, `completionScore` recalculé — cas d'erreur déjà couverts par les tests purs existants, non dupliqués ici). **Périmètre volontairement réduit** : `POST`/`DELETE /providers/me/portfolio` (BE-20d) exclus de QA-01e — nécessite un fixture `MediaAsset` `APPROVED`, complexité disproportionnée par rapport aux 4 routes déjà couvertes ; ligne ajoutée au backlog non planifié ci-dessous. |
| _note_ | _Workflow QA-01_ | | | Oussama a mergé #138/#139/#141 en quelques minutes chacune — GitHub supprime la branche tête au merge, ce qui casse l'empilement de PRs prévu au départ (`…a` → `…b` → …). À partir de QA-01c, chaque sous-tâche branche depuis `develop` à jour et cible `develop` directement. Aussi : la 1ʳᵉ tentative de PR #141 a été squash-mergée, ce qui a fait perdre un commit de bookkeeping poussé après coup — les mises à jour de backlog doivent maintenant être incluses **dans le même commit** que le travail, pas en suivi séparé. |

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
