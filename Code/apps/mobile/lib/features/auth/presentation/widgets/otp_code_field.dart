import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';

/// Champ OTP à [length] cases (FM-05) — widget maison, aucune dépendance
/// ajoutée. Avancement automatique au caractère suivant, retour-arrière vers
/// la case précédente si vide, collage d'un code entier supporté (détection
/// d'une valeur de plus d'un caractère dans une case).
///
/// Recréer ce widget avec une [Key] différente (ex. incrémenter un compteur
/// de tentative côté appelant) réinitialise les cases — c'est le mécanisme
/// utilisé pour vider le champ après un code invalide.
class OtpCodeField extends StatefulWidget {
  const OtpCodeField({
    required this.length,
    required this.onCompleted,
    super.key,
    this.enabled = true,
    this.hasError = false,
    this.autofocus = true,
  });

  final int length;
  final ValueChanged<String> onCompleted;
  final bool enabled;
  final bool hasError;
  final bool autofocus;

  @override
  State<OtpCodeField> createState() => _OtpCodeFieldState();
}

class _OtpCodeFieldState extends State<OtpCodeField> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.length,
      (_) => TextEditingController(),
    );
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _handleChanged(int index, String value) {
    // Collage d'un coup : distribue les chiffres à partir de la case
    // courante, une case = un chiffre.
    if (value.length > 1) {
      final digits = value.split('').take(widget.length - index).toList();
      for (var i = 0; i < digits.length; i++) {
        _controllers[index + i].text = digits[i];
      }
      final lastFilled = (index + digits.length - 1).clamp(
        0,
        widget.length - 1,
      );
      if (index + digits.length >= widget.length) {
        _focusNodes[lastFilled].unfocus();
        widget.onCompleted(_currentCode());
      } else {
        _focusNodes[index + digits.length].requestFocus();
      }
      return;
    }

    if (value.isEmpty) {
      if (index > 0) _focusNodes[index - 1].requestFocus();
      return;
    }

    if (index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    } else {
      _focusNodes[index].unfocus();
    }

    if (_currentCode().length == widget.length) {
      widget.onCompleted(_currentCode());
    }
  }

  String _currentCode() => _controllers.map((c) => c.text).join();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);
    final borderColor = widget.hasError
        ? colors.destructive
        : colors.borderStrong;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(widget.length, (index) {
        return SizedBox(
          width: 44,
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            enabled: widget.enabled,
            autofocus: widget.autofocus && index == 0,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: widget.length,
            style: AppText.bodyStrong(
              locale,
            ).copyWith(color: colors.textPrimary),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: colors.surface,
              contentPadding: const EdgeInsetsDirectional.symmetric(
                vertical: AppSpacing.md,
              ),
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(AppRadius.md),
                borderSide: BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(AppRadius.md),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(AppRadius.md),
                borderSide: BorderSide(
                  color: widget.hasError ? colors.destructive : colors.accent,
                ),
              ),
            ),
            onChanged: (value) => _handleChanged(index, value),
          ),
        );
      }),
    );
  }
}
