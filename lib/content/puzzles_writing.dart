import '../models/models.dart';

// Content for the Puzzles and Writing worksheets.

// ---------------------------------------------------------------- puzzles

/// Picture groups: (name for "not a …" questions, reason "the others all …", pictures).
/// No picture appears in two groups, so odd-one-out answers are never ambiguous.
const pictureGroups = [
  ('a fruit', 'are fruits', ['🍎', '🍌', '🍇', '🍓', '🍊', '🍉', '🍐', '🍒']),
  (
    'a land animal',
    'are land animals',
    ['🐶', '🐱', '🐭', '🐰', '🦊', '🐻', '🐼', '🐮'],
  ),
  ('a vehicle', 'are vehicles', ['🚗', '🚌', '🚓', '🚑', '🚒', '🚜', '🚕']),
  ('clothing', 'are clothes', ['👕', '👖', '👗', '🧦', '🧢', '👟', '🧥']),
  (
    'a sea animal',
    'live in the sea',
    ['🐟', '🐠', '🐙', '🦀', '🐬', '🐳', '🦈'],
  ),
  ('a ball', 'are balls', ['⚽', '🏀', '🏈', '⚾', '🎾', '🏐']),
  ('an instrument', 'make music', ['🎸', '🎹', '🥁', '🎺', '🎻']),
  ('a vegetable', 'are vegetables', ['🥕', '🥦', '🌽', '🥔', '🍆', '🥒']),
];

/// Word groups for "which word does not belong?" (Grade 1+).
const wordGroups = [
  (
    'are colors',
    ['red', 'blue', 'green', 'yellow', 'purple', 'orange', 'pink'],
  ),
  ('are numbers', ['one', 'two', 'three', 'four', 'five', 'six', 'ten']),
  (
    'are days',
    ['Monday', 'Tuesday', 'Friday', 'Sunday', 'Thursday', 'Saturday'],
  ),
  ('are shapes', ['circle', 'square', 'triangle', 'oval', 'rectangle', 'star']),
  (
    'are family',
    ['mom', 'dad', 'sister', 'brother', 'grandma', 'uncle', 'aunt'],
  ),
  ('are months', ['January', 'March', 'July', 'October', 'December', 'April']),
  ('are body parts', ['arm', 'leg', 'nose', 'knee', 'elbow', 'chin', 'toe']),
  ('are weather', ['rain', 'snow', 'wind', 'fog', 'hail', 'sleet']),
];

/// Things that go together: (thing, partner). Every emoji is used once.
const goTogether = [
  ('🐶', '🦴'),
  ('🐰', '🥕'),
  ('🐒', '🍌'),
  ('🐭', '🧀'),
  ('🐝', '🌻'),
  ('🔑', '🔒'),
  ('🧦', '👟'),
  ('☂️', '🌧️'),
  ('🥛', '🍪'),
  ('🐔', '🥚'),
  ('✏️', '📄'),
  ('🎂', '🕯️'),
  ('⚽', '🥅'),
  ('🚗', '⛽'),
];

/// Pictures for shadow puzzles: (emoji, name, is it an animal?).
/// Each has a distinct outline.
const shadowPool = [
  ('🐘', 'elephant', true),
  ('🦒', 'giraffe', true),
  ('🐇', 'rabbit', true),
  ('🐢', 'turtle', true),
  ('🦋', 'butterfly', true),
  ('🐟', 'fish', true),
  ('🐌', 'snail', true),
  ('🦀', 'crab', true),
  ('🐓', 'rooster', true),
  ('🐬', 'dolphin', true),
  ('🦕', 'dinosaur', true),
  ('🦆', 'duck', true),
  ('🚲', 'bike', false),
  ('🎸', 'guitar', false),
  ('✂️', 'scissors', false),
  ('⭐', 'star', false),
  ('☂️', 'umbrella', false),
  ('🍐', 'pear', false),
  ('🍌', 'banana', false),
  ('🔑', 'key', false),
  ('✈️', 'plane', false),
  ('🏠', 'house', false),
  ('⚓', 'anchor', false),
  ('🔨', 'hammer', false),
];

const patternSets = [
  ['🍎', '🍌', '🍇', '🍊'],
  ['🐶', '🐱', '🐰', '🐻'],
  ['❤️', '💙', '💛', '💚'],
  ['🌞', '🌙', '⭐', '☁️'],
  ['🚗', '🚌', '🚀', '🚲'],
  ['🌸', '🍀', '🌻', '🍁'],
  ['⬆️', '➡️', '⬇️', '⬅️'],
  ['🔴', '🔵', '🟡', '🟢'],
];

/// Word riddles: (riddle, answer, wrong answers, minimum level).
const wordRiddles = [
  (
    'I have a face and two hands, but I can not clap.',
    'a clock',
    ['a dog', 'a tree', 'a spoon'],
    Level.grade1,
  ),
  (
    'I have lots of keys, but I can not open a door.',
    'a piano',
    ['a car', 'a house', 'a shoe'],
    Level.grade1,
  ),
  (
    'I open up when the rain comes down.',
    'an umbrella',
    ['a window', 'a book', 'a flower'],
    Level.grade1,
  ),
  (
    'I have a neck but no head, and I wear a cap.',
    'a bottle',
    ['a giraffe', 'a shirt', 'a lamp'],
    Level.grade1,
  ),
  (
    'I have four legs, but I can not walk.',
    'a table',
    ['a cat', 'a bird', 'a cloud'],
    Level.grade1,
  ),
  (
    'I have teeth, but I can not bite.',
    'a comb',
    ['a shark', 'a baby', 'a ball'],
    Level.grade1,
  ),
  (
    'I am round, I bounce, and you can kick me.',
    'a ball',
    ['a rock', 'a cake', 'a hat'],
    Level.grade1,
  ),
  (
    'I am yellow and hot, and I light up the day.',
    'the sun',
    ['the moon', 'a lemon', 'a banana'],
    Level.grade1,
  ),
  (
    'I have pages and a cover, and I tell stories.',
    'a book',
    ['a box', 'a door', 'a bed'],
    Level.grade1,
  ),
  (
    'I am tall when I am new and short when I am old.',
    'a candle',
    ['a tree', 'a person', 'a house'],
    Level.grade2,
  ),
  (
    'The more I dry, the wetter I get.',
    'a towel',
    ['a rock', 'the sun', 'a fan'],
    Level.grade2,
  ),
  (
    'I have an eye, but I can not see.',
    'a needle',
    ['a pirate', 'a fish', 'a cloud'],
    Level.grade3,
  ),
  (
    'The more you take, the more you leave behind.',
    'footsteps',
    ['cookies', 'photos', 'money'],
    Level.grade3,
  ),
  (
    'I have cities but no houses, and rivers but no water.',
    'a map',
    ['a lake', 'a desert', 'a garden'],
    Level.grade3,
  ),
  (
    'I go up and down, but I never move.',
    'stairs',
    ['a ball', 'a bird', 'a kite'],
    Level.grade3,
  ),
  (
    'What has one head, one foot, and four legs?',
    'a bed',
    ['a horse', 'a dog', 'a cow'],
    Level.grade4,
  ),
  (
    'What can you break without touching it?',
    'a promise',
    ['a glass', 'an egg', 'a stick'],
    Level.grade4,
  ),
];

/// Word analogies: (stem, answer, wrong answers, minimum level).
const analogies = [
  (
    'Puppy is to dog as kitten is to ___.',
    'cat',
    ['mouse', 'milk', 'yarn'],
    Level.grade1,
  ),
  (
    'Hot is to cold as up is to ___.',
    'down',
    ['high', 'top', 'sky'],
    Level.grade1,
  ),
  (
    'Big is to small as fast is to ___.',
    'slow',
    ['quick', 'car', 'run'],
    Level.grade1,
  ),
  (
    'Eye is to see as ear is to ___.',
    'hear',
    ['smell', 'loud', 'head'],
    Level.grade1,
  ),
  (
    'Bird is to nest as bee is to ___.',
    'hive',
    ['honey', 'buzz', 'wing'],
    Level.grade1,
  ),
  (
    'Fish is to swim as bird is to ___.',
    'fly',
    ['nest', 'egg', 'tree'],
    Level.grade1,
  ),
  (
    'Hand is to glove as foot is to ___.',
    'sock',
    ['toe', 'leg', 'hat'],
    Level.grade2,
  ),
  (
    'Pen is to write as scissors are to ___.',
    'cut',
    ['paper', 'sharp', 'glue'],
    Level.grade2,
  ),
  (
    'Day is to night as summer is to ___.',
    'winter',
    ['sun', 'hot', 'beach'],
    Level.grade2,
  ),
  (
    'Water is to thirsty as food is to ___.',
    'hungry',
    ['plate', 'eat', 'sleepy'],
    Level.grade2,
  ),
  (
    'Cow is to calf as horse is to ___.',
    'foal',
    ['lamb', 'kitten', 'cub'],
    Level.grade3,
  ),
  (
    'Teacher is to school as doctor is to ___.',
    'hospital',
    ['nurse', 'medicine', 'store'],
    Level.grade3,
  ),
  (
    'Three is to triangle as five is to ___.',
    'pentagon',
    ['circle', 'square', 'hexagon'],
    Level.grade3,
  ),
  (
    'Author is to book as painter is to ___.',
    'painting',
    ['brush', 'color', 'museum'],
    Level.grade4,
  ),
  (
    'Seed is to tree as egg is to ___.',
    'bird',
    ['shell', 'nest', 'yolk'],
    Level.grade4,
  ),
  (
    'Minute is to hour as day is to ___.',
    'week',
    ['second', 'night', 'clock'],
    Level.grade4,
  ),
  (
    'Ice is to water as water is to ___.',
    'steam',
    ['snow', 'cup', 'rain'],
    Level.grade5,
  ),
  (
    'Chapter is to book as scene is to ___.',
    'play',
    ['actor', 'stage', 'ticket'],
    Level.grade5,
  ),
];

/// Comparisons for logic puzzles: (bigger word, smaller word, biggest, smallest).
const comparisons = [
  ('taller', 'shorter', 'tallest', 'shortest'),
  ('older', 'younger', 'oldest', 'youngest'),
  ('faster', 'slower', 'fastest', 'slowest'),
  ('heavier', 'lighter', 'heaviest', 'lightest'),
];

const puzzleNames = [
  'Ava',
  'Ben',
  'Cy',
  'Dev',
  'Ella',
  'Finn',
  'Gia',
  'Hugo',
  'Ivy',
  'Jay',
  'Kim',
  'Luca',
];

/// Symbols for balance puzzles.
const balanceSymbols = ['🍎', '🍌', '🍓', '⭐', '🐟', '🎈', '🍩', '🌸'];

// ---------------------------------------------------------------- tracing

/// Letter → (emoji, word) for tracing hints.
const traceLetters = {
  'A': ('🐜', 'Ant'),
  'B': ('🎈', 'Balloon'),
  'C': ('🥕', 'Carrot'),
  'D': ('🦆', 'Duck'),
  'E': ('🥚', 'Egg'),
  'F': ('🐟', 'Fish'),
  'G': ('🐐', 'Goat'),
  'H': ('🎩', 'Hat'),
  'I': ('🍦', 'Ice cream'),
  'J': ('👖', 'Jeans'),
  'K': ('🦘', 'Kangaroo'),
  'L': ('🍋', 'Lemon'),
  'M': ('🌙', 'Moon'),
  'N': ('🥜', 'Nuts'),
  'O': ('🦉', 'Owl'),
  'P': ('🐧', 'Penguin'),
  'Q': ('👸', 'Queen'),
  'R': ('🤖', 'Robot'),
  'S': ('⭐', 'Star'),
  'T': ('🌳', 'Tree'),
  'U': ('🦄', 'Unicorn'),
  'V': ('🚐', 'Van'),
  'W': ('🐋', 'Whale'),
  'X': ('🦊', 'Fox'),
  'Y': ('🧶', 'Yarn'),
  'Z': ('🦓', 'Zebra'),
};

/// Age 2 pre-writing strokes: (glyph, hint, picture-name used in questions).
const traceStrokes = [
  ('O', 'Round like a ball ⚽', 'round like a ball'),
  ('I', 'Straight down ⬇️', 'straight down'),
  ('L', 'Down and across ↘️', 'down and across'),
  ('C', 'Like a cookie bite 🍪', 'like a cookie bite'),
  ('U', 'Like a cup ☕', 'like a cup'),
  ('V', 'Down and up ✌️', 'down and up'),
];

/// Short words to trace (K–Grade 1).
const traceWords = [
  ('🐱', 'cat'),
  ('☀️', 'sun'),
  ('🐶', 'dog'),
  ('🎩', 'hat'),
  ('🐷', 'pig'),
  ('🚌', 'bus'),
  ('🐟', 'fish'),
  ('🌳', 'tree'),
  ('⭐', 'star'),
  ('🐸', 'frog'),
  ('🌙', 'moon'),
  ('🦆', 'duck'),
  ('📖', 'book'),
  ('🎂', 'cake'),
  ('🐻', 'bear'),
  ('☕', 'cup'),
  ('🛏️', 'bed'),
  ('🦊', 'fox'),
  ('🐝', 'bee'),
  ('🥚', 'egg'),
];

// --------------------------------------------------------------- spelling

/// Picture words for K–Grade 1 spelling: (emoji, WORD, misspellings).
const pictureWords = [
  ('🐱', 'CAT', ['KAT', 'CATT', 'CAAT']),
  ('🐶', 'DOG', ['DOGG', 'DOOG', 'DGO']),
  ('☀️', 'SUN', ['SUNN', 'ZUN', 'SUHN']),
  ('🐝', 'BEE', ['BEEE', 'BIE', 'BII']),
  ('🐷', 'PIG', ['PIGG', 'PIGE', 'PYG']),
  ('🐮', 'COW', ['KOW', 'COWE', 'COUW']),
  ('🚌', 'BUS', ['BUZ', 'BUSE', 'BOUS']),
  ('🎩', 'HAT', ['HAAT', 'HATT', 'HAHT']),
  ('🚗', 'CAR', ['KAR', 'CAAR', 'KARR']),
  ('🛏️', 'BED', ['BEDD', 'BEHD', 'BADD']),
  ('☕', 'CUP', ['KUP', 'CUPP', 'CUHP']),
  ('🦊', 'FOX', ['FOKS', 'FOXX', 'FOCKS']),
  ('🐔', 'HEN', ['HENN', 'HEHN', 'HENE']),
  ('📦', 'BOX', ['BOKS', 'BOXX', 'BOCKS']),
  ('🐟', 'FISH', ['FICH', 'FISSH', 'FESH']),
  ('⭐', 'STAR', ['STAAR', 'SDAR', 'STAHR']),
  ('🐸', 'FROG', ['FROGG', 'VROG', 'FRAWG']),
  ('🌳', 'TREE', ['TRE', 'TREA', 'CHREE']),
  ('🌙', 'MOON', ['MUNE', 'MOOM', 'MUUN']),
  ('🦆', 'DUCK', ['DUK', 'DUC', 'DUKC']),
  ('📖', 'BOOK', ['BUK', 'BOOCK', 'BOUK']),
  ('🎂', 'CAKE', ['KAKE', 'CAK', 'CAEK']),
  ('🐻', 'BEAR', ['BAIR', 'BEHR', 'BAER']),
  ('🧦', 'SOCK', ['SOK', 'SOCC', 'SAKC']),
  ('🥁', 'DRUM', ['DRUMM', 'JRUM', 'DRUHM']),
  ('🚢', 'SHIP', ['SHIPP', 'SHYP', 'SHIIP']),
  ('⚽', 'BALL', ['BAL', 'BOLL', 'BALLE']),
  ('🥛', 'MILK', ['MILC', 'MELK', 'MIK']),
  ('👟', 'SHOE', ['SHU', 'SHOOE', 'CHOE']),
  ('🍎', 'APPLE', ['APPEL', 'APLE', 'APPUL']),
];

/// (lowest level, highest level, word, misspellings) for Grade 2–5.
const spellList = [
  (Level.grade2, Level.grade3, 'because', ['becuase', 'becos']),
  (Level.grade2, Level.grade3, 'friend', ['freind', 'frend']),
  (Level.grade2, Level.grade2, 'said', ['sed', 'siad']),
  (Level.grade2, Level.grade3, 'would', ['wuld', 'woud']),
  (Level.grade2, Level.grade3, 'people', ['peple', 'poeple']),
  (Level.grade2, Level.grade3, 'school', ['skool', 'shcool']),
  (Level.grade2, Level.grade2, 'again', ['agin', 'agen']),
  (Level.grade2, Level.grade2, 'they', ['thay', 'tey']),
  (Level.grade2, Level.grade3, 'little', ['littel', 'litle']),
  (Level.grade2, Level.grade3, 'animal', ['animul', 'aminal']),
  (Level.grade2, Level.grade3, 'pretty', ['prity', 'pritty']),
  (Level.grade2, Level.grade3, 'every', ['evry', 'evrey']),
  (Level.grade2, Level.grade3, 'house', ['howse', 'hous']),
  (Level.grade2, Level.grade3, 'where', ['whare', 'wher']),
  (Level.grade3, Level.grade4, 'different', ['diffrent', 'diferent']),
  (Level.grade3, Level.grade4, 'beautiful', ['beutiful', 'beautifull']),
  (Level.grade3, Level.grade4, 'favorite', ['favrite', 'faverite']),
  (Level.grade3, Level.grade5, 'believe', ['beleive', 'belive']),
  (Level.grade3, Level.grade4, 'tomorrow', ['tommorow', 'tomorow']),
  (Level.grade3, Level.grade4, 'library', ['libary', 'librery']),
  (Level.grade3, Level.grade4, 'enough', ['enuf', 'enogh']),
  (Level.grade3, Level.grade4, 'answer', ['anser', 'answar']),
  (Level.grade3, Level.grade4, 'special', ['speshal', 'specail']),
  (Level.grade3, Level.grade4, 'question', ['qestion', 'questoin']),
  (Level.grade4, Level.grade5, 'February', ['Febuary', 'Februery']),
  (Level.grade4, Level.grade5, 'Wednesday', ['Wensday', 'Wednsday']),
  (Level.grade4, Level.grade5, 'surprise', ['suprise', 'surprize']),
  (Level.grade4, Level.grade5, 'calendar', ['calender', 'calandar']),
  (Level.grade4, Level.grade5, 'necessary', ['neccessary', 'necesary']),
  (Level.grade4, Level.grade5, 'receive', ['recieve', 'receeve']),
  (Level.grade4, Level.grade5, 'separate', ['seperate', 'separete']),
  (Level.grade4, Level.grade5, 'weird', ['wierd', 'weerd']),
  (Level.grade4, Level.grade5, 'government', ['goverment', 'guvernment']),
  (Level.grade5, Level.grade5, 'definitely', ['definately', 'definitly']),
  (Level.grade5, Level.grade5, 'environment', ['enviroment', 'environmint']),
  (Level.grade5, Level.grade5, 'restaurant', ['resturant', 'restaraunt']),
  (Level.grade5, Level.grade5, 'rhythm', ['rythm', 'rhythem']),
  (Level.grade5, Level.grade5, 'knowledge', ['knowlege', 'nowledge']),
  (Level.grade5, Level.grade5, 'immediately', ['immediatly', 'imediately']),
  (Level.grade5, Level.grade5, 'occasion', ['ocasion', 'occassion']),
];

/// Adding endings: (lowest, highest, base, ending, correct, wrong spellings).
const endingWords = [
  (Level.grade2, Level.grade3, 'hop', 'ing', 'hopping', ['hopeing', 'hopinng']),
  (Level.grade2, Level.grade3, 'run', 'ing', 'running', ['runing', 'runeing']),
  (Level.grade2, Level.grade3, 'make', 'ing', 'making', ['makeing', 'makking']),
  (Level.grade2, Level.grade3, 'jump', 'ed', 'jumped', ['jumpped', 'jumpt']),
  (Level.grade2, Level.grade3, 'stop', 'ed', 'stopped', ['stoped', 'stopt']),
  (Level.grade2, Level.grade3, 'bake', 'ed', 'baked', ['bakeed', 'bakked']),
  (
    Level.grade2,
    Level.grade3,
    'swim',
    'ing',
    'swimming',
    ['swiming', 'swimeing'],
  ),
  (Level.grade2, Level.grade3, 'big', 'er', 'bigger', ['biger', 'bigar']),
  (
    Level.grade3,
    Level.grade4,
    'happy',
    'ness',
    'happiness',
    ['happyness', 'happines'],
  ),
  (Level.grade3, Level.grade4, 'cry', 'ed', 'cried', ['cryed', 'cride']),
  (
    Level.grade3,
    Level.grade4,
    'carry',
    'ing',
    'carrying',
    ['carriing', 'carying'],
  ),
  (
    Level.grade3,
    Level.grade4,
    'hope',
    'ful',
    'hopeful',
    ['hopful', 'hopefull'],
  ),
  (Level.grade3, Level.grade5, 'easy', 'ly', 'easily', ['easyly', 'easly']),
  (
    Level.grade3,
    Level.grade5,
    'funny',
    'est',
    'funniest',
    ['funnyest', 'funest'],
  ),
  (
    Level.grade4,
    Level.grade5,
    'begin',
    'ing',
    'beginning',
    ['begining', 'beginnng'],
  ),
  (
    Level.grade4,
    Level.grade5,
    'care',
    'less',
    'careless',
    ['carless', 'carelless'],
  ),
  (
    Level.grade4,
    Level.grade5,
    'enjoy',
    'ment',
    'enjoyment',
    ['enjoiment', 'enjoyement'],
  ),
  (
    Level.grade4,
    Level.grade5,
    'excite',
    'ment',
    'excitement',
    ['excitment', 'excitemint'],
  ),
  (
    Level.grade5,
    Level.grade5,
    'admit',
    'ed',
    'admitted',
    ['admited', 'admittted'],
  ),
  (
    Level.grade5,
    Level.grade5,
    'argue',
    'ment',
    'argument',
    ['arguement', 'argumint'],
  ),
  (
    Level.grade5,
    Level.grade5,
    'courage',
    'ous',
    'courageous',
    ['couragous', 'courageus'],
  ),
];

/// Plural spellings: (lowest, highest, one, more than one, wrong spellings).
const pluralWords = [
  (Level.grade2, Level.grade3, 'baby', 'babies', ['babys', 'babyes']),
  (Level.grade2, Level.grade3, 'box', 'boxes', ['boxs', 'boxies']),
  (Level.grade2, Level.grade3, 'fox', 'foxes', ['foxs', 'foxses']),
  (Level.grade2, Level.grade3, 'bus', 'buses', ['buss', 'busies']),
  (Level.grade2, Level.grade3, 'dish', 'dishes', ['dishs', 'dishies']),
  (Level.grade2, Level.grade3, 'toy', 'toys', ['toies', 'toyes']),
  (Level.grade2, Level.grade3, 'puppy', 'puppies', ['puppys', 'puppyes']),
  (Level.grade2, Level.grade4, 'man', 'men', ['mans', 'mens']),
  (Level.grade2, Level.grade4, 'foot', 'feet', ['foots', 'feets']),
  (Level.grade2, Level.grade4, 'tooth', 'teeth', ['tooths', 'teeths']),
  (Level.grade3, Level.grade4, 'mouse', 'mice', ['mouses', 'mices']),
  (Level.grade3, Level.grade4, 'child', 'children', ['childs', 'childrens']),
  (Level.grade3, Level.grade4, 'city', 'cities', ['citys', 'cityes']),
  (Level.grade3, Level.grade5, 'wolf', 'wolves', ['wolfs', 'wolfes']),
  (Level.grade3, Level.grade5, 'knife', 'knives', ['knifes', 'knifs']),
  (Level.grade3, Level.grade5, 'goose', 'geese', ['gooses', 'geeses']),
  (Level.grade3, Level.grade5, 'sheep', 'sheep', ['sheeps', 'sheepes']),
  (Level.grade4, Level.grade5, 'potato', 'potatoes', ['potatos', 'potatose']),
  (Level.grade4, Level.grade5, 'hero', 'heroes', ['heros', 'heroies']),
  (Level.grade4, Level.grade5, 'half', 'halves', ['halfs', 'halfes']),
  (Level.grade4, Level.grade5, 'woman', 'women', ['womans', 'womens']),
  (Level.grade5, Level.grade5, 'thief', 'thieves', ['thiefs', 'theives']),
];

// ----------------------------------------------------------- fix sentence

/// (lowest, highest, correct sentence, incorrect versions)
const correctSentences = [
  (
    Level.grade1,
    Level.grade2,
    'The dog is big.',
    ['the dog is big.', 'The dog is big', 'the dog is big'],
  ),
  (
    Level.grade1,
    Level.grade2,
    'I like red apples.',
    ['i like red apples.', 'I like red apples', 'i like red apples'],
  ),
  (
    Level.grade1,
    Level.grade2,
    'Can you see the bird?',
    ['Can you see the bird.', 'can you see the bird?', 'can you see the bird'],
  ),
  (
    Level.grade1,
    Level.grade2,
    'We went to the zoo.',
    ['we went to the zoo.', 'We went to the zoo', 'we went to the zoo?'],
  ),
  (
    Level.grade1,
    Level.grade2,
    'Where is my hat?',
    ['Where is my hat.', 'where is my hat?', 'where is my hat'],
  ),
  (
    Level.grade1,
    Level.grade2,
    'My cat naps a lot.',
    ['my cat naps a lot.', 'My cat naps a lot', 'My cat naps a lot?'],
  ),
  (
    Level.grade1,
    Level.grade2,
    'Do you like to swim?',
    ['Do you like to swim.', 'do you like to swim?', 'do you like to swim'],
  ),
  (
    Level.grade2,
    Level.grade3,
    'Sam and I played soccer.',
    [
      'sam and I played soccer.',
      'Sam and i played soccer.',
      'Sam and I played soccer',
    ],
  ),
  (
    Level.grade2,
    Level.grade3,
    'My birthday is in May.',
    [
      'My birthday is in may.',
      'my birthday is in May.',
      'My Birthday is in may.',
    ],
  ),
  (
    Level.grade2,
    Level.grade3,
    'We visited Paris last summer.',
    [
      'We visited paris last summer.',
      'we visited Paris last summer.',
      'We visited paris last summer',
    ],
  ),
  (
    Level.grade2,
    Level.grade3,
    'On Monday, Mia rode her bike.',
    [
      'On monday, Mia rode her bike.',
      'On Monday, mia rode her bike.',
      'on Monday, Mia rode her bike.',
    ],
  ),
  (
    Level.grade3,
    Level.grade4,
    'She bought eggs, milk, and bread.',
    [
      'She bought eggs milk and bread.',
      'She bought, eggs, milk, and bread.',
      'she bought eggs, milk, and bread.',
    ],
  ),
  (
    Level.grade3,
    Level.grade4,
    'The dogs run fast.',
    ['The dogs runs fast.', 'The dogs is running fast.', 'The dog run fast.'],
  ),
  (
    Level.grade3,
    Level.grade5,
    "Mia's bike is blue.",
    ["Mias bike is blue.", "Mia's bike are blue.", "Mias' bike is blue."],
  ),
  (
    Level.grade3,
    Level.grade5,
    'They are going to their house.',
    [
      'They are going to there house.',
      "They are going to they're house.",
      'They is going to their house.',
    ],
  ),
  (
    Level.grade3,
    Level.grade4,
    'Ben and I went to the park.',
    [
      'Me and Ben went to the park.',
      'Ben and me went to the park.',
      'Ben and I goed to the park.',
    ],
  ),
  (
    Level.grade4,
    Level.grade5,
    'Yesterday, we walked to school.',
    [
      'Yesterday, we walk to school.',
      'Yesterday, we walks to school.',
      'Yesterday we walking to school.',
    ],
  ),
  (
    Level.grade4,
    Level.grade5,
    '"Let\'s go," said Dad.',
    ['"Let\'s go" said Dad.', 'Let\'s go, said Dad.', '"lets go," said Dad.'],
  ),
  (
    Level.grade4,
    Level.grade5,
    'Each of the students has a book.',
    [
      'Each of the students have a book.',
      'Each of the student has a book.',
      'Each of the students having a book.',
    ],
  ),
  (
    Level.grade4,
    Level.grade5,
    'Mom asked, "Where are my keys?"',
    [
      'Mom asked, "Where are my keys."',
      'Mom asked "where are my keys?"',
      'Mom asked, Where are my keys?',
    ],
  ),
  (
    Level.grade5,
    Level.grade5,
    'Neither the cat nor the dogs were hungry.',
    [
      'Neither the cat nor the dogs was hungry.',
      'Neither the cat or the dogs were hungry.',
      'Neither the cat nor the dogs is hungry.',
    ],
  ),
  (
    Level.grade5,
    Level.grade5,
    'The team celebrated its victory.',
    [
      "The team celebrated it's victory.",
      'The team celebrated its victory',
      "The team celebrated its' victory.",
    ],
  ),
  (
    Level.grade5,
    Level.grade5,
    'If I were you, I would rest.',
    [
      'If I was you, I would rest.',
      'If I were you I would rested.',
      'If I were you, I will rested.',
    ],
  ),
];

/// End marks: (lowest level, sentence without its mark, the mark).
/// Only clear questions, plain statements and "What a …!/How …!" exclamations.
const endMarkSentences = [
  (Level.grade1, 'Where is my red hat', '?'),
  (Level.grade1, 'The sun is hot today', '.'),
  (Level.grade1, 'Can we play outside', '?'),
  (Level.grade1, 'My dog has a long tail', '.'),
  (Level.grade1, 'Who ate the last cookie', '?'),
  (Level.grade1, 'I have two baby teeth', '.'),
  (Level.grade1, 'Is it time for lunch', '?'),
  (Level.grade1, 'We read a book about frogs', '.'),
  (Level.grade1, 'What is your name', '?'),
  (Level.grade1, 'The bus stops at the corner', '.'),
  (Level.grade2, 'What a huge wave that was', '!'),
  (Level.grade2, 'How tall that giraffe is', '!'),
  (Level.grade2, 'Why do cats purr', '?'),
  (Level.grade2, 'My grandpa grows tomatoes', '.'),
  (Level.grade2, 'What a funny clown he is', '!'),
  (Level.grade3, 'How did the bird build its nest', '?'),
  (Level.grade3, 'How bright the stars are tonight', '!'),
  (Level.grade3, 'Plants need sunlight to grow', '.'),
];

/// Sentence types: (lowest level, sentence, type).
const sentenceKinds = [
  (Level.grade1, 'The cat is black.', 'telling'),
  (Level.grade1, 'Is the cat black?', 'asking'),
  (Level.grade1, 'We have a red car.', 'telling'),
  (Level.grade1, 'Do you have a red car?', 'asking'),
  (Level.grade1, 'Birds can fly.', 'telling'),
  (Level.grade1, 'Can birds fly?', 'asking'),
  (Level.grade1, 'My shoes are new.', 'telling'),
  (Level.grade1, 'Where are my shoes?', 'asking'),
  (Level.grade2, 'What a great game that was!', 'exclaiming'),
  (Level.grade2, 'Wow, I won the race!', 'exclaiming'),
  (Level.grade2, 'Hooray, it snowed!', 'exclaiming'),
  (Level.grade3, 'Please close the door.', 'command'),
  (Level.grade3, 'Put your coat on the hook.', 'command'),
  (Level.grade3, 'Wash your hands before lunch.', 'command'),
  (Level.grade3, 'Turn left at the library.', 'command'),
];

/// Type names: (key, label for Grade 1–2, label for Grade 3+).
const sentenceKindNames = {
  'telling': ('telling', 'statement'),
  'asking': ('asking', 'question'),
  'exclaiming': ('exclaiming', 'exclamation'),
  'command': ('command', 'command'),
};

/// Capitals: (lowest level, sentence, the ONE word that needs a capital besides the first).
const capitalSentences = [
  (Level.grade1, 'My dog Rex likes to dig.', 'Rex'),
  (Level.grade1, 'Mom and I baked a cake.', 'I'),
  (Level.grade1, 'We play with Lily after school.', 'Lily'),
  (Level.grade1, 'Can I have a snack now?', 'I'),
  (Level.grade1, 'My best friend is Omar.', 'Omar'),
  (Level.grade1, 'The cat sat with Grandma.', 'Grandma'),
  (Level.grade2, 'We go swimming every Saturday.', 'Saturday'),
  (Level.grade2, 'My birthday is in October.', 'October'),
  (Level.grade2, 'Our class went to Chicago.', 'Chicago'),
  (Level.grade2, 'The parade is on Friday.', 'Friday'),
  (Level.grade2, 'Snow fell all through January.', 'January'),
  (Level.grade3, 'We drove across Texas in a van.', 'Texas'),
  (Level.grade3, 'Her family is from Mexico.', 'Mexico'),
  (Level.grade3, 'The boat sailed down the Mississippi.', 'Mississippi'),
  (Level.grade3, 'My uncle lives in Canada.', 'Canada'),
  (Level.grade4, 'We studied the planet Jupiter today.', 'Jupiter'),
  (Level.grade4, 'Our trip to Florida was fun.', 'Florida'),
];

/// Word order: (lowest level, correct sentence, wrong orders).
const orderSentences = [
  (
    Level.grade1,
    'The dog runs fast.',
    ['Dog the fast runs.', 'Runs fast the dog.', 'Fast dog the runs.'],
  ),
  (
    Level.grade1,
    'I like green grapes.',
    ['Like I grapes green.', 'Green like I grapes.', 'Grapes I green like.'],
  ),
  (
    Level.grade1,
    'We can see the moon.',
    ['See we can the moon.', 'Moon the we can see.', 'Can the see we moon.'],
  ),
  (
    Level.grade1,
    'My cat is very soft.',
    ['Cat my is soft very.', 'Soft very is my cat.', 'Is very my soft cat.'],
  ),
  (
    Level.grade1,
    'Sam has a red ball.',
    ['Has Sam ball a red.', 'Red a Sam has ball.', 'Ball red has a Sam.'],
  ),
  (
    Level.grade2,
    'The frog jumped into the pond.',
    [
      'Jumped the frog pond into the.',
      'Into the frog the pond jumped.',
      'The pond frog jumped the into.',
    ],
  ),
  (
    Level.grade2,
    'Please pass me the salt.',
    [
      'Pass please salt me the.',
      'Me the salt please pass.',
      'Salt the pass me please.',
    ],
  ),
  (
    Level.grade2,
    'Where did you put my book?',
    [
      'Did where you my put book?',
      'You put where my did book?',
      'Book my where did put you?',
    ],
  ),
  (
    Level.grade3,
    'The tiny ant carried a big crumb.',
    [
      'Ant the tiny a carried crumb big.',
      'Carried a big the tiny crumb ant.',
      'The big crumb ant tiny carried a.',
    ],
  ),
  (
    Level.grade3,
    'After lunch we played a board game.',
    [
      'Lunch after played we a game board.',
      'We game a after played lunch board.',
      'Board a game lunch we after played.',
    ],
  ),
  (
    Level.grade4,
    'My brother always forgets his lunch box.',
    [
      'Brother my forgets always lunch his box.',
      'His lunch always box my brother forgets.',
      'Always my his brother box forgets lunch.',
    ],
  ),
  (
    Level.grade4,
    'The scientists studied the strange rock.',
    [
      'Studied the scientists rock strange the.',
      'The rock strange the studied scientists.',
      'Strange the studied rock scientists the.',
    ],
  ),
];

/// Contractions: (lowest level, two words, contraction, wrong spellings).
const contractions = [
  (Level.grade1, 'do not', "don't", ["dont", "do'nt"]),
  (Level.grade1, 'can not', "can't", ["cant", "ca'nt"]),
  (Level.grade1, 'I am', "I'm", ["Im", "I'am"]),
  (Level.grade1, 'it is', "it's", ["its'", "i'ts"]),
  (Level.grade2, 'is not', "isn't", ["is'nt", "isnt"]),
  (Level.grade2, 'we are', "we're", ["were'", "we'ar"]),
  (Level.grade2, 'they are', "they're", ["theyre", "theyr'e"]),
  (Level.grade2, 'you will', "you'll", ["youll", "you'wll"]),
  (Level.grade2, 'did not', "didn't", ["did'nt", "dint"]),
  (Level.grade3, 'will not', "won't", ["willn't", "wont'"]),
  (Level.grade3, 'I have', "I've", ["Iv'e", "I'hve"]),
  (Level.grade3, 'she would', "she'd", ["sh'ed", "shed'"]),
  (Level.grade3, 'could not', "couldn't", ["could'nt", "coudn't"]),
  (Level.grade4, 'they have', "they've", ["theyv'e", "they'ave"]),
  (Level.grade4, 'should have', "should've", ["should of", "shouldv'e"]),
  (Level.grade4, 'we would', "we'd", ["wed'", "w'ed"]),
];

/// Past tense: (lowest level, sentence with ___, present verb, past answer, wrongs).
const pastTense = [
  (
    Level.grade1,
    'Yesterday I ___ to the park.',
    'go',
    'went',
    ['goed', 'goes'],
  ),
  (
    Level.grade1,
    'Last night we ___ a movie.',
    'watch',
    'watched',
    ['watches', 'watchd'],
  ),
  (
    Level.grade1,
    'Yesterday Ben ___ a big fish.',
    'catch',
    'caught',
    ['catched', 'catches'],
  ),
  (
    Level.grade1,
    'This morning I ___ my teeth.',
    'brush',
    'brushed',
    ['brushs', 'brusht'],
  ),
  (
    Level.grade2,
    'Last week Mia ___ a letter to Grandma.',
    'write',
    'wrote',
    ['writed', 'writes'],
  ),
  (
    Level.grade2,
    'Yesterday the baby ___ all night.',
    'sleep',
    'slept',
    ['sleeped', 'sleeps'],
  ),
  (
    Level.grade2,
    'Last summer we ___ in the lake.',
    'swim',
    'swam',
    ['swimmed', 'swims'],
  ),
  (
    Level.grade2,
    'Yesterday Dad ___ pancakes.',
    'make',
    'made',
    ['maked', 'makes'],
  ),
  (
    Level.grade3,
    'Last year our team ___ the cup.',
    'win',
    'won',
    ['winned', 'wins'],
  ),
  (
    Level.grade3,
    'Yesterday I ___ my lunch at home.',
    'forget',
    'forgot',
    ['forgetted', 'forgets'],
  ),
  (
    Level.grade3,
    'Earlier today the bell ___ twice.',
    'ring',
    'rang',
    ['ringed', 'rings'],
  ),
  (
    Level.grade4,
    'Last night the pond ___ solid.',
    'freeze',
    'froze',
    ['freezed', 'freezes'],
  ),
  (
    Level.grade4,
    'Yesterday the wind ___ hard.',
    'blow',
    'blew',
    ['blowed', 'blows'],
  ),
  (
    Level.grade4,
    'Two days ago Ava ___ her new bike.',
    'ride',
    'rode',
    ['rided', 'rides'],
  ),
  (
    Level.grade5,
    'The choir had ___ that song before.',
    'sing',
    'sung',
    ['sang', 'singed'],
  ),
];

/// Verb agreement: (lowest level, sentence with ___, answer, wrongs).
const agreement = [
  (Level.grade1, 'The cats ___ milk.', 'drink', ['drinks']),
  (Level.grade1, 'My sister ___ fast.', 'runs', ['run']),
  (Level.grade1, 'The birds ___ in the tree.', 'sing', ['sings']),
  (Level.grade1, 'He ___ a red kite.', 'has', ['have']),
  (Level.grade2, 'The boys ___ playing tag.', 'are', ['is']),
  (Level.grade2, 'Our teacher ___ funny stories.', 'tells', ['tell']),
  (Level.grade2, 'The puppies ___ hungry.', 'are', ['is']),
  (Level.grade2, 'She ___ to school every day.', 'walks', ['walk']),
  (Level.grade3, 'The flowers in the vase ___ pretty.', 'look', ['looks']),
  (Level.grade3, 'Everyone ___ a turn.', 'gets', ['get']),
  (Level.grade3, 'Ava and Leo ___ best friends.', 'are', ['is']),
  (Level.grade4, 'The box of crayons ___ on the shelf.', 'is', ['are']),
  (Level.grade4, 'Neither of the boys ___ ready.', 'is', ['are']),
  (Level.grade4, 'The children ___ their lunches.', 'eat', ['eats']),
  (Level.grade5, 'A flock of geese ___ overhead.', 'flies', ['fly']),
  (Level.grade5, 'Each of the girls ___ a solo.', 'sings', ['sing']),
];

/// Joining words: (lowest level, sentence with ___, answer, wrongs). Only one choice makes sense.
const conjunctions = [
  (
    Level.grade2,
    'I wanted to play outside, ___ it was raining.',
    'but',
    ['so', 'or'],
  ),
  (Level.grade2, 'I was hungry, ___ I ate an apple.', 'so', ['but', 'or']),
  (Level.grade2, 'Do you want milk ___ juice?', 'or', ['so', 'but']),
  (Level.grade2, 'We packed sandwiches ___ grapes.', 'and', ['so', 'but']),
  (
    Level.grade3,
    'Leo studied hard, ___ he passed the test.',
    'so',
    ['but', 'or'],
  ),
  (
    Level.grade3,
    'The cake looked good, ___ it tasted bad.',
    'but',
    ['so', 'or'],
  ),
  (
    Level.grade3,
    'We stayed inside ___ it was too cold.',
    'because',
    ['but', 'or'],
  ),
  (Level.grade3, 'You can draw ___ you can paint.', 'or', ['because', 'so']),
  (
    Level.grade4,
    'We will go to the beach ___ it rains.',
    'unless',
    ['because', 'so'],
  ),
  (
    Level.grade4,
    'She read a book ___ she waited for the bus.',
    'while',
    ['unless', 'or'],
  ),
  (
    Level.grade4,
    'I brushed my teeth ___ I went to bed.',
    'before',
    ['unless', 'or'],
  ),
  (
    Level.grade5,
    '___ it was late, we kept reading.',
    'Although',
    ['Because', 'Unless'],
  ),
  (
    Level.grade5,
    'The road was icy; ___, the bus was late.',
    'therefore',
    ['although', 'unless'],
  ),
];

/// Run-on fixes: (lowest level, run-on, best fix, wrong fixes).
const runOns = [
  (
    Level.grade3,
    'I was tired I went to bed.',
    'I was tired, so I went to bed.',
    ['I was, tired I went to bed.', 'I was tired I, went to bed.'],
  ),
  (
    Level.grade3,
    'The bell rang we lined up.',
    'The bell rang. We lined up.',
    ['The bell. Rang we lined up.', 'The bell rang we. Lined up.'],
  ),
  (
    Level.grade3,
    'It was sunny we went to the beach.',
    'It was sunny, so we went to the beach.',
    [
      'It was sunny we, went to the beach.',
      'It was, sunny we went to the beach.',
    ],
  ),
  (
    Level.grade4,
    'My dog barks a lot he wants to play.',
    'My dog barks a lot because he wants to play.',
    [
      'My dog barks, a lot he wants to play.',
      'My dog. Barks a lot he wants to play.',
    ],
  ),
  (
    Level.grade4,
    'Mia likes soccer Leo likes chess.',
    'Mia likes soccer, but Leo likes chess.',
    [
      'Mia likes, soccer Leo likes chess.',
      'Mia likes soccer Leo, likes chess.',
    ],
  ),
  (
    Level.grade5,
    'The storm was loud nobody could sleep.',
    'The storm was so loud that nobody could sleep.',
    [
      'The storm was loud nobody, could sleep.',
      'The storm, was loud nobody could sleep.',
    ],
  ),
  (
    Level.grade5,
    'We missed the bus we walked to school.',
    'We missed the bus, so we walked to school.',
    [
      'We missed, the bus we walked to school.',
      'We missed the bus we walked. To school.',
    ],
  ),
];
