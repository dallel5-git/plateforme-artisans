import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/core/i18n/translations.g.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/app_button.dart';
import 'package:sanaya/core/widgets/app_card.dart';

/// Carte et tuile de suivi du statut KYC pour le Dashboard Pro
/// et le Profil Pro (MOB-031).
///
/// Prend en charge les 5 états de vérification :
/// - `NOT_SUBMITTED` : Incitation à certifier le compte avec CTA vers le tunnel
/// - `PENDING` : Indicateur d'examen en cours sous 24h ouvrées
/// - `MORE_INFO_REQUIRED` : Alerte de demande de compléments avec motif
/// - `REJECTED` : Avertissement de refus avec motif et CTA pour réitérer
/// - `APPROVED` : Badge officiel d'artisan certifié et valorisation
class VerificationStatusCard extends ConsumerWidget {
  const VerificationStatusCard({
    required this.status,
    this.rejectionReason,
    this.isCompact = false,
    this.onAction,
    this.translations,
    super.key,
  });

  final V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum status;
  final String? rejectionReason;
  final bool isCompact;
  final VoidCallback? onAction;
  final Translations? translations;

  void _handleNavigation(BuildContext context) {
    if (onAction != null) {
      onAction!();
    } else {
      unawaited(context.push('/pro/verification'));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = (translations ?? ref.watch(translationsProvider))!;
    final colors = context.colors;
    final locale = Localizations.localeOf(context);

    if (isCompact) {
      return _buildCompactTile(context, t, colors, locale);
    }
    return _buildExpandedBanner(context, t, colors, locale);
  }

  Widget _buildCompactTile(
    BuildContext context,
    Translations t,
    AppColors colors,
    Locale locale,
  ) {
    final (
      icon,
      iconColor,
      statusLabel,
      badgeBg,
      badgeTextColor,
    ) = switch (status) {
      V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum.APPROVED =>
        (
          Icons.verified_rounded,
          colors.verified,
          t.verification.statusApproved,
          colors.verifiedSubtle,
          colors.verified,
        ),
      V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum.PENDING => (
        Icons.hourglass_top_rounded,
        colors.accent,
        t.verification.statusPending,
        colors.accentSubtle,
        colors.accent,
      ),
      V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum
          .MORE_INFO_REQUIRED =>
        (
          Icons.info_outline_rounded,
          colors.pending,
          t.verification.statusMoreInfo,
          colors.pendingSubtle,
          colors.pending,
        ),
      V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum.REJECTED =>
        (
          Icons.error_outline_rounded,
          colors.destructive,
          t.verification.statusRejected,
          colors.destructiveSubtle,
          colors.destructive,
        ),
      _ => (
        Icons.shield_outlined,
        colors.textSecondary,
        t.verification.statusNotSubmitted,
        colors.surfaceSunken,
        colors.textSecondary,
      ),
    };

    final isClickable =
        status !=
        V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum.APPROVED;

    return AppCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: isClickable ? () => _handleNavigation(context) : null,
        borderRadius: const BorderRadius.all(AppRadius.lg),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AppLayout.touchTarget),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                Icon(icon, color: iconColor, size: AppIconSize.lg),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    t.verification.profileTileTitle,
                    style: AppText.bodyStrong(locale).copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: badgeBg,
                    borderRadius: const BorderRadius.all(AppRadius.pill),
                  ),
                  child: Text(
                    statusLabel,
                    style: AppText.caption(locale).copyWith(
                      color: badgeTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (isClickable) ...[
                  const SizedBox(width: AppSpacing.xs),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: colors.textMuted,
                    size: AppIconSize.md,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedBanner(
    BuildContext context,
    Translations t,
    AppColors colors,
    Locale locale,
  ) {
    final effectiveReason = rejectionReason?.isNotEmpty == true
        ? rejectionReason!
        : t.verification.bannerRejectedDefaultReason;

    final (
      icon,
      iconColor,
      cardBg,
      borderColor,
      title,
      description,
      ctaLabel,
      isButtonPrimary,
    ) = switch (status) {
      V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum.APPROVED =>
        (
          Icons.verified_rounded,
          colors.verified,
          colors.verifiedSubtle,
          colors.verified.withValues(alpha: 0.3),
          t.verification.bannerApprovedTitle,
          t.verification.bannerApprovedBody,
          null,
          false,
        ),
      V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum.PENDING => (
        Icons.hourglass_top_rounded,
        colors.accent,
        colors.accentSubtle,
        colors.accent.withValues(alpha: 0.3),
        t.verification.bannerPendingTitle,
        t.verification.bannerPendingBody,
        null,
        false,
      ),
      V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum
          .MORE_INFO_REQUIRED =>
        (
          Icons.info_outline_rounded,
          colors.pending,
          colors.pendingSubtle,
          colors.pending.withValues(alpha: 0.4),
          t.verification.bannerMoreInfoTitle,
          t.verification.bannerMoreInfoBody.replaceAll(
            '{reason}',
            effectiveReason,
          ),
          t.verification.bannerMoreInfoCta,
          true,
        ),
      V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum.REJECTED =>
        (
          Icons.error_outline_rounded,
          colors.destructive,
          colors.destructiveSubtle,
          colors.destructive.withValues(alpha: 0.4),
          t.verification.bannerRejectedTitle,
          t.verification.bannerRejectedBody.replaceAll(
            '{reason}',
            effectiveReason,
          ),
          t.verification.bannerRejectedCta,
          true,
        ),
      _ => (
        Icons.shield_outlined,
        colors.accent,
        colors.accentSubtle,
        colors.accent.withValues(alpha: 0.3),
        t.verification.bannerNotSubmittedTitle,
        t.verification.bannerNotSubmittedBody,
        t.verification.bannerNotSubmittedCta,
        false,
      ),
    };

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: const BorderRadius.all(AppRadius.lg),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.surface,
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppText.subtitle(locale).copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      description,
                      style: AppText.small(locale).copyWith(
                        color: colors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (ctaLabel != null) ...[
            const SizedBox(height: AppSpacing.md),
            Align(
              alignment: Alignment.centerRight,
              child: AppButton(
                label: ctaLabel,
                variant: isButtonPrimary
                    ? AppButtonVariant.primary
                    : AppButtonVariant.secondary,
                onPressed: () => _handleNavigation(context),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
