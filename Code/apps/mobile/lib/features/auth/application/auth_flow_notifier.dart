import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/core/api/api_client_provider.dart';
import 'package:sanaya/core/api/exceptions.dart';
import 'package:sanaya/features/auth/application/auth_flow_state.dart';
import 'package:sanaya/features/auth/application/auth_providers.dart';
import 'package:sanaya/features/auth/application/auth_state_provider.dart';

/// Gère l'état complet du parcours d'authentification OTP (FM-05) :
/// sélection de rôle → saisie du téléphone → saisie du code → session.
///
/// Architecture :
/// - `build()` → état initial synchrone (pas d'appel réseau au démarrage)
/// - `selectRole()` → navigation pure, pas d'appel réseau
/// - `submitPhone()` → `POST /otp/request`, avance à l'étape OTP au succès
/// - `resendOtp()` → identique à `submitPhone`, sans changer d'étape
/// - `submitOtp()` → `POST /otp/verify`, ouvre la session au succès
///   (`AuthTokenStore.saveSession`) et peuple `verifiedUser` — c'est à
///   l'appelant (présentation, FM-05c/d) de naviguer, le notifier n'importe
///   pas le routeur (P3).
class AuthFlowNotifier extends AutoDisposeNotifier<AuthFlowState> {
  @override
  AuthFlowState build() => AuthFlowState.initial;

  /// Choix de rôle — jamais envoyé à l'API, cf. `AuthFlowState`. Avance
  /// directement à l'étape téléphone.
  void selectRole(UserRoleChoice role) {
    state = state.copyWith(role: role, step: AuthStep.phone, clearError: true);
  }

  /// Retour à l'étape téléphone (ex. bouton "Modifier le numéro" sur
  /// l'écran OTP). Pas d'appel réseau.
  void backToPhone() {
    state = state.copyWith(step: AuthStep.phone, clearError: true);
  }

  /// Retour à la sélection de rôle depuis l'étape téléphone. Pas d'appel
  /// réseau.
  void backToRole() {
    state = state.copyWith(step: AuthStep.role, clearError: true);
  }

  /// Demande un premier code OTP pour [phone]. Avance à l'étape OTP et
  /// arme le compte à rebours de renvoi au succès.
  Future<bool> submitPhone(String phone) async {
    state = state.copyWith(
      phone: phone,
      isSubmitting: true,
      clearError: true,
    );
    try {
      await ref.read(authRepositoryProvider).requestOtp(phone);
      state = state.copyWith(
        step: AuthStep.otp,
        isSubmitting: false,
        otpResendAvailableAt: DateTime.now().add(otpResendCooldown),
      );
      return true;
    } on SanayaApiException catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorCode: e.code,
        errorDetails: e.details,
      );
      return false;
    }
  }

  /// Renvoie un code OTP pour le numéro déjà saisi. Réarme le compte à
  /// rebours au succès, sans changer d'étape.
  Future<bool> resendOtp() async {
    final phone = state.phone;
    if (phone == null || !state.canResendOtp) return false;
    return submitPhone(phone);
  }

  /// Vérifie le [code] saisi. Au succès, ouvre la session
  /// (`AuthTokenStore.saveSession`) et peuple `verifiedUser` — la réponse
  /// d'`otp/verify` porte déjà les tokens, pas d'aller-retour supplémentaire.
  Future<bool> submitOtp(String code) async {
    final phone = state.phone;
    if (phone == null) return false;

    state = state.copyWith(isSubmitting: true, clearError: true);
    try {
      final result = await ref
          .read(authRepositoryProvider)
          .verifyOtp(phone: phone, code: code);
      await ref
          .read(authTokenStoreProvider)
          .saveSession(
            accessToken: result.accessToken,
            refreshToken: result.refreshToken,
          );
      // La réponse de vérification porte déjà le rôle — pas besoin d'un
      // second appel à `/auth/me` pour armer `authStateProvider` (consommé
      // par la garde `redirect:` de `router`, FM-05d). On attend d'abord
      // que le bootstrap de session (`AuthStateNotifier.build()`, lancé au
      // démarrage de l'app) soit résolu — sinon sur un réseau lent (P5) sa
      // résolution tardive écraserait l'état "authentifié" qu'on pose ici.
      await ref.read(authStateProvider.future);
      ref.read(authStateProvider.notifier).setAuthenticated(result.user.roles);
      state = state.copyWith(isSubmitting: false, verifiedUser: result.user);
      return true;
    } on SanayaApiException catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorCode: e.code,
        errorDetails: e.details,
      );
      return false;
    }
  }
}

/// Provider pour [AuthFlowNotifier].
final AutoDisposeNotifierProvider<AuthFlowNotifier, AuthFlowState>
authFlowProvider =
    NotifierProvider.autoDispose<AuthFlowNotifier, AuthFlowState>(
      AuthFlowNotifier.new,
    );
