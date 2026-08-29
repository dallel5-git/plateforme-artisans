import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/features/auth/application/auth_flow_state.dart';

void main() {
  group('AuthFlowState.attemptsRemaining', () {
    test('lit details.attemptsRemaining quand présent (BE-10e)', () {
      const state = AuthFlowState(
        step: AuthStep.otp,
        errorDetails: {'attemptsRemaining': 2},
      );

      expect(state.attemptsRemaining, 2);
    });

    test('null si aucune erreur en cours', () {
      const state = AuthFlowState(step: AuthStep.otp);

      expect(state.attemptsRemaining, isNull);
    });
  });

  group('AuthFlowState.canResendOtp / resendCountdownSeconds', () {
    test('renvoi immédiatement disponible si aucune demande faite', () {
      const state = AuthFlowState(step: AuthStep.phone);

      expect(state.canResendOtp, isTrue);
      expect(state.resendCountdownSeconds, 0);
    });

    test('renvoi bloqué tant que le cooldown n’est pas écoulé', () {
      final state = AuthFlowState(
        step: AuthStep.otp,
        otpResendAvailableAt: DateTime.now().add(const Duration(seconds: 45)),
      );

      expect(state.canResendOtp, isFalse);
      expect(state.resendCountdownSeconds, greaterThan(40));
      expect(state.resendCountdownSeconds, lessThanOrEqualTo(45));
    });

    test('renvoi de nouveau disponible une fois le cooldown écoulé', () {
      final state = AuthFlowState(
        step: AuthStep.otp,
        otpResendAvailableAt: DateTime.now().subtract(
          const Duration(seconds: 1),
        ),
      );

      expect(state.canResendOtp, isTrue);
      expect(state.resendCountdownSeconds, 0);
    });
  });

  group('AuthFlowState.copyWith', () {
    test('clearError efface errorCode et errorDetails ensemble', () {
      const withError = AuthFlowState(
        step: AuthStep.otp,
        errorCode: 'OTP_INVALID',
        errorDetails: {'attemptsRemaining': 1},
      );

      final cleared = withError.copyWith(clearError: true);

      expect(cleared.errorCode, isNull);
      expect(cleared.errorDetails, isNull);
    });

    test(
      'clearOtpResendAvailableAt remet le compte à rebours à zéro',
      () {
        final withCooldown = AuthFlowState(
          step: AuthStep.otp,
          otpResendAvailableAt: DateTime.now().add(
            const Duration(seconds: 30),
          ),
        );

        final cleared = withCooldown.copyWith(
          clearOtpResendAvailableAt: true,
        );

        expect(cleared.otpResendAvailableAt, isNull);
        expect(cleared.canResendOtp, isTrue);
      },
    );
  });
}
