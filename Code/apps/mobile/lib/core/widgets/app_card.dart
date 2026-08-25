import 'package:flutter/material.dart';

import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';

/// Conteneur générique du design system — fond `surface`, bordure 1 px,
/// rayon `AppRadius.lg`. Pas d'ombre portée : `elevation` existe dans
/// `tokens.json` mais n'est pas encore exporté en Dart par
/// `build-tokens.mjs` (seuls colors/spacing/typography le sont) — écart
/// connu avec `design-system.html`, pas un oubli (voir backlog non planifié).
class AppCard extends StatelessWidget {
  const AppCard({required this.child, super.key, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.border),
        borderRadius: const BorderRadius.all(AppRadius.lg),
      ),
      child: child,
    );
  }
}
