class Answer {
  final int? mostIndex;
  final int? leastIndex;

  const Answer({this.mostIndex, this.leastIndex});

  bool get isComplete => mostIndex != null && leastIndex != null;

  Answer copyWith({int? mostIndex, int? leastIndex, bool clearMost = false, bool clearLeast = false}) {
    return Answer(
      mostIndex: clearMost ? null : (mostIndex ?? this.mostIndex),
      leastIndex: clearLeast ? null : (leastIndex ?? this.leastIndex),
    );
  }
}
