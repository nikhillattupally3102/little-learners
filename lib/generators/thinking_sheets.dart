// Thinking Skills worksheets: reasoning puzzles in the style of the CogAT's
// three batteries, for Kindergarten to Grade 5.
//
// - Word Thinking (verbal): analogies, sentence completion, classification
// - Number Thinking (quantitative): number analogies, number puzzles,
//   number series
// - Shape Thinking (nonverbal): figure matrices, figure classification,
//   paper folding
//
// K–2 puzzles are pictures and are read aloud; from Grade 3 they use words
// and numbers, and the rules get harder (two changes at once, 3×3 grids,
// paper folded twice).

import 'dart:math';

import '../content/figures.dart';
import '../content/thinking.dart';
import '../models/models.dart';
import 'gen.dart';

int _choices(Gen g) => g.atMost(Level.kindergarten) ? 3 : 4;
bool _pictures(Gen g) => g.atMost(Level.grade2);

/// Items for this level: everything up to it, mostly the newest ones.
List<X> _upTo<X>(Gen g, List<X> all, Level Function(X) from) {
  final ok = [
    for (final x in all)
      if (g.atLeast(from(x))) x,
  ];
  final newest = [
    for (final x in ok)
      if (from(x).index >= g.level.index - 1) x,
  ];
  return newest.length >= 3 && g.chance(.7) ? newest : ok;
}

// =============================================================== verbal

List<Question> wordThinking(Gen g, [int? n]) => g.mix(
  n ?? g.count,
  _pictures(g)
      ? [
          () => _pictureAnalogy(g),
          () => _pictureQuestion(g),
          () => _pictureGroup(g),
        ]
      : [() => _wordAnalogy(g), () => _sentence(g), () => _wordGroup(g)],
);

Question _pictureAnalogy(Gen g) {
  final (_, pairs) = g.one(_upTo(g, pictureAnalogies, (r) => r.$1));
  final [(a, b), (c, d)] = g.pick(pairs, 2);
  final shown = {a, b, c, d};
  final same = [
    for (final p in pairs)
      if (!shown.contains(p.$2)) p.$2,
  ];
  // Small sets borrow wrong answers from the other sets.
  final more = [
    for (final (_, ps) in pictureAnalogies)
      for (final p in ps)
        if (!shown.contains(p.$2) && !same.contains(p.$2)) p.$2,
  ];
  final n = _choices(g);
  return g.choice(
    prompt: 'These two go together. What goes with the last one?',
    visual: MatrixVisual([a, b, c, '?']),
    answer: d,
    wrong: [...g.pick(same, n - 1), ...g.pick(more, max(0, n - 1 - same.length))],
    count: n,
    speech: [
      'Look! These two pictures go together.',
      'Which picture goes with this one, in the same way?',
    ],
  );
}

Question _pictureQuestion(Gen g) {
  final (_, question, answer, wrong) = g.one(
    _upTo(g, pictureQuestions, (q) => q.$1),
  );
  return g.choice(
    prompt: question,
    visual: const ListenVisual(),
    answer: answer,
    wrong: wrong,
    count: _choices(g),
    speech: [question],
  );
}

Question _pictureGroup(Gen g) {
  final (_, members, others) = g.one(_upTo(g, pictureGroups, (x) => x.$1));
  final picked = g.pick(members, 4);
  return g.choice(
    prompt: 'These three go together. Which one goes with them?',
    visual: MatrixVisual(picked.take(3).toList(), cols: 3, joins: const []),
    answer: picked[3],
    wrong: others,
    count: _choices(g),
    speech: ['These three go together.', 'Which one goes with them?'],
  );
}

Question _wordAnalogy(Gen g) {
  final (_, _, pairs) = g.one(_upTo(g, wordAnalogies, (r) => r.$1));
  final [(a, b), (c, d)] = g.pick(pairs, 2);
  return g.choice(
    prompt:
        'The first two words go together. Which word goes with the third '
        'word in the same way?',
    visual: MatrixVisual([a, b, c, '?']),
    answer: d,
    wrong: [
      for (final p in pairs)
        if (p.$2 != d && p.$2 != b && p.$2 != c) p.$2,
    ],
    count: 4,
    speech: ['$a goes with $b.', '$c goes with… what?'],
  );
}

Question _sentence(Gen g) {
  final (_, sentence, answer, wrong) = g.one(
    _upTo(g, sentenceCompletions, (s) => s.$1),
  );
  return g.choice(
    prompt: 'Which word best completes the sentence?',
    visual: TextVisual(sentence, emoji: '💭'),
    answer: answer,
    wrong: wrong,
    count: 4,
    speech: [sentence.replaceAll('___', 'blank'), 'Which word fits best?'],
  );
}

Question _wordGroup(Gen g) {
  final (_, members, others) = g.one(_upTo(g, wordGroups, (x) => x.$1));
  final picked = g.pick(members, 4);
  return g.choice(
    prompt: 'These three words are alike. Which word belongs with them?',
    visual: MatrixVisual(picked.take(3).toList(), cols: 3, joins: const []),
    answer: picked[3],
    wrong: others,
    count: 4,
    speech: ['${picked.take(3).join(', ')}.', 'Which word belongs with them?'],
  );
}

// ========================================================= quantitative

List<Question> numberThinking(Gen g, [int? n]) => g.mix(
  n ?? g.count,
  _pictures(g)
      ? [() => _pictureNumberAnalogy(g), () => _balance(g), () => _series(g)]
      : [() => _numberAnalogy(g), () => _numberPuzzle(g), () => _series(g)],
);

const _countables = ['🍎', '🍌', '🍓', '🍊', '⭐', '🐟', '🎈', '🌸', '🐞', '🍪'];

String _many(String e, int n) => List.filled(n, e).join();

/// A rule for number analogies, with a short name for checking that only
/// one rule fits what's shown.
typedef _Rule = (String, int? Function(int));

List<_Rule> _allRules() => [
  for (var k = 1; k <= 30; k++) ('+$k', (n) => n + k),
  for (var k = 1; k <= 30; k++) ('-$k', (n) => n - k >= 0 ? n - k : null),
  for (var k = 2; k <= 9; k++) ('x$k', (n) => n * k),
  for (var k = 2; k <= 9; k++) ('/$k', (n) => n % k == 0 ? n ~/ k : null),
  for (var k = 2; k <= 5; k++) ...[
    ('x$k+1', (n) => n * k + 1),
    ('x$k-1', (n) => n * k - 1),
  ],
  ('sq', (n) => n * n),
];

/// Whether [rule] is the only rule that turns each example's first number
/// into its second (others may fit, but must give the same answer for [c]).
bool _onlyRule(_Rule rule, List<(int, int)> examples, int c) {
  final answer = rule.$2(c);
  for (final other in _allRules()) {
    if (other.$1 == rule.$1) continue;
    if (examples.every((e) => other.$2(e.$1) == e.$2) &&
        other.$2(c) != answer) {
      return false;
    }
  }
  return true;
}

Question _pictureNumberAnalogy(Gen g) {
  final top = g.byLevel({
    Level.kindergarten: 5,
    Level.grade1: 7,
    Level.grade2: 8,
  });
  final rules = g.byLevel<List<_Rule>>({
    Level.kindergarten: [('+1', (n) => n + 1), ('-1', (n) => n - 1)],
    Level.grade1: [
      ('+1', (n) => n + 1),
      ('-1', (n) => n - 1),
      ('+2', (n) => n + 2),
      ('-2', (n) => n - 2),
    ],
    Level.grade2: [
      ('+2', (n) => n + 2),
      ('-2', (n) => n - 2),
      ('+3', (n) => n + 3),
      ('x2', (n) => n * 2),
      ('/2', (n) => n.isEven ? n ~/ 2 : null),
    ],
  });
  for (var tries = 0; ; tries++) {
    final rule = g.one(rules);
    final a = g.between(1, top), c = g.between(1, top);
    final b = rule.$2(a), d = rule.$2(c);
    if (a == c || b == null || d == null) continue;
    if (b < 1 || d < 1 || b > top || d > top) continue;
    // One example must be enough to tell the rule (2 → 4 could be +2 or ×2).
    final fits = rules.where((r) => r.$2(a) == b && r.$2(c) != d);
    if (fits.isNotEmpty && tries < 50) continue;
    final [e1, e2] = g.pick(_countables, 2);
    return g.choice(
      prompt: 'Look at how the first box changes. What goes in the last box?',
      visual: MatrixVisual([_many(e1, a), _many(e1, b), _many(e2, c), '?']),
      answer: _many(e2, d),
      wrong: [
        for (final n in {d - 1, d + 1, c, d + 2, d - 2, d + 3})
          if (n >= 1 && n <= top + 2 && n != d) _many(e2, n),
      ],
      count: _choices(g),
      speech: [
        'Look at how the first box changes.',
        'Change the next box in the same way. What goes in the empty box?',
      ],
    );
  }
}

Question _balance(Gen g) {
  final top = g.byLevel({
    Level.kindergarten: 5,
    Level.grade1: 7,
    Level.grade2: 9,
  });
  final total = g.between(3, top);
  final have = g.between(1, total - 1);
  final need = total - have;
  final e = g.one(_countables);
  return g.choice(
    prompt: 'What goes in the box to make both sides the same?',
    visual: MatrixVisual(
      [_many(e, have), '?', _many(e, total)],
      cols: 3,
      joins: const ['+', '='],
    ),
    answer: _many(e, need),
    wrong: [
      for (final n in {need - 1, need + 1, total, need + 2, need + 3})
        if (n >= 1 && n != need) _many(e, n),
    ],
    count: _choices(g),
    speech: [
      'Some here, and some more in the box, make the same as the other side.',
      'What goes in the box?',
    ],
  );
}

Question _numberAnalogy(Gen g) {
  final rules = g.byLevel<List<_Rule Function()>>({
    Level.grade3: [
      () {
        final k = g.between(2, 9);
        return ('+$k', (n) => n + k);
      },
      () {
        final k = g.between(2, 9);
        return ('-$k', (n) => n - k >= 0 ? n - k : null);
      },
      () => ('x2', (n) => n * 2),
      () => ('x3', (n) => n * 3),
    ],
    Level.grade4: [
      () {
        final k = g.between(2, 6);
        return ('x$k', (n) => n * k);
      },
      () {
        final k = g.between(2, 6);
        return ('/$k', (n) => n % k == 0 ? n ~/ k : null);
      },
      () {
        final k = g.between(11, 25);
        return ('+$k', (n) => n + k);
      },
      () {
        final k = g.between(6, 15);
        return ('-$k', (n) => n - k >= 0 ? n - k : null);
      },
    ],
    Level.grade5: [
      () {
        final k = g.between(2, 5);
        return ('x$k+1', (n) => n * k + 1);
      },
      () {
        final k = g.between(2, 5);
        return ('x$k-1', (n) => n * k - 1);
      },
      () => ('sq', (n) => n * n),
      () {
        final k = g.between(6, 9);
        return ('x$k', (n) => n * k);
      },
      () {
        final k = g.between(3, 9);
        return ('/$k', (n) => n % k == 0 ? n ~/ k : null);
      },
    ],
  });
  final hi = g.byLevel({Level.grade3: 12, Level.grade4: 40, Level.grade5: 12});
  while (true) {
    final rule = g.one(rules)();
    // Division rules need numbers that divide evenly.
    final ins = g.pick([
      for (var n = 1; n <= hi * 3; n++)
        if (rule.$2(n) != null && (n <= hi || rule.$1.startsWith('/'))) n,
    ], 3);
    if (ins.length < 3) continue;
    final outs = [for (final n in ins) rule.$2(n)!];
    if (outs.any((o) => o > 200)) continue;
    final examples = [(ins[0], outs[0]), (ins[1], outs[1])];
    if (!_onlyRule(rule, examples, ins[2])) continue;
    return g.number(
      prompt: 'The same rule changes each number. What is the missing number?',
      visual: MatrixVisual([
        '${ins[0]}', '${outs[0]}', //
        '${ins[1]}', '${outs[1]}',
        '${ins[2]}', '?',
      ]),
      answer: outs[2],
      speech: [
        '${ins[0]} becomes ${outs[0]}. ${ins[1]} becomes ${outs[1]}.',
        'What does ${ins[2]} become?',
      ],
    );
  }
}

Question _numberPuzzle(Gen g) {
  final b = g.between;
  final (String text, int answer) = g.one(
    g.byLevel<List<(String, int) Function()>>({
      Level.grade3: [
        () {
          final x = b(2, 15), a = b(3, 9);
          return ('? + $a = ${x + a}', x);
        },
        () {
          final x = b(8, 20), a = b(2, 7);
          return ('? − $a = ${x - a}', x);
        },
        () {
          final x = b(2, 12), a = b(3, 12);
          return ('$a + ? = ${x + a}', x);
        },
        () {
          final k = b(2, 9), x = b(2, 9);
          return ('■ = $k\n■ + ? = ${k + x}', x);
        },
      ],
      Level.grade4: [
        () {
          final x = b(2, 9), a = b(3, 9);
          return ('? × $a = ${x * a}', x);
        },
        () {
          final q = b(2, 9), a = b(2, 9);
          return ('? ÷ $a = $q', q * a);
        },
        () {
          final k = b(3, 12), d = b(2, 15);
          return ('■ = $k\n? − ■ = $d', k + d);
        },
        () {
          final x = b(3, 9), y = b(2, 9), c = b(2, 6);
          return ('$x + $y = ? − $c', x + y + c);
        },
      ],
      Level.grade5: [
        () {
          final x = b(2, 9), a = b(2, 6), c = b(1, 9);
          return ('$a × ? + $c = ${a * x + c}', x);
        },
        () {
          final a = b(2, 5), c = b(3, 6), d = b(1, 9);
          final r = c + d;
          return ('? ÷ $a = ${r + d} − $d', r * a);
        },
        () {
          final k = b(2, 6), m = b(1, 4);
          return ('■ = $k,  ▲ = ■ + $m\n? = ■ × ▲', k * (k + m));
        },
        () {
          final c = b(2, 6), x = b(2, 9), a = c * b(2, 3);
          // a × x = ? × c, with ? a whole number.
          return ('$a × $x = ? × $c', a * x ~/ c);
        },
      ],
    }),
  )();
  return g.number(
    prompt: 'What number does ? stand for?',
    visual: TextVisual(text, emoji: '🧮'),
    answer: answer,
    lowest: 0,
    speech: [
      text
          .replaceAll('?', 'blank')
          .replaceAll('■', 'square')
          .replaceAll('▲', 'triangle')
          .replaceAll('\n', '. '),
      'What number goes in the blank?',
    ],
  );
}

/// Number series: what comes next?
Question _series(Gen g) {
  final b = g.between;
  List<int> walk(int start, int n, int Function(int i, int prev) next) {
    final out = [start];
    for (var i = 1; i < n; i++) {
      out.add(next(i, out.last));
    }
    return out;
  }

  final shown = g.atMost(Level.kindergarten) ? 4 : 5;
  final n = shown + 1;
  final makers = g.byLevel<List<List<int> Function()>>({
    Level.kindergarten: [
      () => walk(b(1, 5), n, (_, p) => p + 1),
      () => walk(b(6, 10), n, (_, p) => p - 1),
      () {
        final x = b(1, 4), y = x + b(1, 4);
        return [for (var i = 0; i < n; i++) i.isEven ? x : y];
      },
    ],
    Level.grade1: [
      () => walk(b(0, 6), n, (_, p) => p + 2),
      () => walk(b(0, 1) * 5, n, (_, p) => p + 5),
      () => walk(b(1, 9), n, (_, p) => p + 10),
      () => walk(b(12, 20), n, (_, p) => p - 1),
      () {
        final x = b(1, 4), y = x + b(1, 3);
        return [for (var i = 0; i < n; i++) i % 3 == 0 ? x : y];
      },
    ],
    Level.grade2: [
      () => walk(b(1, 6), n, (_, p) => p + 3),
      () => walk(b(1, 6), n, (_, p) => p + 4),
      () => walk(b(20, 30), n, (_, p) => p - 2),
      () => walk(b(1, 5), n, (i, p) => p + i),
      () => walk(b(11, 19), n, (_, p) => p + 10),
    ],
    Level.grade3: [
      () => walk(b(1, 3), n, (_, p) => p * 2),
      () => walk(b(40, 50), n, (_, p) => p - 3),
      () => walk(b(1, 9), n, (_, p) => p + 6),
      () => walk(b(2, 9), n, (i, p) => i.isOdd ? p + 3 : p - 1),
      () => walk(b(1, 5), n, (i, p) => p + i),
    ],
    Level.grade4: [
      () => walk(b(1, 2), n, (_, p) => p * 3),
      () => walk(b(1, 9), n, (_, p) => p + 7),
      () => walk(b(50, 70), n, (_, p) => p - 4),
      () {
        // Two series taking turns: 1, 10, 2, 20, 3, 30…
        final x = b(1, 3), k = b(5, 10);
        return [
          for (var i = 0; i < n; i++) i.isEven ? x + i ~/ 2 : k * (i ~/ 2 + 1),
        ];
      },
      () => walk(b(1, 5), n, (i, p) => p + 2 * i),
    ],
    Level.grade5: [
      () {
        final k = b(1, 4);
        return [for (var i = 0; i < n; i++) (k + i) * (k + i)];
      },
      () => walk(b(1, 2), n, (_, p) => p * 2 + 1),
      () {
        final s = [b(1, 3), b(2, 4)];
        while (s.length < n) {
          s.add(s[s.length - 1] + s[s.length - 2]);
        }
        return s;
      },
      () => walk([96, 160, 192, 224][b(0, 3)], n, (_, p) => p ~/ 2),
      () => walk(b(1, 3), n, (i, p) => i.isOdd ? p * 2 : p + 1),
    ],
  });
  final seq = g.one(makers)();
  final shownItems = [for (final x in seq.take(shown)) fmt(x)];
  return g.number(
    prompt: 'What number comes next?',
    visual: PatternVisual([...shownItems, '?']),
    answer: seq.last,
    count: _choices(g),
    lowest: 0,
    speech: ['${shownItems.join(', ')}…', 'What number comes next?'],
  );
}

// ============================================================ nonverbal

List<Question> shapeThinking(Gen g, [int? n]) => g.mix(n ?? g.count, [
  () => g.atLeast(Level.grade4) && g.chance(.5) ? _matrix3(g) : _matrix2(g),
  () => _figureGroup(g),
  () => _paperFold(g),
]);

int _colorCount(Gen g) => g.atMost(Level.kindergarten) ? 4 : 5;

Fig _randomFig(Gen g, {bool varied = true}) => Fig(
  g.one(figShapes),
  color: g.r.nextInt(_colorCount(g)),
  count: varied && g.atLeast(Level.grade1) ? g.between(1, 3) : 1,
  outline: varied && g.atLeast(Level.grade1) && g.chance(.3),
);

/// 2×2 figure matrix: the first figure changes into the second; make the
/// same change to the third.
Question _matrix2(Gen g) {
  final kinds = g.byLevel({
    Level.kindergarten: ['color', 'size'],
    Level.grade1: ['color', 'size', 'count', 'fill'],
    Level.grade2: ['color', 'count', 'fill', 'shape', 'turn'],
  });
  // From Grade 3, often two changes at once.
  final two =
      g.atLeast(Level.grade3) && g.chance(g.atLeast(Level.grade4) ? .7 : .5);
  final pool = [...kinds, if (g.atLeast(Level.grade3)) 'size'];
  final changes = two ? g.pick(pool.toSet(), 2) : [g.one(pool)];
  if (changes.contains('turn') && changes.contains('shape'))
    changes.remove('shape');

  final turning = changes.contains('turn');
  final shapes = turning ? turnableShapes : figShapes;
  final [s1, s2] = g.pick(shapes, 2);
  var a = _randomFig(g).copyWith(shape: s1, small: false, turn: 0);
  var c = _randomFig(g).copyWith(shape: s2, small: false, turn: 0);
  if (changes.contains('shape')) {
    // The shape change: both start as the same shape.
    c = c.copyWith(shape: s1);
    if (c.color == a.color)
      c = c.copyWith(color: (a.color + 1) % _colorCount(g));
  }
  // Keep counts small enough to see a change.
  a = a.copyWith(count: min(a.count, 3));
  c = c.copyWith(count: min(c.count, 3));

  Fig change(Fig f, String what, Fig from) => switch (what) {
    'color' => f.copyWith(color: from.color),
    'size' => f.copyWith(small: from.small),
    'count' => f.copyWith(count: from.count),
    'fill' => f.copyWith(outline: from.outline),
    'turn' => f.copyWith(turn: from.turn),
    _ => f.copyWith(shape: from.shape),
  };

  // B = A with the changes; C starts with A's values for what changes.
  var bFig = a;
  for (final w in changes) {
    final newer = switch (w) {
      'color' => a.copyWith(
        color: (a.color + 1 + g.r.nextInt(_colorCount(g) - 1)) % _colorCount(g),
      ),
      'size' => a.copyWith(small: !a.small),
      'count' => a.copyWith(
        count: a.count == 1
            ? g.between(2, 3)
            : (a.count == 2 ? g.one([1, 3]) : g.between(1, 2)),
      ),
      'fill' => a.copyWith(outline: !a.outline),
      'turn' => a.copyWith(turn: g.one([1, 2, 3])),
      _ => a.copyWith(
        shape: g.one(figShapes.where((s) => s != a.shape).toList()),
      ),
    };
    bFig = change(bFig, w, newer);
    c = change(c, w, a);
  }
  var answer = c;
  for (final w in changes) {
    answer = change(answer, w, bFig);
  }
  if (answer == c || bFig == a || c == a) return _matrix2(g);

  final wrong = <Fig>{
    c, // nothing changed
    bFig, // copied the example
    for (final w in changes) change(answer, w, c), // missed one change
    answer.copyWith(color: (answer.color + 1) % _colorCount(g)),
    if (g.atLeast(Level.grade1)) answer.copyWith(count: answer.count % 3 + 1),
    if (turning) answer.copyWith(turn: (answer.turn + 2) % 4),
  }..remove(answer);
  return g.choice(
    prompt:
        'Look at how the first picture changes. Which one goes in the '
        'empty box?',
    visual: MatrixVisual([a.spec, bFig.spec, c.spec, '?']),
    answer: answer.spec,
    wrong: wrong.map((f) => f.spec),
    count: _choices(g),
    speech: [
      'Look at how the first picture changes.',
      'Change the next picture in the same way. Which one goes in the empty box?',
    ],
  );
}

/// 3×3 matrix (Grade 4+): each row and column follows a rule.
Question _matrix3(Gen g) {
  final shapes = g.pick(figShapes, 3);
  final colors = g.pick(List.generate(_colorCount(g), (i) => i), 3);
  final byRow = g.chance(.5);
  final outlineCol = g.chance(.4);
  Fig cell(int r, int c) => Fig(
    shapes[(r + c) % 3],
    color: colors[byRow ? r : c],
    count: (byRow ? c : r) + 1,
    outline: outlineCol && c == 1,
  );
  final answer = cell(2, 2);
  final wrong = <Fig>{
    for (final s in shapes) answer.copyWith(shape: s),
    for (final k in colors) answer.copyWith(color: k),
    for (final n in [1, 2, 3]) answer.copyWith(count: n),
    answer.copyWith(outline: !answer.outline),
  }..remove(answer);
  return g.choice(
    prompt: 'Each row and column follows a rule. Which one finishes the grid?',
    visual: MatrixVisual(
      [
        for (var r = 0; r < 3; r++)
          for (var c = 0; c < 3; c++) r == 2 && c == 2 ? '?' : cell(r, c).spec,
      ],
      cols: 3,
      joins: const [],
    ),
    answer: answer.spec,
    wrong: wrong.map((f) => f.spec),
    count: 4,
    speech: [
      'Look across each row and down each column.',
      'Which one finishes the grid?',
    ],
  );
}

/// Three figures share something; pick the one that shares it too.
Question _figureGroup(Gen g) {
  final active = g.byLevel({
    Level.kindergarten: ['shape', 'color'],
    Level.grade1: ['shape', 'color', 'count'],
    Level.grade2: ['shape', 'color', 'count', 'fill'],
  });
  final rule = g.atLeast(Level.grade4) && g.chance(.5)
      ? g.pick(active, 2)
      : [g.one(active)];
  final colorsN = _colorCount(g);
  // Values for 4 figures (3 shown + the answer), varied where it's not the rule.
  List<int> vary(int n, int options) {
    while (true) {
      final xs = [for (var i = 0; i < n; i++) g.r.nextInt(options)];
      if (xs.take(3).toSet().length > 1) return xs;
    }
  }

  List<int> distinct(int options) =>
      g.pick(List.generate(options, (i) => i), 4);
  final shapeIdx = rule.contains('shape')
      ? List.filled(4, g.r.nextInt(figShapes.length))
      : distinct(figShapes.length);
  final colorIdx = rule.contains('color')
      ? List.filled(4, g.r.nextInt(colorsN))
      : (colorsN >= 4 ? distinct(colorsN) : vary(4, colorsN));
  final counts = !active.contains('count')
      ? List.filled(4, 1)
      : rule.contains('count')
      ? List.filled(4, g.between(1, 3))
      : [for (final x in vary(4, 3)) x + 1];
  final fills = !active.contains('fill')
      ? List.filled(4, 0)
      : rule.contains('fill')
      ? List.filled(4, g.r.nextInt(2))
      : vary(4, 2);
  final figs = [
    for (var i = 0; i < 4; i++)
      Fig(
        figShapes[shapeIdx[i]],
        color: colorIdx[i],
        count: counts[i],
        outline: fills[i] == 1,
      ),
  ];
  if (figs.toSet().length < 4) return _figureGroup(g);
  final answer = figs[3];

  // Wrong answers break the rule (for two-part rules, often just one part).
  final wrong = <Fig>{};
  for (var tries = 0; wrong.length < 6 && tries < 60; tries++) {
    var f = _randomFig(g, varied: active.length > 2).copyWith(
      count: active.contains('count') ? g.between(1, 3) : 1,
      outline: active.contains('fill') && g.chance(.5),
    );
    for (final r in rule) {
      f = switch (r) {
        'shape' => f.copyWith(shape: answer.shape),
        'color' => f.copyWith(color: answer.color),
        'count' => f.copyWith(count: answer.count),
        _ => f.copyWith(outline: answer.outline),
      };
    }
    final broken = g.one(rule);
    f = switch (broken) {
      'shape' => f.copyWith(
        shape: g.one(figShapes.where((s) => s != answer.shape).toList()),
      ),
      'color' => f.copyWith(
        color: (answer.color + 1 + g.r.nextInt(colorsN - 1)) % colorsN,
      ),
      'count' => f.copyWith(count: answer.count % 3 + 1),
      _ => f.copyWith(outline: !answer.outline),
    };
    wrong.add(f);
  }
  return g.choice(
    prompt: 'These three are alike in some way. Which one belongs with them?',
    visual: MatrixVisual(
      [for (final f in figs.take(3)) f.spec],
      cols: 3,
      joins: const [],
    ),
    answer: answer.spec,
    wrong: wrong.map((f) => f.spec),
    count: _choices(g),
    speech: [
      'These three are alike in some way.',
      'Which one belongs with them?',
    ],
  );
}

/// Paper folding: where are the holes when the paper is opened?
Question _paperFold(Gen g) {
  final fold = g.atLeast(Level.grade4) && g.chance(.7)
      ? 'vh'
      : g.one(['v', 'h']);
  final holesN = g.byLevel({
    Level.kindergarten: 1,
    Level.grade2: g.between(1, 2),
    Level.grade5: g.between(1, 2),
  });
  final rows = fold.contains('h') ? [2, 3] : [0, 1, 2, 3];
  final cols = fold.contains('v') ? [2, 3] : [0, 1, 2, 3];
  final spots = [
    for (final r in rows)
      for (final c in cols) (r, c),
  ];
  final holes = g.pick(spots, holesN);
  final answer = unfold(fold, holes);

  final right = paperSpec(answer);
  final wrong = <String>{
    paperSpec(holes), // forgot to unfold
    if (fold == 'vh') ...[
      paperSpec(unfold('v', holes)), // unfolded only once
      paperSpec(unfold('h', holes)),
    ] else ...[
      paperSpec(unfold(fold == 'v' ? 'h' : 'v', holes)), // wrong way
      paperSpec(unfold('vh', holes)), // too many holes
    ],
  }..remove(right);
  // Mirror holes in the wrong spot.
  final mirrored = answer.difference(holes.toSet()).toList();
  final empty = [
    for (var r = 0; r < 4; r++)
      for (var c = 0; c < 4; c++)
        if (!answer.contains((r, c))) (r, c),
  ];
  for (var tries = 0; wrong.length < 5 && tries < 30; tries++) {
    if (mirrored.isEmpty) break;
    final moved = {...answer}
      ..remove(g.one(mirrored))
      ..add(g.one(empty));
    final spec = paperSpec(moved);
    if (spec != right) wrong.add(spec);
  }
  return g.choice(
    prompt: holesN == 1
        ? 'The paper is folded, then a hole is punched. What does it look '
              'like when it is opened?'
        : 'The paper is folded, then holes are punched. What does it look '
              'like when it is opened?',
    visual: FoldVisual(fold, holes),
    answer: right,
    wrong: wrong,
    count: _choices(g),
    speech: [
      fold == 'vh'
          ? 'The paper is folded in half, and in half again.'
          : 'The paper is folded in half.',
      holesN == 1 ? 'Then a hole is punched.' : 'Then holes are punched.',
      'What does it look like when it is opened?',
    ],
  );
}

// ======================================================== weekly GT test

/// Questions in the weekly GT test: 15 in Kindergarten, 5 more each grade.
int gtTestLength(Level level) =>
    15 + 5 * max(0, level.index - Level.kindergarten.index);

/// The test's three parts, in order: (title, emoji).
const gtSections = [
  ('Word Thinking', '💭'),
  ('Number Thinking', '🧮'),
  ('Shape Thinking', '🔷'),
];

/// The weekly GT test: three parts (words, numbers, shapes), like the
/// CogAT's three batteries, each opened by a short "Part 1 of 3" card.
List<Question> gtTest(Gen g) {
  final total = gtTestLength(g.level);
  final sizes = [
    for (var i = 0; i < 3; i++) total ~/ 3 + (i < total % 3 ? 1 : 0),
  ];
  final parts = [
    (int n) => wordThinking(g, n),
    (int n) => numberThinking(g, n),
    (int n) => shapeThinking(g, n),
  ];
  final young = g.atMost(Level.grade2);
  return [
    for (var i = 0; i < 3; i++) ...[
      ExampleQuestion(
        title: 'Part ${i + 1} of 3: ${gtSections[i].$1}',
        visual: EmojiVisual(gtSections[i].$2, '${sizes[i]} questions'),
        steps: [
          if (i == 0)
            young
                ? 'Listen to each question, then tap your answer.'
                : 'Read each question carefully, then tap your answer.',
          'You get one try for each question, so take your time.',
          if (i == 0) 'Do your best. It is fine not to know them all!',
        ],
      ),
      ...parts[i](sizes[i]),
    ],
  ];
}
