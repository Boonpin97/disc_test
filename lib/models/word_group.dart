import 'word.dart';

class WordGroup {
  final List<Word> words;

  const WordGroup(this.words) : assert(words.length == 4);
}
