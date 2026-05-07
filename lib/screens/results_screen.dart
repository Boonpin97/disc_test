import 'package:flutter/material.dart';

import '../data/word_groups.dart';
import '../models/answer.dart';
import '../data/disc_profiles.dart';
import '../models/disc_result.dart';
import '../models/word.dart';
import '../services/export_service.dart';
import '../services/html_report_builder.dart';
import '../services/pattern_matcher.dart';
import '../services/pdf_report_builder.dart';
import '../widgets/disc_bar_chart.dart';
import '../widgets/disc_colors.dart';
import '../widgets/disc_pattern_card.dart';
import '../widgets/disc_score_plot.dart';

class ResultsScreen extends StatelessWidget {
  final DiscResult result;
  final List<Answer> answers;

  const ResultsScreen({
    super.key,
    required this.result,
    required this.answers,
  });

  void _download(BuildContext context) {
    final now = DateTime.now();
    final baseFilename = 'disc-result-'
        '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';
    final html = buildHtmlReport(
      result,
      groups: wordGroups,
      answers: answers,
      generatedAt: now,
    );

    try {
      downloadHtml(html, '$baseFilename.html');
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Download not supported here: $error')),
      );
    }
  }

  Future<void> _downloadPdf(BuildContext context) async {
    final now = DateTime.now();
    final baseFilename = 'disc-result-'
        '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';
    final pdf = await buildPdfReport(
      result,
      groups: wordGroups,
      answers: answers,
      generatedAt: now,
    );

    try {
      downloadPdf(pdf, '$baseFilename.pdf');
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF export not supported here: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dominant = result.dominantComposite;
    final profile = discProfiles[dominant]!;
    final dominantColor = discColors[dominant]!;
    final pattern = matchPattern(result.composite);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Results'),
        actions: [
          PopupMenuButton<_ExportFormat>(
            tooltip: 'Export Results',
            icon: const Icon(Icons.download),
            onSelected: (format) {
              if (format == _ExportFormat.html) {
                _download(context);
              } else {
                _downloadPdf(context);
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: _ExportFormat.html,
                child: Text('Download Results (HTML)'),
              ),
              PopupMenuItem(
                value: _ExportFormat.pdf,
                child: Text('Download Results (PDF)'),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _DominantHeader(
                profile: profile,
                color: dominantColor,
                patternName: pattern.name,
              ),
              const SizedBox(height: 24),
              Text('Scores', style: theme.textTheme.titleLarge),
              const SizedBox(height: 12),
              _ScoresTable(result: result),
              const SizedBox(height: 24),
              Text('Composite chart', style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(
                'How others most likely see you (MOST - LEAST). Range: -24 to +24.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: DiscBarChart(composite: result.composite),
                ),
              ),
              const SizedBox(height: 24),
              Text('Plot your scores', style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(
                'PDF-style line plots for the MOST, LEAST, and COMPOSITE columns of the Scoring Summary.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              _ScorePlots(result: result),
              const SizedBox(height: 24),
              _SanityCheckCard(result: result),
              const SizedBox(height: 24),
              Text('What this means', style: theme.textTheme.titleLarge),
              const SizedBox(height: 12),
              const _ConceptsCard(),
              const SizedBox(height: 24),
              _ProfileMetaCard(profile: profile),
              const SizedBox(height: 24),
              Text('Overview', style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(profile.overview, style: theme.textTheme.bodyLarge),
              const SizedBox(height: 24),
              _StrengthsWeaknesses(profile: profile),
              const SizedBox(height: 32),
              Text(
                'Your representative DISC pattern',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'The COMPOSITE shape that most closely matches one of the 21 representative patterns from the Personal DiSCernment Inventory.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              DiscPatternCard(pattern: pattern),
              const SizedBox(height: 32),
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    FilledButton.icon(
                      onPressed: () => _download(context),
                      icon: const Icon(Icons.download),
                      label: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text('Download as HTML'),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => _downloadPdf(context),
                      icon: const Icon(Icons.picture_as_pdf_outlined),
                      label: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text('Download as PDF'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton.icon(
                  onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Take the test again'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _ExportFormat { html, pdf }

class _ScorePlots extends StatelessWidget {
  final DiscResult result;

  const _ScorePlots({required this.result});

  @override
  Widget build(BuildContext context) {
    final plots = [
      DiscScorePlot(
        title: 'MOST',
        scores: result.most,
        minValue: 0,
        maxValue: 24,
      ),
      DiscScorePlot(
        title: 'LEAST',
        scores: result.least,
        minValue: 0,
        maxValue: 24,
      ),
      DiscScorePlot(
        title: 'COMPOSITE',
        scores: result.composite,
        minValue: -24,
        maxValue: 24,
        showZeroLine: true,
      ),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final stacked = constraints.maxWidth < 680;
            if (stacked) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < plots.length; i++) ...[
                    plots[i],
                    if (i < plots.length - 1) const SizedBox(height: 20),
                  ],
                ],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < plots.length; i++) ...[
                  Expanded(child: plots[i]),
                  if (i < plots.length - 1) const SizedBox(width: 16),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _DominantHeader extends StatelessWidget {
  final DiscProfile profile;
  final Color color;
  final String patternName;

  const _DominantHeader({
    required this.profile,
    required this.color,
    required this.patternName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: color.withValues(alpha: 0.35)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(18),
              ),
              alignment: Alignment.center,
              child: Text(
                profile.category.letter,
                style: theme.textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your dominant style',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${profile.category.fullName} (${profile.category.letter}) — The $patternName',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    profile.otherTerms,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoresTable extends StatelessWidget {
  final DiscResult result;

  const _ScoresTable({required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    TableRow header() => TableRow(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
          ),
          children: [
            const _Cell(''),
            for (final category in DiscCategory.values)
              _Cell(category.letter, color: discColors[category], bold: true),
          ],
        );

    TableRow row(
      String label,
      Map<DiscCategory, int> values, {
      bool emphasize = false,
    }) {
      return TableRow(
        children: [
          _Cell(label, bold: true),
          for (final category in DiscCategory.values)
            _Cell(values[category].toString(), bold: emphasize),
        ],
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Table(
          border: TableBorder.symmetric(
            inside: BorderSide(
              color: theme.dividerColor.withValues(alpha: 0.55),
            ),
          ),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            header(),
            row('MOST', result.most),
            row('LEAST', result.least),
            row('COMPOSITE', result.composite, emphasize: true),
          ],
        ),
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  final String text;
  final Color? color;
  final bool bold;

  const _Cell(this.text, {this.color, this.bold = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: color,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
    );
  }
}

class _SanityCheckCard extends StatelessWidget {
  final DiscResult result;

  const _SanityCheckCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mostSum = result.most.values.fold<int>(0, (sum, item) => sum + item);
    final leastSum = result.least.values.fold<int>(0, (sum, item) => sum + item);
    final compositeSum =
        result.composite.values.fold<int>(0, (sum, item) => sum + item);
    final isValid = mostSum == 24 && leastSum == 24 && compositeSum == 0;

    return Card(
      color: isValid
          ? theme.colorScheme.secondaryContainer.withValues(alpha: 0.45)
          : theme.colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              isValid ? Icons.verified_outlined : Icons.error_outline,
              color: isValid
                  ? theme.colorScheme.secondary
                  : theme.colorScheme.onErrorContainer,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Sanity check: MOST total = $mostSum, LEAST total = $leastSum, COMPOSITE total = $compositeSum.',
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConceptsCard extends StatelessWidget {
  const _ConceptsCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _ConceptRow(
              label: 'MOST - Projected Concept',
              text: 'How you want others to see you, sometimes called the mask.',
            ),
            Divider(),
            _ConceptRow(
              label: 'LEAST - Private Concept',
              text:
                  'Your basic, deep-down behaviour pattern, often most visible when relaxed or under pressure.',
            ),
            Divider(),
            _ConceptRow(
              label: 'COMPOSITE - Public Concept',
              text:
                  'The net effect of MOST minus LEAST, and the clearest indicator of how others generally perceive you.',
            ),
          ],
        ),
      ),
    );
  }
}

class _ConceptRow extends StatelessWidget {
  final String label;
  final String text;

  const _ConceptRow({required this.label, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.titleSmall),
          const SizedBox(height: 4),
          Text(text, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _ProfileMetaCard extends StatelessWidget {
  final DiscProfile profile;

  const _ProfileMetaCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entries = <(String, String)>[
      ('Other terms', profile.otherTerms),
      ('Emphasis', profile.emphasis),
      ('Key to motivation', profile.motivation),
      ('Basic intent', profile.basicIntent),
      ('Value to others', profile.valueToOthers),
      ('Major strengths', profile.majorStrengths),
      ('Motivated by', profile.motivatedBy),
      ('Using time', profile.usingTime),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final entry in entries)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final stacked = constraints.maxWidth < 520;
                    if (stacked) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.$1,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(entry.$2, style: theme.textTheme.bodyMedium),
                        ],
                      );
                    }

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 170,
                          child: Text(
                            entry.$1,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(entry.$2, style: theme.textTheme.bodyMedium),
                        ),
                      ],
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StrengthsWeaknesses extends StatelessWidget {
  final DiscProfile profile;

  const _StrengthsWeaknesses({required this.profile});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final stacked = constraints.maxWidth < 680;
        final children = [
          Expanded(
            child: _ListCard(
              title: 'Probable strengths',
              color: theme.colorScheme.primary,
              items: profile.strengths,
              icon: Icons.thumb_up_outlined,
            ),
          ),
          SizedBox(width: stacked ? 0 : 16, height: stacked ? 16 : 0),
          Expanded(
            child: _ListCard(
              title: 'Possible weaknesses',
              color: theme.colorScheme.error,
              items: profile.weaknesses,
              icon: Icons.warning_amber_outlined,
            ),
          ),
        ];

        return stacked
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children,
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              );
      },
    );
  }
}

class _ListCard extends StatelessWidget {
  final String title;
  final Color color;
  final List<String> items;
  final IconData icon;

  const _ListCard({
    required this.title,
    required this.color,
    required this.items,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(title, style: theme.textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 12),
            for (final item in items)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 6, right: 8),
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(item, style: theme.textTheme.bodyMedium),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
