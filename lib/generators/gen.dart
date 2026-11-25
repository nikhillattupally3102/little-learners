import 'dart:math';

import '../models/models.dart';

/// Shared helpers for building worksheets at a given [level].
///
/// A [Gen] builds one worksheet. As questions are accepted it remembers the
/// words and pictures used, so the same worksheet never asks about the same
/// thing twice, never has two matching rounds, and never repeats the prompt
/// of the question right before. Questions whose [fingerprint] is in [avoid]
/// (seen by this child on an earlier day) are skipped while fresh ones exist.
class Gen {
  Gen(this.r, this.level, {Set<String>? avoid, this.maxMatches = 1})
    : avoid = avoid ?? const {};
  final Random r;
  final Level level;
  final Set<String> avoid;

  /// How many matching rounds this worksheet may have.
  int maxMatches;

  final _keys = <String>{};
  final _words = <String>{};
  int _matchCount = 0;
  String? _lastPrompt;

  int get matchesUsed => _matchCount;

  /// Questions per worksheet: short for toddlers, longer for older kids.
  int get count => byLevel({
    Level.age2: 3,
    Level.age3: 3,
    Level.preK: 5,
    Level.kindergarten: 6,
    Level.grade1: 7,
    Level.grade3: 8,
  });

  bool atLeast(Level l) => level.atLeast(l);
  bool atMost(Level l) => level.atMost(l);

  int between(int lo, int hi) => lo + r.nextInt(hi - lo + 1);
  T one<T>(List<T> xs) => xs[r.nextInt(xs.length)];
  List<T> pick<T>(Iterable<T> xs, int n) =>
      ([...xs]..shuffle(r)).take(n).toList();
  bool chance(double p) => r.nextDouble() < p;

  /// Picks the value for the first level in [table] that this level reaches,
  /// scanning from the highest. `{Level.age2: 3, Level.preK: 10}` → 10 for K.
  T byLevel<T>(Map<Level, T> table) {
    final keys = table.keys.toList()..sort((a, b) => b.index - a.index);
    for (final k in keys) {
      if (level.atLeast(k)) return table[k]!;
    }
    return table[keys.last]!;
  }

  /// A multiple-choice question with text (or emoji) answers.
  ChoiceQuestion choice({
    required String prompt,
    required Visual visual,
    required String answer,
    required Iterable<String> wrong,
    int? count,
    List<String>? speech,
  }) {
    final others = <String>{...wrong}..remove(answer);
    final n = min(count ?? others.length + 1, others.length + 1);
    final list = [answer, ...pick(others, n - 1)]..shuffle(r);
    return ChoiceQuestion(
      prompt: prompt,
      visual: visual,
      choices: [for (final v in list) Choice.label(v)],
      answer: list.indexOf(answer),
      speech: speech,
    );
  }

  /// A multiple-choice question whose answer is a number; distractors are near it.
  ChoiceQuestion number({
    required String prompt,
    required Visual visual,
    required int answer,
    int count = 4,
    int lowest = 0,
    String Function(int)? format,
    List<String>? speech,
  }) {
    final set = <int>{answer};
    var spread = max(2, (answer.abs() * .15).round());
    var guard = 0;
    while (set.length < count && guard++ < 200) {
      final c = answer + r.nextInt(spread * 2 + 1) - spread;
      if (c >= lowest) set.add(c);
      if (guard % 10 == 0) spread++;
    }
    final list = set.toList()..shuffle(r);
    final f = format ?? fmt;
    return ChoiceQuestion(
      prompt: prompt,
      visual: visual,
      choices: [for (final v in list) Choice.label(f(v))],
      answer: list.indexOf(answer),
      speech: speech,
    );
  }

  /// How many pairs each matching question has.
  static const matchCount = 8;

  MatchQuestion match(String prompt, List<(MatchItem, MatchItem)> pairs) {
    final order = List.generate(pairs.length, (i) => i)..shuffle(r);
    return MatchQuestion(
      prompt: prompt,
      left: [for (final p in pairs) p.$1],
      right: [for (final i in order) pairs[i].$2],
      answers: [for (var i = 0; i < pairs.length; i++) order.indexOf(i)],
    );
  }

  /// Builds [n] questions, rotating through several question [formats] so a
  /// worksheet never asks the same kind of question twice in a row.
  ///
  /// Rules are relaxed step by step only when a format runs out of fresh
  /// questions: first the "seen on an earlier day" rule, then the "different
  /// prompt" rule, and last the "no repeated words" rule.
  List<Question> mix(int n, List<Question Function()> formats) {
    final order = [...formats]..shuffle(r);
    final out = <Question>[];
    var i = 0, misses = 0;
    for (var tries = 0; out.length < n && tries < n * 40; tries++) {
      final q = order[i % order.length]();
      if (q is MatchQuestion && _matchCount >= maxMatches) {
        i++; // This format only makes matching rounds; use another one.
        continue;
      }
      if (_take(q, _strictness(misses))) {
        out.add(q);
        i++;
        misses = 0;
      } else {
        misses++;
        if (misses % 3 == 0) i++;
      }
    }
    return out;
  }

  /// Builds up to [n] questions with [make], following the same rules as [mix]
  /// (except the prompt rule: these questions all share one prompt style).
  List<Question> many(int n, Question Function() make) {
    final out = <Question>[];
    var misses = 0;
    for (var tries = 0; out.length < n && tries < n * 30; tries++) {
      final q = make();
      if (_take(q, max(_strictness(misses), 2))) {
        out.add(q);
        misses = 0;
      } else {
        misses++;
      }
    }
    return out;
  }

  /// Adds a question built outside [mix]/[many] to this worksheet's memory,
  /// so later questions avoid its words.
  T keep<T extends Question>(T q) {
    _register(q);
    return q;
  }

  /// Picks an item from [xs] whose [id] hasn't been seen recently (or isn't
  /// used yet in this worksheet), falling back to any item.
  T fresh<T>(List<T> xs, String Function(T) id) {
    final shuffled = [...xs]..shuffle(r);
    for (final x in shuffled) {
      final k = id(x).toLowerCase();
      if (!avoid.contains(itemFingerprint(k)) && !_words.contains(k)) {
        return x;
      }
    }
    for (final x in shuffled) {
      if (!_words.contains(id(x).toLowerCase())) return x;
    }
    return shuffled.first;
  }

  static int _strictness(int misses) => misses < 6
      ? 0
      : misses < 12
      ? 1
      : misses < 18
      ? 2
      : 3;

  bool _take(Question q, int strict) {
    final key = _key(q);
    if (_keys.contains(key)) return false;
    if (q is MatchQuestion && _matchCount >= maxMatches) return false;
    if (strict < 1 && avoid.contains(fingerprint(q))) return false;
    if (strict < 2 && _promptOf(q) == _lastPrompt) return false;
    if (strict < 3 && wordsOf(q).any(_words.contains)) return false;
    _register(q);
    return true;
  }

  void _register(Question q) {
    _keys.add(_key(q));
    _words.addAll(wordsOf(q));
    if (q is MatchQuestion) _matchCount++;
    _lastPrompt = _promptOf(q);
  }

  static String _promptOf(Question q) => switch (q) {
    ChoiceQuestion() => q.prompt,
    MatchQuestion() => q.prompt,
    TraceQuestion() => 'trace',
    ExampleQuestion() => 'example',
  };

  static final _numeric = RegExp(r'^[\d\s.,:/$¢%+−×÷=<>-]+$');

  /// The words and pictures a question is "about" — two questions sharing
  /// any of these feel like the same question to a child. Numbers and
  /// yes/no answers don't count (they repeat naturally).
  static Set<String> wordsOf(Question q) {
    String? norm(String? s) {
      if (s == null) return null;
      final t = s.trim().toLowerCase();
      if (t.isEmpty || t.length > 24 || _numeric.hasMatch(t)) return null;
      if (t.startsWith('yes') || t.startsWith('no ') || t == 'no') return null;
      if (t == 'true' || t == 'false') return null;
      return t;
    }

    final out = <String?>{};
    switch (q) {
      case ChoiceQuestion():
        out.add(norm(q.choices[q.answer].label));
        out.addAll(_visualWords(q.visual).map(norm));
      case MatchQuestion():
        for (final e in [...q.left, ...q.right]) {
          out.add(norm(e.text));
          out.add(norm(e.emoji));
        }
      case TraceQuestion():
        out.add(norm(q.glyph));
      case ExampleQuestion():
        break;
    }
    return out.whereType<String>().toSet();
  }

  static List<String?> _visualWords(Visual v) => switch (v) {
    CountVisual() => [v.emoji],
    EmojiVisual() => [v.emoji],
    TextVisual() => [v.text, v.emoji],
    WordPictureVisual() => [v.word, v.emoji],
    ShadowVisual() => [v.emoji],
    ArrayVisual() => [v.emoji],
    PassageVisual() => [v.title],
    _ => const [],
  };

  /// A short stable id for a question, used to remember what a child has
  /// already seen on earlier days.
  static String fingerprint(Question q) => _hash(_key(q));

  /// Id for a remembered item, such as a reading passage title.
  static String itemFingerprint(String item) => 'i${_hash(item.toLowerCase())}';

  /// Everything worth remembering about a worksheet's questions.
  static Iterable<String> fingerprints(Iterable<Question> qs) sync* {
    for (final q in qs) {
      yield fingerprint(q);
      if (q is ChoiceQuestion && q.visual is PassageVisual) {
        yield itemFingerprint((q.visual as PassageVisual).title);
      }
    }
  }

  /// FNV-1a — stable across runs and platforms (unlike String.hashCode).
  /// Written so every intermediate value stays below 2^53: web builds use
  /// JavaScript numbers, and the iPad and web apps must agree.
  static int stableHash(String s) {
    var h = 0x811c9dc5;
    for (final c in s.codeUnits) {
      h = (h ^ c) & 0xFFFFFFFF;
      // h * 0x01000193 mod 2^32, split as h*0x193 + (h mod 256) * 2^24.
      h = (h * 0x193 + (h & 0xFF) * 0x1000000) % 0x100000000;
    }
    return h;
  }

  static String _hash(String s) => stableHash(s).toRadixString(36);

  static String _key(Question q) => switch (q) {
    ChoiceQuestion() =>
      '${q.prompt}|${q.choices[q.answer].label ?? '${q.choices[q.answer].shape}${q.choices[q.answer].color}'}|${_visualKey(q.visual)}',
    TraceQuestion() => q.glyph,
    MatchQuestion() => q.left.map((e) => '${e.text}${e.emoji}').join(','),
    ExampleQuestion() => 'example|${q.title}',
  };

  static String _visualKey(Visual v) => switch (v) {
    EquationVisual() => '${v.a}${v.op}${v.b}',
    CountVisual() => '${v.emoji}${v.count}',
    ShapeVisual() => '${v.shape}${v.color}',
    ArrayVisual() => '${v.rows}x${v.cols}',
    RectVisual() => '${v.width}x${v.height}${v.grid}',
    FractionVisual() => '${v.parts}/${v.shaded}',
    TextVisual() => v.text,
    EmojiVisual() => v.emoji,
    SudokuVisual() => v.cells.join(),
    MixedVisual() => v.items.join(),
    ClockVisual() => '${v.hour}:${v.minute}',
    CoinsVisual() => v.coins.join(','),
    PatternVisual() => v.items.join(),
    PassageVisual() => v.title,
    WordPictureVisual() => '${v.word}${v.missingIndex}',
    ShadowVisual() => v.emoji,
    MatrixVisual() => v.cells.join('|'),
    FoldVisual() => '${v.fold}${v.holes}',
    _ => '',
  };
}

/// 12345 → "12,345"
String fmt(int n) {
  final s = n.abs().toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
    buf.write(s[i]);
  }
  return n < 0 ? '-$buf' : buf.toString();
}

int gcd(int a, int b) => b == 0 ? a.abs() : gcd(b, a % b);

/// Simplest form of n/d as a label, e.g. 6/4 → "1 1/2", 4/2 → "2".
String fraction(int n, int d) {
  final g = gcd(n, d);
  n ~/= g;
  d ~/= g;
  if (d == 1) return '$n';
  if (n > d) return '${n ~/ d} ${n % d}/$d';
  return '$n/$d';
}

String titleCase(String w) =>
    w.isEmpty ? w : w[0].toUpperCase() + w.substring(1).toLowerCase();
