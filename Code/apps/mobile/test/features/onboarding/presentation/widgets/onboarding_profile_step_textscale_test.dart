import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/features/onboarding/data/onboarding_repository.dart';
import 'package:sanaya/features/onboarding/presentation/widgets/onboarding_profile_step.dart';
import 'package:sanaya/features/search/application/catalog_providers.dart';
import 'package:sanaya/features/search/data/catalog_repository.dart';

import '../../../../support/overflow_guard.dart';

class _MockGovernorate extends Mock implements Governorate {}

class _MockProviderMe extends Mock implements ProviderMe {}

Governorate _governorate(String id, String nameFr, String nameAr) {
  final g = _MockGovernorate();
  when(() => g.id).thenReturn(id);
  when(() => g.nameFr).thenReturn(nameFr);
  when(() => g.nameAr).thenReturn(nameAr);
  return g;
}

/// Profil dense — mêmes 7 champs simultanément visibles (aucune étape n'a
/// autant de `AppTextField` d'affilée dans l'onboarding), + message d'erreur
/// affiché, pour stresser la mise en page la plus chargée du parcours à
/// `TextScaler.linear(1.3)` (FM-17, critère d'acceptation étendu par FM-43).
ProviderMe _denseProfile() {
  final profile = _MockProviderMe();
  when(() => profile.businessName).thenReturn(
    'Établissement Ben Abdallah Climatisation & Plomberie',
  );
  when(() => profile.headline).thenReturn(
    'Spécialiste climatisation réversible, chauffage central et '
    'plomberie sanitaire — intervention rapide 7j/7 dans tout le Sahel',
  );
  when(() => profile.bio).thenReturn(
    "Plus de 15 ans d'expérience dans l'installation et la maintenance "
    'de systèmes de climatisation, chauffage central et plomberie '
    'sanitaire pour particuliers et professionnels.',
  );
  when(() => profile.yearsExperience).thenReturn(15);
  when(() => profile.whatsappPhone).thenReturn('+21622123456');
  when(() => profile.publicPhone).thenReturn('+21673123456');
  when(() => profile.baseGovernorateId).thenReturn('sousse');
  return profile;
}

Widget _wrap({required Locale locale, required TextScaler textScaler}) {
  return ProviderScope(
    overrides: [
      governoratesProvider.overrideWith(
        (ref) async => [
          _governorate('sousse', 'Sousse', 'سوسة'),
          _governorate(
            'monastir',
            'Monastir',
            'المنستير',
          ),
        ],
      ),
    ],
    child: MaterialApp(
      locale: locale,
      supportedLocales: const [Locale('fr'), Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: buildTheme(brightness: Brightness.light, locale: locale),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: textScaler),
        child: child!,
      ),
      home: Directionality(
        textDirection: locale.languageCode == 'ar'
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: Scaffold(
          body: OnboardingProfileStep(
            initialProfile: _denseProfile(),
            isSaving: false,
            // Ligne de texte supplémentaire volontairement présente — même
            // état que celui vu par un artisan qui vient de corriger un
            // champ invalide.
            errorMessage:
                'Le gouvernorat de rattachement est obligatoire pour publier '
                'votre fiche',
            onSubmit: (_) {},
          ),
        ),
      ),
    ),
  );
}

/// FM-43 — étend le patron `TextScaler` 1.3 (FM-17b) à `OnboardingProfileStep`
/// (l'écran de résultats de recherche visé à l'origine, FM-28d, n'existe pas
/// encore — substitué par l'étape la plus dense de l'onboarding, documenté
/// dans la PR).
void main() {
  group(
    'FM-43 — OnboardingProfileStep, TextScaler 1.3 (accessibilité)',
    () {
      testWidgets(
        'aucun débordement à 130% avec un profil dense, en français',
        (tester) async {
          await tester.binding.setSurfaceSize(const Size(360, 800));
          addTearDown(() => tester.binding.setSurfaceSize(null));

          final errors = await captureFlutterErrors(() async {
            await tester.pumpWidget(
              _wrap(
                locale: const Locale('fr'),
                textScaler: const TextScaler.linear(1.3),
              ),
            );
            await tester.pumpAndSettle();
          });

          expect(
            errors,
            isEmpty,
            reason: errors.map((e) => e.exceptionAsString()).join('\n'),
          );
        },
      );

      testWidgets(
        'aucun débordement à 130% avec un profil dense, en arabe (RTL)',
        (tester) async {
          await tester.binding.setSurfaceSize(const Size(360, 800));
          addTearDown(() => tester.binding.setSurfaceSize(null));

          final errors = await captureFlutterErrors(() async {
            await tester.pumpWidget(
              _wrap(
                locale: const Locale('ar'),
                textScaler: const TextScaler.linear(1.3),
              ),
            );
            await tester.pumpAndSettle();
          });

          expect(
            errors,
            isEmpty,
            reason: errors.map((e) => e.exceptionAsString()).join('\n'),
          );
        },
      );
    },
  );
}
