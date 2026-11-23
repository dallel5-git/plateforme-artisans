import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/core/i18n/translations.g.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/features/onboarding/application/onboarding_state.dart';
import 'package:sanaya/features/onboarding/data/onboarding_repository.dart';
import 'package:sanaya/features/onboarding/presentation/widgets/onboarding_summary_step.dart';

class _MockProviderMe extends Mock implements ProviderMe {}

ProviderMe _profile({
  String bio = '',
  String headline = '',
  int yearsExperience = 0,
  String whatsappPhone = '',
  String publicPhone = '',
}) {
  final mock = _MockProviderMe();
  when(() => mock.bio).thenReturn(bio);
  when(() => mock.headline).thenReturn(headline);
  when(() => mock.yearsExperience).thenReturn(yearsExperience);
  when(() => mock.whatsappPhone).thenReturn(whatsappPhone);
  when(() => mock.publicPhone).thenReturn(publicPhone);
  return mock;
}

Widget _wrap(Widget child) => ProviderScope(
  child: MaterialApp(
    theme: buildTheme(brightness: Brightness.light, locale: const Locale('fr')),
    locale: const Locale('fr'),
    home: Scaffold(body: child),
  ),
);

void main() {
  final t = AppLocale.fr.buildSync();
  late AppColors appColors;

  setUpAll(() {
    final theme = buildTheme(
      brightness: Brightness.light,
      locale: const Locale('fr'),
    );
    appColors = theme.extension<AppColors>()!;
  });

  group('computeMissingKeys', () {
    test('profil null -> les 4 clés majeures manquent', () {
      expect(computeMissingKeys(null), [
        'bio',
        'headline',
        'yearsExperience',
        'contactPhone',
      ]);
    });

    test('profil complet -> aucune clé manquante', () {
      final profile = _profile(
        bio: 'x' * 50,
        headline: 'Plombier certifié',
        yearsExperience: 5,
        whatsappPhone: '+21622123456',
      );
      expect(computeMissingKeys(profile), isEmpty);
    });

    test('bio trop courte -> "bio" listée', () {
      final profile = _profile(
        bio: 'trop court',
        headline: 'x',
        yearsExperience: 2,
        publicPhone: '+21671123456',
      );
      expect(computeMissingKeys(profile), ['bio']);
    });

    test(
      'ni whatsapp ni téléphone public -> "contactPhone" listée',
      () {
        final profile = _profile(
          bio: 'x' * 50,
          headline: 'x',
          yearsExperience: 2,
        );
        expect(computeMissingKeys(profile), ['contactPhone']);
      },
    );
  });

  group('missingKeyLabel', () {
    test('mappe chaque clé connue vers son libellé localisé', () {
      expect(missingKeyLabel(t, 'bio'), t.onboarding.missingBio);
      expect(missingKeyLabel(t, 'headline'), t.onboarding.missingHeadline);
      expect(
        missingKeyLabel(t, 'yearsExperience'),
        t.onboarding.missingYearsExperience,
      );
      expect(
        missingKeyLabel(t, 'contactPhone'),
        t.onboarding.missingContactPhone,
      );
      expect(
        missingKeyLabel(t, 'categories'),
        t.onboarding.missingCategories,
      );
      expect(
        missingKeyLabel(t, 'coverageAreas'),
        t.onboarding.missingCoverageAreas,
      );
      expect(
        missingKeyLabel(t, 'photos'),
        t.onboarding.missingPhotos,
      );
    });

    test('clé inconnue -> repli sur la clé elle-même', () {
      expect(missingKeyLabel(t, 'phoneVerified'), 'phoneVerified');
    });
  });

  group('missingKeyStep & stepName (MOB-028)', () {
    test('mappe correctement chaque clé vers son étape cible', () {
      expect(missingKeyStep('bio'), OnboardingStep.profile);
      expect(missingKeyStep('headline'), OnboardingStep.profile);
      expect(missingKeyStep('yearsExperience'), OnboardingStep.profile);
      expect(missingKeyStep('contactPhone'), OnboardingStep.profile);
      expect(missingKeyStep('categories'), OnboardingStep.categories);
      expect(missingKeyStep('coverageAreas'), OnboardingStep.zones);
      expect(missingKeyStep('photos'), OnboardingStep.photos);
      expect(missingKeyStep('unknown'), OnboardingStep.profile);

      expect(missingKeyStepName(t, 'bio'), t.onboarding.stepProfile);
      expect(missingKeyStepName(t, 'categories'), t.onboarding.stepCategories);
      expect(missingKeyStepName(t, 'coverageAreas'), t.onboarding.stepZones);
      expect(missingKeyStepName(t, 'photos'), t.onboarding.stepPhotos);
    });

    test('fournit une icône pour chaque clé', () {
      expect(missingKeyIcon('bio'), Icons.description_outlined);
      expect(missingKeyIcon('headline'), Icons.badge_outlined);
      expect(missingKeyIcon('yearsExperience'), Icons.work_history_outlined);
      expect(missingKeyIcon('contactPhone'), Icons.phone_outlined);
      expect(missingKeyIcon('categories'), Icons.category_outlined);
      expect(missingKeyIcon('coverageAreas'), Icons.location_on_outlined);
      expect(missingKeyIcon('photos'), Icons.photo_library_outlined);
      expect(missingKeyIcon('other'), Icons.edit_outlined);
    });
  });

  group('completionScoreColor & status (MOB-028)', () {
    test('score < 40 : rouge (destructive) et statut critique', () {
      expect(completionScoreColor(appColors, 30), appColors.destructive);
      expect(
        completionScoreStatusText(t, 30),
        t.onboarding.summaryScoreCritical,
      );
    });

    test('40 <= score < 60 : orange (amber) et statut warning', () {
      expect(completionScoreColor(appColors, 40), appColors.amber);
      expect(completionScoreColor(appColors, 59), appColors.amber);
      expect(
        completionScoreStatusText(t, 45),
        t.onboarding.summaryScoreWarning,
      );
    });

    test('score >= 60 : vert (verified) et statut succès', () {
      expect(completionScoreColor(appColors, 60), appColors.verified);
      expect(completionScoreColor(appColors, 85), appColors.verified);
      expect(
        completionScoreStatusText(t, 75),
        t.onboarding.summaryScoreSuccess,
      );
    });
  });

  group('OnboardingSummaryStep (MOB-028)', () {
    testWidgets(
      'affiche la jauge de progression et les tuiles d action interactives',
      (tester) async {
        OnboardingStep? navigatedStep;

        await tester.pumpWidget(
          _wrap(
            OnboardingSummaryStep(
              profile: null,
              completionScore: 36,
              canPublish: false,
              isSaving: false,
              errorMessage: null,
              published: false,
              onPublish: (_) {},
              onNavigateToStep: (step) => navigatedStep = step,
            ),
          ),
        );

        // Progression & jauge
        expect(find.textContaining('36'), findsWidgets);
        expect(find.text(t.onboarding.summaryScoreCritical), findsOneWidget);
        expect(find.byType(LinearProgressIndicator), findsOneWidget);

        // Tuile d'action claire pour bio
        expect(find.text(t.onboarding.missingBio), findsOneWidget);
        expect(find.text(t.onboarding.missingHeadline), findsOneWidget);

        // Tap sur la tuile bio navigue vers OnboardingStep.profile
        await tester.tap(find.text(t.onboarding.missingBio));
        expect(navigatedStep, OnboardingStep.profile);
      },
    );

    testWidgets(
      '🔒 tap sur Publier relaie les clés manquantes calculées ici (P3)',
      (tester) async {
        List<String>? received;
        await tester.pumpWidget(
          _wrap(
            OnboardingSummaryStep(
              profile: null,
              completionScore: 36,
              canPublish: false,
              isSaving: false,
              errorMessage: null,
              published: false,
              onPublish: (keys) => received = keys,
            ),
          ),
        );

        await tester.tap(find.text(t.onboarding.summaryPublish));

        expect(received, [
          'bio',
          'headline',
          'yearsExperience',
          'contactPhone',
        ]);
      },
    );

    testWidgets('affiche le message de succès une fois publié', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          OnboardingSummaryStep(
            profile: null,
            completionScore: 72,
            canPublish: true,
            isSaving: false,
            errorMessage: null,
            published: true,
            onPublish: (_) {},
          ),
        ),
      );

      expect(find.text(t.onboarding.summaryPublished), findsOneWidget);
      expect(find.text(t.onboarding.summaryScoreSuccess), findsOneWidget);
    });
  });
}
