import 'package:flutter/material.dart';
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

/// FM-23 — premier `StatefulShellRoute` du repo : verrouille les 2 garanties
/// qui justifient `IndexedStack` plutôt que des `GoRoute` à plat (préserver
/// l'état d'une branche visitée) et le comportement de retour arrière
/// Android à 4 onglets décrit dans les critères d'acceptation de l'issue.
void main() {
  final t = AppLocale.fr.buildSync();

  setUp(() => router.go('/'));

  Future<void> pumpPastSplash(WidgetTester tester) async {
    await tester.pump();
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  Widget buildApp() {
    final authTokenStore = _MockAuthTokenStore();
    when(authTokenStore.restoreSession).thenAnswer((_) async => false);

    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(_MockAuthRepository()),
        authTokenStoreProvider.overrideWithValue(authTokenStore),
        categoriesProvider.overrideWith((ref) async => const []),
        governoratesProvider.overrideWith((ref) async => const []),
      ],
      child: const SanayaApp(),
    );
  }

  testWidgets(
    '🔒 changer d’onglet préserve l’état de la branche Rechercher '
    '(IndexedStack, pas de reconstruction)',
    (tester) async {
      await tester.pumpWidget(buildApp());
      await pumpPastSplash(tester);

      await tester.enterText(find.byType(TextField), 'Plombier Sousse');
      await tester.pump();
      expect(find.text('Plombier Sousse'), findsOneWidget);

      await tester.tap(find.text(t.common.nav.favoritesTab));
      await tester.pumpAndSettle();
      await tester.tap(find.text(t.common.nav.searchTab));
      await tester.pumpAndSettle();

      expect(find.text('Plombier Sousse'), findsOneWidget);
    },
  );

  testWidgets(
    'retour arrière Android depuis un onglet secondaire revient à '
    'Rechercher avant de quitter l’app',
    (tester) async {
      await tester.pumpWidget(buildApp());
      await pumpPastSplash(tester);

      await tester.tap(find.text(t.common.nav.favoritesTab));
      await tester.pumpAndSettle();
      expect(find.text(t.search.categoriesTitle), findsNothing);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(find.text(t.search.categoriesTitle), findsOneWidget);
    },
  );

  testWidgets(
    'retour arrière Android depuis Rechercher affiche une confirmation '
    'avant de quitter (double-retour)',
    (tester) async {
      await tester.pumpWidget(buildApp());
      await pumpPastSplash(tester);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(find.text(t.common.nav.exitConfirmation), findsOneWidget);
      // Toujours sur Rechercher — le 1er retour n'a pas quitté l'app.
      expect(find.text(t.search.categoriesTitle), findsOneWidget);
    },
  );
}
