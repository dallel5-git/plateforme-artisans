// ⚠️ FICHIER GÉNÉRÉ — NE PAS ÉDITER À LA MAIN.
// Source : packages/design-tokens/tokens.json
// Régénérer : pnpm tokens:build
// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

/// Ombres portées thématisées. Injecté dans le ThemeData via [ThemeExtension].
@immutable
class AppElevation extends ThemeExtension<AppElevation> {
  final List<BoxShadow> none;
  final List<BoxShadow> sm;
  final List<BoxShadow> md;
  final List<BoxShadow> lg;

  const AppElevation({
    required this.none,
    required this.sm,
    required this.md,
    required this.lg,
  });

  static const light = AppElevation(
    none: const [],
    sm: const [
      BoxShadow(
        offset: Offset(0.0, 1.0),
        blurRadius: 2.0,
        spreadRadius: 0.0,
        color: Color.fromRGBO(20, 26, 36, 0.06),
      ),
    ],
    md: const [
      BoxShadow(
        offset: Offset(0.0, 4.0),
        blurRadius: 12.0,
        spreadRadius: 0.0,
        color: Color.fromRGBO(20, 26, 36, 0.08),
      ),
    ],
    lg: const [
      BoxShadow(
        offset: Offset(0.0, 12.0),
        blurRadius: 32.0,
        spreadRadius: 0.0,
        color: Color.fromRGBO(20, 26, 36, 0.12),
      ),
    ],
  );

  static const dark = AppElevation(
    none: const [],
    sm: const [
      BoxShadow(
        offset: Offset(0.0, 1.0),
        blurRadius: 2.0,
        spreadRadius: 0.0,
        color: Color.fromRGBO(0, 0, 0, 0.32),
      ),
    ],
    md: const [
      BoxShadow(
        offset: Offset(0.0, 4.0),
        blurRadius: 12.0,
        spreadRadius: 0.0,
        color: Color.fromRGBO(0, 0, 0, 0.40),
      ),
    ],
    lg: const [
      BoxShadow(
        offset: Offset(0.0, 12.0),
        blurRadius: 32.0,
        spreadRadius: 0.0,
        color: Color.fromRGBO(0, 0, 0, 0.48),
      ),
    ],
  );

  @override
  AppElevation copyWith({
    List<BoxShadow>? none,
    List<BoxShadow>? sm,
    List<BoxShadow>? md,
    List<BoxShadow>? lg,
  }) => AppElevation(
    none: none ?? this.none,
    sm: sm ?? this.sm,
    md: md ?? this.md,
    lg: lg ?? this.lg,
  );

  @override
  AppElevation lerp(ThemeExtension<AppElevation>? other, double t) {
    if (other is! AppElevation) return this;
    return AppElevation(
      none: BoxShadow.lerpList(this.none, other.none, t) ?? this.none,
      sm: BoxShadow.lerpList(this.sm, other.sm, t) ?? this.sm,
      md: BoxShadow.lerpList(this.md, other.md, t) ?? this.md,
      lg: BoxShadow.lerpList(this.lg, other.lg, t) ?? this.lg,
    );
  }
}

extension AppElevationX on BuildContext {
  AppElevation get elevation => Theme.of(this).extension<AppElevation>()!;
}
