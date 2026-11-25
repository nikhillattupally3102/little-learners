// "Today's focus": a small, fixed set of things each young level works on
// for the day, shared by the learning cards and the worksheets so a child
// meets the same letters, numbers, things and words in several ways.
//
// - Age 2–3: today's letters, today's numbers, and today's theme (6 animals,
//   or 6 colors, or 6 shapes…). The theme changes every day, and when a
//   theme comes back it brings the next 6 items, so nothing repeats on the
//   following day.
// - Pre-K: today's sight words and three-letter words (plus yesterday's,
//   for review); reading and tracing sheets use only these.

import 'dart:math';

import 'package:flutter/painting.dart' show Color;

import '../models/models.dart';
import '../theme.dart';
import '../widgets/pic_index.dart';
import 'reading.dart' show soundOutWords;
import 'topics.dart';

/// Days since 2024-01-01 (UTC calendar day, so every device agrees).
int dayNumber(DateTime date) => DateTime.utc(
  date.year,
  date.month,
  date.day,
).difference(DateTime.utc(2024)).inDays;

/// Whether we have our own drawing for [emoji] (toddlers only see drawings).
bool isDrawn(String emoji) =>
    emoji.startsWith('shape:') ||
    drawnPictures.contains(
      emoji.startsWith('pic:')
          ? emoji.substring(4)
          : emoji.runes
                .where((r) => r != 0xFE0F)
                .map((r) => r.toRadixString(16))
                .join('-'),
    );

Topic _topic(String id) => topics.firstWhere((t) => t.id == id);

// ------------------------------------------------------------ toddlers

/// A color toddlers learn: its name, a dot of it, its value (for drawn
/// shapes) and everyday things that are that color.
typedef ToddlerColor = (String, String, Color, List<String>);

const toddlerColors = <ToddlerColor>[
  ('Red', '🔴', Color(0xFFFF4757), ['🍎', '🍓', '🚒', '🍅', '🍒']),
  ('Yellow', '🟡', Color(0xFFFFC93C), ['🍌', '🌻', '🐥', '🍋', '⭐']),
  ('Green', '🟢', Color(0xFF2ECC71), ['🥦', '🐸', '🥒', '🐢', '🍀']),
  ('Blue', '🔵', Color(0xFF3FA9F5), ['🐳', '💧', '🦋', '🐋']),
  ('Orange', '🟠', Color(0xFFFF8C42), ['🥕', '🍊', '🦊', '🎃']),
  ('Purple', '🟣', Color(0xFF8E5CF7), ['🍇', '🍆']),
  ('Pink', '🌸', Color(0xFFFF5D8F), ['🐷', '🦩', '🌷']),
  ('Brown', '🟤', Color(0xFF8D5A3B), ['🐻', '🥔', '🍪', '🌰']),
];

const _shapeFacts = {
  ShapeKind.circle: 'I am round like a ball. I have no corners.',
  ShapeKind.square: 'I have four sides, all the same size.',
  ShapeKind.triangle: 'I have three sides and three corners.',
  ShapeKind.star: 'I have five points and twinkle in the sky.',
  ShapeKind.heart: 'I mean love! Draw me for someone you love.',
  ShapeKind.rectangle: 'I have four sides, two long and two short, like a door.',
  ShapeKind.oval: 'I am round and long, like an egg.',
  ShapeKind.diamond: 'I have four pointy corners, like a kite.',
};

/// The themes toddlers rotate through, one per day.
enum ToddlerTheme {
  animals('Animals', '🐾', AppColors.lime, 'animal'),
  colors('Colors', '🎨', AppColors.bubblegum, 'color'),
  shapes('Shapes', '🔷', AppColors.grape, 'shape'),
  food('Fruits & Veggies', '🍓', AppColors.tangerine, 'food'),
  vehicles('Things That Go', '🚗', AppColors.sky, 'vehicle');

  const ToddlerTheme(this.title, this.emoji, this.color, this.kindOf);
  final String title;
  final String emoji;
  final Color color;
  final String kindOf;

  /// Everything this theme can show, in a fixed shuffled order.
  List<TopicItem> get pool {
    List<TopicItem> from(List<String> ids) => [
      for (final id in ids)
        for (final i in _topic(id).items)
          if (isDrawn(i.emoji))
            TopicItem(i.name, i.emoji, i.fact, picture: i.picture, from: id),
    ];
    final items = switch (this) {
      animals => from(['farm', 'wild', 'ocean', 'birds', 'bugs']),
      food => from(['fruits', 'veggies']),
      vehicles => from(['vehicles']),
      colors => [
        for (final c in toddlerColors)
          TopicItem(
            c.$1,
            c.$2,
            _topic(
              'colors',
            ).items.firstWhere((i) => i.name == c.$1).fact,
            from: 'colors',
          ),
      ],
      shapes => [
        for (final s in ShapeKind.values)
          TopicItem(
            s.label[0].toUpperCase() + s.label.substring(1),
            'shape:${s.name}',
            _shapeFacts[s]!,
          ),
      ],
    };
    // Same names can come from two topics (a dog on the farm and at home).
    final seen = <String>{};
    final unique = [
      for (final i in items)
        if (seen.add(i.name.toLowerCase())) i,
    ];
    return unique..shuffle(Random(index * 97 + 5));
  }
}

/// How many theme items a toddler meets each day.
const toddlerThemeSize = 6;

/// What Age 2 and Age 3 children focus on today.
class ToddlerFocus {
  ToddlerFocus._(this.letters, this.numbers, this.theme, this.items);

  /// Age 2: 2 letters and 2 numbers (1–5) a day; Age 3: 3 letters and
  /// 3 numbers (1–10). Letters go through A–Z in order.
  factory ToddlerFocus.of(DateTime date, Level level) {
    final day = dayNumber(date);
    final young = level == Level.age2;
    final abc = [..._topic('abc1').items, ..._topic('abc2').items];
    final nums = _topic('numbers').items;
    final nl = young ? 2 : 3;
    final top = young ? 5 : 10;
    final theme = ToddlerTheme.values[day % ToddlerTheme.values.length];
    final visit = day ~/ ToddlerTheme.values.length;
    final pool = theme.pool;
    return ToddlerFocus._(
      [for (var i = 0; i < nl; i++) abc[(day * nl + i) % abc.length]],
      [for (var i = 0; i < nl; i++) nums[(day * nl + i) % top]],
      theme,
      [
        for (var i = 0; i < min(toddlerThemeSize, pool.length); i++)
          pool[(visit * toddlerThemeSize + i) % pool.length],
      ],
    );
  }

  /// A focus on any set of things (for the "Learn more" sessions), so their
  /// games are the same ones toddlers play every day.
  factory ToddlerFocus.custom({
    List<TopicItem> letters = const [],
    List<TopicItem> numbers = const [],
    ToddlerTheme theme = ToddlerTheme.animals,
    List<TopicItem> items = const [],
  }) => ToddlerFocus._(letters, numbers, theme, items);

  final List<TopicItem> letters;
  final List<TopicItem> numbers;
  final ToddlerTheme theme;

  /// Today's theme items (e.g. six animals).
  final List<TopicItem> items;

  String get letterNames => letters.map((l) => l.name).join(' · ');
  String get numberNames => numbers.map((n) => n.name).join(' · ');

  /// Today's learning sessions: letters, numbers, then the theme.
  List<Topic> get topics => [
    Topic(
      'abc',
      'Letters ${letters.map((l) => l.name).join(' ')}',
      '🔤',
      AppColors.tangerine,
      'letter',
      letters,
      toddlerOnly: true,
    ),
    Topic(
      'numbers',
      'Numbers ${numbers.map((n) => n.name).join(' ')}',
      '🔢',
      AppColors.sky,
      'number',
      numbers,
      toddlerOnly: true,
    ),
    Topic(
      theme.name,
      theme.title,
      theme.emoji,
      theme.color,
      theme.kindOf,
      items,
      toddlerOnly: true,
    ),
  ];
}

// --------------------------------------------------------------- Pre-K

/// Dolch pre-primer words, simplest first; Pre-K meets two a day.
const preKSightWords = [
  'I', 'a', 'the', 'see', 'can', 'we', 'go', 'up', 'is', 'it', //
  'my', 'me', 'to', 'and', 'look', 'you', 'in', 'big', 'red', 'blue',
  'one', 'two', 'run', 'play', 'jump', 'here', 'come', 'down', 'not', 'help',
  'said', 'little', 'make', 'find', 'away', 'for', 'three', 'yellow', 'funny',
  'where',
];

/// Today's Pre-K words: two sight words and two three-letter words, plus
/// yesterday's for review. Three-letter words are (picture, 'c-a-t').
class PreKWords {
  PreKWords._(this.sight, this.reviewSight, this.cvc, this.reviewCvc);

  factory PreKWords.of(DateTime date) {
    final day = dayNumber(date);
    List<X> two<X>(List<X> xs, int d) => [
      for (var i = 0; i < 2; i++) xs[((d * 2 + i) % xs.length + xs.length) % xs.length],
    ];
    return PreKWords._(
      two(preKSightWords, day),
      two(preKSightWords, day - 1),
      two(soundOutWords, day),
      two(soundOutWords, day - 1),
    );
  }

  final List<String> sight;
  final List<String> reviewSight;
  final List<(String, String)> cvc;
  final List<(String, String)> reviewCvc;
}
