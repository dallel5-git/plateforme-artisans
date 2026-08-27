import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/core/widgets/verified_badge.dart';
import 'package:sanaya/features/provider_profile/application/provider_profile_providers.dart';
import 'package:sanaya/features/provider_profile/data/provider_profile_repository.dart';
import 'package:sanaya/features/provider_profile/presentation/screens/provider_profile_screen.dart';

ProviderProfile _fakeProfile({
  required String slug,
  required String businessName,
  bool isVerified = false,
  num average = 4.5,
  int reviewCount = 10,
}) => ProviderProfile(
  (b) => b
    ..id = 'provider-1'
    ..slug = slug
    ..businessName = businessName
    ..headline = 'Plombier chauffagiste expérimenté'
    ..bio = 'Artisan qualifié depuis plus de 10 ans.'
    ..yearsExperience = 10
    ..spokenLanguages =
        ListBuilder<V1ProvidersMePost200ResponseProviderSpokenLanguagesEnum>(
          [V1ProvidersMePost200ResponseProviderSpokenLanguagesEnum.FR],
        )
    ..baseGovernorate = V1ProvidersSlugGet200ResponseBaseGovernorate(
      (g) => g
        ..slug = 'sousse'
        ..nameFr = 'Sousse'
        ..nameAr = 'سوسة',
    ).toBuilder()
    ..baseDelegation = V1ProvidersSlugGet200ResponseBaseDelegation(
      (d) => d
        ..slug = 'sousse-ville'
        ..nameFr = 'Sousse Ville'
        ..nameAr = 'سوسة المدينة',
    ).toBuilder()
    ..latitude = 35.8256
    ..longitude = 10.63699
    ..isVerified = isVerified
    ..availabilityStatus =
        V1ProvidersSlugGet200ResponseAvailabilityStatusEnum.AVAILABLE
    ..availableAgainAt = DateTime.utc(2026, 8, 28)
    ..acceptsEmergency = true
    ..completionScore = 95
    ..categories = ListBuilder<V1ProvidersSlugGet200ResponseCategoriesInner>(
      [],
    )
    ..offerings = ListBuilder<V1ProvidersSlugGet200ResponseOfferingsInner>([
      V1ProvidersSlugGet200ResponseOfferingsInner(
        (o) => o
          ..id = 'off-1'
          ..category = V1ProvidersSlugGet200ResponseOfferingsInnerCategory(
            (c) => c
              ..slug = 'plomberie'
              ..nameFr = 'Plomberie'
              ..nameAr = 'سباكة',
          ).toBuilder()
          ..titleFr = 'Dépannage plomberie'
          ..titleAr = 'إصلاح سباكة'
          ..description = 'Intervention rapide'
          ..priceMin = 40000
          ..priceMax = 60000
          ..priceUnit =
              V1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum.FIXED
          ..isNegotiable = false
          ..displayPrice = '40 TND',
      ),
    ])
    ..coverageAreas =
        ListBuilder<V1ProvidersSlugGet200ResponseCoverageAreasInner>([
          V1ProvidersSlugGet200ResponseCoverageAreasInner(
            (a) => a
              ..governorate =
                  V1ProvidersSlugGet200ResponseOfferingsInnerCategory(
                    (g) => g
                      ..slug = 'sousse'
                      ..nameFr = 'Sousse'
                      ..nameAr = 'سوسة',
                  ).toBuilder()
              ..delegation =
                  V1ProvidersSlugGet200ResponseCoverageAreasInnerDelegation(
                    (d) => d
                      ..slug = 'sousse-ville'
                      ..nameFr = 'Sousse Ville'
                      ..nameAr = 'سوسة المدينة',
                  ).toBuilder()
              ..travelFee = 0,
          ),
        ])
    ..gallery = ListBuilder<V1ProvidersSlugGet200ResponseGalleryInner>([])
    ..reviewAggregate = V1ProvidersSlugGet200ResponseReviewAggregate(
      (r) => r
        ..average = average
        ..count = reviewCount
        ..breakdown = V1ProvidersSlugGet200ResponseReviewAggregateBreakdown(
          (bk) => bk
            ..n1 = 0
            ..n2 = 0
            ..n3 = 1
            ..n4 = 3
            ..n5 = 6,
        ).toBuilder(),
    ).toBuilder(),
);

class FakeProviderProfileRepository implements ProviderProfileRepository {
  FakeProviderProfileRepository({
    this.profile,
    this.reviewsPage,
    this.error,
    this.completer,
  });

  final ProviderProfile? profile;
  final ReviewsPage? reviewsPage;
  final Exception? error;
  final Completer<ProviderProfile>? completer;

  @override
  Future<ProviderProfile> fetchProfile(String slug) async {
    if (completer != null) return completer!.future;
    if (error != null) throw error!;
    return profile!;
  }

  @override
  Future<ReviewsPage> fetchReviews(
    String slug, {
    String? cursor,
    int limit = 10,
  }) async {
    if (error != null) throw error!;
    return reviewsPage ??
        ReviewsPage(
          (b) => b
            ..items =
                ListBuilder<V1ProvidersSlugReviewsGet200ResponseItemsInner>([])
            ..nextCursor = '',
        );
  }
}

Widget _wrap(
  Widget child, {
  required ProviderProfileRepository repository,
  Locale locale = const Locale('fr'),
}) {
  return ProviderScope(
    overrides: [
      localeProvider.overrideWith((ref) => locale),
      providerProfileRepositoryProvider.overrideWithValue(repository),
    ],
    child: MaterialApp(
      locale: locale,
      supportedLocales: const [Locale('fr'), Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: buildTheme(brightness: Brightness.light, locale: locale),
      home: Directionality(
        textDirection: locale.languageCode == 'ar'
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: child,
      ),
    ),
  );
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('fr');
    await initializeDateFormatting('ar');
  });

  group('ProviderProfileScreen', () {
    testWidgets('affiche le skeleton pendant le chargement', (tester) async {
      final completer = Completer<ProviderProfile>();
      final repo = FakeProviderProfileRepository(completer: completer);

      await tester.pumpWidget(
        _wrap(
          const ProviderProfileScreen(slug: 'artisan-test'),
          repository: repo,
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(ProviderProfileScreen), findsOneWidget);
    });

    testWidgets(
      'affiche un état d erreur avec bouton Réessayer en cas d échec',
      (tester) async {
        final repo = FakeProviderProfileRepository(
          error: Exception('404 Not Found'),
        );

        await tester.pumpWidget(
          _wrap(
            const ProviderProfileScreen(slug: 'artisan-inconnu'),
            repository: repo,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Impossible de charger la fiche.'), findsOneWidget);
        expect(find.text('Réessayer'), findsOneWidget);
      },
    );

    testWidgets('affiche les données complètes du profil', (tester) async {
      final profile = _fakeProfile(
        slug: 'mohamed-plombier',
        businessName: 'Mohamed Plomberie',
        isVerified: true,
      );
      final repo = FakeProviderProfileRepository(profile: profile);

      await tester.pumpWidget(
        _wrap(
          const ProviderProfileScreen(slug: 'mohamed-plombier'),
          repository: repo,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Mohamed Plomberie'), findsWidgets);
      expect(find.text('Plombier chauffagiste expérimenté'), findsOneWidget);
      expect(find.text('Dépannage plomberie'), findsOneWidget);
      expect(find.text('40 TND'), findsOneWidget);
      expect(find.text('Sousse Ville'), findsOneWidget);
      expect(find.text('Appeler'), findsOneWidget);
      expect(find.text('WhatsApp'), findsOneWidget);
    });

    testWidgets(
      'ADR-002: VerifiedBadge est affiché si isVerified=true',
      (tester) async {
        final profile = _fakeProfile(
          slug: 'artisan-verifie',
          businessName: 'Artisan Vérifié',
          isVerified: true,
        );
        final repo = FakeProviderProfileRepository(profile: profile);

        await tester.pumpWidget(
          _wrap(
            const ProviderProfileScreen(slug: 'artisan-verifie'),
            repository: repo,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(VerifiedBadge), findsOneWidget);
      },
    );

    testWidgets(
      'ADR-002: VerifiedBadge est absent si isVerified=false',
      (tester) async {
        final profile = _fakeProfile(
          slug: 'artisan-non-verifie',
          businessName: 'Artisan Non Vérifié',
        );
        final repo = FakeProviderProfileRepository(profile: profile);

        await tester.pumpWidget(
          _wrap(
            const ProviderProfileScreen(slug: 'artisan-non-verifie'),
            repository: repo,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(VerifiedBadge), findsNothing);
      },
    );
  });
}
