import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/core/i18n/translations.g.dart';
import 'package:sanaya/features/search/application/catalog_providers.dart';
import 'package:sanaya/features/search/presentation/search_home_screen.dart';
import 'package:sanaya/features/search/presentation/widgets/category_grid_skeleton.dart';

final Translations _t = AppLocale.fr.buildSync();

CategoryTreeNode _category(String slug) => CategoryTreeNode(
  (b) => b
    ..id = slug
    ..slug = slug
    ..nameFr = slug
    ..nameAr = slug
    ..descriptionFr = ''
    ..descriptionAr = ''
    ..iconKey = slug
    ..colorHex = '#3B6FE0'
    ..sortOrder = 1,
);

Widget _wrap(Widget child, {List<Override> overrides = const []}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      theme: buildTheme(
        brightness: Brightness.light,
        locale: const Locale('fr'),
      ),
      home: child,
    ),
  );
}

void main() {
  testWidgets('affiche le skeleton pendant le chargement des catégories', (
    tester,
  ) async {
    final completer = Completer<List<CategoryTreeNode>>();
    await tester.pumpWidget(
      _wrap(
        const SearchHomeScreen(),
        overrides: [
          categoriesProvider.overrideWith((ref) => completer.future),
          governoratesProvider.overrideWith((ref) async => const []),
        ],
      ),
    );

    expect(find.byType(CategoryGridSkeleton), findsOneWidget);

    completer.complete([_category('plomberie')]);
    await tester.pumpAndSettle();
  });

  testWidgets('affiche les catégories une fois chargées', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const SearchHomeScreen(),
        overrides: [
          categoriesProvider.overrideWith(
            (ref) async => [_category('plomberie')],
          ),
          governoratesProvider.overrideWith((ref) async => const []),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('plomberie'), findsOneWidget);
  });

  testWidgets('affiche une erreur et permet de réessayer', (tester) async {
    var attempts = 0;
    await tester.pumpWidget(
      _wrap(
        const SearchHomeScreen(),
        overrides: [
          categoriesProvider.overrideWith((ref) async {
            attempts++;
            if (attempts == 1) throw Exception('réseau indisponible');
            return [_category('plomberie')];
          }),
          governoratesProvider.overrideWith((ref) async => const []),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(_t.search.categoriesError), findsOneWidget);

    await tester.tap(find.text(_t.search.retry));
    await tester.pumpAndSettle();

    expect(find.text('plomberie'), findsOneWidget);
    expect(attempts, 2);
  });

  testWidgets("affiche l'état vide quand l'API ne renvoie aucune catégorie", (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const SearchHomeScreen(),
        overrides: [
          categoriesProvider.overrideWith((ref) async => const []),
          governoratesProvider.overrideWith((ref) async => const []),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(_t.search.categoriesEmpty), findsOneWidget);
  });

  testWidgets(
    "affiche le placeholder de localisation tant qu'aucun gouvernorat "
    "n'est choisi",
    (tester) async {
      await tester.pumpWidget(
        _wrap(
          const SearchHomeScreen(),
          overrides: [
            categoriesProvider.overrideWith((ref) async => const []),
            governoratesProvider.overrideWith((ref) async => const []),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(_t.search.locationPlaceholder), findsOneWidget);
    },
  );
}
