import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/core/widgets/app_button.dart';
import 'package:sanaya/features/verification/application/kyc_providers.dart';
import 'package:sanaya/features/verification/data/kyc_repository.dart';
import 'package:sanaya/features/verification/domain/kyc_submission_state.dart';
import 'package:sanaya/features/verification/presentation/screens/kyc_submission_screen.dart';
import 'package:sanaya/features/verification/presentation/widgets/inpdp_consent_checkbox.dart';

class _MockKycRepository extends Mock implements KycRepository {}

Widget _wrap({
  required Widget child,
  KycRepository? repo,
  List<Override> overrides = const [],
}) {
  return ProviderScope(
    overrides: [
      if (repo != null) kycRepositoryProvider.overrideWithValue(repo),
      ...overrides,
    ],
    child: MaterialApp(
      theme: buildTheme(
        brightness: Brightness.light,
        locale: const Locale('fr'),
      ),
      locale: const Locale('fr'),
      home: child,
    ),
  );
}

void main() {
  late _MockKycRepository mockRepo;

  setUp(() {
    mockRepo = _MockKycRepository();
  });

  group('KycSubmissionScreen — Parcours complet', () {
    testWidgets("affiche l'ensemble des sections et composants du formulaire", (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          repo: mockRepo,
          child: const KycSubmissionScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // En-tête et titre
      expect(find.text("Vérification d'identité"), findsOneWidget);
      expect(find.text('Obtenez le badge Artisan Vérifié'), findsOneWidget);
      expect(find.text("Informations d'identité"), findsOneWidget);

      // Champs d'identité
      expect(find.text('Nom et prénom (sur la CIN)'), findsOneWidget);
      expect(find.text("Numéro de carte d'identité (CIN)"), findsOneWidget);

      // Cartes recto et verso
      expect(find.text('Face avant (Recto)'), findsOneWidget);
      expect(find.text('Face arrière (Verso)'), findsOneWidget);

      // Consentement INPDP
      expect(find.byType(InpdpConsentCheckbox), findsOneWidget);

      // Bouton désactivé au départ
      final submitFinder = find.widgetWithText(
        AppButton,
        'Envoyer pour vérification',
      );
      expect(submitFinder, findsOneWidget);
      final button = tester.widget<AppButton>(submitFinder);
      expect(button.onPressed, isNull);
    });

    testWidgets('valide les formats nom et CIN et signale les erreurs', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          repo: mockRepo,
          child: const KycSubmissionScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Saisie d'un nom trop court
      await tester.enterText(find.byType(TextField).first, 'Ab');
      await tester.pump();
      expect(
        find.text(
          'Veuillez saisir votre nom et prénom (au moins 3 caractères)',
        ),
        findsOneWidget,
      );

      // Saisie d'un CIN invalide (< 8 chiffres)
      await tester.enterText(find.byType(TextField).last, '12345');
      await tester.pump();
      expect(
        find.text('Le numéro de CIN doit comporter exactement 8 chiffres'),
        findsOneWidget,
      );

      // Correction des saisies
      await tester.enterText(find.byType(TextField).first, 'Mohamed Ben Ali');
      await tester.enterText(find.byType(TextField).last, '08123456');
      await tester.pump();

      expect(
        find.text(
          'Veuillez saisir votre nom et prénom (au moins 3 caractères)',
        ),
        findsNothing,
      );
      expect(
        find.text('Le numéro de CIN doit comporter exactement 8 chiffres'),
        findsNothing,
      );
    });

    testWidgets(
      'active le bouton de soumission quand toutes les conditions sont réunies',
      (
        tester,
      ) async {
        final container = ProviderContainer(
          overrides: [
            kycRepositoryProvider.overrideWithValue(mockRepo),
          ],
        );

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              theme: buildTheme(
                brightness: Brightness.light,
                locale: const Locale('fr'),
              ),
              locale: const Locale('fr'),
              home: const KycSubmissionScreen(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Simule les données complètes via le notifier
        final notifier = container.read(kycSubmissionNotifierProvider.notifier);
        notifier.setFullName('Kamel Trabelsi');
        notifier.setCinNumber('09876543');
        notifier.setConsent(true);

        // Injecte deux fichiers simulés
        container.read(kycSubmissionNotifierProvider.notifier).state = container
            .read(kycSubmissionNotifierProvider)
            .copyWith(
              front: KycDocumentState(
                file: File('/tmp/cin_front.jpg'),
                mediaId: 'media-front-1',
              ),
              back: KycDocumentState(
                file: File('/tmp/cin_back.jpg'),
                mediaId: 'media-back-2',
              ),
            );

        await tester.pumpAndSettle();

        // Bouton désormais actif
        final submitFinder = find.widgetWithText(
          AppButton,
          'Envoyer pour vérification',
        );
        expect(submitFinder, findsOneWidget);
        final button = tester.widget<AppButton>(submitFinder);
        expect(button.onPressed, isNotNull);
      },
    );

    testWidgets("affiche l'écran de succès après soumission réussie", (
      tester,
    ) async {
      final container = ProviderContainer(
        overrides: [
          kycRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );

      // État initial déjà en succès
      container.read(kycSubmissionNotifierProvider.notifier).state =
          const KycSubmissionState(isSuccess: true);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: buildTheme(
              brightness: Brightness.light,
              locale: const Locale('fr'),
            ),
            locale: const Locale('fr'),
            home: const KycSubmissionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Demande envoyée avec succès !'), findsOneWidget);
      expect(
        find.textContaining("Notre équipe examine votre pièce d'identité"),
        findsOneWidget,
      );
      expect(find.text('Retour au tableau de bord'), findsOneWidget);
    });
  });
}
