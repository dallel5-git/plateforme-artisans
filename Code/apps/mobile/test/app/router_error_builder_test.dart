import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/app/router.dart';
import 'package:sanaya/core/i18n/translations.g.dart';
import 'package:sanaya/features/search/application/catalog_providers.dart';
import 'package:sanaya/main.dart';

/// FM-23a — une route inconnue doit afficher `ErrorState` thémé (FR/AR), pas
/// la page anglaise par défaut de go_router.
void main() {
  final t = AppLocale.fr.buildSync();

  setUp(() => router.go('/'));

  testWidgets('route inconnue → ErrorState thémé avec action de retour', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          categoriesProvider.overrideWith((ref) async => const []),
          governoratesProvider.overrideWith((ref) async => const []),
        ],
        child: const SanayaApp(),
      ),
    );
    await tester.pumpAndSettle();

    router.go('/route-qui-nexiste-pas');
    await tester.pumpAndSettle();

    expect(find.text(t.errors.routeNotFoundTitle), findsOneWidget);
    expect(find.text(t.errors.routeNotFoundMessage), findsOneWidget);

    await tester.tap(find.text(t.errors.routeNotFoundAction));
    await tester.pumpAndSettle();

    expect(find.text(t.errors.routeNotFoundTitle), findsNothing);
    expect(find.text(t.search.categoriesTitle), findsOneWidget);
  });
}
