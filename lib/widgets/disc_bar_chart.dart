import 'package:flutter/material.dart';
import '../models/word.dart';
import 'disc_colors.dart';

/// Renders a vertical bar chart of composite scores in the range -24..+24,
/// with a centered zero line.
class DiscBarChart extends StatelessWidget {
  final Map<DiscCategory, int> composite;
  final double height;

  const DiscBarChart({
    super.key,
    required this.composite,
    this.height = 240,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final c in DiscCategory.values)
            Expanded(
              child: _BarColumn(
                category: c,
                value: composite[c]!,
                color: discColors[c]!,
                textTheme: theme.textTheme,
              ),
            ),
        ],
      ),
    );
  }
}

class _BarColumn extends StatelessWidget {
  final DiscCategory category;
  final int value;
  final Color color;
  final TextTheme textTheme;

  const _BarColumn({
    required this.category,
    required this.value,
    required this.color,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return CustomPaint(
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: _BarPainter(value: value, color: color),
              );
            },
          ),
        ),
        const SizedBox(height: 6),
        Text(
          category.letter,
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        Text(
          value > 0 ? '+$value' : '$value',
          style: textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _BarPainter extends CustomPainter {
  final int value;
  final Color color;
  static const double _maxAbs = 24;

  _BarPainter({required this.value, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final trackPaint = Paint()..color = const Color(0xFFEEEEEE);
    final centerY = size.height / 2;

    // Background track.
    final trackRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.25, 0, size.width * 0.5, size.height),
      const Radius.circular(4),
    );
    canvas.drawRRect(trackRect, trackPaint);

    // Zero line.
    final zeroLinePaint = Paint()
      ..color = const Color(0xFF999999)
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(size.width * 0.15, centerY),
      Offset(size.width * 0.85, centerY),
      zeroLinePaint,
    );

    // Bar.
    if (value != 0) {
      final magnitude = (value.abs() / _maxAbs).clamp(0.0, 1.0);
      final barHeight = (size.height / 2) * magnitude;
      final top = value > 0 ? centerY - barHeight : centerY;
      final barRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.25, top, size.width * 0.5, barHeight),
        const Radius.circular(3),
      );
      canvas.drawRRect(barRect, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant _BarPainter old) =>
      old.value != value || old.color != color;
}
