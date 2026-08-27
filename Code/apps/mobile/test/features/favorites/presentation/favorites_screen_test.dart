import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/features/favorites/application/favorites_providers.dart';
import 'package:sanaya/features/favorites/data/favorites_repository.dart';
import 'package:sanaya/features/favorites/presentation/favorites_screen.dart';
import 'package:sanaya/features/favorites/presentation/widgets/favorite_card.dart';
import 'package:sanaya/features/favorites/presentation/widgets/favorite_card_skeleton.dart';

import '../../../core/widgets/widget_test_helpers.dart';

class _FavoritesRepositoryMock extends Mock implements FavoritesRepository {}

void main() {
  late _FavoritesRepositoryMock repository;
  late FavoriteItem sampleItem;

  setUp(() {
    repository = _FavoritesRepositoryMock();
    sampleItem = FavoriteItem(
      (b) => b
        ..providerId = 'prov-1'
        ..slug = 'sami-plombier'
        ..businessName = 'Sami Plomberie'
        ..headline = 'Plombier sanitaire'
        ..isVerified = true
        ..ratingAvg = 4.8
        ..ratingCount = 10
        ..availabilityStatus =
            V1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnum.AVAILABLE
        ..favoritedAt = DateTime.utc(2026, 8, 26),
    );
  });

  Widget buildScreen({
    Locale locale = const Locale('fr'),
  }) {
    return ProviderScope(
      overrides: [
        localeProvider.overrideWith((ref) => locale),
        favoritesRepositoryProvider.overrideWithValue(repository),
      ],
      child: themedApp(
        const FavoritesScreen(),
        locale: locale,
      ),
    );
  }

  group('FavoritesScreen', () {
    testWidgets('affiche les skeletons pendant le chargement', (tester) async {
      final completer = Completer<FavoritesResponse>();
      when(
        () => repository.fetchFavorites(),
      ).thenAnswer((_) => completer.future);

      await tester.pumpWidget(buildScreen());
      await tester.pump();

      expect(find.byType(FavoriteCardSkeleton), findsWidgets);

      completer.complete(
        FavoritesResponse(
          (b) => b
            ..items.add(sampleItem)
            ..nextCursor = '',
        ),
      );
      await tester.pumpAndSettle();
    });

    testWidgets('affiche la vue vide quand aucun favori n’est enregistré', (
      tester,
    ) async {
      when(() => repository.fetchFavorites()).thenAnswer(
        (_) async => FavoritesResponse((b) => b..nextCursor = ''),
      );

      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('Mes favoris'), findsOneWidget);
      expect(find.text('Aucun favori pour le moment'), findsOneWidget);
      expect(find.text('Trouver un artisan'), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    });

    testWidgets(
      'affiche la vue d’erreur et le bouton Réessayer en cas d’échec',
      (
        tester,
      ) async {
        when(
          () => repository.fetchFavorites(),
        ).thenThrow(Exception('Erreur réseau'));

        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();

        expect(find.text('Impossible de charger vos favoris.'), findsOneWidget);
        expect(find.text('Réessayer'), findsOneWidget);

        // Deuxième tentative avec succès
        when(() => repository.fetchFavorites()).thenAnswer(
          (_) async => FavoritesResponse(
            (b) => b
              ..items.add(sampleItem)
              ..nextCursor = '',
          ),
        );

        await tester.tap(find.text('Réessayer'));
        await tester.pumpAndSettle();

        expect(find.byType(FavoriteCard), findsOneWidget);
        expect(find.text('Sami Plomberie'), findsOneWidget);
      },
    );

    testWidgets('affiche la liste des favoris avec succès', (tester) async {
      when(() => repository.fetchFavorites()).thenAnswer(
        (_) async => FavoritesResponse(
          (b) => b
            ..items.add(sampleItem)
            ..nextCursor = '',
        ),
      );

      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.byType(FavoriteCard), findsOneWidget);
      expect(find.text('Sami Plomberie'), findsOneWidget);
    });

    testWidgets(
      'se rend en arabe avec le titre et les boutons traduits (RTL)',
      (
        tester,
      ) async {
        when(() => repository.fetchFavorites()).thenAnswer(
          (_) async => FavoritesResponse((b) => b..nextCursor = ''),
        );

        await tester.pumpWidget(buildScreen(locale: const Locale('ar')));
        await tester.pumpAndSettle();

        expect(find.text('المفضلات'), findsOneWidget);
        expect(find.text('لا توجد عناصر مفضلة حتى الآن'), findsOneWidget);
        expect(find.text('البحث عن حرفي'), findsOneWidget);
      },
    );
  });
}
