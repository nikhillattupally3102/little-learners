import 'dart:math';

import '../content/daily_focus.dart';
import '../content/puzzles_writing.dart';
import '../models/models.dart';
import '../theme.dart';
import 'gen.dart';

// Multi-format Puzzle and Writing worksheets. Each worksheet rotates through
// several different kinds of task (see math_formats.dart for the pattern).

String _rep(String emoji, int n) => List.filled(n, emoji).join();

/// Items of [xs] whose lowest level is within two levels below this level
/// (so older children get harder items), falling back to everything allowed.
List<T> _near<T>(
  Gen g,
  List<T> xs,
  Level Function(T) lowest, [
  Level Function(T)? highest,
]) {
  final ok = [
    for (final x in xs)
      if (g.atLeast(lowest(x)) && (highest == null || g.atMost(highest(x)))) x,
  ];
  final near = [
    for (final x in ok)
      if (lowest(x).index >= g.level.index - 2) x,
  ];
  return near.length >= 3 ? near : ok;
}

/// Two different picture groups: (group A, group B).
((String, String, List<String>), (String, String, List<String>)) _twoGroups(
  Gen g,
) {
  final two = g.pick(pictureGroups, 2);
  return (two[0], two[1]);
}

// ============================================================== puzzles

// ------------------------------------------------------------ match pairs

List<Question> matchPairs(Gen g) {
  final pool = [for (final grp in pictureGroups) ...grp.$3];
  const pairs = Gen.matchCount;
  final opts = g.byLevel({Level.age2: 2, Level.age3: 3, Level.preK: 4});

  final match = g.keep(
    g.chance(.5)
        ? g.match('Match the same pictures!', [
            for (final e in g.pick(pool, pairs))
              (MatchItem('', e), MatchItem('', e)),
          ])
        : g.match('Match the things that go together!', [
            for (final (a, b) in g.pick(goTogether, pairs))
              (MatchItem('', a), MatchItem('', b)),
          ]),
  );

  final choices = g.mix(g.count - 1, [
    // Find the same picture.
    () {
      final (_, _, items) = g.one(pictureGroups);
      final target = g.one(items);
      return g.choice(
        prompt: 'Find the same one!',
        visual: EmojiVisual(target),
        answer: target,
        wrong: items,
        count: opts,
      );
    },
    // Which pair is the same?
    () {
      final (_, _, items) = g.one(pictureGroups);
      final p = g.pick(items, 4);
      final wrong = ['${p[0]}${p[1]}', '${p[2]}${p[0]}', '${p[1]}${p[3]}'];
      return g.choice(
        prompt: 'Find the two that are the same!',
        visual: const EmojiVisual('🃏'),
        answer: '${p[0]}${p[0]}',
        wrong: wrong,
        count: opts,
      );
    },
    // Which pair is NOT the same?
    () {
      final (_, _, items) = g.one(pictureGroups);
      final p = g.pick(items, 5);
      return g.choice(
        prompt: 'Which pair is not the same?',
        visual: const EmojiVisual('🙈'),
        answer: '${p[0]}${p[1]}',
        wrong: ['${p[2]}${p[2]}', '${p[3]}${p[3]}', '${p[4]}${p[4]}'],
        count: opts,
      );
    },
    // What goes with this?
    () {
      final picks = g.pick(goTogether, 4);
      return g.choice(
        prompt: 'What goes with this?',
        visual: EmojiVisual(picks[0].$1),
        answer: picks[0].$2,
        wrong: [for (final p in picks.skip(1)) p.$2],
        count: opts,
      );
    },
    // Which one belongs in this group?
    if (g.atLeast(Level.age3))
      () {
        final (a, b) = _twoGroups(g);
        final shown = g.pick(a.$3, 4);
        return g.choice(
          prompt: 'Which one belongs with these?',
          visual: MixedVisual(shown.take(3).toList()),
          answer: shown[3],
          wrong: g.pick(b.$3, 3),
          count: opts,
        );
      },
  ]);

  return [...choices.take(2), match, ...choices.skip(2)];
}

// ------------------------------------------------------------- odd one out

const _shapeColors = [
  AppColors.bubblegum,
  AppColors.tangerine,
  AppColors.sunshine,
  AppColors.lime,
  AppColors.sky,
  AppColors.grape,
];
const _clearShapes = [
  ShapeKind.circle,
  ShapeKind.triangle,
  ShapeKind.star,
  ShapeKind.heart,
  ShapeKind.square,
];

List<Question> oddOneOut(Gen g) {
  final n = g.atLeast(Level.preK) ? 4 : 3;
  return g.mix(g.count, [
    // Classic picture odd one out.
    () {
      final (a, b) = _twoGroups(g);
      return g.choice(
        prompt: 'Which one does not belong?',
        visual: const EmojiVisual('🙃'),
        answer: g.one(b.$3),
        wrong: g.pick(a.$3, n - 1),
        count: n,
      );
    },
    // Named group.
    () {
      final (a, b) = _twoGroups(g);
      return g.choice(
        prompt: 'Find the one that is not ${a.$1}!',
        visual: const EmojiVisual('🔍'),
        answer: g.one(b.$3),
        wrong: g.pick(a.$3, n - 1),
        count: n,
      );
    },
    // Which one belongs?
    () {
      final (a, b) = _twoGroups(g);
      final shown = g.pick(a.$3, 4);
      final others = [
        ...pictureGroups.where((x) => x != a).expand((x) => x.$3),
      ];
      return g.choice(
        prompt: 'Which one belongs in this group?',
        visual: MixedVisual(shown.take(3).toList()),
        answer: shown[3],
        wrong: [g.one(b.$3), ...g.pick(others, 3)],
        count: n,
      );
    },
    // Shapes: same shape in different colors, one different shape.
    () {
      final kinds = g.pick(_clearShapes, 2);
      final colors = g.pick(_shapeColors, n);
      final odd = g.r.nextInt(n);
      return ChoiceQuestion(
        prompt: 'Which shape is different?',
        visual: const EmojiVisual('🔷'),
        choices: [
          for (var i = 0; i < n; i++)
            Choice.shape(i == odd ? kinds[1] : kinds[0], colors[i]),
        ],
        answer: odd,
      );
    },
    // Letters vs numbers (K), odd/even and multiples (Grade 1+).
    if (g.atLeast(Level.kindergarten))
      () {
        if (g.atMost(Level.kindergarten)) {
          final letters = g.pick('ABCDEFGHKMNPRTW'.split(''), 3);
          final digit = '${g.between(2, 9)}';
          final numOdd = g.chance(.5);
          return numOdd
              ? g.choice(
                  prompt: 'Which one is not a letter?',
                  visual: const EmojiVisual('🔤'),
                  answer: digit,
                  wrong: letters,
                )
              : g.choice(
                  prompt: 'Which one is not a number?',
                  visual: const EmojiVisual('🔢'),
                  answer: letters[0],
                  wrong: [
                    for (final d in g.pick([2, 3, 4, 5, 6, 7, 8, 9], 3)) '$d',
                  ],
                );
        }
        final top = g.atLeast(Level.grade2) ? 50 : 20;
        final tens = g.atLeast(Level.grade2) && g.chance(.4);
        final List<int> same;
        final int odd;
        if (tens) {
          same = [
            for (final k in g.pick(List.generate(9, (i) => i + 1), 3)) k * 10,
          ];
          odd = g.one([
            for (var x = 11; x < 95; x++)
              if (x % 5 != 0) x,
          ]);
        } else {
          final even = g.chance(.5);
          same = g.pick([
            for (var x = 2; x <= top; x++)
              if (x.isEven == even) x,
          ], 3);
          odd = g.one([
            for (var x = 1; x <= top; x++)
              if (x.isEven != even) x,
          ]);
        }
        return g.choice(
          prompt: tens
              ? 'Which number does not belong? Look at the ones digits.'
              : 'Which number does not belong? Think odd and even.',
          visual: const EmojiVisual('🔢'),
          answer: '$odd',
          wrong: [for (final x in same) '$x'],
        );
      },
    // Words.
    if (g.atLeast(Level.grade1))
      () {
        final two = g.pick(wordGroups, 2);
        return g.choice(
          prompt: 'Which word does not belong?',
          visual: const EmojiVisual('📝'),
          answer: g.one(two[1].$2),
          wrong: g.pick(two[0].$2, 3),
        );
      },
    // Why does it not belong?
    if (g.atLeast(Level.grade1))
      () {
        final three = g.pick(pictureGroups, 3);
        final shown = [...g.pick(three[0].$3, 3), g.one(three[1].$3)]
          ..shuffle(g.r);
        return g.choice(
          prompt: 'One of these does not belong. Why?',
          visual: MixedVisual(shown),
          answer: 'The others ${three[0].$2}.',
          wrong: ['The others ${three[1].$2}.', 'The others ${three[2].$2}.'],
        );
      },
    // Why does the word not belong?
    if (g.atLeast(Level.grade2))
      () {
        final three = g.pick(wordGroups, 3);
        final shown = [...g.pick(three[0].$2, 3), g.one(three[1].$2)]
          ..shuffle(g.r);
        return g.choice(
          prompt: 'Why is one word the odd one out?',
          visual: TextVisual(shown.join(', ')),
          answer: 'The others ${three[0].$1}.',
          wrong: ['The others ${three[1].$1}.', 'The others ${three[2].$1}.'],
        );
      },
  ]);
}

// ------------------------------------------------------------------ shadows

List<Question> shadows(Gen g) {
  final n = g.level == Level.age3 ? 3 : 4;
  final pool = [for (final s in shadowPool) s.$1];
  return g.mix(g.count, [
    // Whose shadow is this?
    () {
      final target = g.one(pool);
      return g.choice(
        prompt: 'Whose shadow is this?',
        visual: ShadowVisual(target),
        answer: target,
        wrong: pool,
        count: n,
      );
    },
    // Which shadow matches the picture?
    () {
      final picks = g.pick(pool, n);
      final order = [...picks]..shuffle(g.r);
      return ChoiceQuestion(
        prompt: 'Which shadow matches?',
        visual: EmojiVisual(picks[0]),
        choices: [for (final e in order) Choice.label(e, silhouette: true)],
        answer: order.indexOf(picks[0]),
      );
    },
    // Biggest / smallest shadow.
    () {
      final e = g.one(pool);
      final big = g.chance(.5);
      final scales = [1.0, .72, .45]..shuffle(g.r);
      final target = big ? scales.indexOf(1.0) : scales.indexOf(.45);
      return ChoiceQuestion(
        prompt: big ? 'Tap the biggest shadow!' : 'Tap the smallest shadow!',
        visual: EmojiVisual('🔦', big ? 'BIGGEST' : 'SMALLEST'),
        choices: [
          for (final s in scales) Choice.label(e, scale: s, silhouette: true),
        ],
        answer: target,
      );
    },
    // Yes or no?
    () {
      final two = g.pick(shadowPool, 2);
      final yes = g.chance(.5);
      final asked = two[0];
      final shown = yes ? two[0] : two[1];
      final list = ['👍', '👎'];
      return ChoiceQuestion(
        prompt: 'Is this the shadow of the ${asked.$1}?',
        visual: ShadowVisual(shown.$1),
        choices: [for (final c in list) Choice.label(c)],
        answer: yes ? 0 : 1,
        speech: [
          'Is this the shadow of the ${asked.$2}?',
          'Thumbs up for yes, thumbs down for no.',
        ],
      );
    },
    // Find the animal shadow.
    if (g.atLeast(Level.preK))
      () {
        final animal = g.one([
          for (final s in shadowPool)
            if (s.$3) s.$1,
        ]);
        final things = g.pick([
          for (final s in shadowPool)
            if (!s.$3) s.$1,
        ], n - 1);
        final order = [animal, ...things]..shuffle(g.r);
        return ChoiceQuestion(
          prompt: 'Find the animal shadow!',
          visual: const EmojiVisual('🐾'),
          choices: [for (final e in order) Choice.label(e, silhouette: true)],
          answer: order.indexOf(animal),
        );
      },
    // Name the shadow (K reads simple words).
    if (g.atLeast(Level.kindergarten))
      () {
        final picks = g.pick(shadowPool, 3);
        return g.choice(
          prompt: 'What is the name of this shadow?',
          visual: ShadowVisual(picks[0].$1),
          answer: picks[0].$2,
          wrong: [for (final p in picks.skip(1)) p.$2],
          speech: [
            'What is the name of this shadow?',
            for (final p in picks) p.$2,
          ],
        );
      },
  ]);
}

// ----------------------------------------------------------------- patterns

List<String> _picSeq(String t, List<String> set, int len) => [
  for (var k = 0; k < len; k++) set['ABCD'.indexOf(t[k % t.length])],
];

/// A number sequence for this level, and its rule when it has a simple one.
(List<int>, String?) _numSeq(Gen g, {bool simple = false}) {
  final kinds = g.byLevel({
    Level.kindergarten: ['ADD'],
    Level.grade1: ['ADD'],
    Level.grade3: ['ADD', 'ADD', 'MUL'],
    Level.grade4: ['ADD', 'MUL', 'GROW'],
    Level.grade5: ['ADD', 'MUL', 'GROW', 'SQ', 'FIB'],
  });
  final kind = simple
      ? g.one(['ADD', if (g.atLeast(Level.grade3)) 'MUL'])
      : g.one(kinds);
  switch (kind) {
    case 'MUL':
      final f = g.one([2, 3]);
      final s = g.between(1, f == 2 ? 6 : 3);
      return ([for (var k = 0; k < 5; k++) s * pow(f, k).toInt()], '×$f');
    case 'GROW':
      final s = g.between(1, 10);
      final seq = [s];
      for (var k = 1; k < 5; k++) {
        seq.add(seq.last + k);
      }
      return (seq, null);
    case 'SQ':
      final s = g.between(1, 5);
      return ([for (var k = s; k < s + 5; k++) k * k], null);
    case 'FIB':
      const fib = [1, 1, 2, 3, 5, 8, 13, 21, 34];
      final s = g.between(1, 4);
      return (fib.sublist(s, s + 5), null);
    default:
      final steps = g.byLevel({
        Level.kindergarten: [1],
        Level.grade1: [1, 2, 5, 10],
        Level.grade2: [2, 3, 4, 5, 10, -2, -5],
        Level.grade3: [3, 4, 6, 25, 50, -3, -10],
        Level.grade4: [6, 7, 9, 25, 50, 100, -4, -25],
        Level.grade5: [8, 12, 15, 25, 75, -6, -50],
      });
      final step = g.one(steps);
      final start = step < 0
          ? g.between(-step * 5, -step * 5 + 30)
          : g.between(0, g.atLeast(Level.grade3) ? 60 : 20);
      final rule = step < 0 ? '−${-step}' : '+$step';
      return ([for (var k = 0; k < 5; k++) start + k * step], rule);
  }
}

List<Question> patterns(Gen g) {
  final templates = g.byLevel({
    Level.age3: ['AB'],
    Level.preK: ['AB', 'AAB', 'ABB'],
    Level.kindergarten: ['ABC', 'AABB', 'ABB', 'AAB'],
    Level.grade1: ['ABBC', 'AABB', 'ABC'],
    Level.grade2: ['ABCD', 'AABC', 'ABBC'],
  });
  final wrongCount = g.level == Level.age3 ? 1 : 2;
  (String, List<String>, List<String>) picPattern() {
    final t = g.one(templates);
    final set = g.pick(g.one(patternSets), 4);
    final len = t.length * 2 + 1 + (t.length < 3 ? 2 : 0);
    return (t, set, _picSeq(t, set, len));
  }

  List<String> distinctIn(String t, List<String> set) => [
    for (var k = 0; k < 4; k++)
      if (t.contains('ABCD'[k])) set[k],
  ];

  return g.mix(g.count, [
    // What comes next?
    () {
      final (t, set, items) = picPattern();
      final target = items.last;
      final used = distinctIn(t, set);
      return g.choice(
        prompt: 'What comes next?',
        visual: PatternVisual([...items.take(items.length - 1), '?']),
        answer: target,
        wrong: [...used, ...set].where((s) => s != target).take(wrongCount),
      );
    },
    // What is missing in the middle?
    () {
      final (t, set, items) = picPattern();
      final i = g.between(t.length, items.length - 2);
      final target = items[i];
      final used = distinctIn(t, set);
      return g.choice(
        prompt: 'What is missing?',
        visual: PatternVisual([
          for (var k = 0; k < items.length; k++) k == i ? '?' : items[k],
        ]),
        answer: target,
        wrong: [...used, ...set].where((s) => s != target).take(wrongCount),
      );
    },
    // Growing pattern.
    () {
      final e = g.one(['⭐', '🍎', '🔵', '🐞', '🌸']);
      final step = g.atLeast(Level.grade1) ? g.between(1, 2) : 1;
      final start = g.atLeast(Level.kindergarten) ? g.between(1, 2) : 1;
      final counts = [for (var k = 0; k < 4; k++) start + k * step];
      final ans = counts.last;
      return g.choice(
        prompt: 'Watch it grow! What comes next?',
        visual: TextVisual(
          [for (final c in counts.take(3)) _rep(e, c)].join('\n'),
        ),
        answer: _rep(e, ans),
        wrong: [
          _rep(e, counts[2]),
          _rep(e, ans + 1),
          if (ans > 2) _rep(e, ans - step - 1) else _rep(e, ans + 2),
        ],
        count: wrongCount + 1,
      );
    },
    // Copy the pattern.
    if (g.atMost(Level.kindergarten))
      () {
        final (t, set, items) = picPattern();
        final row = items.take(max(4, t.length * 2)).toList();
        final correct = row.join();
        final wrong = <String>{};
        for (var tries = 0; tries < 30 && wrong.length < 2; tries++) {
          final s = ([...row]..shuffle(g.r)).join();
          if (s != correct) wrong.add(s);
        }
        if (wrong.isEmpty)
          wrong.add(
            [...row.reversed].join() == correct
                ? set.reversed.join()
                : [...row.reversed].join(),
          );
        return g.choice(
          prompt: 'Which row looks just the same?',
          visual: TextVisual(row.join(' ')),
          answer: correct,
          wrong: wrong,
          count: wrongCount + 1,
        );
      },
    // Which two come next?
    if (g.atLeast(Level.kindergarten))
      () {
        final (t, set, items) = picPattern();
        final shown = items.take(t.length * 2).toList();
        final a = items.length > shown.length ? items[shown.length] : set[0];
        final b = _picSeq(t, set, shown.length + 2).last;
        final used = distinctIn(t, set);
        final wrong = <String>{
          for (final x in used)
            for (final y in used) '$x$y',
        }..remove('$a$b');
        return g.choice(
          prompt: 'Which two come next?',
          visual: PatternVisual([...shown, '?', '?']),
          answer: '$a$b',
          wrong: wrong,
          count: 3,
        );
      },
    // Number patterns.
    if (g.atLeast(Level.kindergarten))
      () {
        final (seq, _) = _numSeq(g);
        return g.number(
          prompt: 'What number comes next?',
          visual: PatternVisual([...seq.take(4).map((e) => '$e'), '?']),
          answer: seq.last,
          count: g.atLeast(Level.grade1) ? 4 : 3,
        );
      },
    if (g.atLeast(Level.grade1))
      () {
        final (seq, _) = _numSeq(g);
        final i = g.between(1, 3);
        return g.number(
          prompt: 'Find the missing number in the pattern!',
          visual: PatternVisual([
            for (var k = 0; k < 5; k++) k == i ? '?' : '${seq[k]}',
          ]),
          answer: seq[i],
        );
      },
    // Letter patterns.
    if (g.atLeast(Level.grade1))
      () {
        final step = g.between(1, g.atLeast(Level.grade2) ? 3 : 2);
        final start = g.between(0, 25 - step * 4);
        String l(int i) => String.fromCharCode(65 + i);
        final ans = start + step * 4;
        return g.choice(
          prompt: 'What letter comes next?',
          visual: PatternVisual([
            for (var k = 0; k < 4; k++) l(start + step * k),
            '?',
          ]),
          answer: l(ans),
          wrong: {
            for (final d in [-1, 1, 2, -2])
              if (ans + d >= 0 && ans + d < 26) l(ans + d),
          },
          count: 4,
        );
      },
    // What is the rule?
    if (g.atLeast(Level.grade2))
      () {
        final (seq, rule) = _numSeq(g, simple: true);
        final r = rule!;
        final diff = seq[1] - seq[0];
        final wrong = <String>{
          if (r.startsWith('×')) ...[
            '+$diff',
            '×${int.parse(r.substring(1)) + 1}',
            '+${seq[0]}',
          ] else ...[
            diff > 0 ? '+${diff + 1}' : '−${-diff + 1}',
            diff > 0 ? '−$diff' : '+${-diff}',
            diff > 1 ? '+${diff - 1}' : '×2',
            '×2',
          ],
        }..remove(r);
        return g.choice(
          prompt: 'What is the rule?',
          visual: PatternVisual([for (final x in seq) '$x']),
          answer: r,
          wrong: wrong,
          count: 4,
        );
      },
    // Find the mistake.
    if (g.atLeast(Level.grade2))
      () {
        final (seq0, rule) = _numSeq(g, simple: true);
        final seq = [...seq0];
        final i = g.between(1, 4);
        final up = g.chance(.5);
        seq[i] += up ? 1 : -1;
        if (seq[i] < 0 || seq0.contains(seq[i]))
          seq[i] = seq0[i] + (up ? -1 : 1);
        return g.choice(
          prompt: 'Which number breaks the pattern?',
          visual: PatternVisual([for (final x in seq) '$x']),
          answer: '${seq[i]}',
          wrong: [
            for (var k = 0; k < 5; k++)
              if (k != i) '${seq[k]}',
          ],
          count: 4,
        );
      },
  ]);
}

// ------------------------------------------------------------------- sudoku

List<List<String>> _grid(Gen g, List<String> symbols) {
  // Start from a valid 4×4 grid, then shuffle symbols, rows within bands and columns within stacks.
  const base = [
    [0, 1, 2, 3],
    [2, 3, 0, 1],
    [1, 0, 3, 2],
    [3, 2, 1, 0],
  ];
  final perm = g.pick([0, 1, 2, 3], 4);
  final bands = g.chance(.5) ? [0, 1] : [1, 0];
  final rowOrder = [
    for (final b in bands) ...g.pick([b * 2, b * 2 + 1], 2),
  ];
  final colOrder = [
    ...g.pick([0, 1], 2),
    ...g.pick([2, 3], 2),
  ];
  return [
    for (final r in rowOrder)
      [for (final c in colOrder) symbols[perm[base[r][c]]]],
  ];
}

List<Question> sudoku(Gen g) {
  final pictures = g.atMost(Level.grade1);
  final symbols = pictures
      ? g.pick(['🍎', '🍌', '🍇', '🍊', '🐶', '🐱', '🐸', '⭐'], 4)
      : ['1', '2', '3', '4'];
  final blanks = g.byLevel({
    Level.kindergarten: 3,
    Level.grade1: 4,
    Level.grade2: 5,
    Level.grade3: 6,
    Level.grade4: 7,
    Level.grade5: 8,
  });
  final sep = pictures ? '' : ' ';
  return g.mix(g.count, [
    // Classic 4×4.
    () {
      final grid = _grid(g, symbols);
      final target = g.r.nextInt(16);
      final tr = target ~/ 4, tc = target % 4;
      List<int> hidden = [target];
      for (var tries = 0; tries < 100; tries++) {
        final extra = g.pick(
          List.generate(16, (i) => i).where((i) => i != target),
          blanks - 1,
        );
        final cand = [target, ...extra];
        final seen = <String>{};
        for (var i = 0; i < 16; i++) {
          if (cand.contains(i)) continue;
          final r = i ~/ 4, c = i % 4;
          final sameBox = r ~/ 2 == tr ~/ 2 && c ~/ 2 == tc ~/ 2;
          if (r == tr || c == tc || sameBox) seen.add(grid[r][c]);
        }
        if (seen.length == 3) {
          hidden = cand;
          break;
        }
      }
      final cells = [
        for (var i = 0; i < 16; i++)
          i == target
              ? '?'
              : hidden.contains(i)
              ? ''
              : grid[i ~/ 4][i % 4],
      ];
      return g.choice(
        prompt:
            'Each row, column and box has one of each. What goes in the ? box?',
        visual: SudokuVisual(cells),
        answer: grid[tr][tc],
        wrong: symbols,
        speech: const [
          'Each row, column and box has one of each. What goes in the question box?',
        ],
      );
    },
    // One row.
    () {
      final row = g.pick(symbols, 4);
      final i = g.r.nextInt(4);
      return g.choice(
        prompt: 'Which one is missing from this row?',
        visual: PatternVisual([
          for (var k = 0; k < 4; k++) k == i ? '?' : row[k],
        ]),
        answer: row[i],
        wrong: symbols,
      );
    },
    // One column inside the grid.
    () {
      final grid = _grid(g, symbols);
      final c = g.r.nextInt(4), r = g.r.nextInt(4);
      return g.choice(
        prompt: 'Fill the column! What goes in the ? box?',
        visual: SudokuVisual([
          for (var i = 0; i < 16; i++)
            i % 4 != c
                ? ''
                : i ~/ 4 == r
                ? '?'
                : grid[i ~/ 4][c],
        ]),
        answer: grid[r][c],
        wrong: symbols,
        speech: const [
          'Each column has one of each. What goes in the question box?',
        ],
      );
    },
    // Which row follows the rule?
    () {
      final good = g.pick(symbols, 4);
      final wrong = <String>{};
      for (var tries = 0; tries < 40 && wrong.length < 3; tries++) {
        final bad = g.pick(symbols, 4);
        final i = g.r.nextInt(4), j = (i + 1 + g.r.nextInt(3)) % 4;
        bad[i] = bad[j];
        wrong.add(bad.join(sep));
      }
      return g.choice(
        prompt: 'Which row has one of each?',
        visual: EmojiVisual('🔲', symbols.join(' ')),
        answer: good.join(sep),
        wrong: wrong,
      );
    },
    // 3×3 grid as a text card.
    if (g.atMost(Level.grade2))
      () {
        final three = pictures
            ? g.pick(['🔴', '🔵', '🟡', '🟢'], 3)
            : ['1', '2', '3'];
        final perm = g.pick([0, 1, 2], 3);
        final rows = g.pick([0, 1, 2], 3);
        final grid = [
          for (final r in rows)
            [for (var c = 0; c < 3; c++) three[perm[(r + c) % 3]]],
        ];
        final tr = g.r.nextInt(3), tc = g.r.nextInt(3);
        final text = [
          for (var r = 0; r < 3; r++)
            [for (var c = 0; c < 3; c++) r == tr && c == tc ? '❓' : grid[r][c]]
                .join('  '),
        ].join('\n');
        return g.choice(
          prompt: 'Finish the small grid! Each row and column has one of each.',
          visual: TextVisual(text),
          answer: grid[tr][tc],
          wrong: three,
        );
      },
    // Spot the mistake.
    if (g.atLeast(Level.grade1))
      () {
        final grid = _grid(g, symbols);
        final r = g.r.nextInt(4), c = g.r.nextInt(4);
        final other = g.one(symbols.where((s) => s != grid[r][c]).toList());
        grid[r][c] = other;
        return g.choice(
          prompt: 'Find the row with a mistake!',
          visual: SudokuVisual([
            for (var i = 0; i < 16; i++) grid[i ~/ 4][i % 4],
          ]),
          answer: 'Row ${r + 1}',
          wrong: [for (var k = 1; k <= 4; k++) 'Row $k'],
          speech: const [
            'One row has the same thing twice. Which row has the mistake?',
          ],
        );
      },
  ]);
}

// ------------------------------------------------------------------ riddles

List<Question> riddles(Gen g) {
  final top = g.byLevel({
    Level.grade1: 20,
    Level.grade2: 100,
    Level.grade3: 100,
    Level.grade5: 200,
  });
  return g.mix(g.count, [
    // Who am I? (number clues)
    () {
      final n = g.between(3, top - 2);
      final even = n.isEven;
      final tens = (n ~/ 10) % 10;
      final useTens = g.atLeast(Level.grade2) && n >= 10;
      final useFive = g.atLeast(Level.grade3) && n % 5 == 0;
      bool fitsExtra(int x) =>
          x.isEven == even &&
          (!useTens || (x ~/ 10) % 10 == tens) &&
          (!useFive || x % 5 == 0);
      // Start with a loose range, then tighten it just enough that only n fits.
      var lo = max(0, n - g.between(3, 8)), hi = n + g.between(3, 8);
      final others = [
        for (var x = lo + 1; x < hi; x++)
          if (x != n && fitsExtra(x)) x,
      ];
      final below = others.where((x) => x < n),
          above = others.where((x) => x > n);
      if (below.isNotEmpty) lo = below.reduce(max);
      if (above.isNotEmpty) hi = above.reduce(min);
      final clues = [
        'I am more than $lo and less than $hi.',
        'I am ${even ? 'even' : 'odd'}.',
        if (useTens) 'My tens digit is $tens.',
        if (useFive) 'I am a multiple of 5.',
      ];
      bool fits(int x) => x > lo && x < hi && fitsExtra(x);
      final wrong = <String>{};
      for (var x = max(0, lo - 3); x <= hi + 3 && wrong.length < 6; x++) {
        if (!fits(x)) wrong.add('$x');
      }
      return g.choice(
        prompt: 'Who am I?',
        visual: TextVisual(clues.join('\n'), emoji: '🕵️'),
        answer: '$n',
        wrong: wrong,
        count: 4,
        speech: [...clues, 'Who am I?'],
      );
    },
    // Logic: put people in order.
    () {
      final count = g.atLeast(Level.grade3) ? 4 : 3;
      final people = g.pick(puzzleNames, count); // biggest first
      final (more, less, most, least) = g.one(comparisons);
      final clues = [
        for (var i = 0; i < count - 1; i++)
          g.chance(.5)
              ? '${people[i]} is $more than ${people[i + 1]}.'
              : '${people[i + 1]} is $less than ${people[i]}.',
      ]..shuffle(g.r);
      final ask = g.r.nextInt(count == 3 ? 3 : 2);
      final (question, answer) = switch (ask) {
        0 => ('Who is the $most?', people.first),
        1 => ('Who is the $least?', people.last),
        _ => ('Who is in the middle?', people[1]),
      };
      return g.choice(
        prompt: 'Think it through! $question',
        visual: TextVisual(clues.join('\n'), emoji: '🧠'),
        answer: answer,
        wrong: people,
        speech: [...clues, question],
      );
    },
    // Balance puzzles.
    () {
      final syms = g.pick(balanceSymbols, 2);
      final a = syms[0], b = syms[1];
      if (g.atMost(Level.grade2)) {
        final k = g.between(2, g.atLeast(Level.grade2) ? 4 : 3);
        final v = g.between(1, g.atLeast(Level.grade2) ? 10 : 5);
        return g.number(
          prompt: 'What is one $a worth?',
          visual: TextVisual(
            '${List.filled(k, a).join(' + ')} = ${k * v}',
            emoji: '⚖️',
          ),
          answer: v,
          lowest: 1,
        );
      }
      final va = g.between(2, g.atLeast(Level.grade4) ? 15 : 9);
      final vb = g.between(1, g.atLeast(Level.grade4) ? 15 : 9);
      final lines = g.atLeast(Level.grade4)
          ? ['$a + $a + $a = ${3 * va}', '$a + $b + $b = ${va + 2 * vb}']
          : ['$a + $a = ${2 * va}', '$a + $b = ${va + vb}'];
      return g.number(
        prompt: 'What is one $b worth?',
        visual: TextVisual(lines.join('\n'), emoji: '⚖️'),
        answer: vb,
        lowest: 0,
      );
    },
    // Number-line hops.
    () {
      final start = g.between(2, g.atLeast(Level.grade3) ? 40 : 10);
      final fwd = g.between(2, g.atLeast(Level.grade3) ? 15 : 6);
      final back = g.between(1, g.atLeast(Level.grade3) ? 12 : 5);
      final animal = g.one([
        ('frog', '🐸'),
        ('bunny', '🐰'),
        ('kangaroo', '🦘'),
        ('grasshopper', '🦗'),
      ]);
      final text =
          'A ${animal.$1} starts on $start.\nIt hops forward $fwd.\nThen it hops back $back.';
      return g.number(
        prompt: 'Where does the ${animal.$1} land?',
        visual: TextVisual(text, emoji: animal.$2),
        answer: start + fwd - back,
        lowest: 0,
        speech: [...text.split('\n'), 'Where does the ${animal.$1} land?'],
      );
    },
    // Word riddles.
    () {
      final pool = _near(g, wordRiddles, (r) => r.$4);
      final (text, answer, wrong, _) = g.one(pool);
      return g.choice(
        prompt: 'What am I?',
        visual: TextVisual(text, emoji: '🤔'),
        answer: answer,
        wrong: wrong,
        speech: [text, 'What am I?'],
      );
    },
    // Analogies.
    () {
      final pool = _near(g, analogies, (r) => r.$4);
      final (text, answer, wrong, _) = g.one(pool);
      return g.choice(
        prompt: 'Finish the word puzzle!',
        visual: TextVisual(text, emoji: '🔗'),
        answer: answer,
        wrong: wrong,
        speech: [text.replaceAll('___', 'blank'), 'Which word fits?'],
      );
    },
    // Magic squares.
    if (g.atLeast(Level.grade3))
      () {
        var sq = [
          [2, 7, 6],
          [9, 5, 1],
          [4, 3, 8],
        ];
        for (var k = g.r.nextInt(4); k > 0; k--) {
          sq = [
            for (var c = 0; c < 3; c++) [for (var r = 2; r >= 0; r--) sq[r][c]],
          ];
        }
        if (g.chance(.5)) sq = [for (final row in sq) row.reversed.toList()];
        final add = g.atLeast(Level.grade4)
            ? g.between(0, 10)
            : g.between(0, 3);
        final total = 15 + add * 3;
        final hide = g.r.nextInt(9);
        final text = [
          for (var r = 0; r < 3; r++)
            [
              for (var c = 0; c < 3; c++)
                r * 3 + c == hide ? '?' : '${sq[r][c] + add}',
            ].join('   '),
        ].join('\n');
        return g.number(
          prompt:
              'Magic square! Every row, column and diagonal adds to $total. What is ?',
          visual: TextVisual(text, emoji: '✨'),
          answer: sq[hide ~/ 3][hide % 3] + add,
          lowest: 0,
          speech: [
            'Magic square! Every row, column and diagonal adds up to $total. What is the missing number?',
          ],
        );
      },
    // Think of a number.
    if (g.atLeast(Level.grade3))
      () {
        final x = g.between(2, g.atLeast(Level.grade4) ? 15 : 9);
        final k = g.between(2, g.atLeast(Level.grade4) ? 5 : 3);
        final b = g.between(1, 12);
        final steps =
            'I think of a number.\nI multiply it by $k, then add $b.\nNow I have ${x * k + b}.';
        return g.number(
          prompt: 'What was my number?',
          visual: TextVisual(steps, emoji: '💭'),
          answer: x,
          lowest: 0,
          speech: [...steps.split('\n'), 'What was my number?'],
        );
      },
    // Ages.
    if (g.atLeast(Level.grade4))
      () {
        final two = g.pick(puzzleNames, 2);
        final young = g.between(3, 12), diff = g.between(1, 6);
        final text =
            '${two[0]} is $diff year${diff == 1 ? '' : 's'} older than ${two[1]}.\nTogether their ages add up to ${2 * young + diff}.';
        return g.number(
          prompt: 'How old is ${two[1]}?',
          visual: TextVisual(text, emoji: '🎂'),
          answer: young,
          lowest: 1,
          speech: [...text.split('\n'), 'How old is ${two[1]}?'],
        );
      },
  ]);
}

// ----------------------------------------------------------- missing number

List<Question> missingNumber(Gen g) => g.mix(g.count, [
  // Equation with a box.
  () {
    final (text, answer) = switch (g.level) {
      Level.grade2 =>
        g.chance(.5)
            ? (() {
                final a = g.between(2, 12), x = g.between(2, 9);
                return ('$a + ? = ${a + x}', x);
              })()
            : (() {
                final x = g.between(8, 20), b = g.between(2, 7);
                return ('? − $b = ${x - b}', x);
              })(),
      Level.grade3 => (() {
        final a = g.between(2, 10), x = g.between(2, 10);
        return g.chance(.5)
            ? ('$a × ? = ${a * x}', x)
            : ('${a * x} ÷ ? = $a', x);
      })(),
      Level.grade4 => (() {
        final a = g.between(12, 80), x = g.between(11, 60);
        return g.chance(.5)
            ? ('$a + ? = ${a + x}', x)
            : ('${a + x} − ? = $a', x);
      })(),
      _ => (() {
        final a = g.between(2, 9), x = g.between(2, 12), b = g.between(1, 20);
        return ('$a × ? + $b = ${a * x + b}', x);
      })(),
    };
    return g.number(
      prompt: 'Find the missing number!',
      visual: TextVisual(text, emoji: '❓'),
      answer: answer,
    );
  },
  // Number line.
  () {
    final step = g.one(
      g.byLevel({
        Level.grade2: [2, 5, 10],
        Level.grade3: [3, 4, 25, 50],
        Level.grade4: [6, 8, 25, 100],
        Level.grade5: [7, 9, 15, 250],
      }),
    );
    final start = step * g.between(0, 10);
    final i = g.between(1, 3);
    return g.number(
      prompt: 'Which number is hiding on the number line?',
      visual: PatternVisual([
        for (var k = 0; k < 5; k++) k == i ? '?' : fmt(start + k * step),
      ]),
      answer: start + i * step,
    );
  },
  // Hundred chart / times-table chart window.
  () {
    final times = g.atLeast(Level.grade4);
    final List<List<int>> cells;
    if (times) {
      final a = g.between(2, 8), b = g.between(2, 8);
      cells = [
        for (var r = a; r < a + 3; r++) [for (var c = b; c < b + 3; c++) r * c],
      ];
    } else {
      final c0 = g.between(1, 8) * 10 + g.between(2, 8);
      cells = [
        for (var r = -1; r <= 1; r++)
          [for (var c = -1; c <= 1; c++) c0 + r * 10 + c],
      ];
    }
    final hide = g.r.nextInt(9);
    final text = [
      for (var r = 0; r < 3; r++)
        [for (var c = 0; c < 3; c++) r * 3 + c == hide ? '?' : '${cells[r][c]}']
            .join('   '),
    ].join('\n');
    return g.number(
      prompt: times
          ? 'Look at this piece of the times-table chart. What is missing?'
          : 'Look at this piece of the hundred chart. What is missing?',
      visual: TextVisual(text, emoji: times ? '✖️' : '💯'),
      answer: cells[hide ~/ 3][hide % 3],
    );
  },
  // Number pyramid.
  () {
    final hi = g.byLevel({
      Level.grade2: 6,
      Level.grade3: 12,
      Level.grade4: 25,
      Level.grade5: 60,
    });
    final bottom = [for (var k = 0; k < 3; k++) g.between(1, hi)];
    final mid = [bottom[0] + bottom[1], bottom[1] + bottom[2]];
    final topN = mid[0] + mid[1];
    final hide = g.r.nextInt(
      g.atLeast(Level.grade3) ? 6 : 3,
    ); // 0 top, 1-2 middle, 3-5 bottom
    String show(int idx, int v) => idx == hide ? '?' : '$v';
    // Hiding a middle block needs the top; hiding a bottom block needs its middle.
    final text = [
      show(0, topN),
      '${show(1, mid[0])}     ${show(2, mid[1])}',
      '${show(3, bottom[0])}     ${show(4, bottom[1])}     ${show(5, bottom[2])}',
    ].join('\n');
    final answer = [
      topN,
      mid[0],
      mid[1],
      bottom[0],
      bottom[1],
      bottom[2],
    ][hide];
    return g.number(
      prompt:
          'Number pyramid! Each block is the sum of the two blocks under it.',
      visual: TextVisual(text, emoji: '🔺'),
      answer: answer,
      speech: const [
        'Number pyramid! Each block is the sum of the two blocks under it. What is the missing number?',
      ],
    );
  },
  // Function machine.
  () {
    final k = g.between(2, g.atLeast(Level.grade4) ? 5 : 9),
        b = g.between(1, 9);
    int f(int x) => switch (g.level) {
      Level.grade2 => x + k,
      Level.grade3 => x * k,
      _ => x * k + b,
    };
    final ins = g.pick(List.generate(10, (i) => i + 1), 4);
    final text = [
      'IN → OUT',
      for (final x in ins.take(3)) '$x → ${f(x)}',
      '${ins[3]} → ?',
    ].join('\n');
    return g.number(
      prompt: 'The number machine follows one rule. What comes out?',
      visual: TextVisual(text, emoji: '⚙️'),
      answer: f(ins[3]),
      speech: [
        'The number machine follows one rule. What comes out when ${ins[3]} goes in?',
      ],
    );
  },
  // Balance both sides.
  () {
    final mult = g.atLeast(Level.grade3) && g.chance(.5);
    if (mult) {
      final a = g.between(2, 9), b = g.between(2, 9);
      final factors = [
        for (var d = 2; d <= a * b ~/ 2; d++)
          if ((a * b) % d == 0 && d != a && d != b) d,
      ];
      if (factors.isNotEmpty) {
        final c = g.one(factors);
        return g.number(
          prompt: 'Make both sides equal!',
          visual: TextVisual('$a × $b = $c × ?', emoji: '⚖️'),
          answer: a * b ~/ c,
        );
      }
    }
    final hi = g.atLeast(Level.grade4) ? 60 : 15;
    final a = g.between(2, hi),
        b = g.between(2, hi),
        c = g.between(1, a + b - 1);
    return g.number(
      prompt: 'Make both sides equal!',
      visual: TextVisual('$a + $b = $c + ?', emoji: '⚖️'),
      answer: a + b - c,
    );
  },
]);

// ============================================================== writing

// ------------------------------------------------------------------ tracing

List<Question> tracing(Gen g, {PreKWords? today}) {
  // Pre-K traces only today's sight words and three-letter words.
  if (today != null) {
    final cvc = [for (final w in today.cvc) (w.$1, w.$2.replaceAll('-', ''))];
    final [s1, s2] = today.sight;
    final words = [s1, cvc[0].$2, s2, cvc[1].$2];
    return [
      for (final (i, w) in words.indexed)
        TraceQuestion(
          glyph: w,
          hint: i.isEven
              ? 'Say it: "$w" 👀'
              : '${w.split('').join('-')} ${cvc[i ~/ 2].$1}',
          speech: 'Trace the word $w. ${w.split('').join(', ')}. $w!',
        ),
      () {
        final target = g.one(words);
        return g.choice(
          prompt: 'Find the word you traced!',
          visual: const ListenVisual(),
          answer: target,
          wrong: words,
          count: 3,
          speech: ['Find the word $target!'],
        );
      }(),
    ];
  }
  if (g.level == Level.age2) {
    final strokes = g.pick(traceStrokes, 4);
    final target = g.one(strokes);
    return [
      for (final (glyph, hint, _) in strokes)
        TraceQuestion(
          glyph: glyph,
          hint: hint,
          speech: 'Trace the line with your finger!',
        ),
      g.choice(
        prompt: 'Which one goes ${target.$3}?',
        visual: EmojiVisual(target.$2.split(' ').last),
        answer: target.$1,
        wrong: [for (final s in strokes) s.$1],
        count: 2,
      ),
    ];
  }

  TraceQuestion letter(String l, {bool lower = false}) {
    final glyph = lower ? l.toLowerCase() : l;
    final (emoji, word) = traceLetters[l]!;
    final phrase = l == 'X' ? 'X is at the end of fox' : '$glyph is for $word';
    return TraceQuestion(
      glyph: glyph,
      hint: '$phrase $emoji',
      speech: 'Trace the letter $glyph. $phrase!',
    );
  }

  TraceQuestion number(int top) {
    final n = g.between(1, top);
    return TraceQuestion(
      glyph: '$n',
      hint: _rep('🎈', n),
      speech: 'Trace the number $n. Count the balloons!',
    );
  }

  TraceQuestion word((String, String) w) => TraceQuestion(
    glyph: w.$2,
    hint: 'Write the word "${w.$2}" ${w.$1}',
    speech: 'Trace the word ${w.$2}.',
  );

  final letters = g.pick(traceLetters.keys, 4);
  switch (g.level) {
    case Level.age3 || Level.preK:
      final target = letters[g.r.nextInt(3)];
      final check = g.chance(.5) || g.level == Level.age3
          ? g.choice(
              prompt: 'Find the letter $target!',
              visual: const ListenVisual(),
              answer: target,
              wrong: letters,
              count: g.level == Level.age3 ? 2 : 3,
            )
          : g.match('Match each letter to its picture!', [
              for (final l in g.pick(traceLetters.keys, Gen.matchCount))
                (MatchItem(l), MatchItem('', traceLetters[l]!.$1)),
            ]);
      return [
        letter(letters[0]),
        letter(letters[1]),
        number(g.level == Level.age3 ? 5 : 9),
        letter(letters[2]),
        check,
      ];
    case Level.kindergarten:
      final w = g.one(traceWords.where((w) => w.$2.length == 3).toList());
      return [
        letter(letters[0], lower: true),
        letter(letters[1], lower: true),
        word(w),
        letter(letters[2], lower: true),
        g.match('Match the big and small letters!', [
          for (final l in g.pick('ABDEFGHJLMNQRT'.split(''), Gen.matchCount))
            (MatchItem(l), MatchItem(l.toLowerCase())),
        ]),
      ];
    default: // Grade 1
      final words = g.pick(traceWords, 4);
      final pair = letters[3];
      return [
        word(words[0]),
        TraceQuestion(
          glyph: '$pair${pair.toLowerCase()}',
          hint: 'Big $pair and little ${pair.toLowerCase()}',
          speech: 'Trace big $pair and little ${pair.toLowerCase()}.',
        ),
        word(words[1]),
        word(words[2]),
        g.choice(
          prompt: 'Which word matches the picture?',
          visual: EmojiVisual(words[3].$1),
          answer: words[3].$2,
          wrong: [
            for (final w in g.pick(traceWords.where((w) => w != words[3]), 3))
              w.$2,
          ],
        ),
      ];
  }
}

// ----------------------------------------------------------------- spelling

String _scramble(Gen g, String word) {
  final letters = word.toUpperCase().split('');
  for (var tries = 0; tries < 20; tries++) {
    final s = ([...letters]..shuffle(g.r)).join(' ');
    if (s.replaceAll(' ', '') != word.toUpperCase()) return s;
  }
  return letters.reversed.join(' ');
}

List<Question> spelling(Gen g) {
  if (g.atMost(Level.grade1)) {
    final words = g.atLeast(Level.grade1)
        ? pictureWords
        : pictureWords.where((w) => w.$2.length <= 4).toList();
    return g.mix(g.count, [
      // Missing letter.
      () {
        final (emoji, word, _) = g.one(words);
        final missing = g.r.nextInt(word.length);
        return g.choice(
          prompt: 'Which letter is missing?',
          visual: WordPictureVisual(emoji, word, missing),
          answer: word[missing],
          wrong: 'ABCDEFGHIJKLMNOPRSTUVWY'.split(''),
          count: 4,
        );
      },
      // Choose the right spelling for the picture.
      () {
        final (emoji, word, wrong) = g.one(words);
        return g.choice(
          prompt: 'Which word matches the picture?',
          visual: EmojiVisual(emoji),
          answer: word,
          wrong: wrong,
          count: g.atLeast(Level.grade1) ? 4 : 3,
        );
      },
      // First sound.
      () {
        final (emoji, word, _) = g.one(words);
        return g.choice(
          prompt: 'Which letter does it start with?',
          visual: EmojiVisual(emoji),
          answer: word[0],
          wrong: 'BCDFGHKLMNPRSTW'.split(''),
          count: 3,
        );
      },
      // Unscramble.
      () {
        final (emoji, word, wrong) = g.one(words);
        return g.choice(
          prompt: 'Put the letters in order to spell the picture!',
          visual: TextVisual(_scramble(g, word), emoji: emoji),
          answer: word,
          wrong: [_scramble(g, word).replaceAll(' ', ''), ...wrong],
          count: 3,
        );
      },
      if (g.atLeast(Level.grade1))
        () {
          final (emoji, word, _) = g.one(words);
          return g.choice(
            prompt: 'Which letter does it end with?',
            visual: EmojiVisual(emoji),
            answer: word[word.length - 1],
            wrong: 'BDEGKLMNPRSTX'.split(''),
            count: 3,
          );
        },
      if (g.atLeast(Level.grade1))
        () {
          final picks = g.pick(pictureWords, 4);
          final bad = g.one(picks[0].$3);
          return g.choice(
            prompt: 'Oops! Which word is spelled wrong?',
            visual: const EmojiVisual('🐝'),
            answer: bad,
            wrong: [for (final p in picks.skip(1)) p.$2],
          );
        },
    ]);
  }

  final pool = _near(g, spellList, (w) => w.$1, (w) => w.$2);
  final endings = _near(g, endingWords, (w) => w.$1, (w) => w.$2);
  final plurals = _near(g, pluralWords, (w) => w.$1, (w) => w.$2);
  return g.mix(g.count, [
    // Which is spelled correctly?
    () {
      final (_, _, word, wrong) = g.one(pool);
      return g.choice(
        prompt: 'Which word is spelled correctly?',
        visual: const EmojiVisual('🐝'),
        answer: word,
        wrong: wrong,
        speech: ['Which word is spelled correctly?', word],
      );
    },
    // Which is spelled wrong?
    () {
      final picks = g.pick(pool, 4);
      final bad = g.one(picks[0].$4);
      return g.choice(
        prompt: 'Oops! Which word is spelled wrong?',
        visual: const EmojiVisual('🔎'),
        answer: bad,
        wrong: [for (final p in picks.skip(1)) p.$3],
      );
    },
    // Unscramble.
    () {
      final (_, _, word, wrong) = g.one(pool);
      return g.choice(
        prompt: 'Unscramble the letters!',
        visual: TextVisual(_scramble(g, word), emoji: '🔀'),
        answer: word,
        wrong: wrong,
      );
    },
    // Missing vowel.
    () {
      final longWords = [
        for (final w in pool)
          if (w.$3.length >= 6) w,
      ];
      final (_, _, word, _) = g.one(longWords.isEmpty ? pool : longWords);
      final vowels = [
        for (var i = 1; i < word.length; i++)
          if ('aeiou'.contains(word[i])) i,
      ];
      final i = vowels.isEmpty ? 1 : g.one(vowels);
      return g.choice(
        prompt: 'Which letter fills the gap?',
        visual: TextVisual(
          '${word.substring(0, i)}_${word.substring(i + 1)}',
          emoji: '✏️',
        ),
        answer: word[i],
        wrong: 'aeiou'.split(''),
        count: 4,
        speech: ['Which letter fills the gap in the word $word?'],
      );
    },
    // Add an ending.
    () {
      final (_, _, base, end, word, wrong) = g.one(endings);
      return g.choice(
        prompt: 'Add the ending! How do you spell it?',
        visual: TextVisual('$base + $end', emoji: '🧩'),
        answer: word,
        wrong: wrong,
      );
    },
    // Plurals.
    () {
      final (_, _, one, more, wrong) = g.one(plurals);
      return g.choice(
        prompt: 'More than one! How do you spell it?',
        visual: TextVisual('one $one → two ___', emoji: '✌️'),
        answer: more,
        wrong: wrong,
        speech: ['One $one. Two blank. How do you spell it?'],
      );
    },
  ]);
}

// ------------------------------------------------------------- fix sentence

List<Question> fixSentence(Gen g) {
  final older = g.atLeast(Level.grade3);
  return g.mix(g.count, [
    // Which sentence is written correctly?
    () {
      final pool = _near(g, correctSentences, (s) => s.$1, (s) => s.$2);
      final (_, _, correct, wrong) = g.one(pool);
      return g.choice(
        prompt: 'Which sentence is written correctly?',
        visual: const EmojiVisual('✍️'),
        answer: correct,
        wrong: wrong,
        count: 4,
      );
    },
    // End marks.
    if (g.atMost(Level.grade3))
      () {
        final (_, text, mark) = g.one(_near(g, endMarkSentences, (s) => s.$1));
        final marks = switch (mark) {
          '.' => ['.', '?'],
          '?' => ['.', '?', '!'],
          _ => ['!', '?'],
        };
        return g.choice(
          prompt: 'What mark goes at the end?',
          visual: TextVisual('$text ___'),
          answer: mark,
          wrong: marks,
          speech: ['What mark goes at the end?', text],
        );
      },
    // Sentence types.
    () {
      final pool = [
        for (final s in sentenceKinds)
          if (g.atLeast(s.$1)) s,
      ];
      final (_, text, kind) = g.one(pool);
      String name(String k) =>
          older ? sentenceKindNames[k]!.$2 : sentenceKindNames[k]!.$1;
      final kinds = {for (final s in pool) s.$3};
      final prompt = g.atLeast(Level.grade2)
          ? 'What kind of sentence is this?'
          : 'Is this sentence telling or asking?';
      return g.choice(
        prompt: prompt,
        visual: TextVisual(text),
        answer: name(kind),
        wrong: [for (final k in kinds) name(k)],
        speech: [prompt, text],
      );
    },
    // Capital letters.
    if (g.atMost(Level.grade4))
      () {
        final (_, sentence, word) = g.one(
          _near(g, capitalSentences, (s) => s.$1),
        );
        final lower = word.toLowerCase();
        final shown = sentence.replaceFirst(RegExp('\\b$word\\b'), lower);
        final words = sentence.replaceAll(RegExp(r'[^A-Za-z ]'), '').split(' ');
        final others = [
          for (final w in words.skip(1))
            if (w.length >= 3 && w != word) w.toLowerCase(),
        ];
        return g.choice(
          prompt: 'Which word needs a capital letter?',
          visual: TextVisual(shown),
          answer: lower,
          wrong: others,
          count: 3,
        );
      },
    // Word order.
    () {
      final (_, correct, wrong) = g.one(_near(g, orderSentences, (s) => s.$1));
      final end = correct[correct.length - 1];
      final tiles = correct.substring(0, correct.length - 1).split(' ')
        ..shuffle(g.r);
      return g.choice(
        prompt: 'Put the words in order!',
        visual: TextVisual('${tiles.join('  •  ')}  $end', emoji: '🧱'),
        answer: correct,
        wrong: wrong,
      );
    },
    // Contractions.
    () {
      final (_, words, short, wrong) = g.one(
        _near(g, contractions, (s) => s.$1),
      );
      return g.choice(
        prompt: 'Squeeze the words together! Which is right?',
        visual: TextVisual('$words → ?', emoji: '🤏'),
        answer: short,
        wrong: wrong,
        speech: ['Which is the right way to write $words as one short word?'],
      );
    },
    // Past tense.
    () {
      final (_, text, verb, past, wrong) = g.one(
        _near(g, pastTense, (s) => s.$1),
      );
      return g.choice(
        prompt: 'It already happened! Which word fits?',
        visual: TextVisual('$text\n($verb)', emoji: '⏪'),
        answer: past,
        wrong: wrong,
        speech: [
          'It already happened! Which word fits?',
          text.replaceAll('___', 'blank'),
        ],
      );
    },
    // Agreement.
    () {
      final (_, text, answer, wrong) = g.one(_near(g, agreement, (s) => s.$1));
      return g.choice(
        prompt: 'Which verb fits the sentence?',
        visual: TextVisual(text),
        answer: answer,
        wrong: wrong,
        speech: [
          'Which verb fits the sentence?',
          text.replaceAll('___', 'blank'),
        ],
      );
    },
    // Joining words.
    if (g.atLeast(Level.grade2))
      () {
        final (_, text, answer, wrong) = g.one(
          _near(g, conjunctions, (s) => s.$1),
        );
        return g.choice(
          prompt: 'Pick the best joining word!',
          visual: TextVisual(text, emoji: '🔗'),
          answer: answer,
          wrong: wrong,
        );
      },
    // Run-on sentences.
    if (g.atLeast(Level.grade3))
      () {
        final (_, text, answer, wrong) = g.one(_near(g, runOns, (s) => s.$1));
        return g.choice(
          prompt: 'This is a run-on sentence. What is the best fix?',
          visual: TextVisual(text, emoji: '🏃'),
          answer: answer,
          wrong: wrong,
        );
      },
  ]);
}
