import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/core/api/generated/api.dart';
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
    (tester) async {
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

  testWidgets("affiche l'icône de recherche en préfixe (AppTextField)", (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        SearchHomeBar(t: _t, locationLabel: 'Sousse', onLocationTap: () {}),
      ),
    );

    expect(find.byIcon(Icons.search), findsOneWidget);
  });

  testWidgets('valider le clavier sur le champ déclenche onQuerySubmitted', (
    tester,
  ) async {
    String? submitted;
    await tester.pumpWidget(
      _wrap(
        SearchHomeBar(
          t: _t,
          locationLabel: 'Sousse',
          onLocationTap: () {},
          onQuerySubmitted: (value) => submitted = value,
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'plombier');
    await tester.testTextInput.receiveAction(TextInputAction.done);

    expect(submitted, 'plombier');
  });

  testWidgets('afficher et cliquer sur une suggestion', (tester) async {
    CategoryTreeNode? selected;
    final cat = CategoryTreeNode(
      (b) => b
        ..id = 'plomberie'
        ..slug = 'plomberie'
        ..nameFr = 'Plomberie'
        ..nameAr = 'سباكة'
        ..descriptionFr = ''
        ..descriptionAr = ''
        ..iconKey = 'plumbing'
        ..colorHex = '#0284C7'
        ..sortOrder = 1,
    );

    await tester.pumpWidget(
      _wrap(
        SearchHomeBar(
          t: _t,
          locationLabel: 'Sousse',
          onLocationTap: () {},
          suggestions: [cat],
          onSuggestionTap: (c) => selected = c,
        ),
      ),
    );

    expect(find.text('Plomberie'), findsOneWidget);
    await tester.tap(find.text('Plomberie'));
    expect(selected?.slug, 'plomberie');
  });

  testWidgets('bouton effacer vide le champ', (tester) async {
    final controller = TextEditingController(text: 'plombier');
    await tester.pumpWidget(
      _wrap(
        SearchHomeBar(
          t: _t,
          controller: controller,
          locationLabel: 'Sousse',
          onLocationTap: () {},
        ),
      ),
    );

    expect(find.byIcon(Icons.close), findsOneWidget);
    await tester.tap(find.byIcon(Icons.close));
    await tester.pump();

    expect(controller.text, '');
  });
}
