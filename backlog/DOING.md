# DOING — en cours

> ⚠️ **Maximum 2 tâches par développeur.** Si vous en avez 3, vous n'en finissez aucune.
> Mise à jour obligatoire **en fin de chaque journée**.

_Sprint S1 · dernière mise à jour : 2026-08-27_

## DEV-1

| ID | Tâche | Démarré le | Branche | État / blocage |
|---|---|---|---|---|
| `FM-13` | Favoris et réglages : liste des favoris, réglages (langue, déconnexion, mentions légales) (#56) | 2026-08-27 | `feat/FM-13a-favorites-data-layer` → `feat/FM-13b-favorites-screen` → `feat/FM-13c-settings-screen` | Décomposée en 3 PRs atomiques, branchées depuis `develop` à jour. `FM-13a` : Catalogues i18n FR/AR (`favorites`, `settings`, `legal`), `FavoritesRepository`, `FavoritesListNotifier` (Riverpod AsyncNotifier avec mise à jour optimiste et gestion d'erreurs), `AuthRepository` (déconnexion), `pnpm i18n:check` vert, `flutter analyze` et `flutter test` verts (99/99). |


## DEV-2

| ID | Tâche | Démarré le | Branche | État / blocage |
|---|---|---|---|---|
| `FM-04` | Widgets du design system : `AppButton`, `AppTextField`, `AppCard`, `ProviderCard`, `RatingStars`, `VerifiedBadge`, `AppSkeleton`, `EmptyState`, `ErrorState`, `OfflineBanner` (#55) | 2026-08-25 | `feat/FM-04a-app-button-card` (mergée #163) → `fix/FM-04a-app-button-shrinkwrap` (mergée #167) → `feat/FM-04b-app-text-field` (en attente de revue) → `feat/FM-04c-rating-stars-verified-badge` (en attente de revue) | Décomposée en 5 PRs atomiques, chacune branchée depuis `develop` à jour et ciblée sur `develop` directement (jamais empilées — leçon BE-27/QA-01). `FM-04a` (#163, mergée) : `AppButton` (5 variantes + taille `small`), `AppCard`, écran interne `/_ds-preview`. Bug trouvé sur device réel après merge (`Container(alignment:)` s'étend dans un `Wrap`) → corrigé dans `fix/FM-04a-app-button-shrinkwrap` (#167, mergée) + test de non-régression. `FM-04b` (PR #168) : `AppTextField` (label, hint, erreur, focus avec halo `accentSubtle`, cible tactile ≥48 px via `ConstrainedBox`). `FM-04c` (PR #169) : `RatingStars` + `VerifiedBadge` (ADR-002 — aucun paramètre, test 🔒 non-régression source-scan), résout au passage `SO-09` (CI élargie à `lib/core/i18n/{format,locale_persistence}.dart`). `flutter analyze`/`flutter test` verts (35/35). **Device Android déconnecté en cours de session** : pas de capture FR/AR pour #168/#169 — à faire dès qu'il est de nouveau disponible. |

*(FM-06 — 3/3 PRs mergées #165/#166/#170 — déplacée vers `DONE.md`. `FM-06b` avait un conflit `backlog/DOING.md` avec `fix/FM-04a-app-button-shrinkwrap` (#167, résolu par rebase) et un vrai bug CI (`dart format --set-exit-if-changed lib/core/api` en entier balayait `lib/core/api/generated/`, reformaté par un SDK Dart local différent de celui épinglé — corrigé en ciblant `lib/core/api/api_client_provider.dart` précisément).)*

*(FM-09 — 3/3 PRs mergées #172/#175/#177 — déplacée vers `DONE.md`. Le spec pré-écrit `test/features/contact/contact_flow_test.dart` (FM-09/FM-02) s'est révélé imprécis face au vrai contrat (`phone` et non `revealedPhone`, `whatsappMessage` déjà localisé côté serveur) — remplacé en `FM-09b` par une version conforme. Pas encore d'écran pour embarquer `ContactButtons` (FM-08 non mergé) — vérifié par tests widget seuls, à câbler dans une fiche prestataire dès que FM-08 livre.)*
| `FM-08` | Fiche artisan : galerie, tarifs, zones, avis, badge (#37) | 2026-08-27 | `feat/FM-08a-provider-profile-data-layer` (PR #173, en attente de revue) → `feat/FM-08b-provider-profile-widgets` (PR #174, en attente de revue) → `feat/FM-08c-provider-profile-screen` (PR #176, en attente de revue) → `feat/FM-08d-provider-profile-polish-i18n` (PR #178, en attente de revue) | Dépendance `BE-17` fermée. Décomposée en 4 PRs atomiques, branchées depuis `develop` et ciblant `develop` directement (jamais empilées). `FM-08a` (#173, couche data) : `ProviderProfileRepository`, `cached_network_image`, providers Riverpod, traductions FR/AR, CI étendue. `FM-08b` (#174, widgets présentation) : `ProviderGallery`, `OfferingCard`, `CoverageAreaChip`, `AvailabilityChip`, `ReviewTile`, `RatingStars`, `VerifiedBadge`. `FM-08c` (#176, écran `ProviderProfileScreen` + routing) : route `/providers/:slug`, écran complet avec chargement skeleton, gestion d'erreur avec réessai, affichage galerie / prestations / zones / avis avec pagination curseur, barre fixe de contact basse avec boutons Appeler et WhatsApp (point d'extension FM-09). `FM-08d` (#178, polish i18n & RTL) : validation de la parité i18n FR/AR, tests complets sous locale arabe RTL, intégration design system et vérification CI globale. `flutter analyze` et `flutter test` verts (80/80). |
| `FM-11` | Espace Pro : assistant d'onboarding + `completionScore` en direct (#40) | 2026-08-27 | `feat/FM-11a-onboarding-data-layer` (en cours) → `FM-11b..d` | BE-19 fermée (dépendance levée). Décomposée en 4 PRs atomiques depuis `develop` ciblant `develop`. `FM-11a` (en cours) : `OnboardingRepository` (4 méthodes : createProfile/updateProfile/setCategories/setCoverageAreas via client généré), tests repository (10 cas), CI étendue à `lib/features/onboarding` et `test/features/onboarding`. `flutter analyze`/`flutter test` en cours de vérification. |

*(QA-01 — 5/5 PRs mergées #138/#140/#139/#141–#143 — déplacée vers `DONE.md`. BE-18 et BE-24 : bookkeeping de retard déjà corrigé précédemment.)*

> _Note process — workflow QA-01, gardée pour mémoire_ : Oussama a mergé #138/#139/#141 en quelques minutes chacune — GitHub supprime la branche tête au merge, ce qui casse l'empilement de PRs prévu au départ (`…a` → `…b` → …). À partir de QA-01c, chaque sous-tâche a branché depuis `develop` à jour et ciblé `develop` directement. Aussi : la 1ʳᵉ tentative de PR #141 a été squash-mergée, ce qui a fait perdre un commit de bookkeeping poussé après coup — les mises à jour de backlog doivent être incluses **dans le même commit** que le travail, pas en suivi séparé.
>
> **BE-27 a subi la même classe de bug, en pire** (voir ci-dessous) : #135 empilée sur #134 (au lieu de cibler `develop`) a fini par ne jamais atteindre `develop` du tout, alors que les deux PRs s'affichent « MERGED » sur GitHub. Confirme qu'il faut bannir l'empilement de PRs sur ce repo, pas seulement le limiter.

## En binôme

| ID | Tâche | Démarré le | Branche | État / blocage |
|---|---|---|---|---|
| `FM-02` | ⭐ Couche réseau : client Dio généré + intercepteurs (#33) | 2026-08-25 | `BE-26c` (mergée #155) → `feat/FM-02b-fold-generated-client-v2` (mergée #162) → `feat/FM-02c-api-client-exceptions` (mergée #164) → `feat/FM-02d-auth-refresh-interceptor` (ouverte) → `FM-02e..g` | Décomposée en sous-PRs atomiques. `BE-26c`/`FM-02b`/`FM-02c` mergées (contrat, fusion du client généré, `buildApiClient()`+exceptions typées+`ErrorMappingInterceptor`). ⚠️ Le spec pré-écrit `contact_flow_test.dart` (groupe « FM-02 — client réseau généré ») a été retiré par FM-09b comme hors scope (contrat imprécis) — FM-02d/e n'ont donc plus de test d'acceptation imposé de l'extérieur, conçus directement contre les critères de l'issue #33 (tests écrits ici même, TDD). `FM-02d` (PR ouverte) : `AuthTokenStore` (access token en mémoire, refresh token `flutter_secure_storage`, `refresh()` single-flight via `Completer`, purge totale sur échec — jamais de boucle sur un refresh token mort) + `AuthInterceptor` (bearer sortant sauf OTP/refresh/logout, un seul refresh+rejeu sur 401, anti-récursion). Ordre de la chaîne Dio vérifié dans le source (`dio_mixin.dart`) : request ET error interceptors s'exécutent dans le même ordre d'enregistrement (pas inversé) — `AuthInterceptor` doit donc être enregistré avant `ErrorMappingInterceptor`, confirmé par les tests. `flutter analyze`/`flutter test` verts. Reste : `FM-02e` (retry GET) → `FM-02f` (offline) → `FM-02g` (câblage + vérification acceptance). ⚠️ **Note process** : `BE-26c` a été travaillée deux fois en parallèle par deux sessions Claude sans visibilité l'une sur l'autre (une pairée Oussama, une pairée Chayma) — la première PR ouverte (#153, Chayma) a été fermée au profit de la seconde (#155, Oussama), et le travail de fusion qui en dépendait (#157) a été mergé par erreur dans la branche `feat/BE-26c-openapi-tags-schemas` au lieu de `develop` (même bug que BE-27 : PR affichée MERGED, jamais atteint `develop`) — reconstruit proprement en #162. Signal qu'une tâche marquée `binôme` mais attaquée par deux sessions indépendantes sans coordination explicite (qui fait quoi) duplique le travail ; à éviter en confirmant par un message qui prend quelle sous-tâche avant de commencer, pas seulement en la marquant `binôme` dans le backlog. |

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
