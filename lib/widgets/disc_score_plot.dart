import 'package:flutter/material.dart';

import '../models/word.dart';
import 'disc_colors.dart';

/// A PDF-faithful single graph for plotting DISC scores. Used three times on
/// the results screen — for the MOST, LEAST, and COMPOSITE columns of the
/// Scoring Summary Box.
class DiscScorePlot extends StatelessWidget {
  final String title;
  final Map<DiscCategory, int> scores;
  final int minValue;
  final int maxValue;
  final bool showZeroLine;

  const DiscScorePlot({
    super.key,
    required this.title,
    required this.scores,
    required this.minValue,
    required this.maxValue,
    this.showZeroLine = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return CustomPaint(
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: _PlotPainter(
                  scores: scores,
                  minValue: minValue,
                  maxValue: maxValue,
                  showZeroLine: showZeroLine,
                  axisColor: theme.dividerColor,
                  textColor: theme.colorScheme.onSurfaceVariant,
                  lineColor: theme.colorScheme.onSurface.withValues(alpha: 0.45),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (final c in DiscCategory.values)
              Column(
                children: [
                  Text(
                    c.letter,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: discColors[c],
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    _formatValue(scores[c]!),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }

  String _formatValue(int v) {
    if (showZeroLine && v > 0) return '+$v';
    return '$v';
  }
}

class _PlotPainter extends CustomPainter {
  final Map<DiscCategory, int> scores;
  final int minValue;
  final int maxValue;
  final bool showZeroLine;
  final Color axisColor;
  final Color textColor;
  final Color lineColor;

  _PlotPainter({
    required this.scores,
    required this.minValue,
    required this.maxValue,
    required this.showZeroLine,
    required this.axisColor,
    required this.textColor,
    required this.lineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const double leftPad = 32;
    const double rightPad = 8;
    const double topPad = 6;
    const double bottomPad = 6;
    final plotLeft = leftPad;
    final plotRight = size.width - rightPad;
    final plotTop = topPad;
    final plotBottom = size.height - bottomPad;
    final plotWidth = plotRight - plotLeft;
    final plotHeight = plotBottom - plotTop;
    final range = (maxValue - minValue).toDouble();

    double yFor(num value) {
      final clamped = value.clamp(minValue, maxValue).toDouble();
      final normalised = (clamped - minValue) / range;
      return plotBottom - normalised * plotHeight;
    }

    final framePaint = Paint()
      ..color = axisColor.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawRect(
      Rect.fromLTRB(plotLeft, plotTop, plotRight, plotBottom),
      framePaint,
    );

    final tickPaint = Paint()
      ..color = axisColor.withValues(alpha: 0.25)
      ..strokeWidth = 1;

    final tickLabelStyle = TextStyle(color: textColor, fontSize: 10);

    final tickStep = _chooseTickStep(range);
    for (var v = minValue; v <= maxValue; v += tickStep) {
      final y = yFor(v);
      canvas.drawLine(Offset(plotLeft, y), Offset(plotRight, y), tickPaint);

      final label = TextPainter(
        text: TextSpan(
          text: showZeroLine && v > 0 ? '+$v' : '$v',
          style: tickLabelStyle,
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: leftPad - 4);
      label.paint(
        canvas,
        Offset(plotLeft - label.width - 4, y - label.height / 2),
      );
    }

    if (showZeroLine && minValue < 0 && maxValue > 0) {
      final zeroY = yFor(0);
      final zeroPaint = Paint()
        ..color = axisColor
        ..strokeWidth = 1.5;
      canvas.drawLine(Offset(plotLeft, zeroY), Offset(plotRight, zeroY), zeroPaint);
    }

    final categories = DiscCategory.values;
    final columnSpacing = plotWidth / categories.length;
    final dotXs = <double>[
      for (var i = 0; i < categories.length; i++)
        plotLeft + columnSpacing * (i + 0.5),
    ];

    for (final x in dotXs) {
      final colPaint = Paint()
        ..color = axisColor.withValues(alpha: 0.35)
        ..strokeWidth = 1;
      canvas.drawLine(Offset(x, plotTop), Offset(x, plotBottom), colPaint);
    }

    final dotPoints = <Offset>[
      for (var i = 0; i < categories.length; i++)
        Offset(dotXs[i], yFor(scores[categories[i]]!)),
    ];

    final connector = Paint()
      ..color = lineColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final path = Path()..moveTo(dotPoints.first.dx, dotPoints.first.dy);
    for (var i = 1; i < dotPoints.length; i++) {
      path.lineTo(dotPoints[i].dx, dotPoints[i].dy);
    }
    canvas.drawPath(path, connector);

    for (var i = 0; i < categories.length; i++) {
      final color = discColors[categories[i]]!;
      canvas.drawCircle(dotPoints[i], 6.5, Paint()..color = color);
      canvas.drawCircle(
        dotPoints[i],
        6.5,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }
  }

  int _chooseTickStep(double range) {
    if (range <= 12) return 2;
    if (range <= 30) return 4;
    return 8;
  }

  @override
  bool shouldRepaint(covariant _PlotPainter old) =>
      old.scores != scores ||
      old.minValue != minValue ||
      old.maxValue != maxValue ||
      old.showZeroLine != showZeroLine;
}
