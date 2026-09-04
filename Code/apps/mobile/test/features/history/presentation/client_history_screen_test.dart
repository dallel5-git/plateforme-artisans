import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/features/history/application/contact_history_providers.dart';
import 'package:sanaya/features/history/data/contact_history_repository.dart';
import 'package:sanaya/features/history/presentation/client_history_screen.dart';
import 'package:sanaya/features/history/presentation/widgets/history_entry_card_skeleton.dart';

class _ContactHistoryRepositoryMock extends Mock
    implements ContactHistoryRepository {}

ContactHistoryItem _item(String id, {bool hasReview = false}) =>
    ContactHistoryItem(
      (b) => b
        ..id = id
        ..providerId = 'prov-$id'
        ..slug = 'artisan-$id'
        ..businessName = 'Artisan $id'
        ..categoryName = 'Plombier'
        ..channel = V1ContactEventsGet200ResponseItemsInnerChannelEnum.PHONE
        ..contactedAt = DateTime.utc(2026, 9)
        ..hasReview = hasReview,
    );

/// `GoRouter` avec les 4 branches du shell client réduites à `/client` (page
/// factice) et `/client/history` (l'écran testé), plus `/providers/:slug`
/// pour vérifier la navigation au tap — même patron que
/// `provider_profile_screen_test.dart#_wrapWithRouter`.
({Widget widget, GoRouter router}) _wrapScreen(
  ContactHistoryRepository repository,
) {
  final router = GoRouter(
    initialLocation: '/client/history',
    routes: [
      GoRoute(
        path: '/client/history',
        builder: (_, _) => const ClientHistoryScreen(),
      ),
      GoRoute(
        path: '/providers/:slug',
        name: 'provider-profile',
        builder: (_, _) => const Scaffold(body: Text('provider-screen')),
      ),
    ],
  );

  final widget = ProviderScope(
    overrides: [
      contactHistoryRepositoryProvider.overrideWithValue(repository),
    ],
    child: MaterialApp.router(
      routerConfig: router,
      locale: const Locale('fr'),
      supportedLocales: const [Locale('fr'), Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: buildTheme(
        brightness: Brightness.light,
        locale: const Locale('fr'),
      ),
    ),
  );

  return (widget: widget, router: router);
}

void main() {
  late _ContactHistoryRepositoryMock repository;

  setUp(() {
    repository = _ContactHistoryRepositoryMock();
  });

  group('ClientHistoryScreen', () {
    testWidgets('affiche un skeleton pendant le chargement', (tester) async {
      when(() => repository.fetchHistory()).thenAnswer(
        (_) async {
          await Future<void>.delayed(const Duration(milliseconds: 50));
          return ContactHistoryPage(
            (b) => b
              ..items.add(_item('1'))
              ..nextCursor = '',
          );
        },
      );

      final env = _wrapScreen(repository);
      await tester.pumpWidget(env.widget);
      await tester.pump();

      expect(find.byType(HistoryEntryCardSkeleton), findsWidgets);
      await tester.pumpAndSettle();
    });

    testWidgets(
      "affiche l'état vide avec le CTA « Rechercher » si aucun contact",
      (tester) async {
        when(() => repository.fetchHistory()).thenAnswer(
          (_) async => ContactHistoryPage((b) => b..nextCursor = ''),
        );

        final env = _wrapScreen(repository);
        await tester.pumpWidget(env.widget);
        await tester.pumpAndSettle();

        // Le CTA appelle StatefulNavigationShell.of(context).goBranch(0),
        // qui exige un vrai StatefulShellRoute ambiant (même limite de
        // couverture que favorites_screen_test.dart) — on vérifie l'état
        // vide affiché, pas la navigation déclenchée par le tap.
        expect(find.text('Aucun artisan contacté'), findsOneWidget);
        expect(find.text('Rechercher'), findsOneWidget);
      },
    );

    testWidgets("affiche l'état d'erreur avec un bouton Réessayer", (
      tester,
    ) async {
      var callCount = 0;
      when(() => repository.fetchHistory()).thenAnswer((_) async {
        callCount++;
        if (callCount == 1) {
          throw Exception('Erreur réseau');
        }
        return ContactHistoryPage(
          (b) => b
            ..items.add(_item('1'))
            ..nextCursor = '',
        );
      });

      final env = _wrapScreen(repository);
      await tester.pumpWidget(env.widget);
      await tester.pumpAndSettle();

      expect(find.text('Réessayer'), findsOneWidget);
      expect(
        find.text('Impossible de charger votre historique.'),
        findsOneWidget,
      );

      await tester.tap(find.text('Réessayer'));
      await tester.pumpAndSettle();

      expect(find.text('Artisan 1'), findsOneWidget);
    });

    testWidgets('affiche la liste et navigue vers la fiche artisan au tap', (
      tester,
    ) async {
      when(() => repository.fetchHistory()).thenAnswer(
        (_) async => ContactHistoryPage(
          (b) => b
            ..items.add(_item('1'))
            ..nextCursor = '',
        ),
      );

      final env = _wrapScreen(repository);
      await tester.pumpWidget(env.widget);
      await tester.pumpAndSettle();

      expect(find.text('Artisan 1'), findsOneWidget);

      await tester.tap(find.text('Artisan 1'));
      await tester.pumpAndSettle();

      expect(find.text('provider-screen'), findsOneWidget);
    });

    testWidgets('charge la page suivante en atteignant le bas de la liste', (
      tester,
    ) async {
      when(() => repository.fetchHistory()).thenAnswer(
        (_) async => ContactHistoryPage(
          (b) => b
            ..items.addAll([for (var i = 0; i < 15; i++) _item('$i')])
            ..nextCursor = 'cursor-2',
        ),
      );
      when(() => repository.fetchHistory(cursor: 'cursor-2')).thenAnswer(
        (_) async => ContactHistoryPage(
          (b) => b
            ..items.add(_item('extra'))
            ..nextCursor = '',
        ),
      );

      final env = _wrapScreen(repository);
      await tester.pumpWidget(env.widget);
      await tester.pumpAndSettle();

      await tester.fling(
        find.byType(ListView),
        const Offset(0, -3000),
        3000,
      );
      await tester.pumpAndSettle();

      verify(() => repository.fetchHistory(cursor: 'cursor-2')).called(1);
    });
  });
}
