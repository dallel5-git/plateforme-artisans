import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/core/widgets/app_badge.dart';

/// Puce affichant l'état de disponibilité de l'artisan
/// (AVAILABLE = vert, BUSY = orange, ON_HOLIDAY = gris).
class AvailabilityChip extends ConsumerWidget {
  const AvailabilityChip({required this.status, super.key});

  final V1ProvidersSlugGet200ResponseAvailabilityStatusEnum status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationsProvider);

    final (variant, label) = switch (status) {
      V1ProvidersSlugGet200ResponseAvailabilityStatusEnum.AVAILABLE => (
        AppBadgeVariant.verified,
        t.provider.profile.availableNow,
      ),
      V1ProvidersSlugGet200ResponseAvailabilityStatusEnum.BUSY => (
        AppBadgeVariant.pending,
        t.provider.profile.busy,
      ),
      V1ProvidersSlugGet200ResponseAvailabilityStatusEnum.ON_HOLIDAY => (
        AppBadgeVariant.neutral,
        t.provider.profile.onHoliday,
      ),
      _ => (AppBadgeVariant.neutral, t.provider.profile.availableNow),
    };

    return AppBadge(label: label, variant: variant);
  }
}
