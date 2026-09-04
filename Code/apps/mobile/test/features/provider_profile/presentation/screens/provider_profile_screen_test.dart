import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/core/widgets/app_skeleton.dart';
import 'package:sanaya/core/widgets/verified_badge.dart';
import 'package:sanaya/features/contact/application/contact_providers.dart';
import 'package:sanaya/features/contact/domain/contact_channel.dart';
import 'package:sanaya/features/contact/domain/contact_service.dart';
import 'package:sanaya/features/favorites/application/favorites_providers.dart';
import 'package:sanaya/features/favorites/data/favorites_repository.dart';
import 'package:sanaya/features/provider_profile/application/provider_profile_providers.dart';
import 'package:sanaya/features/provider_profile/data/provider_profile_repository.dart';
import 'package:sanaya/features/provider_profile/presentation/screens/provider_profile_screen.dart';

class _ContactServiceMock extends Mock implements ContactService {}

class _FavoritesRepositoryMock extends Mock implements FavoritesRepository {}

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
  ContactService? contactService,
  FavoritesRepository? favoritesRepository,
}) {
  return ProviderScope(
    overrides: [
      localeProvider.overrideWith((ref) => locale),
      providerProfileRepositoryProvider.overrideWithValue(repository),
      if (contactService != null)
        contactServiceProvider.overrideWithValue(contactService),
      if (favoritesRepository != null)
        favoritesRepositoryProvider.overrideWithValue(favoritesRepository),
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

/// Variante avec un vrai `GoRouter` (pas juste `MaterialApp.home`) pour
/// vérifier la navigation déclenchée par la carte d'invitation — même
/// patron que `review_form_screen_test.dart` (route `/` sous-jacente
/// nécessaire pour tout `pop()` éventuel, même si non utilisé ici).
({Widget widget, GoRouter router}) _wrapWithRouter({
  required ProviderProfileRepository repository,
  required String slug,
}) {
  final router = GoRouter(
    initialLocation: '/providers/$slug',
    routes: [
      GoRoute(
        path: '/providers/:slug',
        name: 'provider-profile',
        builder: (_, state) =>
            ProviderProfileScreen(slug: state.pathParameters['slug'] ?? ''),
        routes: [
          GoRoute(
            path: 'review',
            name: 'provider-review',
            builder: (_, _) => const Scaffold(body: Text('review-screen')),
          ),
        ],
      ),
    ],
  );

  final widget = ProviderScope(
    overrides: [
      providerProfileRepositoryProvider.overrideWithValue(repository),
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
      // FM-29b : squelette fait main de _ProfileSkeleton remplacé par
      // AppSkeleton (design-system.html §8).
      expect(find.byType(AppSkeleton), findsWidgets);
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

    testWidgets('affiche les libellés traduits en arabe et supporte le RTL', (
      tester,
    ) async {
      final profile = _fakeProfile(
        slug: 'mohamed-plombier',
        businessName: 'محمد للسباكة',
        isVerified: true,
      );
      final repo = FakeProviderProfileRepository(profile: profile);

      await tester.pumpWidget(
        _wrap(
          const ProviderProfileScreen(slug: 'mohamed-plombier'),
          repository: repo,
          locale: const Locale('ar'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('محمد للسباكة'), findsWidgets);
      expect(find.text('إصلاح سباكة'), findsOneWidget);
      expect(find.text('سوسة المدينة'), findsOneWidget);
      expect(find.text('اتصال'), findsOneWidget);
      expect(find.text('واتساب'), findsOneWidget);
      expect(find.text('الخدمات'), findsOneWidget);
      expect(find.text('مناطق التدخل'), findsOneWidget);
      expect(find.text('التقييمات'), findsOneWidget);
    });

    testWidgets(
      'FM-10c — tap sur Appeler poste le contact via ContactButtons (P9)',
      (tester) async {
        final profile = _fakeProfile(
          slug: 'mohamed-plombier',
          businessName: 'Mohamed Plomberie',
        );
        final repo = FakeProviderProfileRepository(profile: profile);
        final contactService = _ContactServiceMock();
        registerFallbackValue(ContactChannel.phone);
        when(
          () => contactService.contact(
            providerId: any(named: 'providerId'),
            channel: any(named: 'channel'),
            categoryId: any(named: 'categoryId'),
            sourceScreen: any(named: 'sourceScreen'),
            locale: any(named: 'locale'),
            fallbackPhone: any(named: 'fallbackPhone'),
          ),
        ).thenAnswer((_) async {});

        await tester.pumpWidget(
          _wrap(
            const ProviderProfileScreen(slug: 'mohamed-plombier'),
            repository: repo,
            contactService: contactService,
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Appeler'));
        await tester.pump();

        verify(
          () => contactService.contact(
            providerId: 'provider-1',
            channel: ContactChannel.phone,
            categoryId: any(named: 'categoryId'),
            sourceScreen: 'provider_profile',
            locale: any(named: 'locale'),
            fallbackPhone: any(named: 'fallbackPhone'),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'FM-10c — la carte « Laisser un avis » navigue vers /providers/:slug/review',
      (tester) async {
        final profile = _fakeProfile(
          slug: 'mohamed-plombier',
          businessName: 'Mohamed Plomberie',
        );
        final repo = FakeProviderProfileRepository(profile: profile);

        final env = _wrapWithRouter(
          repository: repo,
          slug: 'mohamed-plombier',
        );
        await tester.pumpWidget(env.widget);
        await tester.pumpAndSettle();

        // La carte est plus bas que le viewport de test par défaut
        // (800x600) — la faire défiler en vue avant le tap.
        await tester.ensureVisible(find.text('Laisser un avis'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Laisser un avis'));
        await tester.pumpAndSettle();

        expect(find.text('review-screen'), findsOneWidget);
      },
    );

    testWidgets(
      'FM-26b — tap sur le bouton favori (non favori) ajoute aux favoris',
      (tester) async {
        final profile = _fakeProfile(
          slug: 'mohamed-plombier',
          businessName: 'Mohamed Plomberie',
        );
        final repo = FakeProviderProfileRepository(profile: profile);
        final favoritesRepository = _FavoritesRepositoryMock();
        when(favoritesRepository.fetchFavorites).thenAnswer(
          (_) async => FavoritesResponse((b) => b..nextCursor = ''),
        );
        when(
          () => favoritesRepository.addFavorite('provider-1'),
        ).thenAnswer((_) async {});

        await tester.pumpWidget(
          _wrap(
            const ProviderProfileScreen(slug: 'mohamed-plombier'),
            repository: repo,
            favoritesRepository: favoritesRepository,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.favorite_border), findsOneWidget);

        await tester.tap(find.byIcon(Icons.favorite_border));
        await tester.pumpAndSettle();

        verify(() => favoritesRepository.addFavorite('provider-1')).called(1);
      },
    );

    testWidgets(
      'FM-26b — tap sur le bouton favori (déjà favori) retire des favoris',
      (tester) async {
        final profile = _fakeProfile(
          slug: 'mohamed-plombier',
          businessName: 'Mohamed Plomberie',
        );
        final repo = FakeProviderProfileRepository(profile: profile);
        final favoritesRepository = _FavoritesRepositoryMock();
        const availableStatus =
            V1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnum.AVAILABLE;
        final favoriteItem = FavoriteItem(
          (item) => item
            ..providerId = 'provider-1'
            ..slug = 'mohamed-plombier'
            ..businessName = 'Mohamed Plomberie'
            ..headline = 'Plombier'
            ..isVerified = false
            ..ratingAvg = 4.5
            ..ratingCount = 10
            ..availabilityStatus = availableStatus
            ..favoritedAt = DateTime.utc(2026, 8, 26),
        );
        when(favoritesRepository.fetchFavorites).thenAnswer(
          (_) async => FavoritesResponse(
            (b) => b
              ..items.add(favoriteItem)
              ..nextCursor = '',
          ),
        );
        when(
          () => favoritesRepository.removeFavorite('provider-1'),
        ).thenAnswer((_) async {});

        await tester.pumpWidget(
          _wrap(
            const ProviderProfileScreen(slug: 'mohamed-plombier'),
            repository: repo,
            favoritesRepository: favoritesRepository,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.favorite), findsOneWidget);

        await tester.tap(find.byIcon(Icons.favorite));
        await tester.pumpAndSettle();

        verify(
          () => favoritesRepository.removeFavorite('provider-1'),
        ).called(1);
      },
    );
  });
}
