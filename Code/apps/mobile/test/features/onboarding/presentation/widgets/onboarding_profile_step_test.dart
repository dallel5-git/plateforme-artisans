import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/core/i18n/translations.g.dart';
import 'package:sanaya/core/widgets/app_text_field.dart';
import 'package:sanaya/features/onboarding/presentation/widgets/onboarding_profile_step.dart';
import 'package:sanaya/features/search/application/catalog_providers.dart';
import 'package:sanaya/features/search/data/catalog_repository.dart';

Governorate _governorate(String id, String nameFr) => Governorate(
  (b) => b
    ..id = id
    ..code = id
    ..nameFr = nameFr
    ..nameAr = nameFr
    ..slug = id
    ..latitude = 0
    ..longitude = 0
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

/// L'étape profil empile 6 champs + le sélecteur de gouvernorat + le
/// bouton Suivant : plus grand que la taille de surface par défaut du
/// test, ce qui laisse `ListView` (paresseux) ne pas construire le bouton
/// tant qu'il reste hors de la zone visible. Élargit la surface plutôt que
/// de scroller à chaque test.
Future<void> _pumpTall(WidgetTester tester, Widget widget) async {
  tester.view.physicalSize = const Size(400, 2400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(widget);
}

void main() {
  final t = AppLocale.fr.buildSync();

  testWidgets(
    "Suivant reste désactivé sans nom d'activité ni gouvernorat",
    (tester) async {
      ProfileStepValues? submitted;
      await _pumpTall(
        tester,
        _wrap(
          OnboardingProfileStep(
            initialProfile: null,
            isSaving: false,
            errorMessage: null,
            onSubmit: (v) => submitted = v,
          ),
          overrides: [
            governoratesProvider.overrideWith(
              (ref) async => [_governorate('sousse', 'Sousse')],
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text(t.onboarding.next));
      await tester.pump();

      expect(submitted, isNull);
    },
  );

  testWidgets(
    '🔒 Suivant relaie businessName + baseGovernorateId une fois remplis',
    (tester) async {
      ProfileStepValues? submitted;
      await _pumpTall(
        tester,
        _wrap(
          OnboardingProfileStep(
            initialProfile: null,
            isSaving: false,
            errorMessage: null,
            onSubmit: (v) => submitted = v,
          ),
          overrides: [
            governoratesProvider.overrideWith(
              (ref) async => [_governorate('sousse', 'Sousse')],
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(AppTextField, t.onboarding.profileBusinessName),
        'Ahmed Plomberie',
      );
      await tester.pump();

      await tester.tap(find.text(t.onboarding.profileGovernorate));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sousse'));
      await tester.pumpAndSettle();

      await tester.tap(find.text(t.onboarding.next));
      await tester.pump();

      expect(submitted, isNotNull);
      expect(submitted!.businessName, 'Ahmed Plomberie');
      expect(submitted!.baseGovernorateId, 'sousse');
    },
  );

  testWidgets('affiche les champs du formulaire', (tester) async {
    await _pumpTall(
      tester,
      _wrap(
        OnboardingProfileStep(
          initialProfile: null,
          isSaving: false,
          errorMessage: null,
          onSubmit: (_) {},
        ),
        overrides: [governoratesProvider.overrideWith((ref) async => [])],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(t.onboarding.profileBusinessName), findsOneWidget);
  });

  testWidgets(
    'FM-38b : submitLabel remplace le libellé « Suivant » par défaut',
    (tester) async {
      await _pumpTall(
        tester,
        _wrap(
          OnboardingProfileStep(
            initialProfile: null,
            isSaving: false,
            errorMessage: null,
            onSubmit: (_) {},
            submitLabel: 'Enregistrer',
          ),
          overrides: [governoratesProvider.overrideWith((ref) async => [])],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Enregistrer'), findsOneWidget);
      expect(find.text(t.onboarding.next), findsNothing);
    },
  );

  testWidgets('affiche errorMessage quand fourni', (tester) async {
    await _pumpTall(
      tester,
      _wrap(
        OnboardingProfileStep(
          initialProfile: null,
          isSaving: false,
          errorMessage: 'oups',
          onSubmit: (_) {},
        ),
        overrides: [governoratesProvider.overrideWith((ref) async => [])],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('oups'), findsOneWidget);
  });
}
