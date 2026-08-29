import 'package:flutter/material.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/features/dashboard/data/dashboard_repository.dart';

/// Courbe des 30 derniers jours (vues + contacts), dessinée à la main
/// (`CustomPainter`) — aucune dépendance de charting ajoutée, décision FM-12
/// consignée dans `backlog/DOING.md`. Volontairement sans axes ni tooltips :
/// c'est un aperçu de tendance, pas un outil d'analyse fine (hors périmètre
/// FM-12, cf. issue #41).
class DashboardTrendChart extends StatelessWidget {
  const DashboardTrendChart({
    required this.series,
    super.key,
    this.height = 140,
  });

  final List<ProviderStatsSeriesPoint> series;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _TrendPainter(
          views: series.map((point) => point.profileViews).toList(),
          contacts: series.map((point) => point.contacts).toList(),
          viewsColor: colors.accent,
          contactsColor: colors.whatsapp,
          gridColor: colors.border,
          isRtl: isRtl,
        ),
      ),
    );
  }
}

class _TrendPainter extends CustomPainter {
  _TrendPainter({
    required this.views,
    required this.contacts,
    required this.viewsColor,
    required this.contactsColor,
    required this.gridColor,
    required this.isRtl,
  });

  final List<int> views;
  final List<int> contacts;
  final Color viewsColor;
  final Color contactsColor;
  final Color gridColor;
  final bool isRtl;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(0, size.height - 1),
      Offset(size.width, size.height - 1),
      gridPaint,
    );

    if (views.isEmpty) return;

    final maxValue = [
      ...views,
      ...contacts,
    ].fold(0, (max, value) => value > max ? value : max);

    _drawSeries(canvas, size, views, viewsColor, maxValue);
    _drawSeries(canvas, size, contacts, contactsColor, maxValue);
  }

  void _drawSeries(
    Canvas canvas,
    Size size,
    List<int> data,
    Color color,
    int maxValue,
  ) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // maxValue == 0 : série toute à zéro, on trace une ligne plate au sol
    // plutôt que de diviser par zéro.
    final path = Path();
    final stepX = data.length > 1 ? size.width / (data.length - 1) : 0.0;

    for (var i = 0; i < data.length; i++) {
      final ratio = maxValue == 0 ? 0.0 : data[i] / maxValue;
      final x = isRtl ? size.width - (i * stepX) : i * stepX;
      final y = size.height - (ratio * (size.height - 4)) - 2;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_TrendPainter oldDelegate) =>
      oldDelegate.views != views ||
      oldDelegate.contacts != contacts ||
      oldDelegate.isRtl != isRtl;
}
