import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/core/widgets/app_button.dart';
import 'package:sanaya/features/verification/presentation/widgets/verification_status_card.dart';

Widget _wrap(Widget child) {
  return ProviderScope(
    child: MaterialApp(
      theme: buildTheme(
        brightness: Brightness.light,
        locale: const Locale('fr'),
      ),
      locale: const Locale('fr'),
      home: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      ),
    ),
  );
}

void main() {
  group('VerificationStatusCard — Mode Bannière (Dashboard)', () {
    testWidgets("affiche l'incitation et le bouton CTA en état NOT_SUBMITTED", (
      tester,
    ) async {
      var actionCalled = false;
      await tester.pumpWidget(
        _wrap(
          VerificationStatusCard(
            status:
                V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum
                    .NOT_SUBMITTED,
            onAction: () => actionCalled = true,
          ),
        ),
      );

      expect(find.text('Faites vérifier votre profil'), findsOneWidget);
      expect(find.text('Faire vérifier mon compte'), findsOneWidget);

      await tester.tap(
        find.widgetWithText(AppButton, 'Faire vérifier mon compte'),
      );
      expect(actionCalled, isTrue);
    });

    testWidgets("affiche le statut d'attente en état PENDING", (tester) async {
      await tester.pumpWidget(
        _wrap(
          const VerificationStatusCard(
            status:
                V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum
                    .PENDING,
          ),
        ),
      );

      expect(find.text('Vérification en cours'), findsOneWidget);
      expect(find.textContaining('24h ouvrées'), findsOneWidget);
      expect(find.byType(AppButton), findsNothing);
    });

    testWidgets(
      "affiche l'alerte avec le motif et le bouton CTA en état REJECTED",
      (
        tester,
      ) async {
        var actionCalled = false;
        await tester.pumpWidget(
          _wrap(
            VerificationStatusCard(
              status:
                  V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum
                      .REJECTED,
              rejectionReason: 'Photo floue, CIN illisible.',
              onAction: () => actionCalled = true,
            ),
          ),
        );

        expect(find.text('Vérification non validée'), findsOneWidget);
        expect(
          find.textContaining('Photo floue, CIN illisible.'),
          findsOneWidget,
        );
        expect(find.text('Soumettre à nouveau'), findsOneWidget);

        await tester.tap(find.widgetWithText(AppButton, 'Soumettre à nouveau'));
        expect(actionCalled, isTrue);
      },
    );

    testWidgets('affiche la demande de complément en état MORE_INFO_REQUIRED', (
      tester,
    ) async {
      var actionCalled = false;
      await tester.pumpWidget(
        _wrap(
          VerificationStatusCard(
            status:
                V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum
                    .MORE_INFO_REQUIRED,
            rejectionReason: 'Verso manquant.',
            onAction: () => actionCalled = true,
          ),
        ),
      );

      expect(find.text('Complément requis'), findsOneWidget);
      expect(find.textContaining('Verso manquant.'), findsOneWidget);
      expect(find.text('Mettre à jour le dossier'), findsOneWidget);

      await tester.tap(
        find.widgetWithText(AppButton, 'Mettre à jour le dossier'),
      );
      expect(actionCalled, isTrue);
    });

    testWidgets('affiche la confirmation officielle en état APPROVED', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const VerificationStatusCard(
            status:
                V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum
                    .APPROVED,
          ),
        ),
      );

      expect(find.text('Profil Vérifié'), findsOneWidget);
      expect(
        find.textContaining('Votre identité a été certifiée'),
        findsOneWidget,
      );
      expect(find.byType(AppButton), findsNothing);
    });
  });

  group('VerificationStatusCard — Mode Compact (Tuile Profil)', () {
    testWidgets('affiche la tuile compacte avec le badge Non vérifié', (
      tester,
    ) async {
      var actionCalled = false;
      await tester.pumpWidget(
        _wrap(
          VerificationStatusCard(
            status:
                V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum
                    .NOT_SUBMITTED,
            isCompact: true,
            onAction: () => actionCalled = true,
          ),
        ),
      );

      expect(find.text("Vérification d'identité"), findsOneWidget);
      expect(find.text('Non vérifié'), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right_rounded), findsOneWidget);

      await tester.tap(find.text("Vérification d'identité"));
      expect(actionCalled, isTrue);
    });

    testWidgets(
      'affiche le badge Artisan Vérifié sans chevron en état APPROVED',
      (
        tester,
      ) async {
        await tester.pumpWidget(
          _wrap(
            const VerificationStatusCard(
              status:
                  V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum
                      .APPROVED,
              isCompact: true,
            ),
          ),
        );

        expect(find.text("Vérification d'identité"), findsOneWidget);
        expect(find.text('Artisan Vérifié'), findsOneWidget);
        expect(find.byIcon(Icons.verified_rounded), findsOneWidget);
        expect(find.byIcon(Icons.chevron_right_rounded), findsNothing);
      },
    );

    testWidgets('affiche le badge Vérification en cours en état PENDING', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const VerificationStatusCard(
            status:
                V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum
                    .PENDING,
            isCompact: true,
          ),
        ),
      );

      expect(find.text("Vérification d'identité"), findsOneWidget);
      expect(find.text('Vérification en cours'), findsOneWidget);
    });
  });
}
