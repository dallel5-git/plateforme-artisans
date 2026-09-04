import 'package:sanaya/core/api/generated/api.dart'
    show V1AuthOtpVerifyPost200ResponseUser;

// ---------------------------------------------------------------------------
// Étapes du parcours
// ---------------------------------------------------------------------------

/// Les 2 écrans du parcours d'authentification, dans l'ordre. L'étape de
/// sélection de rôle (`UserRoleChoice`) a été retirée par FM-33 : elle
/// n'apparaît dans aucune maquette et le rôle réel est de toute façon
/// déterminé côté serveur (garde `redirect:` sur `GET /auth/me`), jamais par
/// ce choix — voir issue FM-33.
enum AuthStep { phone, otp }

/// Délai avant de pouvoir renvoyer un code OTP (critère d'acceptation FM-05).
const otpResendCooldown = Duration(seconds: 60);

// ---------------------------------------------------------------------------
// État immuable du parcours
// ---------------------------------------------------------------------------

/// État complet du parcours OTP (rôle → téléphone → OTP).
///
/// Immuable : toute modification passe par [copyWith]. Pas de `setState`
/// pour de l'état serveur (règle Dart CLAUDE.md §4.2).
///
/// [otpResendAvailableAt] est une date absolue, pas un compteur décrémenté
/// par un `Timer` local à un widget : la valeur de vérité vit ici, dans
/// l'état Riverpod, pour survivre à une rotation d'écran sans dépendre du
/// cycle de vie d'un widget.
class AuthFlowState {
  const AuthFlowState({
    required this.step,
    this.phone,
    this.isSubmitting = false,
    this.otpResendAvailableAt,
    this.errorCode,
    this.errorDetails,
    this.verifiedUser,
  });

  final AuthStep step;

  /// Numéro tel que saisi par l'utilisateur. La normalisation E.164 est
  /// faite côté serveur (P4) — jamais recalculée ici.
  final String? phone;

  /// `true` pendant un appel réseau en cours (désactive les boutons).
  final bool isSubmitting;

  /// `null` = renvoi immédiatement disponible (pas encore de demande, ou
  /// cooldown déjà écoulé).
  final DateTime? otpResendAvailableAt;

  /// Code d'erreur typé (`packages/constants/error-codes`) de la dernière
  /// tentative échouée. `null` = pas d'erreur en cours.
  final String? errorCode;

  /// `details` bruts de la dernière erreur — porte `attemptsRemaining`
  /// pour `OTP_INVALID` (BE-10e).
  final Map<String, dynamic>? errorDetails;

  /// Peuplé après un `otp/verify` réussi. La présentation (FM-05c/d) réagit
  /// à ce champ pour naviguer — le notifier n'importe pas le routeur (P3).
  final V1AuthOtpVerifyPost200ResponseUser? verifiedUser;

  // ---------------------------------------------------------------------------
  // Dérivés
  // ---------------------------------------------------------------------------

  /// Nombre de tentatives OTP restantes avant blocage
  /// (`OTP_TOO_MANY_ATTEMPTS`), renvoyé par le serveur dans
  /// `details.attemptsRemaining` sur `OTP_INVALID`.
  int? get attemptsRemaining => errorDetails?['attemptsRemaining'] as int?;

  /// `true` si le bouton "Renvoyer le code" est actionnable maintenant.
  bool get canResendOtp =>
      otpResendAvailableAt == null ||
      !DateTime.now().isBefore(otpResendAvailableAt!);

  /// Secondes restantes avant de pouvoir renvoyer, arrondi à l'entier
  /// supérieur pour ne jamais afficher "0s" alors que ce n'est pas encore
  /// actionnable.
  int get resendCountdownSeconds {
    final availableAt = otpResendAvailableAt;
    if (availableAt == null) return 0;
    final remaining = availableAt.difference(DateTime.now());
    if (remaining.isNegative) return 0;
    return (remaining.inMilliseconds / 1000).ceil();
  }

  // ---------------------------------------------------------------------------
  // Copie immuable
  // ---------------------------------------------------------------------------

  AuthFlowState copyWith({
    AuthStep? step,
    String? phone,
    bool? isSubmitting,
    DateTime? otpResendAvailableAt,
    String? errorCode,
    Map<String, dynamic>? errorDetails,
    V1AuthOtpVerifyPost200ResponseUser? verifiedUser,
    bool clearError = false,
    bool clearOtpResendAvailableAt = false,
  }) {
    return AuthFlowState(
      step: step ?? this.step,
      phone: phone ?? this.phone,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      otpResendAvailableAt: clearOtpResendAvailableAt
          ? null
          : (otpResendAvailableAt ?? this.otpResendAvailableAt),
      errorCode: clearError ? null : (errorCode ?? this.errorCode),
      errorDetails: clearError ? null : (errorDetails ?? this.errorDetails),
      verifiedUser: verifiedUser ?? this.verifiedUser,
    );
  }

  // ---------------------------------------------------------------------------
  // État initial
  // ---------------------------------------------------------------------------

  static const initial = AuthFlowState(step: AuthStep.phone);
}
