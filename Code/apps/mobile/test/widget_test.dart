import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sanaya/app/router.dart';
import 'package:sanaya/core/i18n/translations.g.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/features/search/application/catalog_providers.dart';
import 'package:sanaya/main.dart';

final Translations _tFr = AppLocale.fr.buildSync();
final Translations _tAr = AppLocale.ar.buildSync();

void main() {
  // `router` (lib/app/router.dart) est un singleton top-level — son état de
  // navigation survit d'un test à l'autre dans le même isolate. On revient
  // explicitement à '/' avant chaque test qui suppose partir de l'accueil.
  setUp(() => router.go('/'));

  group("FM-01d — écran d'accueil, thème, navigation", () {
    testWidgets('affiche le titre et les 3 boutons de navigation', (
      tester,
    ) async {
      await tester.pumpWidget(const ProviderScope(child: SanayaApp()));
      await tester.pumpAndSettle();

      expect(find.text(_tFr.common.appName), findsOneWidget);
      expect(find.text(_tFr.common.home.navAuth), findsOneWidget);
      expect(find.text(_tFr.common.home.navClient), findsOneWidget);
      expect(find.text(_tFr.common.home.navPro), findsOneWidget);
    });

    testWidgets(
      "le bouton /auth mène à l'écran de sélection de rôle (FM-05c), "
      'pas à un placeholder',
      (tester) async {
        router.go('/');
        await tester.pumpWidget(const ProviderScope(child: SanayaApp()));
        await tester.pumpAndSettle();

        await tester.tap(find.text(_tFr.common.home.navAuth));
        await tester.pumpAndSettle();

        expect(find.text(_tFr.common.home.navAuth), findsNothing);
        expect(find.text(_tFr.auth.roleTitle), findsOneWidget);
      },
    );

    testWidgets(
      "le bouton /client mène à l'accueil client (FM-06), pas à un "
      'placeholder',
      (tester) async {
        router.go('/');
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              categoriesProvider.overrideWith((ref) async => const []),
              governoratesProvider.overrideWith((ref) async => const []),
            ],
            child: const SanayaApp(),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text(_tFr.common.home.navClient));
        await tester.pumpAndSettle();

        expect(find.text(_tFr.common.home.navClient), findsNothing);
        expect(find.text(_tFr.search.categoriesTitle), findsOneWidget);
      },
    );

    testWidgets(
      "le bouton /pro mène à l'assistant d'onboarding (FM-11c), pas à un "
      'placeholder',
      (tester) async {
        router.go('/');
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              categoriesProvider.overrideWith((ref) async => const []),
              governoratesProvider.overrideWith((ref) async => const []),
            ],
            child: const SanayaApp(),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text(_tFr.common.home.navPro));
        await tester.pumpAndSettle();

        expect(find.text(_tFr.common.home.navPro), findsNothing);
        expect(find.text(_tFr.onboarding.wizardTitle), findsOneWidget);
      },
    );

    testWidgets('le bouton thème bascule clair ↔ sombre', (tester) async {
      await tester.pumpWidget(const ProviderScope(child: SanayaApp()));
      await tester.pumpAndSettle();

      // Défaut ThemeMode.system → l'icône affiche l'état "clair" (le bouton
      // ne distingue system/light qu'après un premier choix explicite).
      expect(find.byIcon(Icons.light_mode), findsOneWidget);

      await tester.tap(find.byIcon(Icons.light_mode));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.dark_mode), findsOneWidget);
    });
  });

  group('FM-03a — bascule de langue en direct', () {
    testWidgets(
      'changer la langue affiche les chaînes AR et bascule en RTL '
      'sans redémarrage',
      (tester) async {
        await tester.pumpWidget(const ProviderScope(child: SanayaApp()));
        await tester.pumpAndSettle();

        expect(find.text(_tFr.common.home.navAuth), findsOneWidget);
        expect(
          Directionality.of(
            tester.element(find.text(_tFr.common.home.navAuth)),
          ),
          TextDirection.ltr,
        );

        await tester.tap(find.byIcon(Icons.language));
        await tester.pumpAndSettle();

        expect(find.text(_tFr.common.home.navAuth), findsNothing);
        expect(find.text(_tAr.common.home.navAuth), findsOneWidget);
        expect(
          Directionality.of(
            tester.element(find.text(_tAr.common.home.navAuth)),
          ),
          TextDirection.rtl,
        );
      },
    );
  });

  group('FM-03c — miroir des icônes directionnelles', () {
    testWidgets(
      'le chevron des boutons de navigation se miroite en RTL (AR) et '
      'pas en LTR (FR)',
      (tester) async {
        await tester.pumpWidget(const ProviderScope(child: SanayaApp()));
        await tester.pumpAndSettle();

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
        expect(
          find.descendant(of: chevronFinder, matching: find.byType(Transform)),
          findsNothing,
        );

        await tester.tap(find.byIcon(Icons.language));
        await tester.pumpAndSettle();

        final chevronFinderAr = find.byIcon(Icons.chevron_right).first;
        expect(
          Directionality.of(tester.element(chevronFinderAr)),
          TextDirection.rtl,
        );
        expect(
          find.descendant(
            of: chevronFinderAr,
            matching: find.byType(Transform),
          ),
          findsOneWidget,
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
      (
        tester,
      ) async {
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
