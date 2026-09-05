# DOING — en cours

> ⚠️ **Maximum 2 tâches par développeur.** Si vous en avez 3, vous n'en finissez aucune.
> Mise à jour obligatoire **en fin de chaque journée**.

_Sprint S1 · dernière mise à jour : 2026-09-04_

## DEV-1

| ID | Tâche | Démarré le | Branche | État / blocage |
|---|---|---|---|---|
| `BE-44` | `GET /v1/providers/me` — lire son propre profil artisan | 2026-09-03 | `feat/BE-44-providers-me-get` | PR ouverte. L'essentiel existait déjà (`providerMeSchema`, `findProviderProfileByUserId`, `requireOwnProfile`, codes d'erreur) — route + tests + contrat régénéré. Effet de bord détecté et corrigé : la régénération du client Dart a fait migrer le type de retour de `PATCH /providers/me` de `V1ProvidersMePost200ResponseProvider` vers `V1ProvidersMeGet200Response` (openapi-generator ne déduplique un schéma dupliqué qu'entre réponses racine, pas avec un champ imbriqué comme `POST`'s `.provider`) — cassait la compilation mobile (`onboarding_repository.dart`/`onboarding_notifier.dart`). Corrigé par une conversion via les sérialiseurs générés dans `OnboardingRepository.updateProfile()`, sans toucher au typedef `ProviderMe` existant ni au code déjà écrit contre lui. `flutter analyze`/`flutter test` (352/352) et `pnpm --filter api test` (131/131) verts. |
| `FM-33` | Refonte de l'authentification : marque, mention légale, bouton Confirmer (issue #230) | 2026-09-04 | `feat/FM-33a-remove-role-step` | Dépendances `FM-15`/`FM-16` toutes deux `DONE` (label GitHub `blocked` périmé, même situation que `FM-29`/`FM-30`/`FM-32`). Découpée en 4 PRs atomiques empilées (additif → structurel → nettoyage, précédent FM-18/FM-29/FM-30) : **33a** retrait de `AuthStep.role`/`RoleSelectionStep` (absent des maquettes A3/B1, le rôle réel est déterminé côté serveur via `redirect:` sur `GET /auth/me`, jamais par ce choix — vérifié qu'aucun code hors du widget supprimé ne lisait `UserRoleChoice`) ; **33b** `phone_entry_step.dart` : sous-titre, nouveau paramètre `prefix` sur `AppTextField` (filet séparateur, distinct de `prefixIcon`) pour le `+216`, mention légale ouvrant `LegalNoticeScreen` par un `Navigator.push` direct plutôt que la route nommée existante (imbriquée sous le shell client **authentifié** — la garde `redirect:` renverrait un visiteur non connecté sur `/auth`) ; **33c** bouton `AppButton` « Confirmer » sur l'écran OTP (`OtpCodeField` gagne un callback `onChanged` pour suivre le code partiel) en plus de la soumission auto à la 6ᵉ touche, nouvelle fonction `formatCountdown()` dans `format.dart` (`0:47`, jamais `47s`) ; **33d** remplace `Theme.of(context).textTheme.*` par `AppText.*` dans les 2 widgets restants (mapping vérifié contre `_textThemeFrom`, aucun changement visuel). Logo/tuile de marque explicitement hors périmètre (asset absent de `assets/`, non fourni par le lead). **Piège stacked PR rencontré (même classe que `BE-27`/`FM-16c`)** : #312/#313/#314/#315 affichées « MERGED » par GitHub (les 3 dernières fusionnées à moins de 20 s d'écart), mais seule #312 avait réellement atteint `develop` — vérifié par lecture directe du contenu de `origin/develop` (aucune trace de `phoneSubtitle`/`prefix`/`otpCta`/`formatCountdown`) et par `git merge-base --is-ancestor`. PR de rattrapage `fix/FM-33bcd-land-on-develop` (#316) **mergée** — les 15 fichiers sont désormais réellement sur `develop`. `flutter analyze` zéro warning, `flutter test` 463/463 à chaque étape. **Vérification visuelle FR/AR sur device Android réel non faite** — même limite connue que FM-22/23/29/30/32. |
| `FM-35` | Étape photos/portfolio de l'onboarding — upload + compression (issue #232) | 2026-09-05 | `feat/FM-35c-wiring` | Dépendance `FM-34` vérifiée `DONE` sur `origin/develop` (les 3 PRs 34a/b/c mergées, label GitHub `blocked` périmé). Backend entièrement prêt (`POST /v1/media/presign`, `POST /v1/media/:id/process`, `POST`/`DELETE /providers/me/portfolio`, BE-20a→d) — pur travail mobile. Worktree dédié par sous-tâche (`fm-35a-media-repository` → `fm-35b-photos-step` → `fm-35c-wiring`) : le worktree racine était occupé par une autre session (`feat/FM-37a-dashboard-header`), leçon retenue de l'incident `FM-34b`. Découpée en 3 PRs atomiques ciblant `develop` (patron FM-34/FM-11 : couche donnée → widget d'étape → câblage) : **35a** (PR #323, **mergée**) `image_picker` + `flutter_image_compress` (nouvelles dépendances `dependencies` — explicitement prescrites par l'énoncé de l'issue #232, accord déjà donné) + `PortfolioRepository` + `PortfolioUploadTask` (état par photo, jamais d'échec global). **35b** (PR #325, **mergée**) `OnboardingPhotosStep` : **écart découvert et assumé vs le plan initial** — aucune route ne liste le portfolio de son propre profil pendant l'onboarding (seule la fiche publique `GET /providers/{slug}`, réservée aux profils `PUBLISHED`, l'expose) — donc pas d'`AppSkeleton`/`ErrorState` de chargement initial comme prévu à tort dans le plan `FM-34c` : la grille suit uniquement les photos ajoutées **pendant cette session**, la reprise après fermeture restant le périmètre déjà déclaré de `FM-36` (bloqué par `BE-44`). Widget porte lui-même tout le pipeline (pick → compresser → presign → upload → process → attacher), `pickImage`/`compressImage` injectables (canaux de plateforme non simulables en `flutter_test`). Plafond FREE (5 photos) masque le bouton d'ajout ; suppression → `DELETE /providers/me/portfolio/:id`. Clés i18n `photos*` ajoutées dans cette PR (pas reportées, règle §4.2 mobile CLAUDE.md). **35c** (en cours) câblage seul : `OnboardingStep.photos` inséré entre zones et récapitulatif (`onboarding_state.dart`), `OnboardingNotifier.advanceFromPhotos()` (avance locale, aucun appel réseau — chaque photo déjà attachée en temps réel par 35b), `saveCoverageAreas()` route désormais vers `photos` au lieu de `summary` en dur, `onboarding_screen.dart` câble le nouveau cas + clé `stepPhotos` (l'en-tête passe de lui-même à « Étape N sur 5 »), test d'intégration écran zones→photos→récapitulatif (`onboarding_screen_test.dart`) + test notifier `advanceFromPhotos`. `flutter analyze` zéro warning, `flutter test` 491/491, `pnpm i18n:check` vert. **Vérification visuelle FR/AR sur device Android réel non faite** — même limite que FM-22/23/29/30/31/32/33/34. |

_(aucune autre tâche DEV-1 en cours — `FM-05`, `FM-10`, `FM-30`, `FM-32` et `FM-37` terminées, déplacées vers
`DONE.md`)_

*(FM-37 — 3/3 PRs mergées #320/#322/#324 — déplacée vers `DONE.md`.)*

*(FM-32 — 2/2 PRs mergées #309/#310 — déplacée vers `DONE.md`. 3 sessions Claude ont convergé sur
cette même tâche en parallèle dans le même worktree partagé, coordonnées par message direct avant
d'écrire plus de code — voir `DONE.md` pour le détail et pour le bug de test `StatefulShellRoute`
trouvé au passage.)*


## DEV-2

| ID | Tâche | Démarré le | Branche | État / blocage |
|---|---|---|---|---|
| `FM-24` | Shell pro : navigation à 4 onglets, dashboard comme racine | 2026-09-03 | `feat/FM-24c-pro-shell-integration` | 2/3 PRs mergées (#274 persistance, #275 placeholders) — PR #276 (`FM-24c`, intégration routeur) ouverte contre `develop`, en attente de revue |
| `FM-28` | Écran de résultats de recherche : pagination, filtres, cache disque | 2026-09-04 | `feat/FM-28c-search-results-notifier` | Découpée en 4 PRs atomiques (audit du code réel FM-27/FM-23, tous deux livrés — seule une PR de bookkeeping `FM-27` restait ouverte, mergée depuis, #293) : **28a** `SearchRepository` (`v1ProvidersSearchGet`, filtres gouvernorat/catégorie/délégation/vérifié/note min) + infra de cache disque générique (`hive`/`hive_flutter`, nouvelle dépendance — aucune lib de persistance structurée n'existait, seul `shared_preferences` pour des clés simples ; stockage en JSON via `standardSerializers`/`StandardJsonPlugin`, pas de `TypeAdapter` généré) ; **28b** `ProviderProfileCache` (même patron que `SearchResultsCache`), branchée directement dans `ProviderProfileRepository.fetchProfile` : écrit après chaque succès réseau, sert la dernière version en cache sur `DioException` plutôt qu'une erreur (fiches déjà consultées, volet du périmètre de l'issue #225) ; **28c** `SearchResultsNotifier` (`AsyncNotifier.family<SearchFilters>`) : page 1 réseau + écriture cache, repli sur `SearchResultsCache` en cas d'échec (P5) — **écart au plan initial** : pas de dépendance à `connectivity_plus` ici, le repli se déclenche sur l'exception réseau elle-même (même mécanisme que `28b`), la détection de connectivité (bandeau) reste une décision d'écran pour `28d` ; `loadMore()` accumule en mémoire de session uniquement. `SearchFilters` gagne une égalité de valeur (`==`/`hashCode`), nécessaire pour que la famille Riverpod fonctionne une fois les filtres construits au runtime (jamais `const` en usage réel) ; **28d** `SearchResultsScreen` (liste, chips `AppFilterChip` Vérifié/Note 4+/Urgence-désactivée — l'API n'expose aucun paramètre `acceptsEmergency`, confirmé sur le contrat —, skeleton/vide/erreur, `OfflineBanner` monté pour la première fois en production, route `/client/results`, `CategoryGrid.onTap` enfin câblé). **28a/28b mergées (#295/#298), 28c : PR #302 ouverte contre `develop`**, `flutter analyze` zéro warning, `flutter test` 430/430. |

*(FM-29 — 2/2 PRs mergées #294/#296 — déplacée vers `DONE.md`. **Vérification visuelle FR/AR sur
device Android réel toujours à faire** — non disponible dans cet environnement, voir `DONE.md`.)*

*(FM-27 — 3/3 PRs mergées #290/#291/#292 — déplacée vers `DONE.md`. Périmètre réduit à l'audit du
code réel plutôt qu'à l'énoncé littéral de l'issue #224, close avec 3 des 4 points traités, voir
`DONE.md`.)*

*(FM-26 — 2/2 PRs mergées #285/#288 — déplacée vers `DONE.md`. Périmètre réduit à l'audit du code
réel plutôt qu'à l'énoncé littéral de l'issue #223, close avec 2 des 4 points traités, voir
`DONE.md`.)*

*(FM-23 — 2/2 PRs mergées #270/#271 — déplacée vers `DONE.md`. **Vérification visuelle FR/AR sur
device Android réel toujours à faire** — non disponible dans l'environnement où les PRs ont été
préparées, voir `DONE.md`.)*

*(FM-22 — 1 PR mergée #268 — déplacée vers `DONE.md`. **Vérification visuelle FR/AR sur device
Android réel toujours à faire** — non disponible dans l'environnement où la PR a été préparée, voir
`DONE.md`.)*

*(FM-19 — 1 PR mergée #266 — déplacée vers `DONE.md`. Voir `DONE.md` pour le piège de merge
`common.json` rencontré et sa correction.)*

*(FM-18 — 4/4 PRs mergées #261/#262/#263/#264 — déplacée vers `DONE.md`. Trois conflits
`backlog/DOING.md` en cascade rencontrés au fil des merges successifs (#261 puis #262 puis #263,
chacun invalidant la résolution précédente sur `feat/FM-18d-enrichir-ds-preview` qui les touchait
tous) — résolus à chaque fois par fusion de `develop` + re-vérification complète (jamais par
rebase/force-push), même méthode que FM-15/FM-16.)*

*(FM-17 — 2/2 PRs mergées #258/#259 — déplacée vers `DONE.md`.)*

*(FM-16 — 3/3 PRs mergées #254/#255/#256 — déplacée vers `DONE.md`. Piège **stacked PR** rencontré :
`FM-16c` (#256, base `feat/FM-16b-sous-themes-composants`) a fusionné 17 s *après* que #255 (même
branche → `develop`) avait déjà fusionné — GitHub affichait les deux PRs « MERGED », mais le contenu
de FM-16c n'avait en réalité jamais atteint `develop` (vérifié par lecture directe du fichier sur
`origin/develop` après coup, precedent identique documenté sur `BE-27`). Corrigé par une PR de
rattrapage dédiée (`fix/FM-16c-land-on-develop`) fusionnant le contenu réel de la branche stale vers
`develop`, diff vérifié identique aux 12 fichiers attendus avant ouverture.)*

*(FM-15 — 7/7 PRs mergées #246/#247/#248/#249/#250/#251/#252 — déplacée vers `DONE.md`. Prérequis bloquant de la refonte visuelle mobile (milestone M7) : `build-tokens.mjs` exportait `elevation`/`motion`/tracking/`layout.breakpoint`/poids de police en TS/Tailwind mais jamais en Dart (SO-08, généralisée). Découpée en 7 sous-PRs atomiques par *concern* plutôt que par couche (précédent FM-02) : socle de tests d'abord (FM-15a, bloquant pour toutes les suivantes), puis fix `copyWith`/`lerp` et `AppIconSize` (aucune dépendance design), puis élévation/motion et typographie/layout, puis nouveaux rôles et correction des collisions — ces deux dernières séquencées volontairement après les PRs touchant `app_colors.dart` pour éviter que `merge=ours` (`.gitattributes`, fichiers générés) n'écrase un fix par un autre. Deux conflits `backlog/DOING.md`/`fixtures.mjs` rencontrés en cascade (une seule ligne partagée éditée par plusieurs branches successives) — résolus par fusion de `develop` + régénération, jamais par rebase/force-push.)*

*(FM-04 — 6/6 PRs mergées #163/#167/#168/#169/#188/#191 — déplacée vers `DONE.md`. Les 10 widgets de l'issue #55 sont livrés. `feat/FM-04c-rating-stars-verified-badge` était restée bloquée en fusion locale non résolue pendant la revue (`origin/develop` avait avancé de 24 commits, dont FM-08b qui avait entre-temps introduit ses propres copies de `rating_stars.dart`/`verified_badge.dart`) — fusion refaite proprement, conflits résolus par union des chemins CI. `FM-04e` (dernière tranche) : `AppSkeleton`, `EmptyState`/`ErrorState` (design-system.html §8), `OfflineBanner` (bandeau fin non bloquant — tranché en faveur de la description `CLAUDE.md` mobile plutôt que la carte plein écran du mockup §8). **Non vérifié sur device Android réel** dans cet environnement.)*

*(FM-06 — 3/3 PRs mergées #165/#166/#170 — déplacée vers `DONE.md`. `FM-06b` avait un conflit `backlog/DOING.md` avec `fix/FM-04a-app-button-shrinkwrap` (#167, résolu par rebase) et un vrai bug CI (`dart format --set-exit-if-changed lib/core/api` en entier balayait `lib/core/api/generated/`, reformaté par un SDK Dart local différent de celui épinglé — corrigé en ciblant `lib/core/api/api_client_provider.dart` précisément).)*

*(FM-09 — 3/3 PRs mergées #172/#175/#177 — déplacée vers `DONE.md`. Le spec pré-écrit `test/features/contact/contact_flow_test.dart` (FM-09/FM-02) s'est révélé imprécis face au vrai contrat (`phone` et non `revealedPhone`, `whatsappMessage` déjà localisé côté serveur) — remplacé en `FM-09b` par une version conforme. Pas encore d'écran pour embarquer `ContactButtons` (FM-08 non mergé) — vérifié par tests widget seuls, à câbler dans une fiche prestataire dès que FM-08 livre.)*

*(FM-08 — 4/4 PRs mergées #173/#174/#176/#178 — déplacée vers `DONE.md`. Ligne restée par erreur dans ce tableau après le merge des 4 PRs (bookkeeping en retard, corrigé en démarrant `FM-14`, qui en dépend indirectement pour la vérification de bout en bout). ⚠️ `_ContactBar` de `ProviderProfileScreen` (FM-08c) a deux `onPressed` encore vides — `// Point d'extension FM-09` — `ContactButtons` (FM-09c) n'y est pas câblé malgré le merge des deux tâches ; câblage laissé à une petite PR de suivi dédiée, périmètre `FM-09` (voir note FM-14 ci-dessous). ✅ Résolu par `FM-10c`.)*

*(FM-10 — 3/3 PRs mergées #189/#201/#205 — déplacée vers `DONE.md`. Les 3 critères de l'issue #39 sont vérifiés : formulaire (note + commentaire), accessible seulement après contact (403 `REVIEW_REQUIRES_CONTACT` côté serveur), note moyenne mise à jour immédiatement après envoi (invalidation Riverpod). Au passage, `FM-10c` a aussi résolu le gap `_ContactBar` documenté ci-dessus depuis FM-08/FM-09 — Call/WhatsApp fonctionnent enfin sur la fiche artisan. **Non vérifié sur device Android réel** dans cet environnement.)*

*(FM-11 — 3/3 PRs mergées #181/#185/#192 — déplacée vers `DONE.md`. Écart avec l'énoncé de l'issue #40 découvert en route : pas d'étape « tarifs » (aucun endpoint d'écriture `offerings` sous `/providers/me/*`, `calculateCompletionScore` ne note pas ce champ). ⚠️ Une PR dupliquant #181/#185 avait été ouverte par erreur au démarrage de `FM-11c` (pas de `git fetch`/revue de `develop` avant de commencer) — fermée sans merger, reprise propre.)*

*(FM-12 — 3/3 PRs mergées #196/#200/#208 — déplacée vers `DONE.md`. Tableau de bord Espace Pro (`/pro/dashboard`) : 4 tuiles, comparaison mois-1 dérivée côté client, courbe 30 jours en `CustomPainter` fait main (aucune dépendance de charts ajoutée). `flutter analyze` zéro warning, `flutter test` 295/295.)*

*(FM-14 — 5/5 PRs mergées #197/#209/#210/#211 (`FM-14a`/`b`/`c`/`d`, `FM-14e` = cette clôture backlog) — déplacée vers `DONE.md`. Build release jamais exécuté avec succès de bout en bout dans une session (environnement local, puis secrets GitHub manquants) ; palier P1 seul est couvert (config + outillage). Palier P2 = `QA-03`/GATE 2 (#44), toujours bloqué par `FM-07` (non démarrée) et `OPS-01` (aucune API déployée, reporté S2).)*

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
