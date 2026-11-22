import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:sanaya/core/i18n/translations.g.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/features/onboarding/data/onboarding_repository.dart';

/// Hub d'actions rapides du tableau de bord pro :
/// - Partager mon profil (copie du lien avec SnackBar)
/// - Voir ma vitrine publique (/providers/:slug)
/// - Activer un Boost (/pro/boosts)
/// - Gérer mon profil (/pro/profile)
class DashboardQuickActions extends StatelessWidget {
  const DashboardQuickActions({
    required this.t,
    this.profile,
    super.key,
  });

  final Translations t;
  final ProviderMe? profile;

  void _onShare(BuildContext context) {
    final slug = profile?.slug ?? 'sami-mansour-electricite';
    final url = 'https://sanaya.tn/p/$slug';
    unawaited(Clipboard.setData(ClipboardData(text: url)));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(t.dashboard.profileLinkCopied),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t.dashboard.quickActionsTitle,
          style: AppText.bodyStrong(locale).copyWith(
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _QuickActionButton(
                icon: Icons.share_rounded,
                label: t.dashboard.actionShare,
                color: colors.accent,
                onTap: () => _onShare(context),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _QuickActionButton(
                icon: Icons.storefront_rounded,
                label: t.dashboard.actionPublicProfile,
                color: colors.verified,
                onTap: () {
                  final slug = profile?.slug ?? 'sami-mansour-electricite';
                  unawaited(context.push('/providers/$slug'));
                },
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _QuickActionButton(
                icon: Icons.bolt_rounded,
                label: t.dashboard.actionBoost,
                color: colors.accent,
                onTap: () => context.go('/pro/boosts'),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _QuickActionButton(
                icon: Icons.manage_accounts_rounded,
                label: t.dashboard.actionEditProfile,
                color: colors.textSecondary,
                onTap: () => context.go('/pro/profile'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);

    return Material(
      color: colors.surface,
      borderRadius: const BorderRadius.all(AppRadius.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(AppRadius.md),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: colors.border),
            borderRadius: const BorderRadius.all(AppRadius.md),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 20, color: color),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                style: AppText.caption(locale).copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
