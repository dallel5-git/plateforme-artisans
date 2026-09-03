import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanaya/app/router.dart';
import 'package:sanaya/core/api/api_client_provider.dart';
import 'package:sanaya/core/api/auth_token_store.dart';
import 'package:sanaya/core/i18n/translations.g.dart';
import 'package:sanaya/features/auth/application/auth_providers.dart';
import 'package:sanaya/features/auth/data/auth_repository.dart';
import 'package:sanaya/features/search/application/catalog_providers.dart';
import 'package:sanaya/main.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockAuthTokenStore extends Mock implements AuthTokenStore {}

/// FM-23a — une route inconnue doit afficher `ErrorState` thémé (FR/AR), pas
/// la page anglaise par défaut de go_router.
void main() {
  final t = AppLocale.fr.buildSync();

  setUp(() => router.go('/'));

  /// `SplashScreen` (FM-23) affiche un `CircularProgressIndicator`
  /// indéterminé — `pumpAndSettle()` ne se termine jamais tant qu'il est à
  /// l'écran. On pompe donc un budget de temps borné pour laisser
  /// `authStateProvider` résoudre et `redirect:` faire quitter le splash.
  Future<void> pumpPastSplash(WidgetTester tester) async {
    await tester.pump();
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  testWidgets('route inconnue → ErrorState thémé avec action de retour', (
    tester,
  ) async {
    final authTokenStore = _MockAuthTokenStore();
    when(authTokenStore.restoreSession).thenAnswer((_) async => false);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(_MockAuthRepository()),
          authTokenStoreProvider.overrideWithValue(authTokenStore),
          categoriesProvider.overrideWith((ref) async => const []),
          governoratesProvider.overrideWith((ref) async => const []),
        ],
        child: const SanayaApp(),
      ),
    );
    await pumpPastSplash(tester);

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
