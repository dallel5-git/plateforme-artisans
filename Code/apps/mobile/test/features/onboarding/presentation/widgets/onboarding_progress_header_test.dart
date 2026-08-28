import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/features/onboarding/presentation/widgets/onboarding_progress_header.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: buildTheme(brightness: Brightness.light, locale: const Locale('fr')),
  locale: const Locale('fr'),
  home: Scaffold(body: child),
);

void main() {
  testWidgets('affiche les 4 étapes et la valeur de complétude', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const OnboardingProgressHeader(
          stepLabels: ['Profil', 'Catégories', 'Zones', 'Récap'],
          currentStepIndex: 1,
          completionScore: 54,
        ),
      ),
    );

    for (final label in ['Profil', 'Catégories', 'Zones', 'Récap']) {
      expect(find.text(label), findsOneWidget);
    }

    final progress = tester.widget<LinearProgressIndicator>(
      find.byType(LinearProgressIndicator),
    );
    expect(progress.value, closeTo(0.54, 0.001));
  });

  testWidgets('borne la barre à 100 % même au-delà (défense simple)', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const OnboardingProgressHeader(
          stepLabels: ['Profil'],
          currentStepIndex: 0,
          completionScore: 120,
        ),
      ),
    );

    final progress = tester.widget<LinearProgressIndicator>(
      find.byType(LinearProgressIndicator),
    );
    expect(progress.value, 1.0);
  });
}
