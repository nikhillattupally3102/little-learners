import 'package:flutter/material.dart';

import '../theme.dart';

/// School-style levels, from toddlers to 5th grade.
enum Level {
  age2('Age 2', '2 yrs', '🐣'),
  age3('Age 3', '3 yrs', '🐥'),
  preK('Pre-K', 'Pre-K', '🧸'),
  kindergarten('Kindergarten', 'K', '🎒'),
  grade1('Grade 1', '1st', '📘'),
  grade2('Grade 2', '2nd', '📗'),
  grade3('Grade 3', '3rd', '📙'),
  grade4('Grade 4', '4th', '🔭'),
  grade5('Grade 5', '5th', '🎓');

  const Level(this.title, this.short, this.emoji);
  final String title;
  final String short;
  final String emoji;

  bool atLeast(Level other) => index >= other.index;
  bool atMost(Level other) => index <= other.index;

  /// All worksheet kinds suitable for this level.
  List<WorksheetKind> get kinds => [
    for (final k in WorksheetKind.values)
      if (k.suits(this) && k != WorksheetKind.topicQuiz) k,
  ];
}

enum Category {
  math('Math', '🔢', AppColors.sky, 2),
  reading('Reading', '📚', AppColors.bubblegum, 2),
  science('Science', '🔬', AppColors.mint, 1),
  puzzles('Puzzles', '🧩', AppColors.grape, 1),
  writing('Writing', '✏️', AppColors.tangerine, 1),
  geography('Geography', '🌍', AppColors.lime, 1);

  const Category(this.title, this.emoji, this.color, this.dailyCount);
  final String title;
  final String emoji;
  final Color color;

  /// How many worksheets of this category appear in each day's set.
  final int dailyCount;
}

enum WorksheetKind {
  // ------------------------------------------------------------------- math
  counting(
    'Count It!',
    '🔢',
    AppColors.sky,
    Category.math,
    Level.preK,
    Level.kindergarten,
  ),
  shapes(
    'Shapes & Colors',
    '🔷',
    AppColors.grape,
    Category.math,
    Level.preK,
    Level.grade1,
  ),
  sizes(
    'Big & Small',
    '🐘',
    AppColors.lime,
    Category.math,
    Level.preK,
    Level.preK,
  ),
  moreLess(
    'More or Less',
    '⚖️',
    AppColors.tangerine,
    Category.math,
    Level.preK,
    Level.kindergarten,
  ),
  numberFind(
    'Find the Number',
    '🔟',
    AppColors.bubblegum,
    Category.math,
    Level.preK,
    Level.kindergarten,
  ),
  addition(
    'Add It Up',
    '➕',
    AppColors.lime,
    Category.math,
    Level.preK,
    Level.grade3,
  ),
  subtraction(
    'Take Away',
    '➖',
    AppColors.sunshine,
    Category.math,
    Level.preK,
    Level.grade3,
  ),
  compareNumbers(
    'Bigger or Smaller',
    '🐊',
    AppColors.mint,
    Category.math,
    Level.grade1,
    Level.grade5,
  ),
  placeValue(
    'Place Value',
    '🧮',
    AppColors.sky,
    Category.math,
    Level.grade1,
    Level.grade4,
  ),
  time(
    'Tell the Time',
    '🕐',
    AppColors.tangerine,
    Category.math,
    Level.grade1,
    Level.grade3,
  ),
  money(
    'Count Money',
    '🪙',
    AppColors.sunshine,
    Category.math,
    Level.grade1,
    Level.grade3,
  ),
  multiplication(
    'Times Tables',
    '✖️',
    AppColors.grape,
    Category.math,
    Level.grade2,
    Level.grade5,
  ),
  division(
    'Share & Divide',
    '➗',
    AppColors.bubblegum,
    Category.math,
    Level.grade3,
    Level.grade5,
  ),
  fractions(
    'Fractions',
    '🍕',
    AppColors.tangerine,
    Category.math,
    Level.grade1,
    Level.grade5,
  ),
  wordProblems(
    'Word Problems',
    '📝',
    AppColors.sky,
    Category.math,
    Level.grade1,
    Level.grade5,
  ),
  area(
    'Area & Perimeter',
    '📐',
    AppColors.mint,
    Category.math,
    Level.grade3,
    Level.grade5,
  ),
  rounding(
    'Rounding',
    '🎯',
    AppColors.bubblegum,
    Category.math,
    Level.grade3,
    Level.grade4,
  ),
  decimals(
    'Decimals',
    '💯',
    AppColors.grape,
    Category.math,
    Level.grade4,
    Level.grade5,
  ),

  // ---------------------------------------------------------------- reading
  listen(
    'Listen & Tap',
    '👂',
    AppColors.sky,
    Category.reading,
    Level.preK,
    Level.age3,
  ),
  letters(
    'ABC Sounds',
    '🔤',
    AppColors.bubblegum,
    Category.reading,
    Level.preK,
    Level.kindergarten,
  ),
  abcOrder(
    'ABC Order',
    '🚂',
    AppColors.tangerine,
    Category.reading,
    Level.preK,
    Level.grade1,
  ),
  soundOut(
    'Sound It Out',
    '🗣️',
    AppColors.tangerine,
    Category.reading,
    Level.preK,
    Level.grade1,
  ),
  rhymes(
    'Rhyme Time',
    '🎵',
    AppColors.grape,
    Category.reading,
    Level.preK,
    Level.grade1,
  ),
  wordMatch(
    'Word Match',
    '🔗',
    AppColors.mint,
    Category.reading,
    Level.preK,
    Level.grade1,
  ),
  opposites(
    'Opposites',
    '↔️',
    AppColors.sky,
    Category.reading,
    Level.preK,
    Level.grade2,
  ),
  sightWords(
    'Sight Words',
    '👀',
    AppColors.grape,
    Category.reading,
    Level.preK,
    Level.grade2,
  ),
  syllables(
    'Clap the Syllables',
    '👏',
    AppColors.sunshine,
    Category.reading,
    Level.kindergarten,
    Level.grade2,
  ),
  comprehension(
    'Read & Answer',
    '📚',
    AppColors.bubblegum,
    Category.reading,
    Level.kindergarten,
    Level.grade5,
  ),
  grammar(
    'Word Types',
    '🏷️',
    AppColors.lime,
    Category.reading,
    Level.grade1,
    Level.grade4,
  ),
  compoundWords(
    'Compound Words',
    '🌻',
    AppColors.sunshine,
    Category.reading,
    Level.grade1,
    Level.grade2,
  ),
  fillGap(
    'Fill the Gap',
    '🕳️',
    AppColors.sky,
    Category.reading,
    Level.grade1,
    Level.grade3,
  ),
  wordMeanings(
    'Same & Opposite',
    '💬',
    AppColors.mint,
    Category.reading,
    Level.grade2,
    Level.grade5,
  ),
  homophones(
    'Sound-Alikes',
    '👯',
    AppColors.tangerine,
    Category.reading,
    Level.grade2,
    Level.grade4,
  ),
  wordParts(
    'Prefixes & Suffixes',
    '🧱',
    AppColors.grape,
    Category.reading,
    Level.grade3,
    Level.grade5,
  ),

  // ---------------------------------------------------------------- science
  animalSounds(
    'Animal Sounds',
    '🐮',
    AppColors.lime,
    Category.science,
    Level.preK,
    Level.age3,
  ),
  myBody(
    'My Body',
    '🖐️',
    AppColors.bubblegum,
    Category.science,
    Level.preK,
    Level.kindergarten,
  ),
  weather(
    'Weather & Seasons',
    '🌦️',
    AppColors.sky,
    Category.science,
    Level.preK,
    Level.grade1,
  ),
  animalHomes(
    'Animal Homes',
    '🏡',
    AppColors.tangerine,
    Category.science,
    Level.preK,
    Level.grade1,
  ),
  babyAnimals(
    'Baby Animals',
    '🐣',
    AppColors.sunshine,
    Category.science,
    Level.preK,
    Level.kindergarten,
  ),
  sinkFloat(
    'Sink or Float',
    '🛁',
    AppColors.sky,
    Category.science,
    Level.preK,
    Level.grade1,
  ),
  livingThings(
    'Living or Not?',
    '🌱',
    AppColors.lime,
    Category.science,
    Level.kindergarten,
    Level.grade2,
  ),
  animalGroups(
    'Animal Groups',
    '🐾',
    AppColors.tangerine,
    Category.science,
    Level.grade1,
    Level.grade3,
  ),
  plants(
    'Plants',
    '🌻',
    AppColors.lime,
    Category.science,
    Level.grade1,
    Level.grade4,
  ),
  lifeCycles(
    'Life Cycles',
    '🦋',
    AppColors.grape,
    Category.science,
    Level.grade1,
    Level.grade3,
  ),
  matter(
    'Matter',
    '🧊',
    AppColors.sky,
    Category.science,
    Level.grade1,
    Level.grade5,
  ),
  space(
    'Space',
    '🪐',
    AppColors.grape,
    Category.science,
    Level.grade1,
    Level.grade5,
  ),
  humanBody(
    'Human Body',
    '🦴',
    AppColors.bubblegum,
    Category.science,
    Level.grade1,
    Level.grade5,
  ),
  earth(
    'Planet Earth',
    '🌋',
    AppColors.tangerine,
    Category.science,
    Level.grade2,
    Level.grade5,
  ),
  forces(
    'Forces & Energy',
    '🧲',
    AppColors.bubblegum,
    Category.science,
    Level.grade2,
    Level.grade5,
  ),
  ecosystems(
    'Ecosystems',
    '🌳',
    AppColors.mint,
    Category.science,
    Level.grade3,
    Level.grade5,
  ),

  // ---------------------------------------------------------------- puzzles
  matchPairs(
    'Match Pairs',
    '🃏',
    AppColors.bubblegum,
    Category.puzzles,
    Level.preK,
    Level.preK,
  ),
  oddOneOut(
    'Odd One Out',
    '🙃',
    AppColors.sunshine,
    Category.puzzles,
    Level.preK,
    Level.grade2,
  ),
  shadows(
    'Shadow Match',
    '🌑',
    AppColors.grape,
    Category.puzzles,
    Level.preK,
    Level.kindergarten,
  ),
  patterns(
    'What Comes Next?',
    '🔁',
    AppColors.mint,
    Category.puzzles,
    Level.preK,
    Level.grade5,
  ),
  sudoku(
    'Mini Sudoku',
    '🔲',
    AppColors.sky,
    Category.puzzles,
    Level.kindergarten,
    Level.grade5,
  ),
  riddles(
    'Number Riddles',
    '🕵️',
    AppColors.tangerine,
    Category.puzzles,
    Level.grade1,
    Level.grade5,
  ),
  missingNumber(
    'Missing Number',
    '❓',
    AppColors.bubblegum,
    Category.puzzles,
    Level.grade2,
    Level.grade5,
  ),

  // ---------------------------------------------------------------- writing
  tracing(
    'Trace & Write',
    '✏️',
    AppColors.tangerine,
    Category.writing,
    Level.preK,
    Level.grade1,
  ),
  spelling(
    'Spell It',
    '🐝',
    AppColors.bubblegum,
    Category.writing,
    Level.kindergarten,
    Level.grade5,
  ),
  fixSentence(
    'Fix the Sentence',
    '✍️',
    AppColors.grape,
    Category.writing,
    Level.grade1,
    Level.grade5,
  ),

  // ------------------------------------------------- learning-session quiz
  /// Quiz after the daily learning session; not part of the regular rotation.
  // ------------------------------------------- toddlers (Age 2 & 3)
  // Picture answers, every question read aloud; letters and numbers only
  // in their own activities. The daily core for Age 2–3 is tLetters,
  // tNumbers, tTheme (+ tracing for Age 3); the rest are Age 3 bonus play.
  tFindIt(
    'Find It!',
    '🔍',
    AppColors.sky,
    Category.reading,
    Level.age3,
    Level.age3,
  ),
  tColors(
    'Colors',
    '🎨',
    AppColors.bubblegum,
    Category.math,
    Level.age3,
    Level.age3,
  ),
  tShapes(
    'Shapes',
    '🔷',
    AppColors.grape,
    Category.math,
    Level.age3,
    Level.age3,
  ),
  tSounds(
    'Who Says That?',
    '🐮',
    AppColors.lime,
    Category.science,
    Level.age3,
    Level.age3,
  ),
  tBigSmall(
    'Big & Small',
    '🐘',
    AppColors.tangerine,
    Category.math,
    Level.age3,
    Level.age3,
  ),
  tSame(
    'Same Same',
    '🃏',
    AppColors.mint,
    Category.puzzles,
    Level.age3,
    Level.age3,
  ),
  tBody(
    'My Body',
    '✋',
    AppColors.bubblegum,
    Category.science,
    Level.age3,
    Level.age3,
  ),
  tCount(
    'Count with Me',
    '🍎',
    AppColors.sky,
    Category.math,
    Level.age3,
    Level.age3,
  ),
  tShadows(
    'Shadow Play',
    '🌙',
    AppColors.grape,
    Category.puzzles,
    Level.age3,
    Level.age3,
  ),
  tDifferent(
    'Which Is Different?',
    '❓',
    AppColors.tangerine,
    Category.puzzles,
    Level.age3,
    Level.age3,
  ),
  tHomes(
    'Where Do I Live?',
    '🏠',
    AppColors.lime,
    Category.science,
    Level.age3,
    Level.age3,
  ),
  // Today's letters and numbers (see daily_focus.dart): every day for
  // Age 2 and Age 3.
  tLetters(
    'Letters',
    '🔤',
    AppColors.tangerine,
    Category.reading,
    Level.age2,
    Level.age3,
  ),
  tNumbers(
    'Numbers',
    '🔢',
    AppColors.sky,
    Category.math,
    Level.age2,
    Level.age3,
  ),
  // ------------------------------------------------------------ geography
  landWater(
    'Land & Water',
    '🏔️',
    AppColors.lime,
    Category.geography,
    Level.preK,
    Level.grade2,
  ),
  continents(
    'Continents & Oceans',
    '🌍',
    AppColors.sky,
    Category.geography,
    Level.kindergarten,
    Level.grade5,
  ),
  mapSkills(
    'Map Skills',
    '🧭',
    AppColors.tangerine,
    Category.geography,
    Level.grade1,
    Level.grade5,
  ),
  flags(
    'Flags of the World',
    '🚩',
    AppColors.bubblegum,
    Category.geography,
    Level.grade1,
    Level.grade4,
  ),
  capitals(
    'Capital Cities',
    '🏛️',
    AppColors.grape,
    Category.geography,
    Level.grade3,
    Level.grade5,
  ),
  topicQuiz(
    'Learning Quiz',
    '🎓',
    AppColors.grape,
    Category.science,
    Level.age2,
    Level.grade5,
  ),
  // New kinds go last: a kind's position seeds its questions, so inserting
  // one earlier would reshuffle everyone's worksheets.
  // ----------------------------------- today's focus for Age 2 & 3
  tTheme(
    'Play Time',
    '🐾',
    AppColors.lime,
    Category.puzzles,
    Level.age2,
    Level.age3,
  ),
  // Age 3: trace today's letters and numbers.
  tTrace(
    'Trace',
    '✏️',
    AppColors.tangerine,
    Category.writing,
    Level.age3,
    Level.age3,
  ),
  // Yesterday's letters, numbers and theme items, once more.
  tReview(
    'Remember?',
    '🔁',
    AppColors.mint,
    Category.puzzles,
    Level.age2,
    Level.age3,
  );

  const WorksheetKind(
    this.title,
    this.emoji,
    this.color,
    this.category,
    this.min,
    this.max,
  );
  final String title;
  final String emoji;
  final Color color;
  final Category category;
  final Level min;
  final Level max;

  bool suits(Level level) => level.atLeast(min) && level.atMost(max);
}

enum ShapeKind {
  circle('circle'),
  square('square'),
  triangle('triangle'),
  star('star'),
  heart('heart'),
  diamond('diamond'),
  rectangle('rectangle'),
  oval('oval');

  const ShapeKind(this.label);
  final String label;
}

class Worksheet {
  const Worksheet({
    required this.id,
    required this.kind,
    required this.questions,
    this.level,
    String? title,
    String? emoji,
    Color? color,
  }) : _title = title,
       _emoji = emoji,
       _color = color;

  final String id;
  final WorksheetKind kind;
  final List<Question> questions;

  /// The difficulty this worksheet was generated at (may differ from the
  /// child's grade when difficulty adapts).
  final Level? level;

  final String? _title;
  final String? _emoji;
  final Color? _color;

  String get title => _title ?? kind.title;
  String get emoji => _emoji ?? kind.emoji;
  Color get color => _color ?? kind.color;
}

// ---------------------------------------------------------------- questions

sealed class Question {
  const Question();
}

/// Multiple-choice question: a prompt, a picture, and tappable answers.
class ChoiceQuestion extends Question {
  const ChoiceQuestion({
    required this.prompt,
    required this.visual,
    required this.choices,
    required this.answer,
    this.speech,
  });
  final String prompt;
  final Visual visual;
  final List<Choice> choices;
  final int answer;

  /// What is read aloud, in segments. Defaults to the prompt.
  final List<String>? speech;
  List<String> get speechSegments => speech ?? [prompt];
}

/// Finger-tracing question for letters, numbers and short words.
class TraceQuestion extends Question {
  const TraceQuestion({
    required this.glyph,
    required this.hint,
    required this.speech,
  });
  final String glyph;
  final String hint;
  final String speech;
}

/// A worked example shown before practice ("Let's learn!"): a picture,
/// a few steps read aloud, and a "Got it" button. Not scored.
class ExampleQuestion extends Question {
  const ExampleQuestion({
    required this.title,
    required this.visual,
    required this.steps,
  });
  final String title;
  final Visual visual;
  final List<String> steps;
}

/// Connect each item on the left with its partner on the right.
class MatchQuestion extends Question {
  const MatchQuestion({
    required this.prompt,
    required this.left,
    required this.right,
    required this.answers,
  });
  final String prompt;
  final List<MatchItem> left;
  final List<MatchItem> right;

  /// For each left item, the index of its partner in [right].
  final List<int> answers;
}

class MatchItem {
  const MatchItem(this.text, [this.emoji]);
  final String text;
  final String? emoji;
}

class Choice {
  const Choice.label(
    String this.label, {
    this.scale = 1,
    this.silhouette = false,
  }) : shape = null,
       color = null;
  const Choice.shape(ShapeKind this.shape, Color this.color)
    : label = null,
      scale = 1,
      silhouette = false;
  final String? label;
  final ShapeKind? shape;
  final Color? color;

  /// Relative size of the label (used for "big and small").
  final double scale;

  /// Draw the label as a black shadow shape.
  final bool silhouette;
}

// ------------------------------------------------------------------ visuals

sealed class Visual {
  const Visual();
}

class CountVisual extends Visual {
  const CountVisual(this.emoji, this.count);
  final String emoji;
  final int count;
}

/// A jumble of different pictures (e.g. count only the apples).
class MixedVisual extends Visual {
  const MixedVisual(this.items);
  final List<String> items;
}

class ShapeVisual extends Visual {
  const ShapeVisual(this.shape, this.color);
  final ShapeKind shape;
  final Color color;
}

class ColorVisual extends Visual {
  const ColorVisual(this.color, this.name);
  final Color color;
  final String name;
}

class EquationVisual extends Visual {
  const EquationVisual(this.a, this.b, {required this.op, this.emoji});
  final int a;
  final int b;

  /// One of + − × ÷
  final String op;

  /// When set, the sum is also drawn with pictures to count.
  final String? emoji;
}

class PatternVisual extends Visual {
  const PatternVisual(this.items);

  /// Sequence items; the final one is the blank to fill in.
  final List<String> items;
}

class WordPictureVisual extends Visual {
  const WordPictureVisual(this.emoji, this.word, this.missingIndex);
  final String emoji;
  final String word;
  final int missingIndex;
}

/// A big "listen" button: the question is heard, not read.
class ListenVisual extends Visual {
  const ListenVisual();
}

/// Letter tiles that light up as each sound is spoken.
class SoundOutVisual extends Visual {
  const SoundOutVisual(this.letters);
  final List<String> letters;
}

/// One big picture, optionally with a caption underneath.
class EmojiVisual extends Visual {
  const EmojiVisual(this.emoji, [this.caption]);
  final String emoji;
  final String? caption;
}

/// A card of text: a sentence, a riddle, a word problem.
class TextVisual extends Visual {
  const TextVisual(this.text, {this.emoji});
  final String text;
  final String? emoji;
}

class PassageVisual extends Visual {
  const PassageVisual(
    this.title,
    this.emoji,
    this.text, {
    this.readFirst = false,
  });
  final String title;
  final String emoji;
  final String text;

  /// Read the whole passage aloud before the question (for early readers).
  final bool readFirst;

  List<String> get sentences => text
      .split(RegExp(r'(?<=[.!?])\s+'))
      .where((s) => s.trim().isNotEmpty)
      .toList();
}

class ClockVisual extends Visual {
  const ClockVisual(this.hour, this.minute);
  final int hour;
  final int minute;
}

class CoinsVisual extends Visual {
  const CoinsVisual(this.coins);

  /// Coin values in cents (1, 5, 10, 25).
  final List<int> coins;
}

class FractionVisual extends Visual {
  const FractionVisual(this.parts, this.shaded, {this.bar = false});
  final int parts;
  final int shaded;
  final bool bar;
}

class ArrayVisual extends Visual {
  const ArrayVisual(this.emoji, this.rows, this.cols);
  final String emoji;
  final int rows;
  final int cols;
}

class RectVisual extends Visual {
  const RectVisual(this.width, this.height, {this.grid = true});
  final int width;
  final int height;

  /// Grid of unit squares (count them) vs. labelled side lengths.
  final bool grid;
}

class SudokuVisual extends Visual {
  const SudokuVisual(this.cells);

  /// 16 cells, row by row. '' is an empty cell; '?' is the cell to solve.
  final List<String> cells;
}

class ShadowVisual extends Visual {
  const ShadowVisual(this.emoji);
  final String emoji;
}

// ----------------------------------------------------------------- profiles

class Profile {
  const Profile({
    required this.id,
    required this.name,
    required this.avatar,
    required this.colorIndex,
    required this.level,
  });

  final String id;
  final String name;
  final String avatar;
  final int colorIndex;
  final Level level;

  Color get color =>
      AppColors.profileColors[colorIndex % AppColors.profileColors.length];

  Profile copyWith({
    String? name,
    String? avatar,
    int? colorIndex,
    Level? level,
  }) => Profile(
    id: id,
    name: name ?? this.name,
    avatar: avatar ?? this.avatar,
    colorIndex: colorIndex ?? this.colorIndex,
    level: level ?? this.level,
  );

  Map<String, Object> toJson() => {
    'id': id,
    'name': name,
    'avatar': avatar,
    'color': colorIndex,
    'level': level.name,
  };

  /// Older versions stored broad age groups; map them onto levels.
  static const _legacyAges = {
    'toddler': Level.age3,
    'preschool': Level.preK,
    'school': Level.grade1,
  };

  factory Profile.fromJson(Map<String, dynamic> j) => Profile(
    id: j['id'] as String,
    name: j['name'] as String,
    avatar: j['avatar'] as String,
    colorIndex: j['color'] as int,
    level:
        Level.values.asNameMap()[j['level']] ??
        _legacyAges[j['age']] ??
        Level.preK,
  );
}
