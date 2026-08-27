import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sanaya/core/widgets/rating_stars.dart';

import 'widget_test_helpers.dart';

void main() {
  group('FM-04c — RatingStars', () {
    testWidgets('4,8 arrondit à 5 étoiles pleines et affiche la note + avis', (
      tester,
    ) async {
      await tester.pumpWidget(
        themedApp(const RatingStars(rating: 4.8, reviewCount: 63)),
      );

      expect(find.byIcon(Icons.star), findsNWidgets(5));
      expect(find.byIcon(Icons.star_border), findsNothing);
      expect(find.text('4,8 (63)'), findsOneWidget);
    });

    testWidgets('4,2 arrondit à 4 étoiles pleines et 1 vide', (tester) async {
      await tester.pumpWidget(themedApp(const RatingStars(rating: 4.2)));

      expect(find.byIcon(Icons.star), findsNWidgets(4));
      expect(find.byIcon(Icons.star_border), findsNWidgets(1));
      expect(find.text('4,2'), findsOneWidget);
    });

    testWidgets('sans reviewCount, seule la note est affichée', (
      tester,
    ) async {
      await tester.pumpWidget(themedApp(const RatingStars(rating: 3)));

      expect(find.text('3,0'), findsOneWidget);
    });
  });
}
