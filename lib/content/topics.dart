import 'package:flutter/painting.dart' show Color;

import '../theme.dart';

class TopicItem {
  const TopicItem(
    this.name,
    this.emoji,
    this.fact, {
    this.picture,
    this.from,
  });
  final String name;

  /// The topic this item was borrowed from, when it appears in a mixed
  /// topic (e.g. today's toddler "Animals"), so its real photo is found.
  final String? from;

  /// The main picture — or, for letters and numbers, the character itself
  /// (shown big as text when there's no drawing for it).
  final String emoji;

  /// An extra picture shown with the fact, e.g. 🍎 for "A is for apple".
  final String? picture;

  /// A short, kid-friendly fact. It does not mention [name], so it can be
  /// used as a "Who am I?" clue in the quiz.
  final String fact;
}

class Topic {
  const Topic(
    this.id,
    this.title,
    this.emoji,
    this.color,
    this.kindOf,
    this.items, {
    this.pictureQuiz = true,
    this.toddlerOnly = false,
  });
  final String id;
  final String title;
  final String emoji;
  final Color color;

  /// What one item is, e.g. "planet" → "Which one is NOT a planet?"
  final String kindOf;
  final List<TopicItem> items;

  /// Whether the pictures alone identify each item (false for planets,
  /// whose pictures are just coloured circles).
  final bool pictureQuiz;

  /// Learning sessions just for Age 2–3 (letters and numbers), not part of
  /// the daily rotation for older children or the sticker book.
  final bool toddlerOnly;
}

typedef T = TopicItem;

const topics = [
  Topic('farm', 'Farm Animals', '🚜', AppColors.lime, 'farm animal', [
    T('Cow', '🐮', 'I give milk and say "moo".'),
    T('Pig', '🐷', 'I roll in mud to stay cool.'),
    T('Sheep', '🐑', 'My woolly coat is used to make sweaters.'),
    T('Horse', '🐴', 'I can run fast and sleep standing up.'),
    T('Chicken', '🐔', 'I lay eggs and say "cluck cluck".'),
    T('Duck', '🦆', 'I have webbed feet for swimming in the pond.'),
    T('Goat', '🐐', 'I love to climb and I have a little beard.'),
    T('Rabbit', '🐰', 'I have long ears and love to hop.'),
    T('Turkey', '🦃', 'I gobble and have colorful tail feathers.'),
    T('Dog', '🐕', 'I help the farmer herd the sheep.'),
    T('Cat', '🐈', 'I catch mice in the barn.'),
  ]),
  Topic('wild', 'Wild Animals', '🦁', AppColors.sunshine, 'wild animal', [
    T('Lion', '🦁', 'I am called the king of the jungle and I roar loudly.'),
    T('Tiger', '🐯', 'I have orange fur with black stripes.'),
    T(
      'Elephant',
      '🐘',
      'I am the biggest land animal and I have a long trunk.',
    ),
    T('Giraffe', '🦒', 'I am the tallest animal, with a very long neck.'),
    T('Zebra', '🦓', 'I look like a horse with black and white stripes.'),
    T('Monkey', '🐒', 'I swing from tree to tree and love bananas.'),
    T('Gorilla', '🦍', 'I am the largest ape and I beat my chest.'),
    T('Hippo', '🦛', 'I spend most of the day in rivers to stay cool.'),
    T('Rhino', '🦏', 'I have thick skin and a big horn on my nose.'),
    T('Kangaroo', '🦘', 'I hop on strong legs and carry my baby in a pouch.'),
    T('Panda', '🐼', 'I am black and white and I eat bamboo.'),
    T('Bear', '🐻', 'I sleep through the cold winter in a den.'),
  ]),
  Topic('ocean', 'Ocean Animals', '🌊', AppColors.sky, 'sea animal', [
    T('Whale', '🐋', 'I am the biggest animal on Earth and I breathe air.'),
    T('Dolphin', '🐬', 'I am very smart and talk with clicks and whistles.'),
    T('Shark', '🦈', 'I have many rows of sharp teeth.'),
    T('Octopus', '🐙', 'I have eight arms and can squirt ink.'),
    T('Crab', '🦀', 'I walk sideways and have two big claws.'),
    T('Shrimp', '🦐', 'I am small and swim backward to escape danger.'),
    T('Squid', '🦑', 'I have ten arms and a long, soft body.'),
    T('Sea Turtle', '🐢', 'I swim far and lay my eggs on the beach.'),
    T('Clownfish', '🐠', 'I am orange and white and live in a sea anemone.'),
    T('Lobster', '🦞', 'I have a hard shell and big pincers.'),
    T('Fish', '🐟', 'I breathe underwater using gills.'),
  ]),
  Topic('colors', 'Colors', '🎨', AppColors.bubblegum, 'color', [
    T('Red', '🔴', 'Strawberries and fire trucks are this color.'),
    T('Orange', '🟠', 'Pumpkins and carrots are this color.'),
    T('Yellow', '🟡', 'The sun and bananas are this color.'),
    T('Green', '🟢', 'Grass and leaves are this color.'),
    T('Blue', '🔵', 'The sky and the ocean are this color.'),
    T('Purple', '🟣', 'Grapes and eggplants are this color.'),
    T('Brown', '🟤', 'Chocolate and tree trunks are this color.'),
    T('Black', '⚫', 'The night sky is this color.'),
    T('White', '⚪', 'Snow and clouds are this color.'),
    T('Pink', '🌸', 'Flamingos and cherry blossoms are this color.'),
  ]),
  Topic('space', 'Planets & Space', '🪐', AppColors.grape, 'planet', [
    T('Sun', '☀️', 'I am a star at the center of our solar system.'),
    T(
      'Mercury',
      'pic:mercury',
      'I am the smallest planet and the closest to the Sun.',
    ),
    T(
      'Venus',
      'pic:venus',
      'I am the hottest planet, covered in thick clouds.',
    ),
    T('Earth', '🌍', 'I am the only planet we know with living things.'),
    T(
      'Mars',
      'pic:mars',
      'I am called the Red Planet because of my rusty dust.',
    ),
    T(
      'Jupiter',
      'pic:jupiter',
      'I am the biggest planet and have a giant red storm.',
    ),
    T('Saturn', '🪐', 'I have beautiful rings made of ice and rock.'),
    T('Uranus', 'pic:uranus', 'I spin on my side and look blue-green.'),
    T('Neptune', 'pic:neptune', 'I am the farthest planet and the windiest.'),
    T('Moon', '🌙', 'I travel around Earth and change shape each night.'),
  ]),
  Topic(
    'countries',
    'Countries of the World',
    '🌍',
    AppColors.tangerine,
    'country',
    [
      T('India', '🇮🇳', 'My capital is New Delhi and the Taj Mahal is here.'),
      T(
        'United States',
        '🇺🇸',
        'My capital is Washington, D.C., and I have 50 states.',
      ),
      T('United Kingdom', '🇬🇧', 'My capital is London, home of Big Ben.'),
      T(
        'Japan',
        '🇯🇵',
        'My capital is Tokyo and Mount Fuji is my tallest mountain.',
      ),
      T('China', '🇨🇳', 'My capital is Beijing and the Great Wall is here.'),
      T(
        'Brazil',
        '🇧🇷',
        'My capital is Brasília and much of the Amazon rainforest is here.',
      ),
      T(
        'Egypt',
        '🇪🇬',
        'My capital is Cairo and the ancient pyramids are here.',
      ),
      T('Australia', '🇦🇺', 'My capital is Canberra and kangaroos live here.'),
      T(
        'Canada',
        '🇨🇦',
        'My capital is Ottawa and a maple leaf is on my flag.',
      ),
      T(
        'Mexico',
        '🇲🇽',
        'My capital is Mexico City and the Maya built pyramids here.',
      ),
      T('France', '🇫🇷', 'My capital is Paris, home of the Eiffel Tower.'),
      T('Kenya', '🇰🇪', 'My capital is Nairobi and lions roam my savanna.'),
    ],
  ),
  Topic('body', 'My Body', '🧒', AppColors.bubblegum, 'body part', [
    T('Eyes', '👀', 'We use these to see colors and shapes.'),
    T('Ears', '👂', 'We use these to hear music and voices.'),
    T('Nose', '👃', 'We use this to smell flowers and food.'),
    T('Mouth', '👄', 'We use this to eat, talk and smile.'),
    T('Tongue', '👅', 'We use this to taste sweet and sour things.'),
    T('Teeth', '🦷', 'We use these to bite and chew. Brush them twice a day!'),
    T('Hand', '✋', 'Each one has five fingers for holding and waving.'),
    T('Foot', '🦶', 'Each one has five toes and helps us walk.'),
    T(
      'Brain',
      '🧠',
      'It is inside your head and helps you think and remember.',
    ),
    T('Bones', '🦴', 'They are hard and strong, and hold your body up.'),
    T('Leg', '🦵', 'We use these to run, jump and kick.'),
    T('Muscles', '💪', 'They pull on bones so we can move and lift.'),
  ]),
  Topic('fruits', 'Fruits', '🍓', AppColors.bubblegum, 'fruit', [
    T('Apple', '🍎', 'I am crunchy and can be red, green or yellow.'),
    T('Banana', '🍌', 'I am long and yellow, and monkeys love me.'),
    T('Grapes', '🍇', 'I grow in bunches and can be dried into raisins.'),
    T('Strawberry', '🍓', 'I am red and have tiny seeds on the outside.'),
    T('Orange', '🍊', 'I am juicy and full of vitamin C.'),
    T('Watermelon', '🍉', 'I am green outside, red inside and full of water.'),
    T('Pineapple', '🍍', 'I am spiky outside and sweet inside.'),
    T('Mango', '🥭', 'I am sweet and orange inside, with one big seed.'),
    T('Cherries', '🍒', 'We are small and red and grow in pairs on stems.'),
    T('Pear', '🍐', 'I am shaped like a bell and very juicy.'),
    T('Lemon', '🍋', 'I am yellow and taste very sour.'),
    T('Kiwi', '🥝', 'I am brown and fuzzy outside, green inside.'),
  ]),
  Topic('veggies', 'Vegetables', '🥕', AppColors.lime, 'vegetable', [
    T('Carrot', '🥕', 'I am orange and grow under the ground.'),
    T('Broccoli', '🥦', 'I look like a tiny green tree.'),
    T('Corn', '🌽', 'I have rows of yellow kernels and can become popcorn.'),
    T(
      'Potato',
      '🥔',
      'I grow underground and can be mashed or made into fries.',
    ),
    T(
      'Cucumber',
      '🥒',
      'I am long, green and crunchy, and can become a pickle.',
    ),
    T('Eggplant', '🍆', 'I am purple and shiny.'),
    T('Chili Pepper', '🌶️', 'I am small and very spicy.'),
    T('Onion', '🧅', 'I have many layers and can make you cry when cut.'),
    T('Garlic', '🧄', 'I have a strong smell and grow in cloves.'),
    T('Lettuce', '🥬', 'My green leaves are used to make salad.'),
    T('Sweet Potato', '🍠', 'I am orange inside and taste a little sweet.'),
  ]),
  Topic('vehicles', 'Things That Go', '🚗', AppColors.sky, 'vehicle', [
    T('Car', '🚗', 'Families ride in me on roads.'),
    T('Bus', '🚌', 'I carry lots of people, like kids going to school.'),
    T('Train', '🚆', 'I run on tracks and pull many cars.'),
    T('Airplane', '✈️', 'I fly people high in the sky across the world.'),
    T('Helicopter', '🚁', 'My spinning blades let me fly straight up.'),
    T('Sailboat', '⛵', 'The wind pushes my sails across the water.'),
    T('Ship', '🚢', 'I am a giant boat that crosses oceans.'),
    T('Bicycle', '🚲', 'I have two wheels and you push my pedals.'),
    T('Fire Truck', '🚒', 'I carry ladders and hoses to put out fires.'),
    T('Ambulance', '🚑', 'I rush sick or hurt people to the hospital.'),
    T('Tractor', '🚜', 'Farmers use me to pull plows in the fields.'),
    T('Rocket', '🚀', 'I blast off into space.'),
  ]),
  Topic('bugs', 'Bugs & Crawlies', '🐞', AppColors.mint, 'bug', [
    T('Bee', '🐝', 'I make honey and help flowers grow.'),
    T('Ladybug', '🐞', 'I am red with black spots and eat tiny pests.'),
    T('Ant', '🐜', 'I am tiny but can carry things much heavier than me.'),
    T(
      'Butterfly',
      '🦋',
      'I was once a caterpillar and now I have colorful wings.',
    ),
    T('Caterpillar', '🐛', 'I munch leaves and will turn into a butterfly.'),
    T('Cricket', '🦗', 'I chirp by rubbing my wings together.'),
    T('Spider', '🕷️', 'I have eight legs and spin sticky webs.'),
    T('Snail', '🐌', 'I carry my shell house on my back and move slowly.'),
    T('Mosquito', '🦟', 'I buzz around and can give itchy bites.'),
    T('Scorpion', '🦂', 'I have pincers and a stinger on my curly tail.'),
  ]),
  Topic('birds', 'Birds', '🦜', AppColors.tangerine, 'bird', [
    T('Owl', '🦉', 'I stay awake at night and can turn my head far around.'),
    T('Eagle', '🦅', 'I have sharp eyes and fly high to hunt.'),
    T('Parrot', '🦜', 'I am colorful and can copy words people say.'),
    T('Penguin', '🐧', 'I cannot fly, but I am a great swimmer.'),
    T('Flamingo', '🦩', 'I am pink and often stand on one leg.'),
    T('Peacock', '🦚', 'I spread my huge, colorful tail feathers like a fan.'),
    T('Swan', '🦢', 'I am a white bird with a long, curved neck.'),
    T('Rooster', '🐓', 'I crow "cock-a-doodle-doo" in the morning.'),
    T('Dove', '🕊️', 'I am a white bird that stands for peace.'),
    T('Duck', '🦆', 'I quack and float on ponds.'),
    T('Turkey', '🦃', 'I gobble and have a red wattle under my beak.'),
  ]),
  Topic('sports', 'Sports', '⚽', AppColors.lime, 'sport', [
    T(
      'Soccer',
      '⚽',
      'Players kick a ball into a goal without using their hands.',
    ),
    T(
      'Basketball',
      '🏀',
      'Players bounce the ball and shoot it through a hoop.',
    ),
    T('Football', '🏈', 'Players carry an oval ball to the end zone.'),
    T('Baseball', '⚾', 'Players hit a ball with a bat and run around bases.'),
    T('Tennis', '🎾', 'Players hit a fuzzy ball over a net with rackets.'),
    T(
      'Volleyball',
      '🏐',
      'Players hit the ball over a high net with their hands.',
    ),
    T(
      'Table Tennis',
      '🏓',
      'Players hit a tiny ball across a table with paddles.',
    ),
    T('Badminton', '🏸', 'Players hit a feathered shuttlecock over a net.'),
    T('Cricket', '🏏', 'Players bowl a ball and bat to score runs.'),
    T('Ice Hockey', '🏒', 'Players skate on ice and hit a puck with sticks.'),
    T('Bowling', '🎳', 'Players roll a heavy ball to knock down pins.'),
    T(
      'Golf',
      '⛳',
      'Players hit a small ball into a hole with as few swings as possible.',
    ),
  ]),
  Topic('helpers', 'Community Helpers', '🏘️', AppColors.sky, 'helper', [
    T('Doctor', '🩺', 'I help sick people get better.'),
    T('Firefighter', '🚒', 'I put out fires and rescue people.'),
    T(
      'Police Officer',
      '👮',
      'I keep people safe and help when there is trouble.',
    ),
    T('Teacher', '📚', 'I help children learn to read, write and count.'),
    T('Chef', '🍳', 'I cook tasty meals in a kitchen.'),
    T('Farmer', '🌾', 'I grow crops and raise animals for food.'),
    T('Mail Carrier', '📬', 'I deliver letters and packages.'),
    T('Builder', '🔨', 'I build houses, schools and bridges.'),
    T('Dentist', '🦷', 'I keep your teeth clean and healthy.'),
    T('Pilot', '✈️', 'I fly airplanes and take people on trips.'),
    T(
      'Scientist',
      '🔬',
      'I ask questions and do experiments to learn new things.',
    ),
    T('Artist', '🎨', 'I paint, draw and make beautiful things.'),
  ]),

  // ------------------------------------------------------------ geography
  Topic(
    'continents',
    'Continents & Oceans',
    '🌍',
    AppColors.sky,
    'continent or ocean',
    [
      T(
        'Asia',
        'pic:asia',
        'I am the biggest continent, and the most people live on me.',
      ),
      T(
        'Africa',
        'pic:africa',
        'Lions, elephants and giraffes live on me, and so does the Sahara desert.',
      ),
      T(
        'North America',
        'pic:north_america',
        'Canada, the United States and Mexico are on me.',
      ),
      T(
        'South America',
        'pic:south_america',
        'The Amazon rainforest and the Andes mountains are on me.',
      ),
      T(
        'Antarctica',
        'pic:antarctica',
        'I am the coldest place on Earth, covered in ice. Penguins live here.',
      ),
      T(
        'Europe',
        'pic:europe',
        'France, Italy and the United Kingdom are on me.',
      ),
      T(
        'Australia',
        'pic:australia',
        'Kangaroos and koalas live on me. I am the smallest continent.',
      ),
      T(
        'Pacific Ocean',
        'pic:pacific',
        'I am the biggest and deepest ocean on Earth.',
      ),
      T(
        'Atlantic Ocean',
        'pic:atlantic',
        'I lie between the Americas on one side and Europe and Africa on the other.',
      ),
      T(
        'Indian Ocean',
        'pic:indian',
        'I am the warmest ocean, and India is on my northern shore.',
      ),
      T(
        'Arctic Ocean',
        'pic:arctic',
        'I am the smallest ocean, around the North Pole. Polar bears hunt on my ice.',
      ),
      T(
        'Southern Ocean',
        'pic:southern',
        'I go all the way around Antarctica.',
      ),
    ],
  ),
  Topic('land', 'Land & Water', '🏔️', AppColors.lime, 'landform', [
    T(
      'Mountain',
      '🏔️',
      'I am very tall land with a pointy top. Some of me have snow on top.',
    ),
    T('Volcano', '🌋', 'Hot melted rock called lava can come out of my top.'),
    T('Island', '🏝️', 'I am land with water all around me.'),
    T('Desert', '🏜️', 'I am very dry land that gets very little rain.'),
    T(
      'River',
      'pic:river',
      'I am fresh water that flows across the land to the sea.',
    ),
    T('Lake', 'pic:lake', 'I am a big pool of water with land all around me.'),
    T('Waterfall', 'pic:waterfall', 'Water tumbles down a cliff over me.'),
    T('Forest', '🌲', 'I am land covered with lots and lots of trees.'),
    T('Beach', '🏖️', 'I am sandy land right next to the sea.'),
    T('Ocean', '🌊', 'I am a huge body of salty water.'),
    T(
      'Glacier',
      'pic:glacier',
      'I am a giant river of ice that moves very slowly.',
    ),
    T(
      'Cave',
      'pic:cave',
      'I am a big hollow space inside a hill or under the ground.',
    ),
  ]),

  // ------------------------------------------- just for Age 2–3
  Topic('abc1', 'Letters A to M', '🔤', AppColors.tangerine, 'letter', [
    T('A', 'A', 'A is for apple.', picture: '🍎'),
    T('B', 'B', 'B is for ball.', picture: '⚽'),
    T('C', 'C', 'C is for cat.', picture: '🐱'),
    T('D', 'D', 'D is for dog.', picture: '🐶'),
    T('E', 'E', 'E is for egg.', picture: '🥚'),
    T('F', 'F', 'F is for fish.', picture: '🐟'),
    T('G', 'G', 'G is for grapes.', picture: '🍇'),
    T('H', 'H', 'H is for hat.', picture: '🎩'),
    T('I', 'I', 'I is for ice.', picture: '🧊'),
    T('J', 'J', 'J is for juice.', picture: '🧃'),
    T('K', 'K', 'K is for key.', picture: '🔑'),
    T('L', 'L', 'L is for lion.', picture: '🦁'),
    T('M', 'M', 'M is for monkey.', picture: '🐒'),
  ], toddlerOnly: true),
  Topic('abc2', 'Letters N to Z', '🔠', AppColors.grape, 'letter', [
    T('N', 'N', 'N is for nose.', picture: '👃'),
    T('O', 'O', 'O is for octopus.', picture: '🐙'),
    T('P', 'P', 'P is for pig.', picture: '🐷'),
    T('Q', 'Q', 'Q is for queen.', picture: '👑'),
    T('R', 'R', 'R is for rainbow.', picture: '🌈'),
    T('S', 'S', 'S is for sun.', picture: '☀️'),
    T('T', 'T', 'T is for tiger.', picture: '🐯'),
    T('U', 'U', 'U is for umbrella.', picture: '☂️'),
    T('V', 'V', 'V is for violin.', picture: '🎻'),
    T('W', 'W', 'W is for watermelon.', picture: '🍉'),
    T('X', 'X', 'X is at the end of fox.', picture: '🦊'),
    T('Y', 'Y', 'Y is for yarn.', picture: '🧶'),
    T('Z', 'Z', 'Z is for zebra.', picture: '🦓'),
  ], toddlerOnly: true),
  Topic('numbers', 'Numbers 1 to 10', '🔢', AppColors.sky, 'number', [
    T('1', '1', 'One! Count with me: one.', picture: '🍎'),
    T('2', '2', 'Two! Count with me: one, two.', picture: '🐥🐥'),
    T('3', '3', 'Three! Count with me: one, two, three.', picture: '⭐⭐⭐'),
    T(
      '4',
      '4',
      'Four! Count with me: one, two, three, four.',
      picture: '🐞🐞🐞🐞',
    ),
    T(
      '5',
      '5',
      'Five! Count with me: one, two, three, four, five.',
      picture: '🚗🚗🚗🚗🚗',
    ),
    T(
      '6',
      '6',
      'Six! Count with me: one, two, three, four, five, six.',
      picture: '🎈🎈🎈🎈🎈🎈',
    ),
    T(
      '7',
      '7',
      'Seven! Count with me: one, two, three, four, five, six, seven.',
      picture: '🍓🍓🍓🍓🍓🍓🍓',
    ),
    T(
      '8',
      '8',
      'Eight! Count with me: one, two, three, four, five, six, seven, eight.',
      picture: '🐟🐟🐟🐟🐟🐟🐟🐟',
    ),
    T(
      '9',
      '9',
      'Nine! Count with me: one, two, three, four, five, six, seven, eight, nine.',
      picture: '🌸🌸🌸🌸🌸🌸🌸🌸🌸',
    ),
    T(
      '10',
      '10',
      'Ten! Count with me: one, two, three, four, five, six, seven, eight, nine, ten.',
      picture: '🍪🍪🍪🍪🍪🍪🍪🍪🍪🍪',
    ),
  ], toddlerOnly: true),
];
