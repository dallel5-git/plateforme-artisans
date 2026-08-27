import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/features/search/application/catalog_providers.dart';
import 'package:sanaya/features/search/data/catalog_repository.dart';
import 'package:sanaya/features/search/presentation/widgets/governorate_picker_sheet.dart';

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

void main() {
  testWidgets(
    'sélectionner un gouvernorat met à jour selectedGovernorateIdProvider '
    'et ferme la feuille',
    (tester) async {
      final container = ProviderContainer(
        overrides: [
          governoratesProvider.overrideWith(
            (ref) async => [_governorate('sousse', 'Sousse')],
          ),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: buildTheme(
              brightness: Brightness.light,
              locale: const Locale('fr'),
            ),
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () => showGovernoratePicker(context),
                  child: const Text('ouvrir'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('ouvrir'));
      await tester.pumpAndSettle();

      expect(find.text('Sousse'), findsOneWidget);

      await tester.tap(find.text('Sousse'));
      await tester.pumpAndSettle();

      expect(container.read(selectedGovernorateIdProvider), 'sousse');
      expect(find.text('Sousse'), findsNothing);
    },
  );
}
