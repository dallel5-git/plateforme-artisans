import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/features/provider_profile/presentation/widgets/coverage_area_chip.dart';

Widget _wrap(Widget child, {Locale locale = const Locale('fr')}) {
  return MaterialApp(
    theme: buildTheme(brightness: Brightness.light, locale: locale),
    home: Scaffold(body: child),
  );
}

void main() {
  testWidgets('CoverageAreaChip affiche le libellé de la zone', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(const CoverageAreaChip(label: 'Sousse Ville')),
    );

    expect(find.text('Sousse Ville'), findsOneWidget);
  });
}
