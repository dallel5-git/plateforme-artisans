import 'dart:io';

/// Représente l'état d'une face de document d'identité (CIN recto ou verso).
class KycDocumentState {
  const KycDocumentState({
    this.file,
    this.mediaId,
    this.isUploading = false,
    this.uploadProgress = 0.0,
    this.errorMessage,
  });

  final File? file;
  final String? mediaId;
  final bool isUploading;
  final double uploadProgress;
  final String? errorMessage;

  bool get isUploaded => mediaId != null;

  KycDocumentState copyWith({
    File? file,
    String? mediaId,
    bool? isUploading,
    double? uploadProgress,
    String? errorMessage,
    bool clearError = false,
    bool clearFile = false,
  }) {
    return KycDocumentState(
      file: clearFile ? null : (file ?? this.file),
      mediaId: clearFile ? null : (mediaId ?? this.mediaId),
      isUploading: isUploading ?? this.isUploading,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// État global du formulaire de soumission KYC (MOB-030).
class KycSubmissionState {
  const KycSubmissionState({
    this.fullNameOnId = '',
    this.cinNumber = '',
    this.front = const KycDocumentState(),
    this.back = const KycDocumentState(),
    this.consentGiven = false,
    this.isSubmitting = false,
    this.submitError,
    this.isSuccess = false,
  });

  final String fullNameOnId;
  final String cinNumber;
  final KycDocumentState front;
  final KycDocumentState back;
  final bool consentGiven;
  final bool isSubmitting;
  final String? submitError;
  final bool isSuccess;

  /// Numéro CIN tunisien valide : exactement 8 chiffres décimaux.
  bool get isValidCin => RegExp(r'^\d{8}$').hasMatch(cinNumber.trim());

  /// Nom complet valide : au moins 3 caractères.
  bool get isValidFullName => fullNameOnId.trim().length >= 3;

  /// Conditions complètes pour autoriser la soumission :
  /// 1. Nom légal renseigné (≥ 3 car.)
  /// 2. CIN valide (8 chiffres)
  /// 3. Recto et Verso pré-téléversés vers le coffre-fort R2
  /// 4. Consentement explicite INPDP coché
  /// 5. Aucun upload ou soumission en cours
  bool get canSubmit =>
      isValidFullName &&
      isValidCin &&
      front.isUploaded &&
      back.isUploaded &&
      consentGiven &&
      !isSubmitting &&
      !front.isUploading &&
      !back.isUploading;

  KycSubmissionState copyWith({
    String? fullNameOnId,
    String? cinNumber,
    KycDocumentState? front,
    KycDocumentState? back,
    bool? consentGiven,
    bool? isSubmitting,
    String? submitError,
    bool? isSuccess,
    bool clearSubmitError = false,
  }) {
    return KycSubmissionState(
      fullNameOnId: fullNameOnId ?? this.fullNameOnId,
      cinNumber: cinNumber ?? this.cinNumber,
      front: front ?? this.front,
      back: back ?? this.back,
      consentGiven: consentGiven ?? this.consentGiven,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitError: clearSubmitError ? null : (submitError ?? this.submitError),
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
