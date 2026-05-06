enum DiscCategory { d, i, s, c }

extension DiscCategoryX on DiscCategory {
  String get letter => switch (this) {
        DiscCategory.d => 'D',
        DiscCategory.i => 'I',
        DiscCategory.s => 'S',
        DiscCategory.c => 'C',
      };

  String get fullName => switch (this) {
        DiscCategory.d => 'Dominance',
        DiscCategory.i => 'Influence',
        DiscCategory.s => 'Steadiness',
        DiscCategory.c => 'Compliance',
      };
}

class Word {
  final String text;
  final DiscCategory category;
  final String definition;

  const Word({
    required this.text,
    required this.category,
    required this.definition,
  });
}
