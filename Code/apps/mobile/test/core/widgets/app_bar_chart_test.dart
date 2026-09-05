import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/core/widgets/app_bar_chart.dart';

/// Enveloppe minimale : pas de Riverpod, pas de dépôt — AppBarChart est un
/// widget générique sans dépendances applicatives.
Widget _wrap(Widget child, {Locale locale = const Locale('fr')}) {
  return MaterialApp(
    locale: locale,
    supportedLocales: const [Locale('fr'), Locale('ar')],
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    theme: buildTheme(brightness: Brightness.light, locale: locale),
    home: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    ),
  );
}

void main() {
  group('AppBarChart — FM-37c', () {
    const values7 = [10, 20, 5, 30, 15, 8, 25];
    const labels7 = ['J-6', 'J-5', 'J-4', 'J-3', 'J-2', 'J-1', 'J'];

    testWidgets(
      'se construit sans erreur avec 7 barres',
      (tester) async {
        await tester.pumpWidget(
          _wrap(
            const AppBarChart(values: values7, labels: labels7),
          ),
        );

        expect(tester.takeException(), isNull);
        expect(find.byType(AppBarChart), findsOneWidget);
      },
    );

    testWidgets(
      "affiche les libellés de l'axe X",
      (tester) async {
        await tester.pumpWidget(
          _wrap(
            const AppBarChart(values: values7, labels: labels7),
          ),
        );

        // Au moins le premier et le dernier libellé doivent être présents.
        expect(find.text('J-6'), findsOneWidget);
        expect(find.text('J'), findsOneWidget);
      },
    );

    testWidgets(
      'dessine un CustomPaint quand les valeurs ne sont pas nulles',
      (tester) async {
        await tester.pumpWidget(
          _wrap(
            const AppBarChart(values: values7, labels: labels7),
          ),
        );

        expect(find.byType(CustomPaint), findsWidgets);
      },
    );

    testWidgets(
      'se construit sans erreur avec toutes les valeurs à zéro',
      (tester) async {
        await tester.pumpWidget(
          _wrap(
            const AppBarChart(
              values: [0, 0, 0, 0, 0, 0, 0],
              labels: labels7,
            ),
          ),
        );

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'se construit sans erreur avec une seule barre',
      (tester) async {
        await tester.pumpWidget(
          _wrap(
            const AppBarChart(
              values: [42],
              labels: ['J'],
            ),
          ),
        );

        expect(tester.takeException(), isNull);
        expect(find.text('J'), findsOneWidget);
      },
    );

    testWidgets(
      'respecte le highlightIndex sans erreur',
      (tester) async {
        await tester.pumpWidget(
          _wrap(
            const AppBarChart(
              values: values7,
              labels: labels7,
              highlightIndex: 6, // dernière barre = jour courant
            ),
          ),
        );

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'se construit avec une hauteur personnalisée',
      (tester) async {
        await tester.pumpWidget(
          _wrap(
            const AppBarChart(
              values: values7,
              labels: labels7,
              height: 200,
            ),
          ),
        );

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
        expect(sizedBox.height, 200);
      },
    );

    testWidgets(
      'se construit correctement en RTL (arabe)',
      (tester) async {
        await tester.pumpWidget(
          _wrap(
            const AppBarChart(values: values7, labels: labels7),
            locale: const Locale('ar'),
          ),
        );

        expect(tester.takeException(), isNull);
      },
    );
  });
}
