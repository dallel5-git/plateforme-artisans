import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/app_button.dart';
import 'package:sanaya/features/onboarding/application/portfolio_repository_provider.dart';
import 'package:sanaya/features/onboarding/data/portfolio_image_compressor.dart';
import 'package:sanaya/features/onboarding/domain/onboarding_plan_limits.dart';
import 'package:sanaya/features/onboarding/domain/portfolio_upload_task.dart';
import 'package:sanaya/features/onboarding/presentation/widgets/portfolio_photo_tile.dart';

/// Étape photos/portfolio de l'onboarding (issue #232, FM-35) : sélection →
/// compression → upload direct (presign) → traitement serveur → rattachement
/// au profil, avec un état de progression **par photo** — l'échec d'une
/// image n'interrompt jamais les autres (critère d'acceptation).
///
/// Contrairement aux autres étapes, il n'existe aucune route pour lister le
/// portfolio de son propre profil pendant l'onboarding (seule la fiche
/// publique, réservée aux profils `PUBLISHED`, l'expose) : les photos ne
/// sont donc suivies que pour la durée de cette session d'onboarding, pas
/// rechargées depuis le serveur. La reprise après fermeture de l'app reste
/// le périmètre de `FM-36` (bloqué par `BE-44`), comme pour les autres
/// étapes.
class OnboardingPhotosStep extends ConsumerStatefulWidget {
  const OnboardingPhotosStep({
    required this.isSaving,
    required this.errorMessage,
    required this.onSubmit,
    this.initialItems = const [],
    this.pickImage,
    this.compressImage,
    super.key,
  });

  final bool isSaving;
  final String? errorMessage;
  final VoidCallback onSubmit;
  final List<PortfolioUploadTask> initialItems;

  /// Injectable pour les tests (canal de plateforme sinon impossible à
  /// simuler en `flutter test`). `null` → `ImagePicker().pickImage(...)`.
  final Future<XFile?> Function()? pickImage;

  /// Injectable pour les tests, même raison. `null` → [compressPortfolioImage].
  final Future<Uint8List> Function(File file)? compressImage;

  @override
  ConsumerState<OnboardingPhotosStep> createState() =>
      _OnboardingPhotosStepState();
}

class _OnboardingPhotosStepState extends ConsumerState<OnboardingPhotosStep> {
  final Map<String, File> _files = {};
  List<PortfolioUploadTask> _tasks = [];

  @override
  void initState() {
    super.initState();
    _tasks = List.of(widget.initialItems);
  }

  @override
  void didUpdateWidget(OnboardingPhotosStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_tasks.isEmpty && widget.initialItems.isNotEmpty) {
      _tasks = List.of(widget.initialItems);
    }
  }

  bool get _isAtCap =>
      _tasks.where((t) => !t.isError).length >= freePlanMaxPortfolioItems;

  bool get _canSubmit => !widget.isSaving && !_tasks.any((t) => t.isInProgress);

  Future<XFile?> _pickImage() =>
      widget.pickImage?.call() ??
      ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 100);

  Future<Uint8List> _compressImage(File file) =>
      widget.compressImage?.call(file) ?? compressPortfolioImage(file);

  Future<void> _addPhoto() async {
    if (_isAtCap) return;
    final picked = await _pickImage();
    if (picked == null) return;

    final localId = '${DateTime.now().microsecondsSinceEpoch}';
    final file = File(picked.path);
    _files[localId] = file;
    setState(() {
      _tasks = [
        ..._tasks,
        PortfolioUploadTask(
          localId: localId,
          phase: PortfolioUploadPhase.compressing,
        ),
      ];
    });
    await _runPipeline(localId, file);
  }

  Future<void> _retry(String localId) async {
    final file = _files[localId];
    if (file == null) return;
    _updateTask(
      localId,
      (t) => t.copyWith(
        phase: PortfolioUploadPhase.compressing,
        clearError: true,
      ),
    );
    await _runPipeline(localId, file);
  }

  Future<void> _remove(String localId) async {
    final task = _tasks.firstWhere((t) => t.localId == localId);
    setState(() => _tasks = _tasks.where((t) => t.localId != localId).toList());
    _files.remove(localId);
    final portfolioItemId = task.portfolioItemId;
    if (portfolioItemId == null) return;
    try {
      await ref
          .read(portfolioRepositoryProvider)
          .deletePortfolioItem(portfolioItemId);
    } on Object {
      // Suppression déjà reflétée localement — un échec serveur (réseau,
      // 404 déjà supprimé) n'entrave pas la poursuite de l'onboarding.
    }
  }

  Future<void> _runPipeline(String localId, File file) async {
    final repo = ref.read(portfolioRepositoryProvider);
    try {
      final bytes = await _compressImage(file);
      _updateTask(
        localId,
        (t) => t.copyWith(phase: PortfolioUploadPhase.uploading),
      );

      final presign = await repo.presignUpload(
        filename: file.uri.pathSegments.last,
        mimeType: 'image/jpeg',
        sizeBytes: bytes.length,
      );
      _updateTask(localId, (t) => t.copyWith(mediaId: presign.mediaId));

      await repo.uploadToPresignedUrl(
        uploadUrl: presign.uploadUrl,
        bytes: bytes,
        mimeType: 'image/jpeg',
        onSendProgress: (sent, total) {
          if (total <= 0) return;
          _updateTask(localId, (t) => t.copyWith(uploadProgress: sent / total));
        },
      );

      _updateTask(
        localId,
        (t) => t.copyWith(phase: PortfolioUploadPhase.processing),
      );
      final processed = await repo.processMedia(presign.mediaId);
      _updateTask(
        localId,
        (t) => t.copyWith(
          phase: PortfolioUploadPhase.attaching,
          thumbUrl: processed.thumbUrl,
        ),
      );

      final item = await repo.attachToPortfolio(mediaId: presign.mediaId);
      _updateTask(
        localId,
        (t) => t.copyWith(
          phase: PortfolioUploadPhase.done,
          portfolioItemId: item.id,
        ),
      );
    } on SanayaApiException catch (e) {
      _updateTask(
        localId,
        (t) => t.copyWith(phase: PortfolioUploadPhase.error, errorCode: e.code),
      );
    } on ImageCompressionException {
      _updateTask(
        localId,
        (t) => t.copyWith(
          phase: PortfolioUploadPhase.error,
          errorCode: 'IMAGE_COMPRESSION_FAILED',
        ),
      );
    } on Object {
      _updateTask(
        localId,
        (t) => t.copyWith(
          phase: PortfolioUploadPhase.error,
          errorCode: 'NETWORK_ERROR',
        ),
      );
    }
  }

  void _updateTask(
    String localId,
    PortfolioUploadTask Function(PortfolioUploadTask) update,
  ) {
    if (!mounted) return;
    setState(() {
      _tasks = [
        for (final t in _tasks)
          if (t.localId == localId) update(t) else t,
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = ref.watch(translationsProvider);
    final locale = Localizations.localeOf(context);
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(t.onboarding.photosTitle, style: AppText.h3(locale)),
          const SizedBox(height: AppSpacing.xs),
          Text(
            _isAtCap
                ? t.onboarding.photosCapReached
                : t.onboarding.photosCapHint,
            style: AppText.small(locale).copyWith(color: colors.textMuted),
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: AppSpacing.sm,
              crossAxisSpacing: AppSpacing.sm,
              children: [
                for (final task in _tasks)
                  PortfolioPhotoTile(
                    task: task,
                    onRetry: () => _retry(task.localId),
                    onRemove: () => _remove(task.localId),
                    retryLabel: t.onboarding.retry,
                    removeLabel: t.onboarding.photosDelete,
                    failedLabel: t.onboarding.photosUploadFailed,
                  ),
                if (!_isAtCap)
                  _AddPhotoTile(
                    onTap: _addPhoto,
                    label: t.onboarding.photosAdd,
                  ),
              ],
            ),
          ),
          if (widget.errorMessage != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              widget.errorMessage!,
              style: AppText.small(locale).copyWith(color: colors.destructive),
            ),
          ],
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            label: t.onboarding.next,
            onPressed: _canSubmit ? widget.onSubmit : null,
          ),
        ],
      ),
    );
  }
}

class _AddPhotoTile extends StatelessWidget {
  const _AddPhotoTile({required this.onTap, required this.label});

  final VoidCallback onTap;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ClipRRect(
      borderRadius: const BorderRadius.all(AppRadius.sm),
      child: Material(
        color: colors.surfaceSunken,
        child: InkWell(
          onTap: onTap,
          child: Semantics(
            button: true,
            label: label,
            child: Center(
              child: Icon(Icons.add_a_photo_outlined, color: colors.textMuted),
            ),
          ),
        ),
      ),
    );
  }
}
