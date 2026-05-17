import 'package:flutter/material.dart';

import 'questionnaire_screen.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primaryContainer.withValues(alpha: 0.85),
              theme.colorScheme.surface,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withValues(alpha: 0.94),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: theme.colorScheme.outlineVariant.withValues(alpha: 0.75),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DISC Personality Test',
                        style: theme.textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Personal DiSCernment Inventory',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Divider(
                        color:
                            theme.colorScheme.outlineVariant.withValues(alpha: 0.7),
                      ),
                      const SizedBox(height: 24),
                      Text('How it works', style: theme.textTheme.titleLarge),
                      const SizedBox(height: 12),
                      Text(
                        'You will see 24 questions with four words each. In every question, choose the one word that is MOST like you and the one that is LEAST like you. There are no right or wrong answers - go with your first instinct.',
                        style: theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 16),
                      const _Bullet(
                        icon: Icons.check_circle_outline,
                        text: 'Pick exactly one MOST and one LEAST per question',
                      ),
                      const _Bullet(
                        icon: Icons.info_outline,
                        text: 'Definitions are shown by default, and you can hide them if needed',
                      ),
                      const SizedBox(height: 28),
                      Divider(
                        color:
                            theme.colorScheme.outlineVariant.withValues(alpha: 0.7),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: FilledButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const QuestionnaireScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.play_arrow),
                          label: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Text('Begin'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Takes about 8-10 minutes.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Bullet({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
