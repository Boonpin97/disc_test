import 'word.dart';

class DiscResult {
  final Map<DiscCategory, int> most;
  final Map<DiscCategory, int> least;
  final Map<DiscCategory, int> composite;

  const DiscResult({
    required this.most,
    required this.least,
    required this.composite,
  });

  DiscCategory get dominantComposite {
    DiscCategory best = DiscCategory.d;
    int bestVal = composite[DiscCategory.d]!;
    for (final c in [DiscCategory.i, DiscCategory.s, DiscCategory.c]) {
      if (composite[c]! > bestVal) {
        bestVal = composite[c]!;
        best = c;
      }
    }
    return best;
  }

  DiscCategory get dominantMost {
    DiscCategory best = DiscCategory.d;
    int bestVal = most[DiscCategory.d]!;
    for (final c in [DiscCategory.i, DiscCategory.s, DiscCategory.c]) {
      if (most[c]! > bestVal) {
        bestVal = most[c]!;
        best = c;
      }
    }
    return best;
  }
}
