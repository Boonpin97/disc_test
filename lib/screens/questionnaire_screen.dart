import 'package:flutter/material.dart';

import '../data/word_groups.dart';
import '../models/answer.dart';
import '../services/scoring_service.dart';
import '../widgets/progress_bar.dart';
import '../widgets/word_group_card.dart';
import 'results_screen.dart';

class QuestionnaireScreen extends StatefulWidget {
  const QuestionnaireScreen({super.key});

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  late final List<Answer> _answers =
      List.generate(wordGroups.length, (_) => const Answer());
  late final List<GlobalKey> _cardKeys =
      List.generate(wordGroups.length, (_) => GlobalKey());
  final Set<int> _definitionIndexes = Set<int>.from(
    Iterable<int>.generate(wordGroups.length),
  );

  int get _answeredCount => _answers.where((answer) => answer.isComplete).length;
  bool get _allAnswered => _answeredCount == wordGroups.length;

  void _onAnswerChanged(int index, Answer answer) {
    setState(() {
      _answers[index] = answer;
    });
  }

  void _toggleDefinitions(int index) {
    setState(() {
      if (_definitionIndexes.contains(index)) {
        _definitionIndexes.remove(index);
      } else {
        _definitionIndexes.add(index);
      }
    });
  }

  void _submit() {
    if (!_allAnswered) {
      _scrollToFirstUnanswered();
      return;
    }

    final result = scoreAnswers(wordGroups, _answers);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ResultsScreen(
          result: result,
          answers: List<Answer>.from(_answers),
        ),
      ),
    );
  }

  void _scrollToFirstUnanswered() {
    final first = _answers.indexWhere((answer) => !answer.isComplete);
    if (first < 0) {
      return;
    }

    final targetContext = _cardKeys[first].currentContext;
    if (targetContext != null) {
      Scrollable.ensureVisible(
        targetContext,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
        alignment: 0.08,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 204,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primaryContainer,
                      theme.colorScheme.surface,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: 920,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'DISC Questionnaire',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 560),
                              child: Text(
                                'Pick one MOST and one LEAST word for every question. They must be different.',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final compact = constraints.maxWidth < 720;
                                final controls = <Widget>[
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      minWidth: 260,
                                      maxWidth: 420,
                                    ),
                                    child: ProgressBar(
                                      answered: _answeredCount,
                                      total: wordGroups.length,
                                    ),
                                  ),
                                ];

                                if (compact) {
                                  return Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        for (final widget in controls)
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 10),
                                            child: widget,
                                          ),
                                      ],
                                    ),
                                  );
                                }

                                return Center(
                                  child: Wrap(
                                    alignment: WrapAlignment.center,
                                    runAlignment: WrapAlignment.center,
                                    spacing: 16,
                                    runSpacing: 12,
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    children: controls,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                  child: Column(
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.lightbulb_outline,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  'Use your first instinct rather than trying to optimise scores. This inventory is most useful when your choices are fast and honest.',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      for (var i = 0; i < wordGroups.length; i++)
                        KeyedSubtree(
                          key: _cardKeys[i],
                          child: WordGroupCard(
                            groupIndex: i,
                            group: wordGroups[i],
                            answer: _answers[i],
                            showDefinitions: _definitionIndexes.contains(i),
                            onToggleDefinitions: () => _toggleDefinitions(i),
                            onAnswerChanged: (answer) =>
                                _onAnswerChanged(i, answer),
                          ),
                        ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _submit,
                          icon: const Icon(Icons.check),
                          label: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              _allAnswered
                                  ? 'Submit'
                                  : 'Answer all ${wordGroups.length} questions to submit',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
