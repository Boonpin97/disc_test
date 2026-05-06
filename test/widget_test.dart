import 'package:flutter_test/flutter_test.dart';

import 'package:disc_test/data/disc_profiles.dart';
import 'package:disc_test/data/word_groups.dart';
import 'package:disc_test/main.dart';
import 'package:disc_test/models/answer.dart';
import 'package:disc_test/models/word.dart';
import 'package:disc_test/services/scoring_service.dart';

void main() {
  testWidgets('Intro screen renders the Begin button', (tester) async {
    await tester.pumpWidget(const DiscTestApp());
    expect(find.text('DISC Personality Test'), findsOneWidget);
    expect(find.text('Begin'), findsOneWidget);
  });

  test('Word groups: 24 groups, each with one of every D/I/S/C', () {
    expect(wordGroups.length, 24);
    for (final g in wordGroups) {
      final cats = g.words.map((w) => w.category).toSet();
      expect(cats, {DiscCategory.d, DiscCategory.i, DiscCategory.s, DiscCategory.c});
    }
  });

  test('All 24 categories are profiled', () {
    for (final c in DiscCategory.values) {
      expect(discProfiles[c], isNotNull);
    }
  });

  test('Scoring: picking all D as MOST and all C as LEAST', () {
    final answers = <Answer>[];
    for (final group in wordGroups) {
      final dIndex = group.words.indexWhere((w) => w.category == DiscCategory.d);
      final cIndex = group.words.indexWhere((w) => w.category == DiscCategory.c);
      answers.add(Answer(mostIndex: dIndex, leastIndex: cIndex));
    }
    final result = scoreAnswers(wordGroups, answers);
    expect(result.most[DiscCategory.d], 24);
    expect(result.least[DiscCategory.c], 24);
    expect(result.composite[DiscCategory.d], 24);
    expect(result.composite[DiscCategory.c], -24);
    expect(result.composite[DiscCategory.i], 0);
    expect(result.composite[DiscCategory.s], 0);
    expect(result.dominantComposite, DiscCategory.d);
    final mostSum = result.most.values.reduce((a, b) => a + b);
    final leastSum = result.least.values.reduce((a, b) => a + b);
    final compSum = result.composite.values.reduce((a, b) => a + b);
    expect(mostSum, 24);
    expect(leastSum, 24);
    expect(compSum, 0);
  });
}
