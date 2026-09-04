import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/core/widgets/provider_card.dart';
import 'package:sanaya/features/favorites/application/favorites_providers.dart';
import 'package:sanaya/features/favorites/data/favorites_repository.dart';

import 'widget_test_helpers.dart';

class _FavoritesRepositoryMock extends Mock implements FavoritesRepository {}

void main() {
  late _FavoritesRepositoryMock repository;

  setUp(() {
    repository = _FavoritesRepositoryMock();
    when(
      () => repository.fetchFavorites(),
    ).thenAnswer((_) async => FavoritesResponse((b) => b..nextCursor = ''));
  });

  Widget wrap(Widget child) => ProviderScope(
    overrides: [favoritesRepositoryProvider.overrideWithValue(repository)],
    child: themedApp(Scaffold(body: child)),
  );

  group('FM-04d/FM-27b — ProviderCard', () {
    testWidgets(
      'affiche nom, initiales (repli), catégorie/localisation, note et prix',
      (tester) async {
        await tester.pumpWidget(
          wrap(
            const ProviderCard(
              providerId: 'provider-1',
              name: 'Karim Ben Salah',
              categoryLabel: 'Plomberie',
              locationLabel: 'Sousse, Khezama · 2,4 km',
              rating: 4.8,
              reviewCount: 63,
              priceLabel: 'à partir de 40 TND',
            ),
          ),
        );

        expect(find.text('Karim Ben Salah'), findsOneWidget);
        expect(find.text('KB'), findsOneWidget);
        expect(
          find.text('Plomberie · Sousse, Khezama · 2,4 km'),
          findsOneWidget,
        );
        expect(find.text('4,8 (63)'), findsOneWidget);
        expect(find.text('à partir de 40 TND'), findsOneWidget);
      },
    );

    testWidgets('sans priceLabel, aucun prix affiché', (tester) async {
      await tester.pumpWidget(
        wrap(
          const ProviderCard(
            providerId: 'provider-1',
            name: 'Hédi Ferjani',
            categoryLabel: 'Peinture',
            locationLabel: 'Monastir',
            rating: 4.2,
          ),
        ),
      );

      expect(find.text('4,2'), findsOneWidget);
    });

    testWidgets('isVerified: true affiche le VerifiedBadge', (tester) async {
      await tester.pumpWidget(
        wrap(
          const ProviderCard(
            providerId: 'provider-1',
            name: 'Karim Ben Salah',
            categoryLabel: 'Plomberie',
            locationLabel: 'Sousse',
            rating: 4.8,
            isVerified: true,
          ),
        ),
      );

      expect(find.text('Vérifié'), findsOneWidget);
    });

    testWidgets('isVerified: false (défaut) — pas de VerifiedBadge', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const ProviderCard(
            providerId: 'provider-1',
            name: 'Karim Ben Salah',
            categoryLabel: 'Plomberie',
            locationLabel: 'Sousse',
            rating: 4.8,
          ),
        ),
      );

      expect(find.text('Vérifié'), findsNothing);
    });

    testWidgets('tap sur la carte déclenche onTap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        wrap(
          ProviderCard(
            providerId: 'provider-1',
            name: 'Karim Ben Salah',
            categoryLabel: 'Plomberie',
            locationLabel: 'Sousse',
            rating: 4.8,
            onTap: () => tapped = true,
          ),
        ),
      );

      await tester.tap(find.byType(ProviderCard));
      expect(tapped, isTrue);
    });

    testWidgets('initiales : un nom à un seul mot donne une seule lettre', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const ProviderCard(
            providerId: 'provider-1',
            name: 'Cabinet',
            categoryLabel: 'Électricité',
            locationLabel: 'Mahdia',
            rating: 4,
          ),
        ),
      );

      expect(find.text('C'), findsOneWidget);
    });

    testWidgets(
      "sans photoUrl, affiche les initiales plutôt qu'une image réseau",
      (tester) async {
        await tester.pumpWidget(
          wrap(
            const ProviderCard(
              providerId: 'provider-1',
              name: 'Karim Ben Salah',
              categoryLabel: 'Plomberie',
              locationLabel: 'Sousse',
              rating: 4.8,
            ),
          ),
        );

        expect(find.text('KB'), findsOneWidget);
        expect(find.byType(Image), findsNothing);
      },
    );

    testWidgets('tap sur le bouton favori (non favori) ajoute aux favoris', (
      tester,
    ) async {
      when(() => repository.addFavorite('provider-1')).thenAnswer((_) async {});

      await tester.pumpWidget(
        wrap(
          const ProviderCard(
            providerId: 'provider-1',
            name: 'Karim Ben Salah',
            categoryLabel: 'Plomberie',
            locationLabel: 'Sousse',
            rating: 4.8,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.favorite_border), findsOneWidget);

      await tester.tap(find.byIcon(Icons.favorite_border));
      await tester.pumpAndSettle();

      verify(() => repository.addFavorite('provider-1')).called(1);
    });

    testWidgets('tap sur le bouton favori (déjà favori) retire des favoris', (
      tester,
    ) async {
      when(() => repository.fetchFavorites()).thenAnswer(
        (_) async => FavoritesResponse(
          (b) => b
            ..items.add(
              FavoriteItem(
                (item) => item
                  ..providerId = 'provider-1'
                  ..slug = 'karim-plombier'
                  ..businessName = 'Karim Ben Salah'
                  ..headline = 'Plombier'
                  ..isVerified = false
                  ..ratingAvg = 4.8
                  ..ratingCount = 63
                  ..availabilityStatus =
                      V1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnum
                          .AVAILABLE
                  ..favoritedAt = DateTime.utc(2026, 8, 26),
              ),
            )
            ..nextCursor = '',
        ),
      );
      when(
        () => repository.removeFavorite('provider-1'),
      ).thenAnswer((_) async {});

      await tester.pumpWidget(
        wrap(
          const ProviderCard(
            providerId: 'provider-1',
            name: 'Karim Ben Salah',
            categoryLabel: 'Plomberie',
            locationLabel: 'Sousse',
            rating: 4.8,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.favorite), findsOneWidget);

      await tester.tap(find.byIcon(Icons.favorite));
      await tester.pumpAndSettle();

      verify(() => repository.removeFavorite('provider-1')).called(1);
    });
  });
}
