import '../models/word.dart';

/// One of the 21 representative DISC patterns described in the Personal
/// DiSCernment Inventory PDF (pages 21–30, plus the Level pattern on page 30).
///
/// `signature` is a -2..+2 prototype for each DISC factor used by the matcher
/// in `lib/services/pattern_matcher.dart`. Higher absolute values mean the
/// factor is more prominent in that pattern.
class DiscPattern {
  final int id;
  final String name;
  final DiscCategory? quadrant;
  final Map<DiscCategory, int> signature;
  final String outstandingTraits;
  final String internalDrive;
  final String improvement;

  const DiscPattern({
    required this.id,
    required this.name,
    required this.quadrant,
    required this.signature,
    required this.outstandingTraits,
    required this.internalDrive,
    required this.improvement,
  });
}

const List<DiscPattern> discPatterns = [
  DiscPattern(
    id: 1,
    name: 'Director',
    quadrant: DiscCategory.d,
    signature: {
      DiscCategory.d: 2,
      DiscCategory.i: -1,
      DiscCategory.s: -1,
      DiscCategory.c: -1,
    },
    outstandingTraits:
        'Other people see you as coldly aggressive, analytical, impatient, and independent. You are inwardly-driven and try hard to overcome obstacles and reach your goals, and those goals are often obsessions. You like difficult problems that you can overcome with brain-power, logic, and tactics. You are very factual, cool, and competitive, and you want to run the show your own way. You are eager to accept responsibility and make decisions on your own.',
    internalDrive:
        'Underneath, you are dominant, reflective, active, and very determined. In your daily activities, you see the need to initiate action, exercise authority, and produce tangible results. You are an individualist, a loner, and you want both power and freedom. You operate well in fast-moving environments. The more difficult the problems, the more you are interested. You move many times with the determination of a top athlete.',
    improvement:
        'Your impact on others is stronger than you realize. You can be cold, blunt, and critical. When people don\'t measure up to your standards, you tell it like it is, and that often hurts. In your impatience to get things done, you may not hesitate to do it all yourself. You, therefore, are neither the best delegator nor communicator. You are likely to become impatient and irritable when things don\'t go your way. Routine tasks become boring very quickly.',
  ),
  DiscPattern(
    id: 2,
    name: 'Entrepreneur',
    quadrant: DiscCategory.d,
    signature: {
      DiscCategory.d: 2,
      DiscCategory.i: 1,
      DiscCategory.s: -1,
      DiscCategory.c: -2,
    },
    outstandingTraits:
        'Aggressive, persuasive, active, and extremely independent: all these characterize you as an entrepreneur. You are a supreme individualist: cocky, energetic, and persistent. You are incurably venturesome and will try anything once. Your desire for power combines with stubborn determination to control both events and people. You act decisively and positively and move ahead without consultation or conference. Your impatience results in quick action, instant boredom, and an itch for greener pastures. You are versatile, flexible, and self-motivated, with a great sense of urgency and a high tolerance for pressure.',
    internalDrive:
        'You are hard-driving, sociable (on your own terms), alert, and very sure of yourself. In daily activities, you tend to charge ahead against all resistance and opposition. You view restraints as a challenge to getting the quick results you want. You value freedom more than equality and want room to operate. You are most effective where innovation, experimentation, and results are important, and where there are few rules and guidelines.',
    improvement:
        'You disdain corporate structures and controls unless you do the organizing and controlling. As a subordinate, you tend to be a maverick. You may usurp power, overstep bounds, and do it your way. You are often critical of superiors, whom you rarely regard as such, and you resent criticism of your own actions. As a young person, you are likely to move from job to job trying to find the right challenge. The moves may not always be voluntary.',
  ),
  DiscPattern(
    id: 3,
    name: 'Organizer',
    quadrant: DiscCategory.d,
    signature: {
      DiscCategory.d: 2,
      DiscCategory.i: 1,
      DiscCategory.s: -2,
      DiscCategory.c: 1,
    },
    outstandingTraits:
        'You are aggressive, persuasive, active, and independent — an action-oriented self-starter who drives for goals regardless of obstacles. Giving up or giving in is unthinkable. You are a prime mover who loves competition. You prod or persuade, compliment or needle, exhort or drive, depending on the situation. You tend to demand first and ask second, and your love of power primes you for top roles; pride provides the impetus to take risks and implement bold plans. In favourable environments, you are friendly; in antagonistic ones, you are tough.',
    internalDrive:
        'You are forceful, confident, impatient, and firm. In your daily activities, you see the need to move positively against anything that stands in the way. You set a fast pace and expect associates or subordinates to keep up. You make decisions quickly and easily but are willing to recognise that some restraints are reasonable and necessary.',
    improvement:
        'The drive for quick results often makes you a poor delegator and a direct but too-brief communicator. You tend to be a half-hearted listener who is better at sending than receiving. In addition, you may spend too much time putting out brush fires and not enough time on long-range planning. In decision-making, you may be impulsive and shoot from the hip.',
  ),
  DiscPattern(
    id: 4,
    name: 'Pioneer',
    quadrant: DiscCategory.d,
    signature: {
      DiscCategory.d: 2,
      DiscCategory.i: 0,
      DiscCategory.s: -1,
      DiscCategory.c: 1,
    },
    outstandingTraits:
        'People see you as an aggressive, factual, impatient, systematic person. You respond quickly to a challenge with mobility and flexibility. You are a versatile self-starter who is not satisfied with just any answer; you want the best answer. You try to avoid unnecessary risk or trouble. You are sensitive to nuances and to look for hidden meanings. Generally, you need confirmation of the correctness of your action or decision, but in a crucial situation you will tend to go with your intuition. You are logical, critical, and incisive in your approach to attaining goals. You are challenged by problems requiring original and analytical effort.',
    internalDrive:
        'Basically you are apt to be a perfectionist, and you have an equal striving for accomplishment and quality. You are not satisfied with just any answer; you want the best answer. In your daily activities, you are quickly decisive on routine action; on major issues, you weigh all the pros and cons very carefully. You prefer an ever-changing environment — the unusual and different. You want to find the answers for yourself. You want authority and important assignments; advancement and challenge are important to you.',
    improvement:
        'You may have some difficulties with people — for under pressure you can be cool finding and fault finding when your standards are not met. You can become impatient and dissatisfied if you feel your life is becoming routine. Under stress you may seem to waver and appear indecisive when you encounter a conflict between the need to consider the big picture and at the same time attend to details.',
  ),
  DiscPattern(
    id: 5,
    name: 'Cooperator',
    quadrant: DiscCategory.d,
    signature: {
      DiscCategory.d: -2,
      DiscCategory.i: 0,
      DiscCategory.s: 1,
      DiscCategory.c: 1,
    },
    outstandingTraits:
        'Others see you as modest, sociable, predictable, and co-operative. You tend to be careful and conservative and are generally willing to modify your position in order to achieve your goals. The low level of D in your makeup leads you to minimise risks by careful investigation. You prefer an atmosphere free from antagonism and desire harmony. You are steady and consistent, and you prefer to deal with one project at a time with the same person. You will usually direct your skills and experience into areas requiring depth and specialisation. Steady under most pressures, you strive to stabilise your environment, and you react negatively to changes. You are poised and cordial and can create and maintain an atmosphere of goodwill.',
    internalDrive:
        'Because a major influence in your behaviour is a near-absence of the D factor, your nature is to conserve rather than expand. Your basic behaviour is much like what other people see: unassuming, friendly, dependable, and conscientious. You want people to be as considerate, fair, and altruistic as you are. You prefer to please rather than command or direct them. You respect authority and want to please. You are hurt by rejection or rebuff, or by being overlooked, and you don\'t forget a hurt. You want to avoid contention, complications, and conflict.',
    improvement:
        'You are unaggressive and tend to minimise risks by putting things off. You may dawdle, deliberate, and consult before taking a risk or making a decision. You are apt to prefer traditional methods and procedures over innovation, and you may be too willing to follow rules, convention, and instruction. You may trust people too much and get hurt in the process.',
  ),
  DiscPattern(
    id: 6,
    name: 'Affiliator',
    quadrant: DiscCategory.i,
    signature: {
      DiscCategory.d: -1,
      DiscCategory.i: 2,
      DiscCategory.s: 0,
      DiscCategory.c: -1,
    },
    outstandingTraits:
        'People see you as modest, outgoing, active, and independent. You strive to make your environment favourable and friendly. You try to make a good first impression and sell yourself, and you enjoy doing favours for people. Optimistic and enthusiastic, you talk well and at length. You participate actively and exhibit self-confidence. You prefer to persuade people rather than command or direct them, motivating others by teamwork and togetherness.',
    internalDrive:
        'Basically, you are much the same person people see: alert, unassuming, gregarious, active, and determined. You see little need to change your basic behaviour in order to be successful; it has worked well for you through the years. You seek popularity and prestige. You like friendly relationships and group activities, and you want to work with people in pleasant surroundings.',
    improvement:
        'You may trust people too much and misjudge their capabilities. At times you may talk too much and over-sell. You may overestimate the results of your projects and over-commit in setting key objectives. On occasion, you may act impulsively and jump to conclusions. Over-involvement with people may disrupt your time schedule.',
  ),
  DiscPattern(
    id: 7,
    name: 'Negotiator',
    quadrant: DiscCategory.i,
    signature: {
      DiscCategory.d: 0,
      DiscCategory.i: 2,
      DiscCategory.s: 1,
      DiscCategory.c: -1,
    },
    outstandingTraits:
        'Other people view you as modest, energetic, enthusiastic, active, and diplomatic. More tactful than pushy, you are an incurable optimist and are cheerful, talkative, and at home with strangers. You use words to dispel gloom and doubt. You handle small talk smoothly and low-pressure situations well, and easily make your own openings in conversation. You have the ability to create and maintain a pleasant atmosphere of goodwill, both for yourself and your company. You are smooth and tactful, easy-going and smiling, and are very comfortable with a large and diverse circle of acquaintances and associates.',
    internalDrive:
        'Essentially, you are unassuming, outgoing, alert, and tactful. In your daily activities, you see the need to be persuasive but at the same time careful of people and their feelings. You want to be popular and liked, and you seek open recognition of your ability and acceptance from those around you. You want to work with people in open, familiar, friendly surroundings. You tend to work for "prestige" companies — those with which people will be impressed.',
    improvement:
        'To some people, you may appear superficial and a little phony. You may also appear more casual than purposeful, more indirect than specific. Good relations for the long pull may be more important to you than immediate results. You also tend to overestimate other people\'s abilities and may, therefore, expect more than you get. You cushion interpersonal conflicts and find it difficult to be firm, insistent, and direct when handling people problems. You are a diplomat, not a taskmaster.',
  ),
  DiscPattern(
    id: 8,
    name: 'Motivator',
    quadrant: DiscCategory.i,
    signature: {
      DiscCategory.d: 2,
      DiscCategory.i: 2,
      DiscCategory.s: -1,
      DiscCategory.c: -1,
    },
    outstandingTraits:
        'As a Motivator, you are verbally aggressive, outgoing, on-the-go, impatient, and independent. You are very much a social animal. You like to play but know when to work. Both business and social activities involve you with people. You get along well with, and handily motivate, all types of people. Behind your friendliness, however, is a determined push for results. Having natural charisma, you can maintain agreeableness even while disagreeing. You can joke about yourself, and you try not to hurt anyone intentionally. Under pressure, you stand up for what is right.',
    internalDrive:
        'Down deep, you are positive, gregarious, impatient, and unconventional. In your daily activities, you seek to emphasise your natural ability with people and get results through confidence and persuasion. You are prejudiced in favour of people and for what they may potentially accomplish and become. You dislike routine and regimentation; you like to move around, live well, gain prestige and status, and generally be on top of things.',
    improvement:
        'You tend to trust people too much and overestimate your ability to change them. You may also be often weak in follow-through because you expect the best from people. You look on the bright side and may be too optimistic about the results of your efforts. On occasion, you may be too enthusiastic and over-sell. You may also lean too heavily on your own personality when dealing with others.',
  ),
  DiscPattern(
    id: 9,
    name: 'Persuader',
    quadrant: DiscCategory.i,
    signature: {
      DiscCategory.d: 1,
      DiscCategory.i: 2,
      DiscCategory.s: -1,
      DiscCategory.c: 0,
    },
    outstandingTraits:
        'Others view you as positive, persuasive, alert, and independent. You are a direct-action extrovert who is goal-minded and self-motivated. You thrive on taking risks. You are friendly but argumentative and persistent in pursuit of your ends. To you, talking is more important than listening; you tend to dominate the social situation as well as the business environment. You get going verbally, and things just seem to pop into your head and out of your mouth. But your basic empathy for people often overrides your desire to win and stand out above the rest. Your self-esteem is as strong as your desire for acceptance.',
    internalDrive:
        'Basically, you are self-reliant, outgoing, energetic, and uninhibited. In daily activities, to be successful, you need to be a self-starter who can convince people that your way is right. You possess stubborn determination to control events and people. You prefer to deal with the "big picture" rather than having to influence people directly. You are willing to assume authority or even usurp it. You like to be "centre stage." As a Persuader, you tend to be self-indulgent and want what you want when you want it.',
    improvement:
        'You are likely to be too independent to change your ways. Despite your friendliness, you can be quite inconsiderate of others. You might find it helpful to listen and observe more and to curb your stubborn, argumentative streak. Under pressure, your friendliness fades a little as you become more rigid against opposition.',
  ),
  DiscPattern(
    id: 10,
    name: 'Strategist',
    quadrant: DiscCategory.i,
    signature: {
      DiscCategory.d: 1,
      DiscCategory.i: 1,
      DiscCategory.s: -1,
      DiscCategory.c: 2,
    },
    outstandingTraits:
        'People see you as a positive, cool, steady, systematic person. You are direct and straightforward, telling it like it is. You are intellectually curious and challenged by difficult problems requiring brain power and logical analysis. Patient, controlled, moderate, and deliberate, you prefer working with things rather than having to influence people. You are reserved and reflective, and you try to avoid unnecessary risk or trouble. You are conventional, usually diplomatic, often worrisome. You are rarely satisfied in your search for the best answer. You want to achieve, but you also want to be right. Your equal striving for accomplishment and quality often leads others to see you as a perfectionist.',
    internalDrive:
        'Because a significant influence in your pattern is a low level of the I factor, you prefer facts, figures, and things to working with people. To be successful, you see a need in your daily activities to take your time and weigh the pros and cons of each situation very carefully. You prefer to do one thing at a time and need time thoroughly. You strive to maintain the status quo and need time to adjust to change. You make few unnecessary decisions, knowing that time solves more problems than people do.',
    improvement:
        'You are not apt to show hurts openly, but you can bear a grudge and, in time, get even. Since you are possessive, you may be slow to communicate, but when you do, your low I may cause you to be blunt, without apology. If you are engaged in more than one project, you may have to be pushed a little to meet deadlines. Your perfectionism keeps you from ever being completely satisfied with anything, making you appear to waver and be indecisive.',
  ),
  DiscPattern(
    id: 11,
    name: 'Persister',
    quadrant: DiscCategory.s,
    signature: {
      DiscCategory.d: -1,
      DiscCategory.i: 1,
      DiscCategory.s: 2,
      DiscCategory.c: 1,
    },
    outstandingTraits:
        'People see you as a modest, sociable, dependable, determined person. You are not easily swayed once your mind has been made up on any matter. You set your own pace and stick with it. You are a steady, consistent individual who prefers to deal with one thing at a time. You are apt to direct your skills and experience into areas requiring depth and specialisation. Steady under most pressure, you strive to stabilise your environment and react negatively to changes in it. You are a patient and controlled person who moves with moderation and deliberateness. Even under stress, you will usually project a relatively unruffled, unconcerned appearance. You generally approach most situations with care and concentration.',
    internalDrive:
        'Basically, you are conservative, congenial, stable, firm. To be successful, you see a need in your daily activities to emphasise persistence and dependability. You like to build a close relationship with a relatively small group of intimate associates. You like specialised areas of endeavour and usually prefer to be at home rather than travelling. You like specialised work environments with a predictable pattern. You want and need time to adjust to change.',
    improvement:
        'You may conceal grievances and be a grudge-holder. You are apt to be slow to take the initiative, and you do not adapt quickly to change. You strive to maintain the status quo. You are apt to wait for orders before acting. Under pressure, you can be quietly unyielding.',
  ),
  DiscPattern(
    id: 12,
    name: 'Investigator',
    quadrant: DiscCategory.s,
    signature: {
      DiscCategory.d: 1,
      DiscCategory.i: -1,
      DiscCategory.s: 1,
      DiscCategory.c: 2,
    },
    outstandingTraits:
        'Others view you as determined, logical, tenacious, dogged, suspicious, unhurried, and stubborn. Amiable but not hesitant to voice opinions, you like to follow leads, chase clues, dig for facts, and uncover hidden meanings. You analyse problems and evaluate circumstances objectively and dispassionately. You dominate with patience. You are results-oriented without a sense of urgency. Your effective performance is more the result of long, hard work rather than flashes of insight or inspiration.',
    internalDrive:
        'At bottom, you are dogged, decisive, and quite deliberate. You need to be independent and to use a questioning approach. You want to operate by yourself and move in your own way at your own pace. You prefer tough assignments that you can work on independently. You do not want people looking over your shoulder, and you prefer to work with things rather than people.',
    improvement:
        'Disbelieving what you see on the surface, skeptical of intentions, and challenged by unsolved problems, you tend to see people as perplexing and sometimes as annoying obstructions. You are not interested in pleasing others and can be blunt, tactless, stubborn, and cold. It is difficult, if not impossible, to get you to change your mind. You have difficulty persuading others or generating enthusiasm.',
  ),
  DiscPattern(
    id: 13,
    name: 'Specialist',
    quadrant: DiscCategory.s,
    signature: {
      DiscCategory.d: -1,
      DiscCategory.i: -1,
      DiscCategory.s: 2,
      DiscCategory.c: 1,
    },
    outstandingTraits:
        'As a Specialist, you appear to others as quiet, amicable, predictable, self-controlled, practical, and down-to-earth. You seek the familiar and maintain relationships with a few relatively close friends. You are cool-headed, reflective, and considerate, and you "wear well" with others. Soft-spoken, unexcitable, easy-going and relaxed, you proceed at your own deliberate pace, and you perform consistently and steadily.',
    internalDrive:
        'Essentially, you are unassuming, factual, patient, and accurate. In your daily activities, you need to concentrate on the job at hand — one that is generally repetitive and specialised. You like to do one thing at a time and do it thoroughly. You strive to maintain the status quo and want time to adjust to change. You usually prefer to work at one place rather than travel. You make few decisions, knowing that time resolves more problems than people do. Your mildness, possessive nature, and modest aspirations all converge to form a placid personality and a diligent style.',
    improvement:
        'You seem more oriented to the past than to the future. A "traditionalist," you seem more pleased with where you\'ve been than where you might go. You talk about better times and the "good old days." You are not likely to show hurts openly, but you can bear grudges and, in time, get even. Since you are possessive, you may be slow to delegate. Keeping personally involved is also security, because "they need me." Generally, you are not an initiator, but rather, a follower. If more than one project is in process at the same time, you may have to be pushed to meet deadlines.',
  ),
  DiscPattern(
    id: 14,
    name: 'Advisor',
    quadrant: DiscCategory.s,
    signature: {
      DiscCategory.d: -1,
      DiscCategory.i: 1,
      DiscCategory.s: 2,
      DiscCategory.c: -1,
    },
    outstandingTraits:
        'Others see you as easy-going, friendly, relaxed, and independent. You are a nice person who poses no threat to and, consequently, are impossible not to like. People come to you with their problems because you like people and are willing to listen. If you have any suggestions, you will offer them in an indirect, offhand way. People are naturally drawn to you because of your warmth, sympathy, empathy, and understanding. Your self-confidence and modesty, poise and mildness, persistence, and devotion to people all combine to make you likeable.',
    internalDrive:
        'You are inherently patient, relaxed, and steadfast. In daily activities, you need to feature your amiability and goodwill. You want to work with and help people you know in a personal, unhurried environment. You hate to be alone or on your own. You are generally good-natured and pleasant. Regardless of occupation, you will tend to teach, counsel, and advise.',
    improvement:
        'You want to be venturesome, but have some difficulty deciding when to defer or defy, pause or persist, rebuff or befriend. You dislike having to give direct orders. You may be too easy with marginal workers, and if you do get upset, you will find a way to "make up." You may hold grudges against those who criticise you or don\'t allow you to have your own way.',
  ),
  DiscPattern(
    id: 15,
    name: 'Whirlwind',
    quadrant: DiscCategory.s,
    signature: {
      DiscCategory.d: 1,
      DiscCategory.i: 1,
      DiscCategory.s: -2,
      DiscCategory.c: 1,
    },
    outstandingTraits:
        'People see you as positive, sociable, hyperactive, and systematic. You are impatient for quick results, react rapidly, display boredom quickly, are self-motivated, and sometimes irritable. You are versatile with shifting goals, new projects, and new methods, and you win people when you want to with persuasiveness and optimism. You can be diplomatic and precise on one hand, restless and discontented on the other. You are not happy until major events or others confirm the correctness of your action or decision. You want to achieve, but you also want to be right. In your daily activities, you strive equally for accomplishment and quality.',
    internalDrive:
        'Basically, you are self-starting, poised, very impatient, and conscientious. Lacking a significant S factor, you are a bundle of nervous energy that keeps you going at high speed. Often your perfectionism will not allow you to accept just any answer. You want the best answer. In your daily activities, you see a need to weigh the pros and cons of each situation — but fast. With one foot on the gas and the other on the brake, you can generate activity, see alternatives, and cover a lot of ground.',
    improvement:
        'Sometimes your reactions may be too quick and impulsive. The low level of S leaves you dissatisfied with the status quo and irritated with obstacles. You are apt to jump suddenly with quick, seemingly intuitive decisions. At other times, you may waver and vacillate. Your sometimes aggressive, sometimes cautious behaviour may confuse your associates.',
  ),
  DiscPattern(
    id: 16,
    name: 'Perfectionist',
    quadrant: DiscCategory.c,
    signature: {
      DiscCategory.d: -1,
      DiscCategory.i: -1,
      DiscCategory.s: -1,
      DiscCategory.c: 2,
    },
    outstandingTraits:
        'People see you as conservative, logical, alert, and conscientious. You are apt to be diplomatic and contented on the one hand, and restless and discontented on the other. You are sensitive to nuances and alert to possible hidden meanings and ulterior motives. You are reserved and reflective, and you want to avoid unnecessary risk or trouble. You are reliable, precise, and tactful, and you want to be a stickler for details, an enforcer of established rules. You are thorough and fore-sighted.',
    internalDrive:
        'Your basic behaviour is much the same as that which other people see: low-key, factual, active, and accurate. To be successful in your daily activities, you see a need to be careful and co-operative. You want to feel that you are doing the right thing, but under pressure, your perfectionism may make you appear to waver and be indecisive. You seem willing to pay the price for social acceptance, but since this behaviour runs against your grain, it may engender some tension.',
    improvement:
        'You may spend too much time doing things yourself to be sure they\'re right. Fretting over little things and checking and re-checking details may get in the way of performance. Your high sense of obligation and your conscientious effort to please may combine to inhibit your actions and your results.',
  ),
  DiscPattern(
    id: 17,
    name: 'Analyst',
    quadrant: DiscCategory.c,
    signature: {
      DiscCategory.d: -1,
      DiscCategory.i: -1,
      DiscCategory.s: 1,
      DiscCategory.c: 2,
    },
    outstandingTraits:
        'People see you as a reliable, factual, steady, open-minded person. You tend to be a stickler for system and order. You make decisions based on proven precedent and known facts. In all your activity, you try meticulously to live up to high standards. You are diplomatic and precise, and you try to avoid unnecessary risk or trouble. You are not at ease until the correctness of your actions and decisions have been confirmed. You are sensitive to possible hidden meanings and ulterior motives. You are logical, critical, and incisive in your approach to attaining goals.',
    internalDrive:
        'Basically, you are much the same person people see: modest, reflective, stable, precise. You are challenged by difficult problems that require thought and analysis but will not accept just any solution — you want the right answer. You are a good team member and like to share responsibility as part of a group. You like the standard operating procedures and a settled track to follow.',
    improvement:
        'You may spend too much time checking and re-checking details and doing things yourself to be sure they\'re done right. You may become too dependent upon procedures. Your decisions are apt to be tentative, guarded, and low-risk, and you may hesitate to act without orders, rules, or precedent.',
  ),
  DiscPattern(
    id: 18,
    name: 'Adaptor',
    quadrant: DiscCategory.c,
    signature: {
      DiscCategory.d: -2,
      DiscCategory.i: -1,
      DiscCategory.s: 1,
      DiscCategory.c: 2,
    },
    outstandingTraits:
        'Other people view you as conservative, reserved, stable, and conscientious. In daily activities, you need to follow orders, precedent, rules, and regulations. You are often drawn to jobs requiring meticulous work with things and painstaking attention to detail. You prefer to share responsibility by working as a member of a team. You dislike sudden or abrupt change. You like to look ahead, thereby avoiding unnecessary trouble and risk. You have a passion for impeccability and order. You follow directions carefully in order to turn in an error-free performance.',
    internalDrive:
        'As an Adaptor, you are essentially accommodating, contemplative, methodical, and conscientious. In daily activities, you need to follow orders, precedent, rules, and regulations. You are often drawn to jobs requiring meticulous work with things and painstaking attention to detail. You prefer to share responsibility by working as a member of a team. You dislike sudden or abrupt change. You are a good planner since you are well-informed, accurate on details, conservative on estimates, and certain of precedents.',
    improvement:
        'Since you do things yourself to be sure you are right, you ordinarily do not delegate. You are likely to need support and backup in difficult situations. You prefer to be in on decisions rather than have to make them. You need detailed instructions and an exact job description so you know what is expected of you. You do particularly well with assignments requiring planning, attention to detail, precision, and organisation.',
  ),
  DiscPattern(
    id: 19,
    name: 'Creator',
    quadrant: DiscCategory.c,
    signature: {
      DiscCategory.d: 1,
      DiscCategory.i: -1,
      DiscCategory.s: -1,
      DiscCategory.c: 2,
    },
    outstandingTraits:
        'To others, you appear forceful, factual, impulsive, and systematic. You are likely to be highly intelligent but with a flair for disorganisation. You are oriented toward concepts, theories, projections, and probabilities. You investigate facts inexhaustibly and pursue all possible solutions to a problem. You can\'t accept just any answer; you strive unendingly for the best answer. This process results in new and often creative ideas. As a result, many people view you as a perfectionist.',
    internalDrive:
        'As a Creator, you are basically driving, analytical, intense, and complex. Your perfectionism springs from your flair for seeing the forest amid all the trees. You can uncover more alternatives than your acquaintances and associates can imagine. You are highly regarded as a problem-solver. You are drawn to intricate puzzles, tactics, and strategies. You prefer to work alone, usually in a technical area. You want time to explore and freedom to probe.',
    improvement:
        'The presence of a Creator can be exciting to some and exasperating to others. Carefully aggressive, tensely tactful, self-critical, and overly serious, you drive for results with one foot on the gas pedal and the other on the brake. Due to your perfectionist instincts, you are never quite satisfied with anything. As a result, you appear to vacillate and sometimes reverse yourself. Not interested in people as much as "creative things," you can be cool and aloof. You tend to work in spurts rather than at a steady pace and often will not have the communication skills necessary to have your creative ideas understood and accepted.',
  ),
  DiscPattern(
    id: 20,
    name: 'Individualist',
    quadrant: DiscCategory.c,
    signature: {
      DiscCategory.d: 1,
      DiscCategory.i: 1,
      DiscCategory.s: 1,
      DiscCategory.c: -2,
    },
    outstandingTraits:
        'People see you as an assertive, persuasive, steady, independent person. You act positively and directly in the face of opposition and will take a forceful stand to fight for your position. You are willing to take chances. You display self-confidence in dealing with others. Although you strive to win people\'s approval, you are reluctant to give up your own point of view. Persistent and persevering, you aren\'t easily swayed once your mind is made up. You can be rigidly independent when force is applied and are exasperating to others who want you to adapt.',
    internalDrive:
        'You are much the same person that people see: convincing, driving, determined, stubborn. You see little need to change your basic behaviour to be successful. You want room to operate and freedom to run things your way. Your low C makes you resistant to being bound by precedent, tradition, or accepted ways of doing things. You want to be able to state your views firmly and defend them persistently.',
    improvement:
        'At times you may usurp power and overstep your authority. Because the near-absence of the C factor significantly influences your behavioural tendencies, you can be direct, blunt, and fearless in reaction to opposition. Under stress, you can become rigid, act without precedent, and state an unpopular opinion.',
  ),
  DiscPattern(
    id: 21,
    name: 'Level Patterns',
    quadrant: null,
    signature: {
      DiscCategory.d: 0,
      DiscCategory.i: 0,
      DiscCategory.s: 0,
      DiscCategory.c: 0,
    },
    outstandingTraits:
        'People see you as a reliable, congenial, steady, adult person. Your drive for accomplishment is counter-balanced by your need to be right, and as a result, you are sometimes seen as a perfectionist. You cannot accept just any answer; you want the best answer. Sometimes you are decisive, ready to take a stand, firm in conviction, ready to argue a point. At other times, you may compromise, concede, and comply with accepted and expected practice. You can be either tense or surprisingly calm, venturesome or cautious, noticeable or unobtrusive.',
    internalDrive:
        'To be successful, you see a need in your daily activities to act quite differently at different times. Sometimes you are positive, factual, alert, and determined. At other times, you project a low-key, friendly, helpful approach. The changes you demand of yourself could cause some tension. You want ample time to assure perfection in all your undertakings. You want freedom and authority to re-examine and re-test your findings.',
    improvement:
        'At times, your perfectionism may make you vacillate and waver between alternatives. On some matters, you are usually willing to go along with the wishes of others; on other issues, you will take a stand and defend it. Your unpredictable behaviour may on occasion confuse your associates who can\'t get a "fix" on you. You tend to work in spurts rather than at a steady, sustained pace. People who demonstrate level patterns may be going through major life changes and/or transition periods; if all four of your composite scores fall within the midrange, consider re-taking this instrument when the situation has been resolved.',
  ),
];
