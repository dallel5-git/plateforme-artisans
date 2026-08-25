import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sanaya/core/widgets/app_card.dart';

import 'widget_test_helpers.dart';

void main() {
  group('FM-04a — AppCard', () {
    testWidgets('affiche son enfant dans un conteneur stylé', (tester) async {
      await tester.pumpWidget(
        themedApp(const AppCard(child: Text('Contenu de la carte'))),
      );

      expect(find.text('Contenu de la carte'), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('accepte un padding personnalisé', (tester) async {
      await tester.pumpWidget(
        themedApp(
          const AppCard(padding: EdgeInsets.all(4), child: Text('Compact')),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.padding, const EdgeInsets.all(4));
    });
  });
}
