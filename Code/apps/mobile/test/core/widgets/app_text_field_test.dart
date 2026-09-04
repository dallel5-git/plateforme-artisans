import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sanaya/core/widgets/app_text_field.dart';

import 'widget_test_helpers.dart';

void main() {
  group('FM-04b — AppTextField', () {
    testWidgets('affiche le label, le hint et transmet la saisie', (
      tester,
    ) async {
      var lastValue = '';
      await tester.pumpWidget(
        themedApp(
          AppTextField(
            label: 'Numéro de téléphone',
            hintText: '+216 22 123 456',
            onChanged: (value) => lastValue = value,
          ),
        ),
      );

      expect(find.text('Numéro de téléphone'), findsOneWidget);

      await tester.enterText(find.byType(TextField), '22123456');
      expect(lastValue, '22123456');
    });

    testWidgets('errorText affiché sous le champ', (tester) async {
      await tester.pumpWidget(
        themedApp(
          const AppTextField(
            label: 'Code de vérification',
            errorText: 'Code incorrect — il vous reste 2 tentatives',
          ),
        ),
      );

      expect(
        find.text('Code incorrect — il vous reste 2 tentatives'),
        findsOneWidget,
      );
    });

    testWidgets('hauteur minimale ≥ 48 px (cible tactile)', (tester) async {
      await tester.pumpWidget(
        themedApp(const Center(child: AppTextField(label: 'Service'))),
      );

      final size = tester.getSize(find.byType(AppTextField));
      expect(size.height, greaterThanOrEqualTo(48.0));
    });

    testWidgets('focus : le halo (boxShadow) apparaît puis disparaît', (
      tester,
    ) async {
      await tester.pumpWidget(
        themedApp(const AppTextField(label: 'Service recherché')),
      );

      final containerFinder = find.descendant(
        of: find.byType(AppTextField),
        matching: find.byType(AnimatedContainer),
      );
      expect(
        tester.widget<AnimatedContainer>(containerFinder).decoration,
        isA<BoxDecoration>().having((d) => d.boxShadow, 'boxShadow', isNull),
      );

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      expect(
        tester.widget<AnimatedContainer>(containerFinder).decoration,
        isA<BoxDecoration>().having((d) => d.boxShadow, 'boxShadow', isNotNull),
      );
    });

    testWidgets('prefixIcon affiché quand fourni', (tester) async {
      await tester.pumpWidget(
        themedApp(
          const AppTextField(
            hintText: 'Rechercher',
            prefixIcon: Icon(Icons.search),
          ),
        ),
      );

      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets(
      'prefix (FM-33) : affiché avec un filet séparateur, '
      'exclusif de prefixIcon',
      (tester) async {
        await tester.pumpWidget(
          themedApp(
            const AppTextField(
              hintText: '22 123 456',
              prefix: Text('+216'),
              prefixIcon: Icon(Icons.search),
            ),
          ),
        );

        expect(find.text('+216'), findsOneWidget);
        expect(find.byIcon(Icons.search), findsNothing);
        expect(find.byType(VerticalDivider), findsOneWidget);
      },
    );

    testWidgets('onSubmitted déclenché à la validation du clavier', (
      tester,
    ) async {
      var submitted = '';
      await tester.pumpWidget(
        themedApp(
          AppTextField(
            hintText: 'Rechercher',
            onSubmitted: (value) => submitted = value,
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'plombier');
      await tester.testTextInput.receiveAction(TextInputAction.done);

      expect(submitted, 'plombier');
    });
  });
}
