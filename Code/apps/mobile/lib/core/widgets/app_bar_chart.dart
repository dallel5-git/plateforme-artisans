import 'package:flutter/material.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_text.dart';

/// Histogramme générique du design system (FM-37c, issue #234) :
/// N barres verticales avec une barre optionnellement mise en surbrillance
/// (typiquement le jour courant).
///
/// Aucune dépendance de charting externe — barres dessinées via
/// [CustomPainter], libellés de l'axe X via des widgets [Text] dans un [Row]
/// pour l'accessibilité et le respect natif du sens de lecture LTR / RTL.
///
/// Paramètres :
/// - [values] : hauteurs relatives des barres (entiers positifs ou nuls).
/// - [labels] : libellés de l'axe X (même longueur que [values]).
/// - [highlightIndex] : index de la barre mise en surbrillance (nullable).
/// - [barColor] : couleur des barres non surlignées.
/// - [highlightColor] : couleur de la barre surlignée (défaut = [barColor]).
/// - [height] : hauteur totale du widget (barres + libellés).
class AppBarChart extends StatelessWidget {
  const AppBarChart({
    required this.values,
    required this.labels,
    super.key,
    this.highlightIndex,
    this.barColor,
    this.highlightColor,
    this.height = 140,
  });

  final List<int> values;
  final List<String> labels;
  final int? highlightIndex;
  final Color? barColor;
  final Color? highlightColor;
  final double height;

  @override
  Widget build(BuildContext context) {
    assert(
      values.length == labels.length,
      'AppBarChart: values and labels must have the same length',
    );
    final colors = context.colors;
    final locale = Localizations.localeOf(context);
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final effectiveBarColor = barColor ?? colors.accentSubtle;
    final effectiveHighlightColor = highlightColor ?? colors.accent;

    return SizedBox(
      height: height,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: CustomPaint(
              painter: _BarChartPainter(
                values: values,
                highlightIndex: highlightIndex,
                barColor: effectiveBarColor,
                highlightColor: effectiveHighlightColor,
                gridColor: colors.border,
                isRtl: isRtl,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              for (final label in labels)
                Expanded(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: AppText.caption(locale).copyWith(
                      color: colors.textMuted,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BarChartPainter extends CustomPainter {
  _BarChartPainter({
    required this.values,
    required this.highlightIndex,
    required this.barColor,
    required this.highlightColor,
    required this.gridColor,
    required this.isRtl,
  });

  final List<int> values;
  final int? highlightIndex;
  final Color barColor;
  final Color highlightColor;
  final Color gridColor;
  final bool isRtl;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    final drawHeight = size.height;
    final maxValue = values.fold(0, (m, v) => v > m ? v : m);
    final n = values.length;
    const barPaddingRatio = 0.3; // 30 % de l'espace entre barres
    final slotWidth = size.width / n;
    final barWidth = slotWidth * (1 - barPaddingRatio);
    final halfPad = (slotWidth - barWidth) / 2;

    // Ligne de grille en bas de la zone des barres.
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(0, drawHeight),
      Offset(size.width, drawHeight),
      gridPaint,
    );

    for (var i = 0; i < n; i++) {
      final isHighlight = i == highlightIndex;
      final paint = Paint()
        ..color = isHighlight ? highlightColor : barColor
        ..style = PaintingStyle.fill;

      final barHeightRatio = maxValue == 0 ? 0.0 : values[i] / maxValue;
      final barPx = maxValue == 0
          ? 0.0
          : values[i] == 0
          ? 0.0
          : (barHeightRatio * (drawHeight - 8)) + 4;

      final slotIdx = isRtl ? (n - 1 - i) : i;
      final left = slotIdx * slotWidth + halfPad;
      final top = drawHeight - barPx;
      final rect = RRect.fromRectAndCorners(
        Rect.fromLTWH(left, top, barWidth, barPx),
        topLeft: const Radius.circular(4),
        topRight: const Radius.circular(4),
      );
      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(_BarChartPainter old) =>
      old.values != values ||
      old.highlightIndex != highlightIndex ||
      old.barColor != barColor ||
      old.highlightColor != highlightColor ||
      old.gridColor != gridColor ||
      old.isRtl != isRtl;
}
