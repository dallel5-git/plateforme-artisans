import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sanaya/core/widgets/empty_state.dart';

import 'widget_test_helpers.dart';

void main() {
  group('FM-04e — EmptyState', () {
    testWidgets("affiche icône, titre, message et bouton d'action", (
      tester,
    ) async {
      var tapped = false;
      await tester.pumpWidget(
        themedApp(
          EmptyState(
            icon: '🔍',
            title: 'Aucun artisan trouvé',
            message: 'Aucun plombier disponible à Mahdia pour ces filtres.',
            actionLabel: 'Élargir au gouvernorat',
            onAction: () => tapped = true,
          ),
        ),
      );

      expect(find.text('🔍'), findsOneWidget);
      expect(find.text('Aucun artisan trouvé'), findsOneWidget);
      expect(
        find.text('Aucun plombier disponible à Mahdia pour ces filtres.'),
        findsOneWidget,
      );
      expect(find.text('Élargir au gouvernorat'), findsOneWidget);

      await tester.tap(find.text('Élargir au gouvernorat'));
      expect(tapped, isTrue);
    });

    testWidgets('sans actionLabel, aucun bouton affiché', (tester) async {
      await tester.pumpWidget(
        themedApp(
          const EmptyState(
            icon: '🔍',
            title: 'Aucun résultat',
            message: 'Rien à afficher.',
          ),
        ),
      );

      expect(find.byType(TextButton), findsNothing);
      expect(find.byType(InkWell), findsNothing);
    });
  });
}
