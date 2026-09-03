import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/features/pro_profile/presentation/pro_profile_placeholder_screen.dart';

import '../../../core/widgets/widget_test_helpers.dart';

void main() {
  Widget buildScreen({Locale locale = const Locale('fr')}) {
    return ProviderScope(
      overrides: [localeProvider.overrideWith((ref) => locale)],
      child: themedApp(const ProProfilePlaceholderScreen(), locale: locale),
    );
  }

  group('FM-24b — ProProfilePlaceholderScreen', () {
    testWidgets('affiche le titre et le message « bientôt disponible » en '
        'français', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('Profil'), findsOneWidget);
      expect(
        find.text('Édition du profil bientôt disponible'),
        findsOneWidget,
      );
    });

    testWidgets('se rend en arabe sans exception (RTL)', (tester) async {
      await tester.pumpWidget(buildScreen(locale: const Locale('ar')));
      await tester.pumpAndSettle();

      expect(find.text('تعديل الملف الشخصي قريباً'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      "FM-25 : propose le retour vers l'espace Client — atteindre cet "
      'écran suppose déjà une session PROVIDER (garde /pro/*)',
      (tester) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();

        expect(find.text("Retour à l'espace Client"), findsOneWidget);
      },
    );

    testWidgets(
      'FM-25 : le bouton de retour navigue vers /client',
      (tester) async {
        final testRouter = GoRouter(
          initialLocation: '/pro/profile',
          routes: [
            GoRoute(
              path: '/pro/profile',
              builder: (_, _) => const ProProfilePlaceholderScreen(),
            ),
            GoRoute(
              path: '/client',
              builder: (_, _) => const Text('CLIENT_PLACEHOLDER'),
            ),
          ],
        );

        tester.view.physicalSize = const Size(400, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp.router(
              theme: buildTheme(
                brightness: Brightness.light,
                locale: const Locale('fr'),
              ),
              locale: const Locale('fr'),
              routerConfig: testRouter,
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text("Retour à l'espace Client"));
        await tester.pumpAndSettle();

        expect(find.text('CLIENT_PLACEHOLDER'), findsOneWidget);
      },
    );
  });
}
