// ⚠️ FICHIER GÉNÉRÉ — NE PAS ÉDITER À LA MAIN.
// Source : packages/design-tokens/tokens.json
// Régénérer : pnpm tokens:build
// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

/// Palette brute. À n'utiliser que pour construire un [AppColors].
/// Dans les widgets, passer par `context.colors.<role>`.
abstract final class Palette {
  // brand
  static const brand50 = Color(0xFFEEF3FD);
  static const brand100 = Color(0xFFDFECFF);
  static const brand200 = Color(0xFFC2D6F8);
  static const brand300 = Color(0xFF95B4F0);
  static const brand400 = Color(0xFF6690E8);
  static const brand500 = Color(0xFF3B6FE0);
  static const brand600 = Color(0xFF2A57C4);
  static const brand700 = Color(0xFF1F449C);
  static const brand800 = Color(0xFF1559B5);
  static const brand900 = Color(0xFF132F6B);

  // neutral
  static const neutral0 = Color(0xFFFFFFFF);
  static const neutral25 = Color(0xFFFCFCFA);
  static const neutral50 = Color(0xFFF3F2ED);
  static const neutral100 = Color(0xFFECEEF0);
  static const neutral200 = Color(0xFFE9ECF0);
  static const neutral300 = Color(0xFFD3D7DE);
  static const neutral400 = Color(0xFFA8B0BD);
  static const neutral500 = Color(0xFF78818F);
  static const neutral600 = Color(0xFF525C6B);
  static const neutral700 = Color(0xFF343D4B);
  static const neutral800 = Color(0xFF1F2733);
  static const neutral900 = Color(0xFF141A24);
  static const neutral950 = Color(0xFF11161F);
  static const neutral1000 = Color(0xFF0A0D12);

  // success
  static const success50 = Color(0xFFE8F6EE);
  static const success100 = Color(0xFFC6E9D6);
  static const success500 = Color(0xFF1E7F4C);
  static const success600 = Color(0xFF17603A);
  static const success700 = Color(0xFF0F4527);

  // warning
  static const warning50 = Color(0xFFFEF5E6);
  static const warning100 = Color(0xFFFBE6BF);
  static const warning500 = Color(0xFFA9640A);
  static const warning600 = Color(0xFF8A5605);
  static const warning700 = Color(0xFF6B4204);

  // danger
  static const danger50 = Color(0xFFFDECEC);
  static const danger100 = Color(0xFFF8CFCF);
  static const danger500 = Color(0xFFD93B3B);
  static const danger600 = Color(0xFFB32C2C);
  static const danger700 = Color(0xFF8C2020);

  // info
  static const info50 = Color(0xFFE9F2FE);
  static const info500 = Color(0xFF2C7BE5);
}

/// Rôles sémantiques. Injecté dans le ThemeData via [ThemeExtension],
/// ce qui rend le basculement clair/sombre automatique.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color background;
  final Color surface;
  final Color surfaceRaised;
  final Color surfaceSunken;
  final Color border;
  final Color borderStrong;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color textInverse;
  final Color accent;
  final Color accentHover;
  final Color accentSubtle;
  final Color onAccent;
  final Color verified;
  final Color verifiedSubtle;
  final Color pending;
  final Color pendingSubtle;
  final Color destructive;
  final Color destructiveSubtle;
  final Color rating;
  final Color sponsored;
  final Color whatsapp;

  const AppColors({
    required this.background,
    required this.surface,
    required this.surfaceRaised,
    required this.surfaceSunken,
    required this.border,
    required this.borderStrong,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.textInverse,
    required this.accent,
    required this.accentHover,
    required this.accentSubtle,
    required this.onAccent,
    required this.verified,
    required this.verifiedSubtle,
    required this.pending,
    required this.pendingSubtle,
    required this.destructive,
    required this.destructiveSubtle,
    required this.rating,
    required this.sponsored,
    required this.whatsapp,
  });

  static const light = AppColors(
    background: const Color(0xFFFCFCFA),
    surface: const Color(0xFFFFFFFF),
    surfaceRaised: const Color(0xFFFFFFFF),
    surfaceSunken: const Color(0xFFF3F2ED),
    border: const Color(0xFFE9ECF0),
    borderStrong: const Color(0xFFD3D7DE),
    textPrimary: const Color(0xFF141A24),
    textSecondary: const Color(0xFF525C6B),
    textMuted: const Color(0xFF78818F),
    textInverse: const Color(0xFFFFFFFF),
    accent: const Color(0xFF3B6FE0),
    accentHover: const Color(0xFF2A57C4),
    accentSubtle: const Color(0xFFEEF3FD),
    onAccent: const Color(0xFFFFFFFF),
    verified: const Color(0xFF1E7F4C),
    verifiedSubtle: const Color(0xFFE8F6EE),
    pending: const Color(0xFFA9640A),
    pendingSubtle: const Color(0xFFFEF5E6),
    destructive: const Color(0xFFD93B3B),
    destructiveSubtle: const Color(0xFFFDECEC),
    rating: const Color(0xFFC77800),
    sponsored: const Color(0xFFA9640A),
    whatsapp: const Color(0xFF128C7E),
  );

  static const dark = AppColors(
    background: const Color(0xFF0A0D12),
    surface: const Color(0xFF141A24),
    surfaceRaised: const Color(0xFF1F2733),
    surfaceSunken: const Color(0xFF11161F),
    border: const Color(0xFF1F2733),
    borderStrong: const Color(0xFF343D4B),
    textPrimary: const Color(0xFFFCFCFA),
    textSecondary: const Color(0xFFA8B0BD),
    textMuted: const Color(0xFF78818F),
    textInverse: const Color(0xFF141A24),
    accent: const Color(0xFF6690E8),
    accentHover: const Color(0xFF95B4F0),
    accentSubtle: const Color(0xFF1A2440),
    onAccent: const Color(0xFF0A0D12),
    verified: const Color(0xFF3FBF7F),
    verifiedSubtle: const Color(0xFF0F2A1C),
    pending: const Color(0xFFE8A72B),
    pendingSubtle: const Color(0xFF2E2210),
    destructive: const Color(0xFFF26D6D),
    destructiveSubtle: const Color(0xFF2E1414),
    rating: const Color(0xFFF5A623),
    sponsored: const Color(0xFFE8A72B),
    whatsapp: const Color(0xFF25D366),
  );

  @override
  AppColors copyWith() => this;

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) =>
      other is AppColors ? (t < 0.5 ? this : other) : this;
}

extension AppColorsX on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
