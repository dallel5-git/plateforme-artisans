# Mémoire locale — Lot MOBILE (`apps/mobile`, Flutter)

> À placer dans `Code/apps/mobile/CLAUDE.md`. Complète le `CLAUDE.md` racine.
> Lire **ADR-001** avant d'écrire la première ligne de Dart : le cadrage v1.0 dit « Expo/React Native », c'est obsolète.

## Rôle

Une **seule application**, deux espaces : `(client)` et `(pro)`. Un artisan est aussi un client ; deux
apps signifieraient deux fiches store, deux processus de review, deux bases d'installation à faire
croître. Le basculement se fait sur les rôles portés par le compte.

## Stack

Flutter 3.24+ / Dart 3.5+ · **go_router** · **Riverpod 2** (`AsyncNotifier` pour l'état serveur) ·
**Dio + Retrofit** générés depuis `contracts/openapi.json` · **freezed + json_serializable** ·
**flutter_secure_storage** · **cached_network_image** · **slang** (FR/AR) ·
lints `flutter_lints` + `very_good_analysis`.

## Arborescence — par feature, pas par type

```
lib/
  main.dart
  app/            router.dart · theme.dart · providers.dart
  core/
    api/          client Dio + intercepteurs (auth, refresh, retry, offline)
    api/generated/  ⚠️ GÉNÉRÉ — ne jamais éditer à la main
    theme/        app_colors.dart · app_spacing.dart · app_text.dart  (⚠️ générés depuis design-tokens)
    i18n/         slang (généré depuis packages/i18n)
    widgets/      primitives partagées (AppButton, AppCard, EmptyState, ErrorState…)
  features/
    auth/         data/ domain/ presentation/
    search/       …
    provider_profile/
    contact/
    reviews/
    pro_onboarding/
    pro_dashboard/
```

## Règles Flutter — non négociables

1. **Aucun `fetch`/`Dio` écrit à la main.** Tout passe par le client Retrofit généré. Si une route manque, on modifie le backend et on régénère.
2. **Aucune règle métier en Dart.** Ranking, éligibilité, complétude, quotas : c'est `packages/core` côté serveur. Le mobile affiche ce que l'API renvoie.
3. **Aucune couleur, taille, rayon ou police en dur.** `AppColors.primary`, `AppSpacing.md`. Ces fichiers sont **générés** depuis `packages/design-tokens/tokens.json` — les éditer à la main sera écrasé.
4. **Aucun `String` affiché en dur.** `t.search.emptyState`. Toute clé ajoutée dans `fr.json` **et** `ar.json`.
5. **`setState` interdit pour de l'état serveur.** Riverpod `AsyncNotifier`, qui donne loading/error/data gratuitement.
6. **`const` partout où c'est possible.** C'est l'argument même de la bascule Flutter : la fluidité sur Android d'entrée de gamme se joue sur les rebuilds.
7. **Aucun widget > ~150 lignes.** Extraire en sous-widget `const`.
8. **Refresh token dans `flutter_secure_storage` uniquement.** Jamais `SharedPreferences`, jamais en mémoire persistée.

## RTL & bilingue (P7)

- `Directionality` piloté par la locale au niveau de `MaterialApp`, pas par écran.
- Utiliser `EdgeInsetsDirectional` et `AlignmentDirectional` — **jamais** `EdgeInsets.only(left:)`.
- Les icônes directionnelles (`chevron_right`, flèches de retour) doivent être miroitées en arabe.
- Police : Manrope (latin) + **Noto Kufi Arabic** (arabe), sélection automatique par locale.

## Accessibilité — usage chantier, potentiellement avec des gants (FM-43)

- **Tout élément tappable qui n'affiche pas déjà tout son état en texte visible** (étoile de note,
  badge « Vérifié »/« Principal », case OTP, bouton icône seul…) porte un `Semantics(button:,
  selected:, label:)` explicite — réutiliser un texte déjà traduit et affiché ailleurs plutôt que
  créer une nouvelle clé i18n quand c'est possible (patron `category_grid.dart`).
- **`ExcludeSemantics` ne s'applique jamais à un sous-arbre entier**, seulement au `Text`/widget
  précis dont le libellé implicite ferait doublon avec un `Semantics.label` explicite posé plus
  haut. Posé plus large, il supprime *aussi* les `Semantics` et actions (`tap`) des descendants —
  un `trailing`/badge imbriqué avec son propre `Semantics` peut ainsi disparaître entièrement de
  l'arbre, ou rester visible mais devenir inactivable au lecteur d'écran. En cas de doute, vérifier
  avec `tester.binding.pipelineOwner.semanticsOwner!.rootSemanticsNode!.toStringDeep()` dans un test
  jetable avant de committer.
- **Cible tactile minimale : `AppLayout.touchTarget` (48dp)**, sur tout élément avec un `onTap`
  (`app_spacing.dart`). Aucune règle `flutter_lints`/`very_good_analysis` ne peut vérifier une
  taille rendue — c'est un test qui l'atteste : `tester.getSize(finder).height >=
  AppLayout.touchTarget`, jamais un lint.
- **`TextScaler.linear(1.3)`** : tout nouvel écran dense (formulaire, fiche, tableau de bord) mérite
  un test dédié qui pompe l'écran à `textScaler: TextScaler.linear(1.3)` sur un viewport `Size(360,
  800)` (Android bas de gamme) avec `captureFlutterErrors` (`test/support/overflow_guard.dart`) et
  vérifie l'absence de `RenderFlex overflowed` — patron `*_textscale_test.dart`, FR et AR séparément.

## Réseau dégradé (P5) — c'est le cœur du produit

- Timeout Dio : 10 s connect, 20 s receive. Retry × 2 avec backoff sur les `GET` idempotents uniquement.
- Cache disque des réponses de recherche et des fiches consultées → l'app reste consultable hors ligne.
- Bandeau « Hors ligne » global, non bloquant.
- Compression des images **avant upload** (`flutter_image_compress`, max 1600 px, qualité 80).
- Listes paginées par curseur, `ListView.builder` uniquement, jamais `Column` + `map`.
- Skeletons plutôt que spinners plein écran.

## Deep links natifs — la valeur du mobile

```dart
tel:+21622123456                      // launchUrl(mode: externalApplication)
https://wa.me/21622123456?text=...    // message pré-rempli en FR ou AR selon la locale
```
⚠️ **Tout clic « Appeler » ou « WhatsApp » DOIT poster un `ContactEvent` à l'API avant d'ouvrir le lien**
(principe P9). Sans cette trace, l'abonnement Pro est invendable. En cas d'échec réseau : on ouvre
quand même le lien et on met l'événement en file locale pour renvoi différé.

## Checklist avant PR mobile

- [ ] `flutter analyze` : **zéro** warning
- [ ] `dart format .` appliqué
- [ ] `flutter test` vert
- [ ] `dart run build_runner build --delete-conflicting-outputs` exécuté, fichiers générés commités
- [ ] Écran testé en **FR et en AR** (capture des deux)
- [ ] Écran testé en mode avion (état d'erreur correct, pas d'écran blanc)
- [ ] Aucune valeur de style en dur, aucune chaîne en dur
- [ ] Testé sur un Android bas de gamme ou l'émulateur bridé (CPU low, réseau 3G)
- [ ] Chaque élément tappable annonce son état à un lecteur d'écran (`Semantics` — voir
      « Accessibilité » ci-dessus), aucune cible tactile sous 48dp
- [ ] Écran dense testé à `TextScaler.linear(1.3)` (FR et AR), aucun débordement
