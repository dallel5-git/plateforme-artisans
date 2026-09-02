# DOING — en cours

> ⚠️ **Maximum 2 tâches par développeur.** Si vous en avez 3, vous n'en finissez aucune.
> Mise à jour obligatoire **en fin de chaque journée**.

_Sprint S1 · dernière mise à jour : 2026-09-02_

## DEV-1

| ID | Tâche | Démarré le | Branche | État / blocage |
|---|---|---|---|---|

_(aucune tâche DEV-1 en cours — `FM-05` et `FM-10` terminées, déplacées vers `DONE.md`)_


## DEV-2

| ID | Tâche | Démarré le | Branche | État / blocage |
|---|---|---|---|---|

*(FM-18d — Enrichit `/_ds-preview` (issue #217, dernière sous-tâche) : nuancier des 34 rôles
`AppColors` avec bascule clair/sombre locale au widget (n'affecte jamais `themeModeProvider` — la
vitrine ne doit pas changer le thème de toute l'app pour comparer les deux jeux de rôles), échelle
typographique complète (9 paliers `AppText.*`), et 13 widgets de `features/*/presentation/widgets/`
jamais montrés jusqu'ici (`AvailabilityChip`, `ReviewTile`, `OfferingCard`, `ProviderGallery`,
`DashboardStatCard`, `DashboardTrendChart`, `DashboardComparisonChip`, `RatingStarsInput`,
`OtpCodeField`, `CoverageAreaChip`, `CategoryGrid`, `CategoryGridSkeleton`,
`FavoriteCardSkeleton`) — largement au-dessus du plancher de 10 du critère d'acceptation. Exclus
volontairement : widgets couplés à des providers réseau ou des écrans à part entière plutôt que des
composants atomiques (`FavoriteCard`, `GovernoratePickerSheet`, les étapes onboarding/auth). Bâtie
sur `feat/FM-18c-i18n-preview-screen` (fusionnée localement, pas stackée en PR — les deux touchent
lourdement le même fichier) : ~18 nouvelles clés `common.devPreview.*` pour le chrome UI (titres de
section, libellés de bascule) ; les données factices bilingues alimentant les modèles générés
(nom d'avis, titre de prestation, catégories) restent des littéraux Dart, même convention que les
fixtures de test — pas des chaînes UI de l'écran. `flutter test` 340/340. PR #264 ouverte contre
`develop`, dépend de #263 (FM-18c) — déplacée vers `DONE.md` une fois les deux mergées.)*

*(FM-18c — `design_system_preview_screen.dart` respecte enfin la règle « aucune chaîne en dur » :
~34 clés `common.devPreview.*` (namespace `packages/i18n/src/locales/{fr,ar}/common.json`), y
compris les titres de section (décision : un outil de dev n'est pas exempté de la règle). Piège
outillage découvert en route : `dart run build_runner build -d` ne lit **pas** `slang.yaml` (son
`options.config` build_runner arrive vide, retombe sur les valeurs par défaut de `slang`, dont
`input_file_pattern: .i18n.json` — introuvable puisque ce projet utilise `.json` nu) ; la bonne
commande est `dart run slang`, qui lit le fichier directement. A aussi produit ~60 fichiers
`lib/core/api/generated/**.g.dart` reformatés en bruit parasite (même classe de bug que FM-06b/
FM-15b — SDK Dart local différent) — écartés (`git checkout --`), seuls les 3 fichiers
`translations*.g.dart` réellement issus de `dart run slang` sont conservés. Nouveau test
`test/app/design_system_preview_screen_test.dart` (FR + AR, non-régression : une chaîne française
codée en dur apparaîtrait aussi en arabe) — a aussi fermé un gap CI pré-existant, `test/app/`
n'était pas dans la liste `dart format --set-exit-if-changed` de `ci.yml` malgré 2 fichiers déjà
présents. `flutter test` 337/337. PR #263 ouverte contre `develop`, en attente de revue — déplacée
vers `DONE.md` une fois mergée.)*

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
