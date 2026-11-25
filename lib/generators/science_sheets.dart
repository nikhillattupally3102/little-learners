import '../content/science.dart';
import '../models/models.dart';
import 'gen.dart';

// Multi-format science worksheets.

const _yesNo = ['Yes ✅', 'No ❌'];

/// Which topic each fact bank covers, and whether it is life or physical science
/// (used so "which one is NOT about…" never picks an answer that could fit both).
final _topics = <(List<Fact>, String, bool)>[
  (myBodyFacts, 'your body', true),
  (weatherFacts, 'weather', false),
  (plantFacts, 'plants', true),
  (lifeCycleFacts, 'life cycles', true),
  (matterFacts, 'matter', false),
  (spaceFacts, 'space', false),
  (humanBodyFacts, 'the human body', true),
  (earthFacts, 'Planet Earth', false),
  (forceFacts, 'forces and energy', false),
  (ecosystemFacts, 'ecosystems', true),
];

/// Facts written for this level, topped up with the nearest-level facts so
/// every question on the sheet can be about a different fact.
List<Fact> _pool(Gen g, List<Fact> bank) {
  final pool = bank.where((f) => f.suits(g.level)).toList();
  final enough = g.count + 5;
  if (pool.length >= enough) return pool;
  int distance(Fact f) => g.level.index < f.min.index
      ? f.min.index - g.level.index
      : g.level.index - f.max.index;
  final rest = bank.where((f) => !pool.contains(f)).toList()
    ..sort((a, b) => distance(a) - distance(b));
  return [...pool, ...rest.take(enough - pool.length)];
}

/// Which fact a question is about (some questions, like "Which continent is
/// in colour?", are asked about several things).
String _factId(Fact f) => '${f.question}|${f.answer}';

/// Five questions from a fact bank, mixing several different task types.
List<Question> facts(Gen g, List<Fact> bank) {
  final pool = _pool(g, bank);
  final topic = _topics.where((t) => identical(t.$1, bank)).firstOrNull;
  final fillable = pool.where((f) => f.question.endsWith('…')).toList();

  return g.mix(g.count, [
    // Classic multiple choice.
    () {
      final f = g.one(pool);
      return g.choice(
        prompt: f.question,
        visual: EmojiVisual(f.emoji),
        answer: f.answer,
        wrong: f.wrong,
        facts: [_factId(f)],
      );
    },
    // Is this answer right?
    () {
      final f = g.one(pool);
      final right = g.chance(.5);
      final shown = right ? f.answer : g.one(f.wrong);
      final text =
          '${f.question.replaceAll('…', '')} ${f.question.endsWith('?') ? '→ ' : ''}$shown';
      return g.choice(
        prompt: 'Is this correct?',
        visual: TextVisual(text, emoji: f.emoji),
        answer: right ? _yesNo[0] : _yesNo[1],
        wrong: _yesNo,
        speech: ['${f.question.replaceAll('…', '')} $shown. Is this correct?'],
        facts: [_factId(f)],
      );
    },
    // Fill in the blank.
    if (fillable.isNotEmpty)
      () {
        final f = g.one(fillable);
        return g.choice(
          prompt: 'Fill in the blank!',
          visual: TextVisual(
            '${f.question.replaceAll('…', '')} ______.',
            emoji: f.emoji,
          ),
          answer: f.answer,
          wrong: f.wrong,
          speech: ['${f.question.replaceAll('…', '')} blank.'],
          facts: [_factId(f)],
        );
      },
    // Which one is NOT about this topic?
    if (topic != null)
      () {
        final mine = {for (final f in pool) f.answer}.toList();
        final sameSide = {
          for (final t in _topics)
            if (t.$3 == topic.$3)
              for (final f in t.$1) f.answer,
        };
        final intruders = [
          for (final t in _topics)
            if (t.$3 != topic.$3)
              for (final f in t.$1)
                if (!sameSide.contains(f.answer)) f.answer,
        ];
        return g.choice(
          prompt: 'Which one is NOT about ${topic.$2}?',
          visual: EmojiVisual(bank.first.emoji),
          answer: g.one(intruders),
          wrong: mine,
          count: 4,
        );
      },
    // Match words to pictures (things not asked about yet on this sheet).
    () {
      final seen = <String>{};
      final unique = [
        for (final f in [
          ...([...pool]..shuffle(g.r)),
          ...([...bank]..shuffle(g.r)),
        ])
          if (f.answer.length <= 16 &&
              g.isFresh([f.answer, f.emoji]) &&
              seen.add(f.emoji) &&
              seen.add('a:${f.answer}'))
            f,
      ];
      if (unique.length < 3) {
        final f = g.one(pool);
        return g.choice(
          prompt: f.question,
          visual: EmojiVisual(f.emoji),
          answer: f.answer,
          wrong: f.wrong,
          facts: [_factId(f)],
        );
      }
      final chosen = unique.take(g.matchSize(unique.length)).toList();
      return g.match(
        'Match each answer to its picture!',
        [for (final f in chosen) (MatchItem(f.answer), MatchItem('', f.emoji))],
        facts: [for (final f in chosen) _factId(f)],
      );
    },
  ]);
}

// ------------------------------------------------------------ young kids

const _farm = ['🐮', '🐷', '🐑', '🐴', '🐓'];
const _wild = ['🦁', '🦒', '🐘', '🐯', '🐻'];

List<Question> animalSoundsSheet(Gen g) {
  final n = g.level == Level.age2 ? 2 : 3;
  return g.mix(g.count, [
    () {
      final (emoji, _, sound) = g.one(animalSounds);
      return g.choice(
        prompt: 'Who says "$sound"?',
        visual: TextVisual('"${titleCase(sound)}!"', emoji: '🔊'),
        answer: emoji,
        wrong: animalSounds.map((a) => a.$1),
        count: n,
        speech: ['Who says $sound?', '$sound!'],
      );
    },
    () {
      final (emoji, animal, sound) = g.one(animalSounds);
      final other = g.one(animalSounds.where((a) => a.$3 != sound).toList()).$3;
      return g.choice(
        prompt: 'What does the $animal say?',
        visual: EmojiVisual(emoji),
        answer: titleCase(sound),
        wrong: [titleCase(other)],
        speech: ['What does the $animal say? $sound, or $other?'],
      );
    },
    () {
      final (emoji, animal, _) = g.one(animalSounds);
      return g.choice(
        prompt: 'Find the $animal!',
        visual: const ListenVisual(),
        answer: emoji,
        wrong: animalSounds.map((a) => a.$1),
        count: n,
      );
    },
    () {
      final farm = g.chance(.5);
      return g.choice(
        prompt: farm
            ? 'Which animal lives on a farm?'
            : 'Which animal lives in the wild?',
        visual: EmojiVisual(farm ? '🚜' : '🌴'),
        answer: g.one(farm ? _farm : _wild),
        wrong: farm ? _wild : _farm,
        count: n,
      );
    },
  ]);
}

/// "in a nest", "in the ocean", "on the ice".
String _inHome(String home) {
  final h = home.toLowerCase();
  return switch (h) {
    'ice' => 'on the ice',
    'ocean' || 'desert' || 'jungle' => 'in the $h',
    _ => 'in a $h',
  };
}

List<Question> animalHomesSheet(Gen g) {
  final match = g.keep(
    g.match('Match each animal to its home!', [
      for (final (e, animal, home, he) in g.pick(
        animalHomes,
        g.matchSize(animalHomes.length),
      ))
        (MatchItem(animal, e), MatchItem(home, he)),
    ]),
  );
  final choices = g.mix(g.count - 1, [
    () {
      final (e, animal, home, he) = g.one(animalHomes);
      return g.choice(
        prompt: 'Where does a ${animal.toLowerCase()} live?',
        visual: EmojiVisual(e),
        answer: '$he $home',
        wrong: [
          for (final h in animalHomes)
            if (h.$3 != home) '${h.$4} ${h.$3}',
        ],
        count: 3,
      );
    },
    () {
      final (e, _, home, he) = g.one(animalHomes);
      return g.choice(
        prompt: 'Who lives ${_inHome(home)}?',
        visual: EmojiVisual(he, home),
        answer: e,
        wrong: [
          for (final h in animalHomes)
            if (h.$3 != home) h.$1,
        ],
        count: 3,
      );
    },
    () {
      final (e, animal, home, he) = g.one(animalHomes);
      final right = g.chance(.5);
      final shown = right
          ? (home, he)
          : g.one([
              for (final h in animalHomes)
                if (h.$3 != home) (h.$3, h.$4),
            ]);
      return g.choice(
        prompt: 'Does a ${animal.toLowerCase()} live here?',
        visual: TextVisual('$e → ${shown.$2} ${shown.$1}'),
        answer: right ? _yesNo[0] : _yesNo[1],
        wrong: _yesNo,
        speech: ['Does a ${animal.toLowerCase()} live ${_inHome(shown.$1)}?'],
      );
    },
  ]);
  return [...choices.take(2), match, ...choices.skip(2)];
}

List<Question> babyAnimalsSheet(Gen g) {
  final match = g.keep(
    g.match('Match each animal to its baby!', [
      for (final (e, animal, baby) in g.pick(
        babyAnimals,
        g.matchSize(babyAnimals.length),
      ))
        (MatchItem(animal, e), MatchItem(baby)),
    ]),
  );
  final choices = g.mix(g.count - 1, [
    () {
      final (e, animal, baby) = g.one(babyAnimals);
      return g.choice(
        prompt: 'A baby ${animal.toLowerCase()} is called a…',
        visual: EmojiVisual(e),
        answer: baby,
        wrong: babyAnimals.map((b) => b.$3),
        count: 3,
      );
    },
    () {
      final (_, animal, baby) = g.one(babyAnimals);
      return g.choice(
        prompt: 'Whose baby is a ${baby.toLowerCase()}?',
        visual: TextVisual(baby, emoji: '🍼'),
        answer: babyAnimals.firstWhere((b) => b.$2 == animal).$1,
        wrong: babyAnimals.map((b) => b.$1),
        count: 3,
      );
    },
    () {
      final (e, animal, baby) = g.one(babyAnimals);
      final right = g.chance(.5);
      final shown = right
          ? baby
          : g.one([
              for (final b in babyAnimals)
                if (b.$3 != baby) b.$3,
            ]);
      return g.choice(
        prompt:
            'Is a baby ${animal.toLowerCase()} called a ${shown.toLowerCase()}?',
        visual: EmojiVisual(e, shown),
        answer: right ? _yesNo[0] : _yesNo[1],
        wrong: _yesNo,
      );
    },
  ]);
  return [...choices.take(2), match, ...choices.skip(2)];
}

List<Question> sinkFloat(Gen g) {
  final floats = [
    for (final i in sinkFloatItems)
      if (i.$3) i,
  ];
  final sinks = [
    for (final i in sinkFloatItems)
      if (!i.$3) i,
  ];
  return g.mix(g.count, [
    () {
      final (emoji, name, f) = g.one(sinkFloatItems);
      return g.choice(
        prompt: 'Will the $name sink or float?',
        visual: EmojiVisual(emoji, name),
        answer: f ? 'Float' : 'Sink',
        wrong: const ['Sink', 'Float'],
      );
    },
    () => g.choice(
      prompt: 'Which one floats?',
      visual: const EmojiVisual('🛁'),
      answer: g.one(floats).$1,
      wrong: sinks.map((s) => s.$1),
      count: 3,
    ),
    () => g.choice(
      prompt: 'Which one sinks?',
      visual: const EmojiVisual('🌊'),
      answer: g.one(sinks).$1,
      wrong: floats.map((s) => s.$1),
      count: 3,
    ),
    if (g.atLeast(Level.kindergarten))
      () {
        final (emoji, name, f) = g.one(sinkFloatItems);
        final claim = g.chance(.5);
        return g.choice(
          prompt: 'A $name ${claim ? 'floats' : 'sinks'}. Is that true?',
          visual: EmojiVisual(emoji),
          answer: claim == f ? _yesNo[0] : _yesNo[1],
          wrong: _yesNo,
        );
      },
  ]);
}

const _livingFacts = [
  (
    'What do all living things need?',
    '💧',
    'Food and water',
    ['Batteries', 'Paint'],
  ),
  (
    'Living things can…',
    '🌱',
    'Grow and change',
    ['Never change', 'Run on gas'],
  ),
  (
    'Which living thing makes its own food from sunlight?',
    '☀️',
    'A plant',
    ['A rock', 'A car'],
  ),
  (
    'Which of these is NOT something living things do?',
    '🔍',
    'Need charging',
    ['Breathe', 'Grow'],
  ),
];

List<Question> livingThings(Gen g) {
  final living = [
    for (final i in livingItems)
      if (i.$3) i,
  ];
  final notLiving = [
    for (final i in livingItems)
      if (!i.$3) i,
  ];
  return g.mix(g.count, [
    () {
      final (emoji, name, alive) = g.one(livingItems);
      return g.choice(
        prompt: 'Is a $name living or not living?',
        visual: EmojiVisual(emoji, name),
        answer: alive ? 'Living' : 'Not living',
        wrong: const ['Living', 'Not living'],
      );
    },
    () => g.choice(
      prompt: 'Which one is living?',
      visual: const EmojiVisual('🌱'),
      answer: g.one(living).$1,
      wrong: notLiving.map((i) => i.$1),
      count: 3,
    ),
    () => g.choice(
      prompt: 'Which one is NOT living?',
      visual: const EmojiVisual('🧱'),
      answer: g.one(notLiving).$1,
      wrong: living.map((i) => i.$1),
      count: 3,
    ),
    () {
      final (q, emoji, answer, wrong) = g.one(_livingFacts);
      return g.choice(
        prompt: q,
        visual: EmojiVisual(emoji),
        answer: answer,
        wrong: wrong,
      );
    },
  ]);
}

const _traits = {
  'Bird': 'feathers and wings',
  'Fish': 'gills and fins',
  'Mammal': 'fur and drinks milk as a baby',
  'Insect': 'six legs',
  'Reptile': 'dry, scaly skin',
  'Amphibian': 'smooth, wet skin',
};

List<Question> animalGroups(Gen g) {
  final groups = g.level == Level.grade1
      ? ['Mammal', 'Bird', 'Fish', 'Reptile', 'Insect']
      : ['Mammal', 'Bird', 'Fish', 'Reptile', 'Amphibian', 'Insect'];
  final pool = animalGroupItems.where((a) => groups.contains(a.$3)).toList();
  final n = g.level == Level.grade1 ? 3 : 4;
  return g.mix(g.count, [
    () {
      final (emoji, name, group) = g.one(pool);
      return g.choice(
        prompt: 'What kind of animal is a $name?',
        visual: EmojiVisual(emoji, name),
        answer: group,
        wrong: groups,
        count: n,
      );
    },
    () {
      final group = g.one(groups);
      return g.choice(
        prompt:
            'Which one is ${group == 'Insect' || group == 'Amphibian' ? 'an' : 'a'} ${group.toLowerCase()}?',
        visual: const EmojiVisual('🐾'),
        answer: g.one(pool.where((a) => a.$3 == group).toList()).$1,
        wrong: [
          for (final a in pool)
            if (a.$3 != group) a.$1,
        ],
        count: n,
      );
    },
    () {
      final group = g.one(groups);
      return g.choice(
        prompt: 'Which animal has ${_traits[group]}?',
        visual: const EmojiVisual('🔎'),
        answer: g.one(pool.where((a) => a.$3 == group).toList()).$1,
        wrong: [
          for (final a in pool)
            if (a.$3 != group) a.$1,
        ],
        count: n,
      );
    },
    () {
      final group = g.one(groups);
      final members = pool.where((a) => a.$3 == group).toList();
      if (members.length < 2) {
        final (emoji, name, grp) = g.one(pool);
        return g.choice(
          prompt: 'What kind of animal is a $name?',
          visual: EmojiVisual(emoji, name),
          answer: grp,
          wrong: groups,
          count: n,
        );
      }
      return g.choice(
        prompt:
            'Which one is NOT ${group == 'Insect' || group == 'Amphibian' ? 'an' : 'a'} ${group.toLowerCase()}?',
        visual: const EmojiVisual('🙃'),
        answer: g.one(pool.where((a) => a.$3 != group).toList()).$1,
        wrong: members.map((a) => a.$1),
        count: 3,
      );
    },
  ]);
}
