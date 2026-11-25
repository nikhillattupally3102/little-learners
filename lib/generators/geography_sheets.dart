import '../content/geography.dart';
import '../content/topics.dart';
import '../models/models.dart';
import 'gen.dart';
import 'science_sheets.dart' show facts;

List<Question> landWater(Gen g) => facts(g, landWaterFacts);

List<Question> continents(Gen g) => facts(g, continentFacts);

List<Question> mapSkills(Gen g) => facts(g, mapFacts);

/// Countries whose flags we have drawn (from the Countries learning topic).
List<TopicItem> get _flagCountries =>
    topics.firstWhere((t) => t.id == 'countries').items;

List<Question> flags(Gen g) {
  final countries = _flagCountries;
  return g.mix(g.count, [
    // Which flag belongs to this country?
    () {
      final c = g.one(countries);
      return g.choice(
        prompt: 'Which flag is the flag of ${c.name}?',
        visual: const EmojiVisual('🚩'),
        answer: c.emoji,
        wrong: countries.map((x) => x.emoji),
        count: 3,
      );
    },
    // Whose flag is this?
    () {
      final c = g.one(countries);
      return g.choice(
        prompt: 'Which country has this flag?',
        visual: EmojiVisual(c.emoji),
        answer: c.name,
        wrong: countries.map((x) => x.name),
        count: 3,
      );
    },
    // A clue about the country, then pick its flag.
    if (g.atLeast(Level.grade2))
      () {
        final c = g.one(countries);
        return g.choice(
          prompt: c.fact.replaceAll(RegExp(r'^My '), 'Its '),
          visual: const EmojiVisual('🗺️'),
          answer: c.emoji,
          wrong: countries.map((x) => x.emoji),
          count: 3,
          speech: ['Which country is this? ${c.fact}'],
        );
      },
  ]);
}

List<Question> capitals(Gen g) {
  // Grade 3 sticks to the countries from the learning topic; later grades
  // get the whole list.
  final pool = g.atMost(Level.grade3)
      ? capitalCities.where((c) => c.$2 != '🗺️').toList()
      : capitalCities;
  return g.mix(g.count, [
    () {
      final c = g.one(pool);
      return g.choice(
        prompt: 'What is the capital of ${c.$1}?',
        visual: EmojiVisual(c.$2),
        answer: c.$3,
        wrong: pool.map((x) => x.$3),
        count: g.atLeast(Level.grade4) ? 4 : 3,
      );
    },
    () {
      final c = g.one(pool);
      final name = c.$1.replaceFirst('the ', 'The ');
      return g.choice(
        prompt: '${c.$3} is the capital of…',
        visual: const EmojiVisual('🏛️'),
        answer: name,
        wrong: pool.map((x) => x.$1.replaceFirst('the ', 'The ')),
        count: 3,
      );
    },
    () {
      final c = g.one(pool);
      final right = g.chance(.5);
      final shown = right
          ? c.$3
          : g.one([
              for (final x in pool)
                if (x.$3 != c.$3) x.$3,
            ]);
      return g.choice(
        prompt: 'Is $shown the capital of ${c.$1}?',
        visual: EmojiVisual(c.$2),
        answer: right ? 'Yes ✅' : 'No ❌',
        wrong: const ['Yes ✅', 'No ❌'],
      );
    },
  ]);
}
