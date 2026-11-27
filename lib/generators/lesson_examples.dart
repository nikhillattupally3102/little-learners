import '../models/models.dart';
import 'gen.dart';
import 'math_formats.dart' show countables, names, clock, group;

// "Let's learn!" pages for sheets that practise a skill: a worked example
// (math) or how to play (puzzles, thinking, writing). Steps are read aloud
// one by one. They are plain words — no emoji — because the step boxes are
// plain text.

/// The page for [kind], or null when it teaches with cards instead.
ExampleQuestion? workedExample(WorksheetKind kind, Gen g) => switch (kind) {
  WorksheetKind.counting => _counting(g),
  WorksheetKind.numberFind => _numberOrder(g),
  WorksheetKind.moreLess => _moreLess(g),
  WorksheetKind.sizes => const ExampleQuestion(
    title: 'Big and small',
    visual: MatrixVisual(['🐘', '🐭'], joins: []),
    steps: [
      'The elephant is big.',
      'The mouse is small.',
      'Look carefully to find the biggest or the smallest!',
    ],
  ),
  WorksheetKind.addition => _addition(g),
  WorksheetKind.subtraction => _subtraction(g),
  WorksheetKind.compareNumbers => _compare(g),
  WorksheetKind.placeValue => _placeValue(g),
  WorksheetKind.time => _time(g),
  WorksheetKind.money => _money(g),
  WorksheetKind.fractions => _fractions(g),
  WorksheetKind.wordProblems => _wordProblem(g),
  WorksheetKind.area => _area(g),
  WorksheetKind.rounding => _rounding(g),
  WorksheetKind.decimals => _decimals(g),
  WorksheetKind.matchPairs => const ExampleQuestion(
    title: 'How to match',
    visual: MatrixVisual(['🐶', '🦴']),
    steps: [
      'Tap a picture.',
      'Then tap the picture that goes with it.',
      'A dog goes with a bone!',
    ],
  ),
  WorksheetKind.oddOneOut => const ExampleQuestion(
    title: 'Find the odd one out',
    visual: MixedVisual(['🍎', '🍌', '🍇', '🚗']),
    steps: [
      'Look at all the pictures.',
      'Three of them go together: an apple, a banana and grapes are all fruit.',
      'The car is not a fruit. The car is the odd one out!',
    ],
  ),
  WorksheetKind.shadows => const ExampleQuestion(
    title: 'Shadow match',
    visual: ShadowVisual('🐘'),
    steps: [
      'A shadow is the dark shape something makes.',
      'Look at the outline: a long trunk, big ears and four legs.',
      'That is the shadow of an elephant!',
    ],
  ),
  WorksheetKind.patterns => _patterns(g),
  WorksheetKind.sudoku => const ExampleQuestion(
    title: 'How to play Mini Sudoku',
    visual: SudokuVisual([
      '⭐', '🍎', '🐶', '🍇', //
      '🐶', '🍇', '⭐', '🍎',
      '🍎', '⭐', '🍇', '🐶',
      '🍇', '🐶', '🍎', '?',
    ]),
    steps: [
      'Every row has one of each picture.',
      'Every column has one of each picture too.',
      'The last row has grapes, a dog and an apple. The star is missing!',
    ],
  ),
  WorksheetKind.riddles => _riddle(g),
  WorksheetKind.missingNumber => _missingNumber(g),
  WorksheetKind.comprehension => ExampleQuestion(
    title: 'How to read and answer',
    visual: const EmojiVisual('📖'),
    steps: [
      if (g.atMost(Level.grade1))
        'Listen to the whole story first.'
      else
        'Read the whole story first.',
      'Then read the question carefully.',
      'Look back in the story to find the answer.',
    ],
  ),
  WorksheetKind.fillGap => const ExampleQuestion(
    title: 'How to fill the gap',
    visual: TextVisual('The cat is sleeping ___ the box.', emoji: '🐱'),
    steps: [
      'Read the whole sentence.',
      'Try each word in the gap: "on", "in", "run".',
      '"The cat is sleeping in the box" makes sense. The answer is "in".',
    ],
  ),
  WorksheetKind.fixSentence => ExampleQuestion(
    title: 'How to fix a sentence',
    visual: const TextVisual('the dog ran home', emoji: '✏️'),
    steps: [
      'A sentence starts with a capital letter: "The".',
      'It ends with a full stop, a question mark or an exclamation mark.',
      if (g.atLeast(Level.grade2))
        'Names of people and places start with a capital letter too.',
      'So it should be: "The dog ran home."',
    ],
  ),
  WorksheetKind.wordThinking => const ExampleQuestion(
    title: 'How to solve picture puzzles',
    visual: MatrixVisual(['🐟', '🌊', '🐦', '🌳']),
    steps: [
      'Look at the first two pictures. How do they go together?',
      'A fish lives in the water.',
      'Do the same with the next picture: a bird lives in a tree.',
      'Sometimes three pictures go together. Find what they all share!',
    ],
  ),
  WorksheetKind.numberThinking => _numberThinking(g),
  WorksheetKind.shapeThinking => const ExampleQuestion(
    title: 'How to solve shape puzzles',
    visual: MatrixVisual([
      'fig:star.0.1.s.0.b',
      'fig:star.0.1.s.0.s',
      'fig:heart.2.1.s.0.b',
      'fig:heart.2.1.s.0.s',
    ]),
    steps: [
      'Look at how the first picture changes: the big star becomes a small star.',
      'Do the same to the next one: the big heart becomes a small heart.',
      'Check the colour, the size, the number and the way it is turned.',
    ],
  ),
  _ => null,
};

// ------------------------------------------------------------------ early

ExampleQuestion _counting(Gen g) {
  final (emoji, name) = g.one(countables);
  final n = g.between(3, g.atLeast(Level.kindergarten) ? 7 : 5);
  return ExampleQuestion(
    title: 'How to count',
    visual: CountVisual(emoji, n),
    steps: [
      'Touch each one and say a number: ${_upTo(1, n)}.',
      'The last number you say is how many.',
      'There are $n $name!',
    ],
  );
}

ExampleQuestion _numberOrder(Gen g) {
  final start = g.between(1, g.atLeast(Level.kindergarten) ? 6 : 3);
  return ExampleQuestion(
    title: 'Numbers go in order',
    visual: PatternVisual([
      for (var i = start; i < start + 4; i++) '$i',
      '${start + 4}',
    ]),
    steps: [
      'Count along: ${_upTo(start, start + 4)}.',
      'Each number is one more than the one before.',
      'After ${start + 4} comes ${start + 5}.',
    ],
  );
}

ExampleQuestion _moreLess(Gen g) {
  final (emoji, name) = g.one(countables);
  final a = g.between(4, 6), b = g.between(1, 3);
  return ExampleQuestion(
    title: 'More or less?',
    visual: MatrixVisual([group(emoji, a), group(emoji, b)], joins: []),
    steps: [
      'Count the first group: $a $name.',
      'Count the second group: $b.',
      '$a is more than $b, so the first group has more. The second group has less.',
    ],
  );
}

// ------------------------------------------------------- add & subtract

ExampleQuestion _addition(Gen g) {
  if (g.atMost(Level.kindergarten)) {
    final (emoji, name) = g.one(countables);
    final a = g.between(2, 3), b = g.between(1, 3);
    return ExampleQuestion(
      title: 'Adding means putting together',
      visual: EquationVisual(a, b, op: '+', emoji: emoji),
      steps: [
        'There are $a $name.',
        'Then $b more come.',
        'Count them all: ${_upTo(1, a + b)}.',
        'So $a + $b = ${a + b}.',
      ],
    );
  }
  if (g.level == Level.grade1) {
    final a = g.between(6, 9), b = g.between(2, 4);
    return ExampleQuestion(
      title: 'Count on from the bigger number',
      visual: TextVisual('$a + $b = ?'),
      steps: [
        'Start at $a and keep it in your head.',
        'Count on $b more: ${_upTo(a + 1, a + b)}.',
        'So $a + $b = ${a + b}.',
      ],
    );
  }
  final (lo, hi) = g.level == Level.grade2 ? (14, 58) : (125, 589);
  final a = g.between(lo, hi), b = g.between(lo, hi);
  return ExampleQuestion(
    title: 'Add one place at a time',
    visual: TextVisual('$a + $b = ?'),
    steps: [..._columnAdd(a, b), 'So $a + $b = ${a + b}.'],
  );
}

ExampleQuestion _subtraction(Gen g) {
  if (g.atMost(Level.kindergarten)) {
    final (emoji, name) = g.one(countables);
    final a = g.between(4, 6), b = g.between(1, 3);
    return ExampleQuestion(
      title: 'Take away means some go',
      visual: EquationVisual(a, b, op: '−', emoji: emoji),
      steps: [
        'Start with $a $name.',
        'Take $b away.',
        'Count what is left: ${_upTo(1, a - b)}.',
        'So $a − $b = ${a - b}.',
      ],
    );
  }
  if (g.level == Level.grade1) {
    final a = g.between(9, 14), b = g.between(2, 4);
    return ExampleQuestion(
      title: 'Count back',
      visual: TextVisual('$a − $b = ?'),
      steps: [
        'Start at $a.',
        'Count back $b: ${[for (var i = a - 1; i >= a - b; i--) '$i'].join(', ')}.',
        'So $a − $b = ${a - b}.',
      ],
    );
  }
  final (lo, hi) = g.level == Level.grade2 ? (41, 95) : (412, 965);
  var a = g.between(lo, hi);
  // No zeros on top, so borrowing never needs two steps.
  while ('$a'.contains('0')) {
    a = g.between(lo, hi);
  }
  final b = g.between(lo ~/ 3, a - 5);
  return ExampleQuestion(
    title: 'Subtract one place at a time',
    visual: TextVisual('$a − $b = ?'),
    steps: [..._columnSubtract(a, b), 'So $a − $b = ${a - b}.'],
  );
}

const _places = ['ones', 'tens', 'hundreds', 'thousands'];

List<String> _columnAdd(int a, int b) {
  final steps = <String>[];
  var carry = 0;
  for (var p = 0; p < '${a > b ? a : b}'.length; p++) {
    final x = (a ~/ _pow10(p)) % 10, y = (b ~/ _pow10(p)) % 10;
    final sum = x + y + carry;
    final plus = carry > 0 ? ' + $carry carried' : '';
    steps.add(
      sum >= 10
          ? 'Add the ${_places[p]}: $x + $y$plus = $sum. Write ${sum % 10} and carry 1.'
          : 'Add the ${_places[p]}: $x + $y$plus = $sum.',
    );
    carry = sum ~/ 10;
  }
  if (carry > 0) steps.add('Write the carried 1 at the front.');
  return steps;
}

List<String> _columnSubtract(int a, int b) {
  final steps = <String>[];
  var borrow = 0;
  for (var p = 0; p < '$a'.length; p++) {
    final x = (a ~/ _pow10(p)) % 10 - borrow, y = (b ~/ _pow10(p)) % 10;
    if (p >= '$b'.length && borrow == 0) break;
    if (x < y) {
      steps.add(
        '${_cap(_places[p])}: $x is less than $y, so borrow 1 from the ${_places[p + 1]}. ${x + 10} − $y = ${x + 10 - y}.',
      );
      borrow = 1;
    } else {
      steps.add('${_cap(_places[p])}: $x − $y = ${x - y}.');
      borrow = 0;
    }
  }
  return steps;
}

int _pow10(int p) => [1, 10, 100, 1000, 10000][p];

// ------------------------------------------------------------ numbers

ExampleQuestion _compare(Gen g) {
  final digits = g.atMost(Level.grade1)
      ? 2
      : g.level == Level.grade2
      ? 3
      : 4;
  final lo = _pow10(digits - 1), hi = _pow10(digits) - 1;
  final a = g.between(lo, hi);
  var b = g.between(lo, hi);
  if (a == b) b = a == hi ? a - 1 : a + 1;
  final sa = '$a', sb = '$b';
  var i = 0;
  while (sa[i] == sb[i]) {
    i++;
  }
  final place = _places[digits - 1 - i];
  final big = a > b ? a : b, small = a > b ? b : a;
  return ExampleQuestion(
    title: 'Which number is bigger?',
    visual: TextVisual('$a  or  $b'),
    steps: [
      'Both numbers have $digits digits.',
      'Compare from the left, one place at a time.',
      'The $place are different: ${sa[i]} and ${sb[i]}.',
      'So $big is bigger than $small: $big > $small.',
    ],
  );
}

ExampleQuestion _placeValue(Gen g) {
  final digits = switch (g.level) {
    Level.grade1 => 2,
    Level.grade2 => 3,
    _ => 4,
  };
  var n = g.between(_pow10(digits - 1), _pow10(digits) - 1);
  if (n % 10 == 0) n++;
  final s = '$n';
  return ExampleQuestion(
    title: 'Each digit has a place',
    visual: TextVisual(s),
    steps: [
      for (var i = 0; i < s.length; i++)
        if (s[i] != '0')
          'The ${s[i]} is in the ${_places[s.length - 1 - i]} place: it means ${int.parse(s[i]) * _pow10(s.length - 1 - i)}.',
      'So $n = ${[for (var i = 0; i < s.length; i++)
        if (s[i] != '0') '${int.parse(s[i]) * _pow10(s.length - 1 - i)}'].join(' + ')}.',
    ],
  );
}

ExampleQuestion _time(Gen g) {
  final h = g.between(1, 12);
  final m = switch (g.level) {
    Level.grade1 => g.one([0, 30]),
    _ => g.between(1, 11) * 5,
  };
  return ExampleQuestion(
    title: 'How to tell the time',
    visual: ClockVisual(h, m),
    steps: [
      'The short hand shows the hour. It points to $h.',
      if (m == 0)
        'The long hand points to 12, so it is $h o\'clock.'
      else if (m == 30)
        'The long hand points to 6. That is half past $h.'
      else ...[
        'The long hand shows the minutes. Each number on the clock is 5 minutes.',
        'It points to ${m ~/ 5}: ${m ~/ 5} × 5 = $m minutes.',
      ],
      'The time is ${clock(h, m)}.',
    ],
  );
}

ExampleQuestion _money(Gen g) {
  final quarters = g.atLeast(Level.grade2);
  final coins = [
    if (quarters) 25,
    10,
    if (g.chance(.5)) 10,
    5,
    1,
    if (g.chance(.5)) 1,
  ];
  var total = 0;
  final counts = [for (final c in coins) '${total += c}'];
  return ExampleQuestion(
    title: 'How to count coins',
    visual: CoinsVisual(coins),
    steps: [
      quarters
          ? 'A penny is 1 cent, a nickel 5 cents, a dime 10 cents and a quarter 25 cents.'
          : 'A penny is 1 cent, a nickel is 5 cents and a dime is 10 cents.',
      'Start with the biggest coin and count on: ${counts.join(', ')}.',
      'That is $total cents in all.',
    ],
  );
}

ExampleQuestion _fractions(Gen g) {
  final parts = g.atMost(Level.grade1) ? g.one([2, 4]) : g.between(3, 8);
  final shaded = g.between(1, parts - 1);
  return ExampleQuestion(
    title: 'What is a fraction?',
    visual: FractionVisual(parts, shaded),
    steps: [
      'The shape is cut into $parts equal parts.',
      '$shaded of them ${shaded == 1 ? 'is' : 'are'} coloured.',
      'So $shaded/$parts is coloured: $shaded out of $parts.',
      if (g.atLeast(Level.grade3)) 'The bottom number is how many equal parts. The top number is how many we count.',
    ],
  );
}

ExampleQuestion _wordProblem(Gen g) {
  final who = g.one(names);
  final (emoji, name) = g.one(countables);
  if (g.atLeast(Level.grade3) && g.chance(.5)) {
    final bags = g.between(3, 6), each = g.between(4, 9);
    return ExampleQuestion(
      title: 'How to solve a word problem',
      visual: TextVisual(
        '$who has $bags bags with $each $name in each bag. How many $name in all?',
        emoji: emoji,
      ),
      steps: [
        'Find the numbers: $bags bags and $each in each.',
        'The same number in each group means multiply.',
        '$bags × $each = ${bags * each}. $who has ${bags * each} $name.',
      ],
    );
  }
  final big = g.atLeast(Level.grade2);
  final a = g.between(big ? 24 : 6, big ? 60 : 12);
  final b = g.between(big ? 11 : 2, big ? 23 : 5);
  final add = g.chance(.5);
  return ExampleQuestion(
    title: 'How to solve a word problem',
    visual: TextVisual(
      add
          ? '$who has $a $name. $who gets $b more. How many now?'
          : '$who has $a $name and gives away $b. How many are left?',
      emoji: emoji,
    ),
    steps: [
      'Find the numbers: $a and $b.',
      add
          ? 'The clue word "more" means add.'
          : 'The clue words "gives away" and "left" mean subtract.',
      add
          ? '$a + $b = ${a + b}. $who has ${a + b} $name.'
          : '$a − $b = ${a - b}. $who has ${a - b} $name left.',
    ],
  );
}

ExampleQuestion _area(Gen g) {
  final w = g.between(3, 6), h = g.between(2, 4);
  return ExampleQuestion(
    title: 'Area and perimeter',
    visual: RectVisual(w, h),
    steps: [
      'Area is how many squares cover the shape.',
      'There are $h rows of $w squares: $h × $w = ${w * h} square units.',
      'Perimeter is the distance all the way around.',
      'Add the sides: $w + $h + $w + $h = ${2 * (w + h)} units.',
    ],
  );
}

ExampleQuestion _rounding(Gen g) {
  final n = g.between(12, 98);
  final ones = n % 10;
  final up = ones >= 5;
  final r = up ? n - ones + 10 : n - ones;
  return ExampleQuestion(
    title: 'Round to the nearest ten',
    visual: TextVisual('$n'),
    steps: [
      'Look at the ones digit: $ones.',
      '5 or more rounds up. 4 or less rounds down.',
      '$ones ${up ? 'is 5 or more, so round up' : 'is 4 or less, so round down'}: $n rounds to $r.',
    ],
  );
}

ExampleQuestion _decimals(Gen g) {
  final whole = g.between(1, 9), t = g.between(1, 9), h = g.between(1, 9);
  return ExampleQuestion(
    title: 'Reading decimals',
    visual: TextVisual('$whole.$t$h'),
    steps: [
      'The $whole before the point is ones.',
      'The $t is in the tenths place: $t tenths = 0.$t.',
      'The $h is in the hundredths place: $h hundredths = 0.0$h.',
      'So $whole.$t$h = $whole + 0.$t + 0.0$h.',
    ],
  );
}

// ------------------------------------------------------------ puzzles

ExampleQuestion _patterns(Gen g) {
  if (g.atLeast(Level.grade1)) {
    final start = g.between(2, 9), step = g.between(2, 5);
    final items = [for (var i = 0; i < 4; i++) '${start + step * i}'];
    return ExampleQuestion(
      title: 'What comes next?',
      visual: PatternVisual([...items, '?']),
      steps: [
        'Look at how each number changes.',
        'Each one is $step more than the one before.',
        'So next is ${start + step * 3} + $step = ${start + step * 4}.',
      ],
    );
  }
  return const ExampleQuestion(
    title: 'What comes next?',
    visual: PatternVisual(['🔴', '🔵', '🔴', '🔵', '?']),
    steps: [
      'Say the pattern out loud: red, blue, red, blue.',
      'Red, blue repeats again and again.',
      'So next comes red!',
    ],
  );
}

ExampleQuestion _riddle(Gen g) {
  final a = g.between(4, 9), b = g.between(2, 5);
  return ExampleQuestion(
    title: 'How to solve a number riddle',
    visual: TextVisual('I am $b more than $a. What number am I?', emoji: '🤔'),
    steps: [
      'Start with the number you know: $a.',
      '"$b more" means add $b: ${_upTo(a + 1, a + b)}.',
      'The answer is ${a + b}.',
    ],
  );
}

ExampleQuestion _missingNumber(Gen g) {
  final a = g.between(3, 12), b = g.between(2, 9);
  return ExampleQuestion(
    title: 'Find the missing number',
    visual: TextVisual('$a + ? = ${a + b}'),
    steps: [
      'Ask: $a plus what makes ${a + b}?',
      'Count up from $a to ${a + b}: that is $b jumps.',
      'So the missing number is $b. Check: $a + $b = ${a + b}.',
    ],
  );
}

ExampleQuestion _numberThinking(Gen g) {
  final a = g.between(2, 5), add = g.between(1, 3), c = g.between(3, 7);
  return ExampleQuestion(
    title: 'How to solve number puzzles',
    visual: MatrixVisual(['$a', '${a + add}', '$c', '${c + add}']),
    steps: [
      'Look at how the first number changes: $a becomes ${a + add}.',
      'It got $add more.',
      'Do the same to the next number: $c + $add = ${c + add}.',
    ],
  );
}

// ------------------------------------------------------------- helpers

/// "1, 2, 3" (at most 12 numbers).
String _upTo(int from, int to) =>
    [for (var i = from; i <= to && i < from + 12; i++) '$i'].join(', ');

String _cap(String s) => s[0].toUpperCase() + s.substring(1);
