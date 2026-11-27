import '../content/geography.dart';
import '../content/reading.dart';
import '../content/science.dart';
import '../content/topics.dart';
import '../models/models.dart';
import '../content/puzzles_writing.dart' show pictureWords;
import 'gen.dart';
import 'lesson_examples.dart';
import 'math_formats.dart' show countables;

// "Let's learn!" pages before a sheet's questions, shown the first time a
// child gets that kind of sheet and again after a break (see
// Progress.needsLesson):
// - science, geography and word sheets: picture cards teaching exactly the
//   things the questions ask about;
// - math: a worked example; puzzles, thinking and writing: how to play
//   (lesson_examples.dart).

/// Cards per page: fits an iPad or laptop screen without scrolling.
const lessonPageSize = 6;

/// Sheets that teach as they go, or need no lesson: tracing shows the
/// strokes, times tables and division open with a worked example every
/// time, the GT test is a test, and toddlers learn with cards already.
bool hasLesson(WorksheetKind kind, Level level) =>
    level.atLeast(Level.preK) &&
    !const {
      WorksheetKind.tracing,
      WorksheetKind.multiplication,
      WorksheetKind.division,
      WorksheetKind.gtTest,
      WorksheetKind.topicQuiz,
      WorksheetKind.listen,
    }.contains(kind);

/// The lesson for a sheet of [kind] with these [questions]. [g] makes worked
/// examples (with numbers different from the sheet's).
List<ExampleQuestion> lessonFor(
  WorksheetKind kind,
  List<Question> questions,
  Gen g,
) {
  final example = workedExample(kind, g);
  if (example != null) return [example];
  // The words the sheet's answers use ("go", "d", "sunflower").
  final answers = <String>{
    for (final q in questions)
      ...switch (q) {
        ChoiceQuestion() => [q.choices[q.answer].label?.toLowerCase().trim()],
        MatchQuestion() => [
          for (final e in [...q.left, ...q.right]) e.text.toLowerCase().trim(),
        ],
        _ => const <String>[],
      }.whereType<String>(),
  };
  final about = <String>{
    for (final q in questions) ...{...Gen.aboutOf(q).$1, ...Gen.aboutOf(q).$2},
  };
  bool onSheet(String emoji, String name) =>
      Gen.subjectsOf(emoji).any(about.contains) ||
      Gen.subjectsOf(name).isNotEmpty &&
          Gen.subjectsOf(name).every(about.contains);

  final cards = switch (kind) {
    WorksheetKind.animalHomes => [
      for (final (e, animal, home, he) in animalHomes)
        if (onSheet(e, animal))
          LessonCard(e, '$he $home', '${_a(animal)} lives ${_inHome(home)}.'),
    ],
    WorksheetKind.babyAnimals => [
      for (final (e, parent, baby) in babyAnimals)
        if (onSheet(e, parent) || onSheet('', baby))
          LessonCard(
            e,
            baby,
            'A baby ${parent.toLowerCase()} is called ${_a(baby).toLowerCase()}.',
          ),
    ],
    WorksheetKind.animalSounds => [
      for (final (e, animal, sound) in animalSounds)
        if (onSheet(e, animal))
          LessonCard(e, '"$sound"', '${_a(animal)} says $sound.'),
    ],
    WorksheetKind.sinkFloat => [
      for (final (e, name, floats) in sinkFloatItems)
        if (onSheet(e, name))
          LessonCard(
            e,
            floats ? 'Floats' : 'Sinks',
            '${_a(name)} ${floats ? 'floats' : 'sinks'}.',
          ),
    ],
    WorksheetKind.livingThings => [
      for (final (e, name, living) in livingItems)
        if (onSheet(e, name))
          LessonCard(
            e,
            living ? 'Living' : 'Not living',
            '${_a(name)} is ${living ? 'living' : 'not living'}.',
          ),
    ],
    WorksheetKind.animalGroups => [
      for (final (e, animal, group) in animalGroupItems)
        if (onSheet(e, animal))
          LessonCard(e, group, '${_a(animal)} is ${_a(group).toLowerCase()}.'),
    ],
    WorksheetKind.flags => [
      for (final c in topics.firstWhere((t) => t.id == 'countries').items)
        if (onSheet(c.emoji, c.name))
          LessonCard(c.emoji, c.name, 'This is the flag of ${_the(c.name)}.'),
    ],
    WorksheetKind.capitals => [
      for (final (country, pic, capital) in capitalCities)
        if (onSheet(pic == '🗺️' ? '' : pic, country) || onSheet('', capital))
          LessonCard(pic, capital, _end('The capital of $country is $capital')),
    ],
    WorksheetKind.letters => [
      for (final MapEntry(key: l, value: (e, w)) in letterWords.entries)
        if (answers.contains(l.toLowerCase()) || onSheet(e, w))
          LessonCard(
            e,
            '$l ${l.toLowerCase()}',
            '$l is for ${w.toLowerCase()}.',
          ),
    ],
    WorksheetKind.abcOrder => [
      for (final chunk in const [
        'ABCD',
        'EFGH',
        'IJKL',
        'MNOP',
        'QRST',
        'UVWXYZ',
      ])
        LessonCard(
          chunk.split('').join(' '),
          '',
          '${chunk.split('').join(', ')}.',
        ),
    ],
    WorksheetKind.soundOut => [
      for (final (e, spelled) in {...soundOutWords, ...blendWords})
        if (onSheet(e, spelled.replaceAll('-', '')))
          LessonCard(
            e,
            spelled.split('-').join(' - '),
            '${spelled.split('-').join(', ')}. ${_capital(spelled.replaceAll('-', ''))}!',
            say:
                '${spelled.split('-').map((p) => letterSounds[p] ?? p).join('… ')}… ${spelled.replaceAll('-', '')}!',
          ),
    ],
    WorksheetKind.rhymes => [
      for (final grp in rhymeGroups)
        if (grp.any((w) => onSheet(w.$1, w.$2)))
          LessonCard(
            grp.take(2).map((w) => w.$1).join(),
            grp.map((w) => w.$2).join(' · '),
            _rhymeSentence([for (final w in grp) w.$2]),
          ),
    ],
    WorksheetKind.wordMatch => [
      for (final (e, w) in listenWords)
        if (onSheet(e, w)) LessonCard(e, w, 'This is ${_a(w).toLowerCase()}.'),
    ],
    WorksheetKind.opposites => [
      for (final (a, ae, b, be) in oppositePairs)
        if (onSheet(ae, a) || onSheet(be, b) || answers.contains(b))
          LessonCard(
            '$ae$be',
            '$a – $b',
            '${_capital(a)} is the opposite of $b.',
          ),
    ],
    WorksheetKind.sightWords => [
      for (final w in {for (final list in sightWordsByLevel.values) ...list})
        if (answers.contains(w)) LessonCard(w, '', _sightSentence(w)),
    ],
    WorksheetKind.syllables => [
      for (final (e, w, n) in {...syllableWords, ...moreSyllableWords})
        if (onSheet(e, w))
          LessonCard(
            e,
            syllableSplits[w] ?? w,
            '${_capital(w)} has $n clap${n == 1 ? '' : 's'}${n > 1 ? ': ${syllableSplits[w] ?? w}' : ''}.',
          ),
    ],
    WorksheetKind.compoundWords => [
      for (final (a, b) in compoundWords)
        if (answers.contains('$a$b') || onSheet('', '$a$b'))
          LessonCard('$a + $b', '$a$b', '${_capital(a)} and $b make $a$b.'),
    ],
    WorksheetKind.wordMeanings => [
      for (final (_, _, w, same, opposite) in meaningWords)
        if (onSheet('', w) || answers.contains(w))
          LessonCard(
            w,
            'same: $same · opposite: $opposite',
            '${_capital(w)} means the same as $same. The opposite is $opposite.',
          ),
    ],
    WorksheetKind.homophones => () {
      final pairs = <String>{};
      return [
        for (final (sentence, answer, wrong) in homophoneSentences)
          if (answers.contains(answer) &&
              pairs.add((['$answer', ...wrong]..sort()).join()))
            LessonCard(
              [answer, ...wrong].join(' · '),
              '',
              sentence.replaceAll('___', answer),
            ),
      ];
    }(),
    WorksheetKind.wordParts => [
      for (final (part, meaning, example, base, prefix) in wordParts)
        if (answers.any(
          (w) =>
              w == (prefix ? '$part-' : '-$part') ||
              w == meaning ||
              w.length > part.length + 2 &&
                  !w.contains(' ') &&
                  (prefix ? w.startsWith(part) : w.endsWith(part)),
        ))
          LessonCard(
            prefix ? '$part-' : '-$part',
            'means "$meaning"',
            prefix
                ? '${_capital(part)} plus $base makes $example. "$part" means $meaning.'
                : '${_capital(base)} plus $part makes $example. "$part" means $meaning.',
          ),
    ],
    WorksheetKind.grammar => [
      const LessonCard(
        '🐶',
        'Noun',
        'A noun names a person, place or thing: dog, school, apple.',
      ),
      const LessonCard(
        '🏃',
        'Verb',
        'A verb is an action word: run, jump, swim.',
      ),
      if (g.atLeast(Level.grade2))
        const LessonCard(
          '🌈',
          'Adjective',
          'An adjective describes a noun: a happy dog, a tall tree.',
        ),
      if (g.atLeast(Level.grade3))
        const LessonCard(
          '⚡',
          'Adverb',
          'An adverb tells how: she ran quickly.',
        ),
      const LessonCard(
        '🍎',
        'Plural',
        'Plural means more than one: one cat, two cats.',
      ),
      const LessonCard(
        '⏪',
        'Past',
        'Past means it already happened: today I jump, yesterday I jumped.',
      ),
    ],
    WorksheetKind.spelling =>
      g.atMost(Level.grade1)
          ? [
              for (final (e, w, _) in pictureWords)
                if (onSheet(e, w) || answers.contains(w.toLowerCase()))
                  LessonCard(
                    e,
                    w,
                    '${_capital(w.toLowerCase())} is spelled ${w.split('').join(', ')}.',
                  ),
            ]
          : [
              const LessonCard(
                'cats',
                'cat + s',
                'To make more than one, we usually add s: one cat, two cats.',
              ),
              const LessonCard(
                'boxes',
                'box + es',
                'After s, x, ch or sh, add es: box, boxes.',
              ),
              const LessonCard(
                'mice',
                'mouse, mice',
                'Some words change: one mouse, two mice.',
              ),
              const LessonCard(
                'running',
                'run + n + ing',
                'Short words like run double the last letter before ing: running.',
              ),
              const LessonCard(
                'making',
                'make − e + ing',
                'Drop the e before ing: make, making.',
              ),
              for (final (_, _, w, _) in spellingWords)
                if (answers.contains(w))
                  LessonCard(
                    w,
                    'tricky word',
                    '${_capital(w)} is spelled ${w.toUpperCase().split('').join(', ')}.',
                  ),
            ].take(lessonPageSize).toList(),
    WorksheetKind.shapes => [
      for (final (shape, color, about) in _shapeFacts)
        if (shape != 'oval' && shape != 'diamond' ||
            g.atLeast(Level.kindergarten))
          LessonCard('fig:$shape.$color.1.s.0.b', _capital(shape), about),
    ],
    _ => _factCards(questions),
  };
  // Lessons need a few cards to be worth a page.
  if (cards.length < 2) return const [];
  if (cards.length > 2 * lessonPageSize) {
    cards.removeRange(2 * lessonPageSize, cards.length);
  }
  final pages = (cards.length / lessonPageSize).ceil().clamp(1, 2);
  final per = (cards.length / pages).ceil();
  return [
    for (var p = 0; p < pages; p++)
      () {
        final page = cards.skip(p * per).take(per).toList();
        return ExampleQuestion(
          title: kind.title + (pages > 1 ? '  (${p + 1} of $pages)' : ''),
          visual: LessonVisual(page),
          steps: [for (final c in page) c.say ?? c.sentence],
        );
      }(),
  ];
}

/// Science and geography fact sheets: one card for each fact asked about.
List<LessonCard> _factCards(List<Question> questions) {
  final ids = <String>[
    for (final q in questions)
      ...switch (q) {
        ChoiceQuestion() => q.facts,
        MatchQuestion() => q.facts,
        _ => const <String>[],
      },
  ];
  final seen = <String>{};
  return [
    for (final id in ids)
      if (seen.add(id) && _allFacts[id] != null) _factCard(_allFacts[id]!),
  ];
}

final _allFacts = {
  for (final bank in [
    myBodyFacts,
    weatherFacts,
    plantFacts,
    lifeCycleFacts,
    matterFacts,
    spaceFacts,
    humanBodyFacts,
    earthFacts,
    forceFacts,
    ecosystemFacts,
    landWaterFacts,
    continentFacts,
    mapFacts,
  ])
    for (final f in bank) '${f.question}|${f.answer}': f,
};

LessonCard _factCard(Fact f) {
  final picture = _isPicture(f.answer);
  final word = picture ? wordFor(f.answer) : f.answer;
  final q = f.question;
  final sentence = q.endsWith('…')
      ? _end(
          '${q.substring(0, q.length - 1).trimRight()} ${_inSentence(word ?? '…')}',
        )
      : word == null
      ? q
      : _end('$q ${_capital(word)}');
  return LessonCard(
    picture ? f.answer : f.emoji,
    word == null ? '' : _capital(word),
    sentence,
  );
}

/// A name for a picture, from the app's word lists ('👀' → 'eyes').
String? wordFor(String emoji) => _words[emoji];

final _words = <String, String>{
  for (final (e, w) in countables) e: w,
  for (final (e, w) in listenWords) e: w,
  for (final (e, w) in pictureSpellWords) e: w.toLowerCase(),
  for (final (e, w) in startPictures) e: w.toLowerCase(),
  for (final t in topics)
    for (final i in t.items) i.emoji: i.name.toLowerCase(),
  for (final (e, w, _) in sinkFloatItems) e: w,
  for (final (e, w, _) in livingItems) e: w,
  for (final (e, w) in bodyParts) e: w,
  ..._extraWords,
};

/// Pictures used as answers in fact banks that the word lists don't name.
const _extraWords = {
  '👀': 'eyes',
  '👂': 'ears',
  '👃': 'nose',
  '👅': 'tongue',
  '🦶': 'feet',
  '✋': 'hands',
  '🦷': 'teeth',
  '🧠': 'brain',
  '🥦': 'vegetables',
  '🧼': 'soap',
  '🌙': 'at night',
  '🥛': 'milk',
  '🌧️': 'rain',
  '☀️': 'sun',
  '❄️': 'snow',
  '☂️': 'an umbrella',
  '🧤': 'gloves',
  '🌈': 'a rainbow',
  '🏝️': 'an island',
  '🏜️': 'a desert',
  '🏔️': 'a mountain',
  '🌊': 'the ocean',
  '🌋': 'a volcano',
  '🌲': 'a forest',
  '🏞️': 'a river',
  '🧭': 'a compass',
};

/// Ends a sentence with one full stop ("Washington, D.C.").
String _end(String s) => s.endsWith('.') ? s : '$s.';

/// Names (planets, continents, oceans) keep their capital letter mid-sentence.
final _proper = RegExp(
  r'^(Mercury|Venus|Earth|Mars|Jupiter|Saturn|Uranus|Neptune|Sun|Moon|'
  r'Africa|Asia|Europe|Australia|Antarctica|North|South|Pacific|Atlantic|'
  r'Indian|Arctic|Southern|Equator|[A-Z]{2,})',
);

String _inSentence(String word) => _proper.hasMatch(word) || word.isEmpty
    ? word
    : word[0].toLowerCase() + word.substring(1);

bool _isPicture(String s) => !RegExp(r'[A-Za-z0-9]').hasMatch(s);

const _shapeFacts = [
  ('circle', 0, 'A circle is round. It has no corners.'),
  ('square', 1, 'A square has 4 sides, all the same, and 4 corners.'),
  ('triangle', 2, 'A triangle has 3 sides and 3 corners.'),
  ('rectangle', 3, 'A rectangle has 4 sides: 2 long and 2 short.'),
  ('star', 4, 'A star has 5 points.'),
  ('heart', 0, 'A heart is the shape of love.'),
  ('oval', 1, 'An oval is like a stretched circle, the shape of an egg.'),
  ('diamond', 2, 'A diamond has 4 sides and stands on a corner.'),
];

/// "Cat, hat and bat rhyme. They all end in -at."
String _rhymeSentence(List<String> words) {
  var end = words.first;
  while (end.isNotEmpty && !words.every((w) => w.endsWith(end))) {
    end = end.substring(1);
  }
  final list = words.length == 1
      ? words.first
      : '${words.take(words.length - 1).join(', ')} and ${words.last}';
  final all = words.length == 2 ? 'both' : 'all';
  return '${_capital(list)} rhyme.'
      '${end.length >= 2 ? ' They $all end in "$end".' : ''}';
}

/// A sight word in a sentence ("Look at the cat!"), or on its own.
String _sightSentence(String w) {
  for (final (_, s, answer, _) in sightSentences) {
    if (answer == w) return s.replaceAll('___', w);
  }
  return 'This word is "$w".';
}

String _capital(String s) =>
    s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

/// "A rabbit", "An elephant".
String _a(String noun) {
  final n = noun.toLowerCase();
  return '${RegExp(r'^[aeiou]').hasMatch(n) ? 'An' : 'A'} $n';
}

/// "the United States", "India".
String _the(String country) =>
    country.startsWith('United') ? 'the $country' : country;

String _inHome(String home) => switch (home) {
  'Ocean' => 'in the ocean',
  'Ice' => 'on the ice',
  'Desert' => 'in the desert',
  'Jungle' => 'in the jungle',
  _ => 'in ${_a(home).toLowerCase()}',
};
