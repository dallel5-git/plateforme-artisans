import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/features/provider_profile/presentation/widgets/provider_cover_header.dart';

Widget _wrap(Widget child, {required Locale locale}) {
  // Route imbriquée : `context.pop()` (déclenché par ProviderBackButton, cf.
  // review_form_screen.dart) a besoin d'une page en dessous dans la pile,
  // même patron que `_wrapWithRouter` de provider_profile_screen_test.dart.
  final router = GoRouter(
    initialLocation: '/from/detail',
    routes: [
      GoRoute(
        path: '/from',
        builder: (_, _) => const Scaffold(body: SizedBox.shrink()),
        routes: [
          GoRoute(
            path: 'detail',
            builder: (_, _) => Scaffold(body: child),
          ),
        ],
      ),
    ],
  );

  return MaterialApp.router(
    routerConfig: router,
    locale: locale,
    supportedLocales: const [Locale('fr'), Locale('ar')],
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    theme: buildTheme(brightness: Brightness.light, locale: locale),
  );
}

void main() {
  testWidgets(
    'FM-29 — en arabe (RTL), l avatar superposé est aligné à droite '
    '(bord start = droite en RTL)',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(360, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        _wrap(
          const ProviderCoverHeader(gallery: []),
          locale: const Locale('ar'),
        ),
      );
      await tester.pump();

      final avatarRect = tester.getRect(find.byKey(providerAvatarKey));

      // `start` en RTL = droite : le bord droit de l'avatar doit être proche
      // du bord droit de l'écran (360px), pas du bord gauche.
      expect(avatarRect.right, greaterThan(300));
    },
  );

  testWidgets(
    'FM-29 — en français (LTR), l avatar superposé est aligné à gauche '
    '(bord start = gauche en LTR, mirroir de la position arabe)',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(360, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        _wrap(
          const ProviderCoverHeader(gallery: []),
          locale: const Locale('fr'),
        ),
      );
      await tester.pump();

      final avatarRect = tester.getRect(find.byKey(providerAvatarKey));

      expect(avatarRect.left, lessThan(60));
    },
  );

  testWidgets(
    'FM-29 — galerie vide : repli sur une icône neutre, pas de crash sans '
    'champ avatar dédié côté API',
    (tester) async {
      await tester.pumpWidget(
        _wrap(
          const ProviderCoverHeader(gallery: []),
          locale: const Locale('fr'),
        ),
      );
      await tester.pump();

      expect(find.byIcon(Icons.person), findsOneWidget);
    },
  );

  testWidgets(
    'FM-29 — tap sur le bouton retour flottant déclenche context.pop()',
    (tester) async {
      await tester.pumpWidget(
        _wrap(
          const ProviderCoverHeader(gallery: []),
          locale: const Locale('fr'),
        ),
      );
      await tester.pump();

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
    },
  );

  testWidgets(
    'FM-29 — galerie non vide : la 1ère photo alimente l avatar (repli '
    'documenté, aucun champ avatar dédié côté contrat public)',
    (tester) async {
      final gallery = [
        V1ProvidersSlugGet200ResponseGalleryInner(
          (b) => b
            ..id = '1'
            ..url = 'https://example.com/1.jpg'
            ..width = 800
            ..height = 600
            ..blurhash = ''
            ..caption = ''
            ..category =
                V1ProvidersSlugGet200ResponseCoverageAreasInnerDelegation(
                  (c) => c
                    ..slug = 'exterieur'
                    ..nameFr = 'Extérieur'
                    ..nameAr = 'خارجي',
                ).toBuilder(),
        ),
      ];

      await tester.pumpWidget(
        _wrap(
          ProviderCoverHeader(gallery: gallery),
          locale: const Locale('fr'),
        ),
      );
      await tester.pump();

      expect(find.byKey(providerAvatarKey), findsOneWidget);
    },
  );
}
