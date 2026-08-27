import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';

/// Puce affichant l'état de disponibilité de l'artisan
/// (AVAILABLE = vert, BUSY = orange, ON_HOLIDAY = gris).
class AvailabilityChip extends ConsumerWidget {
  const AvailabilityChip({
    required this.status,
    super.key,
  });

  final V1ProvidersSlugGet200ResponseAvailabilityStatusEnum status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);
    final t = ref.watch(translationsProvider);

    final (textColor, bgColor, label) = switch (status) {
      V1ProvidersSlugGet200ResponseAvailabilityStatusEnum.AVAILABLE => (
        colors.verified,
        colors.verifiedSubtle,
        t.provider.profile.availableNow,
      ),
      V1ProvidersSlugGet200ResponseAvailabilityStatusEnum.BUSY => (
        colors.pending,
        colors.pendingSubtle,
        t.provider.profile.busy,
      ),
      V1ProvidersSlugGet200ResponseAvailabilityStatusEnum.ON_HOLIDAY => (
        colors.textMuted,
        colors.surfaceSunken,
        t.provider.profile.onHoliday,
      ),
      _ => (
        colors.textMuted,
        colors.surfaceSunken,
        t.provider.profile.availableNow,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.all(AppRadius.pill),
      ),
      child: Text(
        label,
        style: AppText.caption(locale).copyWith(
          color: textColor,
          height: 1.2,
        ),
      ),
    );
  }
}
