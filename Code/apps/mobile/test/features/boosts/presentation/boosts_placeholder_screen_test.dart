import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/features/boosts/presentation/boosts_placeholder_screen.dart';

import '../../../core/widgets/widget_test_helpers.dart';

void main() {
  Widget buildScreen({Locale locale = const Locale('fr')}) {
    return ProviderScope(
      overrides: [localeProvider.overrideWith((ref) => locale)],
      child: themedApp(const BoostsPlaceholderScreen(), locale: locale),
    );
  }

  group('FM-24b — BoostsPlaceholderScreen', () {
    testWidgets('affiche le titre et le message « bientôt disponible » en '
        'français', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('Boosts'), findsOneWidget);
      expect(find.text('Boosts bientôt disponibles'), findsOneWidget);
    });

    testWidgets('se rend en arabe sans exception (RTL)', (tester) async {
      await tester.pumpWidget(buildScreen(locale: const Locale('ar')));
      await tester.pumpAndSettle();

      expect(find.text('التعزيزات قريباً'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
