import 'dart:math';

import '../models/models.dart';
import 'gen.dart';

// Multi-format math worksheets: every worksheet rotates through several
// different kinds of question so it never feels repetitive.

const countables = [
  ('🍎', 'apples'),
  ('🐞', 'ladybugs'),
  ('⭐', 'stars'),
  ('🐟', 'fish'),
  ('🌸', 'flowers'),
  ('🚗', 'cars'),
  ('🎈', 'balloons'),
  ('🐥', 'chicks'),
  ('🍓', 'strawberries'),
  ('🦋', 'butterflies'),
  ('🍪', 'cookies'),
  ('⚽', 'balls'),
  ('🐢', 'turtles'),
  ('🍩', 'donuts'),
];

const names = [
  'Mia',
  'Leo',
  'Ava',
  'Noah',
  'Zara',
  'Omar',
  'Lily',
  'Kai',
  'Priya',
  'Ben',
  'Sofia',
  'Max',
];

String group(String emoji, int n) => List.filled(n, emoji).join();

/// [n] distinct numbers from [lo]..[hi] other than [except].
List<int> _others(Gen g, int lo, int hi, int except, int n) => g.pick([
  for (var k = lo; k <= hi; k++)
    if (k != except) k,
], n);

// ------------------------------------------------------------------ early

List<Question> counting(Gen g) {
  final top = g.byLevel({
    Level.age2: 3,
    Level.age3: 5,
    Level.preK: 10,
    Level.kindergarten: 15,
  });
  final options = g.byLevel({Level.age2: 2, Level.age3: 3, Level.preK: 4});
  return g.mix(g.count, [
    () {
      final (emoji, name) = g.one(countables);
      final n = g.between(1, top);
      return g.number(
        prompt: 'How many $name?',
        visual: CountVisual(emoji, n),
        answer: n,
        count: options,
        lowest: 1,
      );
    },
    () {
      final picks = g.pick(countables, 2);
      final n = g.between(1, min(top, 6));
      final other = g.between(1, g.atLeast(Level.preK) ? 5 : 2);
      final items = [
        ...List.filled(n, picks[0].$1),
        ...List.filled(other, picks[1].$1),
      ]..shuffle(g.r);
      return g.number(
        prompt: 'How many ${picks[0].$2} can you find?',
        visual: MixedVisual(items),
        answer: n,
        count: options,
        lowest: 1,
      );
    },
    () {
      final (emoji, _) = g.one(countables);
      final cap = min(top, 8);
      final n = g.between(1, cap);
      return g.choice(
        prompt: 'Which group has $n?',
        visual: TextVisual('$n'),
        answer: group(emoji, n),
        wrong: [
          for (final o in _others(g, 1, cap + 1, n, options - 1))
            group(emoji, o),
        ],
      );
    },
    if (g.atLeast(Level.preK))
      () {
        final (emoji, name) = g.one(countables);
        final n = g.between(1, top - 1);
        return g.number(
          prompt: 'One more comes along! How many $name now?',
          visual: CountVisual(emoji, n),
          answer: n + 1,
          count: options,
          lowest: 1,
        );
      },
  ]);
}

const _heavyLight = [
  ('🐘', '🐭'),
  ('🚚', '🚲'),
  ('🍉', '🍒'),
  ('🐋', '🐟'),
  ('🏠', '🎈'),
  ('🦏', '🐤'),
];
const _tallShort = [
  ('🦒', '🐶'),
  ('🌳', '🌷'),
  ('🏢', '🏠'),
  ('🦕', '🐈'),
  ('🗼', '⛺'),
];

List<Question> sizes(Gen g) => g.mix(g.count, [
  () {
    const things = ['🐘', '🍎', '🐶', '🚗', '🌳', '🎈', '🐟', '🏠', '🦒', '⭐'];
    final emoji = g.one(things);
    final three = g.atLeast(Level.age3);
    final scales = three ? [1.0, .72, .45] : [1.0, .5];
    final big = g.chance(.5);
    final order = List.generate(scales.length, (i) => i)..shuffle(g.r);
    final target = big ? 0 : scales.length - 1;
    return ChoiceQuestion(
      prompt: three
          ? (big ? 'Tap the biggest one!' : 'Tap the smallest one!')
          : 'Tap the ${big ? 'big' : 'small'} one!',
      visual: EmojiVisual(big ? '🐘' : '🐭', big ? 'BIG' : 'SMALL'),
      choices: [for (final i in order) Choice.label(emoji, scale: scales[i])],
      answer: order.indexOf(target),
    );
  },
  () {
    final (heavy, light) = g.one(_heavyLight);
    final askHeavy = g.chance(.6);
    return g.choice(
      prompt: askHeavy ? 'Which one is heavier?' : 'Which one is lighter?',
      visual: const EmojiVisual('⚖️'),
      answer: askHeavy ? heavy : light,
      wrong: [askHeavy ? light : heavy],
    );
  },
  () {
    final (tall, short) = g.one(_tallShort);
    final askTall = g.chance(.6);
    return g.choice(
      prompt: askTall ? 'Which one is taller?' : 'Which one is shorter?',
      visual: const EmojiVisual('📏'),
      answer: askTall ? tall : short,
      wrong: [askTall ? short : tall],
    );
  },
]);

List<Question> moreLess(Gen g) {
  final top = g.byLevel({Level.age3: 5, Level.preK: 8, Level.kindergarten: 10});
  final groups = g.atLeast(Level.kindergarten) ? 3 : 2;
  Question groupsQ(bool fewer) {
    final (emoji, name) = g.one(countables);
    final counts = g.pick(List.generate(top, (i) => i + 1), groups);
    if (g.atMost(Level.age3) && (counts[0] - counts[1]).abs() < 2)
      counts[1] = counts[0] > 2 ? 1 : counts[0] + 2;
    final target = fewer ? counts.reduce(min) : counts.reduce(max);
    return ChoiceQuestion(
      prompt: fewer ? 'Which has fewer $name?' : 'Which has more $name?',
      visual: const EmojiVisual('⚖️'),
      choices: [for (final c in counts) Choice.label(group(emoji, c))],
      answer: counts.indexOf(target),
    );
  }

  return g.mix(g.count, [
    () => groupsQ(false),
    if (g.atLeast(Level.preK)) () => groupsQ(true),
    () {
      final nums = g.pick(List.generate(top, (i) => i + 1), 2);
      final smaller = g.atLeast(Level.preK) && g.chance(.4);
      final ans = smaller ? nums.reduce(min) : nums.reduce(max);
      return g.choice(
        prompt: smaller
            ? 'Which number is smaller?'
            : 'Which number is bigger?',
        visual: const EmojiVisual('🐊'),
        answer: '$ans',
        wrong: nums.map((e) => '$e'),
      );
    },
    () {
      final (emoji, _) = g.one(countables);
      final n = g.between(1, min(top, 6));
      return g.choice(
        prompt: 'Which group has the same number?',
        visual: CountVisual(emoji, n),
        answer: group('🔵', n),
        wrong: [
          for (final o in _others(g, 1, min(top, 6) + 1, n, 2)) group('🔵', o),
        ],
      );
    },
  ]);
}

List<Question> numberFind(Gen g) {
  final top = g.byLevel({
    Level.age3: 5,
    Level.preK: 10,
    Level.kindergarten: 20,
  });
  final options = g.atLeast(Level.preK) ? 4 : 3;
  return g.mix(g.count, [
    () {
      final n = g.between(1, top);
      final wrong = {for (final o in _others(g, 1, top, n, 3)) '$o'};
      if (n > 12 && n < 20) wrong.add('${n % 10}1'); // 13 vs 31
      return g.choice(
        prompt: 'Find the number $n!',
        visual: const ListenVisual(),
        answer: '$n',
        wrong: wrong,
        count: options,
      );
    },
    () {
      final n = g.between(1, min(top, 10));
      return g.number(
        prompt: 'Count the dots!',
        visual: CountVisual('🔴', n),
        answer: n,
        count: options,
        lowest: 1,
      );
    },
    () {
      final start = g.between(1, top - 3);
      return g.number(
        prompt: 'What number comes next?',
        visual: PatternVisual(['$start', '${start + 1}', '${start + 2}', '?']),
        answer: start + 3,
        count: 3,
        lowest: 1,
      );
    },
    () {
      final (emoji, _) = g.one(countables);
      final n = g.between(1, min(top, 6));
      return g.choice(
        prompt: 'Tap the group with this many!',
        visual: TextVisual('$n'),
        answer: group(emoji, n),
        wrong: [for (final o in _others(g, 1, 7, n, 2)) group(emoji, o)],
      );
    },
  ]);
}

// ---------------------------------------------------------- add & subtract

(int, int) _addPair(Gen g) {
  final a = switch (g.level) {
    Level.preK => g.between(1, 4),
    Level.kindergarten => g.between(1, 7),
    Level.grade1 => g.between(2, 12),
    Level.grade2 => g.between(12, 68),
    _ => g.between(120, 699),
  };
  final b = switch (g.level) {
    Level.preK => g.between(1, 5 - a),
    Level.kindergarten => g.between(1, 10 - a),
    Level.grade1 => g.between(1, 20 - a),
    Level.grade2 => g.between(11, 99 - a),
    _ => g.between(105, 999 - a),
  };
  return (a, b);
}

List<Question> addition(Gen g) {
  final young = g.atMost(Level.kindergarten);
  final options = g.atMost(Level.preK) ? 3 : 4;
  return g.mix(g.count, [
    () {
      final (a, b) = _addPair(g);
      return g.number(
        prompt: young ? 'How many altogether?' : 'Add them up!',
        visual: EquationVisual(
          a,
          b,
          op: '+',
          emoji: a + b <= 10 ? g.one(countables).$1 : null,
        ),
        answer: a + b,
        count: options,
        lowest: 1,
      );
    },
    () {
      final (a, b) = _addPair(g);
      final (emoji, name) = g.one(countables);
      final who = g.one(names);
      final text = '$who has ${fmt(a)} $name. $who gets ${fmt(b)} more.';
      return g.number(
        prompt: 'How many $name in all?',
        visual: TextVisual(text, emoji: emoji),
        answer: a + b,
        count: options,
        lowest: 1,
        speech: ['$text How many $name in all?'],
      );
    },
    if (g.atLeast(Level.kindergarten))
      () {
        final (a, b) = _addPair(g);
        return g.number(
          prompt: 'What number is missing?',
          visual: TextVisual('${fmt(a)} + ? = ${fmt(a + b)}'),
          answer: b,
          lowest: 1,
        );
      },
    if (g.atLeast(Level.kindergarten))
      () {
        final (a, b) = _addPair(g);
        final wrong = <String>{};
        for (var i = 0; wrong.length < 3 && i < 50; i++) {
          final (x, y) = _addPair(g);
          if (x + y != a + b) wrong.add('${fmt(x)} + ${fmt(y)}');
        }
        return g.choice(
          prompt: 'Which one makes ${fmt(a + b)}?',
          visual: TextVisual('= ${fmt(a + b)}', emoji: '🎯'),
          answer: '${fmt(a)} + ${fmt(b)}',
          wrong: wrong,
        );
      },
    if (g.level == Level.preK)
      () {
        final n = g.between(1, 5);
        return g.number(
          prompt: 'What is one more than $n?',
          visual: CountVisual('🟢', n),
          answer: n + 1,
          count: 3,
          lowest: 1,
        );
      },
  ]);
}

(int, int) _subPair(Gen g) {
  final a = switch (g.level) {
    Level.preK => g.between(2, 5),
    Level.kindergarten => g.between(3, 10),
    Level.grade1 => g.between(6, 20),
    Level.grade2 => g.between(30, 99),
    _ => g.between(300, 999),
  };
  return (a, g.between(1, a - 1));
}

List<Question> subtraction(Gen g) => g.mix(g.count, [
  () {
    final (a, b) = _subPair(g);
    return g.number(
      prompt: a <= 10 ? 'How many are left?' : 'Subtract!',
      visual: EquationVisual(
        a,
        b,
        op: '−',
        emoji: a <= 10 ? g.one(countables).$1 : null,
      ),
      answer: a - b,
    );
  },
  () {
    final (a, b) = _subPair(g);
    final (emoji, name) = g.one(countables);
    final who = g.one(names);
    final action = g.one(['gives away', 'loses', 'eats', 'shares']);
    final text = '$who has ${fmt(a)} $name and $action ${fmt(b)}.';
    return g.number(
      prompt: 'How many $name are left?',
      visual: TextVisual(text, emoji: emoji),
      answer: a - b,
      speech: ['$text How many are left?'],
    );
  },
  if (g.atLeast(Level.kindergarten))
    () {
      final (a, b) = _subPair(g);
      return g.number(
        prompt: 'What number is missing?',
        visual: TextVisual('${fmt(a)} − ? = ${fmt(a - b)}'),
        answer: b,
        lowest: 1,
      );
    },
  if (g.atLeast(Level.grade1))
    () {
      final (a, b) = _subPair(g);
      final people = g.pick(names, 2);
      final (emoji, name) = g.one(countables);
      final text =
          '${people[0]} has ${fmt(a)} $name. ${people[1]} has ${fmt(b)} $name.';
      return g.number(
        prompt: 'How many more does ${people[0]} have?',
        visual: TextVisual(text, emoji: emoji),
        answer: a - b,
        speech: ['$text How many more does ${people[0]} have?'],
      );
    },
]);

// -------------------------------------------------------- number sense

List<Question> compareNumbers(Gen g) {
  final hi = g.byLevel({
    Level.grade1: 100,
    Level.grade2: 1000,
    Level.grade3: 10000,
    Level.grade4: 1000000,
  });
  final step = g.byLevel({
    Level.grade1: 10,
    Level.grade2: 100,
    Level.grade3: 1000,
    Level.grade4: 10000,
  });
  Question sign() {
    if (g.atLeast(Level.grade5) && g.chance(.6)) {
      final a = g.between(1, 99), b = g.between(1, 9);
      final sa = (a / 100).toString(), sb = (b / 10).toString();
      final ans = a / 100 > b / 10
          ? '>'
          : a / 100 < b / 10
          ? '<'
          : '=';
      return g.choice(
        prompt: 'Which sign goes in the circle?',
        visual: TextVisual('$sa   ◯   $sb'),
        answer: ans,
        wrong: const ['>', '<', '='],
        speech: ['Compare $sa and $sb. Which sign goes in the circle?'],
      );
    }
    final a = g.between(1, hi - 1);
    var b = g.chance(.12) ? a : g.between(1, hi - 1);
    if (a != b && a > 9 && g.chance(.35)) {
      final rev = int.parse(a.toString().split('').reversed.join());
      if (rev != a && rev < hi) b = rev;
    }
    final ans = a > b
        ? '>'
        : a < b
        ? '<'
        : '=';
    return g.choice(
      prompt: 'Which sign goes in the circle?',
      visual: TextVisual('${fmt(a)}   ◯   ${fmt(b)}'),
      answer: ans,
      wrong: const ['>', '<', '='],
      speech: [
        'Compare ${fmt(a)} and ${fmt(b)}. Which sign goes in the circle?',
      ],
    );
  }

  Question extreme(bool biggest) {
    // Four close-together numbers, so it takes real comparing.
    final spread = max(20, hi ~/ 20);
    final lo = g.between(1, hi - spread - 1);
    final list = g.pick([for (var x = lo; x < lo + spread; x++) x], 4);
    final ans = biggest ? list.reduce(max) : list.reduce(min);
    return g.choice(
      prompt: biggest
          ? 'Which number is the biggest?'
          : 'Which number is the smallest?',
      visual: EmojiVisual(biggest ? '🏔️' : '🐜'),
      answer: fmt(ans),
      wrong: list.map(fmt),
    );
  }

  return g.mix(g.count, [
    sign,
    () => extreme(true),
    () => extreme(false),
    () {
      final n = g.between(step, hi - step * 2);
      final more = g.chance(.6);
      return g.choice(
        prompt:
            'What is ${fmt(step)} ${more ? 'more' : 'less'} than ${fmt(n)}?',
        visual: TextVisual(
          '${fmt(n)} ${more ? '+' : '−'} ${fmt(step)}',
          emoji: more ? '⬆️' : '⬇️',
        ),
        answer: fmt(more ? n + step : n - step),
        wrong: {
          fmt(more ? n + 1 : n - 1),
          fmt(more ? n - step : n + step),
          fmt(more ? n + step * 10 : (n - step * 10).abs()),
        },
      );
    },
  ]);
}

List<Question> placeValue(Gen g) {
  const places = [
    'ones',
    'tens',
    'hundreds',
    'thousands',
    'ten thousands',
    'hundred thousands',
  ];
  final digits = g.byLevel({
    Level.grade1: 2,
    Level.grade2: 3,
    Level.grade3: 4,
    Level.grade4: 6,
  });
  int newNumber() =>
      g.between(pow(10, digits - 1).toInt(), pow(10, digits).toInt() - 1);
  int digitAt(int n, int pos) => (n ~/ pow(10, pos).toInt()) % 10;
  List<int> nonZero(int n) => [
    for (var p = 0; p < digits; p++)
      if (digitAt(n, p) != 0) p,
  ];

  return g.mix(g.count, [
    () {
      final n = newNumber(), pos = g.one(nonZero(n));
      return g.number(
        prompt: g.level == Level.grade1
            ? 'How many ${places[pos]} are in ${fmt(n)}?'
            : 'Which digit is in the ${places[pos]} place of ${fmt(n)}?',
        visual: TextVisual(fmt(n), emoji: '🧮'),
        answer: digitAt(n, pos),
        count: 3,
      );
    },
    () {
      final n = newNumber();
      final parts = [
        for (var p = digits - 1; p >= 0; p--)
          if (digitAt(n, p) != 0) '${digitAt(n, p)} ${places[p]}',
      ];
      return g.choice(
        prompt: 'What number is this?',
        visual: TextVisual(parts.join(', '), emoji: '🧱'),
        answer: fmt(n),
        wrong: {
          fmt(int.parse(n.toString().split('').reversed.join())),
          fmt(n + pow(10, g.r.nextInt(digits)).toInt()),
          fmt((n - pow(10, g.r.nextInt(digits)).toInt()).abs()),
        }..remove(fmt(n)),
        count: 4,
      );
    },
    () {
      final n = newNumber(), pos = g.one(nonZero(n));
      final d = digitAt(n, pos);
      final wrong = <String>{};
      for (var i = 0; wrong.length < 3 && i < 60; i++) {
        final x = newNumber();
        if (digitAt(x, pos) != d) wrong.add(fmt(x));
      }
      return g.choice(
        prompt: 'Which number has $d in the ${places[pos]} place?',
        visual: const EmojiVisual('🔎'),
        answer: fmt(n),
        wrong: wrong,
      );
    },
    if (g.atLeast(Level.grade2))
      () {
        final n = newNumber(), pos = g.one(nonZero(n));
        final d = digitAt(n, pos), value = d * pow(10, pos).toInt();
        return g.choice(
          prompt: 'What is the value of the $d in ${fmt(n)}?',
          visual: TextVisual(fmt(n), emoji: '🧮'),
          answer: fmt(value),
          wrong: {
            for (var p = 0; p < digits; p++)
              if (p != pos) fmt(d * pow(10, p).toInt()),
            '$d',
          }..remove(fmt(value)),
          count: 4,
        );
      },
  ]);
}

// ------------------------------------------------------------ time & money

String clock(int h, int m) => '$h:${m.toString().padLeft(2, '0')}';

(int, int) _addMinutes(int h, int m, int delta) {
  final total = ((h % 12) * 60 + m + delta) % 720;
  final t = total < 0 ? total + 720 : total;
  final hour = t ~/ 60;
  return (hour == 0 ? 12 : hour, t % 60);
}

List<Question> time(Gen g) {
  (int, int) randomTime() => (
    g.between(1, 12),
    switch (g.level) {
      Level.grade1 => g.one([0, 30]),
      Level.grade2 => g.between(0, 11) * 5,
      _ => g.between(0, 59),
    },
  );
  Set<String> near(int h, int m) {
    final (h1, m1) = _addMinutes(h, m, 60);
    final (h2, m2) = _addMinutes(h, m, -60);
    final (h3, m3) = _addMinutes(h, m, 30);
    return {
      clock(h1, m1),
      clock(h2, m2),
      clock(h3, m3),
      clock(h, (m + 15) % 60),
    };
  }

  return g.mix(g.count, [
    () {
      final (h, m) = randomTime();
      return g.choice(
        prompt: 'What time is it?',
        visual: ClockVisual(h, m),
        answer: clock(h, m),
        wrong: near(h, m)..remove(clock(h, m)),
        count: 4,
      );
    },
    () {
      final (h, m) = randomTime();
      final (h2, m2) = _addMinutes(h, m, 60);
      return g.choice(
        prompt: 'What time will it be in 1 hour?',
        visual: ClockVisual(h, m),
        answer: clock(h2, m2),
        wrong: {clock(h, m), ...near(h2, m2)}..remove(clock(h2, m2)),
        count: 4,
      );
    },
    if (g.atLeast(Level.grade2))
      () {
        final (h, m) = randomTime();
        final (h2, m2) = _addMinutes(h, m, -30);
        return g.choice(
          prompt: 'What time was it 30 minutes ago?',
          visual: ClockVisual(h, m),
          answer: clock(h2, m2),
          wrong: {clock(h, m), ...near(h2, m2)}..remove(clock(h2, m2)),
          count: 4,
        );
      },
    () {
      final facts = [
        ('How many minutes are in an hour?', 60),
        ('How many minutes are in half an hour?', 30),
        if (g.atLeast(Level.grade2))
          ('How many minutes are in a quarter of an hour?', 15),
        ('How many hours are in a day?', 24),
        if (g.atLeast(Level.grade2)) ('How many seconds are in a minute?', 60),
        ('How many days are in a week?', 7),
      ];
      final (q, a) = g.one(facts);
      return g.choice(
        prompt: q,
        visual: const EmojiVisual('⏳'),
        answer: '$a',
        wrong: const ['7', '12', '15', '24', '30', '60', '100'],
      );
    },
    if (g.atLeast(Level.grade3))
      () {
        final (h, m) = randomTime();
        final d = g.one([15, 25, 40, 45, 50, 75, 90]);
        final (h2, m2) = _addMinutes(h, m, d);
        final text = 'A game starts at ${clock(h, m)} and lasts $d minutes.';
        return g.choice(
          prompt: 'What time does it end?',
          visual: TextVisual(text, emoji: '⚽'),
          answer: clock(h2, m2),
          wrong: near(h2, m2)..remove(clock(h2, m2)),
          count: 4,
          speech: ['$text What time does it end?'],
        );
      },
  ]);
}

List<Question> money(Gen g) {
  final coinTypes = g.atLeast(Level.grade2) ? [25, 10, 5, 1] : [10, 5, 1];
  const coinNames = {1: 'penny', 5: 'nickel', 10: 'dime', 25: 'quarter'};
  final maxCoins = g.byLevel({
    Level.grade1: 5,
    Level.grade2: 6,
    Level.grade3: 8,
  });
  String cents(int v) => v >= 100 ? '\$${(v / 100).toStringAsFixed(2)}' : '$v¢';
  return g.mix(g.count, [
    () {
      final coins = [
        for (var i = 0; i < g.between(2, maxCoins); i++) g.one(coinTypes),
      ]..sort((a, b) => b - a);
      return g.number(
        prompt: 'How much money is this?',
        visual: CoinsVisual(coins),
        answer: coins.reduce((a, b) => a + b),
        format: (v) => '$v¢',
        lowest: 1,
      );
    },
    () {
      final v = g.one(coinTypes);
      return g.choice(
        prompt: 'Which coin is worth $v¢?',
        visual: CoinsVisual([v]),
        answer: coinNames[v]!,
        wrong: coinTypes.map((c) => coinNames[c]!),
      );
    },
    () {
      final unit = g.one(g.atLeast(Level.grade2) ? [5, 10, 25] : [5, 10]);
      final n = g.between(2, unit == 25 ? 4 : 9);
      return g.number(
        prompt: 'How many ${coinNames[unit]}s make ${cents(unit * n)}?',
        visual: CoinsVisual([unit]),
        answer: n,
        lowest: 1,
      );
    },
    if (g.atLeast(Level.grade2))
      () {
        final paid = g.atLeast(Level.grade3) ? 100 : 50;
        final cost = g.between(5, paid - 5);
        return g.number(
          prompt:
              'A toy costs $cost¢. You pay ${cents(paid)}. How much change?',
          visual: TextVisual('${cents(paid)} − $cost¢', emoji: '🧸'),
          answer: paid - cost,
          format: (v) => '$v¢',
          lowest: 1,
        );
      },
    if (g.atLeast(Level.grade2))
      () {
        final a = g.one(coinTypes),
            b = g.one(coinTypes.where((c) => c != a).toList());
        final na = g.between(1, 4), nb = g.between(1, 4);
        if (a * na == b * nb)
          return g.choice(
            prompt: 'Which is more money?',
            visual: const EmojiVisual('💰'),
            answer: '${na + 1} ${coinNames[a]}s',
            wrong: ['$nb ${coinNames[b]}s'],
          );
        final la = '$na ${coinNames[a]}${na > 1 ? 's' : ''}',
            lb = '$nb ${coinNames[b]}${nb > 1 ? 's' : ''}';
        return g.choice(
          prompt: 'Which is more money?',
          visual: const EmojiVisual('💰'),
          answer: a * na > b * nb ? la : lb,
          wrong: [la, lb],
        );
      },
  ]);
}

// ------------------------------------------------------- multiply & divide

(int, int) _mulPair(Gen g) => switch (g.level) {
  Level.grade2 => (g.between(2, 5), g.one([2, 5, 10])),
  Level.grade3 => (g.between(2, 10), g.between(2, 10)),
  Level.grade4 => (g.between(12, 99), g.between(2, 9)),
  _ => (g.between(11, 40), g.between(11, 30)),
};

/// A worked example first ("Let's learn!"), then practice.
List<Question> multiplication(Gen g) => [
  _mulExample(g),
  ..._multiplicationPractice(g),
];

/// How to multiply, one step up each grade: equal groups (Grade 2), skip
/// counting (Grade 3), splitting into tens and ones (Grade 4), splitting a
/// two-digit number (Grade 5).
ExampleQuestion _mulExample(Gen g) {
  final (emoji, name) = g.one(countables);
  switch (g.level) {
    case Level.grade2:
      final rows = g.between(2, 4), each = g.between(2, 5);
      return ExampleQuestion(
        title: '$rows × $each means $rows groups of $each',
        visual: ArrayVisual(emoji, rows, each),
        steps: [
          'There are $rows rows, with $each $name in each row.',
          'Add the rows: ${List.filled(rows, '$each').join(' + ')} = ${rows * each}.',
          'So $rows × $each = ${rows * each}.',
        ],
      );
    case Level.grade3:
      final rows = g.between(3, 5), each = g.between(4, 8);
      final counts = [for (var i = 1; i <= rows; i++) '${each * i}'];
      return ExampleQuestion(
        title: 'Multiply by skip counting',
        visual: ArrayVisual(emoji, rows, each),
        steps: [
          '$rows × $each means $rows groups of $each.',
          'Skip count by $each, $rows times: ${counts.join(', ')}.',
          'So $rows × $each = ${rows * each}.',
        ],
      );
    case Level.grade4:
      final tens = g.between(1, 4) * 10, ones = g.between(2, 9);
      final b = g.between(3, 9), a = tens + ones;
      return ExampleQuestion(
        title: 'Split it into tens and ones',
        visual: TextVisual('$a × $b = ?'),
        steps: [
          'Split $a into $tens + $ones.',
          '$tens × $b = ${tens * b}',
          '$ones × $b = ${ones * b}',
          'Add them: ${tens * b} + ${ones * b} = ${fmt(a * b)}. So $a × $b = ${fmt(a * b)}.',
        ],
      );
    default:
      final a = g.between(12, 39), extra = g.between(2, 9), b = 10 + extra;
      return ExampleQuestion(
        title: 'Split the second number',
        visual: TextVisual('$a × $b = ?'),
        steps: [
          'Split $b into 10 + $extra.',
          '$a × 10 = ${a * 10}',
          '$a × $extra = ${a * extra}',
          'Add them: ${a * 10} + ${a * extra} = ${fmt(a * b)}. So $a × $b = ${fmt(a * b)}.',
        ],
      );
  }
}

List<Question> _multiplicationPractice(Gen g) => g.mix(g.count, [
  () {
    final (a, b) = _mulPair(g);
    return g.number(
      prompt: 'Multiply!',
      visual: EquationVisual(a, b, op: '×'),
      answer: a * b,
    );
  },
  if (g.atMost(Level.grade3))
    () {
      final rows = g.between(2, 5), cols = g.between(2, 5);
      return g.number(
        prompt: '$rows rows of $cols. How many in all?',
        visual: ArrayVisual(g.one(countables).$1, rows, cols),
        answer: rows * cols,
      );
    },
  if (g.atMost(Level.grade3))
    () {
      final times = g.between(2, 5), n = g.between(2, 9);
      final sum = List.filled(times, '$n').join(' + ');
      return g.choice(
        prompt: 'Which is the same as $sum?',
        visual: TextVisual(sum),
        answer: '$times × $n',
        wrong: {
          '$n × $n',
          '$times + $n',
          '${times + 1} × $n',
          '$times × ${n + 1}',
        }..remove('$times × $n'),
        count: 4,
      );
    },
  () {
    final (a, b) = _mulPair(g);
    final (emoji, name) = g.one(countables);
    final box = g.one(['bags', 'boxes', 'baskets', 'plates']);
    final text = 'There are $a $box with $b $name in each.';
    return g.number(
      prompt: 'How many $name altogether?',
      visual: TextVisual(text, emoji: emoji),
      answer: a * b,
      speech: ['$text How many altogether?'],
    );
  },
  if (g.atLeast(Level.grade3))
    () {
      final (a, b) = _mulPair(g);
      return g.number(
        prompt: 'What number is missing?',
        visual: TextVisual('$a × ? = ${fmt(a * b)}'),
        answer: b,
        lowest: 1,
      );
    },
  if (g.atLeast(Level.grade4))
    () {
      final a = g.between(3, 99), k = g.one([10, 100, 1000]);
      return g.choice(
        prompt: 'Multiply by ${fmt(k)}.',
        visual: TextVisual('$a × ${fmt(k)} = ?'),
        answer: fmt(a * k),
        wrong: {fmt(a * k ~/ 10), fmt(a * k * 10), fmt(a + k)}
          ..remove(fmt(a * k)),
      );
    },
]);

(int, int) _divPair(Gen g) => switch (g.level) {
  Level.grade3 => (g.between(2, 10), g.between(2, 10)),
  Level.grade4 => (g.between(2, 9), g.between(10, 99)),
  _ => (g.between(11, 25), g.between(10, 60)),
};

/// A worked example first ("Let's learn!"), then practice.
List<Question> division(Gen g) => [_divExample(g), ..._divisionPractice(g)];

/// How to divide: sharing into equal groups (Grade 3), splitting into
/// easy parts (Grades 4–5).
ExampleQuestion _divExample(Gen g) {
  final (emoji, name) = g.one(countables);
  if (g.level == Level.grade3) {
    final d = g.between(2, 4), q = g.between(2, 5), n = d * q;
    return ExampleQuestion(
      title: '$n ÷ $d means share $n into $d equal groups',
      visual: ArrayVisual(emoji, d, q),
      steps: [
        'Share $n $name into $d rows, one at a time.',
        'Each row ends up with $q.',
        'Check: $d × $q = $n. So $n ÷ $d = $q.',
      ],
    );
  }
  final grade4 = g.level == Level.grade4;
  final d = grade4 ? g.between(2, 9) : g.between(11, 19);
  final big = grade4 ? g.between(1, 4) * 10 : 10;
  final small = g.between(2, 9);
  final q = big + small, n = d * q;
  return ExampleQuestion(
    title: 'Split it into easy parts',
    visual: TextVisual('${fmt(n)} ÷ $d = ?'),
    steps: [
      'Split ${fmt(n)} into ${fmt(d * big)} + ${d * small}.',
      '${fmt(d * big)} ÷ $d = $big',
      '${d * small} ÷ $d = $small',
      'Add them: $big + $small = $q. So ${fmt(n)} ÷ $d = $q.',
    ],
  );
}

List<Question> _divisionPractice(Gen g) => g.mix(g.count, [
  () {
    final (d, q) = _divPair(g);
    return g.number(
      prompt: 'Divide!',
      visual: EquationVisual(d * q, d, op: '÷'),
      answer: q,
      lowest: 1,
    );
  },
  () {
    final (d, q) = _divPair(g);
    final (emoji, name) = g.one(countables);
    final text = '${fmt(d * q)} $name are shared equally between $d friends.';
    return g.number(
      prompt: 'How many does each friend get?',
      visual: TextVisual(text, emoji: emoji),
      answer: q,
      lowest: 1,
      speech: ['$text How many does each friend get?'],
    );
  },
  () {
    final (d, q) = _divPair(g);
    return g.number(
      prompt: 'What number is missing?',
      visual: TextVisual('? ÷ $d = $q'),
      answer: d * q,
      lowest: 1,
    );
  },
  if (g.level == Level.grade3)
    () {
      final (d, q) = _divPair(g);
      return g.choice(
        prompt: 'Which fact helps you solve ${d * q} ÷ $d?',
        visual: TextVisual('${d * q} ÷ $d'),
        answer: '$d × $q = ${d * q}',
        wrong: {
          '$d + $q = ${d + q}',
          '$d × ${q + 1} = ${d * (q + 1)}',
          '${d * q} − $d = ${d * q - d}',
        },
      );
    },
  if (g.atLeast(Level.grade4))
    () {
      final (d, q) = _divPair(g);
      final extra = g.between(1, d - 1);
      final text = '${fmt(d * q + extra)} eggs are packed into boxes of $d.';
      return g.number(
        prompt: 'How many boxes can be filled completely?',
        visual: TextVisual(text, emoji: '🥚'),
        answer: q,
        lowest: 1,
        speech: ['$text How many boxes can be filled completely?'],
      );
    },
]);

// --------------------------------------------------------------- fractions

List<Question> fractions(Gen g) {
  Question shaded() {
    final parts = g.byLevel({
      Level.grade1: g.between(2, 4),
      Level.grade2: g.between(2, 6),
      Level.grade3: g.between(2, 8),
      Level.grade4: g.between(3, 10),
    });
    final shadedParts = g.level == Level.grade1 ? 1 : g.between(1, parts - 1);
    return g.choice(
      prompt: 'What fraction is shaded?',
      visual: FractionVisual(parts, shadedParts, bar: g.chance(.4)),
      answer: '$shadedParts/$parts',
      wrong: {
        '${parts - shadedParts}/$parts',
        '$shadedParts/${parts + 1}',
        '$parts/$shadedParts',
        '1/$parts',
        '$shadedParts/${max(2, parts - 1)}',
      }..remove('$shadedParts/$parts'),
      count: g.level == Level.grade1 ? 3 : 4,
    );
  }

  Question equalParts() {
    final parts = g.between(2, 6);
    return g.number(
      prompt: 'How many equal parts?',
      visual: FractionVisual(parts, 0, bar: g.chance(.5)),
      answer: parts,
      count: 3,
      lowest: 1,
    );
  }

  Question partOf() {
    final (name, d) = g.byLevel({
      Level.grade1: g.one([('half', 2)]),
      Level.grade2: g.one([('half', 2), ('a quarter', 4)]),
      Level.grade3: g.one([('a third', 3), ('a quarter', 4), ('a fifth', 5)]),
    });
    final whole = d * g.between(2, g.level == Level.grade1 ? 6 : 10);
    return g.number(
      prompt: 'What is $name of $whole?',
      visual: TextVisual('$name of $whole', emoji: '🍪'),
      answer: whole ~/ d,
      lowest: 1,
    );
  }

  Question unitCompare() {
    final ds = g.pick([2, 3, 4, 6, 8, 10], 2);
    final bigger = ds.reduce(min);
    return g.choice(
      prompt: 'Same pizza. Which piece is bigger?',
      visual: TextVisual('1/${ds[0]}   or   1/${ds[1]}', emoji: '🍕'),
      answer: '1/$bigger',
      wrong: ['1/${ds.reduce(max)}'],
    );
  }

  Question sameCompare() {
    final d = g.one([4, 5, 6, 8, 10, 12]);
    final picks = g.pick(List.generate(d - 1, (i) => i + 1), 2);
    return g.choice(
      prompt: 'Which fraction is bigger?',
      visual: TextVisual('${picks[0]}/$d   or   ${picks[1]}/$d'),
      answer: '${picks.reduce(max)}/$d',
      wrong: ['${picks.reduce(min)}/$d'],
    );
  }

  Question equal() {
    final d = g.between(2, 6), n = g.between(1, d - 1), k = g.between(2, 4);
    return g.choice(
      prompt: 'Which fraction is equal to $n/$d?',
      visual: FractionVisual(d, n),
      answer: '${n * k}/${d * k}',
      wrong: {
        '${n + k}/${d + k}',
        '${n * k}/$d',
        '$n/${d * k}',
        '${n + 1}/${d * k}',
      },
      count: 4,
    );
  }

  Question addSame() {
    final d = g.one([3, 4, 5, 6, 8, 10]);
    final a = g.between(1, d - 2), b = g.between(1, d - 1 - a);
    return g.choice(
      prompt: 'Add the fractions!',
      visual: TextVisual('$a/$d + $b/$d = ?'),
      answer: '${a + b}/$d',
      wrong: {
        '${a + b}/${d * 2}',
        '${a * b}/$d',
        '${a + b + 1}/$d',
        '${(a - b).abs() + 1}/$d',
      }..remove('${a + b}/$d'),
      count: 4,
    );
  }

  Question unlike() {
    final (d1, d2) = g.one([
      (2, 4),
      (2, 3),
      (3, 6),
      (4, 8),
      (2, 8),
      (3, 4),
      (2, 6),
    ]);
    final n1 = g.between(1, d1 - 1), n2 = g.between(1, d2 - 1);
    final num = n1 * d2 + n2 * d1, den = d1 * d2;
    return g.choice(
      prompt: 'Add the fractions!',
      visual: TextVisual('$n1/$d1 + $n2/$d2 = ?'),
      answer: fraction(num, den),
      wrong: {
        '${n1 + n2}/${d1 + d2}',
        fraction(num + 1, den),
        fraction(n1 + n2, max(d1, d2)),
        fraction(num, den * 2),
      }..remove(fraction(num, den)),
      count: 4,
    );
  }

  Question ofWhole() {
    final d = g.one([2, 3, 4, 5, 10]),
        n = g.between(1, d - 1),
        whole = d * g.between(2, 12);
    return g.number(
      prompt: 'What is $n/$d of $whole?',
      visual: TextVisual('$n/$d of $whole = ?', emoji: '🍪'),
      answer: whole ~/ d * n,
      lowest: 1,
    );
  }

  final formats = switch (g.level) {
    Level.grade1 => [shaded, equalParts, partOf],
    Level.grade2 => [shaded, partOf, unitCompare, equalParts],
    Level.grade3 => [shaded, unitCompare, sameCompare, partOf],
    Level.grade4 => [equal, addSame, sameCompare, shaded, ofWhole],
    _ => [unlike, addSame, ofWhole, equal],
  };
  return g.mix(g.count, formats);
}

// ---------------------------------------------------------- word problems

List<Question> wordProblems(Gen g) {
  const things = [
    ('🍎', 'apples'),
    ('🖍️', 'crayons'),
    ('🍪', 'cookies'),
    ('⚽', 'balls'),
    ('📚', 'books'),
    ('🌟', 'stickers'),
    ('🐟', 'fish'),
    ('🎈', 'balloons'),
    ('🐚', 'shells'),
    ('🥕', 'carrots'),
  ];
  Question story(String text, String question, int answer, String emoji) =>
      g.number(
        prompt: question,
        visual: TextVisual(text, emoji: emoji),
        answer: answer,
        speech: ['$text $question'],
      );

  final ppl = g.pick(names, 2);
  final a = ppl[0], b = ppl[1];

  final formats = <Question Function()>[
    switch (g.level) {
      Level.grade1 => () {
        final (e, t) = g.one(things);
        final x = g.between(3, 12), y = g.between(2, 8);
        return story(
          '$a has $x $t. $b gives $a $y more.',
          'How many $t does $a have now?',
          x + y,
          e,
        );
      },
      Level.grade2 => () {
        final (e, t) = g.one(things);
        final x = g.between(15, 60), y = g.between(12, 39);
        return story(
          'A class collected $x $t on Monday and $y on Tuesday.',
          'How many $t in all?',
          x + y,
          e,
        );
      },
      Level.grade3 => () {
        final (e, t) = g.one(things);
        final x = g.between(3, 9), y = g.between(3, 9);
        return story(
          'There are $x bags with $y $t in each bag.',
          'How many $t are there?',
          x * y,
          e,
        );
      },
      Level.grade4 => () {
        final (e, t) = g.one(things);
        final packs = g.between(3, 9),
            each = g.between(6, 15),
            away = g.between(5, packs * each - 5);
        return story(
          '$a buys $packs packs of $t with $each in each pack, then gives away $away.',
          'How many $t are left?',
          packs * each - away,
          e,
        );
      },
      _ => () {
        final price = g.between(3, 15),
            qty = g.between(4, 12),
            paid = (price * qty ~/ 10 + 1) * 10 + 10;
        return story(
          '$a buys $qty notebooks at \$$price each and pays with \$$paid.',
          'How much change, in dollars?',
          paid - price * qty,
          '📓',
        );
      },
    },
    switch (g.level) {
      Level.grade1 => () {
        final (e, t) = g.one(things);
        final x = g.between(8, 20), y = g.between(2, x - 2);
        return story(
          '$a had $x $t and gave $y to $b.',
          'How many $t are left?',
          x - y,
          e,
        );
      },
      Level.grade2 => () {
        final (e, t) = g.one(things);
        final x = g.between(40, 99), y = g.between(11, x - 10);
        return story(
          'There were $x $t in a box. $a took out $y.',
          'How many are still in the box?',
          x - y,
          e,
        );
      },
      Level.grade3 => () {
        final (e, t) = g.one(things);
        final x = g.between(2, 9), y = g.between(3, 9);
        return story(
          '$a shares ${x * y} $t equally among $x friends.',
          'How many does each friend get?',
          y,
          e,
        );
      },
      Level.grade4 => () {
        final l = g.between(5, 20), w = g.between(3, 12);
        return story(
          'A garden is $l meters long and $w meters wide.',
          'What is its area in square meters?',
          l * w,
          '🌻',
        );
      },
      _ => () {
        final d = g.one([2, 4, 5, 10]),
            n = g.between(1, d - 1),
            total = d * g.between(3, 9);
        return story(
          'There are $total students. $n/$d of them walk to school.',
          'How many students walk?',
          total ~/ d * n,
          '🚶',
        );
      },
    },
    switch (g.level) {
      Level.grade1 => () {
        final (e, t) = g.one(things);
        final x = g.between(8, 18), y = g.between(2, x - 2);
        return story(
          '$a has $x $t. $b has $y $t.',
          'How many more does $a have?',
          x - y,
          e,
        );
      },
      Level.grade2 => () {
        final (e, t) = g.one(things);
        final x = g.between(20, 50),
            y = g.between(10, 30),
            z = g.between(5, 15);
        return story(
          '$a had $x $t, found $y more, then lost $z.',
          'How many $t does $a have now?',
          x + y - z,
          e,
        );
      },
      Level.grade3 => () {
        final (e, t) = g.one(things);
        final x = g.between(3, 9), k = g.between(2, 5);
        return story(
          '$a has $x $t. $b has $k times as many.',
          'How many $t does $b have?',
          x * k,
          e,
        );
      },
      Level.grade4 => () {
        final per = g.between(4, 9),
            total = per * g.between(8, 20) + g.between(1, per - 1);
        return story(
          '$total children go on a trip. Each van holds $per children.',
          'How many vans are needed?',
          (total / per).ceil(),
          '🚐',
        );
      },
      _ => () {
        final l = g.between(2, 8), w = g.between(2, 6), h = g.between(2, 5);
        return story(
          'A box is $l cm long, $w cm wide and $h cm tall.',
          'What is its volume in cubic cm?',
          l * w * h,
          '📦',
        );
      },
    },
  ];
  return g.mix(g.count, formats);
}

// --------------------------------------------------- area & rounding extras

List<Question> area(Gen g) => g.mix(g.count, [
  () {
    final grid = g.level == Level.grade3;
    final w = grid ? g.between(2, 7) : g.between(3, 15),
        h = grid ? g.between(2, 5) : g.between(2, 12);
    return g.number(
      prompt: 'What is the area${grid ? ' in squares' : ' in square cm'}?',
      visual: RectVisual(w, h, grid: grid),
      answer: w * h,
      lowest: 1,
    );
  },
  () {
    final grid = g.level == Level.grade3;
    final w = grid ? g.between(2, 7) : g.between(3, 15),
        h = grid ? g.between(2, 5) : g.between(2, 12);
    return g.number(
      prompt: 'What is the perimeter${grid ? ' (count the edges)' : ' in cm'}?',
      visual: RectVisual(w, h, grid: grid),
      answer: 2 * (w + h),
      lowest: 1,
    );
  },
  () {
    final s = g.between(2, 12);
    final perimeter = g.chance(.5);
    return g.number(
      prompt:
          'A square has sides of $s cm. What is its ${perimeter ? 'perimeter in cm' : 'area in square cm'}?',
      visual: const EmojiVisual('🟦'),
      answer: perimeter ? 4 * s : s * s,
      lowest: 1,
    );
  },
  if (g.atLeast(Level.grade4))
    () {
      final w = g.between(3, 9), area = w * g.between(3, 9);
      return g.number(
        prompt:
            'A rectangle has an area of $area square cm and a width of $w cm. How long is it?',
        visual: const EmojiVisual('📐'),
        answer: area ~/ w,
        lowest: 1,
      );
    },
  if (g.atLeast(Level.grade5))
    () {
      final l = g.between(2, 8), w = g.between(2, 6), h = g.between(2, 5);
      return g.number(
        prompt:
            'A box is $l cubes long, $w cubes wide and $h cubes tall. What is its volume in cubes?',
        visual: TextVisual('$l × $w × $h', emoji: '📦'),
        answer: l * w * h,
      );
    },
]);

List<Question> rounding(Gen g) {
  (int, int) pick() => g.level == Level.grade3
      ? g.chance(.6)
            ? (g.between(11, 999), 10)
            : (g.between(101, 999), 100)
      : g.one([
          (g.between(1001, 9999), 10),
          (g.between(1001, 9999), 100),
          (g.between(1001, 99999), 1000),
        ]);
  int roundTo(int n, int to) => (n + to ~/ 2) ~/ to * to;
  const word = {10: 'ten', 100: 'hundred', 1000: 'thousand'};
  return g.mix(g.count, [
    () {
      final (n, to) = pick();
      final ans = roundTo(n, to);
      final other = ans == n ~/ to * to ? ans + to : ans - to;
      return g.choice(
        prompt: 'Round ${fmt(n)} to the nearest ${word[to]}.',
        visual: TextVisual(fmt(n), emoji: '🎯'),
        answer: fmt(ans),
        wrong: {fmt(other), fmt(ans + to), fmt(n ~/ (to * 10) * to * 10)}
          ..remove(fmt(ans)),
        count: 3,
      );
    },
    () {
      final (n, to) = pick();
      final target = roundTo(n, to);
      final wrong = <String>{};
      for (var i = 0; wrong.length < 3 && i < 80; i++) {
        final x = target + g.between(-to * 2, to * 2);
        if (x > 0 && roundTo(x, to) != target) wrong.add(fmt(x));
      }
      return g.choice(
        prompt: 'Which number rounds to ${fmt(target)} (nearest ${word[to]})?',
        visual: TextVisual('≈ ${fmt(target)}', emoji: '🎯'),
        answer: fmt(n),
        wrong: wrong,
      );
    },
    () {
      final a = g.between(11, g.level == Level.grade3 ? 99 : 999),
          b = g.between(11, g.level == Level.grade3 ? 99 : 999);
      final to = g.level == Level.grade3 ? 10 : 100;
      final est = roundTo(a, to) + roundTo(b, to);
      return g.choice(
        prompt:
            'Estimate by rounding to the nearest ${word[to]}: about how much is ${fmt(a)} + ${fmt(b)}?',
        visual: TextVisual('${fmt(a)} + ${fmt(b)} ≈ ?', emoji: '🤔'),
        answer: fmt(est),
        wrong: {fmt(est + to), fmt((est - to).abs()), fmt(est + to * 2)}
          ..remove(fmt(est)),
      );
    },
  ]);
}
