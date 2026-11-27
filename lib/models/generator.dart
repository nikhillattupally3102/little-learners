import 'dart:math';

import '../content/daily_focus.dart';
import '../content/science.dart';
import '../content/topics.dart';
import '../generators/gen.dart';
import '../generators/learn_more.dart';
import '../generators/lessons.dart';
import '../generators/geography_sheets.dart';
import '../generators/math_formats.dart';
import '../generators/math_sheets.dart';
import '../generators/puzzle_writing_sheets.dart';
import '../generators/reading_sheets.dart';
import '../generators/science_sheets.dart';
import '../generators/thinking_sheets.dart';
import '../generators/toddler_sheets.dart';
import '../generators/topic_sheets.dart';
import 'models.dart';

String dayKey(DateTime d) =>
    '${d.year}${d.month.toString().padLeft(2, '0')}${d.day.toString().padLeft(2, '0')}';

/// Builds fresh, deterministic worksheets for each day and level.
/// The same day always produces the same worksheets, so progress is stable.
class WorksheetGenerator {
  /// Today's set: a few worksheets from each category, rotating daily so every
  /// kind of worksheet comes round regularly.
  ///
  /// [levelFor] lets each worksheet be generated at an adapted difficulty.
  ///
  /// [avoid] holds fingerprints of questions this child saw on earlier days
  /// (see [Gen.fingerprints]); fresh questions are preferred over those.
  static List<Worksheet> forDay(
    DateTime date,
    Level level, {
    Level Function(WorksheetKind)? levelFor,
    Set<String> avoid = const {},
  }) {
    final result = <Worksheet>[];
    // Today's learning quiz opens with a matching round; allow one more
    // matching round across the worksheets, so matching stays special.
    var matchBudget = 1;
    for (final kind in kindsForDay(date, level)) {
      final ws = build(
        date,
        // The GT test is always at the child's own level.
        kind.weeklyOnly ? level : levelFor?.call(kind) ?? level,
        kind,
        avoid: avoid,
        maxMatches: matchBudget > 0 || _needsMatch(kind) ? 1 : 0,
      );
      matchBudget -= ws.questions.whereType<MatchQuestion>().length;
      result.add(ws);
    }
    return result;
  }

  /// Kinds whose whole point is matching.
  static bool _needsMatch(WorksheetKind kind) =>
      const {WorksheetKind.matchPairs, WorksheetKind.wordMatch}.contains(kind);

  static int _day(DateTime date) => dayNumber(date);

  /// The weekly GT test is on Sundays.
  static bool isGtDay(DateTime date) => date.weekday == DateTime.sunday;

  /// Whether [date] is a GT test day for [level] (Sundays, K–5): the test
  /// is the only thing on the plan, with no learning session or bonus.
  static bool gtDayFor(DateTime date, Level level) =>
      isGtDay(date) && level.kinds.contains(WorksheetKind.gtTest);

  /// Toddlers' plan is the same shape every day — only its content
  /// (today's letters, numbers and theme) changes. Mostly learning: Age 2
  /// has just its 3 learning sessions (each ending in a few games); Age 3
  /// adds tracing and a review of yesterday (5 tiles).
  static const _toddlerPlan = {
    Level.age2: <WorksheetKind>[],
    Level.age3: [WorksheetKind.tTrace, WorksheetKind.tReview],
  };

  /// Pre-K: the learning session plus these 4 every day (5 tiles). Kinds in
  /// one slot take turns, one per day.
  static const _core = {
    Level.preK: [
      [WorksheetKind.addition, WorksheetKind.subtraction],
      [WorksheetKind.sightWords],
      [WorksheetKind.soundOut],
      [WorksheetKind.tracing],
    ],
  };

  /// K–Grade 5: subjects on every day's plan, and how many more subjects
  /// take turns (from [_rotating]). With the learning session: K 5 tiles,
  /// Grades 1–2 6, Grade 3 7, Grades 4–5 8.
  static const _gradePlan = <Level, (List<Category>, int)>{
    Level.kindergarten: ([Category.math, Category.reading], 2),
    Level.grade1: ([Category.math, Category.reading, Category.science], 2),
    Level.grade2: ([Category.math, Category.reading, Category.science], 2),
    Level.grade3: ([Category.math, Category.reading, Category.science], 3),
    Level.grade4: (
      [Category.math, Category.math, Category.reading, Category.science],
      3,
    ),
    Level.grade5: (
      [Category.math, Category.math, Category.reading, Category.science],
      3,
    ),
  };

  /// Subjects that take turns on the grade plans.
  static const _rotating = [
    Category.science,
    Category.puzzles,
    Category.writing,
    Category.geography,
    Category.thinking,
  ];

  static List<WorksheetKind> kindsForDay(DateTime date, Level level) {
    // Sundays (K–5): the weekly GT test is the whole day's work.
    if (gtDayFor(date, level)) return const [WorksheetKind.gtTest];
    final toddler = _toddlerPlan[level];
    if (toddler != null) return toddler;
    final day = _day(date);
    final core = _core[level];
    if (core != null) return [for (final slot in core) slot[day % slot.length]];
    final (fixed, extra) = _gradePlan[level]!;
    final turns = [
      for (final c in _rotating)
        if (!fixed.contains(c)) c,
    ];
    final categories = [
      ...fixed,
      for (var i = 0; i < extra; i++) turns[(day * extra + i) % turns.length],
    ];
    // Each subject's kinds take turns too (two math sheets: two different).
    final kinds = <WorksheetKind>[];
    for (final category in Category.values) {
      final times = categories.where((c) => c == category).length;
      if (times == 0) continue;
      final pool = [
        for (final k in level.kinds)
          if (k.category == category && !k.weeklyOnly) k,
      ]..shuffle(Random(level.index * 13 + category.index));
      for (var i = 0; i < min(times, pool.length); i++) {
        kinds.add(pool[(day * times + i) % pool.length]);
      }
    }
    return kinds;
  }

  /// Extra worksheets offered once today's plan is finished: kinds that are
  /// not on today's plan, one from each category.
  static List<Worksheet> bonusForDay(
    DateTime date,
    Level level, {
    Level Function(WorksheetKind)? levelFor,
    Set<String> avoid = const {},
    int count = 3,
  }) {
    if (level == Level.age2) return const []; // learning only
    if (gtDayFor(date, level)) return const []; // just the GT test
    final today = {
      ...kindsForDay(date, level),
      // Today's focus games are already in the learning sessions.
      WorksheetKind.tLetters,
      WorksheetKind.tNumbers,
      WorksheetKind.tTheme,
    };
    final day = _day(date);
    final out = <Worksheet>[];
    final categories = [...Category.values]..shuffle(Random(day));
    for (final category in categories) {
      final pool = [
        for (final k in level.kinds)
          if (k.category == category && !today.contains(k) && !k.weeklyOnly) k,
      ];
      if (pool.isEmpty) continue;
      final kind = pool[day % pool.length];
      out.add(build(date, levelFor?.call(kind) ?? level, kind, avoid: avoid));
      if (out.length == count) break;
    }
    return out;
  }

  /// Progress is stored per child, so the id doesn't include the level: a
  /// worksheet keeps its stars even if its difficulty adapts later that day.
  static String idFor(DateTime date, WorksheetKind kind) =>
      '${dayKey(date)}_${kind.name}';

  /// The quiz for a learning topic (today's or any other from the library).
  static Worksheet buildTopicQuiz(
    DateTime date,
    Level level,
    Topic topic, {
    Set<String> avoid = const {},
  }) {
    final g = Gen(
      Random(
        int.parse(dayKey(date)) * 31 +
            level.index * 7919 +
            Gen.stableHash(topic.id) % 1000,
      ),
      level,
      avoid: avoid,
    );
    // Toddlers play with today's letters, numbers or theme items, each
    // shown a different way, right after learning them.
    final focus = level.atMost(Level.age3) && topic.toddlerOnly
        ? ToddlerFocus.of(date, level)
        : null;
    final questions = switch (focus) {
      null => topicQuiz(g, topic),
      _ when topic.id == 'abc' => tLetters(g, focus),
      _ when topic.id == 'numbers' => tNumbers(g, focus),
      _ when topic.id == focus.theme.name => tTheme(g, focus),
      _ => topicQuiz(g, topic),
    };
    return Worksheet(
      id: topicQuizId(date, topic),
      kind: WorksheetKind.topicQuiz,
      questions: questions,
      level: level,
      title: '${topic.title} Quiz',
      emoji: topic.emoji,
      color: topic.color,
    );
  }

  /// The game after a "Learn more" session.
  static Worksheet buildLearnMoreQuiz(
    DateTime date,
    Level level,
    LearnMore more, {
    Set<String> avoid = const {},
  }) {
    final topic = more.topic;
    final g = Gen(
      Random(
        int.parse(dayKey(date)) * 31 +
            level.index * 7919 +
            Gen.stableHash('more_${topic.id}') % 1000,
      ),
      level,
      avoid: avoid,
    );
    return Worksheet(
      id: learnMoreQuizId(date, topic),
      kind: WorksheetKind.topicQuiz,
      questions: more.quiz(g),
      level: level,
      title: level.atMost(Level.age3) ? topic.title : '${topic.title} Quiz',
      emoji: topic.emoji,
      color: topic.color,
    );
  }

  static Worksheet build(
    DateTime date,
    Level level,
    WorksheetKind kind, {
    Set<String> avoid = const {},
    int maxMatches = 1,
  }) {
    if (kind == WorksheetKind.topicQuiz) {
      return buildTopicQuiz(date, level, topicForDay(date), avoid: avoid);
    }
    final key = dayKey(date);
    final toddler = level.atMost(Level.age3)
        ? ToddlerFocus.of(date, level)
        : null;
    final preK = level == Level.preK ? PreKWords.of(date) : null;
    final g = Gen(
      Random(int.parse(key) * 31 + level.index * 7919 + kind.index * 131),
      level,
      avoid: avoid,
      maxMatches: maxMatches,
    );
    final questions = switch (kind) {
      WorksheetKind.counting => counting(g),
      WorksheetKind.shapes => shapes(g),
      WorksheetKind.sizes => sizes(g),
      WorksheetKind.moreLess => moreLess(g),
      WorksheetKind.numberFind => numberFind(g),
      WorksheetKind.addition => addition(g),
      WorksheetKind.subtraction => subtraction(g),
      WorksheetKind.compareNumbers => compareNumbers(g),
      WorksheetKind.placeValue => placeValue(g),
      WorksheetKind.time => time(g),
      WorksheetKind.money => money(g),
      WorksheetKind.multiplication => multiplication(g),
      WorksheetKind.division => division(g),
      WorksheetKind.fractions => fractions(g),
      WorksheetKind.wordProblems => wordProblems(g),
      WorksheetKind.area => area(g),
      WorksheetKind.rounding => rounding(g),
      WorksheetKind.decimals => decimals(g),
      WorksheetKind.listen => listen(g),
      WorksheetKind.letters => letters(g),
      WorksheetKind.abcOrder => abcOrder(g),
      WorksheetKind.soundOut => soundOut(g, today: preK),
      WorksheetKind.rhymes => rhymes(g),
      WorksheetKind.wordMatch => wordMatch(g),
      WorksheetKind.opposites => opposites(g),
      WorksheetKind.sightWords => sightWords(g, today: preK),
      WorksheetKind.syllables => syllables(g),
      WorksheetKind.comprehension => comprehension(g),
      WorksheetKind.grammar => grammar(g),
      WorksheetKind.compoundWords => compounds(g),
      WorksheetKind.fillGap => fillGap(g),
      WorksheetKind.wordMeanings => wordMeanings(g),
      WorksheetKind.homophones => homophones(g),
      WorksheetKind.wordParts => wordPartsSheet(g),
      WorksheetKind.animalSounds => animalSoundsSheet(g),
      WorksheetKind.myBody => facts(g, myBodyFacts),
      WorksheetKind.weather => facts(g, weatherFacts),
      WorksheetKind.animalHomes => animalHomesSheet(g),
      WorksheetKind.babyAnimals => babyAnimalsSheet(g),
      WorksheetKind.sinkFloat => sinkFloat(g),
      WorksheetKind.livingThings => livingThings(g),
      WorksheetKind.animalGroups => animalGroups(g),
      WorksheetKind.plants => facts(g, plantFacts),
      WorksheetKind.lifeCycles => facts(g, lifeCycleFacts),
      WorksheetKind.matter => facts(g, matterFacts),
      WorksheetKind.space => facts(g, spaceFacts),
      WorksheetKind.humanBody => facts(g, humanBodyFacts),
      WorksheetKind.earth => facts(g, earthFacts),
      WorksheetKind.forces => facts(g, forceFacts),
      WorksheetKind.ecosystems => facts(g, ecosystemFacts),
      WorksheetKind.matchPairs => matchPairs(g),
      WorksheetKind.oddOneOut => oddOneOut(g),
      WorksheetKind.shadows => shadows(g),
      WorksheetKind.patterns => patterns(g),
      WorksheetKind.sudoku => sudoku(g),
      WorksheetKind.riddles => riddles(g),
      WorksheetKind.missingNumber => missingNumber(g),
      WorksheetKind.tracing => tracing(g, today: preK),
      WorksheetKind.spelling => spelling(g),
      WorksheetKind.fixSentence => fixSentence(g),
      WorksheetKind.tFindIt => tFindIt(g),
      WorksheetKind.tColors => tColors(g),
      WorksheetKind.tShapes => tShapes(g),
      WorksheetKind.tSounds => tSounds(g),
      WorksheetKind.tBigSmall => tBigSmall(g),
      WorksheetKind.tSame => tSame(g),
      WorksheetKind.tBody => tBody(g),
      WorksheetKind.tCount => tCount(g),
      WorksheetKind.tShadows => tShadows(g),
      WorksheetKind.tDifferent => tDifferent(g),
      WorksheetKind.tHomes => tHomes(g),
      WorksheetKind.tLetters => tLetters(g, toddler!),
      WorksheetKind.tNumbers => tNumbers(g, toddler!),
      WorksheetKind.tTheme => tTheme(g, toddler!),
      WorksheetKind.tTrace => tTrace(g, toddler!),
      WorksheetKind.tReview => tReview(
        g,
        ToddlerFocus.of(date.subtract(const Duration(days: 1)), level),
      ),
      WorksheetKind.landWater => landWater(g),
      WorksheetKind.continents => continents(g),
      WorksheetKind.mapSkills => mapSkills(g),
      WorksheetKind.flags => flags(g),
      WorksheetKind.capitals => capitals(g),
      WorksheetKind.topicQuiz => <Question>[],
      WorksheetKind.wordThinking => wordThinking(g),
      WorksheetKind.numberThinking => numberThinking(g),
      WorksheetKind.shapeThinking => shapeThinking(g),
      WorksheetKind.gtTest => gtTest(g),
    };
    return Worksheet(
      id: idFor(date, kind),
      kind: kind,
      questions: questions,
      level: level,
      lesson: hasLesson(kind, level)
          ? lessonFor(
              kind,
              questions,
              Gen(
                Random(int.parse(key) * 37 + level.index * 101 + kind.index),
                level,
              ),
            )
          : const [],
      // Toddler sheets are named after what they practise today.
      title: switch (kind) {
        WorksheetKind.tLetters => 'Letters ${toddler!.letterNames}',
        WorksheetKind.tNumbers => 'Numbers ${toddler!.numberNames}',
        WorksheetKind.tTheme => toddler!.theme.title,
        WorksheetKind.tTrace =>
          'Trace ${toddler!.letterNames} · ${toddler.numberNames}',
        _ => null,
      },
      emoji: kind == WorksheetKind.tTheme ? toddler!.theme.emoji : null,
      color: kind == WorksheetKind.tTheme ? toddler!.theme.color : null,
    );
  }
}
