import 'package:flutter/material.dart';

import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/widgets/rating_stars.dart';

/// Sélecteur de note en étoiles (FM-10) — 5 étoiles tappables, `value`
/// entre 0 (aucune sélection) et 5. Distinct de [RatingStars] (lecture
/// seule, `StatelessWidget` sans état ni tap) : les deux widgets ne
/// partagent pas d'implémentation, même choix que `EmptyState`/`ErrorState`
/// (FM-04e) malgré une structure visuelle proche.
class RatingStarsInput extends StatelessWidget {
  const RatingStarsInput({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final int value;
  final ValueChanged<int> onChanged;

  static const double _iconSize = 32;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    // Material(transparency) : même raison que ProviderCard/AppButton — pas
    // de Material ambiant garanti sur l'écran appelant, InkWell en exige un.
    return Material(
      type: MaterialType.transparency,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 1; i <= 5; i++)
            InkWell(
              onTap: () => onChanged(i),
              customBorder: const CircleBorder(),
              child: Padding(
                // Cible tactile ≥48 px (AppLayout.touchTarget) autour d'une
                // icône de 32 px, pas un calcul approximatif : padding
                // symétrique choisi pour que la zone tappable atteigne
                // exactement 48 px ((48-32)/2 = 8 = AppSpacing.sm).
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Icon(
                  i <= value ? Icons.star : Icons.star_border,
                  size: _iconSize,
                  color: colors.rating,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
