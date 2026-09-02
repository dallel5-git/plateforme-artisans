// ⚠️ FICHIER GÉNÉRÉ — NE PAS ÉDITER À LA MAIN.
// Source : packages/design-tokens/tokens.json
// Régénérer : pnpm tokens:build
// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

abstract final class AppSpacing {
  static const double s0 = 0.0;
  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double s2xl = 32.0;
  static const double s3xl = 48.0;
  static const double s4xl = 64.0;
  static const double s5xl = 96.0;
}

abstract final class AppRadius {
  static const Radius none = Radius.circular(0.0);
  static const Radius sm = Radius.circular(6.0);
  static const Radius md = Radius.circular(10.0);
  static const Radius lg = Radius.circular(14.0);
  static const Radius xl = Radius.circular(20.0);
  static const Radius pill = Radius.circular(999.0);
}

abstract final class AppLayout {
  /// Cible tactile minimale — accessibilité et usage sur chantier (gants, écran sale).
  static const double touchTarget = 48.0;
  static const double containerMax = 1200.0;
  static const double breakpointSm = 480.0;
  static const double breakpointMd = 768.0;
  static const double breakpointLg = 1024.0;
  static const double breakpointXl = 1280.0;
}

abstract final class AppIconSize {
  static const double xs = 12.0;
  static const double sm = 16.0;
  static const double md = 20.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
}
