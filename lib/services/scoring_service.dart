import '../models/answer.dart';
import '../models/disc_result.dart';
import '../models/word.dart';
import '../models/word_group.dart';

DiscResult scoreAnswers(List<WordGroup> groups, List<Answer> answers) {
  assert(groups.length == answers.length);

  final most = <DiscCategory, int>{
    DiscCategory.d: 0,
    DiscCategory.i: 0,
    DiscCategory.s: 0,
    DiscCategory.c: 0,
  };
  final least = <DiscCategory, int>{
    DiscCategory.d: 0,
    DiscCategory.i: 0,
    DiscCategory.s: 0,
    DiscCategory.c: 0,
  };

  for (var i = 0; i < groups.length; i++) {
    final answer = answers[i];
    final group = groups[i];
    if (answer.mostIndex != null) {
      final cat = group.words[answer.mostIndex!].category;
      most[cat] = most[cat]! + 1;
    }
    if (answer.leastIndex != null) {
      final cat = group.words[answer.leastIndex!].category;
      least[cat] = least[cat]! + 1;
    }
  }

  final composite = <DiscCategory, int>{
    for (final c in DiscCategory.values) c: most[c]! - least[c]!,
  };

  return DiscResult(most: most, least: least, composite: composite);
}
