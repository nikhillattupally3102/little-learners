import '../content/geography.dart';
import '../content/reading.dart';
import '../content/science.dart';
import '../content/topics.dart';
import '../models/models.dart';
import 'gen.dart';
import 'math_formats.dart' show countables;

// "Let's learn!" pages: before a science or geography sheet, picture cards
// teach exactly the things its questions ask about. They are shown the first
// time a child gets that kind of sheet, and again after a break (see
// Progress.needsLesson).

/// Cards per page: fits an iPad or laptop screen without scrolling.
const lessonPageSize = 6;

/// The lesson for a sheet of [kind] with these [questions] (empty for kinds
/// that practise a skill rather than teach facts).
List<ExampleQuestion> lessonFor(WorksheetKind kind, List<Question> questions) {
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
          steps: [for (final c in page) c.sentence],
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
