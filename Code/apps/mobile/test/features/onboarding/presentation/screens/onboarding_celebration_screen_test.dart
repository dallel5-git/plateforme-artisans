import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/core/i18n/translations.g.dart';
import 'package:sanaya/core/widgets/verified_badge.dart';
import 'package:sanaya/features/onboarding/presentation/onboarding_celebration_screen.dart';

Widget _wrap(
  Widget child, {
  Locale locale = const Locale('fr'),
  Brightness brightness = Brightness.light,
}) => ProviderScope(
  overrides: [
    localeProvider.overrideWith((ref) => locale),
  ],
  child: MaterialApp(
    theme: buildTheme(brightness: brightness, locale: locale),
    locale: locale,
    home: child,
  ),
);

void main() {
  final tFr = AppLocale.fr.buildSync();
  final tAr = AppLocale.ar.buildSync();

  group('OnboardingCelebrationScreen (MOB-029)', () {
    testWidgets(
      'affiche tous les éléments de célébration et avantages KYC en FR',
      (tester) async {
        tester.view.physicalSize = const Size(400, 1200);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(_wrap(const OnboardingCelebrationScreen()));
        await tester.pumpAndSettle();

        expect(find.text(tFr.onboarding.celebrationTitle), findsOneWidget);
        expect(find.text(tFr.onboarding.celebrationSubtitle), findsOneWidget);
        expect(find.byType(VerifiedBadge), findsOneWidget);
        expect(
          find.text(tFr.onboarding.celebrationKycCardTitle),
          findsOneWidget,
        );
        expect(
          find.text(tFr.onboarding.celebrationKycCardDescription),
          findsOneWidget,
        );
        expect(
          find.text(tFr.onboarding.celebrationKycBenefitBadge),
          findsOneWidget,
        );
        expect(
          find.text(tFr.onboarding.celebrationKycBenefitRank),
          findsOneWidget,
        );
        expect(
          find.text(tFr.onboarding.celebrationKycBenefitFast),
          findsOneWidget,
        );
        expect(find.text(tFr.onboarding.celebrationCtaVerify), findsOneWidget);
        expect(
          find.text(tFr.onboarding.celebrationCtaDashboard),
          findsOneWidget,
        );
      },
    );

    testWidgets('affiche correctement en arabe (RTL) sans débordement', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(400, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _wrap(
          const OnboardingCelebrationScreen(),
          locale: const Locale('ar'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(tAr.onboarding.celebrationTitle), findsOneWidget);
      expect(find.text(tAr.onboarding.celebrationSubtitle), findsOneWidget);
      expect(find.text(tAr.onboarding.celebrationKycCardTitle), findsOneWidget);
      expect(find.text(tAr.onboarding.celebrationCtaVerify), findsOneWidget);
      expect(find.text(tAr.onboarding.celebrationCtaDashboard), findsOneWidget);
    });

    testWidgets('affiche correctement en mode sombre', (tester) async {
      tester.view.physicalSize = const Size(400, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _wrap(
          const OnboardingCelebrationScreen(),
          brightness: Brightness.dark,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(tFr.onboarding.celebrationTitle), findsOneWidget);
      expect(find.text(tFr.onboarding.celebrationCtaVerify), findsOneWidget);
    });

    testWidgets('déclenche onVerifyNow lors du clic sur le CTA principal', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(400, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      var verifyCalled = false;

      await tester.pumpWidget(
        _wrap(
          OnboardingCelebrationScreen(
            onVerifyNow: () => verifyCalled = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text(tFr.onboarding.celebrationCtaVerify));
      await tester.pumpAndSettle();

      expect(verifyCalled, isTrue);
    });

    testWidgets(
      'déclenche onGoToDashboard lors du clic sur le CTA secondaire',
      (tester) async {
        tester.view.physicalSize = const Size(400, 1200);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        var dashboardCalled = false;

        await tester.pumpWidget(
          _wrap(
            OnboardingCelebrationScreen(
              onGoToDashboard: () => dashboardCalled = true,
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text(tFr.onboarding.celebrationCtaDashboard));
        await tester.pumpAndSettle();

        expect(dashboardCalled, isTrue);
      },
    );

    testWidgets('navigation par défaut avec GoRouter', (tester) async {
      tester.view.physicalSize = const Size(400, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      final router = GoRouter(
        initialLocation: '/pro/celebration',
        routes: [
          GoRoute(
            path: '/pro/celebration',
            builder: (_, _) => const OnboardingCelebrationScreen(),
          ),
          GoRoute(
            path: '/pro/verification',
            builder: (_, _) => const Text('VERIFICATION_SCREEN'),
          ),
          GoRoute(
            path: '/pro/dashboard',
            builder: (_, _) => const Text('DASHBOARD_SCREEN'),
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            theme: buildTheme(
              brightness: Brightness.light,
              locale: const Locale('fr'),
            ),
            locale: const Locale('fr'),
            routerConfig: router,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap verify -> /pro/verification
      await tester.tap(find.text(tFr.onboarding.celebrationCtaVerify));
      await tester.pumpAndSettle();
      expect(find.text('VERIFICATION_SCREEN'), findsOneWidget);

      // Return to celebration
      router.go('/pro/celebration');
      await tester.pumpAndSettle();

      // Tap dashboard -> /pro/dashboard
      await tester.tap(find.text(tFr.onboarding.celebrationCtaDashboard));
      await tester.pumpAndSettle();
      expect(find.text('DASHBOARD_SCREEN'), findsOneWidget);
    });
  });
}
