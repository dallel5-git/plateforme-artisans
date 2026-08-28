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

*(FM-11 — 3/3 PRs mergées #181/#185/#192 — déplacée vers `DONE.md`. Écart avec l'énoncé de l'issue #40 découvert en route : pas d'étape « tarifs » (aucun endpoint d'écriture `offerings` sous `/providers/me/*`, `calculateCompletionScore` ne note pas ce champ). ⚠️ Une PR dupliquant #181/#185 avait été ouverte par erreur au démarrage de `FM-11c` (pas de `git fetch`/revue de `develop` avant de commencer) — fermée sans merger, reprise propre.)*

*(QA-01 — 5/5 PRs mergées #138/#140/#139/#141–#143 — déplacée vers `DONE.md`. BE-18 et BE-24 : bookkeeping de retard déjà corrigé précédemment.)*

> _Note process — workflow QA-01, gardée pour mémoire_ : Oussama a mergé #138/#139/#141 en quelques minutes chacune — GitHub supprime la branche tête au merge, ce qui casse l'empilement de PRs prévu au départ (`…a` → `…b` → …). À partir de QA-01c, chaque sous-tâche a branché depuis `develop` à jour et ciblé `develop` directement. Aussi : la 1ʳᵉ tentative de PR #141 a été squash-mergée, ce qui a fait perdre un commit de bookkeeping poussé après coup — les mises à jour de backlog doivent être incluses **dans le même commit** que le travail, pas en suivi séparé.
>
> **BE-27 a subi la même classe de bug, en pire** (voir ci-dessous) : #135 empilée sur #134 (au lieu de cibler `develop`) a fini par ne jamais atteindre `develop` du tout, alors que les deux PRs s'affichent « MERGED » sur GitHub. Confirme qu'il faut bannir l'empilement de PRs sur ce repo, pas seulement le limiter.

## En binôme

| ID | Tâche | Démarré le | Branche | État / blocage |
|---|---|---|---|---|
| `FM-02` | ⭐ Couche réseau : client Dio généré + intercepteurs (#33) | 2026-08-25 | `BE-26c` (mergée #155) → `feat/FM-02b-fold-generated-client-v2` (mergée #162) → `feat/FM-02c-api-client-exceptions` (mergée #164) → `feat/FM-02d-auth-refresh-interceptor` (mergée #180) → `feat/FM-02e-retry-interceptor` (mergée #187) → `feat/FM-02f-offline-detection` (mergée #190) → `feat/FM-02g-final-wiring` (en cours) | Décomposée en sous-PRs atomiques. `BE-26c`/`FM-02b`/`FM-02c`/`FM-02d`/`FM-02e`/`FM-02f` mergées (contrat, fusion du client généré, `buildApiClient()`+exceptions typées+`ErrorMappingInterceptor`, `AuthTokenStore`+`AuthInterceptor` — refresh single-flight, `flutter_secure_storage`, jamais de boucle sur un token mort —, `RetryInterceptor` — backoff sur GET idempotents —, `ConnectivityService`+`connectivityServiceProvider` — détection hors ligne, widget `OfflineBanner` volontairement laissé à `FM-04e`, voir note ci-dessous). ⚠️ Le spec pré-écrit `contact_flow_test.dart` (groupe « FM-02 — client réseau généré ») a été retiré par FM-09b comme hors scope (contrat imprécis) — FM-02d..g n'ont donc plus de test d'acceptation imposé de l'extérieur, conçus directement contre les critères de l'issue #33 (tests écrits ici même, TDD). `FM-02g` (en cours, câblage final) : ordre des intercepteurs `Auth → Retry → ErrorMapping` confirmé (code + commentaire `api_client_provider.dart`, déjà en place depuis FM-02e). Test d'intégration écrit et vert — `test/core/api/auth_refresh_concurrency_test.dart` : deux `GET` concurrents (`Future.wait`, pas deux `await` séquentiels) sur un endpoint protégé avec token expiré → exactement **1** appel réseau à `/v1/auth/refresh` (délai artificiel de 20 ms sur la réponse du refresh factice pour garantir que les deux requêtes ont réellement le temps de se rejoindre sur le même `Completer`, sinon un test rapide passerait par pure coïncidence de timing), les deux requêtes d'origine aboutissent après rejeu — dernier critère d'acceptation non couvert de l'issue #33. Vérifié significatif (pas un test qui passe par hasard) : mutation temporaire du garde-fou single-flight dans `AuthTokenStore.refresh()` → le test échoue bien (2 appels au lieu de 1), puis revert immédiat. `flutter analyze`/`dart format` propres. Reste avant clôture de FM-02 : mise à jour `backlog/TODO.md`→`DONE.md` et `CLAUDE.md` §8 (ce commit) ; câblage visuel du bandeau (`ValueListenableBuilder` sur `connectivityServiceProvider`) différé à une petite PR de suivi une fois `FM-04e` livré (non démarré à ce jour) — même point d'extension que `ContactButtons`/FM-08→FM-09. ⚠️ **Note process — chevauchement `OfflineBanner`** : le widget figure aussi dans le périmètre `FM-04e` (design system, issue #55). Répartition actée par message direct entre sessions avant d'écrire du code (pas seulement notée ici) : FM-04e livre le widget présentation (tokens, FR/AR, sans logique) ; FM-02 livre uniquement la détection + le câblage Riverpod, aucun fichier `offline_banner.dart` côté FM-02. ⚠️ **Note process — collision de répertoire de travail découverte pendant FM-02f** : `d:\artisan-project\plateforme-artisans` (répertoire sans suffixe) s'est révélé partagé entre plusieurs sessions Claude concurrentes (reflog contenant un checkout FM-11c jamais fait par cette session) — même classe de risque que la duplication BE-26c, mais sur l'arbre de travail local plutôt que sur GitHub. Résolu en migrant vers un `git worktree` dédié par sous-PR (`plateforme-artisans-fm02f`, puis `-fm02g`, même mécanisme que `-fm06`/`-fm09b`/`-fm09c`/`-fm09-close`/`-fm11c` déjà en place) — le répertoire sans suffixe doit rester neutre (`develop`, jamais une branche de feature). ⚠️ **Note process — BE-26c** : `BE-26c` a été travaillée deux fois en parallèle par deux sessions Claude sans visibilité l'une sur l'autre (une pairée Oussama, une pairée Chayma) — la première PR ouverte (#153, Chayma) a été fermée au profit de la seconde (#155, Oussama), et le travail de fusion qui en dépendait (#157) a été mergé par erreur dans la branche `feat/BE-26c-openapi-tags-schemas` au lieu de `develop` (même bug que BE-27 : PR affichée MERGED, jamais atteint `develop`) — reconstruit proprement en #162. Signal qu'une tâche marquée `binôme` mais attaquée par deux sessions indépendantes sans coordination explicite (qui fait quoi) duplique le travail ; à éviter en confirmant par un message qui prend quelle sous-tâche avant de commencer, pas seulement en la marquant `binôme` dans le backlog. |

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
