import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/core/api/api_client_provider.dart';
import 'package:sanaya/features/verification/application/kyc_submission_notifier.dart';
import 'package:sanaya/features/verification/data/kyc_repository.dart';
import 'package:sanaya/features/verification/domain/kyc_submission_state.dart';

/// Provider pour [KycRepository].
final kycRepositoryProvider = Provider<KycRepository>((ref) {
  final api = ref.watch(defaultApiProvider);
  return KycRepository(api);
});

/// Statut de vérification actuel de l'artisan (`GET /v1/providers/me/verification`).
final kycStatusProvider = FutureProvider<KycStatusResponse>((ref) async {
  final repository = ref.watch(kycRepositoryProvider);
  return repository.getVerificationStatus();
});

/// Gestionnaire d'état de la soumission KYC.
final AutoDisposeStateNotifierProvider<
  KycSubmissionNotifier,
  KycSubmissionState
>
kycSubmissionNotifierProvider =
    StateNotifierProvider.autoDispose<
      KycSubmissionNotifier,
      KycSubmissionState
    >(
      (ref) {
        final repository = ref.watch(kycRepositoryProvider);
        return KycSubmissionNotifier(repository);
      },
    );
