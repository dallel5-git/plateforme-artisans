import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/features/boosts/presentation/widgets/credit_balance_card.dart';

import '../../../../core/widgets/widget_test_helpers.dart';

void main() {
  group('FM-40a — CreditBalanceCard', () {
    testWidgets(
      'affiche le solde par défaut (0 crédits) et le bouton Acheter',
      (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: themedApp(
              const CreditBalanceCard(),
            ),
          ),
        );

        expect(find.text('Solde de crédits'), findsOneWidget);
        expect(find.text('0 crédits'), findsOneWidget);
        expect(find.text('Acheter'), findsOneWidget);
      },
    );

    testWidgets('affiche un solde personnalisé quand fourni', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: themedApp(
            const CreditBalanceCard(creditsCount: 120),
          ),
        ),
      );

      expect(find.text('120 crédits'), findsOneWidget);
    });

    testWidgets(
      'tap sur Acheter ouvre la boîte de dialogue Bientôt disponible',
      (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: themedApp(
              const CreditBalanceCard(),
            ),
          ),
        );

        expect(find.byType(AlertDialog), findsNothing);

        await tester.tap(find.text('Acheter'));
        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('Bientôt disponible'), findsOneWidget);
        expect(find.text('Compris'), findsOneWidget);

        await tester.tap(find.text('Compris'));
        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsNothing);
      },
    );

    testWidgets('custom onBuyPressed est appelé au tap', (tester) async {
      var buyPressed = false;

      await tester.pumpWidget(
        ProviderScope(
          child: themedApp(
            CreditBalanceCard(
              onBuyPressed: () => buyPressed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Acheter'));
      await tester.pump();

      expect(buyPressed, isTrue);
      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('rendu fidèle en arabe (RTL)', (tester) async {
      const locale = Locale('ar');
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            localeProvider.overrideWith((ref) => locale),
          ],
          child: themedApp(
            const CreditBalanceCard(creditsCount: 50),
            locale: locale,
          ),
        ),
      );

      expect(find.text('رصيد النقاط'), findsOneWidget);
      expect(find.text('50 نقاط'), findsOneWidget);
      expect(find.text('شراء'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
