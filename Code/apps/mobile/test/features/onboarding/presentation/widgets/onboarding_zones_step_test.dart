import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/core/i18n/translations.g.dart';
import 'package:sanaya/features/onboarding/presentation/widgets/onboarding_zones_step.dart';
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

Future<void> _pumpTall(WidgetTester tester, Widget widget) async {
  tester.view.physicalSize = const Size(400, 2400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(widget);
}

void main() {
  final t = AppLocale.fr.buildSync();

  testWidgets("Suivant désactivé tant qu'aucune zone n'est cochée", (
    tester,
  ) async {
    await _pumpTall(
      tester,
      _wrap(
        OnboardingZonesStep(
          initialSelection: const {},
          isSaving: false,
          errorMessage: null,
          onSubmit: (_) {},
        ),
        overrides: [
          governoratesProvider.overrideWith(
            (ref) async => [_governorate('sousse', 'Sousse')],
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(t.onboarding.zonesEmpty), findsOneWidget);
  });

  testWidgets(
    'Suivant relaie les gouvernorats cochés '
    '(délégation omise = tout le gouvernorat)',
    (tester) async {
      Set<String>? submitted;
      await _pumpTall(
        tester,
        _wrap(
          OnboardingZonesStep(
            initialSelection: const {},
            isSaving: false,
            errorMessage: null,
            onSubmit: (s) => submitted = s,
          ),
          overrides: [
            governoratesProvider.overrideWith(
              (ref) async => [
                _governorate('sousse', 'Sousse'),
                _governorate('sfax', 'Sfax'),
              ],
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Checkbox).first);
      await tester.pumpAndSettle();

      await tester.tap(find.text(t.onboarding.next));
      await tester.pump();

      expect(submitted, {'sousse'});
    },
  );

  testWidgets('recocher une zone la retire de la sélection', (tester) async {
    Set<String>? submitted;
    await _pumpTall(
      tester,
      _wrap(
        OnboardingZonesStep(
          initialSelection: const {},
          isSaving: false,
          errorMessage: null,
          onSubmit: (s) => submitted = s,
        ),
        overrides: [
          governoratesProvider.overrideWith(
            (ref) async => [_governorate('sousse', 'Sousse')],
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(Checkbox).first);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Checkbox).first);
    await tester.pumpAndSettle();

    expect(find.text(t.onboarding.zonesEmpty), findsOneWidget);
    expect(submitted, isNull);
  });
}
