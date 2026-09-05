import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/widgets/sticky_action_bar.dart';

import 'widget_test_helpers.dart';

void main() {
  group('FM-41d — StickyActionBar', () {
    testWidgets('affiche le contenu fourni', (tester) async {
      await tester.pumpWidget(
        themedApp(
          const Scaffold(
            bottomNavigationBar: StickyActionBar(child: Text('Appeler')),
          ),
        ),
      );

      expect(find.text('Appeler'), findsOneWidget);
    });

    testWidgets('fond surface et filet supérieur border', (tester) async {
      await tester.pumpWidget(
        themedApp(
          const Scaffold(
            bottomNavigationBar: StickyActionBar(child: Text('Appeler')),
          ),
        ),
      );

      final context = tester.element(find.text('Appeler'));
      final colors = context.colors;
      final decoration =
          tester.widget<Container>(find.byType(Container)).decoration!
              as BoxDecoration;

      expect(decoration.color, colors.surface);
      expect(
        decoration.border,
        Border(top: BorderSide(color: colors.border)),
      );
    });

    testWidgets('rendu sans exception en RTL (arabe)', (tester) async {
      await tester.pumpWidget(
        themedApp(
          const Scaffold(
            bottomNavigationBar: StickyActionBar(child: Text('اتصل')),
          ),
          locale: const Locale('ar'),
        ),
      );

      expect(find.text('اتصل'), findsOneWidget);
    });
  });
}
