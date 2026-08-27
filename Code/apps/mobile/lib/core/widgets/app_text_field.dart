import 'package:flutter/material.dart';

import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';

/// Champ de saisie du design system — bordure focus `accent` + halo
/// `accentSubtle`, bordure erreur `destructive` (design-system.html §6).
/// Cible tactile ≥48 px garantie par un `ConstrainedBox`, pas par un calcul
/// approximatif de padding.
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.label,
    this.hintText,
    this.errorText,
    this.controller,
    this.keyboardType,
    this.onChanged,
    this.obscureText = false,
    this.textDirection,
  });

  final String? label;
  final String? hintText;
  final String? errorText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final bool obscureText;

  /// Surcharge explicite de la direction du *contenu saisi* (pas du label,
  /// qui suit toujours la locale ambiante). `null` (défaut) hérite de la
  /// `Directionality` ambiante. À passer en `TextDirection.ltr` par l'écran
  /// appelant pour un numéro de téléphone / code OTP : ce sont des données
  /// intrinsèquement LTR — sans ça, l'algorithme bidi Unicode réordonne
  /// visuellement une chaîne comme « +216 22 123 456 » dans un contexte RTL
  /// (constaté à l'écran sur device réel, écran vitrine FM-04b en arabe).
  final TextDirection? textDirection;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_handleFocusChange)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);
    final hasError = widget.errorText != null;
    final borderColor = hasError
        ? colors.destructive
        : (_isFocused ? colors.accent : colors.borderStrong);
    final outlineBorder = OutlineInputBorder(
      borderRadius: const BorderRadius.all(AppRadius.md),
      borderSide: BorderSide(color: borderColor),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppText.bodyStrong(
              locale,
            ).copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AppLayout.touchTarget),
          // `Material(type: transparency)` : `TextField` exige un ancêtre
          // `Material` (splash/curseur) — comme `AppButton`, ce widget reste
          // autonome sans imposer un `Scaffold` à l'écran appelant.
          child: Material(
            type: MaterialType.transparency,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(AppRadius.md),
                boxShadow: _isFocused && !hasError
                    ? [BoxShadow(color: colors.accentSubtle, spreadRadius: 3)]
                    : null,
              ),
              // `Directionality` explicite (pas seulement `TextField.
              // textDirection`, qui ne couvre que la valeur saisie) : le
              // hint suit sa propre logique de rendu dans `InputDecorator`
              // et ignore `TextField.textDirection` — sans cet enrobage, un
              // hint comme « +216 22 123 456 » reste réordonné par
              // l'algorithme bidi Unicode en contexte RTL malgré la
              // surcharge (constaté à l'écran, écran vitrine FM-04b en
              // arabe).
              child: Directionality(
                textDirection:
                    widget.textDirection ?? Directionality.of(context),
                child: TextField(
                  focusNode: _focusNode,
                  controller: widget.controller,
                  keyboardType: widget.keyboardType,
                  onChanged: widget.onChanged,
                  obscureText: widget.obscureText,
                  textDirection: widget.textDirection,
                  style: AppText.body(
                    locale,
                  ).copyWith(color: colors.textPrimary),
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    errorText: widget.errorText,
                    errorStyle: AppText.small(locale).copyWith(
                      color: colors.destructive,
                      fontWeight: FontWeight.w600,
                    ),
                    filled: true,
                    fillColor: colors.surface,
                    contentPadding: const EdgeInsetsDirectional.symmetric(
                      horizontal: AppSpacing.md + 2,
                      vertical: AppSpacing.md,
                    ),
                    border: outlineBorder,
                    enabledBorder: outlineBorder,
                    focusedBorder: outlineBorder,
                    errorBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(AppRadius.md),
                      borderSide: BorderSide(color: colors.destructive),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(AppRadius.md),
                      borderSide: BorderSide(color: colors.destructive),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
