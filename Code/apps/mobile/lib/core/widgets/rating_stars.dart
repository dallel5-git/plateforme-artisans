import 'package:flutter/material.dart';
import 'package:sanaya/core/i18n/format.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';

/// 5 étoiles pleines/vides (arrondi à l'entier le plus proche) + note et
/// nombre d'avis en texte (design-system.html §7, ex. "★★★★★ 4,8 (63)").
class RatingStars extends StatelessWidget {
  const RatingStars({
    required this.rating,
    super.key,
    this.reviewCount,
    this.size = 14,
  });

  final double rating;
  final int? reviewCount;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);
    final filledStars = rating.round().clamp(0, 5);
    final ratingLabel = formatNumber(rating, locale);
    final displayText = reviewCount != null
        ? '$ratingLabel ($reviewCount)'
        : ratingLabel;

    // FM-43 : les 5 icônes étoile sont décoratives (muettes en soi) — un
    // seul nœud Semantics porte le texte déjà affiché, plutôt que de
    // laisser un lecteur d'écran traverser 5 icônes silencieuses avant le
    // texte. `excludeSemantics: true` supprime la sémantique implicite du
    // `Text` descendant pour éviter un double-libellé (même piège déjà
    // rencontré sur `AppBottomNav`, FM-22).
    return Semantics(
      label: displayText,
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < 5; i++)
            Icon(
              i < filledStars ? Icons.star : Icons.star_border,
              color: colors.rating,
              size: size,
            ),
          const SizedBox(width: AppSpacing.xs),
          Flexible(
            child: Text(
              displayText,
              style: AppText.small(
                locale,
              ).copyWith(color: colors.textSecondary),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
