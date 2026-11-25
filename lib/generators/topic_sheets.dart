import 'dart:math';

import '../content/daily_focus.dart';
import '../content/science.dart' show Fact;
import '../content/topic_depth.dart';
import '../content/topics.dart';
import '../models/generator.dart' show dayKey;
import '../models/models.dart';
import 'gen.dart';
import 'toddler_sheets.dart';

/// Topics grouped into families, so "Which one is NOT a …?" never picks
/// something that arguably belongs (a chicken is not a "wild animal", but
/// it is still an animal, so animal topics never borrow from each other).
const _family = {
  'farm': 'animals',
  'wild': 'animals',
  'ocean': 'animals',
  'bugs': 'animals',
  'birds': 'animals',
  'fruits': 'food',
  'veggies': 'food',
};

String _familyOf(Topic t) => _family[t.id] ?? t.id;

/// One learning topic per day, rotating through all topics.
Topic topicForDay(DateTime date) {
  final day = dayNumber(date);
  final pool = [
    for (final t in topics)
      if (!t.toddlerOnly) t,
  ];
  return pool[day % pool.length];
}

/// Today's learning sessions: for Age 2–3, today's letters, numbers and
/// theme (see [ToddlerFocus]); for everyone else one topic, rotating
/// through all of them.
List<Topic> topicsForDay(DateTime date, Level level) =>
    level.atMost(Level.age3)
    ? ToddlerFocus.of(date, level).topics
    : [topicForDay(date)];

String topicQuizId(DateTime date, Topic t) => '${dayKey(date)}_topic_${t.id}';

const _yesNo = ['Yes ✅', 'No ❌'];

/// The "Did you know?" fact on a card, for Grade 2 and up (null below).
String? deeperFact(Topic t, TopicItem i, Level level) {
  if (!level.atLeast(Level.grade2)) return null;
  return deeperFacts[t.id]?[i.name];
}

/// The topic's harder questions that suit [level] (at least 6, borrowing the
/// nearest grades when needed).
List<Fact> _bankFor(Topic t, Level level) {
  final bank = topicQuestions[t.id] ?? const <Fact>[];
  final pool = bank.where((f) => f.suits(level)).toList();
  if (pool.length >= 6 || bank.length <= pool.length) return pool;
  int distance(Fact f) => level.index < f.min.index
      ? f.min.index - level.index
      : level.index - f.max.index;
  final rest = bank.where((f) => !pool.contains(f)).toList()
    ..sort((a, b) => distance(a) - distance(b));
  return [...pool, ...rest.take(6 - pool.length)];
}

/// A quiz on everything learned in the topic. It grows up with the child:
/// Pre-K and K match pictures and names; Grade 1–2 add questions that go
/// beyond the cards; from Grade 3 the picture games drop away and the quiz
/// is mostly reasoning about the topic (plant parts, life cycles, science
/// words), with the "Did you know?" facts as clues.
List<Question> topicQuiz(Gen g, Topic t) {
  if (g.atMost(Level.age3)) return toddlerTopicQuiz(g, t);
  final items = t.items;
  final young = g.atMost(Level.kindergarten);
  final older = g.atLeast(Level.grade3);
  final n = older ? 4 : (g.atMost(Level.age3) ? 3 : 4);
  final names = {for (final i in items) i.name.toLowerCase()};
  final emojis = {for (final i in items) i.emoji};
  final intruders = [
    for (final other in topics)
      if (_familyOf(other) != _familyOf(t))
        for (final i in other.items)
          if (!names.contains(i.name.toLowerCase()) &&
              !emojis.contains(i.emoji))
            i,
  ];
  final bank = young ? const <Fact>[] : _bankFor(t, g.level);
  final fillable = bank.where((f) => f.question.endsWith('…')).toList();
  String clue(TopicItem i) => deeperFact(t, i, g.level) ?? i.fact;

  Question bankChoice() {
    final f = g.one(bank);
    return g.choice(
      prompt: f.question,
      visual: EmojiVisual(f.emoji),
      answer: f.answer,
      wrong: f.wrong,
    );
  }

  final match = older
      ? null
      : g.keep(
          g.match('Match each ${t.kindOf} to its name!', [
            for (final i in g.pick(items, min(Gen.matchCount, items.length)))
              (MatchItem(i.name), MatchItem('', i.emoji)),
          ]),
        );

  final rest = g.mix(g.count, [
    if (t.pictureQuiz && young)
      () {
        final i = g.one(items);
        return g.choice(
          prompt: 'Find the ${i.name.toLowerCase()}!',
          visual: const ListenVisual(),
          answer: i.emoji,
          wrong: emojis,
          count: n,
        );
      },
    if (t.pictureQuiz && g.atMost(Level.grade1))
      () {
        final i = g.one(items);
        return g.choice(
          prompt: 'What is this?',
          visual: EmojiVisual(i.emoji),
          answer: i.name,
          wrong: items.map((x) => x.name),
          count: n,
        );
      },
    () {
      final i = g.one(items);
      final c = clue(i);
      return g.choice(
        prompt: 'Who am I?',
        visual: TextVisual('"$c"', emoji: '🕵️'),
        answer: i.name,
        wrong: items.map((x) => x.name),
        count: n,
        speech: [c, 'Who am I?'],
      );
    },
    () {
      final odd = g.one(intruders);
      final usePictures = t.pictureQuiz && young;
      return g.choice(
        prompt: 'Which one is NOT a ${t.kindOf}?',
        visual: EmojiVisual(t.emoji),
        answer: usePictures ? odd.emoji : odd.name,
        wrong: [
          for (final i in g.pick(items, 3)) usePictures ? i.emoji : i.name,
        ],
        count: 4,
      );
    },
    () {
      final i = g.one(items);
      final right = g.chance(.5);
      final shown = right ? i : g.one(items.where((x) => x != i).toList());
      final c = clue(i);
      return g.choice(
        prompt: 'Is this true?',
        visual: TextVisual('${shown.name}: "$c"', emoji: shown.emoji),
        answer: right ? _yesNo[0] : _yesNo[1],
        wrong: _yesNo,
        speech: ['${shown.name}. $c Is this true?'],
      );
    },
    // Questions beyond the cards — more of them as children get older.
    if (bank.isNotEmpty) bankChoice,
    if (bank.isNotEmpty && g.atLeast(Level.grade2)) bankChoice,
    if (bank.isNotEmpty && older) bankChoice,
    if (fillable.isNotEmpty && older)
      () {
        final f = g.one(fillable);
        return g.choice(
          prompt: 'Fill in the blank!',
          visual: TextVisual(
            '${f.question.replaceAll('…', '')} ______.',
            emoji: f.emoji,
          ),
          answer: f.answer,
          wrong: f.wrong,
          speech: ['${f.question.replaceAll('…', '')} blank.'],
        );
      },
  ]);
  return [?match, ...rest];
}
