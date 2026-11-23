import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sanaya/core/i18n/translations.g.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/app_button.dart';
import 'package:sanaya/core/widgets/app_card.dart';

/// Bannière Boost et Conseils d'efficacité pour l'artisan.
class DashboardProTipsCard extends StatelessWidget {
  const DashboardProTipsCard({
    required this.t,
    super.key,
  });

  final Translations t;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Bannière Boost Sahel
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colors.accent.withValues(alpha: 0.85),
                colors.accent,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.all(AppRadius.lg),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: colors.onAccent.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.bolt_rounded,
                      size: 20,
                      color: colors.onAccent,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      t.dashboard.boostBannerTitle,
                      style: AppText.bodyStrong(locale).copyWith(
                        color: colors.onAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                t.dashboard.boostBannerSubtitle,
                style: AppText.small(locale).copyWith(
                  color: colors.onAccent.withValues(alpha: 0.9),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppButton(
                label: t.dashboard.boostBannerCta,
                variant: AppButtonVariant.secondary,
                onPressed: () => context.go('/pro/boosts'),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        // Conseils Métier Pro
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline_rounded,
                    size: 20,
                    color: colors.amber,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      t.dashboard.proTipsTitle,
                      style: AppText.bodyStrong(locale).copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              _TipItem(
                icon: Icons.timer_outlined,
                title: t.dashboard.tipResponsivenessTitle,
                description: t.dashboard.tipResponsivenessDesc,
              ),
              const SizedBox(height: AppSpacing.md),
              _TipItem(
                icon: Icons.photo_camera_back_outlined,
                title: t.dashboard.tipPhotosTitle,
                description: t.dashboard.tipPhotosDesc,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TipItem extends StatelessWidget {
  const _TipItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.xs),
          decoration: BoxDecoration(
            color: colors.accent.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: colors.accent),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppText.small(locale).copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: AppText.caption(locale).copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
