import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/core/widgets/app_button.dart';
import 'package:sanaya/features/provider_profile/application/provider_profile_providers.dart';
import 'package:sanaya/features/provider_profile/application/review_submission_notifier.dart';
import 'package:sanaya/features/provider_profile/data/provider_profile_repository.dart';
import 'package:sanaya/features/provider_profile/data/reviews_repository.dart';
import 'package:sanaya/features/provider_profile/presentation/screens/review_form_screen.dart';

class _ProfileMock extends Mock implements ProviderProfile {}

class _ProfileRepoMock extends Mock implements ProviderProfileRepository {}

class _ReviewsRepoMock extends Mock implements ReviewsRepository {}

/// `context.pop()` (go_router) exige un `GoRouter` ancêtre avec une pile non
/// vide. `initialLocation: '/'` puis un `push('/review')` explicite dans le
/// test (pas `initialLocation: '/review'` directement) donne une vraie page
/// sous-jacente à dépiler — sans ça, `pop()` lève `GoError('There is
/// nothing to pop')`.
({Widget widget, GoRouter router}) _wrap({
  required ProviderProfileRepository profileRepository,
  required ReviewsRepository reviewsRepository,
  String slug = 'sami-plombier',
}) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (_, _) => const SizedBox()),
      GoRoute(
        path: '/review',
        builder: (_, _) => ReviewFormScreen(slug: slug),
      ),
    ],
  );

  final widget = ProviderScope(
    overrides: [
      providerProfileRepositoryProvider.overrideWithValue(profileRepository),
      reviewsRepositoryProvider.overrideWithValue(reviewsRepository),
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
  late _ProfileMock profile;
  late _ProfileRepoMock profileRepository;
  late _ReviewsRepoMock reviewsRepository;

  setUp(() {
    profile = _ProfileMock();
    when(() => profile.id).thenReturn('prov-1');
    when(() => profile.businessName).thenReturn('Sami Plombier');
    when(() => profile.gallery).thenReturn(BuiltList());

    profileRepository = _ProfileRepoMock();
    when(
      () => profileRepository.fetchProfile('sami-plombier'),
    ).thenAnswer((_) async => profile);

    reviewsRepository = _ReviewsRepoMock();
  });

  group('FM-10b — ReviewFormScreen', () {
    testWidgets(
      'FM-30 — affiche qui l on note (raison sociale + badge Contact '
      'vérifié) avant la première étoile',
      (tester) async {
        final env = _wrap(
          profileRepository: profileRepository,
          reviewsRepository: reviewsRepository,
        );
        await tester.pumpWidget(env.widget);
        unawaited(env.router.push<void>('/review'));
        await tester.pumpAndSettle();

        expect(find.text('Sami Plombier'), findsOneWidget);
        expect(find.text('Contact vérifié'), findsOneWidget);
      },
    );

    testWidgets("bouton désactivé tant qu'aucune étoile n'est sélectionnée", (
      tester,
    ) async {
      final env = _wrap(
        profileRepository: profileRepository,
        reviewsRepository: reviewsRepository,
      );
      await tester.pumpWidget(env.widget);
      unawaited(env.router.push<void>('/review'));
      await tester.pumpAndSettle();

      final button = tester.widget<AppButton>(find.byType(AppButton));
      expect(button.onPressed, isNull);
    });

    testWidgets(
      'tap sur la 4ᵉ étoile puis soumission appelle createReview et '
      'affiche le succès',
      (tester) async {
        final reviewDto = V1ProvidersIdReviewsPost200Response(
          (b) => b
            ..id = 'rev-1'
            ..rating = 4
            ..comment = ''
            ..isVerifiedContact = true
            ..createdAt = DateTime.utc(2026, 8, 28),
        );
        when(
          () => reviewsRepository.createReview(
            providerId: 'prov-1',
            rating: 4,
            comment: any(named: 'comment'),
          ),
        ).thenAnswer((_) async => reviewDto);

        final env = _wrap(
          profileRepository: profileRepository,
          reviewsRepository: reviewsRepository,
        );
        await tester.pumpWidget(env.widget);
        unawaited(env.router.push<void>('/review'));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.star_border).at(3));
        await tester.pump();
        await tester.tap(find.text("Publier l'avis"));
        // `pump()` explicite, pas `pumpAndSettle()` : le SnackBar a sa propre
        // durée d'affichage (~4 s) et son animation de disparition —
        // `pumpAndSettle()` les traverserait entièrement et le texte aurait
        // déjà disparu au moment de l'assertion. Deux pumps suffisent à
        // laisser le Future (mock async) se résoudre et le pop + SnackBar
        // s'exécuter, sans avancer jusqu'à sa disparition.
        await tester.pump();
        await tester.pump();

        verify(
          () => reviewsRepository.createReview(
            providerId: 'prov-1',
            rating: 4,
            comment: any(named: 'comment'),
          ),
        ).called(1);
        expect(find.text('Merci ! Votre avis a été publié.'), findsOneWidget);
      },
    );

    testWidgets('erreur 403 REVIEW_REQUIRES_CONTACT affiche le bon message', (
      tester,
    ) async {
      when(
        () => reviewsRepository.createReview(
          providerId: 'prov-1',
          rating: any(named: 'rating'),
          comment: any(named: 'comment'),
        ),
      ).thenThrow(
        ForbiddenException(
          code: 'REVIEW_REQUIRES_CONTACT',
          message: 'Aucun contact éligible',
        ),
      );

      final env = _wrap(
        profileRepository: profileRepository,
        reviewsRepository: reviewsRepository,
      );
      await tester.pumpWidget(env.widget);
      unawaited(env.router.push<void>('/review'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.star_border).first);
      await tester.pump();
      await tester.tap(find.text("Publier l'avis"));
      await tester.pumpAndSettle();

      expect(
        find.text(
          'Vous devez avoir contacté cet artisan pour pouvoir laisser un avis.',
        ),
        findsOneWidget,
      );
    });
  });
}
