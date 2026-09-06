import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sanaya/core/i18n/translations.g.dart';
import 'package:sanaya/core/widgets/app_button.dart';
import 'package:sanaya/features/auth/presentation/widgets/otp_step.dart';

import '../../../../core/widgets/widget_test_helpers.dart';

void main() {
  final t = AppLocale.fr.buildSync();

  Widget buildStep({
    ValueChanged<String>? onSubmit,
    VoidCallback? onResend,
    int resendCountdownSeconds = 0,
    bool canResend = true,
  }) {
    return ProviderScope(
      child: themedApp(
        Scaffold(
          body: OtpStep(
            translations: t,
            phone: '+21622123456',
            isSubmitting: false,
            errorMessage: null,
            attemptsRemaining: null,
            canResend: canResend,
            resendCountdownSeconds: resendCountdownSeconds,
            attemptCount: 0,
            onSubmit: onSubmit ?? (_) {},
            onResend: onResend ?? () {},
          ),
        ),
      ),
    );
  }

  group('FM-33c — OtpStep', () {
    testWidgets(
      'le bouton Confirmer est désactivé tant que le code est incomplet, '
      'activé à 6 chiffres',
      (tester) async {
        await tester.pumpWidget(buildStep());

        final confirmButton = find.widgetWithText(AppButton, t.auth.otpCta);
        expect(tester.widget<AppButton>(confirmButton).onPressed, isNull);

        final fields = find.byType(TextField);
        for (var i = 0; i < 6; i++) {
          await tester.enterText(fields.at(i), '${i + 1}');
          await tester.pump();
        }

        expect(
          tester.widget<AppButton>(confirmButton).onPressed,
          isNotNull,
        );
      },
    );

    testWidgets(
      'taper Confirmer soumet le code, indépendamment de la '
      'soumission automatique à la 6e touche',
      (tester) async {
        final calls = <String>[];
        await tester.pumpWidget(buildStep(onSubmit: calls.add));

        final fields = find.byType(TextField);
        for (var i = 0; i < 6; i++) {
          await tester.enterText(fields.at(i), '${i + 1}');
        }
        await tester.pump();

        // La 6e touche a déjà déclenché la soumission automatique.
        expect(calls, ['123456']);

        await tester.tap(find.widgetWithText(AppButton, t.auth.otpCta));

        expect(calls, ['123456', '123456']);
      },
    );

    testWidgets('le compte à rebours de renvoi s’affiche au format mm:ss', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildStep(canResend: false, resendCountdownSeconds: 47),
      );

      expect(
        find.text(t.auth.otpResendCountdown.replaceAll('{mmss}', '0:47')),
        findsOneWidget,
      );
      expect(find.textContaining('47s'), findsNothing);
    });
  });
}
