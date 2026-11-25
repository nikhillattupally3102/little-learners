// Content for the Thinking Skills worksheets: reasoning puzzles in the
// style of the CogAT's verbal battery (analogies, sentence completion,
// classification). All items are written for this app.
//
// K–2 items are pictures, read aloud; Grade 3+ items use words.

import '../models/models.dart';

// ------------------------------------------------------- picture analogies

/// A way two pictures go together, with pairs that go together that way.
/// The child sees one pair, then a new first picture, and picks its partner.
typedef PictureRelation = (Level, List<(String, String)>);

const pictureAnalogies = <PictureRelation>[
  // Animal → what it eats.
  (
    Level.kindergarten,
    [
      ('🐰', '🥕'), ('🐒', '🍌'), ('🐻', '🍯'), ('🐭', '🧀'), ('🐶', '🦴'), //
      ('🐝', '🌸'),
    ],
  ),
  // Things used together.
  (
    Level.kindergarten,
    [
      ('🔑', '🔒'), ('🧦', '👟'), ('⚽', '🥅'), ('🥄', '🍜'), ('🧼', '🛁'), //
      ('✏️', '📓'),
    ],
  ),
  // Animal → where it lives.
  (
    Level.kindergarten,
    [('🐟', '🌊'), ('🐪', '🏜️'), ('🐧', '🧊'), ('🐒', '🌴'), ('🐻', '🌲')],
  ),
  // Young → grown up.
  (Level.grade1, [('🐣', '🐔'), ('🐛', '🦋'), ('🌰', '🌳'), ('🌱', '🌻')]),
  // Weather → what you need.
  (Level.grade1, [('☀️', '🕶️'), ('🌧️', '☂️'), ('❄️', '🧤'), ('🌙', '🛏️')]),
  // Part → the whole thing.
  (Level.grade2, [('🍃', '🌳'), ('🧱', '🏠'), ('🐾', '🐶'), ('🦷', '👄')]),
  // Opposites.
  (Level.grade2, [('🔥', '🧊'), ('☀️', '🌙'), ('😀', '😢'), ('⬆️', '⬇️')]),
];

// --------------------------------------------- picture sentence completion

/// (from level, spoken question, picture answer, wrong pictures)
const pictureQuestions = <(Level, String, String, List<String>)>[
  (
    Level.kindergarten,
    'Which one do you use to cut paper?',
    '✂️',
    ['🥄', '🖍️', '🧸'],
  ),
  (Level.kindergarten, 'Which one gives us milk?', '🐄', ['🐔', '🐷', '🐟']),
  (Level.kindergarten, 'Which one grows on a tree?', '🍎', ['🥕', '🥔', '🧀']),
  (
    Level.kindergarten,
    'Which one keeps you dry in the rain?',
    '☂️',
    ['🕶️', '🧢', '🩳'],
  ),
  (
    Level.kindergarten,
    'Which one do you use to wash your hands?',
    '🧼',
    ['🖍️', '🔨', '🧸'],
  ),
  (
    Level.kindergarten,
    'Which one helps you see in the dark?',
    '🔦',
    ['🧸', '🥄', '📚'],
  ),
  (Level.kindergarten, 'Which one do you sleep in?', '🛏️', ['🛁', '🪑', '🚗']),
  (
    Level.kindergarten,
    'Which animal has a long trunk?',
    '🐘',
    ['🦒', '🦓', '🐻'],
  ),
  (Level.kindergarten, 'Which one lays eggs?', '🐔', ['🐶', '🐄', '🐱']),
  (
    Level.kindergarten,
    'Which one do you wear on your head?',
    '🧢',
    ['🧦', '👖', '🧤'],
  ),
  (
    Level.grade1,
    'Which one would you use to eat soup?',
    '🥄',
    ['✂️', '🔨', '✏️'],
  ),
  (
    Level.grade1,
    'Which one would a firefighter drive?',
    '🚒',
    ['🚜', '🚌', '🚲'],
  ),
  (
    Level.grade1,
    'Which one tells you what time it is?',
    '⌚',
    ['📚', '🎒', '🧸'],
  ),
  (Level.grade1, 'Which one melts when it gets warm?', '⛄', ['🧱', '🔑', '🪑']),
  (
    Level.grade1,
    'Which one do you plant to grow a flower?',
    '🌱',
    ['🧱', '🍭', '🧦'],
  ),
  (
    Level.grade1,
    'Which one would you wear at the beach?',
    '🕶️',
    ['🧤', '🛷', '🧥'],
  ),
  (
    Level.grade1,
    'Which one can swim but cannot fly?',
    '🐟',
    ['🦅', '🦋', '🐝'],
  ),
  (Level.grade1, 'Which one makes music?', '🎸', ['🔨', '🧽', '🪑']),
  (Level.grade2, 'Mia was cold, so she put on her…', '🧥', ['🩳', '🕶️', '🍦']),
  (
    Level.grade2,
    'The plant was dry, so Sam gave it some…',
    '💧',
    ['🍪', '🧦', '🧱'],
  ),
  (
    Level.grade2,
    'It was dark, so Grandpa turned on the…',
    '💡',
    ['🧸', '🥕', '🧦'],
  ),
  (
    Level.grade2,
    'Leo wanted to read, so he picked up a…',
    '📚',
    ['⚽', '🍕', '🛁'],
  ),
  (
    Level.grade2,
    'The ice cream melted because it was out in the…',
    '☀️',
    ['❄️', '🌙', '🌧️'],
  ),
  (
    Level.grade2,
    'Ava missed the bus, so she rode her… to school.',
    '🚲',
    ['🛏️', '🐟', '☂️'],
  ),
  (
    Level.grade2,
    'The dog was hungry, so it chewed on a…',
    '🦴',
    ['🧸', '🎈', '👟'],
  ),
  (
    Level.grade2,
    'After playing in the mud, Ben needed a…',
    '🛁',
    ['🎂', '🎈', '📺'],
  ),
];

// ------------------------------------------------- picture classification

/// (from level, things that belong together, things that don't)
const pictureGroups = <(Level, List<String>, List<String>)>[
  (
    Level.kindergarten,
    ['🍎', '🍌', '🍇', '🍓', '🍊', '🍐', '🍉', '🍒'],
    ['🥕', '🚗', '🧸', '⚽', '👟', '🐶'],
  ),
  (
    Level.kindergarten,
    ['🚗', '🚌', '🚂', '✈️', '🚲', '🚜', '🚒'],
    ['🍎', '🐶', '🌳', '🏠', '🧸', '👕'],
  ),
  (
    Level.kindergarten,
    ['👕', '👖', '🧦', '🧥', '👗', '🧢', '🧤'],
    ['🍌', '🚗', '🐱', '⚽', '📚'],
  ),
  (
    Level.kindergarten,
    ['☀️', '🌙', '⭐', '☁️', '🌈'],
    ['🌳', '🏠', '🐟', '🚗', '🍎'],
  ),
  (
    Level.kindergarten,
    ['🐄', '🐖', '🐑', '🐴', '🐔'],
    ['🐟', '🐙', '🦀', '🐳', '🐬'],
  ),
  (
    Level.grade1,
    ['🐟', '🐙', '🐬', '🦀', '🐳', '🦈'],
    ['🐄', '🐖', '🐑', '🐴', '🐔', '🐶'],
  ),
  (Level.grade1, ['🎸', '🥁', '🎹', '🎺', '🎻'], ['🔨', '📱', '📺', '🧸', '⚽']),
  (
    Level.grade1,
    ['🥕', '🥦', '🌽', '🥔', '🥒', '🧅'],
    ['🍎', '🍌', '🍇', '🍓', '🍒'],
  ),
  (
    Level.grade1,
    ['🍳', '🥄', '🍽️', '🧂', '🥛'],
    ['🛏️', '🧸', '🚗', '⚽', '🧦'],
  ),
  (Level.grade1, ['🔨', '🛠️', '✂️', '📏'], ['🍕', '🧸', '🎈', '🌸', '📚']),
  // Trickier: bats and butterflies fly, but they aren't birds.
  (
    Level.grade2,
    ['🦅', '🦉', '🦜', '🐧', '🦆', '🐓'],
    ['🦇', '🐶', '🦋', '🐱', '🐝'],
  ),
  // Spiders and snails are small, but they aren't insects.
  (
    Level.grade2,
    ['🐞', '🐝', '🦋', '🐜', '🦗'],
    ['🕷️', '🐌', '🦂', '🐸', '🐟'],
  ),
  // Penguins are birds that can't fly.
  (
    Level.grade2,
    ['✈️', '🚁', '🎈', '🚀', '🦋', '🦅'],
    ['🚗', '🚂', '🐢', '🐘', '🚲', '🐧'],
  ),
  (Level.grade2, ['🔥', '☀️', '☕', '🌋'], ['🧊', '⛄', '🍦', '❄️', '🐧']),
  (Level.grade2, ['🧊', '⛄', '🍦', '❄️'], ['🔥', '☀️', '☕', '🌋']),
];

// ----------------------------------------------------------- word analogies

/// (from level, what the relation is, pairs)
const wordAnalogies = <(Level, String, List<(String, String)>)>[
  (
    Level.grade3,
    'opposites',
    [
      ('hot', 'cold'), ('up', 'down'), ('open', 'shut'), ('early', 'late'), //
      ('full', 'empty'), ('loud', 'quiet'), ('wet', 'dry'), ('heavy', 'light'),
      ('push', 'pull'), ('win', 'lose'),
    ],
  ),
  (
    Level.grade3,
    'animal and its baby',
    [
      ('dog', 'puppy'),
      ('cat', 'kitten'),
      ('cow', 'calf'),
      ('sheep', 'lamb'), //
      ('horse', 'foal'),
      ('duck', 'duckling'),
      ('bear', 'cub'),
      ('frog', 'tadpole'),
      ('kangaroo', 'joey'),
    ],
  ),
  (
    Level.grade3,
    'thing and its group',
    [
      ('apple', 'fruit'), ('carrot', 'vegetable'), ('robin', 'bird'), //
      ('oak', 'tree'), ('rose', 'flower'), ('shark', 'fish'), ('ant', 'insect'),
      ('piano', 'instrument'),
    ],
  ),
  (
    Level.grade3,
    'animal and its home',
    [
      ('bee', 'hive'),
      ('bird', 'nest'),
      ('spider', 'web'),
      ('horse', 'stable'), //
      ('pig', 'sty'), ('rabbit', 'burrow'), ('lion', 'den'),
    ],
  ),
  (
    Level.grade4,
    'worker and tool',
    [
      ('painter', 'brush'), ('farmer', 'tractor'), ('doctor', 'stethoscope'), //
      ('carpenter', 'hammer'), ('gardener', 'rake'), ('pilot', 'plane'),
      ('baker', 'oven'),
    ],
  ),
  (
    Level.grade4,
    'part and whole',
    [
      ('page', 'book'), ('petal', 'flower'), ('wheel', 'bicycle'), //
      ('finger', 'hand'),
      ('branch', 'tree'),
      ('key', 'keyboard'),
      ('room', 'house'),
    ],
  ),
  (
    Level.grade4,
    'words that mean the same',
    [
      ('big', 'large'),
      ('quick', 'fast'),
      ('glad', 'happy'),
      ('begin', 'start'), //
      ('shout', 'yell'),
      ('tiny', 'small'),
      ('smart', 'clever'),
      ('afraid', 'scared'),
    ],
  ),
  (
    Level.grade5,
    'a little and a lot',
    [
      ('warm', 'hot'), ('cool', 'freezing'), ('damp', 'soaked'), //
      ('big', 'enormous'), ('happy', 'overjoyed'), ('tired', 'exhausted'),
      ('hungry', 'starving'), ('good', 'excellent'),
    ],
  ),
  (
    Level.grade5,
    'place and what you find there',
    [
      ('library', 'books'), ('bakery', 'bread'), ('garage', 'car'), //
      ('aquarium', 'fish'), ('orchard', 'apples'), ('closet', 'clothes'),
      ('museum', 'paintings'),
    ],
  ),
  (
    Level.grade5,
    'tool and what it does',
    [
      ('scissors', 'cut'), ('broom', 'sweep'), ('pen', 'write'), //
      ('shovel', 'dig'), ('needle', 'sew'), ('oven', 'bake'), ('spoon', 'stir'),
    ],
  ),
];

// ------------------------------------------------- word sentence completion

/// (from level, sentence with ___, answer, wrong words)
const sentenceCompletions = <(Level, String, String, List<String>)>[
  (
    Level.grade3,
    'The puppy was so ___ after the long walk that it fell asleep right away.',
    'tired',
    ['loud', 'early', 'curious'],
  ),
  (
    Level.grade3,
    'We use an umbrella to stay ___ when it rains.',
    'dry',
    ['clean', 'quiet', 'tall'],
  ),
  (
    Level.grade3,
    'The sun ___ in the east every morning.',
    'rises',
    ['sets', 'sleeps', 'melts'],
  ),
  (
    Level.grade3,
    'Plants need water and ___ to grow.',
    'sunlight',
    ['plastic', 'music', 'paper'],
  ),
  (
    Level.grade3,
    'Ava put on her coat because it was ___ outside.',
    'cold',
    ['sunny', 'loud', 'early'],
  ),
  (
    Level.grade3,
    'At the library, people can ___ books and take them home.',
    'borrow',
    ['cook', 'throw', 'paint'],
  ),
  (
    Level.grade3,
    'A baby frog is called a ___.',
    'tadpole',
    ['calf', 'chick', 'cub'],
  ),
  (
    Level.grade3,
    'Fish breathe through their ___.',
    'gills',
    ['lungs', 'noses', 'fins'],
  ),
  (
    Level.grade4,
    'The team practiced every day, so they were ___ for the big game.',
    'ready',
    ['late', 'hungry', 'finished'],
  ),
  (
    Level.grade4,
    'Because the road was icy, the driver went very ___.',
    'slowly',
    ['quickly', 'loudly', 'happily'],
  ),
  (
    Level.grade4,
    'The ___ of a fable is the lesson it teaches.',
    'moral',
    ['title', 'author', 'cover'],
  ),
  (
    Level.grade4,
    'Water turns into ice when it ___.',
    'freezes',
    ['boils', 'melts', 'flows'],
  ),
  (
    Level.grade4,
    'Maya ___ the answer, so she raised her hand right away.',
    'knew',
    ['forgot', 'lost', 'hid'],
  ),
  (
    Level.grade4,
    'A desert is a place that gets very little ___.',
    'rain',
    ['sand', 'sun', 'heat'],
  ),
  (
    Level.grade4,
    'Although the box looked heavy, it was actually quite ___.',
    'light',
    ['large', 'full', 'strong'],
  ),
  (
    Level.grade4,
    'The cat hid under the bed because the thunder ___ it.',
    'frightened',
    ['fed', 'washed', 'carried'],
  ),
  (
    Level.grade5,
    'The scientist was ___ about the results, so she ran the experiment again.',
    'unsure',
    ['certain', 'delighted', 'finished'],
  ),
  (
    Level.grade5,
    'Despite the storm, the hikers stayed ___ and kept going.',
    'determined',
    ['frightened', 'lost', 'asleep'],
  ),
  (
    Level.grade5,
    'The ___ of the volcano covered the village in ash.',
    'eruption',
    ['explanation', 'invention', 'celebration'],
  ),
  (
    Level.grade5,
    'Because the bridge was ___, the city closed it for repairs.',
    'damaged',
    ['crowded', 'painted', 'famous'],
  ),
  (
    Level.grade5,
    'Unlike his noisy brother, Leo was ___ and calm.',
    'quiet',
    ['loud', 'angry', 'silly'],
  ),
  (
    Level.grade5,
    'The plant ___ toward the window to reach the light.',
    'leaned',
    ['jumped', 'shouted', 'swam'],
  ),
  (
    Level.grade5,
    'Her explanation was so ___ that everyone understood it at once.',
    'clear',
    ['confusing', 'long', 'quiet'],
  ),
  (
    Level.grade5,
    'Bats are mammals, but unlike most mammals, they can ___.',
    'fly',
    ['eat', 'sleep', 'breathe'],
  ),
];

// ---------------------------------------------------- word classification

/// (from level, words that belong together, words that don't)
const wordGroups = <(Level, List<String>, List<String>)>[
  (
    Level.grade3,
    ['rose', 'daisy', 'tulip', 'lily', 'sunflower'],
    ['oak', 'carrot', 'pine', 'mushroom'],
  ),
  (
    Level.grade3,
    ['hammer', 'saw', 'wrench', 'screwdriver', 'drill'],
    ['nail', 'plank', 'paint', 'glue'],
  ),
  (
    Level.grade3,
    ['Mars', 'Venus', 'Earth', 'Jupiter', 'Saturn'],
    ['Moon', 'Sun', 'comet', 'star'],
  ),
  (
    Level.grade3,
    ['triangle', 'square', 'circle', 'rectangle', 'hexagon'],
    ['cube', 'sphere', 'cone', 'pyramid'],
  ),
  (
    Level.grade3,
    ['eagle', 'robin', 'penguin', 'ostrich', 'owl'],
    ['bat', 'butterfly', 'bee', 'dragonfly'],
  ),
  (
    Level.grade3,
    ['breakfast', 'lunch', 'dinner', 'brunch'],
    ['napkin', 'plate', 'kitchen', 'fork'],
  ),
  (
    Level.grade3,
    ['Monday', 'Friday', 'Sunday', 'Tuesday', 'Wednesday'],
    ['January', 'summer', 'morning', 'holiday'],
  ),
  (
    Level.grade3,
    ['river', 'lake', 'ocean', 'pond', 'stream'],
    ['mountain', 'desert', 'valley', 'forest'],
  ),
  (
    Level.grade4,
    ['violin', 'guitar', 'harp', 'cello'],
    ['drum', 'flute', 'trumpet', 'tuba'],
  ),
  (
    Level.grade4,
    ['whale', 'dolphin', 'seal', 'otter'],
    ['shark', 'tuna', 'eel', 'salmon'],
  ),
  (
    Level.grade4,
    ['inch', 'foot', 'mile', 'yard', 'meter'],
    ['pound', 'hour', 'liter', 'degree'],
  ),
  (
    Level.grade4,
    ['happy', 'joyful', 'cheerful', 'glad', 'delighted'],
    ['angry', 'tired', 'gloomy', 'nervous'],
  ),
  (
    Level.grade4,
    ['ant', 'beetle', 'bee', 'ladybug', 'grasshopper'],
    ['spider', 'worm', 'snail', 'scorpion'],
  ),
  (
    Level.grade4,
    ['Africa', 'Asia', 'Europe', 'Australia', 'Antarctica'],
    ['Egypt', 'Japan', 'France', 'Brazil'],
  ),
  (
    Level.grade5,
    ['whisper', 'murmur', 'mumble', 'mutter'],
    ['shout', 'yell', 'scream', 'roar'],
  ),
  (
    Level.grade5,
    ['brave', 'bold', 'daring', 'fearless'],
    ['timid', 'shy', 'nervous', 'cautious'],
  ),
  (
    Level.grade5,
    ['copper', 'iron', 'gold', 'silver', 'aluminum'],
    ['wood', 'glass', 'plastic', 'rubber'],
  ),
  (
    Level.grade5,
    ['heart', 'lungs', 'brain', 'stomach', 'liver'],
    ['elbow', 'knee', 'finger', 'ankle'],
  ),
  (
    Level.grade5,
    ['carrot', 'potato', 'beet', 'radish', 'turnip'],
    ['lettuce', 'celery', 'broccoli', 'cabbage'],
  ),
];
