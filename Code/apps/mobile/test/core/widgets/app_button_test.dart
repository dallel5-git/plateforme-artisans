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

    testWidgets(
      "dans un Wrap, chaque bouton s'ajuste à son contenu et ne force pas "
      'la pleine largeur (régression fix/FM-04a-app-button-shrinkwrap)',
      (tester) async {
        // `Container(alignment: Alignment.center)` s'étend pour remplir tout
        // l'espace dès que le parent lui donne des contraintes bornées —
        // c'est le cas dans un `Wrap` — au lieu de s'ajuster à son contenu.
        // Repéré à l'écran vitrine sur device réel : les 6 boutons
        // s'empilaient un par ligne au lieu de se placer côte à côte.
        await tester.pumpWidget(
          themedApp(
            Center(
              child: SizedBox(
                width: 400,
                child: Wrap(
                  spacing: 8,
                  children: [
                    AppButton(label: 'A', onPressed: () {}),
                    AppButton(label: 'B', onPressed: () {}),
                  ],
                ),
              ),
            ),
          ),
        );

        final sizeA = tester.getSize(find.widgetWithText(AppButton, 'A'));
        final sizeB = tester.getSize(find.widgetWithText(AppButton, 'B'));

        expect(sizeA.width, lessThan(200));
        expect(sizeB.width, lessThan(200));
        // Les deux boutons tiennent sur la même ligne : leurs boîtes ne se
        // chevauchent pas verticalement.
        final topA = tester.getTopLeft(find.widgetWithText(AppButton, 'A')).dy;
        final topB = tester.getTopLeft(find.widgetWithText(AppButton, 'B')).dy;
        expect(topA, topB);
      },
    );

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

    testWidgets(
      'FM-30 — outlineWhatsapp : fond transparent et bordure verte, '
      'contrairement à whatsapp (fond plein)',
      (tester) async {
        await tester.pumpWidget(
          themedApp(
            const AppButton(
              label: 'WhatsApp',
              onPressed: null,
              variant: AppButtonVariant.outlineWhatsapp,
            ),
          ),
        );

        final ink = tester.widget<Ink>(find.byType(Ink));
        final decoration = ink.decoration! as BoxDecoration;

        expect(decoration.color, Colors.transparent);
        expect(decoration.border, isNotNull);
      },
    );
  });
}
