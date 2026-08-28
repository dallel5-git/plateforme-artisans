# DOING — en cours

> ⚠️ **Maximum 2 tâches par développeur.** Si vous en avez 3, vous n'en finissez aucune.
> Mise à jour obligatoire **en fin de chaque journée**.

_Sprint S1 · dernière mise à jour : 2026-08-27_

## DEV-1

| ID | Tâche | Démarré le | Branche | État / blocage |
|---|---|---|---|---|
| `FM-10` | Dépôt d'avis après contact : note en étoiles, commentaire, invitation post-contact (#39) | 2026-08-28 | `feat/FM-10a-reviews-data-layer` → `FM-10b..c` | Décomposée en 3 PRs atomiques depuis `develop`. `FM-10a` : traductions i18n FR/AR, `ReviewsRepository` (délégation à `DefaultApi.v1ProvidersIdReviewsPost`), `ReviewSubmissionNotifier` (AutoDisposeNotifier avec invalidation profil & avis), tests unitaires repository + notifier. `flutter analyze` et `flutter test` verts. |


## DEV-2

| ID | Tâche | Démarré le | Branche | État / blocage |
|---|---|---|---|---|
*(FM-04 — 6/6 PRs mergées #163/#167/#168/#169/#188/#… — déplacée vers `DONE.md`. Les 10 widgets de l'issue #55 sont livrés. `feat/FM-04c-rating-stars-verified-badge` était restée bloquée en fusion locale non résolue pendant la revue (`origin/develop` avait avancé de 24 commits, dont FM-08b qui avait entre-temps introduit ses propres copies de `rating_stars.dart`/`verified_badge.dart`) — fusion refaite proprement, conflits résolus par union des chemins CI. `FM-04e` (dernière tranche) : `AppSkeleton`, `EmptyState`/`ErrorState` (design-system.html §8), `OfflineBanner` (bandeau fin non bloquant — tranché en faveur de la description `CLAUDE.md` mobile plutôt que la carte plein écran du mockup §8). **Non vérifié sur device Android réel** dans cet environnement.)*

*(FM-06 — 3/3 PRs mergées #165/#166/#170 — déplacée vers `DONE.md`. `FM-06b` avait un conflit `backlog/DOING.md` avec `fix/FM-04a-app-button-shrinkwrap` (#167, résolu par rebase) et un vrai bug CI (`dart format --set-exit-if-changed lib/core/api` en entier balayait `lib/core/api/generated/`, reformaté par un SDK Dart local différent de celui épinglé — corrigé en ciblant `lib/core/api/api_client_provider.dart` précisément).)*

*(FM-09 — 3/3 PRs mergées #172/#175/#177 — déplacée vers `DONE.md`. Le spec pré-écrit `test/features/contact/contact_flow_test.dart` (FM-09/FM-02) s'est révélé imprécis face au vrai contrat (`phone` et non `revealedPhone`, `whatsappMessage` déjà localisé côté serveur) — remplacé en `FM-09b` par une version conforme. Pas encore d'écran pour embarquer `ContactButtons` (FM-08 non mergé) — vérifié par tests widget seuls, à câbler dans une fiche prestataire dès que FM-08 livre.)*
| `FM-08` | Fiche artisan : galerie, tarifs, zones, avis, badge (#37) | 2026-08-27 | `feat/FM-08a-provider-profile-data-layer` (PR #173, en attente de revue) → `feat/FM-08b-provider-profile-widgets` (PR #174, en attente de revue) → `feat/FM-08c-provider-profile-screen` (PR #176, en attente de revue) → `feat/FM-08d-provider-profile-polish-i18n` (PR #178, en attente de revue) | Dépendance `BE-17` fermée. Décomposée en 4 PRs atomiques, branchées depuis `develop` et ciblant `develop` directement (jamais empilées). `FM-08a` (#173, couche data) : `ProviderProfileRepository`, `cached_network_image`, providers Riverpod, traductions FR/AR, CI étendue. `FM-08b` (#174, widgets présentation) : `ProviderGallery`, `OfferingCard`, `CoverageAreaChip`, `AvailabilityChip`, `ReviewTile`, `RatingStars`, `VerifiedBadge`. `FM-08c` (#176, écran `ProviderProfileScreen` + routing) : route `/providers/:slug`, écran complet avec chargement skeleton, gestion d'erreur avec réessai, affichage galerie / prestations / zones / avis avec pagination curseur, barre fixe de contact basse avec boutons Appeler et WhatsApp (point d'extension FM-09). `FM-08d` (#178, polish i18n & RTL) : validation de la parité i18n FR/AR, tests complets sous locale arabe RTL, intégration design system et vérification CI globale. `flutter analyze` et `flutter test` verts (80/80). |
| `FM-11` | Espace Pro : assistant d'onboarding + `completionScore` en direct (#40) | 2026-08-27 | `feat/FM-11a-onboarding-data-layer` (mergée #181) → `feat/FM-11b-onboarding-notifier` (mergée #185) → `feat/FM-11c-onboarding-screens` (en attente de revue) | BE-19 fermée (dépendance levée). Décomposée en 3 PRs atomiques depuis `develop` ciblant `develop` (pas 4 — `FM-11d` envisagée initialement n'était pas nécessaire, les écrans + le routing tiennent dans `FM-11c`). ⚠️ **Collision de travail découverte en démarrant `FM-11c`** : une PR `feat/FM-11a-onboarding-domain-repository` (#186) avait été ouverte en parallèle par cette session sans revoir `develop` d'abord — dupliquait #181/#185 déjà mergées. Fermée sans merger, branche supprimée, reprise propre depuis `develop` à jour. `FM-11a` (#181, mergée, par la session pairée avec Chayma) : `OnboardingRepository` (createProfile/updateProfile/setCategories/setCoverageAreas, typealias sur types générés — P4). `FM-11b` (#185, mergée, idem) : `OnboardingState`/`OnboardingNotifier` (state machine 4 étapes profil→catégories→zones→récap, reprise session-memory faute de `GET /providers/me`). `FM-11c` (nouveau worktree isolé) : écrans — `OnboardingScreen` (shell, step indicator + barre de complétude, câblé sur `/pro` à la place du placeholder bootstrap, même patron que `/client` en FM-06), `OnboardingProfileStep`/`OnboardingCategoriesStep`/`OnboardingZonesStep`/`OnboardingSummaryStep`. Pas d'étape « tarifs » : aucun endpoint d'écriture `offerings` sous `/providers/me/*` et `calculateCompletionScore` ne note que 7 champs (aucun n'est « tarifs » ni « photos ») — écart déjà noté à l'ouverture de la tâche. Étape zones limitée au niveau gouvernorat (`delegationId` omis = tout le gouvernorat) — la granularité délégation nécessiterait un fetch par gouvernorat sélectionné, hors périmètre v1. Corrige au passage un bug de `FM-11b` : la branche PATCH de `saveProfile` ne recopiait que `businessName`, perdant silencieusement bio/headline/etc. au retour sur l'étape profil. `missingFields` du récapitulatif recalculé côté client à l'affichage seulement (mêmes clés que `calculateCompletionScore`, `phoneVerified` exclu faute d'auth) — `canPublish`/la décision serveur restent seuls juges de la publication (P3). `flutter analyze`/`flutter test` verts (test/features/onboarding : 49/49 ; suite mobile complète verte). |

*(QA-01 — 5/5 PRs mergées #138/#140/#139/#141–#143 — déplacée vers `DONE.md`. BE-18 et BE-24 : bookkeeping de retard déjà corrigé précédemment.)*

> _Note process — workflow QA-01, gardée pour mémoire_ : Oussama a mergé #138/#139/#141 en quelques minutes chacune — GitHub supprime la branche tête au merge, ce qui casse l'empilement de PRs prévu au départ (`…a` → `…b` → …). À partir de QA-01c, chaque sous-tâche a branché depuis `develop` à jour et ciblé `develop` directement. Aussi : la 1ʳᵉ tentative de PR #141 a été squash-mergée, ce qui a fait perdre un commit de bookkeeping poussé après coup — les mises à jour de backlog doivent être incluses **dans le même commit** que le travail, pas en suivi séparé.
>
> **BE-27 a subi la même classe de bug, en pire** (voir ci-dessous) : #135 empilée sur #134 (au lieu de cibler `develop`) a fini par ne jamais atteindre `develop` du tout, alors que les deux PRs s'affichent « MERGED » sur GitHub. Confirme qu'il faut bannir l'empilement de PRs sur ce repo, pas seulement le limiter.

## En binôme

_(aucune tâche en binôme en cours — `FM-02` terminée, déplacée vers `DONE.md`)_

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
