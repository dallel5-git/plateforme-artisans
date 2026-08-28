import 'package:flutter_test/flutter_test.dart';

import 'package:sanaya/core/widgets/error_state.dart';

import 'widget_test_helpers.dart';

void main() {
  group('FM-04e — ErrorState', () {
    testWidgets('affiche icône, titre, message et bouton Réessayer', (
      tester,
    ) async {
      var tapped = false;
      await tester.pumpWidget(
        themedApp(
          ErrorState(
            icon: '⚠️',
            title: 'Connexion perdue',
            message:
                'Impossible de charger les résultats. Vérifie ta connexion.',
            actionLabel: 'Réessayer',
            onAction: () => tapped = true,
          ),
        ),
      );

      expect(find.text('⚠️'), findsOneWidget);
      expect(find.text('Connexion perdue'), findsOneWidget);
      expect(find.text('Réessayer'), findsOneWidget);

      await tester.tap(find.text('Réessayer'));
      expect(tapped, isTrue);
    });

    testWidgets('sans actionLabel, aucun bouton affiché', (tester) async {
      await tester.pumpWidget(
        themedApp(
          const ErrorState(
            icon: '⚠️',
            title: 'Erreur',
            message: 'Quelque chose a échoué.',
          ),
        ),
      );

      expect(find.text('Réessayer'), findsNothing);
    });
  });
}
