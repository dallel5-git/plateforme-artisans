import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/features/boosts/presentation/boosts_screen.dart';
import 'package:sanaya/features/boosts/presentation/widgets/boost_option_card.dart';

import '../../../core/widgets/widget_test_helpers.dart';

void main() {
  Widget buildScreen({
    Locale locale = const Locale('fr'),
    Brightness brightness = Brightness.light,
  }) {
    return ProviderScope(
      overrides: [localeProvider.overrideWith((ref) => locale)],
      child: themedApp(
        const BoostsScreen(),
        locale: locale,
        brightness: brightness,
      ),
    );
  }

  group('FM-40b — BoostsScreen', () {
    testWidgets('affiche tous les composants et libellés en français', (
      tester,
    ) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      // En-tête AppBar & Segmented Control
      expect(find.text('Boosts'), findsOneWidget);
      expect(find.text('Client'), findsOneWidget);
      expect(find.text('Pro'), findsOneWidget);

      // Solde de crédits
      expect(find.text('Solde de crédits'), findsOneWidget);
      expect(find.text('0 crédits'), findsOneWidget);
      expect(find.text('Acheter'), findsOneWidget);

      // Section options de boost
      expect(find.text('Activer un boost'), findsOneWidget);
      expect(
        find.text(
          'Mettez en avant votre profil en tête des résultats de recherche.',
        ),
        findsOneWidget,
      );

      // Options 24h et 7j
      expect(find.text('Boost 24 heures'), findsOneWidget);
      expect(find.text('10 crédits'), findsOneWidget);
      expect(find.text('Boost 7 jours'), findsOneWidget);
      expect(find.text('500 crédits'), findsNothing);
      expect(find.text('50 crédits'), findsOneWidget);
      expect(find.text('Sponsorisé'), findsNWidgets(2));

      // Bouton CTA
      expect(find.text('Activer le boost'), findsOneWidget);
    });

    testWidgets('sélection par défaut est 24h et bascule vers 7j au clic', (
      tester,
    ) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      final cards = tester
          .widgetList<BoostOptionCard>(
            find.byType(BoostOptionCard),
          )
          .toList();

      expect(cards[0].selected, isTrue);
      expect(cards[1].selected, isFalse);

      // Tap sur la carte 7j
      await tester.tap(find.text('Boost 7 jours'));
      await tester.pumpAndSettle();

      final updatedCards = tester
          .widgetList<BoostOptionCard>(
            find.byType(BoostOptionCard),
          )
          .toList();

      expect(updatedCards[0].selected, isFalse);
      expect(updatedCards[1].selected, isTrue);

      // Re-tap sur la carte 24h
      await tester.tap(find.text('Boost 24 heures'));
      await tester.pumpAndSettle();

      final reUpdatedCards = tester
          .widgetList<BoostOptionCard>(
            find.byType(BoostOptionCard),
          )
          .toList();

      expect(reUpdatedCards[0].selected, isTrue);
      expect(reUpdatedCards[1].selected, isFalse);
    });

    testWidgets('tap sur Activer le boost ouvre la modale Bientôt disponible', (
      tester,
    ) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);

      await tester.tap(find.text('Activer le boost'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Bientôt disponible'), findsOneWidget);

      await tester.tap(find.text('Compris'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('le switch Client du segmented control navigue vers /client', (
      tester,
    ) async {
      final testRouter = GoRouter(
        initialLocation: '/pro/boosts',
        routes: [
          GoRoute(
            path: '/pro/boosts',
            builder: (_, _) => const BoostsScreen(),
          ),
          GoRoute(
            path: '/client',
            builder: (_, _) => const Text('CLIENT_SCREEN'),
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            theme: buildTheme(
              brightness: Brightness.light,
              locale: const Locale('fr'),
            ),
            locale: const Locale('fr'),
            routerConfig: testRouter,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Client'));
      await tester.pumpAndSettle();

      expect(find.text('CLIENT_SCREEN'), findsOneWidget);
    });

    testWidgets('rendu fidèle en arabe RTL', (tester) async {
      const locale = Locale('ar');
      await tester.pumpWidget(buildScreen(locale: locale));
      await tester.pumpAndSettle();

      expect(find.text('حريف'), findsOneWidget);
      expect(find.text('حرفي'), findsOneWidget);
      expect(find.text('رصيد النقاط'), findsOneWidget);
      expect(find.text('تفعيل التعزيز'), findsNWidgets(2));
      expect(find.text('تعزيز 24 ساعة'), findsOneWidget);
      expect(find.text('إعلان ممول'), findsNWidgets(2));
      expect(tester.takeException(), isNull);
    });

    testWidgets('rendu fidèle en dark mode', (tester) async {
      await tester.pumpWidget(buildScreen(brightness: Brightness.dark));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('ADR-002: le mot Vérifié ne figure jamais sur cet écran', (
      tester,
    ) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.textContaining('Vérifié'), findsNothing);
      expect(find.textContaining('vérifié'), findsNothing);
      expect(find.textContaining('Badge'), findsNothing);
    });
  });
}
