import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/widgets/app_selectable_card.dart';

import 'widget_test_helpers.dart';

void main() {
  group('FM-41b — AppSelectableCard', () {
    testWidgets('affiche le contenu fourni', (tester) async {
      await tester.pumpWidget(
        themedApp(
          Scaffold(
            body: AppSelectableCard(
              selected: false,
              onTap: () {},
              child: const Text('Plomberie'),
            ),
          ),
        ),
      );

      expect(find.text('Plomberie'), findsOneWidget);
    });

    testWidgets("non sélectionnée : fond surface, pas d'icône check", (
      tester,
    ) async {
      await tester.pumpWidget(
        themedApp(
          Scaffold(
            body: AppSelectableCard(
              selected: false,
              onTap: () {},
              child: const Text('Plomberie'),
            ),
          ),
        ),
      );

      final context = tester.element(find.text('Plomberie'));
      final colors = context.colors;
      final decoration =
          tester.widget<Container>(find.byType(Container)).decoration!
              as BoxDecoration;

      expect(decoration.color, colors.surface);
      expect(find.byIcon(Icons.check_circle), findsNothing);
    });

    testWidgets('sélectionnée : fond accentSubtle, icône check visible', (
      tester,
    ) async {
      await tester.pumpWidget(
        themedApp(
          Scaffold(
            body: AppSelectableCard(
              selected: true,
              onTap: () {},
              child: const Text('Plomberie'),
            ),
          ),
        ),
      );

      final context = tester.element(find.text('Plomberie'));
      final colors = context.colors;
      final decoration =
          tester.widget<Container>(find.byType(Container)).decoration!
              as BoxDecoration;

      expect(decoration.color, colors.accentSubtle);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('indicator radio : visible dans les deux états', (
      tester,
    ) async {
      await tester.pumpWidget(
        themedApp(
          Scaffold(
            body: AppSelectableCard(
              selected: false,
              onTap: () {},
              indicator: AppSelectableCardIndicator.radio,
              child: const Text('24h'),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.radio_button_off), findsOneWidget);
    });

    testWidgets('indicator none : aucune icône', (tester) async {
      await tester.pumpWidget(
        themedApp(
          Scaffold(
            body: AppSelectableCard(
              selected: true,
              onTap: () {},
              indicator: AppSelectableCardIndicator.none,
              child: const Text('Plomberie'),
            ),
          ),
        ),
      );

      expect(find.byType(Icon), findsNothing);
    });

    testWidgets("trailing personnalisé remplace l'indicateur", (tester) async {
      await tester.pumpWidget(
        themedApp(
          Scaffold(
            body: AppSelectableCard(
              selected: true,
              onTap: () {},
              trailing: const Icon(Icons.star),
              child: const Text('Plomberie'),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsNothing);
    });

    testWidgets('enabled: false désactive le tap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        themedApp(
          Scaffold(
            body: AppSelectableCard(
              selected: false,
              enabled: false,
              onTap: () => tapped = true,
              child: const Text('Plomberie'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Plomberie'));
      await tester.pump();

      expect(tapped, isFalse);
    });

    testWidgets('enabled: true (défaut) déclenche onTap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        themedApp(
          Scaffold(
            body: AppSelectableCard(
              selected: false,
              onTap: () => tapped = true,
              child: const Text('Plomberie'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Plomberie'));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('accentColor personnalisé (ex. amber FM-40)', (tester) async {
      await tester.pumpWidget(
        themedApp(
          Scaffold(
            body: AppSelectableCard(
              selected: true,
              onTap: () {},
              accentColor: Colors.amber,
              selectedBackground: Colors.amber.withValues(alpha: 0.12),
              child: const Text('24h'),
            ),
          ),
        ),
      );

      final decoration =
          tester.widget<Container>(find.byType(Container)).decoration!
              as BoxDecoration;

      expect(decoration.color, Colors.amber.withValues(alpha: 0.12));
      expect(decoration.border, Border.all(color: Colors.amber));
    });
  });
}
