import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/features/profile/presentation/profile_placeholder_screen.dart';

import '../../../core/widgets/widget_test_helpers.dart';

void main() {
  Widget buildScreen({Locale locale = const Locale('fr')}) {
    return ProviderScope(
      overrides: [localeProvider.overrideWith((ref) => locale)],
      child: themedApp(const ProfilePlaceholderScreen(), locale: locale),
    );
  }

  group('FM-23a — ProfilePlaceholderScreen', () {
    testWidgets('affiche le titre et le message « bientôt disponible » en '
        'français', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('Profil'), findsOneWidget);
      expect(find.text('Profil bientôt disponible'), findsOneWidget);
    });

    testWidgets('se rend en arabe sans exception (RTL)', (tester) async {
      await tester.pumpWidget(buildScreen(locale: const Locale('ar')));
      await tester.pumpAndSettle();

      expect(find.text('الملف الشخصي قريباً'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      '🔒 réglages relogés depuis le hub (FM-23) : la bascule langue '
      'fonctionne toujours',
      (tester) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();

        expect(find.text('Profil'), findsOneWidget);

        await tester.tap(find.byIcon(Icons.language));
        await tester.pumpAndSettle();

        expect(find.text('الملف الشخصي'), findsOneWidget);
      },
    );

    testWidgets(
      '🔒 réglages relogés depuis le hub (FM-23) : la bascule thème '
      'fonctionne toujours',
      (tester) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.light_mode), findsOneWidget);

        await tester.tap(find.byIcon(Icons.light_mode));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.dark_mode), findsOneWidget);
      },
    );
  });
}
