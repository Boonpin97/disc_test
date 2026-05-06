import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final int answered;
  final int total;

  const ProgressBar({super.key, required this.answered, required this.total});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fraction = total == 0 ? 0.0 : answered / total;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$answered / $total answered',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            if (answered == total) const SizedBox(width: 10),
            if (answered == total)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: theme.colorScheme.primary, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    'Ready to submit',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
          ],
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: fraction,
              minHeight: 6,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
            ),
          ),
        ),
      ],
    );
  }
}
