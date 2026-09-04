import 'package:flutter/material.dart';

import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';

enum AppButtonVariant {
  primary,
  secondary,
  ghost,
  whatsapp,
  outlineWhatsapp,
  danger,
}

enum AppButtonSize { regular, small }

/// Bouton du design system — 6 variantes, cible tactile ≥48 px (règle 3 du
/// `CLAUDE.md` mobile). Purement présentation : ne poste aucun
/// `ContactEvent` — c'est le rôle de l'écran appelant (FM-09, principe P9).
class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.regular,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final Widget? icon;

  /// Gabarit de composant (design-system.html §4) — 36 n'existe pas dans
  /// l'échelle `AppSpacing`, ce n'est pas un token mais une taille de bouton.
  static const double _smallHeight = 36;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);
    final isSmall = size == AppButtonSize.small;
    final minHeight = isSmall ? _smallHeight : AppLayout.touchTarget;
    final radius = isSmall ? AppRadius.sm : AppRadius.md;
    final horizontalPadding = isSmall ? AppSpacing.md : AppSpacing.xl;
    final palette = _paletteFor(colors, variant);

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[icon!, const SizedBox(width: AppSpacing.sm)],
        Flexible(
          child: Text(
            label,
            style:
                (isSmall ? AppText.small(locale) : AppText.bodyStrong(locale))
                    .copyWith(
                      color: palette.foreground,
                      fontWeight: FontWeight.w600,
                    ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );

    return Opacity(
      opacity: onPressed == null ? 0.45 : 1.0,
      child: Material(
        type: MaterialType.transparency,
        child: Ink(
          decoration: BoxDecoration(
            color: palette.background,
            borderRadius: BorderRadius.all(radius),
            border: palette.borderColor != null
                ? Border.all(color: palette.borderColor!)
                : null,
          ),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.all(radius),
            // ConstrainedBox + Padding, pas Container(alignment:) : un
            // Container avec un alignment non nul s'étend pour remplir
            // l'espace dès que le parent lui donne des contraintes bornées
            // (c'est le cas ici, dans un Wrap) — bug constaté à l'écran
            // vitrine (boutons pleine largeur au lieu de s'ajuster à leur
            // contenu). ConstrainedBox n'a pas cet effet de bord ; le
            // centrage vertical reste assuré par le crossAxisAlignment
            // par défaut (center) du Row de contenu.
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: minHeight),
              child: Padding(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: horizontalPadding,
                ),
                child: content,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _AppButtonPalette _paletteFor(AppColors colors, AppButtonVariant variant) {
    return switch (variant) {
      AppButtonVariant.primary => _AppButtonPalette(
        background: colors.accent,
        foreground: colors.onAccent,
      ),
      AppButtonVariant.whatsapp => _AppButtonPalette(
        background: colors.whatsapp,
        foreground: colors.onAccent,
      ),
      // FM-30 : action secondaire (WhatsApp en contour) sur la fiche
      // artisan — Appeler reste l'action primaire pleine (A4/B4).
      AppButtonVariant.outlineWhatsapp => _AppButtonPalette(
        background: Colors.transparent,
        foreground: colors.whatsapp,
        borderColor: colors.whatsapp,
      ),
      AppButtonVariant.secondary => _AppButtonPalette(
        background: colors.surface,
        foreground: colors.textPrimary,
        borderColor: colors.borderStrong,
      ),
      AppButtonVariant.ghost => _AppButtonPalette(
        background: Colors.transparent,
        foreground: colors.accent,
      ),
      AppButtonVariant.danger => _AppButtonPalette(
        background: Colors.transparent,
        foreground: colors.destructive,
        borderColor: colors.destructive,
      ),
    };
  }
}

class _AppButtonPalette {
  const _AppButtonPalette({
    required this.background,
    required this.foreground,
    this.borderColor,
  });

  final Color background;
  final Color foreground;
  final Color? borderColor;
}
