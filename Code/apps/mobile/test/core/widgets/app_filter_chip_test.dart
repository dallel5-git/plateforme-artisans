import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/widgets/app_filter_chip.dart';

import 'widget_test_helpers.dart';

void main() {
  group('FM-27a — AppFilterChip', () {
    testWidgets('affiche le libellé', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: themedApp(
            const AppFilterChip(label: 'Vérifié', selected: false),
          ),
        ),
      );

      expect(find.text('Vérifié'), findsOneWidget);
    });

    testWidgets('état inactif : contour, pas de remplissage', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: themedApp(
            const AppFilterChip(label: 'Vérifié', selected: false),
          ),
        ),
      );

      final context = tester.element(find.text('Vérifié'));
      final colors = context.colors;
      final decoration =
          tester.widget<Container>(find.byType(Container)).decoration!
              as BoxDecoration;

      expect(decoration.color, Colors.transparent);
      expect(decoration.border, Border.all(color: colors.border));
    });

    testWidgets('état actif : fond accent plein, sans contour', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: themedApp(
            const AppFilterChip(label: 'Vérifié', selected: true),
          ),
        ),
      );

      final context = tester.element(find.text('Vérifié'));
      final colors = context.colors;
      final decoration =
          tester.widget<Container>(find.byType(Container)).decoration!
              as BoxDecoration;

      expect(decoration.color, colors.accent);
      expect(decoration.border, isNull);
    });

    testWidgets('tap déclenche onTap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        ProviderScope(
          child: themedApp(
            AppFilterChip(
              label: 'Note 4+',
              selected: false,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(AppFilterChip));
      expect(tapped, isTrue);
    });

    testWidgets('se rend sans exception en arabe (RTL)', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: themedApp(
            const AppFilterChip(label: 'عاجل', selected: true),
            locale: const Locale('ar'),
          ),
        ),
      );

      expect(find.text('عاجل'), findsOneWidget);
    });
  });
}
