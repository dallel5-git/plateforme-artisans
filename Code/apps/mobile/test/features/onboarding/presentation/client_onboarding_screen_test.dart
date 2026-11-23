import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/features/onboarding/presentation/client_onboarding_screen.dart';

void main() {
  Widget buildScreen({Locale locale = const Locale('fr')}) {
    final testRouter = GoRouter(
      initialLocation: '/client/onboarding',
      routes: [
        GoRoute(
          path: '/client/onboarding',
          builder: (_, _) => const ClientOnboardingScreen(),
        ),
        GoRoute(
          path: '/client',
          builder: (_, _) => const Text('CLIENT_SCREEN_PLACEHOLDER'),
        ),
      ],
    );

    return ProviderScope(
      child: MaterialApp.router(
        theme: buildTheme(
          brightness: Brightness.light,
          locale: locale,
        ),
        locale: locale,
        supportedLocales: const [Locale('fr'), Locale('ar')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        routerConfig: testRouter,
      ),
    );
  }

  group('ClientOnboardingScreen', () {
    testWidgets('affiche le premier slide du carrousel et le bouton Passer', (
      tester,
    ) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(
        find.text("Trouvez l'artisan idéal"),
        findsOneWidget,
      );
      expect(find.text("Passer l'introduction"), findsOneWidget);
      expect(find.text('Suivant'), findsOneWidget);
    });

    testWidgets('taper sur Passer navigue vers /client', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      await tester.tap(find.text("Passer l'introduction"));
      await tester.pumpAndSettle();

      expect(find.text('CLIENT_SCREEN_PLACEHOLDER'), findsOneWidget);
    });

    testWidgets(
      'taper sur Suivant avance jusqu au dernier slide avec CTA Commencer',
      (tester) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();

        // Slide 1 -> Slide 2
        await tester.tap(find.text('Suivant'));
        await tester.pumpAndSettle();

        expect(
          find.text('Confiance & Avis vérifiés'),
          findsOneWidget,
        );

        // Slide 2 -> Slide 3
        await tester.tap(find.text('Suivant'));
        await tester.pumpAndSettle();

        expect(
          find.text('Contact direct & 100% gratuit'),
          findsOneWidget,
        );
        expect(find.text('Commencer à chercher'), findsOneWidget);

        // Tap on Commencer
        await tester.tap(find.text('Commencer à chercher'));
        await tester.pumpAndSettle();

        expect(find.text('CLIENT_SCREEN_PLACEHOLDER'), findsOneWidget);
      },
    );

    testWidgets('se rend en arabe sans exception (RTL)', (tester) async {
      await tester.pumpWidget(buildScreen(locale: const Locale('ar')));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
