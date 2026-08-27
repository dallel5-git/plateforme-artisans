# DOING — en cours

> ⚠️ **Maximum 2 tâches par développeur.** Si vous en avez 3, vous n'en finissez aucune.
> Mise à jour obligatoire **en fin de chaque journée**.

_Sprint S1 · dernière mise à jour : 2026-08-27_

## DEV-1

| ID | Tâche | Démarré le | Branche | État / blocage |
|---|---|---|---|---|

*(FM-03 — 4/4 PRs mergées #154/#156/#159/#160 — déplacée vers `DONE.md`.)*

## DEV-2

| ID | Tâche | Démarré le | Branche | État / blocage |
|---|---|---|---|---|
| `FM-04` | Widgets du design system : `AppButton`, `AppTextField`, `AppCard`, `ProviderCard`, `RatingStars`, `VerifiedBadge`, `AppSkeleton`, `EmptyState`, `ErrorState`, `OfflineBanner` (#55) | 2026-08-25 | `feat/FM-04a-app-button-card` (mergée #163) → `fix/FM-04a-app-button-shrinkwrap` (mergée #167) → `feat/FM-04b-app-text-field` (en attente de revue) → `feat/FM-04c-rating-stars-verified-badge` (en attente de revue) | Décomposée en 5 PRs atomiques, chacune branchée depuis `develop` à jour et ciblée sur `develop` directement (jamais empilées — leçon BE-27/QA-01). `FM-04a` (#163, mergée) : `AppButton` (5 variantes + taille `small`), `AppCard`, écran interne `/_ds-preview`. Bug trouvé sur device réel après merge (`Container(alignment:)` s'étend dans un `Wrap`) → corrigé dans `fix/FM-04a-app-button-shrinkwrap` (#167, mergée) + test de non-régression. `FM-04b` (PR #168) : `AppTextField` (label, hint, erreur, focus avec halo `accentSubtle`, cible tactile ≥48 px via `ConstrainedBox`). `FM-04c` (PR #169) : `RatingStars` + `VerifiedBadge` (ADR-002 — aucun paramètre, test 🔒 non-régression source-scan), résout au passage `SO-09` (CI élargie à `lib/core/i18n/{format,locale_persistence}.dart`). `flutter analyze`/`flutter test` verts (35/35). **Device Android déconnecté en cours de session** : pas de capture FR/AR pour #168/#169 — à faire dès qu'il est de nouveau disponible. |

*(FM-06 — 3/3 PRs mergées #165/#166/#170 — déplacée vers `DONE.md`. `FM-06b` avait un conflit `backlog/DOING.md` avec `fix/FM-04a-app-button-shrinkwrap` (#167, résolu par rebase) et un vrai bug CI (`dart format --set-exit-if-changed lib/core/api` en entier balayait `lib/core/api/generated/`, reformaté par un SDK Dart local différent de celui épinglé — corrigé en ciblant `lib/core/api/api_client_provider.dart` précisément).)*

*(FM-09 — 3/3 PRs mergées #172/#175/#177 — déplacée vers `DONE.md`. Le spec pré-écrit `test/features/contact/contact_flow_test.dart` (FM-09/FM-02) s'est révélé imprécis face au vrai contrat (`phone` et non `revealedPhone`, `whatsappMessage` déjà localisé côté serveur) — remplacé en `FM-09b` par une version conforme. Pas encore d'écran pour embarquer `ContactButtons` (FM-08 non mergé) — vérifié par tests widget seuls, à câbler dans une fiche prestataire dès que FM-08 livre.)*
| `FM-08` | Fiche artisan : galerie, tarifs, zones, avis, badge (#37) | 2026-08-27 | `feat/FM-08a-provider-profile-data-layer` (en cours) → `FM-08b..d` | Dépendance `BE-17` fermée. Décomposée en 4 PRs atomiques, branchées depuis `develop` et ciblant `develop` directement (jamais empilées). `FM-08a` (couche data) : `ProviderProfileRepository` (`/v1/providers/:slug`, `/v1/providers/:slug/reviews` via le client généré BE-26, aucun `Dio` à la main), `cached_network_image: ^3.4.1` ajouté avec justification (#37), providers Riverpod (`providerProfileProvider`, `providerReviewsProvider` avec `ReviewsState`/`ProviderReviewsNotifier` gérant la pagination par curseur P5). Traductions FR/AR `profile.*` dans `provider.json`, slang régénéré. CI mobile étendue à `lib/features/provider_profile` et `test/features/provider_profile`. `flutter analyze` et `flutter test` verts. `FM-08b` (widgets présentation) → `FM-08c` (écran `ProviderProfileScreen` + routing) → `FM-08d` (i18n final + tracking de vue P9). |

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
