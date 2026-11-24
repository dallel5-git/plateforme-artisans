import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/core/widgets/verified_badge.dart';
import 'package:sanaya/features/auth/application/auth_state_provider.dart';
import 'package:sanaya/features/auth/application/auth_status.dart';
import 'package:sanaya/features/favorites/application/favorites_providers.dart';
import 'package:sanaya/features/favorites/data/favorites_repository.dart';
import 'package:sanaya/features/favorites/presentation/widgets/favorite_card.dart';

import '../../../../core/widgets/widget_test_helpers.dart';

class _FavoritesRepositoryMock extends Mock implements FavoritesRepository {}

class _FixedAuthStateNotifier extends AuthStateNotifier {
  _FixedAuthStateNotifier(this._status);

  final AuthStatus _status;

  @override
  Future<AuthStatus> build() async => _status;
}

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
        ..headline = 'Plombier sanitaire à Sousse'
        ..isVerified = true
        ..ratingAvg = 4.8
        ..ratingCount = 15
        ..availabilityStatus =
            V1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnum.AVAILABLE
        ..favoritedAt = DateTime.utc(2026, 8, 26),
    );
  });

  Widget buildTestWidget({
    required FavoriteItem item,
    Locale locale = const Locale('fr'),
    VoidCallback? onTap,
    AuthStatus authStatus = const AuthStatus.authenticated(isProvider: false),
  }) {
    return ProviderScope(
      overrides: [
        localeProvider.overrideWith((ref) => locale),
        favoritesRepositoryProvider.overrideWithValue(repository),
        authStateProvider.overrideWith(
          () => _FixedAuthStateNotifier(authStatus),
        ),
      ],
      child: themedApp(
        Scaffold(
          body: FavoriteCard(item: item, onTap: onTap),
        ),
        locale: locale,
      ),
    );
  }

  group('FavoriteCard', () {
    testWidgets(
      'affiche les informations du prestataire et les boutons de contact',
      (
        tester,
      ) async {
        await tester.pumpWidget(buildTestWidget(item: sampleItem));
        await tester.pumpAndSettle();

        expect(find.text('Sami Plomberie'), findsOneWidget);
        expect(find.text('Plombier sanitaire à Sousse'), findsOneWidget);
        expect(find.byType(VerifiedBadge), findsOneWidget);
        expect(find.text('Appeler'), findsOneWidget);
        expect(find.text('WhatsApp'), findsOneWidget);
        expect(find.byIcon(Icons.favorite), findsOneWidget);
      },
    );

    testWidgets('le tap sur le bouton favori déclenche le retrait', (
      tester,
    ) async {
      when(() => repository.removeFavorite('prov-1')).thenAnswer((_) async {});
      when(() => repository.fetchFavorites()).thenAnswer(
        (_) async => FavoritesResponse(
          (b) => b
            ..items.add(sampleItem)
            ..nextCursor = '',
        ),
      );

      await tester.pumpWidget(buildTestWidget(item: sampleItem));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.favorite));
      await tester.pump();

      verify(() => repository.removeFavorite('prov-1')).called(1);
    });

    testWidgets(
      'le tap sur la carte (hors bouton favori) déclenche onTap sans '
      'retirer le favori',
      (tester) async {
        var tapped = false;
        await tester.pumpWidget(
          buildTestWidget(item: sampleItem, onTap: () => tapped = true),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Sami Plomberie'));
        await tester.pump();

        expect(tapped, isTrue);
        verifyNever(() => repository.removeFavorite(any()));
      },
    );

    testWidgets('se rend sans exception en arabe (RTL)', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          item: sampleItem,
          locale: const Locale('ar'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Sami Plomberie'), findsOneWidget);
      expect(find.text('اتصال'), findsOneWidget);
      expect(find.text('واتساب'), findsOneWidget);
    });
  });
}
