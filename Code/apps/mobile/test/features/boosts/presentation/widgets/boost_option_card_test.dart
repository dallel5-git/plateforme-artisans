import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/features/boosts/presentation/widgets/boost_option_card.dart';

import '../../../../core/widgets/widget_test_helpers.dart';

void main() {
  group('FM-40b — BoostOptionCard', () {
    testWidgets('affiche le titre, la description, le prix et le badge', (
      tester,
    ) async {
      await tester.pumpWidget(
        themedApp(
          BoostOptionCard(
            title: 'Boost 24h',
            description: 'Visibilité maximale pendant 24 heures',
            priceLabel: '100 crédits',
            sponsoredLabel: 'Sponsorisé',
            selected: false,
            onTap: () {},
          ),
        ),
      );

      expect(find.text('Boost 24h'), findsOneWidget);
      expect(
        find.text('Visibilité maximale pendant 24 heures'),
        findsOneWidget,
      );
      expect(find.text('100 crédits'), findsOneWidget);
      expect(find.text('Sponsorisé'), findsOneWidget);
      expect(find.byIcon(Icons.radio_button_off), findsOneWidget);
      expect(find.byIcon(Icons.radio_button_checked), findsNothing);
    });

    testWidgets(
      'affiche l icone radio cochee et semantics quand selected=true',
      (tester) async {
        final handle = tester.ensureSemantics();

        await tester.pumpWidget(
          themedApp(
            BoostOptionCard(
              title: 'Boost 7 jours',
              description: 'Visibilité boostée pendant 7 jours',
              priceLabel: '500 crédits',
              sponsoredLabel: 'Sponsorisé',
              selected: true,
              onTap: () {},
            ),
          ),
        );

        expect(find.byIcon(Icons.radio_button_checked), findsOneWidget);
        expect(find.byIcon(Icons.radio_button_off), findsNothing);

        final node = tester.getSemantics(find.byType(BoostOptionCard));
        expect(node.flagsCollection.isSelected, Tristate.isTrue);
        expect(node.flagsCollection.isButton, isTrue);

        handle.dispose();
      },
    );

    testWidgets('appelle onTap lors du clic', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        themedApp(
          BoostOptionCard(
            title: 'Boost 24h',
            description: 'Desc',
            priceLabel: '100 crédits',
            sponsoredLabel: 'Sponsorisé',
            selected: false,
            onTap: () => tapped = true,
          ),
        ),
      );

      await tester.tap(find.byType(BoostOptionCard));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('rendu fidele en dark mode', (tester) async {
      await tester.pumpWidget(
        themedApp(
          BoostOptionCard(
            title: 'Boost 24h',
            description: 'Desc',
            priceLabel: '100 crédits',
            sponsoredLabel: 'Sponsorisé',
            selected: true,
            onTap: () {},
          ),
          brightness: Brightness.dark,
        ),
      );

      expect(tester.takeException(), isNull);
    });
  });
}
