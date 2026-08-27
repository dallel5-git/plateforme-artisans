import 'package:flutter/material.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/widgets/app_card.dart';
import 'package:sanaya/features/favorites/presentation/widgets/favorite_card.dart';

/// Skeleton d'une carte favori — affiche un bloc grisé reprenant les dimensions
/// d'une [FavoriteCard] pour une transition fluide sans spinner bloquant (P5).
class FavoriteCardSkeleton extends StatelessWidget {
  const FavoriteCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 20,
                  decoration: BoxDecoration(
                    color: colors.surfaceSunken,
                    borderRadius: const BorderRadius.all(AppRadius.sm),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: colors.surfaceSunken,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            height: 14,
            width: 180,
            decoration: BoxDecoration(
              color: colors.surfaceSunken,
              borderRadius: const BorderRadius.all(AppRadius.sm),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            height: 14,
            width: 100,
            decoration: BoxDecoration(
              color: colors.surfaceSunken,
              borderRadius: const BorderRadius.all(AppRadius.sm),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: colors.surfaceSunken,
                    borderRadius: const BorderRadius.all(AppRadius.md),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: colors.surfaceSunken,
                    borderRadius: const BorderRadius.all(AppRadius.md),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
