// "Learn more": learning sessions children can open any time, below
// Today's Plan. Each level gets the topics that suit it, and the list grows
// with the child:
//
// - Age 2:  letters, numbers 1–5, shapes, colors, farm animals
// - Age 3:  + numbers to 10, wild animals, fruits
// - Pre-K:  + sight words and three-letter words (with their sounds read
//           aloud), ocean animals, my body, a few countries
// - K:      words, nature, helpers and more countries; the toddler basics
//           (letters, numbers, shapes, colors) drop away
// - Grade 1: space, continents, land & water, sports
// - Grade 2+: every topic, with "Did you know?" facts from Grade 2

import 'dart:math';

import '../content/daily_focus.dart';
import '../content/reading.dart';
import '../content/topics.dart';
import '../models/generator.dart' show dayKey;
import '../models/models.dart';
import '../theme.dart';
import 'gen.dart';
import 'toddler_sheets.dart';
import 'topic_sheets.dart';

/// One "Learn more" session: its cards, and the game played after them.
class LearnMore {
  const LearnMore(this.topic, this.quiz);
  final Topic topic;
  final List<Question> Function(Gen g) quiz;
}

/// Quiz id for a "Learn more" session (kept apart from today's sessions,
/// which can share a topic).
String learnMoreQuizId(DateTime date, Topic t) =>
    '${dayKey(date)}_topic_more_${t.id}';

Topic _t(String id) => topics.firstWhere((t) => t.id == id);

/// [t] with only the items we have drawings for (what toddlers see).
Topic _drawnOnly(Topic t, {int? take}) {
  final items = [
    for (final i in t.items)
      if (isDrawn(i.emoji))
        TopicItem(
          i.name,
          i.emoji,
          i.fact,
          picture: i.picture,
          from: i.from ?? t.id,
        ),
  ];
  return _with(t, take == null ? items : items.take(take).toList());
}

Topic _with(Topic t, List<TopicItem> items, {String? id, String? title}) =>
    Topic(
      id ?? t.id,
      title ?? t.title,
      t.emoji,
      t.color,
      t.kindOf,
      items,
      pictureQuiz: t.pictureQuiz,
      toddlerOnly: t.toddlerOnly,
    );

/// Toddler games, also used for Pre-K's letters, numbers, shapes and colors.
Gen _toddlerGen(Gen g) => g.level.atMost(Level.age3) ? g : Gen(g.r, Level.age3);

LearnMore _letters(String id) {
  final t = _t(id);
  return LearnMore(
    t,
    (g) => tLetters(_toddlerGen(g), ToddlerFocus.custom(letters: t.items)),
  );
}

LearnMore _numbers(int upTo) {
  final t = _t('numbers');
  final items = t.items.take(upTo).toList();
  return LearnMore(
    _with(t, items, title: 'Numbers 1 to $upTo'),
    (g) => tNumbers(_toddlerGen(g), ToddlerFocus.custom(numbers: items)),
  );
}

LearnMore _theme(ToddlerTheme theme, {Topic? from}) {
  final items = from?.items ?? theme.pool;
  final t =
      from ??
      Topic(
        theme.name,
        theme.title,
        theme.emoji,
        theme.color,
        theme.kindOf,
        items,
      );
  return LearnMore(
    t,
    (g) =>
        tTheme(_toddlerGen(g), ToddlerFocus.custom(theme: theme, items: items)),
  );
}

/// An ordinary topic with its usual quiz (cards + "Who am I?" and so on).
LearnMore _topic(String id, {int? take}) {
  final t = _t(id);
  final topic = take == null ? t : _with(t, t.items.take(take).toList());
  return LearnMore(topic, (g) => topicQuiz(g, topic));
}

// ----------------------------------------------------------------- words

/// Sight-word cards: the word, spelled out, then said again.
LearnMore _sightWords(List<String> words) {
  final items = [
    for (final w in words)
      TopicItem(
        w,
        w,
        'Spell it: ${w.split('').join(' · ')}',
        say: [w, ...w.toUpperCase().split(''), w],
      ),
  ];
  final topic = Topic(
    'sightwords',
    'Sight Words',
    '👀',
    AppColors.bubblegum,
    'word',
    items,
  );
  return LearnMore(topic, (g) {
    List<String> lookAlikes(String w) => [
      for (final x in words)
        if (x != w && (x.length - w.length).abs() <= 1) x,
    ];
    return g.mix(5, [
      () {
        final w = g.one(words);
        return g.choice(
          prompt: 'Tap the word you hear!',
          visual: const ListenVisual(),
          answer: w,
          wrong: words,
          count: 3,
          speech: ['Find the word… $w.', w],
        );
      },
      () {
        final w = g.one(words);
        final near = lookAlikes(w);
        return g.choice(
          prompt: 'Find the same word!',
          visual: TextVisual(w),
          answer: w,
          wrong: near.length >= 2 ? near : words,
          count: 3,
          speech: ['This word is $w. Find the same word!'],
        );
      },
      () {
        final w = g.one(words.where((x) => x.length > 1).toList());
        return g.choice(
          prompt: 'Which word is this?',
          visual: TextVisual(w.split('').join(' - ')),
          answer: w,
          wrong: words,
          count: 3,
          speech: [...w.toUpperCase().split(''), 'Which word is this?'],
        );
      },
    ]);
  });
}

/// Three-letter word cards: picture, word, and its sounds read aloud.
LearnMore _cvcWords(List<(String, String)> words) {
  List<String> sounds(String spelled) => [
    for (final p in spelled.split('-')) letterSounds[p] ?? p,
  ];
  final items = [
    for (final (emoji, spelled) in words)
      TopicItem(
        spelled.replaceAll('-', ''),
        emoji,
        'Sound it out: ${spelled.split('-').join(' … ')}',
        say: [
          spelled.replaceAll('-', ''),
          ...sounds(spelled),
          spelled.replaceAll('-', ''),
        ],
      ),
  ];
  final topic = Topic(
    'words3',
    'Three-Letter Words',
    '📖',
    AppColors.sky,
    'word',
    items,
  );
  return LearnMore(topic, (g) {
    return g.mix(5, [
      () {
        final (emoji, spelled) = g.one(words);
        return g.choice(
          prompt: 'Sound it out!',
          visual: SoundOutVisual(spelled.split('-')),
          answer: emoji,
          wrong: words.map((w) => w.$1),
          count: 3,
          speech: [...sounds(spelled), 'What word is that? Tap the picture!'],
        );
      },
      () {
        final (emoji, spelled) = g.one(words);
        return g.choice(
          prompt: 'Which word matches the picture?',
          visual: EmojiVisual(emoji),
          answer: spelled.replaceAll('-', ''),
          wrong: words.map((w) => w.$2.replaceAll('-', '')),
          count: 3,
        );
      },
      () {
        final (emoji, spelled) = g.one(words);
        final word = spelled.replaceAll('-', '');
        return g.choice(
          prompt: 'Find the word you hear!',
          visual: const ListenVisual(),
          answer: word,
          wrong: words.map((w) => w.$2.replaceAll('-', '')),
          count: 3,
          speech: ['Find the word… $word.', word],
        );
      },
    ]);
  });
}

/// The words a Pre-K child has met in the last few days (today's words
/// come round in the daily sheets; this lets them look back).
List<X> _recent<X>(List<X> all, int day, int perDay, int days) {
  final out = <X>[];
  for (var d = day - days + 1; d <= day; d++) {
    for (var i = 0; i < perDay; i++) {
      final w = all[((d * perDay + i) % all.length + all.length) % all.length];
      if (!out.contains(w)) out.add(w);
    }
  }
  return out;
}

/// A window of [n] items that moves on every week.
List<X> _weekly<X>(List<X> all, int day, int n) {
  final start = (day ~/ 7) * n;
  return [
    for (var i = 0; i < min(n, all.length); i++) all[(start + i) % all.length],
  ];
}

// ---------------------------------------------------------------- ladder

/// The "Learn more" sessions for [level] on [date].
List<LearnMore> learnMoreFor(Level level, DateTime date) {
  final day = dayNumber(date);
  final toddlerBasics = [
    _letters('abc1'),
    _letters('abc2'),
    _numbers(level == Level.age2 ? 5 : 10),
    _theme(ToddlerTheme.shapes),
    _theme(ToddlerTheme.colors),
    _theme(ToddlerTheme.animals, from: _drawnOnly(_t('farm'))),
  ];
  return switch (level) {
    Level.age2 => toddlerBasics,
    Level.age3 => [
      ...toddlerBasics,
      _theme(ToddlerTheme.animals, from: _drawnOnly(_t('wild'))),
      _theme(ToddlerTheme.food, from: _drawnOnly(_t('fruits'))),
    ],
    Level.preK => [
      _sightWords(_recent(preKSightWords, day, 2, 5)),
      _cvcWords(_recent(soundOutWords, day, 2, 4)),
      ...toddlerBasics,
      _topic('wild'),
      _topic('ocean'),
      _topic('body'),
      _topic('countries', take: 6),
    ],
    Level.kindergarten => [
      _sightWords(_weekly(sightWordsByLevel[Level.kindergarten]!, day, 10)),
      _cvcWords(_weekly(soundOutWords, day, 8)),
      for (final id in [
        'body', 'fruits', 'veggies', 'wild', 'ocean', 'bugs', //
        'birds', 'vehicles', 'helpers',
      ])
        _topic(id),
      _topic('countries', take: 8),
    ],
    Level.grade1 => [
      _sightWords(_weekly(sightWordsByLevel[Level.grade1]!, day, 10)),
      for (final id in [
        'space', 'continents', 'countries', 'land', 'body', 'ocean', //
        'bugs', 'birds', 'helpers', 'sports', 'veggies',
      ])
        _topic(id),
    ],
    _ => [
      if (level == Level.grade2)
        _sightWords(_weekly(sightWordsByLevel[Level.grade2]!, day, 10)),
      for (final t in topics)
        if (!t.toddlerOnly && t.id != 'colors' && t.id != 'farm') _topic(t.id),
    ],
  };
}
