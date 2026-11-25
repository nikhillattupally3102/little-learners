// Picture-only play for Age 2 and Age 3.
//
// Toddlers can't read, so: every answer is a picture (never a word, number
// or letter), every question is read aloud, there are only 2 (Age 2) or
// 3 (Age 3) answers to pick from, and prompts are short.

import 'package:flutter/painting.dart' show Color;

import '../content/daily_focus.dart';
import '../content/reading.dart' show animalSoundWords, bodyParts;
import '../content/topics.dart';
import '../models/models.dart';
import 'gen.dart';

bool _drawn(String emoji) => isDrawn(emoji);

List<TopicItem> _items(List<String> topicIds) => [
  for (final t in topics)
    if (topicIds.contains(t.id))
      for (final i in t.items)
        if (_drawn(i.emoji)) i,
];

const _things = [
  'farm',
  'wild',
  'ocean',
  'fruits',
  'veggies',
  'vehicles',
  'bugs',
  'birds',
];

/// How many pictures to choose from.
int _n(Gen g) => g.level == Level.age2 ? 2 : 3;

String _lower(String s) => s.toLowerCase();

ChoiceQuestion _pictures(
  Gen g, {
  required String prompt,
  required Visual visual,
  required String answer,
  required Iterable<String> wrong,
  List<String>? speech,
}) => g.choice(
  prompt: prompt,
  visual: visual,
  answer: answer,
  wrong: wrong.where((w) => w != answer),
  count: _n(g),
  speech: speech,
);

// ------------------------------------------------------------- find it

List<Question> tFindIt(Gen g) => g.many(g.count, () {
  // Age 2: the others come from a different topic (a cow among fruits).
  // Age 3: from the same topic (a cow among other farm animals).
  final topic = g.one(_things);
  final pool = _items([topic]);
  final target = g.one(pool);
  final others = g.level == Level.age2
      ? _items([g.one(_things.where((t) => t != topic).toList())])
      : pool;
  return _pictures(
    g,
    prompt: 'Find the ${_lower(target.name)}!',
    visual: const ListenVisual(),
    answer: target.emoji,
    wrong: others.map((i) => i.emoji),
  );
});

// -------------------------------------------------------------- colors

/// (colour, a dot of that colour, things that are that colour)
const _colors = [
  ('red', '🔴', ['🍎', '🍓', '🚒', '🍅', '🍒']),
  ('yellow', '🟡', ['🍌', '🌻', '🐥', '🍋', '⭐']),
  ('green', '🟢', ['🥦', '🐸', '🥒', '🐢', '🍀']),
  ('blue', '🔵', ['🐳', '💧', '🫐', '🦋']),
  ('orange', '🟠', ['🥕', '🍊', '🦊', '🎃']),
  ('purple', '🟣', ['🍇', '🍆']),
  ('pink', '🌸', ['🐷', '🦩']),
];

List<Question> tColors(Gen g) => g.mix(g.count, [
  () {
    final c = g.one(_colors);
    return _pictures(
      g,
      prompt: 'Find ${c.$1}!',
      visual: const ListenVisual(),
      answer: c.$2,
      wrong: _colors.map((x) => x.$2),
    );
  },
  if (g.level == Level.age3)
    () {
      final c = g.one(_colors);
      final mine = c.$3.where(_drawn).toList();
      return _pictures(
        g,
        prompt: 'Find something ${c.$1}!',
        visual: EmojiVisual(c.$2),
        answer: g.one(mine),
        wrong: [
          for (final x in _colors)
            if (x != c) ...x.$3.where(_drawn),
        ],
      );
    },
]);

// -------------------------------------------------------------- shapes

const _shapes = [
  ShapeKind.circle,
  ShapeKind.square,
  ShapeKind.triangle,
  ShapeKind.star,
  ShapeKind.heart,
];

List<Question> tShapes(Gen g) => g.many(g.count, () {
  final picks = g.pick(_shapes, _n(g));
  final target = picks.first;
  final shuffled = [...picks]..shuffle(g.r);
  final color = Color(
    g.one(const [0xFFFF4757, 0xFF3FA9F5, 0xFF2ECC71, 0xFF8E5CF7]),
  );
  final same = g.chance(.5);
  return ChoiceQuestion(
    prompt: same ? 'Find the same shape!' : 'Find the ${target.label}!',
    visual: same ? ShapeVisual(target, color) : const ListenVisual(),
    // All the same colour, so only the shape tells them apart.
    choices: [for (final s in shuffled) Choice.shape(s, color)],
    answer: shuffled.indexOf(target),
  );
});

// ---------------------------------------------------------- who says that

List<Question> tSounds(Gen g) => g.many(g.count, () {
  final (e, sound) = g.one(
    animalSoundWords.where((a) => _drawn(a.$1)).toList(),
  );
  return _pictures(
    g,
    prompt: 'Who says "$sound"?',
    visual: const ListenVisual(),
    answer: e,
    wrong: animalSoundWords.map((a) => a.$1).where(_drawn),
    speech: ['Who says $sound? $sound! $sound!'],
  );
});

// ------------------------------------------------------------ big & small

List<Question> tBigSmall(Gen g) => g.many(g.count, () {
  final e = g.one(_items(_things)).emoji;
  final big = g.chance(.5);
  // Same picture at different sizes; only Age 3 gets a middle size.
  final scales = g.level == Level.age2 ? [1.0, .5] : [1.0, .72, .45];
  final order = [...scales]..shuffle(g.r);
  return ChoiceQuestion(
    prompt: big ? 'Find the big one!' : 'Find the small one!',
    visual: const ListenVisual(),
    choices: [for (final s in order) Choice.label(e, scale: s)],
    answer: order.indexOf(big ? scales.first : scales.last),
  );
});

// --------------------------------------------------------------- same same

List<Question> tSame(Gen g) {
  final pool = _items(_things);
  final finds = g.many(g.count - 1, () {
    final target = g.one(pool);
    return _pictures(
      g,
      prompt: 'Find the same one!',
      visual: EmojiVisual(target.emoji),
      answer: target.emoji,
      wrong: pool.map((i) => i.emoji),
    );
  });
  // A small matching round: 3 pairs for Age 2, 4 for Age 3.
  final match = g.match('Match the same pictures!', [
    for (final i in g.pick(pool, g.level == Level.age2 ? 3 : 4))
      (MatchItem('', i.emoji), MatchItem('', i.emoji)),
  ]);
  return [...finds, match];
}

// ---------------------------------------------------------------- my body

List<Question> tBody(Gen g) => g.many(g.count, () {
  final parts = bodyParts.where((b) => _drawn(b.$1)).toList();
  final (e, name) = g.one(parts);
  return _pictures(
    g,
    prompt: 'Find the $name!',
    visual: const ListenVisual(),
    answer: e,
    wrong: parts.map((b) => b.$1),
  );
});

// --------------------------------------------------- count with me (Age 3)

const _numberWords = ['zero', 'one', 'two', 'three', 'four', 'five'];

/// cow → cows, bus → buses, strawberry → strawberries, sheep → sheep.
String _plural(String w) {
  const same = {'sheep', 'fish', 'deer', 'corn', 'broccoli', 'lettuce'};
  final last = w.split(' ').last;
  if (same.contains(last)) return w;
  if (RegExp(r'(s|sh|ch|x|z)$').hasMatch(w)) return '${w}es';
  if (RegExp(r'[^aeiou]y$').hasMatch(w))
    return '${w.substring(0, w.length - 1)}ies';
  return '${w}s';
}

List<Question> tCount(Gen g) => g.many(g.count, () {
  final item = g.one(_items(['fruits', 'farm', 'bugs', 'vehicles']));
  final target = g.between(1, 5);
  final others = g.pick([
    for (var k = 1; k <= 5; k++)
      if (k != target) k,
  ], 2);
  final counts = [target, ...others]..shuffle(g.r);
  String group(int k) => List.filled(k, item.emoji).join();
  final word = _numberWords[target];
  final name = target == 1 ? _lower(item.name) : _plural(_lower(item.name));
  return ChoiceQuestion(
    prompt: 'Find $word $name!',
    visual: const ListenVisual(),
    choices: [for (final k in counts) Choice.label(group(k))],
    answer: counts.indexOf(target),
    speech: ['Find $word $name! Count with me!'],
  );
});

// ---------------------------------------------------- shadow play (Age 3)

List<Question> tShadows(Gen g) => g.many(g.count, () {
  final pool = _items(['farm', 'wild', 'vehicles', 'fruits']);
  final picks = g.pick(pool, 3);
  final target = picks.first;
  final shuffled = [...picks]..shuffle(g.r);
  return ChoiceQuestion(
    prompt: 'Which shadow is the ${_lower(target.name)}?',
    visual: EmojiVisual(target.emoji),
    choices: [
      for (final i in shuffled) Choice.label(i.emoji, silhouette: true),
    ],
    answer: shuffled.indexOf(target),
  );
});

// ---------------------------------------------- which is different (Age 3)

List<Question> tDifferent(Gen g) => g.many(g.count, () {
  final groups = g.pick(['farm', 'fruits', 'vehicles', 'ocean'], 2);
  final same = g.pick(_items([groups[0]]), 2);
  final odd = g.one(_items([groups[1]]));
  final choices = [...same.map((i) => i.emoji), odd.emoji]..shuffle(g.r);
  return ChoiceQuestion(
    prompt: 'Which one is different?',
    visual: const ListenVisual(),
    choices: [for (final c in choices) Choice.label(c)],
    answer: choices.indexOf(odd.emoji),
  );
});

// ------------------------------------------------- where do I live (Age 3)

/// (animal, its name, its home)
const _homes = [
  ('🐟', 'fish', '🌊'),
  ('🐳', 'whale', '🌊'),
  ('🐒', 'monkey', '🌳'),
  ('🐦', 'bird', '🌳'),
  ('🐧', 'penguin', '🧊'),
  ('🐶', 'dog', '🏠'),
  ('🐱', 'cat', '🏠'),
  ('🐝', 'bee', '🌸'),
  ('🐫', 'camel', '🏜️'),
];

List<Question> tHomes(Gen g) => g.many(g.count, () {
  final homes = _homes.where((h) => _drawn(h.$1) && _drawn(h.$3)).toList();
  final (e, name, home) = g.one(homes);
  return _pictures(
    g,
    prompt: 'Where does the $name live?',
    visual: EmojiVisual(e),
    answer: home,
    wrong: homes.map((h) => h.$3),
  );
});

// ------------------------------------------ today's focus (Age 2 & 3)
//
// The daily core for toddlers: today's letters, numbers and theme items
// (see daily_focus.dart), each shown in a different way on every question.

/// Spreads [n] questions over [targets], using each format at most once
/// (formats that don't apply to a target return null and are skipped).
List<Question> _focusSheet<X>(
  Gen g,
  List<X> targets,
  List<Question? Function(X)> formats, {
  int? n,
}) {
  // About 5 things for Age 3, 3 for Age 2.
  final count = n ?? (g.level == Level.age3 ? 5 : 3);
  final order = [...targets]..shuffle(g.r);
  final pool = [...formats]..shuffle(g.r);
  final out = <Question>[];
  for (var i = 0; out.length < count && i < count * 6; i++) {
    final target = order[i % order.length];
    if (pool.isEmpty) pool.addAll([...formats]..shuffle(g.r));
    Question? q;
    for (final f in [...pool]) {
      q = f(target);
      if (q != null) {
        pool.remove(f);
        break;
      }
    }
    // None of the unused formats fit this target: start the formats over.
    if (q == null) {
      pool.clear();
      continue;
    }
    out.add(g.keep(q));
  }
  return out;
}

/// Today's letters, found three ways: by sound, by picture, by shape.
List<Question> tLetters(Gen g, ToddlerFocus f) {
  final names = f.letters.map((l) => l.name).toList();
  ChoiceQuestion pick(String prompt, Visual v, String answer, String say) =>
      g.choice(
        prompt: prompt,
        visual: v,
        answer: answer,
        wrong: names,
        count: _n(g),
        speech: [say],
      );
  return _focusSheet<TopicItem>(g, f.letters, [
    (l) => pick(
      'Find the letter ${l.name}!',
      const ListenVisual(),
      l.name,
      'Find the letter ${l.name}! ${l.fact}',
    ),
    (l) => l.picture == null
        ? null
        : pick(
            '${l.fact.replaceAll('.', '!')} Find ${l.name}!',
            EmojiVisual(l.picture!),
            l.name,
            '${l.fact} Find the letter ${l.name}!',
          ),
    (l) => pick(
      'Find the same letter!',
      EmojiVisual(l.name),
      l.name,
      'Find the same letter! ${l.name}!',
    ),
    // Age 3: which picture starts with this letter?
    (l) {
      final pics = [
        for (final x in f.letters)
          if (x.picture != null && _drawn(x.picture!)) x.picture!,
      ];
      if (g.level == Level.age2 ||
          l.picture == null ||
          !pics.contains(l.picture) ||
          pics.length < _n(g)) {
        return null;
      }
      return _pictures(
        g,
        prompt: 'What starts with ${l.name}?',
        visual: const ListenVisual(),
        answer: l.picture!,
        wrong: pics,
        speech: ['What starts with ${l.name}? ${l.fact}'],
      );
    },
  ]);
}

/// Today's numbers: find the numeral, find the group, count and choose.
List<Question> tNumbers(Gen g, ToddlerFocus f) {
  final ns = [for (final n in f.numbers) int.parse(n.name)];
  final things = _items(['fruits', 'farm', 'bugs', 'vehicles']);
  return _focusSheet<int>(g, ns, [
    (n) {
      final item = g.one(things);
      return g.choice(
        prompt: 'Find the number $n!',
        visual: CountVisual(item.emoji, n),
        answer: '$n',
        wrong: ns.map((k) => '$k'),
        count: _n(g),
        speech: ['Find the number $n! Count the pictures with me.'],
      );
    },
    (n) {
      final item = g.one(things);
      final name = n == 1 ? _lower(item.name) : _plural(_lower(item.name));
      final word = _numberWord(n);
      final counts = [n, ...g.pick(ns.where((k) => k != n), _n(g) - 1)]
        ..shuffle(g.r);
      return ChoiceQuestion(
        prompt: 'Find $word $name!',
        visual: const ListenVisual(),
        choices: [
          for (final k in counts) Choice.label(List.filled(k, item.emoji).join()),
        ],
        answer: counts.indexOf(n),
        speech: ['Find $word $name! Count with me!'],
      );
    },
    (n) {
      final item = g.one(things);
      final name = _plural(_lower(item.name));
      return g.choice(
        prompt: 'How many $name?',
        visual: CountVisual(item.emoji, n),
        answer: '$n',
        wrong: ns.map((k) => '$k'),
        count: _n(g),
        speech: ['How many $name? Count with me!'],
      );
    },
  ]);
}

const _numberWords10 = [
  'zero', 'one', 'two', 'three', 'four', 'five', //
  'six', 'seven', 'eight', 'nine', 'ten',
];
String _numberWord(int n) => _numberWords10[n];

/// Today's theme (six animals, colors, shapes…), each one shown a
/// different way: heard, matched, as a shadow, by its sound, big or small.
List<Question> tTheme(Gen g, ToddlerFocus f) => switch (f.theme) {
  ToddlerTheme.colors => _colorTheme(g, f),
  ToddlerTheme.shapes => _shapeTheme(g, f),
  _ => _pictureTheme(g, f),
};

List<Question> _pictureTheme(Gen g, ToddlerFocus f) {
  final items = f.items;
  final emojis = items.map((i) => i.emoji).toList();
  final sounds = {for (final (e, s) in animalSoundWords) e: s};
  return _focusSheet<TopicItem>(g, items, [
    (i) => _pictures(
      g,
      prompt: 'Find the ${_lower(i.name)}!',
      visual: const ListenVisual(),
      answer: i.emoji,
      wrong: emojis,
    ),
    (i) => _pictures(
      g,
      prompt: 'Find the same one!',
      visual: EmojiVisual(i.emoji),
      answer: i.emoji,
      wrong: emojis,
    ),
    (i) {
      final others = g.pick(emojis.where((e) => e != i.emoji), _n(g) - 1);
      final all = [i.emoji, ...others]..shuffle(g.r);
      return ChoiceQuestion(
        prompt: 'Which shadow is the ${_lower(i.name)}?',
        visual: EmojiVisual(i.emoji),
        choices: [for (final e in all) Choice.label(e, silhouette: true)],
        answer: all.indexOf(i.emoji),
      );
    },
    (i) {
      final sound = sounds[i.emoji];
      if (sound == null) return null;
      return _pictures(
        g,
        prompt: 'Who says "$sound"?',
        visual: const ListenVisual(),
        answer: i.emoji,
        wrong: emojis,
        speech: ['Who says $sound? $sound! $sound!'],
      );
    },
    (i) {
      final big = g.chance(.5);
      final scales = g.level == Level.age2 ? [1.0, .5] : [1.0, .72, .45];
      final order = [...scales]..shuffle(g.r);
      final name = _lower(i.name);
      return ChoiceQuestion(
        prompt: big ? 'Find the big $name!' : 'Find the small $name!',
        visual: const ListenVisual(),
        choices: [for (final s in order) Choice.label(i.emoji, scale: s)],
        answer: order.indexOf(big ? scales.first : scales.last),
      );
    },
  ]);
}

List<Question> _colorTheme(Gen g, ToddlerFocus f) {
  final today = [
    for (final i in f.items) toddlerColors.firstWhere((c) => c.$1 == i.name),
  ];
  final dots = today.map((c) => c.$2).toList();
  String lower(ToddlerColor c) => c.$1.toLowerCase();
  List<String> things(ToddlerColor c) => c.$4.where(_drawn).toList();
  return _focusSheet<ToddlerColor>(g, today, [
    (c) => _pictures(
      g,
      prompt: 'Find ${lower(c)}!',
      visual: const ListenVisual(),
      answer: c.$2,
      wrong: dots,
    ),
    (c) => things(c).isEmpty
        ? null
        : _pictures(
            g,
            prompt: 'Find something ${lower(c)}!',
            visual: EmojiVisual(c.$2),
            answer: g.one(things(c)),
            wrong: [
              for (final x in today)
                if (x != c) ...things(x),
            ],
          ),
    (c) => things(c).isEmpty
        ? null
        : _pictures(
            g,
            prompt: 'What color is this?',
            visual: EmojiVisual(g.one(things(c))),
            answer: c.$2,
            wrong: dots,
          ),
    (c) {
      final shape = g.one(const [
        ShapeKind.circle,
        ShapeKind.star,
        ShapeKind.heart,
        ShapeKind.square,
      ]);
      final picks = [c, ...g.pick(today.where((x) => x != c), _n(g) - 1)]
        ..shuffle(g.r);
      return ChoiceQuestion(
        prompt: 'Find the ${lower(c)} ${shape.label}!',
        visual: const ListenVisual(),
        choices: [for (final x in picks) Choice.shape(shape, x.$3)],
        answer: picks.indexOf(c),
      );
    },
  ]);
}

List<Question> _shapeTheme(Gen g, ToddlerFocus f) {
  final today = [
    for (final i in f.items) ShapeKind.values.byName(i.emoji.substring(6)),
  ];
  const palette = [
    Color(0xFFFF4757),
    Color(0xFF3FA9F5),
    Color(0xFF2ECC71),
    Color(0xFF8E5CF7),
    Color(0xFFFF8C42),
  ];
  ChoiceQuestion shapes(
    ShapeKind s, {
    required String prompt,
    required Visual visual,
    bool mixed = false,
  }) {
    final picks = [s, ...g.pick(today.where((x) => x != s), _n(g) - 1)]
      ..shuffle(g.r);
    final colors = g.pick(palette, picks.length);
    final one = g.one(palette);
    return ChoiceQuestion(
      prompt: prompt,
      visual: visual,
      // Same colour unless [mixed], so only the shape tells them apart.
      choices: [
        for (var k = 0; k < picks.length; k++)
          Choice.shape(picks[k], mixed ? colors[k] : one),
      ],
      answer: picks.indexOf(s),
    );
  }

  return _focusSheet<ShapeKind>(g, today, [
    (s) => shapes(
      s,
      prompt: 'Find the ${s.label}!',
      visual: const ListenVisual(),
    ),
    (s) => shapes(
      s,
      prompt: 'Find the same shape!',
      visual: ShapeVisual(s, g.one(palette)),
    ),
    (s) => g.level == Level.age2
        ? null
        : shapes(
            s,
            prompt: 'Find the ${s.label}!',
            visual: const ListenVisual(),
            mixed: true,
          ),
  ]);
}

/// Review of yesterday's letters, numbers and theme items: one of each
/// for Age 2; two letters, two numbers and a theme item for Age 3.
List<Question> tReview(Gen g, ToddlerFocus yesterday) {
  final two = g.level == Level.age3 ? 2 : 1;
  return [
    ...tLetters(g, yesterday).take(two),
    ...tNumbers(g, yesterday).take(two),
    tTheme(g, yesterday).first,
  ]..shuffle(g.r);
}

/// Age 3: trace today's letters, then today's numbers, big and clear.
List<Question> tTrace(Gen g, ToddlerFocus f) => [
  for (final l in f.letters)
    TraceQuestion(
      glyph: l.name,
      hint: '${l.fact.replaceAll('.', '')} ${l.picture ?? ''}'.trim(),
      speech: 'Trace the letter ${l.name}. ${l.fact}',
    ),
  for (final n in f.numbers)
    TraceQuestion(
      glyph: n.name,
      hint: List.filled(int.parse(n.name), '🎈').join(),
      speech: 'Trace the number ${n.name}. Count the balloons!',
    ),
];

/// The learning quiz for toddlers: "Find the cow!" taps, no reading
/// (letters and numbers sessions ask for the letter or number itself).
List<Question> toddlerTopicQuiz(Gen g, Topic t) {
  final pool = [
    for (final i in t.items)
      if (t.toddlerOnly || _drawn(i.emoji)) i,
  ];
  return g.many(g.count, () {
    final target = g.one(pool);
    final kind = t.kindOf == 'letter' || t.kindOf == 'number'
        ? 'the ${t.kindOf} ${target.name}'
        : t.kindOf == 'color'
        ? _lower(target.name)
        : 'the ${_lower(target.name)}';
    return _pictures(
      g,
      prompt: 'Find $kind!',
      visual: target.picture == null
          ? const ListenVisual()
          : t.kindOf == 'number'
          ? CountVisual(
              target.picture!.substring(
                0,
                target.picture!.length ~/ int.parse(target.name),
              ),
              int.parse(target.name),
            )
          : EmojiVisual(target.picture!),
      answer: target.emoji,
      wrong: pool.map((i) => i.emoji),
    );
  });
}
