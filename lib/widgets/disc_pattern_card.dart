import 'package:flutter/material.dart';

import '../data/disc_patterns.dart';
import '../models/word.dart';
import 'disc_colors.dart';

/// Renders the matched representative DISC pattern with its name and the three
/// PDF text blocks: Outstanding Traits, Basic Desires & Internal Drive, and
/// Need for Possible Improvement.
class DiscPatternCard extends StatelessWidget {
  final DiscPattern pattern;

  const DiscPatternCard({super.key, required this.pattern});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = pattern.quadrant != null
        ? discColors[pattern.quadrant]!
        : theme.colorScheme.primary;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: accent.withValues(alpha: 0.35)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${pattern.id}',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Representative pattern',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        pattern.name,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (pattern.quadrant != null)
                        Text(
                          '${pattern.quadrant!.fullName} quadrant (${pattern.quadrant!.letter})',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _Section(
              title: 'Outstanding Traits',
              body: pattern.outstandingTraits,
            ),
            const SizedBox(height: 14),
            _Section(
              title: 'Basic Desires and Internal Drive',
              body: pattern.internalDrive,
            ),
            const SizedBox(height: 14),
            _Section(
              title: 'Need for Possible Improvement',
              body: pattern.improvement,
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String body;

  const _Section({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(body, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}
