import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/features/onboarding/presentation/widgets/onboarding_progress_header.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: buildTheme(brightness: Brightness.light, locale: const Locale('fr')),
  locale: const Locale('fr'),
  home: Scaffold(body: child),
);

void main() {
  testWidgets("affiche les libellés d'étape, le compteur et l'étape courante", (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const OnboardingProgressHeader(
          stepLabels: ['Profil', 'Catégories', 'Zones', 'Récap'],
          currentStepIndex: 1,
          stepCountLabel: 'Étape 2 sur 4',
        ),
      ),
    );

    expect(find.text('Étape 2 sur 4'), findsOneWidget);
    expect(find.text('Catégories'), findsOneWidget);
  });

  testWidgets(
    "remplit un segment par étape jusqu'à l'étape courante, pas au-delà",
    (tester) async {
      await tester.pumpWidget(
        _wrap(
          const OnboardingProgressHeader(
            stepLabels: ['Profil', 'Catégories', 'Zones', 'Récap'],
            currentStepIndex: 2,
            stepCountLabel: 'Étape 3 sur 4',
          ),
        ),
      );

      final colors = tester
          .element(find.byType(OnboardingProgressHeader))
          .colors;
      final segmentColors = tester
          .widgetList<Container>(find.byType(Container))
          .where((c) => c.constraints?.maxHeight == 6)
          .map((c) => c.color)
          .toList();

      expect(segmentColors, hasLength(4));
      expect(
        segmentColors.where((c) => c == colors.accent).length,
        3,
        reason: 'les segments 0, 1 et 2 (<= currentStepIndex) sont remplis',
      );
      expect(
        segmentColors.where((c) => c == colors.border).length,
        1,
        reason: 'le segment 3 (au-delà de currentStepIndex) reste neutre',
      );
    },
  );
}
