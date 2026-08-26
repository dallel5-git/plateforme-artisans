# DOING — en cours

> ⚠️ **Maximum 2 tâches par développeur.** Si vous en avez 3, vous n'en finissez aucune.
> Mise à jour obligatoire **en fin de chaque journée**.

_Sprint S1 · dernière mise à jour : 2026-08-25_

## DEV-1

| ID | Tâche | Démarré le | Branche | État / blocage |
|---|---|---|---|---|

*(FM-03 — 4/4 PRs mergées #154/#156/#159/#160 — déplacée vers `DONE.md`.)*

## DEV-2

| ID | Tâche | Démarré le | Branche | État / blocage |
|---|---|---|---|---|
| `FM-04` | Widgets du design system : `AppButton`, `AppTextField`, `AppCard`, `ProviderCard`, `RatingStars`, `VerifiedBadge`, `AppSkeleton`, `EmptyState`, `ErrorState`, `OfflineBanner` (#55) | 2026-08-25 | `feat/FM-04a-app-button-card` (mergée #163) → `fix/FM-04a-app-button-shrinkwrap` (PR #167, en attente de revue) → `feat/FM-04b-app-text-field` (en cours) | Décomposée en 5 PRs atomiques, chacune branchée depuis `develop` à jour et ciblée sur `develop` directement (jamais empilées — leçon BE-27/QA-01). `FM-04a` (#163, mergée) : `AppButton` (5 variantes + taille `small`), `AppCard`, écran interne `/_ds-preview` (vitrine de vérification FR/AR sur device, grandit à chaque sous-PR), élargissement CI (`dart format`/`flutter test` couvrent désormais `lib/core/widgets`/`test/core/widgets`). **Vérifié en direct sur device Android réel** (M2101K7AG) une fois `develop` synchronisé après le merge : bug trouvé à l'écran vitrine — `Container(alignment: Alignment.center)` s'étend pour remplir tout l'espace dès qu'un parent à contraintes bornées (`Wrap`) l'entoure, au lieu de s'ajuster à son contenu ; les 6 boutons s'empilaient un par ligne au lieu de se placer côte à côte. Corrigé dans `fix/FM-04a-app-button-shrinkwrap` (PR #167, `ConstrainedBox` + `Padding` au lieu de `Container(alignment:)`, centrage vertical toujours assuré par le `crossAxisAlignment` par défaut du `Row` de contenu) + test de non-régression. FR et AR vérifiés après correctif : boutons côte à côte, contraste correct dans les deux thèmes, miroir RTL correct (`Wrap` respecte la `Directionality` ambiante). `FM-04b` : `AppTextField` en cours (focus/erreur/halo), branchée depuis `develop` sans attendre le merge de #167 (pas de dépendance de code entre les deux). |
| `FM-06` | Accueil client : recherche + grille de catégories, depuis l'API (#35) | 2026-08-26 | `FM-06a` mergée (#165) → `feat/FM-06b-search-home-widgets` (en cours) → `FM-06c` | Dépendance `BE-14` fermée (#52), label `blocked` retiré de #35. Décomposée en 3 PRs atomiques, chacune branchée depuis `develop` à jour et ciblée sur `develop` directement (jamais empilées — leçon BE-27/QA-01/FM-02). `FM-06a` (#165, mergée) : `CatalogRepository`, persistance du gouvernorat choisi, providers Riverpod — voir `DONE.md`. `FM-06b` (en cours, même worktree isolé `plateforme-artisans-fm06`) : `SearchHomeBar` (service + déclencheur de localisation), `CategoryGrid`/`CategoryGridSkeleton` (icônes larges par `iconKey`, teinte `colorHex`, repli si catégorie inconnue), réutilise `AppButton`/`AppCard` de FM-04a. Clés `t.search.*` ajoutées FR/AR (`packages/i18n`), régénérées via `dart run slang` (pas `build_runner build` — ne voit pas les fichiers hors package, cf. commentaire `ci.yml`). CI mobile étendue à `lib/core/api`/`lib/features/search`/`test/features/search` (FM-06a avait ajouté du code sous `lib/core/api` sans étendre la liste explicite de `dart format --set-exit-if-changed`/`flutter test` — corrigé ici). Test verrouillant la grille inversée en arabe (critère d'acceptation FM-06). `FM-06c` (écran `/client`, câblage providers + persistance + skeleton, vérification FR/AR) reste à faire. |

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
