import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/widgets/offline_banner.dart';

import 'widget_test_helpers.dart';

void main() {
  group('FM-04e — OfflineBanner', () {
    testWidgets('affiche le message traduit (FR)', (tester) async {
      await tester.pumpWidget(
        ProviderScope(child: themedApp(const OfflineBanner())),
      );

      expect(
        find.text(
          'Tu consultes des résultats enregistrés. Ils seront actualisés au '
          'retour du réseau.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('affiche le message traduit (AR)', (tester) async {
      // `translationsProvider` lit `localeProvider` (état Riverpod), pas
      // `MaterialApp.locale` — les deux doivent être alignés (cf.
      // verified_badge_test.dart).
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            localeProvider.overrideWith((ref) => const Locale('ar')),
          ],
          child: themedApp(const OfflineBanner(), locale: const Locale('ar')),
        ),
      );

      expect(
        find.text(
          'أنت تتصفح نتائج محفوظة. سيتم تحديثها عند عودة الاتصال بالشبكة.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('sans onDismiss, aucun bouton de fermeture', (tester) async {
      await tester.pumpWidget(
        ProviderScope(child: themedApp(const OfflineBanner())),
      );

      expect(find.text('Compris'), findsNothing);
    });

    testWidgets('avec onDismiss, tap sur "Compris" le déclenche', (
      tester,
    ) async {
      var dismissed = false;
      await tester.pumpWidget(
        ProviderScope(
          child: themedApp(OfflineBanner(onDismiss: () => dismissed = true)),
        ),
      );

      expect(find.text('Compris'), findsOneWidget);
      await tester.tap(find.text('Compris'));
      expect(dismissed, isTrue);
    });
  });
}
