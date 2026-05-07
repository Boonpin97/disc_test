import '../data/disc_patterns.dart';
import '../models/word.dart';

/// Maps a user's COMPOSITE scores onto the closest of the 21 representative
/// DISC patterns described in the Personal DiSCernment Inventory PDF.
///
/// Algorithm:
/// 1. If every category's composite is within ±[levelThreshold] of zero, return
///    the Level pattern (id 21).
/// 2. Otherwise, normalise each composite into the same -2..+2 range that the
///    pattern signatures use, then return the pattern with the smallest
///    Euclidean distance to the user's normalised vector. Ties are broken by
///    matching the user's strongest factor against the pattern's quadrant,
///    then by lowest pattern id.
DiscPattern matchPattern(
  Map<DiscCategory, int> composite, {
  int levelThreshold = 4,
}) {
  final levelPattern = discPatterns.firstWhere((p) => p.id == 21);
  final isLevel = DiscCategory.values
      .every((c) => composite[c]!.abs() <= levelThreshold);
  if (isLevel) {
    return levelPattern;
  }

  final normalised = <DiscCategory, double>{
    for (final c in DiscCategory.values)
      c: (composite[c]! / 6.0).clamp(-2.0, 2.0),
  };

  DiscCategory strongest = DiscCategory.d;
  int strongestAbs = composite[DiscCategory.d]!.abs();
  for (final c in DiscCategory.values) {
    final mag = composite[c]!.abs();
    if (mag > strongestAbs) {
      strongestAbs = mag;
      strongest = c;
    }
  }

  DiscPattern? best;
  double bestDist = double.infinity;
  for (final p in discPatterns) {
    if (p.id == 21) continue;
    double dist = 0;
    for (final c in DiscCategory.values) {
      final diff = normalised[c]! - p.signature[c]!.toDouble();
      dist += diff * diff;
    }

    if (best == null) {
      best = p;
      bestDist = dist;
      continue;
    }

    if (dist < bestDist - 1e-9) {
      best = p;
      bestDist = dist;
    } else if ((dist - bestDist).abs() <= 1e-9) {
      final bestMatchesQuadrant = best.quadrant == strongest;
      final candidateMatchesQuadrant = p.quadrant == strongest;
      if (candidateMatchesQuadrant && !bestMatchesQuadrant) {
        best = p;
        bestDist = dist;
      } else if (candidateMatchesQuadrant == bestMatchesQuadrant &&
          p.id < best.id) {
        best = p;
        bestDist = dist;
      }
    }
  }
  return best!;
}
