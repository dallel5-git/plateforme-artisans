import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/features/verification/data/kyc_image_compressor.dart';
import 'package:sanaya/features/verification/data/kyc_repository.dart';
import 'package:sanaya/features/verification/domain/kyc_submission_state.dart';

typedef CompressKycFunction = Future<Uint8List> Function(File file);

class KycSubmissionNotifier extends StateNotifier<KycSubmissionState> {
  KycSubmissionNotifier(this._repository, {CompressKycFunction? compressImage})
    : _compressImage = compressImage ?? compressKycImage,
      super(const KycSubmissionState());

  final KycRepository _repository;
  final CompressKycFunction _compressImage;

  void setFullName(String name) {
    state = state.copyWith(fullNameOnId: name, clearSubmitError: true);
  }

  void setCinNumber(String cin) {
    state = state.copyWith(cinNumber: cin, clearSubmitError: true);
  }

  void setConsent({required bool consent}) {
    state = state.copyWith(consentGiven: consent, clearSubmitError: true);
  }

  void removeDocument({required bool isFront}) {
    if (isFront) {
      state = state.copyWith(
        front: const KycDocumentState(),
        clearSubmitError: true,
      );
    } else {
      state = state.copyWith(
        back: const KycDocumentState(),
        clearSubmitError: true,
      );
    }
  }

  /// Traite l'image sélectionnée : compression locale puis upload direct vers
  /// R2 privé.
  Future<void> processAndUploadFile({
    required bool isFront,
    required File file,
  }) async {
    final docType = isFront
        ? V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum.CIN_FRONT
        : V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum.CIN_BACK;

    // Début d'upload avec réinitialisation de l'état
    final pendingDoc = KycDocumentState(
      file: file,
      isUploading: true,
      uploadProgress: 0.1,
    );
    state = isFront
        ? state.copyWith(front: pendingDoc, clearSubmitError: true)
        : state.copyWith(back: pendingDoc, clearSubmitError: true);

    try {
      // 1. Compression locale
      final compressedBytes = await _compressImage(file);

      // Mise à jour progression
      _updateDocProgress(isFront, 0.3);

      // 2. Pré-signature vers R2 privé
      final presign = await _repository.presignUpload(
        documentType: docType,
        mimeType: V1ProvidersMeVerificationPresignPostRequestMimeTypeEnum
            .imageSlashJpeg,
        sizeBytes: compressedBytes.length,
      );

      _updateDocProgress(isFront, 0.5);

      // 3. Upload binaire direct vers R2
      await _repository.uploadToPresignedUrl(
        uploadUrl: presign.uploadUrl,
        bytes: compressedBytes,
        mimeType: 'image/jpeg',
        onSendProgress: (sent, total) {
          if (total > 0) {
            final progress = 0.5 + (sent / total) * 0.5;
            _updateDocProgress(isFront, progress);
          }
        },
      );

      // Succès upload
      final uploadedDoc = KycDocumentState(
        file: file,
        mediaId: presign.mediaId,
        uploadProgress: 1,
      );
      state = isFront
          ? state.copyWith(front: uploadedDoc)
          : state.copyWith(back: uploadedDoc);
    } on Object catch (err) {
      final errorDoc = KycDocumentState(
        file: file,
        errorMessage: err.toString(),
      );
      state = isFront
          ? state.copyWith(front: errorDoc)
          : state.copyWith(back: errorDoc);
    }
  }

  void _updateDocProgress(bool isFront, double progress) {
    if (isFront) {
      state = state.copyWith(
        front: state.front.copyWith(
          isUploading: true,
          uploadProgress: progress,
        ),
      );
    } else {
      state = state.copyWith(
        back: state.back.copyWith(
          isUploading: true,
          uploadProgress: progress,
        ),
      );
    }
  }

  /// Soumet l'ensemble du dossier de vérification
  Future<bool> submit() async {
    if (!state.canSubmit) return false;

    state = state.copyWith(isSubmitting: true, clearSubmitError: true);

    try {
      await _repository.submitVerification(
        cinNumber: state.cinNumber.trim(),
        fullNameOnId: state.fullNameOnId.trim(),
        cinFrontMediaId: state.front.mediaId!,
        cinBackMediaId: state.back.mediaId!,
      );

      state = state.copyWith(isSubmitting: false, isSuccess: true);
      return true;
    } on Object catch (err) {
      state = state.copyWith(
        isSubmitting: false,
        submitError: err.toString(),
      );
      return false;
    }
  }

  void reset() {
    state = const KycSubmissionState();
  }
}
