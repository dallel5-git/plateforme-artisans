import 'package:flutter/material.dart';
import 'package:sanaya/core/i18n/translations.g.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/app_card.dart';

/// Barre de recherche de l'accueil client : service (texte libre) +
/// localisation (déclenche un sélecteur externe via [onLocationTap]).
/// Widget purement présentation — aucun appel réseau, aucune règle métier
/// (P3). La recherche elle-même (résultats) est hors périmètre FM-06,
/// dépend de FM-07/BE-16 non encore livrés.
class SearchHomeBar extends StatelessWidget {
  const SearchHomeBar({
    required this.t,
    required this.locationLabel,
    required this.onLocationTap,
    super.key,
    this.onQueryChanged,
    this.onQuerySubmitted,
  });

  final Translations t;
  final String locationLabel;
  final VoidCallback onLocationTap;
  final ValueChanged<String>? onQueryChanged;
  final ValueChanged<String>? onQuerySubmitted;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Column(
        children: [
          TextField(
            onChanged: onQueryChanged,
            onSubmitted: onQuerySubmitted,
            style: AppText.body(locale).copyWith(color: colors.textPrimary),
            decoration: InputDecoration(
              hintText: t.search.searchPlaceholder,
              hintStyle: AppText.body(locale).copyWith(color: colors.textMuted),
              border: InputBorder.none,
              isDense: true,
              prefixIcon: Icon(Icons.search, color: colors.textMuted),
            ),
          ),
          Divider(height: AppSpacing.lg, color: colors.border),
          InkWell(
            onTap: onLocationTap,
            borderRadius: const BorderRadius.all(AppRadius.md),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
              child: Row(
                children: [
                  Icon(Icons.location_on_outlined, color: colors.accent),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      locationLabel,
                      style: AppText.bodyStrong(
                        locale,
                      ).copyWith(color: colors.textPrimary),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // `Icons.chevron_right` porte déjà
                  // IconData.matchTextDirection: true — miroité
                  // automatiquement en RTL (cf. apps/mobile/CLAUDE.md).
                  Icon(Icons.chevron_right, color: colors.textMuted),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
