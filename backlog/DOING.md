# DOING — en cours

> ⚠️ **Maximum 2 tâches par développeur.** Si vous en avez 3, vous n'en finissez aucune.
> Mise à jour obligatoire **en fin de chaque journée**.

_Sprint S1 · dernière mise à jour : 2026-08-25_

## DEV-1

| ID | Tâche | Démarré le | Branche | État / blocage |
|---|---|---|---|---|
| `FM-03` | i18n `slang` FR/AR, `Directionality` global, miroir des icônes (#54) | 2026-08-25 | `feat/FM-03a-slang-pipeline` (mergée #154) → `feat/FM-03b-locale-persistence` (mergée #156) → `feat/FM-03c-directional-icons` → `FM-03d` | Décomposée en 4 PRs atomiques, chacune branchée depuis `develop` à jour et ciblée sur `develop` directement. `FM-03a` et `FM-03b` mergées. `FM-03c` : chevron `Icons.chevron_right` ajouté en fin des 3 boutons de navigation de `HomeScreen`. Pas de wrapper `AppDirectionalIcon` — vérifié contre la doc Flutter que `matchTextDirection` est un champ de `IconData` (déjà `true` sur `chevron_right`/`arrow_back`…), pas un paramètre du widget `Icon` ; le miroir RTL est donc déjà automatique via la `Directionality` ambiante, sans code supplémentaire. Test de non-régression dans `test/widget_test.dart` (groupe FM-03c) : vérifie `matchTextDirection: true` sur l'icône utilisée + absence/présence du `Transform` de miroir en LTR/RTL. **Vérifié en direct sur device Android réel** : capture FR (chevron `>` à droite) vs capture AR (chevron `<` miroité à gauche) — critère d'acceptation de l'issue #54. |

## DEV-2

| ID | Tâche | Démarré le | Branche | État / blocage |
|---|---|---|---|---|

*(QA-01 — 5/5 PRs mergées #138/#140/#139/#141–#143 — déplacée vers `DONE.md`. BE-18 et BE-24 : bookkeeping de retard déjà corrigé précédemment.)*

> _Note process — workflow QA-01, gardée pour mémoire_ : Oussama a mergé #138/#139/#141 en quelques minutes chacune — GitHub supprime la branche tête au merge, ce qui casse l'empilement de PRs prévu au départ (`…a` → `…b` → …). À partir de QA-01c, chaque sous-tâche a branché depuis `develop` à jour et ciblé `develop` directement. Aussi : la 1ʳᵉ tentative de PR #141 a été squash-mergée, ce qui a fait perdre un commit de bookkeeping poussé après coup — les mises à jour de backlog doivent être incluses **dans le même commit** que le travail, pas en suivi séparé.
>
> **BE-27 a subi la même classe de bug, en pire** (voir ci-dessous) : #135 empilée sur #134 (au lieu de cibler `develop`) a fini par ne jamais atteindre `develop` du tout, alors que les deux PRs s'affichent « MERGED » sur GitHub. Confirme qu'il faut bannir l'empilement de PRs sur ce repo, pas seulement le limiter.

## En binôme

| ID | Tâche | Démarré le | Branche | État / blocage |
|---|---|---|---|---|
| `FM-02` | ⭐ Couche réseau : client Dio généré + intercepteurs (#33) | 2026-08-25 | `BE-26c` (mergée #155) → `feat/FM-02b-fold-generated-client-v2` (PR #162, ouverte) → `FM-02c..g` | Décomposée en sous-PRs atomiques (voir plan). `BE-26c` (tags OpenAPI + schémas nommés) mergée. `FM-02b` (fusion du client généré `lib/core/api/generated/` — package autonome depuis BE-26 — dans la vraie app `sanaya`, livrée par FM-01) : PR #162 ouverte, `flutter analyze`/`dart analyze`/`mobile:client:check` verts, régénéré avec le Dart SDK 3.12.2 épinglé en CI. Reste : `FM-02c` (Dio client factory, exceptions typées) → `FM-02d` (intercepteur auth/refresh single-flight + secure storage) → `FM-02e` (retry) → `FM-02f` (offline) → `FM-02g` (câblage + vérification acceptance). ⚠️ **Note process** : `BE-26c` a été travaillée deux fois en parallèle par deux sessions Claude sans visibilité l'une sur l'autre (une pairée Oussama, une pairée Chayma) — la première PR ouverte (#153, Chayma) a été fermée au profit de la seconde (#155, Oussama), et le travail de fusion qui en dépendait (#157) a été mergé par erreur dans la branche `feat/BE-26c-openapi-tags-schemas` au lieu de `develop` (même bug que BE-27 : PR affichée MERGED, jamais atteint `develop`) — reconstruit proprement en #162. Signal qu'une tâche marquée `binôme` mais attaquée par deux sessions indépendantes sans coordination explicite (qui fait quoi) duplique le travail ; à éviter en confirmant par un message qui prend quelle sous-tâche avant de commencer, pas seulement en la marquant `binôme` dans le backlog. |

*(`BE-27` — GATE 1 exécutée avec succès le 2026-08-24, les 8 appels + vérifications bonus passent :
voir `DONE.md`. Deux bugs trouvés et corrigés dans le script de recette lui-même au passage —
`tooling/scripts/gate1-recette.sh` lisait `.ratingCount` au lieu de `.reviewAggregate.count`
(mauvais chemin jq, donnait toujours `null`/0) et un crash bash sur comparaison arithmétique avec
`null` non protégée. **Le backend (BE-22, agrégat de notes) était correct** — confirmé par
`apps/api/tests/providers-reviews-create.integration.test.ts`, déjà vert. Lot Flutter débloqué.)*

---

## 🔴 Bloqués

| ID | Bloqué par | Depuis | Qui débloque | Action attendue |
|---|---|---|---|---|
| `BE-33` | Question 2 du cadrage non tranchée (moyens de paiement) | 2026-08-15 | Oussama | Rédiger ADR-003 avant S2 |
| `BE-38` | Question 3 du cadrage non tranchée (annuaire ou marketplace) | 2026-08-15 | Oussama | Rédiger un ADR avant S2 — **numéro à revoir : ADR-004 est pris par le git flow `develop`/`main` (2026-08-19), utiliser ADR-005** |

> Une tâche bloquée depuis **plus de 24 h** remonte automatiquement dans `#a_vue_générale` au daily.
