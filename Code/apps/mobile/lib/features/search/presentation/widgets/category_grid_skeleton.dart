import 'package:flutter/material.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';

/// État de chargement de la grille de catégories — mêmes proportions que
/// `CategoryGrid`, blocs pleins plutôt qu'un spinner plein écran
/// (« Skeletons plutôt que spinners plein écran », `apps/mobile/CLAUDE.md`).
class CategoryGridSkeleton extends StatelessWidget {
  const CategoryGridSkeleton({super.key, this.itemCount = 6});

  final int itemCount;

  static const _crossAxisCount = 3;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _crossAxisCount,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: 0.9,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) => DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surfaceSunken,
          borderRadius: const BorderRadius.all(AppRadius.lg),
        ),
      ),
    );
  }
}
