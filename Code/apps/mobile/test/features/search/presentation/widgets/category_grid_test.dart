import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/features/search/presentation/widgets/category_grid.dart';

CategoryTreeNode _category({
  required String slug,
  required String nameFr,
  required String nameAr,
}) => CategoryTreeNode(
  (b) => b
    ..id = slug
    ..slug = slug
    ..nameFr = nameFr
    ..nameAr = nameAr
    ..descriptionFr = ''
    ..descriptionAr = ''
    ..iconKey = slug
    ..colorHex = '#3B6FE0'
    ..sortOrder = 1,
);

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
    home: Directionality(
      textDirection: locale.languageCode == 'ar'
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(body: child),
    ),
  );
}

void main() {
  final categories = [
    _category(slug: 'plomberie', nameFr: 'Plomberie', nameAr: 'سباكة'),
    _category(slug: 'electricite', nameFr: 'Électricité', nameAr: 'كهرباء'),
  ];

  testWidgets('affiche une tuile par catégorie, libellé FR', (tester) async {
    await tester.pumpWidget(
      _wrap(CategoryGrid(categories: categories, onTap: (_) {})),
    );

    expect(find.text('Plomberie'), findsOneWidget);
    expect(find.text('Électricité'), findsOneWidget);
  });

  testWidgets('affiche le libellé en arabe sous la locale ar', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        CategoryGrid(categories: categories, onTap: (_) {}),
        locale: const Locale('ar'),
      ),
    );

    expect(find.text('سباكة'), findsOneWidget);
    expect(find.text('كهرباء'), findsOneWidget);
  });

  testWidgets('le tap sur une tuile renvoie la bonne catégorie', (
    tester,
  ) async {
    CategoryTreeNode? tapped;
    await tester.pumpWidget(
      _wrap(CategoryGrid(categories: categories, onTap: (c) => tapped = c)),
    );

    await tester.tap(find.text('Électricité'));
    await tester.pumpAndSettle();

    expect(tapped?.slug, 'electricite');
  });

  testWidgets(
    "🔒 la grille est inversée en arabe — critère d'acceptation FM-06",
    (tester) async {
      // 🔒 NON-RÉGRESSION — l'issue FM-06 exige explicitement un « rendu
      // correct en arabe (grille inversée) ». `GridView` suit la
      // `Directionality` ambiante sans code spécifique : ce test verrouille
      // ce comportement plutôt que de le supposer.
      await tester.pumpWidget(
        _wrap(CategoryGrid(categories: categories, onTap: (_) {})),
      );
      final ltrFirstX = tester.getTopLeft(find.text('Plomberie')).dx;
      final ltrSecondX = tester.getTopLeft(find.text('Électricité')).dx;

      await tester.pumpWidget(
        _wrap(
          CategoryGrid(categories: categories, onTap: (_) {}),
          locale: const Locale('ar'),
        ),
      );
      final rtlFirstX = tester.getTopLeft(find.text('سباكة')).dx;
      final rtlSecondX = tester.getTopLeft(find.text('كهرباء')).dx;

      expect(
        ltrFirstX < ltrSecondX,
        isTrue,
        reason: 'en LTR, la 1ère catégorie doit être à gauche',
      );
      expect(
        rtlFirstX > rtlSecondX,
        isTrue,
        reason: 'en RTL, la 1ère catégorie doit être à droite',
      );
    },
  );
}
