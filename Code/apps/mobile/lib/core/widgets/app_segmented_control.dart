import 'package:flutter/material.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_elevation.dart';
import 'package:sanaya/core/theme/app_motion.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';

/// Définition d'un segment pour [AppSegmentedControl].
@immutable
class AppSegment<T> {
  const AppSegment({
    required this.value,
    required this.label,
    this.icon,
    this.semanticsLabel,
  });

  final T value;
  final String label;
  final IconData? icon;
  final String? semanticsLabel;
}

/// Contrôle segmenté moderne (design-system — maquettes A6 / C3).
///
/// Affiche une liste de segments sous forme de pilule avec transition fluide
/// de l'onglet actif ([AppMotion.durationFast]), respect des contrastes et
/// de l'accessibilité ([Semantics]).
class AppSegmentedControl<T> extends StatelessWidget {
  const AppSegmentedControl({
    required this.segments,
    required this.selectedValue,
    required this.onValueChanged,
    super.key,
    this.padding,
  });

  final List<AppSegment<T>> segments;
  final T selectedValue;
  final ValueChanged<T> onValueChanged;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);

    return Container(
      padding: padding ?? const EdgeInsets.all(AppSpacing.xxs),
      decoration: BoxDecoration(
        color: colors.surfaceSunken,
        borderRadius: const BorderRadius.all(AppRadius.pill),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: segments.map((segment) {
          final isSelected = segment.value == selectedValue;

          return Expanded(
            child: Semantics(
              button: true,
              selected: isSelected,
              label: segment.semanticsLabel ?? segment.label,
              excludeSemantics: true,
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  onTap: () => onValueChanged(segment.value),
                  borderRadius: const BorderRadius.all(AppRadius.pill),
                  child: AnimatedContainer(
                    duration: AppMotion.durationFast,
                    curve: AppMotion.easingStandard,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? colors.surface : Colors.transparent,
                      borderRadius: const BorderRadius.all(AppRadius.pill),
                      boxShadow: isSelected ? context.elevation.sm : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (segment.icon != null) ...[
                          Icon(
                            segment.icon,
                            size: AppIconSize.sm,
                            color: isSelected
                                ? colors.textPrimary
                                : colors.textSecondary,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                        ],
                        Flexible(
                          child: Text(
                            segment.label,
                            style:
                                (isSelected
                                        ? AppText.bodyStrong(locale)
                                        : AppText.body(locale))
                                    .copyWith(
                                      color: isSelected
                                          ? colors.textPrimary
                                          : colors.textSecondary,
                                    ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
