import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sanaya/core/widgets/provider_card.dart';
import 'package:sanaya/features/favorites/application/favorites_providers.dart';
import 'package:sanaya/features/favorites/data/favorites_repository.dart';

import '../../support/overflow_guard.dart';
import 'widget_test_helpers.dart';

class _FavoritesRepositoryMock extends Mock implements FavoritesRepository {}

/// FM-17 — critère d'acceptation : `TextScaler.linear(1.3)` ne doit
/// provoquer aucun débordement sur les écrans à forte densité de texte.
/// `ProviderCard` est le composant le plus vu du produit (design-system.html
/// §7) — noms/catégories/localisations longs mélangés à des chips de
/// largeur fixe (avatar, badge, prix) en font un candidat classique.
void main() {
  group('FM-17b — ProviderCard, TextScaler 1.3 (accessibilité)', () {
    testWidgets('aucun débordement à 130% avec un contenu dense, en français', (
      tester,
    ) async {
      // Largeur d'un Android bas de gamme (apps/mobile/CLAUDE.md) — le
      // viewport de test par défaut (800×600) est plus large que la
      // plupart des devices réels et masquerait un débordement.
      await tester.binding.setSurfaceSize(const Size(360, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final repository = _FavoritesRepositoryMock();
      when(repository.fetchFavorites).thenAnswer(
        (_) async => FavoritesResponse((b) => b..nextCursor = ''),
      );

      final errors = await captureFlutterErrors(() async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              favoritesRepositoryProvider.overrideWithValue(repository),
            ],
            child: themedApp(
              const Padding(
                padding: EdgeInsets.all(16),
                child: ProviderCard(
                  providerId: 'provider-1',
                  name: 'Sidi Mohamed Ben Abdallah El Fourati',
                  categoryLabel: 'Climatisation et chauffage central',
                  locationLabel: 'Sousse, Khezama Ouest · 12,7 km',
                  rating: 4.8,
                  reviewCount: 1234,
                  priceLabel: 'à partir de 250 TND',
                  isVerified: true,
                ),
              ),
              textScaler: const TextScaler.linear(1.3),
            ),
          ),
        );
        await tester.pumpAndSettle();
      });

      expect(
        errors,
        isEmpty,
        reason: errors.map((e) => e.exceptionAsString()).join('\n'),
      );
    });

    testWidgets(
      'aucun débordement à 130% avec un contenu dense, en arabe (RTL)',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(360, 800));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        final repository = _FavoritesRepositoryMock();
        when(repository.fetchFavorites).thenAnswer(
          (_) async => FavoritesResponse((b) => b..nextCursor = ''),
        );

        final errors = await captureFlutterErrors(() async {
          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                favoritesRepositoryProvider.overrideWithValue(repository),
              ],
              child: themedApp(
                const Directionality(
                  textDirection: TextDirection.rtl,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: ProviderCard(
                      providerId: 'provider-1',
                      name: 'سيدي محمد بن عبد الله الفوراتي',
                      categoryLabel: 'تكييف الهواء والتدفئة المركزية',
                      locationLabel: 'سوسة، خزامة الغربية · 12,7 كم',
                      rating: 4.8,
                      reviewCount: 1234,
                      priceLabel: 'ابتداء من 250 د.ت',
                      isVerified: true,
                    ),
                  ),
                ),
                locale: const Locale('ar'),
                textScaler: const TextScaler.linear(1.3),
              ),
            ),
          );
          await tester.pumpAndSettle();
        });

        expect(
          errors,
          isEmpty,
          reason: errors.map((e) => e.exceptionAsString()).join('\n'),
        );
      },
    );
  });
}
