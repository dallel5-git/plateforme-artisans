import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/core/i18n/translations.g.dart';
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
    });

    test('clé inconnue -> repli sur la clé elle-même', () {
      expect(missingKeyLabel(t, 'phoneVerified'), 'phoneVerified');
    });
  });

  group('OnboardingSummaryStep', () {
    testWidgets(
      'affiche la liste des manques quand canPublish est faux',
      (tester) async {
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
            ),
          ),
        );

        expect(find.textContaining('36'), findsOneWidget);
        expect(find.text('• ${t.onboarding.missingBio}'), findsOneWidget);
      },
    );

    testWidgets(
      '🔒 tap sur Publier relaie les clés manquantes calculées ici (P3)',
      (tester) async {
        // 🔒 NON-RÉGRESSION — c'est ce widget qui calcule `missingKeys`
        // (le serveur reste seul juge de `canPublish`) ; s'il relaie une
        // liste différente de ce qu'il affiche, le récap et le POST divergent.
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
    });
  });
}
