// Older-grade depth for the learning topics.
//
// Pre-K and Kindergarten learn from the simple fact on each card. From
// Grade 2 each card also shows a "Did you know?" fact, and the quizzes for
// Grade 1 and up draw on harder, grade-ranged questions about the topic.

import '../models/models.dart';
import 'science.dart' show Fact;

const _g1 = Level.grade1,
    _g2 = Level.grade2,
    _g3 = Level.grade3,
    _g4 = Level.grade4,
    _g5 = Level.grade5;

/// Grade 2 and up: a second, deeper fact for each card. Like the simple
/// fact, it never names the item, so it also works as a "Who am I?" clue.
const deeperFacts = <String, Map<String, String>>{
  'farm': {
    'Cow':
        'I have one stomach split into four parts, and I chew my food twice.',
    'Pig': 'I roll in mud to keep cool because I cannot sweat much. I am very clever.',
    'Sheep':
        'My wool keeps growing all my life, so farmers shear it each year.',
    'Horse': 'I can sleep standing up, and my age can be told from my teeth.',
    'Chicken': 'My wild relatives come from the jungles of Asia. I can lay about one egg a day.',
    'Duck': 'My feathers are coated in oil, so water rolls right off them.',
    'Goat': 'My eyes have sideways pupils, so I can see almost all the way around me.',
    'Rabbit': 'My front teeth never stop growing, so I chew all day to keep them short.',
    'Turkey': 'The bare skin on my head can change color when I am excited or scared.',
    'Dog': 'My nose is thousands of times better than yours, so I can help find lost people.',
    'Cat': 'My whiskers help me feel if a gap is wide enough for my body to fit through.',
  },
  'wild': {
    'Lion': 'I am the only big cat that lives in a group, called a pride. My roar carries 8 km.',
    'Tiger': 'I am the biggest cat in the world, and no two of us have the same stripes.',
    'Elephant': 'My trunk has about 40,000 muscles. I am the largest animal that lives on land.',
    'Giraffe': 'My neck is very long, but it has just seven bones — the same number as yours.',
    'Zebra': 'My stripes may confuse biting flies and help my herd blur together when lions chase.',
    'Monkey': 'Many of my kind can grab branches with their tails, like a fifth hand.',
    'Gorilla':
        'I am the largest ape. I share almost all of my genes with humans.',
    'Hippo': 'I spend my days in rivers to stay cool, and my skin makes its own red sunscreen.',
    'Rhino':
        'My horn is made of keratin, the same material as your fingernails.',
    'Kangaroo':
        'My baby, called a joey, is the size of a jellybean when it is born.',
    'Panda': 'I eat bamboo for about 12 hours every day, and I live in China.',
    'Bear': 'In winter many of my kind hibernate, sleeping for months without eating.',
  },
  'ocean': {
    'Whale': 'I am a mammal, not a fish: I breathe air through a blowhole on top of my head.',
    'Dolphin': 'I find food with echolocation: I make clicks and listen for the echoes.',
    'Shark': 'My skeleton is made of cartilage, not bone, and I grow new teeth all my life.',
    'Octopus': 'I have three hearts and blue blood, and I can change my color in a blink.',
    'Crab': 'My skeleton is on the outside. I molt it to grow, and I walk sideways.',
    'Shrimp': 'I swim backwards fast by flicking my tail. Whales eat lots of my kind.',
    'Squid': 'I squirt ink to escape, and the giant kind has the biggest eyes of any animal.',
    'Sea Turtle': 'I lay my eggs on the beach where I hatched, sometimes after swimming thousands of kilometres.',
    'Clownfish': 'A slimy coat lets me live safely among the stinging arms of a sea anemone.',
    'Lobster': 'I taste with my legs and smell with tiny hairs on my antennae.',
    'Fish': 'I breathe by taking oxygen from the water with my gills.',
  },
  'colors': {
    'Red': 'I am a primary color in paint: you cannot mix other paints to make me.',
    'Orange':
        'Mix red and yellow paint and you get me. I am a secondary color.',
    'Yellow': 'I am a primary color, and I am the easiest color to see from far away.',
    'Green': 'Mix blue and yellow paint to make me. Plants are me because of chlorophyll.',
    'Blue': 'The sky looks like me because air scatters my light more than other colors.',
    'Purple': 'Mix red and blue paint to make me. Long ago my dye was so costly only kings wore me.',
    'Brown':
        'Mix all three primary paint colors together and you often get me.',
    'Black': 'Things look like me when they soak up all the light, so I get hot in the sun.',
    'White': 'Things look like me when they bounce back all the light. Sunlight is made of every color.',
    'Pink':
        'Mix red paint with white paint and you get me. I am a tint of red.',
  },
  'space': {
    'Sun': 'I am a star, a giant ball of hot gas. My light takes about 8 minutes to reach Earth.',
    'Mercury': 'I have almost no air, so my days are very hot and my nights are freezing.',
    'Venus': 'Thick clouds trap my heat, so I am the hottest planet even though I am not the closest.',
    'Earth': 'I am the only planet known to have life. Water covers about 71% of me.',
    'Mars': 'I have the biggest volcano in the solar system, Olympus Mons. Robot rovers explore me.',
    'Jupiter': 'I am a gas giant so big that more than 1,000 Earths could fit inside me.',
    'Saturn':
        'I am so light for my size that I would float in a giant bathtub.',
    'Uranus': 'I am an ice giant tipped on my side, so each pole gets 42 years of sunlight in a row.',
    'Neptune': 'I was found using math before anyone saw me. One trip around the Sun takes me 165 years.',
    'Moon': 'I have no light of my own: I shine by reflecting the Sun. My pull causes ocean tides.',
  },
  'countries': {
    'India': 'More people live in me than in any other country. My capital is New Delhi.',
    'United States': 'I have 50 states, and my capital is Washington, D.C.',
    'United Kingdom': 'I am made of England, Scotland, Wales and Northern Ireland. My capital is London.',
    'Japan': 'I am made of thousands of islands, and my capital is Tokyo.',
    'China': 'The Great Wall stretches across me, and my capital is Beijing.',
    'Brazil': 'Most of the Amazon rainforest is in me, and people here speak Portuguese.',
    'Egypt': 'The Nile, one of the longest rivers in the world, flows through me. My capital is Cairo.',
    'Australia':
        'I am a country and a whole continent at once. My capital is Canberra.',
    'Canada': 'I am the second-biggest country in the world, and my capital is Ottawa.',
    'Mexico': 'The Maya and Aztecs built great cities here, and I am famous for tacos and chocolate.',
    'France': 'The Eiffel Tower is in my capital, Paris.',
    'Kenya': 'The equator runs through me, and runners from here win many races. My capital is Nairobi.',
  },
  'body': {
    'Eyes': 'Light comes in through a hole called the pupil, and the picture forms at the back.',
    'Ears': 'Sound makes a thin skin called the eardrum shake. Inside are the smallest bones in your body.',
    'Nose': 'Tiny hairs and sticky mucus inside me catch dust and germs before they reach your lungs.',
    'Mouth': 'Digestion starts in me: spit, called saliva, begins breaking down food.',
    'Tongue': 'I am covered in thousands of taste buds that sense sweet, sour, salty and bitter.',
    'Teeth': 'My outside is enamel, the hardest thing in the body. Grown-ups have 32 of me.',
    'Hand': 'I have 27 bones, and my thumb can touch each finger, which helps me hold things.',
    'Foot': 'I have 26 bones, and my arch works like a spring when you walk and run.',
    'Brain': 'I send messages along nerves to control your body, even while you sleep.',
    'Bones': 'A baby has about 300 of us, and a grown-up has 206 because some join together.',
    'Leg': 'My thigh bone, the femur, is the longest and strongest bone in the body.',
    'Muscles': 'We work by pulling, never pushing, so we often work in pairs. The heart is one of us.',
  },
  'fruits': {
    'Apple':
        'I grow on trees in orchards, and my core holds seeds called pips.',
    'Banana': 'I grow in big hanging bunches, and I am full of a mineral called potassium.',
    'Grapes': 'I grow on vines, and when I am dried I become a raisin.',
    'Strawberry': 'I am the only fruit that wears my seeds on the outside — about 200 of them.',
    'Orange': 'I am full of vitamin C, which helps your body fight off colds.',
    'Watermelon': 'I am about 92% water, and I grow on vines along the ground.',
    'Pineapple': 'A new plant can grow from my leafy top, and I take about two years to grow.',
    'Mango': 'I am the national fruit of India, and I have one big flat seed inside.',
    'Cherries': 'Each of us has a hard stone inside, and we grow from pretty spring blossoms.',
    'Pear': 'I ripen from the inside out, so check near my stem to see if I am ready.',
    'Lemon': 'I am sour because of citric acid. Sailors once ate me to stay healthy.',
    'Kiwi': 'I come from China, but I am named after a bird from New Zealand that is brown and fuzzy like me.',
  },
  'veggies': {
    'Carrot': 'I am a root. I am full of beta-carotene, which your body uses to keep your eyes healthy.',
    'Broccoli': 'The part you eat is lots of tiny flower buds that have not opened yet.',
    'Corn': 'Each kernel is a seed. I am a grass, like wheat and rice, and I feed millions of people.',
    'Potato': 'I am not a root — I am a tuber, a fat underground stem that stores food for the plant.',
    'Cucumber': 'Scientists call me a fruit because I hold seeds, and I am about 95% water.',
    'Eggplant':
        'Scientists call me a berry. I am related to tomatoes and potatoes.',
    'Chili Pepper': 'My heat comes from capsaicin, and it is measured on the Scoville scale.',
    'Onion': 'I am a bulb. Cutting me lets out a gas that stings your eyes and makes tears.',
    'Garlic': 'I am a bulb made of cloves, and each clove can grow into a whole new plant.',
    'Lettuce': 'The part you eat is my leaves, and I am mostly water.',
    'Sweet Potato': 'I am a root, not a tuber, and I am only a distant cousin of the potato.',
  },
  'vehicles': {
    'Car': 'Most of my kind burn gasoline in an engine, but electric ones run on batteries.',
    'Bus': 'One of me can carry as many people as about 50 cars, which saves fuel.',
    'Train': 'The fastest electric ones of my kind, in Japan and China, go over 300 km an hour.',
    'Airplane': 'My curved wings make lift as air rushes past them, and jet engines push me forward.',
    'Helicopter': 'My spinning rotor blades are wings that let me fly up, down, backwards and hover.',
    'Sailboat': 'I can even sail into the wind by zig-zagging, which is called tacking.',
    'Ship': 'I float even though I am made of heavy steel, because I push aside lots of water.',
    'Bicycle': 'I turn the push of your legs into motion with pedals, a chain and gears.',
    'Fire Truck': 'My ladder can stretch up 30 metres, and my pump sprays thousands of litres of water.',
    'Ambulance': 'My name is written backwards on my front so drivers can read it in their mirrors.',
    'Tractor':
        'My giant back tires grip soft soil so I can pull heavy farm tools.',
    'Rocket': 'I push hot gas down so hard that I shoot up. I need over 40,000 km an hour to leave Earth.',
  },
  'bugs': {
    'Bee': 'I do a waggle dance to tell my hive-mates where to find flowers.',
    'Ladybug': 'I am a kind of beetle, and one of me can eat thousands of aphids in my life.',
    'Ant': 'I live in a colony with a queen, and I talk to my nestmates using smells.',
    'Butterfly': 'I taste with my feet, and I drink nectar through a long tube called a proboscis.',
    'Caterpillar': 'I am a larva. I build a chrysalis and change completely inside it — that is metamorphosis.',
    'Cricket':
        'My ears are on my front legs, and I chirp faster when it is warm.',
    'Spider': 'I am not an insect: I am an arachnid with eight legs and two body parts.',
    'Snail':
        'I am a mollusk. I glide on one muscly foot over a trail of slime.',
    'Mosquito': 'Only the females of my kind bite, and my bite can spread diseases like malaria.',
    'Scorpion':
        'I am an arachnid, and I glow blue-green under ultraviolet light.',
  },
  'birds': {
    'Owl':
        'My feathers have soft edges, so I fly silently and surprise my prey.',
    'Eagle':
        'I can spot a rabbit from more than 3 km away, and I build huge nests.',
    'Parrot': 'I have two toes pointing forward and two back, so I can grip food like a hand.',
    'Penguin': 'I live in the Southern Hemisphere, and my wings work like flippers underwater.',
    'Flamingo':
        'I am pink because the shrimp and algae I eat have pink color in them.',
    'Peacock': 'Only the males of my kind have the giant tail. The females are called peahens.',
    'Swan': 'I mate for life, and my babies are called cygnets.',
    'Rooster':
        'I am a male chicken, and I crow to tell other males this is my home.',
    'Dove':
        'My cousins, homing pigeons, can find their way home from far away.',
    'Duck': 'My feet are webbed for paddling, and I can sleep with one eye open to watch for danger.',
    'Turkey': 'Wild ones of my kind can fly short distances and run up to 40 km an hour.',
  },
  'sports': {
    'Soccer': 'I am the most popular sport in the world, and the World Cup is held every four years.',
    'Basketball': 'A coach named James Naismith made me up in 1891 using peach baskets as hoops.',
    'Football': 'A touchdown is worth 6 points, and each team has 11 players on the field.',
    'Baseball': 'Each team gets nine innings to bat, and hitting the ball out of the park is a home run.',
    'Tennis': 'I keep score in a funny way: love, 15, 30, 40, game. Wimbledon is played on grass.',
    'Volleyball':
        'Each team may touch the ball three times to get it back over the net.',
    'Table Tennis': 'I am also called ping-pong, and my tiny ball weighs less than 3 grams.',
    'Badminton': 'My shuttlecock can fly faster than 400 km an hour off a powerful smash.',
    'Cricket': 'I am very popular in India, England and Australia, and a match can last five days.',
    'Ice Hockey': 'My puck is made of hard rubber and is frozen before games so it slides well.',
    'Bowling':
        'Knocking down all ten pins with your first ball is called a strike.',
    'Golf': 'My course usually has 18 holes, and "par" is the number of strokes a hole should take.',
  },
  'helpers': {
    'Doctor': 'I study for many years. Some of my kind work only on hearts, bones or children.',
    'Firefighter': 'I wear heavy gear that protects me from heat and carry air to breathe in smoke.',
    'Police Officer':
        'I help keep laws, direct traffic and find people who are lost.',
    'Teacher': 'I plan lessons and help each student learn in the way that works best for them.',
    'Chef': 'I lead a team in a restaurant kitchen. My tall white hat is called a toque.',
    'Farmer': 'I rotate my crops so the soil stays healthy, and I grow food for whole towns.',
    'Mail Carrier':
        'I sort and deliver mail to every address on my route, rain or shine.',
    'Builder': 'I read blueprints, which are plans drawn by an architect, to build things.',
    'Dentist': 'I take x-rays to look for cavities, which are holes in teeth.',
    'Pilot': 'I use a checklist before every flight and talk to air traffic control by radio.',
    'Scientist': 'I use the scientific method: ask, guess, test, look at the results, and share.',
    'Artist': 'I mix colors and plan with sketches, and my work may hang in a museum.',
  },
  'continents': {
    'Asia': 'I hold Mount Everest, the tallest mountain, and about six out of every ten people.',
    'Africa': 'I have more countries than any other continent — 54 of them — and the Nile river.',
    'North America': 'I stretch from the Arctic down to Panama, and the Grand Canyon is on me.',
    'South America': 'The Andes, the longest mountain range on land, run all down my western side.',
    'Antarctica': 'I am a desert, because very little snow falls, and no one lives on me all year.',
    'Europe':
        'I am joined to Asia by land. The Alps are my most famous mountains.',
    'Australia': 'I am the only continent that is also one single country. The Great Barrier Reef is off my coast.',
    'Pacific Ocean': 'I am bigger than all the land on Earth put together, and I hold the deepest place, the Mariana Trench.',
    'Atlantic Ocean': 'I am the second-largest ocean, and the Titanic sank in my cold northern waters.',
    'Indian Ocean':
        'Monsoon winds blow across me and bring heavy rains to South Asia.',
    'Arctic Ocean': 'Much of me is frozen all year, and the ice grows and shrinks with the seasons.',
    'Southern Ocean': 'A strong current flows all the way around me, from west to east, with nothing to stop it.',
  },
  'land': {
    'Mountain': 'I can form when the plates of Earth crash together and push the land up.',
    'Volcano': 'Magma is hot melted rock inside me. Once it comes out, it is called lava.',
    'Island':
        'Some of my kind are the tops of volcanoes poking out of the sea.',
    'Desert': 'I get less than 25 cm of rain a year. I can be hot, or freezing cold like Antarctica.',
    'River': 'I start at a source, often in hills, and end at a mouth, where I meet a lake or sea.',
    'Lake': 'Most of my kind hold fresh water, but some are salty, like the Dead Sea.',
    'Waterfall':
        'The tallest of my kind is Angel Falls in Venezuela, almost 1 km tall.',
    'Forest': 'My trees make oxygen and soak up carbon dioxide. The rainy, tropical kind holds half of all the animal kinds on land.',
    'Beach': 'My sand is made of rocks and shells ground into tiny bits by waves over many years.',
    'Ocean': 'I hold about 97% of all the water on Earth, and it is salty, so you cannot drink it.',
    'Glacier': 'I am made of snow pressed into ice over many years, and I slowly carve out valleys.',
    'Cave': 'Dripping water makes icicle-like rocks: stalactites hang down and stalagmites grow up.',
  },
};

/// Harder quiz questions for each learning topic, from Grade 1 up.
const topicQuestions = <String, List<Fact>>{
  'farm': [
    Fact(_g1, _g2, 'A baby cow is called a…', '🐮', 'calf', ['kid', 'foal']),
    Fact(_g1, _g2, 'A baby horse is called a…', '🐴', 'foal', [
      'lamb',
      'chick',
    ]),
    Fact(_g1, _g2, 'A baby goat is called a…', '🐐', 'kid', ['piglet', 'calf']),
    Fact(_g1, _g3, 'Wool comes from…', '🐑', 'sheep', ['pigs', 'chickens']),
    Fact(_g2, _g4, 'Butter and cheese are made from…', '🐮', 'milk', [
      'eggs',
      'wool',
    ]),
    Fact(_g2, _g4, 'A group of cows is called a…', '🐮', 'herd', [
      'flock',
      'pack',
    ]),
    Fact(_g2, _g4, 'Cows and goats eat mostly…', '🐐', 'plants', [
      'meat',
      'insects',
    ]),
    Fact(_g3, _g5, 'An animal that eats only plants is a…', '🐮', 'herbivore', [
      'carnivore',
      'omnivore',
    ]),
    Fact(
      _g3,
      _g5,
      'Pigs eat plants and meat, so they are…',
      '🐷',
      'omnivores',
      ['herbivores', 'carnivores'],
    ),
    Fact(
      _g3,
      _g5,
      'Animals kept by people for food or work are called…',
      '🚜',
      'livestock',
      ['wildlife', 'predators'],
    ),
    Fact(
      _g4,
      _g5,
      'Cows chew partly digested food again. This is called chewing…',
      '🐮',
      'cud',
      ['bark', 'seeds'],
    ),
    Fact(
      _g4,
      _g5,
      'Animals that were tamed by people long ago are…',
      '🐕',
      'domesticated',
      ['endangered', 'extinct'],
    ),
  ],
  'wild': [
    Fact(_g1, _g2, 'A baby lion is called a…', '🦁', 'cub', ['calf', 'joey']),
    Fact(_g1, _g2, 'A baby kangaroo is called a…', '🦘', 'joey', [
      'cub',
      'kid',
    ]),
    Fact(
      _g1,
      _g3,
      'Giraffes use their long necks to reach…',
      '🦒',
      'tree leaves',
      ['fish', 'grass roots'],
    ),
    Fact(_g1, _g3, 'Pandas mostly eat…', '🐼', 'bamboo', ['fish', 'meat']),
    Fact(_g2, _g4, 'A group of lions is called a…', '🦁', 'pride', [
      'herd',
      'school',
    ]),
    Fact(_g2, _g4, 'Kangaroos live wild in…', '🦘', 'Australia', [
      'Africa',
      'Europe',
    ]),
    Fact(
      _g2,
      _g4,
      'An animal that hunts other animals is a…',
      '🐯',
      'predator',
      ['prey', 'herbivore'],
    ),
    Fact(
      _g3,
      _g5,
      'Kangaroos carry babies in a pouch, so they are…',
      '🦘',
      'marsupials',
      ['reptiles', 'amphibians'],
    ),
    Fact(
      _g3,
      _g5,
      'Animals that sleep through the winter…',
      '🐻',
      'hibernate',
      ['migrate', 'molt'],
    ),
    Fact(
      _g3,
      _g5,
      'The grassy plains where zebras and lions live are called the…',
      '🦓',
      'savanna',
      ['tundra', 'rainforest'],
    ),
    Fact(_g4, _g5, 'Animals in danger of dying out are…', '🐼', 'endangered', [
      'domesticated',
      'nocturnal',
    ]),
    Fact(
      _g4,
      _g5,
      'Colors and patterns that help animals hide are called…',
      '🐯',
      'camouflage',
      ['migration', 'hibernation'],
    ),
  ],
  'ocean': [
    Fact(_g1, _g2, 'Fish breathe underwater using…', '🐟', 'gills', [
      'lungs',
      'fins',
    ]),
    Fact(_g1, _g2, 'How many arms does an octopus have?', '🐙', '8', [
      '6',
      '10',
    ]),
    Fact(_g1, _g3, 'Whales breathe air through a…', '🐋', 'blowhole', [
      'gill',
      'fin',
    ]),
    Fact(_g2, _g3, 'Sea turtles lay their eggs…', '🐢', 'on the beach', [
      'in coral',
      'on ice',
    ]),
    Fact(_g2, _g4, 'A group of fish swimming together is a…', '🐟', 'school', [
      'herd',
      'pride',
    ]),
    Fact(_g2, _g4, 'Whales and dolphins are…', '🐬', 'mammals', [
      'fish',
      'reptiles',
    ]),
    Fact(
      _g3,
      _g5,
      'Dolphins find food by making clicks. This is called…',
      '🐬',
      'echolocation',
      ['camouflage', 'migration'],
    ),
    Fact(
      _g3,
      _g5,
      'Crabs and lobsters have a hard outer skeleton called an…',
      '🦀',
      'exoskeleton',
      ['endoskeleton', 'eardrum'],
    ),
    Fact(
      _g3,
      _g5,
      'Clownfish live safely inside the arms of a…',
      '🐠',
      'sea anemone',
      ['jellyfish', 'shark'],
    ),
    Fact(
      _g4,
      _g5,
      'Tiny drifting plants and animals in the sea are called…',
      '🐋',
      'plankton',
      ['coral', 'kelp'],
    ),
    Fact(_g4, _g5, 'A shark\'s skeleton is made of…', '🦈', 'cartilage', [
      'bone',
      'shell',
    ]),
  ],
  'colors': [
    Fact(_g1, _g2, 'Red and yellow paint make…', '🎨', 'orange', [
      'green',
      'purple',
    ]),
    Fact(_g1, _g2, 'Blue and yellow paint make…', '🎨', 'green', [
      'orange',
      'pink',
    ]),
    Fact(_g1, _g2, 'Red and blue paint make…', '🎨', 'purple', [
      'brown',
      'green',
    ]),
    Fact(_g1, _g3, 'Red and white paint make…', '🎨', 'pink', [
      'orange',
      'gray',
    ]),
    Fact(_g2, _g4, 'Which is a primary color in paint?', '🎨', 'blue', [
      'green',
      'purple',
    ]),
    Fact(_g2, _g4, 'Which is a secondary color?', '🎨', 'orange', [
      'red',
      'yellow',
    ]),
    Fact(
      _g2,
      _g4,
      'A rainbow shows up when sunlight shines through…',
      '🌈',
      'raindrops',
      ['clouds', 'snow'],
    ),
    Fact(_g3, _g5, 'Leaves are green because of…', '🍃', 'chlorophyll', [
      'carotene',
      'melanin',
    ]),
    Fact(
      _g3,
      _g5,
      'Which colour soaks up the most sunlight and gets hottest?',
      '☀️',
      'black',
      ['white', 'yellow'],
    ),
    Fact(
      _g3,
      _g5,
      'Colors opposite each other on the color wheel are…',
      '🎨',
      'complementary',
      ['primary', 'neutral'],
    ),
    Fact(_g4, _g5, 'Which color is at the top of a rainbow?', '🌈', 'red', [
      'violet',
      'green',
    ]),
    Fact(_g4, _g5, 'Adding white to a color makes a…', '🎨', 'tint', [
      'shade',
      'primary',
    ]),
  ],
  'space': [
    Fact(_g1, _g2, 'The Sun is a…', '☀️', 'star', ['planet', 'moon']),
    Fact(_g1, _g2, 'Which planet do we live on?', '🌍', 'Earth', [
      'Mars',
      'Venus',
    ]),
    Fact(_g1, _g3, 'Which planet has big, bright rings?', '🪐', 'Saturn', [
      'Mars',
      'Mercury',
    ]),
    Fact(_g2, _g3, 'Which planet is closest to the Sun?', '☀️', 'Mercury', [
      'Earth',
      'Neptune',
    ]),
    Fact(_g2, _g4, 'The biggest planet is…', '🪐', 'Jupiter', [
      'Earth',
      'Mars',
    ]),
    Fact(_g2, _g4, 'How many planets go around the Sun?', '☀️', '8', [
      '5',
      '12',
    ]),
    Fact(_g3, _g5, 'Earth takes one year to go around the…', '🌍', 'Sun', [
      'Moon',
      'Mars',
    ]),
    Fact(_g3, _g5, 'Earth spins once every…', '🌍', '24 hours', [
      '7 days',
      '1 year',
    ]),
    Fact(_g3, _g5, 'The Moon shines because it…', '🌙', 'reflects sunlight', [
      'makes its own light',
      'is on fire',
    ]),
    Fact(
      _g4,
      _g5,
      'The force that keeps planets going around the Sun is…',
      '☀️',
      'gravity',
      ['magnetism', 'friction'],
    ),
    Fact(
      _g4,
      _g5,
      'The path a planet takes around the Sun is its…',
      '🪐',
      'orbit',
      ['axis', 'phase'],
    ),
    Fact(_g4, _g5, 'Which planet is the hottest?', '☀️', 'Venus', [
      'Mercury',
      'Mars',
    ]),
  ],
  'countries': [
    Fact(_g1, _g2, 'The Eiffel Tower is in…', '🇫🇷', 'France', [
      'Japan',
      'Brazil',
    ]),
    Fact(_g1, _g3, 'The pyramids of Giza are in…', '🇪🇬', 'Egypt', [
      'Canada',
      'India',
    ]),
    Fact(_g1, _g3, 'Kangaroos live wild in…', '🇦🇺', 'Australia', [
      'Mexico',
      'France',
    ]),
    Fact(_g2, _g4, 'The capital of Japan is…', '🇯🇵', 'Tokyo', [
      'Beijing',
      'Paris',
    ]),
    Fact(_g2, _g4, 'The Great Wall is in…', '🇨🇳', 'China', [
      'Kenya',
      'Brazil',
    ]),
    Fact(
      _g2,
      _g4,
      'Which country is north of the United States?',
      '🇺🇸',
      'Canada',
      ['Mexico', 'Brazil'],
    ),
    Fact(_g3, _g5, 'People in Brazil mainly speak…', '🇧🇷', 'Portuguese', [
      'Spanish',
      'French',
    ]),
    Fact(_g3, _g5, 'Which country has the most people?', '🇮🇳', 'India', [
      'Canada',
      'France',
    ]),
    Fact(_g3, _g5, 'The capital of Australia is…', '🇦🇺', 'Canberra', [
      'Sydney',
      'Melbourne',
    ]),
    Fact(_g4, _g5, 'The equator passes through…', '🇰🇪', 'Kenya', [
      'Canada',
      'France',
    ]),
    Fact(
      _g4,
      _g5,
      'Which country is on the continent of Asia?',
      '🇯🇵',
      'Japan',
      ['Egypt', 'Mexico'],
    ),
    Fact(_g4, _g5, 'Mexico is on the continent of…', '🇲🇽', 'North America', [
      'South America',
      'Europe',
    ]),
  ],
  'body': [
    Fact(_g1, _g2, 'Which part of your body helps you think?', '🧠', 'brain', [
      'stomach',
      'heart',
    ]),
    Fact(_g1, _g2, 'Your heart pumps…', '🧒', 'blood', ['air', 'food']),
    Fact(_g1, _g3, 'You breathe air into your…', '🧒', 'lungs', [
      'stomach',
      'bones',
    ]),
    Fact(_g2, _g3, 'Your skull protects your…', '🧠', 'brain', [
      'heart',
      'stomach',
    ]),
    Fact(_g2, _g4, 'How many senses do people have?', '👀', '5', ['3', '8']),
    Fact(_g2, _g4, 'Muscles move your body by…', '💪', 'pulling on bones', [
      'pushing on skin',
      'pumping air',
    ]),
    Fact(_g3, _g5, 'How many bones does a grown-up have?', '🦴', '206', [
      '52',
      '1,000',
    ]),
    Fact(_g3, _g5, 'The longest bone in your body is the…', '🦵', 'femur', [
      'skull',
      'rib',
    ]),
    Fact(
      _g3,
      _g5,
      'Messages travel from the brain to the body along…',
      '🧠',
      'nerves',
      ['veins', 'bones'],
    ),
    Fact(_g4, _g5, 'Your ribs protect your heart and…', '🧒', 'lungs', [
      'stomach',
      'brain',
    ]),
    Fact(_g4, _g5, 'The hard outer layer of a tooth is…', '🦷', 'enamel', [
      'marrow',
      'cartilage',
    ]),
    Fact(_g4, _g5, 'Bones meet at places called…', '🦴', 'joints', [
      'nerves',
      'organs',
    ]),
  ],
  'fruits': [
    Fact(_g1, _g2, 'Dried grapes are called…', '🍇', 'raisins', [
      'prunes',
      'nuts',
    ]),
    Fact(_g1, _g2, 'Apples grow on…', '🍎', 'trees', ['vines', 'the ground']),
    Fact(_g1, _g3, 'Which fruit is the most sour?', '🍋', 'lemon', [
      'banana',
      'mango',
    ]),
    Fact(
      _g2,
      _g3,
      'Which fruit has its seeds on the outside?',
      '🍓',
      'strawberry',
      ['apple', 'orange'],
    ),
    Fact(_g2, _g4, 'Oranges are full of vitamin…', '🍊', 'C', ['D', 'K']),
    Fact(_g2, _g4, 'Grapes and watermelons grow on…', '🍉', 'vines', [
      'trees',
      'bushes',
    ]),
    Fact(
      _g3,
      _g5,
      'A fruit is the part of a plant that holds the…',
      '🍎',
      'seeds',
      ['roots', 'leaves'],
    ),
    Fact(_g3, _g5, 'Fruit trees grown together make an…', '🍎', 'orchard', [
      'island',
      'oasis',
    ]),
    Fact(_g3, _g5, 'Lemons and oranges are called…', '🍋', 'citrus fruits', [
      'berries',
      'tubers',
    ]),
    Fact(
      _g4,
      _g5,
      'Bees help fruit grow by carrying pollen. This is called…',
      '🍒',
      'pollination',
      ['photosynthesis', 'evaporation'],
    ),
    Fact(
      _g4,
      _g5,
      'Cherries and mangoes have one big seed called a…',
      '🍒',
      'stone',
      ['bulb', 'clove'],
    ),
    Fact(_g4, _g5, 'Bananas are rich in the mineral…', '🍌', 'potassium', [
      'iron',
      'calcium',
    ]),
  ],
  'veggies': [
    Fact(_g1, _g2, 'Which vegetable grows under the ground?', '🥕', 'carrot', [
      'lettuce',
      'corn',
    ]),
    Fact(_g1, _g2, 'Popcorn is made from…', '🌽', 'corn', ['potato', 'onion']),
    Fact(_g1, _g2, 'French fries are made from…', '🥔', 'potatoes', [
      'carrots',
      'cucumbers',
    ]),
    Fact(_g1, _g3, 'A pickle is made from a…', '🥒', 'cucumber', [
      'carrot',
      'pepper',
    ]),
    Fact(
      _g2,
      _g3,
      'When we eat lettuce, we eat the plant\'s…',
      '🥬',
      'leaves',
      ['roots', 'seeds'],
    ),
    Fact(_g2, _g4, 'When we eat a carrot, we eat the plant\'s…', '🥕', 'root', [
      'flower',
      'leaf',
    ]),
    Fact(
      _g2,
      _g4,
      'When we eat broccoli, we eat the plant\'s…',
      '🥦',
      'flower buds',
      ['roots', 'seeds'],
    ),
    Fact(
      _g3,
      _g5,
      'When we eat corn kernels, we eat the plant\'s…',
      '🌽',
      'seeds',
      ['roots', 'stems'],
    ),
    Fact(
      _g3,
      _g5,
      'A potato is a swollen underground stem called a…',
      '🥔',
      'tuber',
      ['bulb', 'root'],
    ),
    Fact(_g3, _g5, 'Onions and garlic grow underground as…', '🧅', 'bulbs', [
      'tubers',
      'fruits',
    ]),
    Fact(
      _g3,
      _g5,
      'Scientists call a cucumber a fruit because it has…',
      '🥒',
      'seeds',
      ['leaves', 'roots'],
    ),
    Fact(
      _g4,
      _g5,
      'Carrots are full of beta-carotene, which helps keep your…',
      '🥕',
      'eyes healthy',
      ['hair curly', 'bones long'],
    ),
    Fact(
      _g4,
      _g5,
      'The heat in chili peppers comes from…',
      '🌶️',
      'capsaicin',
      ['chlorophyll', 'calcium'],
    ),
    Fact(
      _g4,
      _g5,
      'Eggplants, tomatoes and potatoes are in the same plant…',
      '🍆',
      'family',
      ['orchard', 'season'],
    ),
  ],
  'vehicles': [
    Fact(_g1, _g2, 'Which one travels on rails?', '🚆', 'train', [
      'bus',
      'ship',
    ]),
    Fact(_g1, _g2, 'Which one is pushed by the wind?', '⛵', 'sailboat', [
      'bus',
      'tractor',
    ]),
    Fact(
      _g1,
      _g3,
      'Which one can fly straight up and hover?',
      '🚁',
      'helicopter',
      ['airplane', 'rocket'],
    ),
    Fact(_g2, _g3, 'How many wheels does a bicycle have?', '🚲', '2', [
      '3',
      '4',
    ]),
    Fact(_g2, _g4, 'A person who flies an airplane is a…', '✈️', 'pilot', [
      'captain',
      'driver',
    ]),
    Fact(
      _g2,
      _g4,
      'Which one carries sick people to the hospital?',
      '🚑',
      'ambulance',
      ['fire truck', 'tractor'],
    ),
    Fact(_g3, _g5, 'An airplane\'s wings make a force called…', '✈️', 'lift', [
      'gravity',
      'friction',
    ]),
    Fact(_g3, _g5, 'Electric cars get their power from…', '🚗', 'batteries', [
      'sails',
      'coal',
    ]),
    Fact(_g3, _g5, 'Brakes slow a bike down using…', '🚲', 'friction', [
      'magnetism',
      'lift',
    ]),
    Fact(
      _g4,
      _g5,
      'A huge steel ship floats because it pushes aside lots of…',
      '🚢',
      'water',
      ['air', 'sand'],
    ),
    Fact(_g4, _g5, 'Rockets go up by pushing hot gas…', '🚀', 'down', [
      'up',
      'sideways',
    ]),
    Fact(
      _g4,
      _g5,
      'The force that pulls a rocket back to Earth is…',
      '🚀',
      'gravity',
      ['lift', 'thrust'],
    ),
  ],
  'bugs': [
    Fact(_g1, _g2, 'How many legs does an insect have?', '🐜', '6', ['8', '4']),
    Fact(_g1, _g2, 'How many legs does a spider have?', '🕷️', '8', [
      '6',
      '10',
    ]),
    Fact(_g1, _g3, 'A caterpillar turns into a…', '🐛', 'butterfly', [
      'bee',
      'spider',
    ]),
    Fact(_g2, _g3, 'Bees make…', '🐝', 'honey', ['silk', 'milk']),
    Fact(_g2, _g4, 'Is a spider an insect?', '🕷️', 'No, it is an arachnid', [
      'Yes, it is an insect',
      'No, it is a reptile',
    ]),
    Fact(
      _g2,
      _g4,
      'A caterpillar makes a case around itself called a…',
      '🐛',
      'chrysalis',
      ['hive', 'web'],
    ),
    Fact(_g3, _g5, 'An insect\'s body has how many parts?', '🐜', '3', [
      '2',
      '5',
    ]),
    Fact(
      _g3,
      _g5,
      'The change from caterpillar to butterfly is called…',
      '🦋',
      'metamorphosis',
      ['hibernation', 'migration'],
    ),
    Fact(_g3, _g5, 'Ants and bees live in groups called…', '🐜', 'colonies', [
      'herds',
      'schools',
    ]),
    Fact(
      _g4,
      _g5,
      'Insects have a hard covering instead of bones, called an…',
      '🐞',
      'exoskeleton',
      ['endoskeleton', 'enamel'],
    ),
    Fact(_g4, _g5, 'Bees carry this from flower to flower:', '🐝', 'pollen', [
      'nectar jars',
      'seeds',
    ]),
    Fact(_g4, _g5, 'Snails are not insects. They are…', '🐌', 'mollusks', [
      'arachnids',
      'reptiles',
    ]),
  ],
  'birds': [
    Fact(_g1, _g2, 'Birds are covered in…', '🦜', 'feathers', [
      'fur',
      'scales',
    ]),
    Fact(_g1, _g2, 'Which bird cannot fly but swims well?', '🐧', 'penguin', [
      'eagle',
      'dove',
    ]),
    Fact(_g1, _g3, 'Which bird is awake at night?', '🦉', 'owl', [
      'rooster',
      'swan',
    ]),
    Fact(_g2, _g3, 'Baby birds hatch from…', '🐣', 'eggs', [
      'seeds',
      'pouches',
    ]),
    Fact(
      _g2,
      _g4,
      'Flamingos are pink because of the…',
      '🦩',
      'food they eat',
      ['sun', 'water they drink'],
    ),
    Fact(_g2, _g4, 'A baby swan is called a…', '🦢', 'cygnet', [
      'chick',
      'cub',
    ]),
    Fact(_g3, _g5, 'Birds that fly south for the winter…', '🦆', 'migrate', [
      'hibernate',
      'molt',
    ]),
    Fact(
      _g3,
      _g5,
      'Animals that are awake at night are called…',
      '🦉',
      'nocturnal',
      ['diurnal', 'extinct'],
    ),
    Fact(
      _g3,
      _g5,
      'Eagles and owls are birds of prey, which means they…',
      '🦅',
      'hunt other animals',
      ['eat only seeds', 'live in water'],
    ),
    Fact(
      _g4,
      _g5,
      'Birds have hollow bones, which makes them…',
      '🦅',
      'light for flying',
      ['very strong swimmers', 'warm in winter'],
    ),
    Fact(
      _g4,
      _g5,
      'Penguins live mostly in the…',
      '🐧',
      'Southern Hemisphere',
      ['Northern Hemisphere', 'Arctic'],
    ),
    Fact(
      _g4,
      _g5,
      'The male peacock\'s big tail helps it…',
      '🦚',
      'attract a mate',
      ['fly faster', 'stay warm'],
    ),
  ],
  'sports': [
    Fact(_g1, _g2, 'Which sport uses a bat and bases?', '⚾', 'baseball', [
      'tennis',
      'golf',
    ]),
    Fact(_g1, _g2, 'Which sport is played on ice?', '🏒', 'ice hockey', [
      'soccer',
      'bowling',
    ]),
    Fact(
      _g1,
      _g3,
      'In soccer you may not touch the ball with your…',
      '⚽',
      'hands',
      ['feet', 'head'],
    ),
    Fact(
      _g2,
      _g3,
      'Knocking down all ten pins in bowling is a…',
      '🎳',
      'strike',
      ['goal', 'home run'],
    ),
    Fact(
      _g2,
      _g4,
      'How many players does a soccer team have on the field?',
      '⚽',
      '11',
      ['5', '9'],
    ),
    Fact(
      _g2,
      _g4,
      'How many players does a basketball team have on the court?',
      '🏀',
      '5',
      ['11', '9'],
    ),
    Fact(_g3, _g5, 'Which sport has a shuttlecock?', '🏸', 'badminton', [
      'volleyball',
      'cricket',
    ]),
    Fact(_g3, _g5, 'In tennis, a score of zero is called…', '🎾', 'love', [
      'nil',
      'duck',
    ]),
    Fact(
      _g3,
      _g5,
      'The world\'s biggest soccer contest, held every four years, is the…',
      '⚽',
      'World Cup',
      ['Super Bowl', 'Wimbledon'],
    ),
    Fact(_g4, _g5, 'A touchdown in football is worth…', '🏈', '6 points', [
      '3 points',
      '1 point',
    ]),
    Fact(_g4, _g5, 'Basketball was invented in…', '🏀', '1891', [
      '1991',
      '1491',
    ]),
    Fact(
      _g4,
      _g5,
      'Games where athletes from many countries compete every four years are the…',
      '⚽',
      'Olympics',
      ['World Series', 'Grand Prix'],
    ),
  ],
  'helpers': [
    Fact(_g1, _g2, 'Who helps you when you are sick?', '🩺', 'doctor', [
      'pilot',
      'chef',
    ]),
    Fact(_g1, _g2, 'Who grows food on a farm?', '🌾', 'farmer', [
      'dentist',
      'artist',
    ]),
    Fact(
      _g1,
      _g3,
      'Which number do you call in an emergency in the USA?',
      '🚒',
      '911',
      ['123', '411'],
    ),
    Fact(_g2, _g3, 'Who flies an airplane?', '✈️', 'pilot', [
      'builder',
      'teacher',
    ]),
    Fact(
      _g2,
      _g4,
      'A dentist looks for holes in teeth called…',
      '🦷',
      'cavities',
      ['cracks', 'roots'],
    ),
    Fact(
      _g2,
      _g4,
      'A doctor listens to your heart with a…',
      '🩺',
      'stethoscope',
      ['telescope', 'microscope'],
    ),
    Fact(
      _g3,
      _g5,
      'A scientist looks at tiny things with a…',
      '🔬',
      'microscope',
      ['telescope', 'periscope'],
    ),
    Fact(_g3, _g5, 'A builder follows plans called…', '🔨', 'blueprints', [
      'recipes',
      'maps',
    ]),
    Fact(_g3, _g5, 'A chef\'s tall white hat is called a…', '🍳', 'toque', [
      'helmet',
      'beret',
    ]),
    Fact(
      _g4,
      _g5,
      'Who designs buildings before they are built?',
      '🔨',
      'architect',
      ['plumber', 'pilot'],
    ),
    Fact(_g4, _g5, 'A scientist tests ideas with…', '🔬', 'experiments', [
      'recipes',
      'paintings',
    ]),
    Fact(_g4, _g5, 'Pilots talk by radio with…', '✈️', 'air traffic control', [
      'the fire station',
      'the post office',
    ]),
  ],
  'continents': [
    Fact(_g1, _g2, 'How many continents are there?', '🌍', '7', ['5', '10']),
    Fact(_g1, _g2, 'Which continent is the coldest?', '🧊', 'Antarctica', [
      'Africa',
      'Asia',
    ]),
    Fact(_g1, _g3, 'Which is the biggest ocean?', '🌊', 'Pacific', [
      'Arctic',
      'Indian',
    ]),
    Fact(_g2, _g3, 'Which continent is the biggest?', '🌍', 'Asia', [
      'Europe',
      'Australia',
    ]),
    Fact(_g2, _g4, 'How many oceans are there?', '🌊', '5', ['3', '7']),
    Fact(_g2, _g4, 'Which ocean is around the North Pole?', '🧊', 'Arctic', [
      'Southern',
      'Indian',
    ]),
    Fact(_g3, _g5, 'The Sahara desert is in…', '🏜️', 'Africa', [
      'Asia',
      'Europe',
    ]),
    Fact(_g3, _g5, 'The Amazon rainforest is in…', '🌳', 'South America', [
      'Africa',
      'Australia',
    ]),
    Fact(
      _g3,
      _g5,
      'Which ocean lies between the Americas and Europe?',
      '🌊',
      'Atlantic',
      ['Pacific', 'Indian'],
    ),
    Fact(
      _g4,
      _g5,
      'The deepest place in the ocean, the Mariana Trench, is in the…',
      '🌊',
      'Pacific',
      ['Atlantic', 'Arctic'],
    ),
    Fact(
      _g4,
      _g5,
      'The continent with the most countries is…',
      '🌍',
      'Africa',
      ['Europe', 'North America'],
    ),
    Fact(
      _g4,
      _g5,
      'Mount Everest, the tallest mountain, is in…',
      '🏔️',
      'Asia',
      ['Europe', 'South America'],
    ),
  ],
  'land': [
    Fact(_g1, _g2, 'Land with water all around it is an…', '🏝️', 'island', [
      'ocean',
      'desert',
    ]),
    Fact(_g1, _g2, 'A very dry place with little rain is a…', '🏜️', 'desert', [
      'forest',
      'lake',
    ]),
    Fact(_g1, _g3, 'Hot melted rock from a volcano is…', '🌋', 'lava', [
      'ice',
      'sand',
    ]),
    Fact(_g2, _g3, 'Ocean water is…', '🌊', 'salty', ['sweet', 'fresh']),
    Fact(_g2, _g4, 'A slow-moving river of ice is a…', '🧊', 'glacier', [
      'waterfall',
      'lake',
    ]),
    Fact(_g2, _g4, 'Where a river meets the sea is its…', '🐟', 'mouth', [
      'source',
      'peak',
    ]),
    Fact(_g3, _g5, 'Melted rock still underground is called…', '🌋', 'magma', [
      'lava',
      'ash',
    ]),
    Fact(
      _g3,
      _g5,
      'Rocks that hang from a cave roof are…',
      '🦇',
      'stalactites',
      ['stalagmites', 'glaciers'],
    ),
    Fact(
      _g3,
      _g5,
      'Sand is made of rock broken into tiny bits by…',
      '🏖️',
      'waves and wind',
      ['animals', 'lava'],
    ),
    Fact(
      _g4,
      _g5,
      'Rock and soil being carried away by water or wind is…',
      '🌊',
      'erosion',
      ['evaporation', 'eruption'],
    ),
    Fact(
      _g4,
      _g5,
      'Most mountains form when Earth\'s plates…',
      '🏔️',
      'push together',
      ['melt', 'freeze'],
    ),
    Fact(_g4, _g5, 'The tallest waterfall on Earth is…', '💧', 'Angel Falls', [
      'Niagara Falls',
      'Victoria Falls',
    ]),
  ],
};
