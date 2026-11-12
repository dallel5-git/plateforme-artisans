import 'package:flutter/material.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';

/// Carte d'option de boost sélectionnable (maquettes A6 / C3 — issue #237).
///
/// Affiche la durée, la description, le coût en crédits et le badge
/// « Sponsorisé ». L'état sélectionné adopte la couleur `amber` des design
/// tokens (FM-15).
class BoostOptionCard extends StatelessWidget {
  const BoostOptionCard({
    required this.title,
    required this.description,
    required this.priceLabel,
    required this.sponsoredLabel,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String title;
  final String description;
  final String priceLabel;
  final String sponsoredLabel;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);

    final selectedBg = colors.amber.withValues(alpha: 0.12);
    final selectedBorder = colors.amber;

    return Semantics(
      button: true,
      selected: selected,
      label: '$title, $priceLabel',
      child: Material(
        color: selected ? selectedBg : colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(AppRadius.lg),
          side: BorderSide(
            color: selected ? selectedBorder : colors.border,
            width: selected ? 2.0 : 1.0,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: const BorderRadius.all(AppRadius.lg),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: selected ? colors.amber : colors.textMuted,
                  size: AppIconSize.md,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: AppText.h3(locale).copyWith(
                                color: colors.textPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.xs,
                              vertical: AppSpacing.xxs,
                            ),
                            decoration: BoxDecoration(
                              color: colors.pendingSubtle,
                              borderRadius: const BorderRadius.all(
                                AppRadius.sm,
                              ),
                            ),
                            child: Text(
                              sponsoredLabel,
                              style: AppText.caption(locale).copyWith(
                                color: colors.sponsored,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        description,
                        style: AppText.small(locale).copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        priceLabel,
                        style: AppText.bodyStrong(locale).copyWith(
                          color: colors.accent,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
