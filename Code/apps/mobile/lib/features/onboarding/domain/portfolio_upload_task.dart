/// Étapes du pipeline d'ajout d'une photo au portfolio (FM-35), dans l'ordre :
/// sélection → compression → upload direct (presign) → traitement serveur
/// (variantes WebP) → rattachement au profil.
enum PortfolioUploadPhase {
  compressing,
  uploading,
  processing,
  attaching,
  done,
  error,
}

/// État d'une photo en cours d'ajout au portfolio, suivi indépendamment des
/// autres (US-P-04) : l'échec d'une image n'interrompt jamais les autres,
/// conformément au critère d'acceptation de l'issue #232.
///
/// Immuable — copié via [copyWith] à chaque changement de phase, jamais muté
/// (règle Dart CLAUDE.md §4.2, pas de `setState` pour de l'état serveur).
class PortfolioUploadTask {
  const PortfolioUploadTask({
    required this.localId,
    required this.phase,
    this.uploadProgress = 0,
    this.mediaId,
    this.portfolioItemId,
    this.thumbUrl,
    this.errorCode,
  });

  /// Identifiant local (généré côté client, ex. chemin du fichier source ou
  /// horodatage) — sert de clé stable dans la liste avant qu'un [mediaId]
  /// serveur n'existe.
  final String localId;

  final PortfolioUploadPhase phase;

  /// Progression 0.0–1.0 de la mise en ligne vers l'URL pré-signée
  /// (`onSendProgress` de Dio). Sans objet hors
  /// [PortfolioUploadPhase.uploading].
  final double uploadProgress;

  /// Renseigné dès la réponse de `POST /v1/media/presign`.
  final String? mediaId;

  /// Renseigné une fois l'élément rattaché (`POST /providers/me/portfolio`).
  final String? portfolioItemId;

  /// Vignette à afficher une fois le traitement serveur terminé.
  final String? thumbUrl;

  /// Code d'erreur typé (`SanayaApiException.code`, ou code local tel que
  /// `IMAGE_COMPRESSION_FAILED`) quand [phase] vaut
  /// [PortfolioUploadPhase.error]. `null` sinon.
  final String? errorCode;

  bool get isError => phase == PortfolioUploadPhase.error;
  bool get isDone => phase == PortfolioUploadPhase.done;
  bool get isInProgress => !isError && !isDone;

  PortfolioUploadTask copyWith({
    PortfolioUploadPhase? phase,
    double? uploadProgress,
    String? mediaId,
    String? portfolioItemId,
    String? thumbUrl,
    String? errorCode,
    bool clearError = false,
  }) {
    return PortfolioUploadTask(
      localId: localId,
      phase: phase ?? this.phase,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      mediaId: mediaId ?? this.mediaId,
      portfolioItemId: portfolioItemId ?? this.portfolioItemId,
      thumbUrl: thumbUrl ?? this.thumbUrl,
      errorCode: clearError ? null : (errorCode ?? this.errorCode),
    );
  }
}
