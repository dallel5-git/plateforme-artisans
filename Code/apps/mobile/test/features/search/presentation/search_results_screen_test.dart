import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/core/connectivity/connectivity_provider.dart';
import 'package:sanaya/core/connectivity/connectivity_service.dart';
import 'package:sanaya/core/widgets/app_filter_chip.dart';
import 'package:sanaya/core/widgets/empty_state.dart';
import 'package:sanaya/core/widgets/error_state.dart';
import 'package:sanaya/core/widgets/provider_card.dart';
import 'package:sanaya/features/search/application/catalog_providers.dart';
import 'package:sanaya/features/search/application/search_providers.dart';
import 'package:sanaya/features/search/data/search_filters.dart';
import 'package:sanaya/features/search/data/search_repository.dart';
import 'package:sanaya/features/search/data/search_results_cache.dart';
import 'package:sanaya/features/search/presentation/search_results_screen.dart';
import 'package:sanaya/features/search/presentation/widgets/search_results_skeleton.dart';

class _SearchRepositoryMock extends Mock implements SearchRepository {}

class _SearchResultsCacheMock extends Mock implements SearchResultsCache {}

class _ConnectivityServiceMock extends Mock implements ConnectivityService {}

class _SearchFiltersFake extends Fake implements SearchFilters {}

class _SearchResultsPageFake extends Fake implements SearchResultsPage {}

SearchResultItem _item(String id) => V1ProvidersSearchGet200ResponseItemsInner(
  (i) => i
    ..id = id
    ..slug = 'artisan-$id'
    ..businessName = 'Artisan $id'
    ..headline = 'Plombier qualifié'
    ..isVerified = true
    ..ratingAvg = 4.8
    ..ratingCount = 12
    ..completionScore = 90
    ..availabilityStatus =
        V1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnum
            .AVAILABLE,
);

SearchResultsPage _page(List<String> ids, {String nextCursor = ''}) =>
    V1ProvidersSearchGet200Response(
      (b) => b
        ..nextCursor = nextCursor
        ..items.addAll(ids.map(_item)),
    );

const _filters = SearchFilters(governorateId: 'sousse');

Widget _wrap(
  Widget child, {
  required List<Override> overrides,
}) {
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

Widget _wrapWithRouter({
  required List<Override> overrides,
  required GoRouter router,
}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp.router(
      routerConfig: router,
      theme: buildTheme(
        brightness: Brightness.light,
        locale: const Locale('fr'),
      ),
    ),
  );
}

void main() {
  late _SearchRepositoryMock repository;
  late _SearchResultsCacheMock cache;
  late _ConnectivityServiceMock connectivity;

  setUpAll(() {
    registerFallbackValue(_SearchFiltersFake());
    registerFallbackValue(_SearchResultsPageFake());
  });

  setUp(() {
    repository = _SearchRepositoryMock();
    cache = _SearchResultsCacheMock();
    connectivity = _ConnectivityServiceMock();

    when(() => connectivity.isOnline).thenReturn(ValueNotifier(true));
    when(
      () => cache.writeFirstPage(any(), any()),
    ).thenAnswer((_) async {});
  });

  testWidgets('affiche le skeleton pendant le chargement initial', (
    tester,
  ) async {
    final completer = Completer<SearchResultsPage>();
    when(() => repository.search(any())).thenAnswer((_) => completer.future);

    await tester.pumpWidget(
      _wrap(
        const SearchResultsScreen(initialFilters: _filters),
        overrides: [
          searchRepositoryProvider.overrideWithValue(repository),
          searchResultsCacheProvider.overrideWithValue(cache),
          connectivityServiceProvider.overrideWithValue(connectivity),
          categoriesProvider.overrideWith((ref) async => const []),
        ],
      ),
    );

    expect(find.byType(SearchResultsSkeleton), findsOneWidget);

    completer.complete(_page(['p1']));
    await tester.pumpAndSettle();
  });

  testWidgets('affiche les ProviderCard après chargement réussi', (
    tester,
  ) async {
    when(() => repository.search(any())).thenAnswer(
      (_) async => _page(['p1', 'p2']),
    );

    await tester.pumpWidget(
      _wrap(
        const SearchResultsScreen(initialFilters: _filters),
        overrides: [
          searchRepositoryProvider.overrideWithValue(repository),
          searchResultsCacheProvider.overrideWithValue(cache),
          connectivityServiceProvider.overrideWithValue(connectivity),
          categoriesProvider.overrideWith((ref) async => const []),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ProviderCard), findsNWidgets(2));
    expect(find.text('Artisan p1'), findsOneWidget);
    expect(find.text('Artisan p2'), findsOneWidget);
  });

  testWidgets('affiche EmptyState quand aucun artisan n’est trouvé', (
    tester,
  ) async {
    when(() => repository.search(any())).thenAnswer((_) async => _page([]));

    await tester.pumpWidget(
      _wrap(
        const SearchResultsScreen(initialFilters: _filters),
        overrides: [
          searchRepositoryProvider.overrideWithValue(repository),
          searchResultsCacheProvider.overrideWithValue(cache),
          connectivityServiceProvider.overrideWithValue(connectivity),
          categoriesProvider.overrideWith((ref) async => const []),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(EmptyState), findsOneWidget);
    expect(find.byType(ProviderCard), findsNothing);
  });

  testWidgets('affiche ErrorState en cas d’échec et recharge au retry', (
    tester,
  ) async {
    when(() => repository.search(any())).thenThrow(Exception('Network error'));
    when(() => cache.readFirstPage(any())).thenAnswer((_) async => null);

    await tester.pumpWidget(
      _wrap(
        const SearchResultsScreen(initialFilters: _filters),
        overrides: [
          searchRepositoryProvider.overrideWithValue(repository),
          searchResultsCacheProvider.overrideWithValue(cache),
          connectivityServiceProvider.overrideWithValue(connectivity),
          categoriesProvider.overrideWith((ref) async => const []),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ErrorState), findsOneWidget);

    // Changement de comportement au retry
    when(() => repository.search(any())).thenAnswer((_) async => _page(['p1']));

    await tester.tap(find.text('Réessayer'));
    await tester.pumpAndSettle();

    expect(find.byType(ProviderCard), findsOneWidget);
  });

  testWidgets(
    'le clic sur les filtres déclenche une nouvelle recherche',
    (tester) async {
    when(() => repository.search(any())).thenAnswer(
      (_) async => _page(['p1']),
    );

    await tester.pumpWidget(
      _wrap(
        const SearchResultsScreen(initialFilters: _filters),
        overrides: [
          searchRepositoryProvider.overrideWithValue(repository),
          searchResultsCacheProvider.overrideWithValue(cache),
          connectivityServiceProvider.overrideWithValue(connectivity),
          categoriesProvider.overrideWith((ref) async => const []),
        ],
      ),
    );
    await tester.pumpAndSettle();

    // Tap sur le filtre "Vérifié" dans AppFilterChip
    await tester.tap(
      find.descendant(
        of: find.byType(AppFilterChip),
        matching: find.text('Vérifié'),
      ),
    );
    await tester.pumpAndSettle();

    verify(
      () => repository.search(
        const SearchFilters(governorateId: 'sousse', isVerified: true),
      ),
    ).called(1);
  });

  testWidgets('le tap sur une ProviderCard navigue vers /providers/:slug', (
    tester,
  ) async {
    when(() => repository.search(any())).thenAnswer(
      (_) async => _page(['p1']),
    );

    final router = GoRouter(
      initialLocation: '/results',
      routes: [
        GoRoute(
          path: '/results',
          builder: (_, _) => const SearchResultsScreen(
            initialFilters: _filters,
          ),
        ),
        GoRoute(
          path: '/providers/:slug',
          name: 'provider-profile',
          builder: (_, state) => Text('slug: ${state.pathParameters['slug']}'),
        ),
      ],
    );

    await tester.pumpWidget(
      _wrapWithRouter(
        router: router,
        overrides: [
          searchRepositoryProvider.overrideWithValue(repository),
          searchResultsCacheProvider.overrideWithValue(cache),
          connectivityServiceProvider.overrideWithValue(connectivity),
          categoriesProvider.overrideWith((ref) async => const []),
        ],
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Artisan p1'));
    await tester.pumpAndSettle();

    expect(find.text('slug: artisan-p1'), findsOneWidget);
  });
}
