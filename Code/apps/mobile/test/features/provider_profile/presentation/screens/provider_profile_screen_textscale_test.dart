import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/features/provider_profile/application/provider_profile_providers.dart';
import 'package:sanaya/features/provider_profile/data/provider_profile_repository.dart';
import 'package:sanaya/features/provider_profile/presentation/screens/provider_profile_screen.dart';

import '../../../../support/overflow_guard.dart';

/// Profil délibérément dense (libellés longs, plusieurs prestations/zones)
/// pour stresser la mise en page à `TextScaler.linear(1.3)` — FM-17,
/// critère d'acceptation.
ProviderProfile _denseFakeProfile() => ProviderProfile(
  (b) => b
    ..id = 'provider-1'
    ..slug = 'artisan-dense'
    ..businessName = 'Établissement Ben Abdallah Climatisation & Plomberie'
    ..headline =
        'Spécialiste climatisation réversible, chauffage central et '
        'plomberie sanitaire — intervention rapide 7j/7 dans tout le Sahel'
    ..bio =
        "Plus de 15 ans d'expérience dans l'installation et la "
        'maintenance de systèmes de climatisation, chauffage central et '
        'plomberie sanitaire pour particuliers et professionnels.'
    ..yearsExperience = 15
    ..spokenLanguages =
        ListBuilder<V1ProvidersMePost200ResponseProviderSpokenLanguagesEnum>([
          V1ProvidersMePost200ResponseProviderSpokenLanguagesEnum.FR,
          V1ProvidersMePost200ResponseProviderSpokenLanguagesEnum.AR,
        ])
    ..baseGovernorate = V1ProvidersSlugGet200ResponseBaseGovernorate(
      (g) => g
        ..slug = 'sousse'
        ..nameFr = 'Sousse'
        ..nameAr = 'سوسة',
    ).toBuilder()
    ..baseDelegation = V1ProvidersSlugGet200ResponseBaseDelegation(
      (d) => d
        ..slug = 'sousse-ville'
        ..nameFr = 'Sousse Ville, Khezama Ouest, à proximité de la gare'
        ..nameAr = 'سوسة المدينة، خزامة الغربية، بالقرب من المحطة',
    ).toBuilder()
    ..latitude = 35.8256
    ..longitude = 10.63699
    ..isVerified = true
    ..availabilityStatus =
        V1ProvidersSlugGet200ResponseAvailabilityStatusEnum.AVAILABLE
    ..availableAgainAt = DateTime.utc(2026, 8, 28)
    ..acceptsEmergency = true
    ..completionScore = 95
    ..categories = ListBuilder<V1ProvidersSlugGet200ResponseCategoriesInner>(
      [],
    )
    ..offerings = ListBuilder<V1ProvidersSlugGet200ResponseOfferingsInner>([
      for (var i = 0; i < 4; i++)
        V1ProvidersSlugGet200ResponseOfferingsInner(
          (o) => o
            ..id = 'off-$i'
            ..category = V1ProvidersSlugGet200ResponseOfferingsInnerCategory(
              (c) => c
                ..slug = 'plomberie'
                ..nameFr = 'Plomberie et climatisation générale'
                ..nameAr = 'سباكة وتكييف الهواء العام',
            ).toBuilder()
            ..titleFr =
                'Installation et maintenance complète de climatiseur '
                "split réversible avec garantie pièces et main d'œuvre"
            ..titleAr = 'تركيب وصيانة كاملة لمكيف هواء منقسم قابل للعكس'
            ..description = 'Intervention rapide, devis gratuit sur place'
            ..priceMin = 40000
            ..priceMax = 600000
            ..priceUnit =
                V1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum.FIXED
            ..isNegotiable = false
            ..displayPrice = 'à partir de 400,000 TND',
        ),
    ])
    ..coverageAreas =
        ListBuilder<V1ProvidersSlugGet200ResponseCoverageAreasInner>([
          for (final delegation in const [
            'Sousse Ville',
            'Sousse Khezama Ouest',
            'Sousse Sidi Abdelhamid',
            'Kalaa Kebira',
          ])
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
                        ..slug = delegation.toLowerCase()
                        ..nameFr = delegation
                        ..nameAr = delegation,
                    ).toBuilder()
                ..travelFee = 5000,
            ),
        ])
    ..gallery = ListBuilder<V1ProvidersSlugGet200ResponseGalleryInner>([])
    ..reviewAggregate = V1ProvidersSlugGet200ResponseReviewAggregate(
      (r) => r
        ..average = 4.8
        ..count = 1234
        ..breakdown = V1ProvidersSlugGet200ResponseReviewAggregateBreakdown(
          (bk) => bk
            ..n1 = 2
            ..n2 = 5
            ..n3 = 20
            ..n4 = 300
            ..n5 = 907,
        ).toBuilder(),
    ).toBuilder(),
);

class _FakeProviderProfileRepository implements ProviderProfileRepository {
  _FakeProviderProfileRepository(this.profile);

  final ProviderProfile profile;

  @override
  Future<ProviderProfile> fetchProfile(String slug) async => profile;

  @override
  Future<ReviewsPage> fetchReviews(
    String slug, {
    String? cursor,
    int limit = 10,
  }) async => ReviewsPage(
    (b) => b
      ..items = ListBuilder<V1ProvidersSlugReviewsGet200ResponseItemsInner>([])
      ..nextCursor = '',
  );
}

Widget _wrap({required Locale locale, TextScaler? textScaler}) {
  return ProviderScope(
    overrides: [
      localeProvider.overrideWith((ref) => locale),
      providerProfileRepositoryProvider.overrideWithValue(
        _FakeProviderProfileRepository(_denseFakeProfile()),
      ),
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
      builder: textScaler == null
          ? null
          : (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: textScaler),
              child: child!,
            ),
      home: Directionality(
        textDirection: locale.languageCode == 'ar'
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: const ProviderProfileScreen(slug: 'artisan-dense'),
      ),
    ),
  );
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('fr');
    await initializeDateFormatting('ar');
  });

  group('FM-17b — ProviderProfileScreen, TextScaler 1.3 (accessibilité)', () {
    testWidgets(
      'aucun débordement à 130% avec un profil dense, en français',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(360, 800));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        final errors = await captureFlutterErrors(() async {
          await tester.pumpWidget(
            _wrap(
              locale: const Locale('fr'),
              textScaler: const TextScaler.linear(1.3),
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

    testWidgets(
      'aucun débordement à 130% avec un profil dense, en arabe (RTL)',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(360, 800));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        final errors = await captureFlutterErrors(() async {
          await tester.pumpWidget(
            _wrap(
              locale: const Locale('ar'),
              textScaler: const TextScaler.linear(1.3),
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
