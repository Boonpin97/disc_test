import '../models/word.dart';

class DiscProfile {
  final DiscCategory category;
  final String otherTerms;
  final String emphasis;
  final String motivation;
  final String basicIntent;
  final String overview;
  final List<String> strengths;
  final List<String> weaknesses;
  final String valueToOthers;
  final String majorStrengths;
  final String motivatedBy;
  final String usingTime;

  const DiscProfile({
    required this.category,
    required this.otherTerms,
    required this.emphasis,
    required this.motivation,
    required this.basicIntent,
    required this.overview,
    required this.strengths,
    required this.weaknesses,
    required this.valueToOthers,
    required this.majorStrengths,
    required this.motivatedBy,
    required this.usingTime,
  });
}

const Map<DiscCategory, DiscProfile> discProfiles = {
  DiscCategory.d: DiscProfile(
    category: DiscCategory.d,
    otherTerms: 'Driver, Director',
    emphasis:
        'Controlling the environment by overcoming opposition to achieve desired goals.',
    motivation: 'Challenge',
    basicIntent: 'To Overcome',
    overview:
        '"D" quadrant people are self-starters who get going when things get tough. You thrive on competition and are usually direct, positive and straightforward - sometimes blunt. You like to be center stage and in charge.\n\nYou will fight hard for what you think is the way to go but can accept momentary defeat without holding grudges. You hate routine and are prone to changing jobs, especially early in your career, until you find the challenge you need.\n\nD\'s thrive on competition, tough assignments, heavy workloads, pressure, and opportunities for individual accomplishment. You are discontented with the status quo. You are a real individualist and very self-sufficient. You demand a great deal of yourself and others.',
    strengths: [
      'Decisive',
      'Initiating',
      'Forceful',
      'Assertive',
      'Competitive',
      'Goal-oriented',
      'Authoritative',
      'Independent',
    ],
    weaknesses: [
      'Overbearing',
      'Abrasive',
      'Impatient',
      'Blunt',
      'Demanding',
      'Hasty',
      'Dictatorial',
      'Belligerent',
    ],
    valueToOthers: 'Initiates change',
    majorStrengths: 'Goal oriented, persistent, gets things done',
    motivatedBy: 'RESULTS - challenge and action',
    usingTime: 'Focus: NOW - efficient use of time, likes to get to the point',
  ),
  DiscCategory.i: DiscProfile(
    category: DiscCategory.i,
    otherTerms: 'Expressive, Persuader',
    emphasis:
        'Creating the environment by motivating and aligning others to accomplish results.',
    motivation: 'Recognition',
    basicIntent: 'To Persuade',
    overview:
        '"I" quadrant people thrive on social contact, one-on-one situations, and freedom from control and detail. I\'s are friendly, outgoing, persuasive and confident.\n\nYour basic interest is in people. You are poised and meet strangers well. People seem to respond to you naturally, and you usually have a wide range of acquaintances. Your innate optimism and people skills help you get along with most people, including competitors.\n\nOften very fashionable dressers, I\'s thrive on personal recognition.',
    strengths: [
      'Charismatic',
      'Confident',
      'Gregarious',
      'Persuasive',
      'Participative',
      'Optimistic',
      'Stimulating',
      'Enthusiastic',
      'Communicative',
    ],
    weaknesses: [
      'Impulsive',
      'Superficial',
      'Unrealistic',
      'Glib',
      'Overconfident',
      'Poor listener',
      'Self-centered',
      'Too trusting',
      'Emotional',
    ],
    valueToOthers: 'Creates enthusiasm',
    majorStrengths: 'Outgoing, gets people motivated and involved',
    motivatedBy: 'RECOGNITION - approval and visibility',
    usingTime: 'Focus: FUTURE - tends to rush to the next exciting thing',
  ),
  DiscCategory.s: DiscProfile(
    category: DiscCategory.s,
    otherTerms: 'Amicable, Supporter',
    emphasis: 'Maintaining the environment to carry out specific tasks.',
    motivation: 'Appreciation',
    basicIntent: 'To Support',
    overview:
        'The "S" quadrant person thrives in a relaxed, friendly atmosphere without much pressure, one that offers security, limited territory, predictable routine and credit for work accomplished.\n\nYou are usually amiable, easy-going, warm-hearted, home-loving and neighbourly. On the other hand, you may be undemonstrative and controlled. You conceal your feelings and sometimes hold a grudge. Most of the time S people are even-tempered, low-key, emotionally mature and unobtrusive. You are generally content with the status quo and prone to leniency with yourself and others.\n\nS people dislike change. Once under way, you work steadily and patiently, and you dislike deadlines. You are usually very possessive and develop strong attachments for your things, your family, your department, and your position.',
    strengths: [
      'Self-controlled',
      'Accommodating',
      'Persistent',
      'Patient',
      'Good listener',
      'Easy-going',
      'Calm',
      'Sympathetic',
      'Warm',
      'Dependable',
    ],
    weaknesses: [
      'Complacent',
      'Lenient',
      'Smug',
      'Indifferent',
      'Non-demonstrative',
      'Confrontation-averse',
      'Apathetic',
      'Plodding',
      'Passive',
      'Possessive',
    ],
    valueToOthers: 'Builds relationships',
    majorStrengths: 'Good people skills, good team player or leader',
    motivatedBy: 'RELATIONSHIPS - appreciation and service',
    usingTime: 'Focus: PRESENT - spends time in personal interaction',
  ),
  DiscCategory.c: DiscProfile(
    category: DiscCategory.c,
    otherTerms: 'Conscientious, Cautious, Analytical',
    emphasis:
        'Structuring the environment to produce products and services that meet high standards.',
    motivation: 'Protection / Security',
    basicIntent: 'To Avoid Trouble',
    overview:
        '"C" quadrant people thrive on order, pre-determined methods, tradition, and conflict-free atmospheres with ample opportunity for careful planning and without sudden changes.\n\nC methods are pre-determined, precise and attentive to detail. You prefer to adapt to situations to avoid conflict and antagonism. Your need for self-preservation causes you to document everything that you do, and you try to do whatever others want you to do.\n\nNaturally cautious, you prefer to wait and see which way the wind is blowing. Once your mind is made up, however, you can be very firm in adhering to procedures.',
    strengths: [
      'Precise',
      'Adaptable',
      'Thorough',
      'Systematic',
      'Cautious',
      'Conscientious',
      'Orderly',
      'Well-prepared',
      'Accurate',
    ],
    weaknesses: [
      'Too careful',
      'Obsessive / compulsive',
      'Nit-picky',
      'Analysis paralysis',
      'Suspicious',
      'Finicky',
      'Detached',
      'Sensitive',
      'Indecisive',
    ],
    valueToOthers: 'Pursues excellence',
    majorStrengths: 'Quality oriented, accurate and precise in their work',
    motivatedBy: 'BEING RIGHT - quality and excellence',
    usingTime: 'Focus: PAST - works more slowly to ensure accuracy',
  ),
};
