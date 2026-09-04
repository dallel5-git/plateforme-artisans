import 'package:flutter/material.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/widgets/app_card.dart';

/// Skeleton d'une `HistoryEntryCard` — bloc grisé reprenant ses dimensions
/// pour une transition fluide sans spinner bloquant (P5), gabarit
/// `FavoriteCardSkeleton`.
class HistoryEntryCardSkeleton extends StatelessWidget {
  const HistoryEntryCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 16,
            width: 180,
            decoration: BoxDecoration(
              color: colors.surfaceSunken,
              borderRadius: const BorderRadius.all(AppRadius.sm),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            height: 12,
            width: 100,
            decoration: BoxDecoration(
              color: colors.surfaceSunken,
              borderRadius: const BorderRadius.all(AppRadius.sm),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            height: 20,
            width: 80,
            decoration: BoxDecoration(
              color: colors.surfaceSunken,
              borderRadius: const BorderRadius.all(AppRadius.pill),
            ),
          ),
        ],
      ),
    );
  }
}
