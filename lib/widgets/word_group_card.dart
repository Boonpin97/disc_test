import 'package:flutter/material.dart';

import '../models/answer.dart';
import '../models/word_group.dart';

class WordGroupCard extends StatelessWidget {
  final int groupIndex;
  final WordGroup group;
  final Answer answer;
  final bool showDefinitions;
  final VoidCallback onToggleDefinitions;
  final ValueChanged<Answer> onAnswerChanged;

  const WordGroupCard({
    super.key,
    required this.groupIndex,
    required this.group,
    required this.answer,
    required this.showDefinitions,
    required this.onToggleDefinitions,
    required this.onAnswerChanged,
  });

  void _selectMost(int index) {
    final newLeast = answer.leastIndex == index ? null : answer.leastIndex;
    onAnswerChanged(Answer(mostIndex: index, leastIndex: newLeast));
  }

  void _selectLeast(int index) {
    final newMost = answer.mostIndex == index ? null : answer.mostIndex;
    onAnswerChanged(Answer(mostIndex: newMost, leastIndex: index));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isComplete = answer.isComplete;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: isComplete
              ? theme.colorScheme.primary.withValues(alpha: 0.35)
              : theme.colorScheme.outlineVariant,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${groupIndex + 1}',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Question ${groupIndex + 1}',
                  style: theme.textTheme.titleMedium,
                ),
                const Spacer(),
                if (isComplete)
                  Icon(
                    Icons.check_circle,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                onPressed: onToggleDefinitions,
                icon: Icon(
                  showDefinitions ? Icons.visibility_off_outlined : Icons.info_outline,
                  size: 18,
                ),
                label: Text(
                  showDefinitions ? 'Hide definitions' : 'Show definitions',
                ),
              ),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                children: [
                  const Expanded(child: SizedBox.shrink()),
                  SizedBox(
                    width: 64,
                    child: Text(
                      'MOST',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 64,
                    child: Text(
                      'LEAST',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 12),
            for (var i = 0; i < group.words.length; i++)
              _WordRow(
                word: group.words[i].text,
                definition: group.words[i].definition,
                showDefinition: showDefinitions,
                isMost: answer.mostIndex == i,
                isLeast: answer.leastIndex == i,
                onMost: () => _selectMost(i),
                onLeast: () => _selectLeast(i),
              ),
          ],
        ),
      ),
    );
  }
}

class _WordRow extends StatelessWidget {
  final String word;
  final String definition;
  final bool showDefinition;
  final bool isMost;
  final bool isLeast;
  final VoidCallback onMost;
  final VoidCallback onLeast;

  const _WordRow({
    required this.word,
    required this.definition,
    required this.showDefinition,
    required this.isMost,
    required this.isLeast,
    required this.onMost,
    required this.onLeast,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    word,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (showDefinition)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        definition,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          height: 1.35,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 64,
            child: Center(
              child: _ChoiceButton(
                selected: isMost,
                label: 'M',
                color: theme.colorScheme.primary,
                onTap: onMost,
              ),
            ),
          ),
          SizedBox(
            width: 64,
            child: Center(
              child: _ChoiceButton(
                selected: isLeast,
                label: 'L',
                color: theme.colorScheme.tertiary,
                onTap: onLeast,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  final bool selected;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ChoiceButton({
    required this.selected,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selected ? color : Colors.transparent,
          border: Border.all(
            color: selected ? color : theme.dividerColor,
            width: 2,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.24),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: selected ? Colors.white : color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
