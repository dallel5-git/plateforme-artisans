import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Luminance relative WCAG 2.x — https://www.w3.org/TR/WCAG21/#dfn-relative-luminance
/// `Color.r/g/b` sont déjà des `double` normalisés en [0, 1] (espace sRGB).
double relativeLuminance(Color color) {
  double linearize(double channel) {
    return channel <= 0.04045
        ? channel / 12.92
        : math.pow((channel + 0.055) / 1.055, 2.4).toDouble();
  }

  return 0.2126 * linearize(color.r) +
      0.7152 * linearize(color.g) +
      0.0722 * linearize(color.b);
}

/// Ratio de contraste WCAG entre deux couleurs (symétrique, toujours ≥ 1).
double contrastRatio(Color a, Color b) {
  final lumA = relativeLuminance(a);
  final lumB = relativeLuminance(b);
  final lighter = lumA > lumB ? lumA : lumB;
  final darker = lumA > lumB ? lumB : lumA;
  return (lighter + 0.05) / (darker + 0.05);
}
