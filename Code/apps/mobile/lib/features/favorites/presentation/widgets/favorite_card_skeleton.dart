import 'package:flutter/material.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/widgets/app_card.dart';
import 'package:sanaya/core/widgets/app_skeleton.dart';
import 'package:sanaya/features/favorites/presentation/widgets/favorite_card.dart';

/// Skeleton d'une carte favori — affiche un bloc grisé reprenant les dimensions
/// d'une [FavoriteCard] pour une transition fluide sans spinner bloquant (P5).
class FavoriteCardSkeleton extends StatelessWidget {
  const FavoriteCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppCard(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: AppSkeleton(height: 20)),
              SizedBox(width: AppSpacing.lg),
              AppSkeleton.circle(size: 32),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          AppSkeleton(height: 14, width: 180),
          SizedBox(height: AppSpacing.sm),
          AppSkeleton(height: 14, width: 100),
          SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: AppSkeleton(
                  height: 48,
                  borderRadius: BorderRadius.all(AppRadius.md),
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppSkeleton(
                  height: 48,
                  borderRadius: BorderRadius.all(AppRadius.md),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
