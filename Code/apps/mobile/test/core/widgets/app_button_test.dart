import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sanaya/core/widgets/app_button.dart';

import 'widget_test_helpers.dart';

void main() {
  group('FM-04a — AppButton', () {
    testWidgets('affiche le libellé et déclenche onPressed au tap', (
      tester,
    ) async {
      var tapped = false;
      await tester.pumpWidget(
        themedApp(
          AppButton(label: 'Appeler', onPressed: () => tapped = true),
        ),
      );

      expect(find.text('Appeler'), findsOneWidget);
      await tester.tap(find.text('Appeler'));
      expect(tapped, isTrue);
    });

    testWidgets(
      'onPressed null : le bouton est visuellement atténué et ignore le tap',
      (tester) async {
        await tester.pumpWidget(
          themedApp(
            const AppButton(label: 'Publier le profil', onPressed: null),
          ),
        );

        final opacityFinder = find.ancestor(
          of: find.text('Publier le profil'),
          matching: find.byType(Opacity),
        );
        expect(opacityFinder, findsWidgets);
        expect(tester.widget<Opacity>(opacityFinder.first).opacity, 0.45);

        // Ne doit lever aucune exception : `InkWell(onTap: null)` ignore
        // déjà le tap nativement, rien à assertionner de plus ici.
        await tester.tap(find.text('Publier le profil'));
      },
    );

    testWidgets('taille régulière : hauteur minimale ≥ 48 px (cible tactile)', (
      tester,
    ) async {
      await tester.pumpWidget(
        themedApp(
          Center(
            child: AppButton(label: 'Voir le profil', onPressed: () {}),
          ),
        ),
      );

      final size = tester.getSize(find.byType(AppButton));
      expect(size.height, greaterThanOrEqualTo(48.0));
    });

    for (final variant in AppButtonVariant.values) {
      testWidgets('variante $variant se rend sans exception', (tester) async {
        await tester.pumpWidget(
          themedApp(
            AppButton(label: 'Bouton', onPressed: () {}, variant: variant),
          ),
        );

        expect(tester.takeException(), isNull);
      });
    }
  });
}
