import 'package:flutter/material.dart';
import 'package:sanaya/core/i18n/translations.g.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/app_card.dart';
import 'package:sanaya/features/dashboard/data/dashboard_repository.dart';

/// Carte de répartition des contacts par canal (Téléphone vs WhatsApp).
class DashboardContactChannelsCard extends StatelessWidget {
  const DashboardContactChannelsCard({
    required this.totals,
    required this.t,
    super.key,
  });

  final ProviderStatsTotals totals;
  final Translations t;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);

    final phoneCount = totals.contactsByChannel.phone;
    final whatsappCount = totals.contactsByChannel.whatsapp;
    final totalContacts = totals.contacts;

    final phonePercent = totalContacts > 0
        ? (phoneCount / totalContacts * 100).round()
        : 0;
    final whatsappPercent = totalContacts > 0
        ? (whatsappCount / totalContacts * 100).round()
        : 0;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.pie_chart_outline_rounded,
                size: 20,
                color: colors.accent,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  t.dashboard.channelsTitle,
                  style: AppText.bodyStrong(locale).copyWith(
                    color: colors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            t.dashboard.channelsSubtitle,
            style: AppText.caption(locale).copyWith(
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _ChannelRow(
            icon: Icons.phone_in_talk_rounded,
            iconColor: colors.accent,
            label: t.dashboard.channelPhone,
            count: phoneCount,
            percent: phonePercent,
            barColor: colors.accent,
          ),
          const SizedBox(height: AppSpacing.md),
          _ChannelRow(
            icon: Icons.chat_rounded,
            iconColor: colors.whatsapp,
            label: t.dashboard.channelWhatsapp,
            count: whatsappCount,
            percent: whatsappPercent,
            barColor: colors.whatsapp,
          ),
        ],
      ),
    );
  }
}

class _ChannelRow extends StatelessWidget {
  const _ChannelRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.count,
    required this.percent,
    required this.barColor,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final int count;
  final int percent;
  final Color barColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: iconColor),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text(
                label,
                style: AppText.small(locale).copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              '$count ($percent%)',
              style: AppText.small(locale).copyWith(
                color: colors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        ClipRRect(
          borderRadius: const BorderRadius.all(AppRadius.pill),
          child: LinearProgressIndicator(
            value: percent > 0 ? (percent / 100).clamp(0.0, 1.0) : 0.0,
            minHeight: 6,
            backgroundColor: colors.surfaceSunken,
            valueColor: AlwaysStoppedAnimation<Color>(barColor),
          ),
        ),
      ],
    );
  }
}
