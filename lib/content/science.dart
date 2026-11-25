import '../models/models.dart';

/// A multiple-choice fact question for a range of levels.
class Fact {
  const Fact(
    this.min,
    this.max,
    this.question,
    this.emoji,
    this.answer,
    this.wrong,
  );
  final Level min;
  final Level max;
  final String question;
  final String emoji;
  final String answer;
  final List<String> wrong;

  bool suits(Level l) => l.atLeast(min) && l.atMost(max);
}

const _a2 = Level.age2,
    _a3 = Level.age3,
    _pk = Level.preK,
    _k = Level.kindergarten;
const _g1 = Level.grade1,
    _g2 = Level.grade2,
    _g3 = Level.grade3,
    _g4 = Level.grade4,
    _g5 = Level.grade5;

const _myBodyBase = [
  Fact(_a2, _k, 'What do we see with?', '🧒', '👀', ['👂', '👃']),
  Fact(_a2, _k, 'What do we hear with?', '🧒', '👂', ['👀', '🦶']),
  Fact(_a2, _k, 'What do we smell with?', '🧒', '👃', ['👂', '✋']),
  Fact(_a2, _k, 'What do we taste with?', '🧒', '👅', ['👀', '👂']),
  Fact(_a2, _k, 'What do we walk with?', '🧒', '🦶', ['👂', '👃']),
  Fact(_a2, _k, 'What do we brush every day?', '😁', '🦷', ['👂', '🦶']),
  Fact(_a3, _k, 'What do we touch and hold with?', '🧸', '✋', ['👃', '👀']),
  Fact(_a3, _k, 'Which food helps you grow strong?', '💪', '🥦', ['🍭', '🍩']),
  Fact(_a3, _k, 'What do we use before we eat?', '🍽️', '🧼', ['🎮', '📺']),
  Fact(_a3, _k, 'When do we go to bed?', '🛏️', '🌙', ['☀️', '🌈']),
  Fact(_pk, _k, 'What do we think with?', '💭', '🧠', ['👃', '🦶']),
  Fact(_pk, _k, 'Which drink is best for your body?', '💧', '🥛', ['🧃', '🥤']),
];

const _weatherBase = [
  Fact(_a3, _k, 'Which one is rainy?', '☂️', '🌧️', ['☀️', '❄️']),
  Fact(_a3, _k, 'Which one is sunny?', '🕶️', '☀️', ['🌧️', '❄️']),
  Fact(_a3, _k, 'Which one is snowy?', '⛄', '❄️', ['☀️', '🌈']),
  Fact(_a3, _k, 'What do we use in the rain?', '🌧️', '☂️', ['🕶️', '🧤']),
  Fact(_a3, _g1, 'What do we wear when it is cold?', '❄️', '🧤', ['🩳', '🕶️']),
  Fact(_a3, _k, 'What can we see after rain and sun?', '🌦️', '🌈', [
    '⛄',
    '🌙',
  ]),
  Fact(_pk, _g1, 'Leaves fall from the trees in…', '🍂', 'Autumn', [
    'Spring',
    'Summer',
  ]),
  Fact(_pk, _g1, 'Which season is the coldest?', '⛄', 'Winter', [
    'Summer',
    'Spring',
  ]),
  Fact(_pk, _g1, 'Which season is the hottest?', '🏖️', 'Summer', [
    'Winter',
    'Autumn',
  ]),
  Fact(_pk, _g1, 'Flowers start to bloom in…', '🌷', 'Spring', [
    'Winter',
    'Autumn',
  ]),
  Fact(_k, _g1, 'What tells us how hot or cold it is?', '🌡️', 'Thermometer', [
    'Ruler',
    'Clock',
  ]),
  Fact(_k, _g1, 'Clouds are made of tiny drops of…', '☁️', 'Water', [
    'Cotton',
    'Smoke',
  ]),
  Fact(
    _g1,
    _g1,
    'A storm with a spinning funnel of wind is a…',
    '🌪️',
    'Tornado',
    ['Rainbow', 'Breeze'],
  ),
  Fact(_g1, _g1, 'How many seasons are in a year?', '🗓️', '4', ['2', '6']),
];

const _plantBase = [
  Fact(
    _g1,
    _g4,
    'Which part of a plant takes in water from the soil?',
    '🌱',
    'Roots',
    ['Leaves', 'Flower', 'Seeds'],
  ),
  Fact(
    _g1,
    _g4,
    'Which part of a plant uses sunlight to make food?',
    '🍃',
    'Leaves',
    ['Roots', 'Seeds', 'Stem'],
  ),
  Fact(
    _g1,
    _g3,
    'What do plants need to grow?',
    '🌻',
    'Sunlight, water and air',
    ['Candy and toys', 'Darkness only', 'Music only'],
  ),
  Fact(_g1, _g2, 'A seed grows into a…', '🌱', 'Plant', ['Rock', 'Cloud']),
  Fact(
    _g1,
    _g4,
    'Which part holds a plant up and carries water?',
    '🌿',
    'Stem',
    ['Flower', 'Seed', 'Petal'],
  ),
  Fact(_g1, _g3, 'Which of these vegetables is a root?', '🥕', 'Carrot', [
    'Apple',
    'Lettuce',
    'Corn',
  ]),
  Fact(_g2, _g4, 'Bees help flowers by carrying…', '🐝', 'Pollen', [
    'Water',
    'Leaves',
    'Soil',
  ]),
  Fact(_g2, _g4, 'Plants give off which gas that we breathe?', '🌳', 'Oxygen', [
    'Carbon dioxide',
    'Steam',
    'Smoke',
  ]),
  Fact(_g2, _g4, 'Which part of a plant makes seeds?', '🌸', 'Flower', [
    'Root',
    'Stem',
    'Bark',
  ]),
  Fact(_g2, _g3, 'An acorn grows into which kind of tree?', '🌰', 'Oak', [
    'Palm',
    'Pine',
    'Apple',
  ]),
  Fact(_g2, _g4, 'Cactus plants store water in their…', '🌵', 'Thick stems', [
    'Petals',
    'Seeds',
    'Spines',
  ]),
  Fact(
    _g3,
    _g4,
    'How plants make food from sunlight is called…',
    '☀️',
    'Photosynthesis',
    ['Digestion', 'Evaporation', 'Germination'],
  ),
  Fact(
    _g3,
    _g4,
    'Plants take in which gas from the air to make food?',
    '🌳',
    'Carbon dioxide',
    ['Oxygen', 'Helium', 'Steam'],
  ),
  Fact(
    _g3,
    _g4,
    'When a seed starts to sprout, it is called…',
    '🌱',
    'Germination',
    ['Pollination', 'Melting', 'Erosion'],
  ),
];

const _lifeCycleBase = [
  Fact(_g1, _g2, 'What does a caterpillar turn into?', '🐛', 'Butterfly', [
    'Bee',
    'Bird',
    'Snail',
  ]),
  Fact(
    _g1,
    _g3,
    'Butterfly: egg → caterpillar → ? → butterfly',
    '🦋',
    'Chrysalis',
    ['Tadpole', 'Seed', 'Chick'],
  ),
  Fact(_g1, _g3, 'A baby frog is called a…', '🐸', 'Tadpole', [
    'Kitten',
    'Cub',
    'Chick',
  ]),
  Fact(_g2, _g3, 'Frog: egg → tadpole → ? → frog', '🐸', 'Froglet', [
    'Caterpillar',
    'Chick',
    'Seedling',
  ]),
  Fact(_g1, _g2, 'What hatches from a hen\'s egg?', '🥚', 'Chick', [
    'Puppy',
    'Calf',
    'Kitten',
  ]),
  Fact(_g1, _g2, 'What does a seed need to sprout?', '🌱', 'Water and warmth', [
    'Ice and darkness',
    'Sugar',
    'Noise',
  ]),
  Fact(_g1, _g2, 'Plant: seed → sprout → ? → flower', '🌻', 'Young plant', [
    'Egg',
    'Pupa',
    'Tadpole',
  ]),
  Fact(_g2, _g3, 'Which baby is born alive, not from an egg?', '🍼', 'Puppy', [
    'Chick',
    'Turtle',
    'Frog',
  ]),
  Fact(_g1, _g3, 'Which animal hatches from an egg?', '🥚', 'Turtle', [
    'Dog',
    'Horse',
    'Cow',
  ]),
  Fact(_g3, _g3, 'Ladybug: egg → larva → pupa → ?', '🐞', 'Adult ladybug', [
    'Tadpole',
    'Seed',
    'Caterpillar',
  ]),
  Fact(
    _g3,
    _g3,
    'A big change in body shape, like tadpole to frog, is called…',
    '🐸',
    'Metamorphosis',
    ['Migration', 'Hibernation', 'Pollination'],
  ),
  Fact(
    _g3,
    _g3,
    'Traits like fur color passed from parents to babies are…',
    '🐈',
    'Inherited traits',
    ['Habitats', 'Seasons', 'Fossils'],
  ),
];

const _matterBase = [
  Fact(_g1, _g3, 'Ice is a…', '🧊', 'Solid', ['Liquid', 'Gas']),
  Fact(_g1, _g2, 'Water is a…', '💧', 'Liquid', ['Solid', 'Gas']),
  Fact(_g1, _g3, 'Steam from a kettle is a…', '♨️', 'Gas', ['Solid', 'Liquid']),
  Fact(_g1, _g2, 'What happens to ice left in the sun?', '🧊', 'It melts', [
    'It grows',
    'It freezes',
  ]),
  Fact(_g1, _g3, 'Water turns into ice when it…', '❄️', 'Freezes', [
    'Boils',
    'Melts',
  ]),
  Fact(_g1, _g1, 'Which one is a liquid?', '🥛', 'Milk', ['Brick', 'Spoon']),
  Fact(_g2, _g4, 'Which state of matter keeps its own shape?', '🧱', 'Solid', [
    'Liquid',
    'Gas',
  ]),
  Fact(
    _g2,
    _g4,
    'A puddle dries up on a sunny day because the water…',
    '☀️',
    'Evaporates',
    ['Freezes', 'Melts', 'Sinks'],
  ),
  Fact(
    _g3,
    _g5,
    'Water vapor turning back into drops is called…',
    '💧',
    'Condensation',
    ['Evaporation', 'Melting', 'Freezing'],
  ),
  Fact(_g3, _g5, 'At what temperature does water boil?', '♨️', '100 °C', [
    '0 °C',
    '50 °C',
    '10 °C',
  ]),
  Fact(_g3, _g5, 'At what temperature does water freeze?', '❄️', '0 °C', [
    '100 °C',
    '50 °C',
    '20 °C',
  ]),
  Fact(
    _g3,
    _g5,
    'Anything that has mass and takes up space is…',
    '⚖️',
    'Matter',
    ['Energy', 'Light', 'Sound'],
  ),
  Fact(
    _g3,
    _g5,
    'Which state of matter spreads out to fill any container?',
    '🎈',
    'Gas',
    ['Solid', 'Liquid'],
  ),
  Fact(
    _g4,
    _g5,
    'Salt stirred into water until you can\'t see it makes a…',
    '🧂',
    'Solution',
    ['Solid', 'Rock', 'Gas'],
  ),
  Fact(_g4, _g5, 'Sand and water stirred together make a…', '🏖️', 'Mixture', [
    'Solution',
    'Gas',
    'Metal',
  ]),
  Fact(
    _g5,
    _g5,
    'The tiny particles that make up all matter are…',
    '⚛️',
    'Atoms',
    ['Cells', 'Pixels', 'Seeds'],
  ),
  Fact(_g5, _g5, 'Rust forming on a bike is a…', '🚲', 'Chemical change', [
    'Physical change',
    'State change',
    'Melting',
  ]),
  Fact(_g5, _g5, 'Cutting paper into pieces is a…', '✂️', 'Physical change', [
    'Chemical change',
    'Burning',
    'Rusting',
  ]),
];

const _spaceBase = [
  Fact(_g1, _g3, 'What is the Sun?', '☀️', 'A star', ['A planet', 'A moon']),
  Fact(_g1, _g2, 'Which planet do we live on?', '🌍', 'Earth', [
    'Mars',
    'Jupiter',
  ]),
  Fact(_g1, _g3, 'The Moon travels around the…', '🌙', 'Earth', [
    'Mars',
    'Stars',
  ]),
  Fact(_g1, _g1, 'What twinkles in the night sky?', '✨', 'Stars', [
    'Rainbows',
    'Clouds',
  ]),
  Fact(_g1, _g2, 'A person who travels into space is an…', '🚀', 'Astronaut', [
    'Farmer',
    'Chef',
  ]),
  Fact(
    _g2,
    _g3,
    'The Sun is the star at the center of our…',
    '☀️',
    'Solar system',
    ['Ocean', 'Moon', 'Garden'],
  ),
  Fact(_g2, _g5, 'Which planet is the biggest?', '🪐', 'Jupiter', [
    'Earth',
    'Mars',
    'Mercury',
  ]),
  Fact(_g2, _g5, 'Which planet is called the Red Planet?', '🔴', 'Mars', [
    'Venus',
    'Saturn',
    'Neptune',
  ]),
  Fact(_g2, _g4, 'Which planet has big, bright rings?', '🪐', 'Saturn', [
    'Mars',
    'Earth',
    'Venus',
  ]),
  Fact(_g3, _g5, 'Which planet is closest to the Sun?', '☀️', 'Mercury', [
    'Earth',
    'Neptune',
    'Jupiter',
  ]),
  Fact(
    _g3,
    _g5,
    'How long does Earth take to travel around the Sun?',
    '🌍',
    'One year',
    ['One day', 'One week', 'One hour'],
  ),
  Fact(
    _g3,
    _g5,
    'We have day and night because Earth…',
    '🌓',
    'Spins on its axis',
    ['Moves closer to the Sun', 'Gets cloudy', 'Changes size'],
  ),
  Fact(_g3, _g5, 'How many planets are in our solar system?', '🔭', '8', [
    '9',
    '6',
    '12',
  ]),
  Fact(
    _g3,
    _g5,
    'The changing shapes of the Moon are called…',
    '🌗',
    'Phases',
    ['Seasons', 'Orbits', 'Tides'],
  ),
  Fact(
    _g4,
    _g5,
    'The force that keeps planets circling the Sun is…',
    '🌌',
    'Gravity',
    ['Magnetism', 'Friction', 'Wind'],
  ),
  Fact(
    _g4,
    _g5,
    'A group of stars that forms a picture is a…',
    '✨',
    'Constellation',
    ['Galaxy', 'Comet', 'Planet'],
  ),
  Fact(_g4, _g5, 'Our galaxy is called the…', '🌌', 'Milky Way', [
    'Big Dipper',
    'Star Road',
    'Solar Wind',
  ]),
];

const _humanBodyBase = [
  Fact(_g1, _g5, 'Which organ pumps blood around your body?', '❤️', 'Heart', [
    'Lungs',
    'Stomach',
    'Brain',
  ]),
  Fact(_g1, _g5, 'Which organs help you breathe?', '🌬️', 'Lungs', [
    'Heart',
    'Bones',
    'Kidneys',
  ]),
  Fact(_g1, _g3, 'Which organ do you think with?', '🧠', 'Brain', [
    'Heart',
    'Stomach',
  ]),
  Fact(_g1, _g3, 'Muscles help us…', '💪', 'Move', ['Sleep', 'See']),
  Fact(
    _g1,
    _g3,
    'Which foods help build strong bones?',
    '🥛',
    'Milk and cheese',
    ['Candy', 'Chips'],
  ),
  Fact(
    _g1,
    _g2,
    'Germs on your hands are washed off with…',
    '🧼',
    'Soap and water',
    ['Juice', 'Paint'],
  ),
  Fact(_g2, _g4, 'Where does food go after you swallow it?', '🍎', 'Stomach', [
    'Lungs',
    'Brain',
    'Heart',
  ]),
  Fact(_g2, _g5, 'Which bones protect your brain?', '🧠', 'Skull', [
    'Ribs',
    'Knees',
    'Toes',
  ]),
  Fact(_g2, _g4, 'Your ribs protect your heart and…', '🦴', 'Lungs', [
    'Feet',
    'Eyes',
    'Hair',
  ]),
  Fact(_g3, _g5, 'About how many bones does an adult have?', '🦴', '206', [
    '12',
    '50',
    '1,000',
  ]),
  Fact(
    _g3,
    _g5,
    'We breathe in oxygen and breathe out…',
    '🌬️',
    'Carbon dioxide',
    ['Helium', 'Smoke', 'Steam'],
  ),
  Fact(
    _g4,
    _g5,
    'The body system that breaks down food is the…',
    '🍽️',
    'Digestive system',
    ['Skeletal system', 'Nervous system', 'Respiratory system'],
  ),
  Fact(
    _g4,
    _g5,
    'Nerves carry messages between your body and your…',
    '🧠',
    'Brain',
    ['Stomach', 'Bones', 'Hair'],
  ),
  Fact(_g4, _g5, 'The largest organ of the human body is the…', '✋', 'Skin', [
    'Heart',
    'Liver',
    'Brain',
  ]),
  Fact(
    _g5,
    _g5,
    'Blood vessels that carry blood away from the heart are…',
    '❤️',
    'Arteries',
    ['Veins', 'Nerves', 'Tendons'],
  ),
];

const _earthBase = [
  Fact(
    _g2,
    _g4,
    'Hot melted rock that flows out of a volcano is…',
    '🌋',
    'Lava',
    ['Ice', 'Sand', 'Mud'],
  ),
  Fact(_g2, _g4, 'Most of Earth\'s surface is covered by…', '🌊', 'Water', [
    'Sand',
    'Ice',
    'Grass',
  ]),
  Fact(
    _g2,
    _g4,
    'Remains of ancient plants and animals found in rock are…',
    '🦕',
    'Fossils',
    ['Crystals', 'Planets', 'Seeds'],
  ),
  Fact(_g2, _g4, 'A sudden shaking of the ground is an…', '🏚️', 'Earthquake', [
    'Eclipse',
    'Rainbow',
    'Echo',
  ]),
  Fact(
    _g2,
    _g5,
    'Water evaporates, forms clouds and falls as rain. This is the…',
    '🌧️',
    'Water cycle',
    ['Life cycle', 'Food chain', 'Moon cycle'],
  ),
  Fact(_g2, _g4, 'Recycling helps the Earth by…', '♻️', 'Reducing waste', [
    'Making more trash',
    'Using more oil',
    'Cutting more trees',
  ]),
  Fact(
    _g3,
    _g5,
    'Wind and water slowly wearing away rock is called…',
    '🏜️',
    'Erosion',
    ['Freezing', 'Growing', 'Melting'],
  ),
  Fact(
    _g3,
    _g5,
    'Rain, snow, sleet and hail are all kinds of…',
    '🌨️',
    'Precipitation',
    ['Evaporation', 'Erosion', 'Condensation'],
  ),
  Fact(_g3, _g5, 'Which of these is a renewable resource?', '☀️', 'Sunlight', [
    'Coal',
    'Oil',
    'Natural gas',
  ]),
  Fact(_g4, _g5, 'Which layer of Earth do we live on?', '🌍', 'Crust', [
    'Core',
    'Mantle',
  ]),
  Fact(_g4, _g5, 'The very center of the Earth is the…', '🌍', 'Core', [
    'Crust',
    'Ocean',
    'Mantle',
  ]),
  Fact(_g4, _g5, 'Rock formed when lava cools is…', '🌋', 'Igneous rock', [
    'Sedimentary rock',
    'Metamorphic rock',
  ]),
  Fact(
    _g4,
    _g5,
    'Rock made from layers of sand and mud pressed together is…',
    '🏜️',
    'Sedimentary rock',
    ['Igneous rock', 'Metamorphic rock'],
  ),
  Fact(_g4, _g5, 'Which tool measures wind speed?', '🌬️', 'Anemometer', [
    'Thermometer',
    'Ruler',
    'Scale',
  ]),
  Fact(
    _g4,
    _g5,
    'The layer of air around the Earth is the…',
    '🌍',
    'Atmosphere',
    ['Crust', 'Ocean', 'Core'],
  ),
];

const _forceBase = [
  Fact(_g2, _g4, 'A magnet will pick up a…', '🧲', 'Paper clip', [
    'Wooden spoon',
    'Rubber band',
    'Paper cup',
  ]),
  Fact(_g2, _g3, 'Opening a drawer toward you is a…', '🗄️', 'Pull', [
    'Push',
    'Spin',
  ]),
  Fact(_g2, _g3, 'Kicking a ball is a…', '⚽', 'Push', ['Pull', 'Twist']),
  Fact(
    _g2,
    _g5,
    'Which force pulls things down to the ground?',
    '🍎',
    'Gravity',
    ['Friction', 'Wind', 'Magnetism'],
  ),
  Fact(_g2, _g4, 'Sound is made when things…', '🥁', 'Vibrate', [
    'Melt',
    'Freeze',
    'Glow',
  ]),
  Fact(
    _g2,
    _g4,
    'A shadow forms when light is…',
    '🔦',
    'Blocked by an object',
    ['Made brighter', 'Turned into sound', 'Frozen'],
  ),
  Fact(_g2, _g3, 'Which of these uses electricity?', '🔌', 'Lamp', [
    'Book',
    'Spoon',
    'Pillow',
  ]),
  Fact(
    _g3,
    _g5,
    'A rough surface slows a moving object because of…',
    '🛹',
    'Friction',
    ['Gravity', 'Magnetism', 'Light'],
  ),
  Fact(_g3, _g5, 'Light travels in…', '🔦', 'Straight lines', [
    'Circles',
    'Zigzags',
    'Spirals',
  ]),
  Fact(_g3, _g5, 'Energy from the Sun is called…', '☀️', 'Solar energy', [
    'Wind energy',
    'Sound energy',
    'Nuclear energy',
  ]),
  Fact(
    _g3,
    _g5,
    'Ramps, levers and pulleys are all…',
    '🛠️',
    'Simple machines',
    ['Magnets', 'Circuits', 'Planets'],
  ),
  Fact(
    _g3,
    _g5,
    'Two magnet ends that are the same will…',
    '🧲',
    'Push apart',
    ['Pull together', 'Melt', 'Glow'],
  ),
  Fact(
    _g3,
    _g5,
    'A rainbow appears when sunlight is split by…',
    '🌈',
    'Raindrops',
    ['Wind', 'Smoke', 'Rocks'],
  ),
  Fact(
    _g4,
    _g5,
    'A closed path that electricity flows around is a…',
    '🔋',
    'Circuit',
    ['Magnet', 'Prism', 'Lever'],
  ),
  Fact(
    _g4,
    _g5,
    'Materials that let electricity flow easily are…',
    '⚡',
    'Conductors',
    ['Insulators', 'Magnets', 'Liquids'],
  ),
  Fact(
    _g4,
    _g5,
    'A rolling ball has which kind of energy?',
    '🎳',
    'Kinetic energy',
    ['Potential energy', 'Chemical energy', 'Sound energy'],
  ),
];

const _ecosystemBase = [
  Fact(
    _g3,
    _g5,
    'Plants are called producers because they…',
    '🌱',
    'Make their own food',
    ['Eat other animals', 'Break down dead things', 'Hunt for food'],
  ),
  Fact(_g3, _g5, 'An animal that eats only plants is a…', '🐄', 'Herbivore', [
    'Carnivore',
    'Omnivore',
  ]),
  Fact(_g3, _g5, 'An animal that eats only meat is a…', '🦁', 'Carnivore', [
    'Herbivore',
    'Producer',
  ]),
  Fact(
    _g3,
    _g5,
    'An animal that eats both plants and meat is an…',
    '🐻',
    'Omnivore',
    ['Herbivore', 'Carnivore'],
  ),
  Fact(_g3, _g5, 'In a food chain, energy first comes from the…', '☀️', 'Sun', [
    'Moon',
    'Wind',
    'Soil',
  ]),
  Fact(_g3, _g5, 'An animal that hunts other animals is a…', '🦅', 'Predator', [
    'Prey',
    'Producer',
    'Decomposer',
  ]),
  Fact(
    _g3,
    _g5,
    'A camel\'s hump and long eyelashes help it live in the…',
    '🐪',
    'Desert',
    ['Arctic', 'Ocean', 'Rainforest'],
  ),
  Fact(
    _g3,
    _g5,
    'Thick fur and fat help polar bears survive in the…',
    '🧊',
    'Arctic',
    ['Desert', 'Jungle', 'Grassland'],
  ),
  Fact(
    _g3,
    _g4,
    'Grass → rabbit → fox. What does the rabbit eat?',
    '🐰',
    'Grass',
    ['Fox', 'Sunlight', 'Rocks'],
  ),
  Fact(_g3, _g4, 'The natural home of an animal is its…', '🏞️', 'Habitat', [
    'Hobby',
    'Shadow',
    'Habit',
  ]),
  Fact(
    _g3,
    _g5,
    'Birds flying south for the winter is called…',
    '🦢',
    'Migration',
    ['Hibernation', 'Pollination'],
  ),
  Fact(
    _g3,
    _g5,
    'Bears resting through the winter is called…',
    '🐻',
    'Hibernation',
    ['Migration', 'Evaporation'],
  ),
  Fact(
    _g4,
    _g5,
    'Mushrooms and worms that break down dead things are…',
    '🍄',
    'Decomposers',
    ['Producers', 'Predators', 'Herbivores'],
  ),
  Fact(
    _g4,
    _g5,
    'A body feature that helps an animal survive is an…',
    '🦎',
    'Adaptation',
    ['Invention', 'Emotion', 'Opinion'],
  ),
  Fact(
    _g4,
    _g5,
    'An animal that no longer lives anywhere on Earth is…',
    '🦖',
    'Extinct',
    ['Endangered', 'Hibernating', 'Migrating'],
  ),
];

/// (emoji, animal, sound)
const _animalSoundsBase = [
  ('🐮', 'cow', 'moo'),
  ('🐶', 'dog', 'woof woof'),
  ('🐱', 'cat', 'meow'),
  ('🦆', 'duck', 'quack quack'),
  ('🐑', 'sheep', 'baa'),
  ('🐷', 'pig', 'oink oink'),
  ('🦁', 'lion', 'roar'),
  ('🐴', 'horse', 'neigh'),
  ('🐸', 'frog', 'ribbit'),
  ('🦉', 'owl', 'hoo hoo'),
  ('🐝', 'bee', 'buzz'),
  ('🐓', 'rooster', 'cock-a-doodle-doo'),
  ('🐍', 'snake', 'hiss'),
  ('🐭', 'mouse', 'squeak'),
];

/// (emoji, name, floats?)
const _sinkFloatItemsBase = [
  ('🦆', 'rubber duck', true),
  ('🧱', 'brick', false),
  ('🍃', 'leaf', true),
  ('🔑', 'key', false),
  ('⚓', 'anchor', false),
  ('🎈', 'balloon', true),
  ('🍎', 'apple', true),
  ('🥄', 'spoon', false),
  ('🧽', 'sponge', true),
  ('🏀', 'ball', true),
  ('🔨', 'hammer', false),
  ('⛵', 'boat', true),
  ('💍', 'ring', false),
  ('🍌', 'banana', true),
  ('🔩', 'bolt', false),
];

/// (emoji, name, living?)
const _livingItemsBase = [
  ('🐶', 'dog', true),
  ('🌳', 'tree', true),
  ('🌻', 'sunflower', true),
  ('🐟', 'fish', true),
  ('🐛', 'caterpillar', true),
  ('🍄', 'mushroom', true),
  ('🐦', 'bird', true),
  ('🌵', 'cactus', true),
  ('👶', 'baby', true),
  ('⚽', 'ball', false),
  ('🚗', 'car', false),
  ('🧸', 'teddy bear', false),
  ('🪑', 'chair', false),
  ('📱', 'phone', false),
  ('🧱', 'brick', false),
  ('✏️', 'pencil', false),
  ('☁️', 'cloud', false),
  ('💧', 'water drop', false),
];

/// (emoji, animal, group)
const _animalGroupItemsBase = [
  ('🐶', 'dog', 'Mammal'),
  ('🐘', 'elephant', 'Mammal'),
  ('🐋', 'whale', 'Mammal'),
  ('🦇', 'bat', 'Mammal'),
  ('🐒', 'monkey', 'Mammal'),
  ('🐧', 'penguin', 'Bird'),
  ('🦉', 'owl', 'Bird'),
  ('🦅', 'eagle', 'Bird'),
  ('🦜', 'parrot', 'Bird'),
  ('🐟', 'fish', 'Fish'),
  ('🦈', 'shark', 'Fish'),
  ('🐠', 'clownfish', 'Fish'),
  ('🐍', 'snake', 'Reptile'),
  ('🐢', 'turtle', 'Reptile'),
  ('🐊', 'crocodile', 'Reptile'),
  ('🦎', 'lizard', 'Reptile'),
  ('🐸', 'frog', 'Amphibian'),
  ('🐝', 'bee', 'Insect'),
  ('🐞', 'ladybug', 'Insect'),
  ('🐜', 'ant', 'Insect'),
  ('🦋', 'butterfly', 'Insect'),
];

/// (animal emoji, animal, home, home emoji)
const _animalHomesBase = [
  ('🐝', 'Bee', 'Hive', '🍯'),
  ('🐦', 'Bird', 'Nest', '🌳'),
  ('🐟', 'Fish', 'Ocean', '🌊'),
  ('🐄', 'Cow', 'Barn', '🌾'),
  ('🐻', 'Bear', 'Cave', '⛰️'),
  ('🐸', 'Frog', 'Pond', '💧'),
  ('🐕', 'Dog', 'Kennel', '🏠'),
  ('🐰', 'Rabbit', 'Burrow', '🕳️'),
  ('🕷️', 'Spider', 'Web', '🕸️'),
  ('🐒', 'Monkey', 'Jungle', '🌴'),
  ('🐧', 'Penguin', 'Ice', '🧊'),
  ('🐪', 'Camel', 'Desert', '🏜️'),
];

/// (parent emoji, parent, baby)
const _babyAnimalsBase = [
  ('🐄', 'Cow', 'Calf'),
  ('🐕', 'Dog', 'Puppy'),
  ('🐈', 'Cat', 'Kitten'),
  ('🐔', 'Hen', 'Chick'),
  ('🐑', 'Sheep', 'Lamb'),
  ('🐸', 'Frog', 'Tadpole'),
  ('🐴', 'Horse', 'Foal'),
  ('🦆', 'Duck', 'Duckling'),
  ('🐻', 'Bear', 'Cub'),
  ('🐐', 'Goat', 'Kid'),
  ('🦘', 'Kangaroo', 'Joey'),
  ('🐖', 'Pig', 'Piglet'),
];

// ---------------------------------------------------------------------------
// TEMPORARY public names (added by the lead after the science agent was cut
// off by a usage limit). They point at the existing content so the app builds.
// When the science work resumes, replace these with the expanded banks.
const myBodyFacts = _myBodyBase;
const weatherFacts = _weatherBase;
const plantFacts = _plantBase;
const lifeCycleFacts = _lifeCycleBase;
const matterFacts = _matterBase;
const spaceFacts = _spaceBase;
const humanBodyFacts = _humanBodyBase;
const earthFacts = _earthBase;
const forceFacts = _forceBase;
const ecosystemFacts = _ecosystemBase;
const animalSounds = _animalSoundsBase;
const sinkFloatItems = _sinkFloatItemsBase;
const livingItems = _livingItemsBase;
const animalGroupItems = _animalGroupItemsBase;
const animalHomes = _animalHomesBase;
const babyAnimals = _babyAnimalsBase;
