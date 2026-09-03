import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sanaya/app/router.dart';
import 'package:sanaya/core/api/api_client_provider.dart';
import 'package:sanaya/core/api/auth_token_store.dart';
import 'package:sanaya/core/i18n/translations.g.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/features/auth/application/auth_providers.dart';
import 'package:sanaya/features/auth/data/auth_repository.dart';
import 'package:sanaya/features/search/application/catalog_providers.dart';
import 'package:sanaya/main.dart';

final Translations _tFr = AppLocale.fr.buildSync();
final Translations _tAr = AppLocale.ar.buildSync();

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockAuthTokenStore extends Mock implements AuthTokenStore {}

/// `SplashScreen` affiche un `CircularProgressIndicator` indéterminé —
/// `pumpAndSettle()` ne se termine jamais tant qu'il est à l'écran (son
/// animation se reprogramme indéfiniment). On pompe donc un budget de temps
/// borné pour laisser `authStateProvider` résoudre et `redirect:` faire
/// quitter le splash, avant tout `pumpAndSettle()`.
Future<void> pumpPastSplash(WidgetTester tester) async {
  await tester.pump();
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

/// Invoque directement `onPressed` plutôt qu'un `tester.tap()` par
/// coordonnées : les `Navigator`/`Overlay` imbriqués de chaque branche
/// `StatefulShellRoute` (premier usage dans ce repo) rendent le calcul de
/// position par `tester.tap()` peu fiable sur les icônes d'AppBar d'une
/// branche tout juste rejointe (« derived an Offset that would not hit
/// test »), alors que le bouton est bien monté et son callback intact.
Future<void> tapIconButton(WidgetTester tester, IconData icon) async {
  final button = tester.widget<IconButton>(
    find.ancestor(of: find.byIcon(icon), matching: find.byType(IconButton)),
  );
  button.onPressed!();
  await tester.pumpAndSettle();
}

void main() {
  // `router` (lib/app/router.dart) est un singleton top-level — son état de
  // navigation survit d'un test à l'autre dans le même isolate. On revient
  // explicitement à '/' avant chaque test qui suppose partir du splash.
  setUp(() => router.go('/'));

  Widget buildApp() {
    // `restoreSession()` (implémentation réelle, `flutter_secure_storage`)
    // n'aboutit jamais dans le harnais de test (aucun handler de canal de
    // plateforme enregistré) — `authStateProvider` resterait indéfiniment
    // en `AsyncLoading`, et le splash ne serait jamais quitté. Le mock
    // simule une absence de session, résolue immédiatement (même patron
    // que `test/app/router_redirect_test.dart`).
    final authTokenStore = _MockAuthTokenStore();
    when(authTokenStore.restoreSession).thenAnswer((_) async => false);

    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(_MockAuthRepository()),
        authTokenStoreProvider.overrideWithValue(authTokenStore),
        categoriesProvider.overrideWith((ref) async => const []),
        governoratesProvider.overrideWith((ref) async => const []),
      ],
      child: const SanayaApp(),
    );
  }

  group('FM-23 — splash puis atterrissage anonyme sur le shell client', () {
    testWidgets(
      'un utilisateur anonyme atterrit sur l’onglet Rechercher avec les 4 '
      'onglets visibles, jamais sur un hub de dev',
      (tester) async {
        await tester.pumpWidget(buildApp());
        await pumpPastSplash(tester);

        expect(find.text(_tFr.search.categoriesTitle), findsOneWidget);
        expect(find.text(_tFr.common.nav.searchTab), findsOneWidget);
        expect(find.text(_tFr.common.nav.favoritesTab), findsOneWidget);
        expect(find.text(_tFr.common.nav.historyTab), findsOneWidget);
        expect(find.text(_tFr.common.nav.profileTab), findsOneWidget);
      },
    );

    testWidgets(
      '/auth reste atteignable directement et mène à la sélection de rôle '
      '(FM-05c)',
      (tester) async {
        await tester.pumpWidget(buildApp());
        await pumpPastSplash(tester);

        router.go('/auth');
        await tester.pumpAndSettle();

        expect(find.text(_tFr.auth.roleTitle), findsOneWidget);
      },
    );

    testWidgets(
      'FM-24 — /pro n’est plus atteignable sans session PROVIDER : un '
      'anonyme est redirigé vers /auth, pas l’onboarding',
      (tester) async {
        // Avant FM-24, /pro/* n'avait aucune garde (voir CLAUDE.md racine,
        // §3.6) — un anonyme y voyait librement l'onboarding. Ce test
        // verrouillait ce comportement ; il verrouille désormais son
        // inverse, la garde ajoutée par FM-24 (`router.dart`, `redirect:`).
        await tester.pumpWidget(buildApp());
        await pumpPastSplash(tester);

        router.go('/pro');
        await tester.pumpAndSettle();

        expect(find.text(_tFr.onboarding.wizardTitle), findsNothing);
        expect(find.text(_tFr.auth.roleTitle), findsOneWidget);
      },
    );
  });

  group('FM-23 — réglages relogés sur l’onglet Profil', () {
    testWidgets('le bouton thème (onglet Profil) bascule clair ↔ sombre', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp());
      await pumpPastSplash(tester);

      await tester.tap(find.text(_tFr.common.nav.profileTab));
      await tester.pumpAndSettle();

      // Défaut ThemeMode.system → l'icône affiche l'état "clair" (le bouton
      // ne distingue system/light qu'après un premier choix explicite).
      expect(find.byIcon(Icons.light_mode), findsOneWidget);

      await tapIconButton(tester, Icons.light_mode);

      expect(find.byIcon(Icons.dark_mode), findsOneWidget);
    });
  });

  group('FM-03a — bascule de langue en direct', () {
    testWidgets(
      'changer la langue depuis l’onglet Profil affiche les chaînes AR et '
      'bascule en RTL sans redémarrage',
      (tester) async {
        await tester.pumpWidget(buildApp());
        await pumpPastSplash(tester);

        await tester.tap(find.text(_tFr.common.nav.profileTab));
        await tester.pumpAndSettle();

        // `find.widgetWithText(AppBar, ...)` plutôt que `find.text(...)` :
        // le libellé de l'onglet et le titre de l'AppBar sont tous deux
        // « Profil » en français, ambigu pour un simple `find.text`.
        final appBarFr = find.widgetWithText(AppBar, _tFr.profile.title);
        expect(appBarFr, findsOneWidget);
        expect(
          Directionality.of(tester.element(appBarFr)),
          TextDirection.ltr,
        );

        await tapIconButton(tester, Icons.language);

        expect(find.widgetWithText(AppBar, _tFr.profile.title), findsNothing);
        final appBarAr = find.widgetWithText(AppBar, _tAr.profile.title);
        expect(appBarAr, findsOneWidget);
        expect(
          Directionality.of(tester.element(appBarAr)),
          TextDirection.rtl,
        );
      },
    );
  });

  group('FM-03c — miroir des icônes directionnelles', () {
    testWidgets(
      'le chevron de la barre de recherche (accueil client) se miroite en '
      'RTL (AR) et pas en LTR (FR)',
      (tester) async {
        await tester.pumpWidget(buildApp());
        await pumpPastSplash(tester);

        final chevronFinder = find.byIcon(Icons.chevron_right).first;
        final chevronWidget = tester.widget<Icon>(chevronFinder);

        // Regression guard : si l'icône est un jour remplacée par une
        // constante Icons.* sans matchTextDirection, ce test doit échouer
        // avant même de vérifier le rendu.
        expect(chevronWidget.icon!.matchTextDirection, isTrue);
        expect(
          Directionality.of(tester.element(chevronFinder)),
          TextDirection.ltr,
        );

        // L'onglet Rechercher reste monté sous l'IndexedStack du shell — la
        // bascule de langue depuis l'onglet Profil suffit, sans revenir sur
        // l'onglet Rechercher au préalable. `skipOffstage: false` : les
        // Finders ignorent par défaut les descendants d'un `Offstage`
        // (branche inactive du shell), qui n'ont donc plus rien à voir avec
        // la visibilité réelle recherchée ici (état RTL préservé même hors
        // écran).
        await tester.tap(find.text(_tFr.common.nav.profileTab));
        await tester.pumpAndSettle();
        await tapIconButton(tester, Icons.language);

        final chevronFinderAr = find
            .byIcon(Icons.chevron_right, skipOffstage: false)
            .first;
        expect(
          Directionality.of(tester.element(chevronFinderAr)),
          TextDirection.rtl,
        );
      },
    );
  });

  group('FM-01c — polices Manrope + Noto Kufi Arabic', () {
    testWidgets('les 4 poids Manrope (FR) se chargent sans exception', (
      tester,
    ) async {
      const locale = Locale('fr');
      await tester.pumpWidget(
        MaterialApp(
          home: Column(
            children: [
              Text('Aa', style: AppText.body(locale)),
              Text('Aa', style: AppText.bodyStrong(locale)),
              Text('Aa', style: AppText.h2(locale)),
              Text('Aa', style: AppText.display(locale)),
            ],
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'les 4 poids Noto Kufi Arabic (AR) se chargent sans exception',
      (tester) async {
        const locale = Locale('ar');
        await tester.pumpWidget(
          MaterialApp(
            home: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                children: [
                  Text('أب', style: AppText.body(locale)),
                  Text('أب', style: AppText.bodyStrong(locale)),
                  Text('أب', style: AppText.h2(locale)),
                  Text('أب', style: AppText.display(locale)),
                ],
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
      },
    );
  });
}
