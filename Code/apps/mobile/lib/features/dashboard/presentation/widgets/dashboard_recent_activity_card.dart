import 'package:flutter/material.dart';
import 'package:sanaya/core/i18n/translations.g.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/app_card.dart';

/// Carte affichant les interactions et demandes récentes de l'artisan.
class DashboardRecentActivityCard extends StatelessWidget {
  const DashboardRecentActivityCard({
    required this.t,
    super.key,
  });

  final Translations t;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.history_rounded, size: 20, color: colors.accent),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  t.dashboard.recentActivityTitle,
                  style: AppText.bodyStrong(locale).copyWith(
                    color: colors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            t.dashboard.recentActivitySubtitle,
            style: AppText.caption(locale).copyWith(
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _ActivityItem(
            icon: Icons.chat_rounded,
            iconColor: colors.whatsapp,
            title: t.dashboard.recentLeadWhatsappTitle,
            subtitle: t.dashboard.recentLeadWhatsappDesc,
            time: t.dashboard.time2hAgo,
          ),
          Divider(color: colors.border, height: AppSpacing.lg),
          _ActivityItem(
            icon: Icons.phone_callback_rounded,
            iconColor: colors.accent,
            title: t.dashboard.recentLeadPhoneTitle,
            subtitle: t.dashboard.recentLeadPhoneDesc,
            time: t.dashboard.time5hAgo,
          ),
          Divider(color: colors.border, height: AppSpacing.lg),
          _ActivityItem(
            icon: Icons.star_rounded,
            iconColor: colors.rating,
            title: t.dashboard.recentLeadReviewTitle,
            subtitle: t.dashboard.recentLeadReviewDesc,
            time: t.dashboard.timeYesterday,
          ),
        ],
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  const _ActivityItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String time;

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
            color: iconColor.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: iconColor),
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
                subtitle,
                style: AppText.caption(locale).copyWith(
                  color: colors.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          time,
          style: AppText.caption(locale).copyWith(
            color: colors.textMuted,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
