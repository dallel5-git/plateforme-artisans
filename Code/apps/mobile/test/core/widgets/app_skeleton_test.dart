import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sanaya/core/widgets/app_skeleton.dart';

import 'widget_test_helpers.dart';

void main() {
  group('FM-04e — AppSkeleton', () {
    testWidgets('rectangle : largeur/hauteur/rayon appliqués', (
      tester,
    ) async {
      await tester.pumpWidget(themedApp(const AppSkeleton(width: 140)));

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.constraints?.maxWidth, 140);
      expect(container.constraints?.maxHeight, 16);
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.shape, BoxShape.rectangle);
      expect(decoration.borderRadius, isNotNull);
    });

    testWidgets('.circle : forme circulaire, largeur = hauteur', (
      tester,
    ) async {
      await tester.pumpWidget(
        themedApp(const AppSkeleton.circle(size: 48)),
      );

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.constraints?.maxWidth, 48);
      expect(container.constraints?.maxHeight, 48);
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.shape, BoxShape.circle);
    });
  });
}
