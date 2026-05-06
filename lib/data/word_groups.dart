import '../models/word.dart';
import '../models/word_group.dart';
import 'glossary.dart';

Word _w(String text, DiscCategory category) {
  final def = glossary[text];
  assert(def != null, 'Missing glossary entry for "$text"');
  return Word(text: text, category: category, definition: def ?? '');
}

final List<WordGroup> wordGroups = [
  WordGroup([
    _w('Forceful', DiscCategory.d),
    _w('Expressive', DiscCategory.i),
    _w('Restrained', DiscCategory.s),
    _w('Compliant', DiscCategory.c),
  ]),
  WordGroup([
    _w('Force-Of-Character', DiscCategory.d),
    _w('Emotional', DiscCategory.i),
    _w('Careful', DiscCategory.s),
    _w('Satisfied', DiscCategory.c),
  ]),
  WordGroup([
    _w('Pioneering', DiscCategory.d),
    _w('Influential', DiscCategory.i),
    _w('Calm', DiscCategory.s),
    _w('Correct', DiscCategory.c),
  ]),
  WordGroup([
    _w('Domineering', DiscCategory.d),
    _w('Attractive', DiscCategory.i),
    _w('Willing', DiscCategory.s),
    _w('Precise', DiscCategory.c),
  ]),
  WordGroup([
    _w('Determined', DiscCategory.d),
    _w('Stimulating', DiscCategory.i),
    _w('Meticulous', DiscCategory.s),
    _w('Even-Tempered', DiscCategory.c),
  ]),
  WordGroup([
    _w('Demanding', DiscCategory.d),
    _w('Captivating', DiscCategory.i),
    _w('Patient', DiscCategory.s),
    _w('Timid', DiscCategory.c),
  ]),
  WordGroup([
    _w('Self-Reliant', DiscCategory.d),
    _w('Companionable', DiscCategory.i),
    _w('Kind', DiscCategory.s),
    _w('Conscientious', DiscCategory.c),
  ]),
  WordGroup([
    _w('Persistent', DiscCategory.d),
    _w('Playful', DiscCategory.i),
    _w('Self-Controlled', DiscCategory.s),
    _w('Agreeable', DiscCategory.c),
  ]),
  WordGroup([
    _w('High-Spirited', DiscCategory.d),
    _w('Talkative', DiscCategory.i),
    _w('Soft-Spoken', DiscCategory.s),
    _w('Good-Natured', DiscCategory.c),
  ]),
  WordGroup([
    _w('Impatient', DiscCategory.d),
    _w('Convincing', DiscCategory.i),
    _w('Contented', DiscCategory.s),
    _w('Resigned', DiscCategory.c),
  ]),
  WordGroup([
    _w('Aggressive', DiscCategory.d),
    _w('Good Mixer', DiscCategory.i),
    _w('Respectful', DiscCategory.s),
    _w('Gentle', DiscCategory.c),
  ]),
  WordGroup([
    _w('Nervy', DiscCategory.d),
    _w('Poised', DiscCategory.i),
    _w('Accommodating', DiscCategory.s),
    _w('Conventional', DiscCategory.c),
  ]),
  WordGroup([
    _w('Argumentative', DiscCategory.d),
    _w('Confident', DiscCategory.i),
    _w('Cooperative', DiscCategory.s),
    _w('Relaxed', DiscCategory.c),
  ]),
  WordGroup([
    _w('Restless', DiscCategory.d),
    _w('Inspiring', DiscCategory.i),
    _w('Well-Disciplined', DiscCategory.s),
    _w('Considerate', DiscCategory.c),
  ]),
  WordGroup([
    _w('Courageous', DiscCategory.d),
    _w('Optimistic', DiscCategory.i),
    _w('Sympathetic', DiscCategory.s),
    _w('Diplomatic', DiscCategory.c),
  ]),
  WordGroup([
    _w('Exacting', DiscCategory.d),
    _w('Charming', DiscCategory.i),
    _w('Lenient', DiscCategory.s),
    _w('Fixed', DiscCategory.c),
  ]),
  WordGroup([
    _w('Adventurous', DiscCategory.d),
    _w('Enthusiastic', DiscCategory.i),
    _w('Loyal', DiscCategory.s),
    _w('Goes-By-The-Book', DiscCategory.c),
  ]),
  WordGroup([
    _w('Will Power', DiscCategory.d),
    _w('Entertaining', DiscCategory.i),
    _w('Good Listener', DiscCategory.s),
    _w('Humble', DiscCategory.c),
  ]),
  WordGroup([
    _w('Competitive', DiscCategory.d),
    _w('Fun-Loving', DiscCategory.i),
    _w('Obedient', DiscCategory.s),
    _w('Tactful', DiscCategory.c),
  ]),
  WordGroup([
    _w('Vigorous', DiscCategory.d),
    _w('Persuasive', DiscCategory.i),
    _w('Neighbourly', DiscCategory.s),
    _w('Cautious', DiscCategory.c),
  ]),
  WordGroup([
    _w('Outspoken', DiscCategory.d),
    _w('Eloquent', DiscCategory.i),
    _w('Strict', DiscCategory.s),
    _w('Reserved', DiscCategory.c),
  ]),
  WordGroup([
    _w('Decisive', DiscCategory.d),
    _w('Animated', DiscCategory.i),
    _w('Accurate', DiscCategory.s),
    _w('Obliging', DiscCategory.c),
  ]),
  WordGroup([
    _w('Assertive', DiscCategory.d),
    _w('Gregarious', DiscCategory.i),
    _w('Nonchalant', DiscCategory.s),
    _w('Orderly', DiscCategory.c),
  ]),
  WordGroup([
    _w('Bold', DiscCategory.d),
    _w('Outgoing', DiscCategory.i),
    _w('Perfectionist', DiscCategory.s),
    _w('Moderate', DiscCategory.c),
  ]),
];
