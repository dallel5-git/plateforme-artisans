# DOING — en cours

> ⚠️ **Maximum 2 tâches par développeur.** Si vous en avez 3, vous n'en finissez aucune.
> Mise à jour obligatoire **en fin de chaque journée**.

_Sprint S1 · dernière mise à jour : 2026-09-03_

## DEV-1

| ID | Tâche | Démarré le | Branche | État / blocage |
|---|---|---|---|---|
| `BE-44` | `GET /v1/providers/me` — lire son propre profil artisan | 2026-09-03 | `feat/BE-44-providers-me-get` | PR ouverte. L'essentiel existait déjà (`providerMeSchema`, `findProviderProfileByUserId`, `requireOwnProfile`, codes d'erreur) — route + tests + contrat régénéré. Effet de bord détecté et corrigé : la régénération du client Dart a fait migrer le type de retour de `PATCH /providers/me` de `V1ProvidersMePost200ResponseProvider` vers `V1ProvidersMeGet200Response` (openapi-generator ne déduplique un schéma dupliqué qu'entre réponses racine, pas avec un champ imbriqué comme `POST`'s `.provider`) — cassait la compilation mobile (`onboarding_repository.dart`/`onboarding_notifier.dart`). Corrigé par une conversion via les sérialiseurs générés dans `OnboardingRepository.updateProfile()`, sans toucher au typedef `ProviderMe` existant ni au code déjà écrit contre lui. `flutter analyze`/`flutter test` (352/352) et `pnpm --filter api test` (131/131) verts. |
| `BE-45` | `GET /v1/contact-events` — historique de lecture (débloque `FM-31`) | 2026-09-03 | `feat/BE-45-contact-events-history` | PR ouverte. Nouveau `select` dédié `clientHistorySelect` (`contact-event.repository.ts`) plutôt qu'élargissement du `select` module-level existant, qui a des appelants réels (BE-16). Hydratation par lots providers/catégories (même patron que `loadFavoritesPage`, BE-25c) — `categoryName` résolu FR/AR à la volée, `hasReview` lu directement via la relation 1-1 `review` de `ContactEvent` (pas de second `select`/requête). 3 tests d'intégration Postgres réels : isolation stricte par client, pagination par curseur sur 3 lignes/limit=2, résolution catégorie + `hasReview`. Contrat régénéré, client Dart régénéré sans collision de schéma cette fois (types `V1ContactEventsGet200Response*` neufs, contrairement à l'effet de bord `PATCH`/`GET` de BE-44 ci-dessus). `pnpm typecheck`/`lint`/`format:check` verts, `flutter analyze` zéro warning. |

_(aucune autre tâche DEV-1 en cours — `FM-05` et `FM-10` terminées, déplacées vers `DONE.md`)_


## DEV-2

| ID | Tâche | Démarré le | Branche | État / blocage |
|---|---|---|---|---|
| `FM-24` | Shell pro : navigation à 4 onglets, dashboard comme racine | 2026-09-03 | `feat/FM-24c-pro-shell-integration` | 2/3 PRs mergées (#274 persistance, #275 placeholders) — PR #276 (`FM-24c`, intégration routeur) ouverte contre `develop`, en attente de revue |
| `FM-29` | Refonte fiche artisan : couverture plein-écran et avatar superposé (RTL) | 2026-09-04 | `feat/FM-29a-cover-avatar-rtl` | 1/2 PRs. `FM-29a` (couverture + bouton retour flottant + avatar RTL) prête, PR à ouvrir contre `develop`. Dépendance `FM-15` déjà livrée (label GitHub #226 resté `blocked` par bookkeeping en retard). 2 points de l'issue déjà satisfaits par `FM-18a` (couleurs `scrim`/`onScrim`, garde-fou CI), aucun travail requis. Écart API documenté : `V1ProvidersSlugGet200Response` n'expose aucun champ avatar dédié, repli sur `gallery.first` en commentaire dans `provider_cover_header.dart`. Reste `FM-29b` (adoption `AppSkeleton` sur `_ProfileSkeleton` et le placeholder image de `ProviderGallery`). `flutter analyze` zéro warning, `flutter test` 397/397. **Vérification visuelle FR/AR sur device Android réel toujours à faire** — non disponible dans cet environnement. |

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
