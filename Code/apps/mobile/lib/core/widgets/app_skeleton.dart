import 'package:flutter/material.dart';

import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';

/// Bloc de chargement générique (design-system.html `.sk`) — remplace un
/// spinner plein écran par la silhouette du contenu à venir (« Skeletons
/// plutôt que spinners plein écran », `CLAUDE.md` mobile, principe P5).
/// Pas d'animation de pulsation : cohérent avec `CategoryGridSkeleton`/
/// `FavoriteCardSkeleton`, déjà des blocs statiques `surfaceSunken`.
class AppSkeleton extends StatelessWidget {
  const AppSkeleton({
    super.key,
    this.width,
    this.height = AppSpacing.lg,
    this.shape = AppSkeletonShape.rectangle,
    this.borderRadius,
  });

  /// Bloc circulaire — avatar, icône. `width`/`height` doivent être égaux
  /// pour un cercle correct ; c'est à l'appelant de les fournir cohérents.
  const AppSkeleton.circle({required double size, super.key})
    : width = size,
      height = size,
      shape = AppSkeletonShape.circle,
      borderRadius = null;

  final double? width;
  final double height;
  final AppSkeletonShape shape;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isCircle = shape == AppSkeletonShape.circle;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: colors.surfaceSunken,
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircle
            ? null
            : borderRadius ?? const BorderRadius.all(AppRadius.sm),
      ),
    );
  }
}

enum AppSkeletonShape { rectangle, circle }
