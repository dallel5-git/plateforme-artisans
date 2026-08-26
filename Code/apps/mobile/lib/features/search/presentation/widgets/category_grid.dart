import 'package:flutter/material.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/app_card.dart';
import 'package:sanaya/features/search/presentation/category_icons.dart';

/// Grille de catégories — icônes larges, contrastes forts (la cible inclut
/// des artisans peu à l'aise avec le texte et des clients pressés, cf.
/// contexte de l'issue FM-06). Aucun code RTL spécifique : `GridView`
/// remplit déjà de droite à gauche sous `Directionality.rtl` ambiante.
class CategoryGrid extends StatelessWidget {
  const CategoryGrid({
    required this.categories,
    required this.onTap,
    super.key,
  });

  final List<CategoryTreeNode> categories;
  final ValueChanged<CategoryTreeNode> onTap;

  static const _crossAxisCount = 3;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
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
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return _CategoryTile(
          category: category,
          locale: locale,
          onTap: () => onTap(category),
        );
      },
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.category,
    required this.locale,
    required this.onTap,
  });

  final CategoryTreeNode category;
  final Locale locale;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final accent = _parseHexColor(category.colorHex) ?? colors.accent;
    final label = locale.languageCode == 'ar'
        ? category.nameAr
        : category.nameFr;

    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(AppRadius.lg),
        child: AppCard(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  categoryIconFor(category.iconKey),
                  size: 32,
                  color: accent,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                label,
                style:
                    AppText.small(
                      locale,
                    ).copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// `colorHex` (BE-14b) est au format `#RRGGBB` — repli sur `colors.accent`
/// si jamais une valeur inattendue arrivait (défense simple, pas une règle
/// métier : l'API garantit déjà le format côté backend).
Color? _parseHexColor(String hex) {
  final normalized = hex.replaceFirst('#', '');
  if (normalized.length != 6) return null;
  final value = int.tryParse('FF$normalized', radix: 16);
  return value == null ? null : Color(value);
}
