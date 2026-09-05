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
  final Color onWhatsapp;
  final Color amber;
  final Color onAmber;
  final Color scrim;
  final Color onScrim;
  final Color thumbnail;
  final Color thumbnailBorder;
  final Color chartBar;
  final Color chartBarHighlight;
  final Color navActive;
  final Color navInactive;
  final Color navBackground;

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
    required this.onWhatsapp,
    required this.amber,
    required this.onAmber,
    required this.scrim,
    required this.onScrim,
    required this.thumbnail,
    required this.thumbnailBorder,
    required this.chartBar,
    required this.chartBarHighlight,
    required this.navActive,
    required this.navInactive,
    required this.navBackground,
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
    sponsored: const Color(0xFFB8860B),
    whatsapp: const Color(0xFF128C7E),
    onWhatsapp: const Color(0xFFFFFFFF),
    amber: const Color(0xFFC77800),
    onAmber: const Color(0xFFFFFFFF),
    scrim: const Color(0xFF2B2F36),
    onScrim: const Color(0xFFFFFFFF),
    thumbnail: const Color(0xFFF3F2ED),
    thumbnailBorder: const Color(0xFFE9ECF0),
    chartBar: const Color(0xFF95B4F0),
    chartBarHighlight: const Color(0xFF3B6FE0),
    navActive: const Color(0xFF3B6FE0),
    navInactive: const Color(0xFF78818F),
    navBackground: const Color(0xFFFFFFFF),
  );

  static const dark = AppColors(
    background: const Color(0xFF0A0D12),
    surface: const Color(0xFF141A24),
    surfaceRaised: const Color(0xFF1F2733),
    surfaceSunken: const Color(0xFF11161F),
    border: const Color(0xFF2A3441),
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
    sponsored: const Color(0xFFC99A2E),
    whatsapp: const Color(0xFF25D366),
    onWhatsapp: const Color(0xFFFFFFFF),
    amber: const Color(0xFFF5A623),
    onAmber: const Color(0xFF141A24),
    scrim: const Color(0xFF05070A),
    onScrim: const Color(0xFFFFFFFF),
    thumbnail: const Color(0xFF232C39),
    thumbnailBorder: const Color(0xFF343D4B),
    chartBar: const Color(0xFF2A57C4),
    chartBarHighlight: const Color(0xFF6690E8),
    navActive: const Color(0xFF6690E8),
    navInactive: const Color(0xFFA8B0BD),
    navBackground: const Color(0xFF141A24),
  );

  @override
  AppColors copyWith({
    Color? background,
    Color? surface,
    Color? surfaceRaised,
    Color? surfaceSunken,
    Color? border,
    Color? borderStrong,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? textInverse,
    Color? accent,
    Color? accentHover,
    Color? accentSubtle,
    Color? onAccent,
    Color? verified,
    Color? verifiedSubtle,
    Color? pending,
    Color? pendingSubtle,
    Color? destructive,
    Color? destructiveSubtle,
    Color? rating,
    Color? sponsored,
    Color? whatsapp,
    Color? onWhatsapp,
    Color? amber,
    Color? onAmber,
    Color? scrim,
    Color? onScrim,
    Color? thumbnail,
    Color? thumbnailBorder,
    Color? chartBar,
    Color? chartBarHighlight,
    Color? navActive,
    Color? navInactive,
    Color? navBackground,
  }) => AppColors(
    background: background ?? this.background,
    surface: surface ?? this.surface,
    surfaceRaised: surfaceRaised ?? this.surfaceRaised,
    surfaceSunken: surfaceSunken ?? this.surfaceSunken,
    border: border ?? this.border,
    borderStrong: borderStrong ?? this.borderStrong,
    textPrimary: textPrimary ?? this.textPrimary,
    textSecondary: textSecondary ?? this.textSecondary,
    textMuted: textMuted ?? this.textMuted,
    textInverse: textInverse ?? this.textInverse,
    accent: accent ?? this.accent,
    accentHover: accentHover ?? this.accentHover,
    accentSubtle: accentSubtle ?? this.accentSubtle,
    onAccent: onAccent ?? this.onAccent,
    verified: verified ?? this.verified,
    verifiedSubtle: verifiedSubtle ?? this.verifiedSubtle,
    pending: pending ?? this.pending,
    pendingSubtle: pendingSubtle ?? this.pendingSubtle,
    destructive: destructive ?? this.destructive,
    destructiveSubtle: destructiveSubtle ?? this.destructiveSubtle,
    rating: rating ?? this.rating,
    sponsored: sponsored ?? this.sponsored,
    whatsapp: whatsapp ?? this.whatsapp,
    onWhatsapp: onWhatsapp ?? this.onWhatsapp,
    amber: amber ?? this.amber,
    onAmber: onAmber ?? this.onAmber,
    scrim: scrim ?? this.scrim,
    onScrim: onScrim ?? this.onScrim,
    thumbnail: thumbnail ?? this.thumbnail,
    thumbnailBorder: thumbnailBorder ?? this.thumbnailBorder,
    chartBar: chartBar ?? this.chartBar,
    chartBarHighlight: chartBarHighlight ?? this.chartBarHighlight,
    navActive: navActive ?? this.navActive,
    navInactive: navInactive ?? this.navInactive,
    navBackground: navBackground ?? this.navBackground,
  );

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      background: Color.lerp(this.background, other.background, t)!,
      surface: Color.lerp(this.surface, other.surface, t)!,
      surfaceRaised: Color.lerp(this.surfaceRaised, other.surfaceRaised, t)!,
      surfaceSunken: Color.lerp(this.surfaceSunken, other.surfaceSunken, t)!,
      border: Color.lerp(this.border, other.border, t)!,
      borderStrong: Color.lerp(this.borderStrong, other.borderStrong, t)!,
      textPrimary: Color.lerp(this.textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(this.textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(this.textMuted, other.textMuted, t)!,
      textInverse: Color.lerp(this.textInverse, other.textInverse, t)!,
      accent: Color.lerp(this.accent, other.accent, t)!,
      accentHover: Color.lerp(this.accentHover, other.accentHover, t)!,
      accentSubtle: Color.lerp(this.accentSubtle, other.accentSubtle, t)!,
      onAccent: Color.lerp(this.onAccent, other.onAccent, t)!,
      verified: Color.lerp(this.verified, other.verified, t)!,
      verifiedSubtle: Color.lerp(this.verifiedSubtle, other.verifiedSubtle, t)!,
      pending: Color.lerp(this.pending, other.pending, t)!,
      pendingSubtle: Color.lerp(this.pendingSubtle, other.pendingSubtle, t)!,
      destructive: Color.lerp(this.destructive, other.destructive, t)!,
      destructiveSubtle: Color.lerp(
        this.destructiveSubtle,
        other.destructiveSubtle,
        t,
      )!,
      rating: Color.lerp(this.rating, other.rating, t)!,
      sponsored: Color.lerp(this.sponsored, other.sponsored, t)!,
      whatsapp: Color.lerp(this.whatsapp, other.whatsapp, t)!,
      onWhatsapp: Color.lerp(this.onWhatsapp, other.onWhatsapp, t)!,
      amber: Color.lerp(this.amber, other.amber, t)!,
      onAmber: Color.lerp(this.onAmber, other.onAmber, t)!,
      scrim: Color.lerp(this.scrim, other.scrim, t)!,
      onScrim: Color.lerp(this.onScrim, other.onScrim, t)!,
      thumbnail: Color.lerp(this.thumbnail, other.thumbnail, t)!,
      thumbnailBorder: Color.lerp(
        this.thumbnailBorder,
        other.thumbnailBorder,
        t,
      )!,
      chartBar: Color.lerp(this.chartBar, other.chartBar, t)!,
      chartBarHighlight: Color.lerp(
        this.chartBarHighlight,
        other.chartBarHighlight,
        t,
      )!,
      navActive: Color.lerp(this.navActive, other.navActive, t)!,
      navInactive: Color.lerp(this.navInactive, other.navInactive, t)!,
      navBackground: Color.lerp(this.navBackground, other.navBackground, t)!,
    );
  }
}

extension AppColorsX on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
