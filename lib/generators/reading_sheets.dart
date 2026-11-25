import '../content/daily_focus.dart';
import '../content/reading.dart';
import '../models/models.dart';
import 'gen.dart';

// Multi-format reading worksheets: each worksheet rotates through several
// different kinds of reading task.

const _alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

/// Items whose level is at or below [g]'s level, preferring the closest level.
List<T> _upTo<T>(Gen g, List<T> items, Level Function(T) levelOf) {
  final exact = items.where((i) => levelOf(i) == g.level).toList();
  final below = items.where((i) => levelOf(i).atMost(g.level)).toList();
  return exact.length >= 3
      ? [...exact, ...below.take(exact.length)]
      : (below.isNotEmpty ? below : items);
}

List<T> _inRange<T>(
  Gen g,
  List<T> items,
  Level Function(T) lo,
  Level Function(T) hi,
) {
  final fit = items
      .where((i) => g.level.atLeast(lo(i)) && g.level.atMost(hi(i)))
      .toList();
  return fit.isNotEmpty ? fit : items;
}

String _scramble(Gen g, String word) {
  for (var i = 0; i < 10; i++) {
    final s = (word.split('')..shuffle(g.r)).join();
    if (s != word) return s;
  }
  return word.split('').reversed.join();
}

// ----------------------------------------------------------- listen & tap

List<Question> listen(Gen g) {
  final n = g.level == Level.age2 ? 2 : 3;
  return g.mix(g.count, [
    () {
      final (emoji, word) = g.one(listenWords);
      return g.choice(
        prompt: 'Find the $word!',
        visual: const ListenVisual(),
        answer: emoji,
        wrong: listenWords.map((w) => w.$1),
        count: n,
      );
    },
    () {
      final (emoji, sound) = g.one(animalSoundWords);
      return g.choice(
        prompt: 'Who says "$sound"?',
        visual: const ListenVisual(),
        answer: emoji,
        wrong: animalSoundWords.map((a) => a.$1),
        count: n,
        speech: ['Who says $sound? $sound!'],
      );
    },
    () {
      final (emoji, color) = g.one(colorHearts);
      return g.choice(
        prompt: 'Find the $color heart!',
        visual: const ListenVisual(),
        answer: emoji,
        wrong: colorHearts.map((c) => c.$1),
        count: n,
      );
    },
    () {
      final (emoji, part) = g.one(bodyParts);
      return g.choice(
        prompt: 'Find the $part!',
        visual: const ListenVisual(),
        answer: emoji,
        wrong: bodyParts.map((b) => b.$1),
        count: n,
      );
    },
    () {
      final (animal, name, food) = g.one(animalFoods);
      return g.choice(
        prompt: 'What does the $name eat?',
        visual: EmojiVisual(animal),
        answer: food,
        wrong: animalFoods.map((a) => a.$3),
        count: n,
      );
    },
    () => g.choice(
      prompt: 'Which one can fly?',
      visual: const EmojiVisual('☁️'),
      answer: g.one(thingsThatFly),
      wrong: thingsThatDontFly,
      count: n,
    ),
    if (g.level == Level.age3)
      () {
        final letter = g.one('ABCDEFGHIJKLMNOPRSTUVWZ'.split(''));
        return g.choice(
          prompt: 'Find the letter $letter!',
          visual: const ListenVisual(),
          answer: letter,
          wrong: _alphabet.split(''),
          count: 3,
        );
      },
  ]);
}

// ---------------------------------------------------------------- letters

List<Question> letters(Gen g) {
  final n = g.level == Level.preK ? 3 : 4;
  return g.mix(g.count, [
    () {
      final letter = g.one(letterWords.keys.where((l) => l != 'X').toList());
      final (emoji, word) = letterWords[letter]!;
      return g.choice(
        prompt: 'What does ${titleCase(word)} start with?',
        visual: WordPictureVisual(emoji, word, 0),
        answer: letter,
        wrong: _alphabet.split(''),
        count: n,
      );
    },
    () {
      final (emoji, word) = g.one(startPictures);
      final letter = word[0];
      return g.choice(
        prompt: 'Which picture starts with $letter?',
        visual: TextVisual(letter),
        answer: emoji,
        wrong: [
          for (final p in startPictures)
            if (p.$2[0] != letter) p.$1,
        ],
        count: n,
      );
    },
    () {
      final l = g.one(clearSoundLetters);
      final sound = letterSounds[l]!;
      return g.choice(
        prompt: 'Which letter makes this sound?',
        visual: const ListenVisual(),
        answer: l.toUpperCase(),
        wrong: clearSoundLetters.map((x) => x.toUpperCase()),
        count: n,
        speech: ['Which letter makes this sound?', '$sound… $sound'],
      );
    },
    if (g.level == Level.kindergarten)
      () {
        final l = g.one(_alphabet.split(''));
        return g.choice(
          prompt: 'Find the lowercase partner of $l!',
          visual: TextVisual(l),
          answer: l.toLowerCase(),
          wrong: _alphabet.toLowerCase().split(''),
          count: 4,
        );
      },
    if (g.level == Level.kindergarten)
      () {
        final (emoji, word) = g.one(pictureSpellWords);
        final last = word[word.length - 1];
        return g.choice(
          prompt: 'What sound does ${word.toLowerCase()} end with?',
          visual: EmojiVisual(emoji, word.toLowerCase()),
          answer: last,
          wrong: _alphabet.split(''),
          count: 4,
        );
      },
  ]);
}

List<Question> abcOrder(Gen g) => g.mix(g.count, [
  () {
    final i = g.between(0, 24);
    return g.choice(
      prompt: 'Which letter comes after ${_alphabet[i]}?',
      visual: TextVisual(_alphabet[i]),
      answer: _alphabet[i + 1],
      wrong: {
        _alphabet[i],
        if (i > 0) _alphabet[i - 1],
        _alphabet[(i + 5) % 26],
      },
      count: 3,
    );
  },
  if (g.atLeast(Level.kindergarten))
    () {
      final i = g.between(1, 25);
      return g.choice(
        prompt: 'What comes just before ${_alphabet[i]}?',
        visual: TextVisual(_alphabet[i]),
        answer: _alphabet[i - 1],
        wrong: {
          _alphabet[i],
          if (i < 25) _alphabet[i + 1],
          _alphabet[(i + 7) % 26],
        },
        count: 3,
      );
    },
  () {
    final i = g.between(1, 24);
    final seq = [_alphabet[i - 1], _alphabet[i], _alphabet[i + 1]];
    final blank = g.r.nextInt(3);
    return g.choice(
      prompt: 'Which letter is missing?',
      visual: PatternVisual([
        for (var k = 0; k < 3; k++) k == blank ? '?' : seq[k],
      ]),
      answer: seq[blank],
      wrong: _alphabet.split(''),
      count: 3,
    );
  },
  () {
    final picks = g.pick(_alphabet.split(''), 3)..sort();
    return g.choice(
      prompt: 'Which letter comes first in the alphabet?',
      visual: const EmojiVisual('🔤'),
      answer: picks.first,
      wrong: picks,
    );
  },
  if (g.level == Level.grade1)
    () {
      final words = g.pick(g.one(sameStartWords), 3);
      final sorted = [...words]..sort();
      return g.choice(
        prompt:
            'These start with the same letter. Which comes first in ABC order?',
        visual: const EmojiVisual('🚂'),
        answer: sorted.first,
        wrong: words,
      );
    },
]);

// ------------------------------------------------------------- phonics

List<Question> soundOut(Gen g, {PreKWords? today}) {
  if (today != null) return _preKWords(g, today);
  final pool = g.level == Level.grade1
      ? [...soundOutWords, ...blendWords]
      : soundOutWords;
  return g.mix(g.count, [
    () {
      final (emoji, spelled) = g.one(pool);
      final parts = spelled.split('-');
      return g.choice(
        prompt: 'Sound it out!',
        visual: SoundOutVisual(parts),
        answer: emoji,
        wrong: pool.map((w) => w.$1),
        count: 3,
        speech: [
          for (final p in parts) letterSounds[p] ?? p,
          'What word is that? Tap the picture!',
        ],
      );
    },
    () {
      final (emoji, spelled) = g.one(pool);
      return g.choice(
        prompt: 'Which word matches the picture?',
        visual: EmojiVisual(emoji),
        answer: spelled.replaceAll('-', ''),
        wrong: pool.map((w) => w.$2.replaceAll('-', '')),
        count: 3,
      );
    },
    () {
      final (emoji, spelled) = g.one(soundOutWords);
      final word = spelled.replaceAll('-', '').toUpperCase();
      return g.choice(
        prompt: 'What is the middle sound?',
        visual: WordPictureVisual(emoji, word, 1),
        answer: word[1],
        wrong: const ['A', 'E', 'I', 'O', 'U'],
        count: 3,
      );
    },
    () {
      final families = g.pick(wordFamilies, 2);
      final ending = families[0].first.substring(1);
      return g.choice(
        prompt: 'Which word is in the -$ending family?',
        visual: TextVisual('-$ending', emoji: '🏠'),
        answer: g.one(families[0]),
        wrong: families[1],
        count: 3,
      );
    },
    if (g.atLeast(Level.kindergarten))
      () => g.choice(
        prompt: 'Which one is a real word?',
        visual: const EmojiVisual('🔍'),
        answer: g.one(pool).$2.replaceAll('-', ''),
        wrong: nonsenseWords,
        count: 3,
      ),
  ]);
}

List<Question> rhymes(Gen g) {
  final useWords = g.level == Level.grade1;
  String show((String, String) w) => useWords ? w.$2 : w.$1;
  List<(String, String)> others(List<(String, String)> group) => [
    for (final grp in rhymeGroups)
      if (grp != group) ...grp,
  ];
  return g.mix(g.count, [
    () {
      final group = g.one(rhymeGroups);
      final pair = g.pick(group, 2);
      return g.choice(
        prompt: 'Which one rhymes with ${pair[0].$2}?',
        visual: EmojiVisual(pair[0].$1, pair[0].$2),
        answer: show(pair[1]),
        wrong: [for (final w in g.pick(others(group), 2)) show(w)],
      );
    },
    () {
      final group = g.one(rhymeGroups.where((grp) => grp.length >= 3).toList());
      final odd = g.one(others(group));
      final rhyming = g.pick(group, 2);
      return g.choice(
        prompt: 'Which one does NOT rhyme?',
        visual: const EmojiVisual('🎵'),
        answer: show(odd),
        wrong: [for (final w in rhyming) show(w)],
        speech: [
          'Which one does not rhyme? ${[...rhyming.map((w) => w.$2), odd.$2].join(', ')}',
        ],
      );
    },
    () {
      final group = g.one(rhymeGroups);
      final a = group.first;
      final rhyme = g.chance(.5);
      final b = rhyme ? group.last : g.one(others(group));
      return g.choice(
        prompt: 'Do ${a.$2} and ${b.$2} rhyme?',
        visual: TextVisual('${a.$1}  ${b.$1}'),
        answer: rhyme ? 'Yes 👍' : 'No 👎',
        wrong: const ['Yes 👍', 'No 👎'],
        speech: ['Do ${a.$2} and ${b.$2} rhyme?'],
      );
    },
    () {
      final (sentence, emoji, word) = g.one(rhymeSentences);
      return g.choice(
        prompt: 'Finish the rhyme!',
        visual: TextVisual(sentence),
        answer: useWords ? word : emoji,
        wrong: [
          for (final s in rhymeSentences)
            if (s.$3 != word) useWords ? s.$3 : s.$2,
        ],
        count: 3,
        speech: [sentence.replaceAll('___', 'blank')],
      );
    },
  ]);
}

// -------------------------------------------------------------- vocabulary

List<Question> wordMatch(Gen g) {
  const pairs = Gen.matchCount;
  final pool = listenWords
      .where((w) => w.$2.length <= (g.level == Level.preK ? 4 : 8))
      .toList();
  final match = g.keep(
    g.match('Match each picture to its word!', [
      for (final (emoji, word) in g.pick(pool, pairs))
        (MatchItem('', emoji), MatchItem(word)),
    ]),
  );
  final choices = g.mix(g.count - 1, [
    () {
      final (emoji, word) = g.one(pool);
      return g.choice(
        prompt: 'Which word goes with this picture?',
        visual: EmojiVisual(emoji),
        answer: word,
        wrong: pool.map((w) => w.$2),
        count: 3,
      );
    },
    () {
      final (emoji, word) = g.one(pool);
      return g.choice(
        prompt: 'Which picture shows "$word"?',
        visual: TextVisual(word),
        answer: emoji,
        wrong: pool.map((w) => w.$1),
        count: 3,
      );
    },
    () {
      final cats = g.pick(wordCategories.keys, 2);
      return g.choice(
        prompt: 'Which word is ${cats[0]}?',
        visual: const EmojiVisual('🏷️'),
        answer: g.one(wordCategories[cats[0]]!),
        wrong: wordCategories[cats[1]]!,
        count: 3,
      );
    },
  ]);
  return [...choices.take(2), match, ...choices.skip(2)];
}

List<Question> opposites(Gen g) {
  final pictures = g.atMost(Level.kindergarten);
  const pairs = Gen.matchCount;
  final match = g.keep(
    g.match('Match the opposites!', [
      for (final (a, ae, b, be) in g.pick(oppositePairs, pairs))
        (
          MatchItem(a, pictures ? ae : null),
          MatchItem(b, pictures ? be : null),
        ),
    ]),
  );
  final choices = g.mix(g.count - 1, [
    () {
      final (a, ae, b, _) = g.one(
        oppositePairs.where((p) => clearOpposites.contains(p.$1)).toList(),
      );
      return g.choice(
        prompt: 'What is the opposite of "$a"?',
        visual: EmojiVisual(ae, a),
        answer: b,
        wrong: [
          for (final p in oppositePairs)
            if (p.$3 != b) p.$3,
        ],
        count: 3,
      );
    },
    () {
      final (sentence, answer, wrong) = g.one(oppositeSentences);
      return g.choice(
        prompt: 'Which word fits?',
        visual: TextVisual(sentence),
        answer: answer,
        wrong: wrong,
        speech: [sentence.replaceAll('___', 'blank')],
      );
    },
    () {
      final p = g.one(oppositePairs);
      final wrongPairs = [
        for (final q in g.pick(oppositePairs.where((q) => q != p), 2))
          '${p.$1} – ${q.$3}',
      ];
      return g.choice(
        prompt: 'Which pair are opposites?',
        visual: const EmojiVisual('↔️'),
        answer: '${p.$1} – ${p.$3}',
        wrong: wrongPairs,
      );
    },
  ]);
  return [...choices.take(2), match, ...choices.skip(2)];
}

List<Question> sightWords(Gen g, {PreKWords? today}) {
  if (today != null) return _preKSight(g, today);
  final list = sightWordsByLevel[g.level] ?? sightWordsByLevel[Level.grade2]!;
  final sentences = _upTo(g, sightSentences, (s) => s.$1);
  return g.mix(g.count, [
    () {
      final word = g.one(list);
      final similar = list
          .where((w) => w != word && (w.length - word.length).abs() <= 1)
          .toList();
      return g.choice(
        prompt: 'Tap the word you hear!',
        visual: const ListenVisual(),
        answer: word,
        wrong: similar.length >= 3 ? similar : list,
        count: 4,
        speech: ['Find the word… $word.', word],
      );
    },
    () {
      final (_, sentence, answer, wrong) = g.one(sentences);
      return g.choice(
        prompt: 'Which word finishes the sentence?',
        visual: TextVisual(sentence),
        answer: answer,
        wrong: wrong,
      );
    },
    () {
      final word = g.one(list.where((w) => w.length >= 3).toList());
      return g.choice(
        prompt: 'Which word is spelled like this?',
        visual: TextVisual(word.split('').join(' - ')),
        answer: word,
        wrong: list.where((w) => w.length == word.length || w[0] == word[0]),
        count: 3,
      );
    },
    () {
      final word = g.one(list.where((w) => w.length >= 3).toList());
      final fakes = {for (var i = 0; i < 3; i++) _scramble(g, word)}
        ..removeWhere(list.contains);
      if (fakes.isEmpty) fakes.add('${word}x');
      return g.choice(
        prompt: 'Which one is a real word?',
        visual: const EmojiVisual('🔍'),
        answer: word,
        wrong: fakes,
      );
    },
  ]);
}

List<Question> syllables(Gen g) {
  final most = g.level == Level.kindergarten ? 3 : 4;
  final pool = [
    ...syllableWords,
    ...moreSyllableWords,
  ].where((w) => w.$3 <= most).toList();
  return g.mix(g.count, [
    () {
      final (emoji, word, count) = g.one(pool);
      return g.choice(
        prompt: 'How many claps (syllables) in "$word"?',
        visual: EmojiVisual(emoji, word),
        answer: '$count',
        wrong: [for (var i = 1; i <= most; i++) '$i'],
        speech: ['How many claps in $word?', word],
      );
    },
    () {
      final n = g.between(1, most);
      final right = pool.where((w) => w.$3 == n).toList();
      return g.choice(
        prompt: 'Which word has $n syllable${n == 1 ? '' : 's'}?',
        visual: const EmojiVisual('👏'),
        answer: g.one(right).$2,
        wrong: [
          for (final w in pool)
            if (w.$3 != n) w.$2,
        ],
        count: 3,
      );
    },
    () {
      final word = g.one(syllableSplits.keys.toList());
      final split = syllableSplits[word]!;
      final cut = split.indexOf('-');
      final wrong = {
        if (cut > 1) '${word.substring(0, cut - 1)}-${word.substring(cut - 1)}',
        if (cut < word.length - 1)
          '${word.substring(0, cut + 1)}-${word.substring(cut + 1)}',
        '${word[0]}-${word.substring(1)}',
      }..remove(split);
      return g.choice(
        prompt: 'How do you clap "$word"?',
        visual: const EmojiVisual('👏'),
        answer: split,
        wrong: wrong,
      );
    },
    () {
      final one = pool.where((w) => w.$3 == 1).toList();
      return g.choice(
        prompt: 'Which picture has just ONE clap?',
        visual: const EmojiVisual('☝️'),
        answer: g.one(one).$1,
        wrong: [
          for (final w in pool)
            if (w.$3 > 1) w.$1,
        ],
        count: 3,
      );
    },
  ]);
}

// ------------------------------------------------------------- passages

List<Question> comprehension(Gen g) {
  final exact = passages.where((p) => p.level == g.level).toList();
  final pool = exact.isNotEmpty
      ? exact
      : passages.where((p) => p.level.atMost(g.level)).toList();
  // A story this child hasn't read recently.
  final p = g.fresh(pool, (p) => p.title);
  final readFirst = g.atMost(Level.grade1);
  return [
    for (var i = 0; i < p.questions.length; i++)
      g.choice(
        prompt: p.questions[i].question,
        visual: PassageVisual(
          p.title,
          p.emoji,
          p.text,
          readFirst: readFirst && i == 0,
        ),
        answer: p.questions[i].answer,
        wrong: p.questions[i].wrong,
      ),
  ];
}

// --------------------------------------------------------------- grammar

List<Question> grammar(Gen g) {
  final types = {
    'noun (a person, place or thing)': nouns,
    'verb (an action word)': verbs,
    if (g.atLeast(Level.grade2)) 'adjective (a describing word)': adjectives,
    if (g.atLeast(Level.grade3)) 'adverb (tells how)': adverbs,
  };
  return g.mix(g.count, [
    () {
      final type = g.one(types.keys.toList());
      return g.choice(
        prompt: 'Which word is a $type?',
        visual: const EmojiVisual('🏷️'),
        answer: g.one(types[type]!),
        wrong: [
          for (final e in types.entries)
            if (e.key != type) ...e.value,
        ],
        count: types.length >= 3 ? 4 : 3,
      );
    },
    () {
      final (sentence, noun, verb, adj, adv) = g.one(taggedSentences);
      final options = {
        'noun': noun,
        'verb': verb,
        if (g.atLeast(Level.grade2)) 'adjective': adj,
        if (g.atLeast(Level.grade3)) 'adverb': adv,
      };
      final type = g.one(options.keys.toList());
      return g.choice(
        prompt: 'Find the $type in this sentence.',
        visual: TextVisual(sentence),
        answer: options[type]!,
        wrong: [noun, verb, adj, adv],
      );
    },
    () {
      final (_, single, plural, wrong) = g.one(_upTo(g, plurals, (p) => p.$1));
      return g.choice(
        prompt: 'What is the plural of "$single"?',
        visual: TextVisual('one $single → two ___'),
        answer: plural,
        wrong: wrong,
      );
    },
    () {
      final (_, present, past, wrong) = g.one(
        _upTo(g, pastTenses, (p) => p.$1),
      );
      return g.choice(
        prompt: 'Yesterday I ___. Which word fits?',
        visual: TextVisual('today: $present\nyesterday: ?'),
        answer: past,
        wrong: wrong,
      );
    },
    if (g.level == Level.grade1)
      () {
        final an = g.chance(.5);
        final (emoji, noun) = g.one(an ? anNouns : aNouns);
        return g.choice(
          prompt: 'Which is correct?',
          visual: EmojiVisual(emoji),
          answer: '${an ? 'an' : 'a'} $noun',
          wrong: ['${an ? 'a' : 'an'} $noun'],
        );
      },
    if (g.atLeast(Level.grade2))
      () => g.choice(
        prompt: 'Which word needs a capital letter?',
        visual: const EmojiVisual('🔠'),
        answer: g.one(properNouns),
        wrong: commonNouns,
        count: 4,
      ),
    if (g.atLeast(Level.grade2))
      () {
        final (_, template, pronoun) = g.one(pronounSentences);
        return g.choice(
          prompt: 'Which word fills the gap?',
          visual: TextVisual(template),
          answer: pronoun,
          wrong: const ['He', 'She', 'They', 'It', 'We'],
          count: 3,
        );
      },
  ]);
}

List<Question> compounds(Gen g) {
  final valid = {for (final (a, b) in compoundWords) '$a$b'};
  MatchQuestion matchRound() {
    // Greedily pick pairs where no first part joins a different second part.
    final picks = <(String, String)>[];
    for (final p in [...compoundWords]..shuffle(g.r)) {
      final clash = picks.any(
        (q) =>
            valid.contains('${p.$1}${q.$2}') ||
            valid.contains('${q.$1}${p.$2}'),
      );
      if (!clash) picks.add(p);
      if (picks.length == Gen.matchCount) break;
    }
    return g.match('Join the words to make compound words!', [
      for (final (a, b) in picks) (MatchItem(a), MatchItem(b)),
    ]);
  }

  final match = g.keep(matchRound());
  final choices = g.mix(g.count - 1, [
    () {
      final (emoji, word) = g.one(compoundPictures);
      return g.choice(
        prompt: 'Which compound word matches the picture?',
        visual: EmojiVisual(emoji),
        answer: word,
        wrong: fakeCompounds,
        count: 3,
      );
    },
    () {
      final (sentence, answer, wrong) = g.one(compoundSentences);
      return g.choice(
        prompt: 'Finish the compound word!',
        visual: TextVisual(sentence),
        answer: answer,
        wrong: wrong,
      );
    },
    () {
      final (a, b) = g.one(compoundWords);
      return g.choice(
        prompt: '$a + $b = ?',
        visual: TextVisual('$a + $b'),
        answer: '$a$b',
        wrong: {
          '$b$a',
          '$a${g.one(compoundWords).$2}',
          '${g.one(compoundWords).$1}$b',
        }..removeWhere(valid.contains),
      );
    },
    () => g.choice(
      prompt: 'Which one is a real compound word?',
      visual: const EmojiVisual('🔍'),
      answer: g.one(valid.toList()),
      wrong: fakeCompounds,
      count: 3,
    ),
  ]);
  return [...choices.take(2), match, ...choices.skip(2)];
}

List<Question> fillGap(Gen g) => g.mix(g.count, [
  () {
    final (_, _, sentence, answer, wrong) = g.one(
      _inRange(g, gapSentences, (s) => s.$1, (s) => s.$2),
    );
    return g.choice(
      prompt: 'Which word fits in the gap?',
      visual: TextVisual(sentence.replaceAll('___', '_____')),
      answer: answer,
      wrong: wrong,
      speech: ['Which word fits? ${sentence.replaceAll('___', 'blank')}'],
    );
  },
  () {
    final (_, _, emoji, sentence, answer, wrong) = g.one(
      _inRange(g, pictureGaps, (s) => s.$1, (s) => s.$2),
    );
    return g.choice(
      prompt: 'Look at the picture. Which word fits?',
      visual: TextVisual(sentence, emoji: emoji),
      answer: answer,
      wrong: wrong,
    );
  },
  () {
    final (_, _, sentence, fits, misfit) = g.one(
      _inRange(g, notFitGaps, (s) => s.$1, (s) => s.$2),
    );
    return g.choice(
      prompt: 'Which word does NOT make sense in the gap?',
      visual: TextVisual(sentence),
      answer: misfit,
      wrong: fits,
    );
  },
  if (g.atLeast(Level.grade2))
    () {
      final (_, _, sentence, answer, wrong) = g.one(
        _inRange(g, doubleGaps, (s) => s.$1, (s) => s.$2),
      );
      return g.choice(
        prompt: 'Which pair of words fills both gaps?',
        visual: TextVisual(sentence),
        answer: answer,
        wrong: wrong,
      );
    },
  () {
    final an = g.chance(.5);
    final (emoji, noun) = g.one(an ? anNouns : aNouns);
    return g.choice(
      prompt: 'Should it be "a" or "an"?',
      visual: TextVisual('I see ___ $noun.', emoji: emoji),
      answer: an ? 'an' : 'a',
      wrong: const ['a', 'an'],
    );
  },
]);

List<Question> wordMeanings(Gen g) {
  final pool = _inRange(g, meaningWords, (w) => w.$1, (w) => w.$2);
  return g.mix(g.count, [
    () {
      final (_, _, word, same, opposite) = g.one(pool);
      return g.choice(
        prompt: 'Which word means the SAME as "$word"?',
        visual: TextVisual(word, emoji: '🟰'),
        answer: same,
        wrong: [
          opposite,
          ...g.pick([
            for (final w in pool)
              if (w.$3 != word) w.$4,
          ], 2),
        ],
      );
    },
    () {
      final (_, _, word, same, opposite) = g.one(pool);
      return g.choice(
        prompt: 'Which word means the OPPOSITE of "$word"?',
        visual: TextVisual(word, emoji: '↔️'),
        answer: opposite,
        wrong: [
          same,
          ...g.pick([
            for (final w in pool)
              if (w.$3 != word) w.$5,
          ], 2),
        ],
      );
    },
    () {
      final withSentence = pool
          .where((w) => meaningSentences.containsKey(w.$3))
          .toList();
      final (_, _, word, same, opposite) = g.one(
        withSentence.isNotEmpty ? withSentence : pool,
      );
      final sentence = meaningSentences[word] ?? 'The word is "$word".';
      return g.choice(
        prompt: 'Which word could replace "$word" in this sentence?',
        visual: TextVisual(sentence),
        answer: same,
        wrong: [
          opposite,
          ...g.pick([
            for (final w in meaningWords)
              if (w.$3 != word) w.$4,
          ], 1),
        ],
      );
    },
    if (g.atLeast(Level.grade3))
      () {
        final (_, _, sentence, word, meaning, wrong) = g.one(
          _inRange(g, contextClues, (c) => c.$1, (c) => c.$2),
        );
        return g.choice(
          prompt: 'Use the clues. What does "$word" mean?',
          visual: TextVisual(sentence),
          answer: meaning,
          wrong: wrong,
        );
      },
    () {
      final shades = g.one(shadesOfMeaning);
      final strongest = g.chance(.5);
      return g.choice(
        prompt: strongest
            ? 'Which word is the strongest?'
            : 'Which word is the mildest?',
        visual: const EmojiVisual('🌡️'),
        answer: strongest ? shades.last : shades.first,
        wrong: shades,
      );
    },
  ]);
}

List<Question> homophones(Gen g) => g.mix(g.count, [
  () {
    final (sentence, answer, wrong) = g.one(homophoneSentences);
    return g.choice(
      prompt: 'Which word is correct?',
      visual: TextVisual(sentence.replaceAll('___', '_____')),
      answer: answer,
      wrong: wrong,
      speech: [sentence.replaceAll('___', answer.toLowerCase())],
    );
  },
  () {
    final set = g.one(homophoneSets);
    final (word, meaning) = g.one(set);
    return g.choice(
      prompt: 'Which word means "$meaning"?',
      visual: const EmojiVisual('👯'),
      answer: word,
      wrong: set.map((w) => w.$1),
      speech: ['Which word means $meaning?'],
    );
  },
  () {
    final (sentence, wrongWord, others) = g.one(homophoneMistakes);
    return g.choice(
      prompt: 'Which word is the wrong sound-alike?',
      visual: TextVisual(sentence),
      answer: wrongWord,
      wrong: others,
    );
  },
  () {
    final set = g.one(homophoneSets);
    final (a, b) = g.one(nearHomophones);
    return g.choice(
      prompt: 'Which two words sound exactly the same?',
      visual: const EmojiVisual('👂'),
      answer: '${set[0].$1} – ${set[1].$1}',
      wrong: ['$a – $b', '${set[0].$1} – ${g.one(nearHomophones).$2}'],
    );
  },
]);

List<Question> wordPartsSheet(Gen g) => g.mix(g.count, [
  () {
    final (_, _, word, _, meaning) = g.one(affixWords);
    return g.choice(
      prompt: 'What does "$word" mean?',
      visual: TextVisual(word, emoji: '🧱'),
      answer: meaning,
      wrong: [
        for (final a in affixWords)
          if (a.$3 != word) a.$5,
      ],
      count: 3,
    );
  },
  () {
    final part = g.one(affixMeanings.keys.toList());
    final prefix = wordParts.any((p) => p.$1 == part && p.$5);
    return g.choice(
      prompt:
          'Which ${prefix ? 'prefix' : 'suffix'} means "${affixMeanings[part]}"?',
      visual: const EmojiVisual('🧩'),
      answer: prefix ? '$part-' : '-$part',
      wrong: [
        for (final p in wordParts)
          if (p.$5 == prefix && p.$1 != part) prefix ? '${p.$1}-' : '-${p.$1}',
      ],
      count: 3,
    );
  },
  () {
    final (sentence, answer, wrong) = g.one(affixSentences);
    return g.choice(
      prompt: 'Which word fits the sentence?',
      visual: TextVisual(sentence),
      answer: answer,
      wrong: wrong,
    );
  },
  () {
    final (_, _, word, base, meaning) = g.one(affixWords);
    return g.choice(
      prompt: 'Which word means "$meaning"?',
      visual: TextVisual(base, emoji: '➕'),
      answer: word,
      wrong: [
        for (final a in affixWords)
          if (a.$4 == base && a.$3 != word) a.$3,
        ..._fakeAffixes(base),
      ],
      count: 3,
    );
  },
  if (g.atLeast(Level.grade4))
    () {
      final (root, meaning, examples) = g.one(wordRoots);
      return g.choice(
        prompt: 'The root "$root" is in $examples. What does it mean?',
        visual: TextVisual(root, emoji: '🌱'),
        answer: meaning,
        wrong: [
          for (final w in wordRoots)
            if (w.$1 != root) w.$2,
        ],
        count: 3,
      );
    },
]);

List<String> _fakeAffixes(String base) => [
  'dis$base',
  '${base}less',
  'mis$base',
  '${base}ful',
];

// ------------------------------------------------- Pre-K: today's words
//
// Pre-K meets two sight words and two three-letter words a day (plus
// yesterday's, for review), and sees each one several different ways.

List<Question> _preKSight(Gen g, PreKWords today) {
  final [a, b] = today.sight;
  final review = g.one(today.reviewSight);
  final near = [...today.sight, ...today.reviewSight];
  List<String> lookAlikes(String w) => [
    for (final x in preKSightWords)
      if (x != w && (x.length - w.length).abs() <= 1) x,
  ];
  ChoiceQuestion hear(String w) => g.choice(
    prompt: 'Tap the word you hear!',
    visual: const ListenVisual(),
    answer: w,
    wrong: near,
    count: 3,
    speech: ['Find the word… $w.', w],
  );
  ChoiceQuestion same(String w) => g.choice(
    prompt: 'Find the same word!',
    visual: TextVisual(w),
    answer: w,
    wrong: lookAlikes(w),
    count: 3,
    speech: ['This word is $w. Find the same word!'],
  );
  ChoiceQuestion spelled(String w) => w.length < 2
      ? same(w)
      : g.choice(
          prompt: 'Which word is spelled like this?',
          visual: TextVisual(w.split('').join(' - ')),
          answer: w,
          wrong: [...near, ...lookAlikes(w)],
          count: 3,
          speech: ['${w.split('').join(', ')}. Which word is that?'],
        );
  return [hear(a), same(b), spelled(a), hear(b), hear(review)];
}

List<Question> _preKWords(Gen g, PreKWords today) {
  final [a, b] = today.cvc;
  final review = g.one(today.reviewCvc);
  String word((String, String) w) => w.$2.replaceAll('-', '');
  final pictures = soundOutWords.map((w) => w.$1);
  ChoiceQuestion soundIt((String, String) w) {
    final parts = w.$2.split('-');
    return g.choice(
      prompt: 'Sound it out!',
      visual: SoundOutVisual(parts),
      answer: w.$1,
      wrong: pictures,
      count: 3,
      speech: [
        for (final p in parts) letterSounds[p] ?? p,
        'What word is that? Tap the picture!',
      ],
    );
  }

  ChoiceQuestion readIt((String, String) w) => g.choice(
    prompt: 'Read the word. Tap its picture!',
    visual: TextVisual(word(w)),
    answer: w.$1,
    wrong: pictures,
    count: 3,
    speech: ['Read the word. Tap its picture!'],
  );
  ChoiceQuestion nameIt((String, String) w) => g.choice(
    prompt: 'Which word matches the picture?',
    visual: EmojiVisual(w.$1),
    answer: word(w),
    wrong: [
      ...[...today.cvc, ...today.reviewCvc].map(word),
      ...soundOutWords.map(word),
    ],
    count: 3,
  );
  ChoiceQuestion missing((String, String) w) {
    final up = word(w).toUpperCase();
    final i = g.between(0, 2);
    return g.choice(
      prompt: 'Which letter is missing?',
      visual: WordPictureVisual(w.$1, up, i),
      answer: up[i],
      wrong: i == 1
          ? const ['A', 'E', 'I', 'O', 'U']
          : 'BCDFGHLMNPRSTV'.split(''),
      count: 3,
    );
  }

  return [soundIt(a), readIt(b), nameIt(a), missing(b), readIt(review)];
}
