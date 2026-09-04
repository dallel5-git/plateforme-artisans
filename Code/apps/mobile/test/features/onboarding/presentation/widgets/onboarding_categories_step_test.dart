import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/core/i18n/translations.g.dart';
import 'package:sanaya/features/onboarding/presentation/widgets/onboarding_categories_step.dart';
import 'package:sanaya/features/search/application/catalog_providers.dart';

CategoryTreeNode _category(String id, String nameFr) => CategoryTreeNode(
  (b) => b
    ..id = id
    ..slug = id
    ..nameFr = nameFr
    ..nameAr = nameFr
    ..descriptionFr = ''
    ..descriptionAr = ''
    ..iconKey = id
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
      locale: const Locale('fr'),
      home: Scaffold(body: child),
    ),
  );
}

Future<void> _pumpTall(WidgetTester tester, Widget widget) async {
  tester.view.physicalSize = const Size(400, 2400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(widget);
}

void main() {
  final t = AppLocale.fr.buildSync();

  testWidgets("Suivant désactivé tant qu'aucune catégorie n'est cochée", (
    tester,
  ) async {
    await _pumpTall(
      tester,
      _wrap(
        OnboardingCategoriesStep(
          initialSelection: const {},
          isSaving: false,
          errorMessage: null,
          onSubmit: (_) {},
        ),
        overrides: [
          categoriesProvider.overrideWith(
            (ref) async => [_category('plomberie', 'Plomberie')],
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(t.onboarding.categoriesEmpty), findsOneWidget);
  });

  testWidgets(
    '🔒 la première catégorie cochée devient automatiquement principale',
    (tester) async {
      // 🔒 NON-RÉGRESSION — le serveur exige exactement un `isPrimary: true`
      // (providers.ts) ; sans cette règle, un envoi avec 0 ou 2 primaires
      // serait rejeté silencieusement pour l'utilisateur.
      Map<String, bool>? submitted;
      await _pumpTall(
        tester,
        _wrap(
          OnboardingCategoriesStep(
            initialSelection: const {},
            isSaving: false,
            errorMessage: null,
            onSubmit: (s) => submitted = s,
          ),
          overrides: [
            categoriesProvider.overrideWith(
              (ref) async => [
                _category('plomberie', 'Plomberie'),
                _category('electricite', 'Électricité'),
              ],
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Plomberie'));
      await tester.pumpAndSettle();

      await tester.tap(find.text(t.onboarding.next));
      await tester.pump();

      expect(submitted, {'plomberie': true});
    },
  );

  testWidgets(
    'changer la catégorie principale via le badge « Principale »',
    (tester) async {
      Map<String, bool>? submitted;
      await _pumpTall(
        tester,
        _wrap(
          OnboardingCategoriesStep(
            initialSelection: const {},
            isSaving: false,
            errorMessage: null,
            onSubmit: (s) => submitted = s,
          ),
          overrides: [
            categoriesProvider.overrideWith(
              (ref) async => [
                _category('plomberie', 'Plomberie'),
                _category('electricite', 'Électricité'),
              ],
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Plomberie'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Électricité'));
      await tester.pumpAndSettle();

      // Les 2 cartes sont sélectionnées : le badge « Principale » apparaît
      // sur chacune (actif sur la première, inactif sur la seconde) — on
      // tape le second pour transférer le statut principal.
      await tester.tap(find.text(t.onboarding.categoriesPrimaryHint).last);
      await tester.pumpAndSettle();

      await tester.tap(find.text(t.onboarding.next));
      await tester.pump();

      expect(submitted, {'plomberie': false, 'electricite': true});
    },
  );

  testWidgets(
    'FM-34b — le plafond FREE (3 catégories) désactive les autres options',
    (tester) async {
      Map<String, bool>? submitted;
      await _pumpTall(
        tester,
        _wrap(
          OnboardingCategoriesStep(
            initialSelection: const {},
            isSaving: false,
            errorMessage: null,
            onSubmit: (s) => submitted = s,
          ),
          overrides: [
            categoriesProvider.overrideWith(
              (ref) async => [
                _category('plomberie', 'Plomberie'),
                _category('electricite', 'Électricité'),
                _category('peinture', 'Peinture'),
                _category('climatisation', 'Climatisation'),
              ],
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Plomberie'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Électricité'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Peinture'));
      await tester.pumpAndSettle();

      // Une 4ᵉ sélection au-delà du plafond FREE (3) ne doit rien changer.
      await tester.tap(find.text('Climatisation'));
      await tester.pumpAndSettle();

      await tester.tap(find.text(t.onboarding.next));
      await tester.pump();

      expect(submitted, {
        'plomberie': true,
        'electricite': false,
        'peinture': false,
      });
    },
  );
}
