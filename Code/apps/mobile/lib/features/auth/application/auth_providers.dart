import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/core/api/api_client_provider.dart';
import 'package:sanaya/core/api/auth_token_store.dart';
import 'package:sanaya/core/api/exceptions.dart';
import 'package:sanaya/features/auth/data/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(ref.watch(authApiProvider)),
);

/// Action de déconnexion : révoque la session serveur et nettoie l'état.
final logoutProvider = Provider<Future<void> Function({String? refreshToken})>(
  (ref) {
    final repository = ref.watch(authRepositoryProvider);
    return ({String? refreshToken}) async {
      await repository.logout(refreshToken: refreshToken);
    };
  },
);

enum AuthRole { client, provider }

enum AuthStep { role, phone, otp, authenticated }

class AuthState {
  const AuthState({
    this.step = AuthStep.role,
    this.role,
    this.phone,
    this.isLoading = false,
    this.errorCode,
  });

  final AuthStep step;
  final AuthRole? role;
  final String? phone;
  final bool isLoading;
  final String? errorCode;

  AuthState copyWith({
    AuthStep? step,
    AuthRole? role,
    String? phone,
    bool? isLoading,
    String? errorCode,
    bool clearError = false,
  }) => AuthState(
    step: step ?? this.step,
    role: role ?? this.role,
    phone: phone ?? this.phone,
    isLoading: isLoading ?? this.isLoading,
    errorCode: clearError ? null : (errorCode ?? this.errorCode),
  );
}

/// Parcours FM-05 : rôle choisi → téléphone → OTP → session persistée.
/// Le rôle choisi est une intention de navigation : les droits effectifs
/// restent ceux renvoyés par l'API après validation du code.
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._repository, this._tokenStore) : super(const AuthState());

  final AuthRepository _repository;
  final AuthTokenStore _tokenStore;

  void selectRole(AuthRole role) => state = state.copyWith(
    role: role,
    step: AuthStep.phone,
    clearError: true,
  );

  Future<void> requestOtp(String phone) async {
    final normalized = _normalizeTunisianPhone(phone);
    if (normalized == null) {
      state = state.copyWith(errorCode: 'PHONE_INVALID');
      return;
    }
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repository.requestOtp(phone: normalized);
      state = state.copyWith(
        phone: normalized,
        step: AuthStep.otp,
        isLoading: false,
      );
    } on SanayaApiException catch (error) {
      state = state.copyWith(isLoading: false, errorCode: error.code);
    } on Object {
      state = state.copyWith(isLoading: false, errorCode: 'UNKNOWN');
    }
  }

  Future<void> verifyOtp(String code) async {
    final phone = state.phone;
    if (phone == null || !RegExp(r'^\d{6}$').hasMatch(code)) {
      state = state.copyWith(errorCode: 'OTP_INVALID');
      return;
    }
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final session = await _repository.verifyOtp(phone: phone, code: code);
      await _tokenStore.saveSession(
        accessToken: session.accessToken,
        refreshToken: session.refreshToken,
      );
      state = state.copyWith(step: AuthStep.authenticated, isLoading: false);
    } on SanayaApiException catch (error) {
      state = state.copyWith(isLoading: false, errorCode: error.code);
    } on Object {
      state = state.copyWith(isLoading: false, errorCode: 'UNKNOWN');
    }
  }

  void backToPhone() => state = state.copyWith(
    step: AuthStep.phone,
    clearError: true,
  );
}

String? _normalizeTunisianPhone(String raw) {
  final digits = raw.replaceAll(RegExp('[^0-9]'), '');
  final local = digits.startsWith('216') ? digits.substring(3) : digits;
  return RegExp(r'^[2-9]\d{7}$').hasMatch(local) ? '+216$local' : null;
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(
    ref.watch(authRepositoryProvider),
    ref.watch(authTokenStoreProvider),
  ),
);
