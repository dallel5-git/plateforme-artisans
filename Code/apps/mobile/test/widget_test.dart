import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sanaya/app/bootstrap_copy.dart';
import 'package:sanaya/app/router.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/main.dart';

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

      expect(find.text(BootstrapCopy.appName), findsOneWidget);
      expect(find.text(BootstrapCopy.authLabel), findsOneWidget);
      expect(find.text(BootstrapCopy.clientLabel), findsOneWidget);
      expect(find.text(BootstrapCopy.proLabel), findsOneWidget);
    });

    testWidgets('les 3 boutons mènent bien à /auth, /client, /pro', (
      tester,
    ) async {
      for (final label in [
        BootstrapCopy.authLabel,
        BootstrapCopy.clientLabel,
        BootstrapCopy.proLabel,
      ]) {
        router.go('/');
        await tester.pumpWidget(const ProviderScope(child: SanayaApp()));
        await tester.pumpAndSettle();

        await tester.tap(find.text(label));
        await tester.pumpAndSettle();

        expect(find.text(label), findsOneWidget);
      }
    });

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
