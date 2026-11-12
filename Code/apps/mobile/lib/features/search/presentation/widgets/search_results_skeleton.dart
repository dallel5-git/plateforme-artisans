import 'package:flutter/material.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/widgets/app_card.dart';
import 'package:sanaya/core/widgets/app_skeleton.dart';
import 'package:sanaya/core/widgets/provider_card.dart';

/// Skeleton pour la liste des résultats de recherche (FM-28d, P5).
/// Reproduit la structure de [ProviderCard] pour éviter les sauts de contenu.
class SearchResultsSkeleton extends StatelessWidget {
  const SearchResultsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: 5,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) => const _ProviderCardSkeleton(),
    );
  }
}

class _ProviderCardSkeleton extends StatelessWidget {
  const _ProviderCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return const AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSkeleton(
            width: 56,
            height: 56,
            borderRadius: BorderRadius.all(AppRadius.sm),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSkeleton(height: 18, width: 140),
                SizedBox(height: AppSpacing.xs),
                AppSkeleton(height: 14, width: 180),
                SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppSkeleton(height: 14, width: 100),
                    AppSkeleton(height: 14, width: 60),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          AppSkeleton.circle(size: 24),
        ],
      ),
    );
  }
}
