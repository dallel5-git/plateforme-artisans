import 'package:flutter/material.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/features/verification/domain/kyc_submission_state.dart';

/// Carte visuelle de capture au ratio carte d'identité (format CIN 85.6 × 53.98 mm).
class CinCaptureCard extends StatelessWidget {
  const CinCaptureCard({
    required this.title,
    required this.subtitle,
    required this.state,
    required this.onPickImage,
    required this.onRemove,
    this.onRetry,
    super.key,
  });

  final String title;
  final String subtitle;
  final KycDocumentState state;
  final VoidCallback onPickImage;
  final VoidCallback onRemove;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);
    final hasFile = state.file != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: AppText.subtitle(locale).copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
            ),
            if (state.isUploaded)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    size: 18,
                    color: colors.verified,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'OK',
                    style: AppText.caption(locale).copyWith(
                      color: colors.verified,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          subtitle,
          style: AppText.caption(locale).copyWith(
            color: colors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        AspectRatio(
          aspectRatio: 1.58,
          child: Container(
            decoration: BoxDecoration(
              color: colors.surfaceRaised,
              borderRadius: const BorderRadius.all(AppRadius.md),
              border: Border.all(
                color: state.errorMessage != null
                    ? colors.destructive
                    : state.isUploaded
                    ? colors.verified
                    : colors.border,
                width: state.isUploaded || state.errorMessage != null
                    ? 1.5
                    : 1.0,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: hasFile ? null : onPickImage,
              borderRadius: const BorderRadius.all(AppRadius.md),
              child: hasFile
                  ? _buildImagePreview(context)
                  : _buildPlaceholder(context),
            ),
          ),
        ),
        if (state.errorMessage != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Icon(Icons.error_outline, size: 16, color: colors.destructive),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  state.errorMessage!,
                  style: AppText.caption(locale).copyWith(
                    color: colors.destructive,
                  ),
                ),
              ),
              if (onRetry != null)
                TextButton(
                  onPressed: onRetry,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xxs,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                  child: Text(
                    'Réessayer',
                    style: AppText.caption(locale).copyWith(
                      color: colors.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ],
        if (hasFile && !state.isUploading) ...[
          const SizedBox(height: AppSpacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: onPickImage,
                icon: const Icon(Icons.refresh_rounded, size: 16),
                label: const Text('Remplacer'),
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  foregroundColor: colors.textSecondary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              TextButton.icon(
                onPressed: onRemove,
                icon: const Icon(Icons.delete_outline_rounded, size: 16),
                label: const Text('Supprimer'),
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  foregroundColor: colors.destructive,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: colors.accentSubtle,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.camera_alt_rounded,
            color: colors.accent,
            size: 26,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Prendre ou importer une photo',
          style: AppText.subtitle(locale).copyWith(
            fontWeight: FontWeight.w600,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          'JPG ou PNG (max 10 Mo)',
          style: AppText.caption(locale).copyWith(
            color: colors.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildImagePreview(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.file(
          state.file!,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => Center(
            child: Icon(
              Icons.broken_image_rounded,
              size: 40,
              color: colors.textMuted,
            ),
          ),
        ),
        if (state.isUploading)
          ColoredBox(
            color: colors.scrim,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    value: state.uploadProgress > 0
                        ? state.uploadProgress
                        : null,
                    color: colors.onAccent,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    '${(state.uploadProgress * 100).toInt()}%',
                    style: AppText.body(locale).copyWith(
                      color: colors.onAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
