import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/core/i18n/translations.g.dart';
import 'package:sanaya/features/search/presentation/widgets/search_home_bar.dart';

final Translations _t = AppLocale.fr.buildSync();

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: buildTheme(brightness: Brightness.light, locale: const Locale('fr')),
    home: Scaffold(body: child),
  );
}

void main() {
  testWidgets(
    'affiche le placeholder de recherche et le libellé de localisation',
    (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          SearchHomeBar(t: _t, locationLabel: 'Sousse', onLocationTap: () {}),
        ),
      );

      expect(find.text(_t.search.searchPlaceholder), findsOneWidget);
      expect(find.text('Sousse'), findsOneWidget);
    },
  );

  testWidgets('taper dans le champ déclenche onQueryChanged', (tester) async {
    String? changed;
    await tester.pumpWidget(
      _wrap(
        SearchHomeBar(
          t: _t,
          locationLabel: 'Sousse',
          onLocationTap: () {},
          onQueryChanged: (value) => changed = value,
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'plombier');

    expect(changed, 'plombier');
  });

  testWidgets('taper sur la localisation déclenche onLocationTap', (
    tester,
  ) async {
    var tapped = false;
    await tester.pumpWidget(
      _wrap(
        SearchHomeBar(
          t: _t,
          locationLabel: 'Sousse',
          onLocationTap: () => tapped = true,
        ),
      ),
    );

    await tester.tap(find.text('Sousse'));

    expect(tapped, isTrue);
  });
}
