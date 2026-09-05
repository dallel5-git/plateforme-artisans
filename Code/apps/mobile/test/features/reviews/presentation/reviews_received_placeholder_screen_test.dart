import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/features/reviews/presentation/reviews_received_placeholder_screen.dart';

import '../../../core/widgets/widget_test_helpers.dart';

void main() {
  Widget buildScreen({Locale locale = const Locale('fr')}) {
    return ProviderScope(
      overrides: [localeProvider.overrideWith((ref) => locale)],
      child: themedApp(
        const ReviewsReceivedPlaceholderScreen(),
        locale: locale,
      ),
    );
  }

  group('FM-24b — ReviewsReceivedPlaceholderScreen', () {
    testWidgets('affiche le titre et le message en français', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('Avis'), findsOneWidget);
      expect(find.text("Aucun avis reçu pour l'instant"), findsOneWidget);
    });

    testWidgets('se rend en arabe sans exception (RTL)', (tester) async {
      await tester.pumpWidget(buildScreen(locale: const Locale('ar')));
      await tester.pumpAndSettle();

      expect(find.text('التقييمات'), findsOneWidget);
      expect(find.text('لا توجد تقييمات حتى الآن'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
