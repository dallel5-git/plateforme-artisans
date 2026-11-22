import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/features/onboarding/domain/portfolio_upload_task.dart';

/// Une vignette de la grille de l'étape photos (FM-35) : image une fois
/// traitée ([PortfolioUploadPhase.done]), indicateur de progression pendant
/// le pipeline, ou état d'erreur avec bouton Réessayer — jamais un échec
/// global de l'étape (US-P-04).
class PortfolioPhotoTile extends StatelessWidget {
  const PortfolioPhotoTile({
    required this.task,
    required this.onRetry,
    required this.onRemove,
    required this.retryLabel,
    required this.removeLabel,
    required this.failedLabel,
    super.key,
  });

  final PortfolioUploadTask task;
  final VoidCallback onRetry;
  final VoidCallback onRemove;
  final String retryLabel;
  final String removeLabel;
  final String failedLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ClipRRect(
      borderRadius: const BorderRadius.all(AppRadius.sm),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ColoredBox(
            color: colors.surfaceSunken,
            child: switch (task.phase) {
              PortfolioUploadPhase.done when task.thumbUrl != null =>
                CachedNetworkImage(
                  imageUrl: task.thumbUrl!,
                  fit: BoxFit.cover,
                ),
              PortfolioUploadPhase.done =>
                Icon(Icons.image_outlined, color: colors.textSecondary),
              PortfolioUploadPhase.error => _ErrorContent(
                label: failedLabel,
                colors: colors,
              ),
              _ => _ProgressContent(
                value: task.phase == PortfolioUploadPhase.uploading
                    ? task.uploadProgress
                    : null,
                colors: colors,
              ),
            },
          ),
          if (task.isError)
            Positioned(
              right: 4,
              bottom: 4,
              child: _RoundIconButton(
                icon: Icons.refresh,
                tooltip: retryLabel,
                onPressed: onRetry,
              ),
            ),
          if (task.isDone)
            Positioned(
              right: 4,
              top: 4,
              child: _RoundIconButton(
                icon: Icons.close,
                tooltip: removeLabel,
                onPressed: onRemove,
              ),
            ),
        ],
      ),
    );
  }
}

class _ProgressContent extends StatelessWidget {
  const _ProgressContent({required this.value, required this.colors});

  final double? value;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 28,
        height: 28,
        child: CircularProgressIndicator(value: value, color: colors.accent),
      ),
    );
  }
}

class _ErrorContent extends StatelessWidget {
  const _ErrorContent({required this.label, required this.colors});

  final String label;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        Icons.error_outline,
        color: colors.destructive,
        semanticLabel: label,
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: colors.surface,
      shape: const CircleBorder(),
      child: IconButton(
        icon: Icon(icon, size: 16, color: colors.textPrimary),
        tooltip: tooltip,
        onPressed: onPressed,
        constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
        padding: EdgeInsets.zero,
      ),
    );
  }
}
