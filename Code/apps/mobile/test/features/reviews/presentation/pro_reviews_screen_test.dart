import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/core/widgets/empty_state.dart';
import 'package:sanaya/core/widgets/error_state.dart';
import 'package:sanaya/features/onboarding/data/onboarding_repository.dart';
import 'package:sanaya/features/provider_profile/application/provider_profile_providers.dart';
import 'package:sanaya/features/provider_profile/data/provider_profile_repository.dart';
import 'package:sanaya/features/provider_profile/presentation/widgets/review_tile.dart';
import 'package:sanaya/features/reviews/application/pro_reviews_providers.dart';
import 'package:sanaya/features/reviews/presentation/pro_reviews_screen.dart';

import '../../../core/widgets/widget_test_helpers.dart';

class _MockProviderMe extends Mock
    implements V1ProvidersMePost200ResponseProvider {}

class _MockProviderProfileRepository extends Mock
    implements ProviderProfileRepository {}

V1ProvidersSlugReviewsGet200ResponseItemsInner _mockReview(
  String id, {
  int rating = 5,
  String author = 'Sami Ben Ali',
  String comment = 'Travail soigné et ponctuel.',
  bool isVerifiedContact = false,
}) => V1ProvidersSlugReviewsGet200ResponseItemsInner(
  (b) {
    b
      ..id = id
      ..rating = rating
      ..authorDisplayName = author
      ..comment = comment
      ..createdAt = DateTime.utc(2026, 9)
      ..isVerifiedContact = isVerifiedContact;
  },
);

void main() {
  setUpAll(() async {
    await initializeDateFormatting('fr');
    await initializeDateFormatting('ar');
  });

  late _MockProviderMe mockProfile;
  late _MockProviderProfileRepository mockProfileRepo;

  setUp(() {
    mockProfile = _MockProviderMe();
    when(() => mockProfile.slug).thenReturn('artisan-sousse-1');
    when(() => mockProfile.businessName).thenReturn('Plomberie Pro Sousse');
    when(() => mockProfile.ratingAvg).thenReturn(4.8);
    when(() => mockProfile.ratingCount).thenReturn(12);

    mockProfileRepo = _MockProviderProfileRepository();
  });

  Widget buildScreen({
    List<Override> overrides = const [],
    Locale? locale,
  }) {
    final effectiveLocale = locale ?? const Locale('fr');
    return ProviderScope(
      overrides: [
        localeProvider.overrideWith((ref) => effectiveLocale),
        providerProfileRepositoryProvider.overrideWithValue(mockProfileRepo),
        ...overrides,
      ],
      child: themedApp(const ProReviewsScreen(), locale: effectiveLocale),
    );
  }

  group('FM-39 — ProReviewsScreen', () {
    testWidgets('affiche les squelettes pendant le chargement du profil', (
      tester,
    ) async {
      final completer = Completer<ProviderMe?>();

      await tester.pumpWidget(
        buildScreen(
          overrides: [
            myProviderProfileProvider.overrideWith((ref) => completer.future),
          ],
        ),
      );
      await tester.pump();

      expect(find.byType(ProReviewsScreen), findsOneWidget);
      expect(find.byType(EmptyState), findsNothing);
      expect(find.byType(ErrorState), findsNothing);
    });

    testWidgets("affiche EmptyState si aucun profil artisan n'existe", (
      tester,
    ) async {
      await tester.pumpWidget(
        buildScreen(
          overrides: [
            myProviderProfileProvider.overrideWith((ref) async => null),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(EmptyState), findsOneWidget);
      expect(find.text("Aucun avis reçu pour l'instant"), findsOneWidget);
    });

    testWidgets(
      'affiche ErrorState avec bouton réessayer si le chargement du profil'
      ' échoue',
      (tester) async {
        var retryCalled = false;

        when(
          () => mockProfileRepo.fetchReviews(
            'artisan-sousse-1',
            cursor: any(named: 'cursor'),
          ),
        ).thenAnswer(
          (_) async => ReviewsPage(
            (b) => b
              ..items = ListBuilder([_mockReview('1')])
              ..nextCursor = '',
          ),
        );

        await tester.pumpWidget(
          buildScreen(
            overrides: [
              myProviderProfileProvider.overrideWith((ref) {
                if (retryCalled) {
                  return Future.value(mockProfile);
                }
                throw Exception('Erreur réseau');
              }),
            ],
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(ErrorState), findsOneWidget);
        expect(find.text('Impossible de charger vos avis.'), findsOneWidget);

        retryCalled = true;
        await tester.tap(find.text('Réessayer'));
        await tester.pumpAndSettle();

        expect(find.byType(ReviewTile), findsOneWidget);
      },
    );

    testWidgets(
      "affiche EmptyState si l'artisan connecté n'a aucun avis reçu",
      (tester) async {
        when(
          () => mockProfileRepo.fetchReviews(
            'artisan-sousse-1',
            cursor: any(named: 'cursor'),
          ),
        ).thenAnswer(
          (_) async => ReviewsPage(
            (b) => b
              ..items = ListBuilder([])
              ..nextCursor = '',
          ),
        );

        await tester.pumpWidget(
          buildScreen(
            overrides: [
              myProviderProfileProvider.overrideWith(
                (ref) async => mockProfile,
              ),
            ],
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(EmptyState), findsOneWidget);
        expect(find.text("Aucun avis reçu pour l'instant"), findsOneWidget);
      },
    );

    testWidgets(
      'affiche ErrorState avec bouton réessayer si le chargement des avis'
      ' échoue',
      (tester) async {
        var retryCalled = false;

        when(
          () => mockProfileRepo.fetchReviews(
            'artisan-sousse-1',
            cursor: any(named: 'cursor'),
          ),
        ).thenAnswer((_) async {
          if (retryCalled) {
            return ReviewsPage(
              (b) => b
                ..items = ListBuilder([_mockReview('1')])
                ..nextCursor = '',
            );
          }
          throw Exception('Erreur réseau avis');
        });

        await tester.pumpWidget(
          buildScreen(
            overrides: [
              myProviderProfileProvider.overrideWith(
                (ref) async => mockProfile,
              ),
            ],
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(ErrorState), findsOneWidget);
        expect(find.text('Impossible de charger vos avis.'), findsOneWidget);

        retryCalled = true;
        await tester.tap(find.text('Réessayer'));
        await tester.pumpAndSettle();

        expect(find.byType(ReviewTile), findsOneWidget);
      },
    );

    testWidgets(
      'affiche la liste des avis reçus avec la note, '
      "l'auteur et le point d'extension BE-22b",
      (tester) async {
        final review1 = _mockReview(
          '1',
          author: 'Karim Jaziri',
          comment: 'Très bon électricien, rapide et professionnel.',
        );
        final review2 = _mockReview(
          '2',
          rating: 4,
          author: 'Salma Trabelsi',
          comment: 'Bon travail, satisfait de la prestation.',
        );

        when(
          () => mockProfileRepo.fetchReviews(
            'artisan-sousse-1',
            cursor: any(named: 'cursor'),
          ),
        ).thenAnswer(
          (_) async => ReviewsPage(
            (b) => b
              ..items = ListBuilder([review1, review2])
              ..nextCursor = '',
          ),
        );

        await tester.pumpWidget(
          buildScreen(
            overrides: [
              myProviderProfileProvider.overrideWith(
                (ref) async => mockProfile,
              ),
            ],
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(ReviewTile), findsNWidgets(2));
        expect(find.text('Karim Jaziri'), findsOneWidget);
        expect(
          find.text('Très bon électricien, rapide et professionnel.'),
          findsOneWidget,
        );
        expect(find.text('Salma Trabelsi'), findsOneWidget);

        // En-tête résumé de la note
        expect(find.text('Note moyenne'), findsOneWidget);
        expect(find.text('12 avis'), findsOneWidget);

        // Point d'extension réponse artisan BE-22b
        expect(
          find.text('La réponse aux avis sera bientôt disponible'),
          findsNWidgets(2),
        );
      },
    );

    testWidgets(
      'affiche le bouton charger plus et appelle loadMore lors du tap',
      (tester) async {
        var pageCount = 0;

        when(
          () => mockProfileRepo.fetchReviews(
            'artisan-sousse-1',
            cursor: any(named: 'cursor'),
          ),
        ).thenAnswer((_) async {
          pageCount++;
          if (pageCount == 1) {
            return ReviewsPage(
              (b) => b
                ..items = ListBuilder([_mockReview('1')])
                ..nextCursor = 'cursor-page-2',
            );
          }
          return ReviewsPage(
            (b) => b
              ..items = ListBuilder([_mockReview('2')])
              ..nextCursor = '',
          );
        });

        await tester.pumpWidget(
          buildScreen(
            overrides: [
              myProviderProfileProvider.overrideWith(
                (ref) async => mockProfile,
              ),
            ],
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text("Charger plus d'avis"), findsOneWidget);
        await tester.tap(find.text("Charger plus d'avis"));
        await tester.pumpAndSettle();

        expect(find.byType(ReviewTile), findsNWidgets(2));
        verify(
          () => mockProfileRepo.fetchReviews(
            'artisan-sousse-1',
            cursor: any(named: 'cursor'),
          ),
        ).called(2);
      },
    );

    testWidgets('se rend en arabe sans exception (RTL)', (tester) async {
      when(
        () => mockProfileRepo.fetchReviews(
          'artisan-sousse-1',
          cursor: any(named: 'cursor'),
        ),
      ).thenAnswer(
        (_) async => ReviewsPage(
          (b) => b
            ..items = ListBuilder([_mockReview('1')])
            ..nextCursor = '',
        ),
      );

      await tester.pumpWidget(
        buildScreen(
          locale: const Locale('ar'),
          overrides: [
            myProviderProfileProvider.overrideWith((ref) async => mockProfile),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('التقييمات'), findsOneWidget);
      expect(find.text('متوسط التقييم'), findsOneWidget);
      expect(
        find.text('الرد على التقييمات سيكون متاحاً قريباً'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });
  });
}
