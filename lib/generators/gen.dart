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

  /// What accepted questions were about: their answers, and what they showed.
  final _aboutAnswers = <String>{};
  final _aboutShown = <String>{};

  /// Facts already asked about on this worksheet.
  final _facts = <String>{};

  static List<String> _factsOf(Question q) => switch (q) {
    ChoiceQuestion() => q.facts,
    MatchQuestion() => q.facts,
    _ => const [],
  };
  int _matchCount = 0;
  String? _lastPrompt;

  int get matchesUsed => _matchCount;

  /// Questions per worksheet: short for toddlers, longer for older kids.
  int get count => byLevel({
    Level.age2: 3,
    Level.age3: 3,
    Level.preK: 5,
    Level.kindergarten: 5,
    Level.grade1: 5,
    Level.grade2: 7,
    Level.grade4: 8,
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
    List<String> facts = const [],
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
      facts: facts,
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

  /// How many pairs each matching question has (at most).
  static const matchCount = 8;

  /// Pairs in a matching round: fewer for the youngest.
  int get pairs => atMost(Level.kindergarten) ? 5 : matchCount;

  /// Pairs for a matching round from [available] items: fewer when the
  /// topic is small, so the sheet's other questions can each be about
  /// something new (questions often show two items: [perQuestion]).
  int matchSize(int available, {int perQuestion = 2}) =>
      (available - perQuestion * (count - 1)).clamp(4, pairs);

  /// Whether nothing in [texts] (names, pictures) has come up on this
  /// worksheet yet.
  bool isFresh(Iterable<String> texts) => texts.every(
    (t) => _subjects(t)
        .every((x) => !_aboutAnswers.contains(x) && !_aboutShown.contains(x)),
  );

  MatchQuestion match(
    String prompt,
    List<(MatchItem, MatchItem)> pairs, {
    List<String> facts = const [],
  }) {
    final order = List.generate(pairs.length, (i) => i)..shuffle(r);
    return MatchQuestion(
      prompt: prompt,
      facts: facts,
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
      : misses < 30
      ? 3
      : 4;

  bool _take(Question q, int strict) {
    final key = _key(q);
    if (_keys.contains(key)) return false;
    // Never the same fact twice on one worksheet, however short it gets.
    if (_factsOf(q).any(_facts.contains)) return false;
    if (q is MatchQuestion && _matchCount >= maxMatches) return false;
    if (strict < 1 && avoid.contains(fingerprint(q))) return false;
    if (strict < 2 && _promptOf(q) == _lastPrompt) return false;
    if (strict < 3 && wordsOf(q).any(_words.contains)) return false;
    // Two questions about the same thing ("Rabbits live in burrows: true?"
    // then "Who lives in a burrow?") — the last rule to give way.
    if (strict < 4 && _aboutTaken(q)) return false;
    _register(q);
    return true;
  }

  bool _aboutTaken(Question q) {
    final (answer, shown) = aboutOf(q);
    return answer.any(
          (x) => _aboutAnswers.contains(x) || _aboutShown.contains(x),
        ) ||
        shown.any(_aboutAnswers.contains);
  }

  void _register(Question q) {
    _keys.add(_key(q));
    _words.addAll(wordsOf(q));
    final (answer, shown) = aboutOf(q);
    _aboutAnswers.addAll(answer);
    _aboutShown.addAll(shown);
    _facts.addAll(_factsOf(q));
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

  /// What a question is about, as (answer, shown): the things in its
  /// answer, and the things in its picture, caption or sentence. For yes/no
  /// and true/false questions the statement shown is the answer.
  ///
  /// "Rabbits live in burrows: true?" is about rabbit and burrow; so is
  /// "Who lives in a burrow? → 🐰". Prompts are left out: a worksheet's
  /// prompts share a template, which doesn't make questions related.
  static (Set<String>, Set<String>) aboutOf(Question q) {
    switch (q) {
      case ChoiceQuestion():
        // Questions about one reading passage are meant to be related.
        if (q.visual is PassageVisual) return (const {}, const {});
        final label = q.choices[q.answer].label ?? '';
        final shown = {for (final t in _visualText(q.visual)) ..._subjects(t)};
        // A row of pictures (🍎🍎🍎, a sequence) isn't one thing.
        final many =
            label.runes.where((r) => _isPicture(r)).length > 1 &&
            !label.contains(' ');
        // Puzzle figures are compared exactly elsewhere.
        final spec = label.startsWith('fig:') || label.startsWith('paper:');
        final answer = many || spec ? <String>{} : _subjects(label);
        final yesNo = RegExp(
          r'^(yes|no|true|false)\b',
          caseSensitive: false,
        ).hasMatch(label.trim());
        return (yesNo ? shown : answer, shown);
      case MatchQuestion():
        final all = {
          for (final e in [...q.left, ...q.right]) ...{
            ..._subjects(e.text),
            ..._subjects(e.emoji ?? ''),
          },
        };
        return (all, all);
      case TraceQuestion() || ExampleQuestion():
        return (const {}, const {});
    }
  }

  /// Whether two questions are about the same thing: one's answer is in
  /// the other's picture, sentence or answer.
  static bool related(Question a, Question b) {
    if (_factsOf(a).any(_factsOf(b).contains)) return true;
    final (aAnswer, aShown) = aboutOf(a);
    final (bAnswer, bShown) = aboutOf(b);
    return aAnswer.any((x) => bAnswer.contains(x) || bShown.contains(x)) ||
        bAnswer.any(aShown.contains);
  }

  static List<String> _visualText(Visual v) => switch (v) {
    TextVisual() => [v.text],
    EmojiVisual() => [v.emoji, ?v.caption],
    CountVisual() => [v.emoji],
    WordPictureVisual() => [v.word, v.emoji],
    ShadowVisual() => [v.emoji],
    ArrayVisual() => [v.emoji],
    MixedVisual() => v.items,
    _ => const [],
  };

  /// Words that say nothing about what a question is about.
  static const _filler = {
    'a',
    'an',
    'the',
    'and',
    'or',
    'but',
    'of',
    'to',
    'in',
    'on',
    'at',
    'by',
    'for',
    'with',
    'from',
    'into',
    'onto',
    'up',
    'out',
    'off',
    'over',
    'is',
    'are',
    'was',
    'were',
    'be',
    'been',
    'am',
    'do',
    'does',
    'did',
    'has',
    'have',
    'had',
    'can',
    'could',
    'will',
    'would',
    'should',
    'may',
    'it',
    'its',
    'this',
    'that',
    'these',
    'those',
    'there',
    'here',
    'they',
    'them',
    'their',
    'he',
    'she',
    'his',
    'her',
    'him',
    'you',
    'your',
    'we',
    'our',
    'us',
    'i',
    'me',
    'my',
    'who',
    'what',
    'which',
    'where',
    'when',
    'why',
    'how',
    'one',
    'ones',
    'some',
    'many',
    'much',
    'more',
    'most',
    'all',
    'each',
    'every',
    'any',
    'not',
    'no',
    'yes',
    'true',
    'false',
    'so',
    'if',
    'than',
    'then',
    'too',
    'very',
    'just',
    'also',
    'only',
    'same',
    'other',
    'live',
    'lives',
    'living',
    'find',
    'tap',
    'pick',
    'choose',
    'show',
    'look',
    'see',
    'tell',
    'make',
    'makes',
    'made',
    'go',
    'goes',
    'get',
    'gets',
    'use',
    'used',
    'uses',
    'call',
    'called',
    'name',
    'word',
    'words',
    'sentence',
    'picture',
    'pictures',
    'answer',
    'question',
    'number',
    'numbers',
    'thing',
    'things',
    'kind',
    'best',
    'right',
    'correct',
    'missing',
    'blank',
    'next',
    'come',
    'comes',
    'first',
    'last',
    'belong',
    'belongs',
    'together',
    'match',
    'mean',
    'means',
    'like',
    'about',
    'help',
    'pic',
    'united',
  };

  /// Pictures that are just marks (✅ ❌ → +), not subjects.
  static const _marks = {
    0x2705,
    0x274C,
    0x2714,
    0x2716,
    0x2795,
    0x2796,
    0x2797,
    0x1F44D, // 👍
    0x1F44E, // 👎
  };

  static bool _isPicture(int r) =>
      (r >= 0x1F000 || (r >= 0x2600 && r <= 0x27BF)) && !_marks.contains(r);

  /// The things [text] names: its pictures and its main words (stemmed).
  static Set<String> subjectsOf(String text) => _subjects(text);

  static Set<String> _subjects(String text) {
    final out = <String>{};
    // Pictures (emoji) name things too.
    final runes = text.runes.toList();
    for (var i = 0; i < runes.length; i++) {
      final r = runes[i];
      // Flags are two letters (🇮 🇳): keep them together.
      if (r >= 0x1F1E6 && r <= 0x1F1FF && i + 1 < runes.length) {
        out.add(String.fromCharCodes([r, runes[++i]]));
      } else if (_isPicture(r)) {
        out.add(String.fromCharCode(r));
      }
    }
    for (final w in text.toLowerCase().split(RegExp(r'[^a-z]+'))) {
      if (w.length < 3 || _filler.contains(w)) continue;
      out.add(_stem(w));
    }
    return out;
  }

  /// burrows → burrow, berries → berry, boxes → box.
  static String _stem(String w) {
    if (w.length > 4 && w.endsWith('ies')) {
      return '${w.substring(0, w.length - 3)}y';
    }
    if (w.length > 4 && RegExp(r'(s|x|z|ch|sh)es$').hasMatch(w)) {
      return w.substring(0, w.length - 2);
    }
    if (w.length > 3 && w.endsWith('s') && !w.endsWith('ss')) {
      return w.substring(0, w.length - 1);
    }
    return w;
  }

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
