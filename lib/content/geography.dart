// Geography: land & water, continents & oceans, map skills, capitals.
// Same Fact format as science (min level, max level, question, picture,
// answer, wrong answers).

import '../models/models.dart';
import 'science.dart' show Fact;

const _pk = Level.preK,
    _k = Level.kindergarten,
    _g1 = Level.grade1,
    _g2 = Level.grade2,
    _g3 = Level.grade3,
    _g4 = Level.grade4,
    _g5 = Level.grade5;

// ------------------------------------------------------------ land & water
// Picture answers for the youngest.
const landWaterFacts = [
  Fact(_pk, _g2, 'Which one has water all around it?', '🧭', '🏝️', [
    '🏔️',
    '🏜️',
  ]),
  Fact(_pk, _g2, 'Which one is very tall with a pointy top?', '🧭', '🏔️', [
    '🏖️',
    'pic:lake',
  ]),
  Fact(_pk, _g2, 'Which one can have hot lava?', '🔥', '🌋', [
    'pic:lake',
    '🌲',
  ]),
  Fact(_pk, _g2, 'Which one is hot, dry and sandy?', '☀️', '🏜️', [
    'pic:glacier',
    '🌲',
  ]),
  Fact(_pk, _g2, 'Which one is covered in trees?', '🌳', '🌲', ['🏜️', '🌊']),
  Fact(_pk, _g2, 'Where do waves splash on the sand?', '🌊', '🏖️', [
    'pic:cave',
    '🏔️',
  ]),
  Fact(_pk, _g2, 'Which one is a giant river of ice?', '🧊', 'pic:glacier', [
    '🏜️',
    '🌋',
  ]),
  Fact(_pk, _g2, 'Where does water flow down a cliff?', '💧', 'pic:waterfall', [
    '🏝️',
    '🏜️',
  ]),
  Fact(_pk, _g2, 'Which one is a dark hole in a hill?', '🔦', 'pic:cave', [
    '🏖️',
    '🌲',
  ]),
  Fact(_pk, _g2, 'Which one has water flowing to the sea?', '🐟', 'pic:river', [
    '🏜️',
    '🏔️',
  ]),
  Fact(
    _pk,
    _g2,
    'Which one is still water with land all around?',
    '🦆',
    'pic:lake',
    ['🌋', '🏜️'],
  ),
  Fact(_pk, _g2, 'Where do cactuses grow?', '🌵', '🏜️', ['pic:glacier', '🌊']),
  Fact(_pk, _g2, 'Where do whales live?', '🐳', '🌊', ['🏜️', '🌲']),
  Fact(_pk, _g2, 'Where do polar bears live?', '🧊', 'pic:glacier', [
    '🏜️',
    '🏖️',
  ]),
  Fact(_pk, _g2, 'Where can you build a sandcastle?', '☀️', '🏖️', [
    '🏔️',
    'pic:glacier',
  ]),
  Fact(_pk, _g2, 'Where can you find snow high up?', '❄️', '🏔️', [
    '🏖️',
    '🏜️',
  ]),
  Fact(_pk, _g2, 'Where do bats sleep in the dark?', '🦇', 'pic:cave', [
    '🏖️',
    '🏜️',
  ]),
  Fact(_pk, _g2, 'Where can you catch fish in fresh water?', '🐟', 'pic:lake', [
    '🏜️',
    '🌋',
  ]),
  Fact(_k, _g2, 'A mountain is very…', '🏔️', 'Tall', ['Flat', 'Wet']),
  Fact(_k, _g2, 'A forest has lots of…', '🌲', 'Trees', ['Sand', 'Ice']),
  Fact(_k, _g2, 'An island has water…', '🏝️', 'All around it', [
    'Only on top',
    'Nowhere near it',
  ]),
  Fact(_k, _g2, 'Ocean water tastes…', '🌊', 'Salty', ['Sweet', 'Like juice']),
  Fact(_k, _g2, 'A desert gets very little…', '🏜️', 'Rain', ['Sun', 'Sand']),
  Fact(
    _g1,
    _g2,
    'What is the hot melted rock from a volcano called?',
    '🌋',
    'Lava',
    ['Ice', 'Sand'],
  ),
  Fact(_g1, _g2, 'Rivers usually flow into the…', 'pic:river', 'Sea', [
    'Sky',
    'Desert',
  ]),
  Fact(
    _g1,
    _g2,
    'Which is the tallest mountain on Earth?',
    '🏔️',
    'Mount Everest',
    ['Mount Fuji', 'Mount Kilimanjaro'],
  ),
  Fact(
    _g2,
    _g2,
    'The biggest hot desert in the world is the…',
    '🏜️',
    'Sahara',
    ['Gobi', 'Arctic'],
  ),
  Fact(_g2, _g2, 'A glacier is made of…', 'pic:glacier', 'Ice', [
    'Sand',
    'Rock',
  ]),
];

// ------------------------------------------------- continents & oceans
const continentFacts = [
  // Which one is this? (the globe shows it in colour)
  Fact(_k, _g5, 'Which continent is in colour?', 'pic:africa', 'Africa', [
    'Asia',
    'Europe',
  ]),
  Fact(_k, _g5, 'Which continent is in colour?', 'pic:asia', 'Asia', [
    'Africa',
    'Australia',
  ]),
  Fact(_k, _g5, 'Which continent is in colour?', 'pic:australia', 'Australia', [
    'Antarctica',
    'Europe',
  ]),
  Fact(
    _k,
    _g5,
    'Which continent is in colour?',
    'pic:antarctica',
    'Antarctica',
    ['Australia', 'Asia'],
  ),
  Fact(
    _k,
    _g5,
    'Which continent is in colour?',
    'pic:south_america',
    'South America',
    ['North America', 'Africa'],
  ),
  Fact(
    _g1,
    _g5,
    'Which continent is in colour?',
    'pic:north_america',
    'North America',
    ['South America', 'Europe'],
  ),
  Fact(_k, _g5, 'Which continent is in colour?', 'pic:europe', 'Europe', [
    'Asia',
    'Africa',
  ]),
  Fact(_k, _g5, 'Which ocean is dark blue?', 'pic:pacific', 'Pacific Ocean', [
    'Atlantic Ocean',
    'Indian Ocean',
  ]),
  Fact(
    _g1,
    _g5,
    'Which ocean is dark blue?',
    'pic:atlantic',
    'Atlantic Ocean',
    ['Pacific Ocean', 'Arctic Ocean'],
  ),
  Fact(_g2, _g5, 'Which ocean is dark blue?', 'pic:indian', 'Indian Ocean', [
    'Pacific Ocean',
    'Southern Ocean',
  ]),
  Fact(_g2, _g5, 'Which ocean is dark blue?', 'pic:arctic', 'Arctic Ocean', [
    'Southern Ocean',
    'Indian Ocean',
  ]),
  Fact(
    _g2,
    _g5,
    'Which ocean is dark blue?',
    'pic:southern',
    'Southern Ocean',
    ['Arctic Ocean', 'Atlantic Ocean'],
  ),
  // Counting and record-breakers.
  Fact(_k, _g5, 'How many continents are there?', '🌍', '7', ['5', '10']),
  Fact(_g1, _g5, 'How many oceans are there?', '🌊', '5', ['3', '7']),
  Fact(_k, _g5, 'Which is the coldest continent?', '🧊', 'Antarctica', [
    'Africa',
    'Australia',
  ]),
  Fact(_g1, _g5, 'Which is the biggest continent?', '🌍', 'Asia', [
    'Europe',
    'Australia',
  ]),
  Fact(_g1, _g5, 'Which is the biggest ocean?', '🌊', 'Pacific Ocean', [
    'Indian Ocean',
    'Arctic Ocean',
  ]),
  Fact(_g2, _g5, 'Which is the smallest continent?', '🦘', 'Australia', [
    'Asia',
    'Africa',
  ]),
  Fact(_g2, _g5, 'Which is the smallest ocean?', '🧊', 'Arctic Ocean', [
    'Pacific Ocean',
    'Atlantic Ocean',
  ]),
  // Animals and places.
  Fact(_k, _g5, 'Kangaroos live wild in…', '🦘', 'Australia', [
    'Europe',
    'Antarctica',
  ]),
  Fact(_k, _g5, 'Penguins live in icy…', '🐧', 'Antarctica', [
    'Africa',
    'Asia',
  ]),
  Fact(_k, _g5, 'Lions and zebras live in…', '🦁', 'Africa', [
    'Europe',
    'Antarctica',
  ]),
  Fact(_g1, _g5, 'Giant pandas live in…', '🐼', 'Asia', [
    'Africa',
    'South America',
  ]),
  Fact(_g1, _g5, 'Polar bears live near the…', '🧊', 'Arctic Ocean', [
    'Indian Ocean',
    'Southern Ocean',
  ]),
  Fact(_g2, _g5, 'The Amazon rainforest is in…', '🌳', 'South America', [
    'Africa',
    'Europe',
  ]),
  Fact(_g2, _g5, 'The Sahara desert is in…', '🏜️', 'Africa', [
    'Asia',
    'Australia',
  ]),
  Fact(_g3, _g5, 'Mount Everest is in…', '🏔️', 'Asia', ['Europe', 'Africa']),
  Fact(_k, _g5, 'Koalas live wild in…', '🐨', 'Australia', [
    'Africa',
    'Europe',
  ]),
  Fact(_k, _g5, 'Tigers live wild in…', '🐯', 'Asia', [
    'Antarctica',
    'Australia',
  ]),
  Fact(_k, _g5, 'Elephants live in Africa and…', '🐘', 'Asia', [
    'Antarctica',
    'Europe',
  ]),
  Fact(_k, _g5, 'Earth is mostly covered with…', '🌍', 'Water', [
    'Sand',
    'Ice',
  ]),
  Fact(_k, _g5, 'Which is bigger?', '🌊', 'An ocean', ['A lake', 'A pond']),
  Fact(_k, _g5, 'Antarctica is covered with…', '🐧', 'Ice and snow', [
    'Sand',
    'Grass',
  ]),
  Fact(_k, _g5, 'Which one is a continent?', '🌍', 'Africa', [
    'Pacific',
    'Sahara',
  ]),
  Fact(_k, _g5, 'Which one is an ocean?', '🌊', 'Atlantic', [
    'Asia',
    'Everest',
  ]),
  Fact(_k, _g5, 'We live on the planet…', '🌍', 'Earth', ['Mars', 'The Moon']),
  Fact(_k, _g5, 'Whales and sharks swim in the…', '🐳', 'Ocean', [
    'Desert',
    'Forest',
  ]),
  // Countries and their continents.
  Fact(_g1, _g5, 'India is in…', '🇮🇳', 'Asia', ['Africa', 'Europe']),
  Fact(_g1, _g5, 'The United States is in…', '🇺🇸', 'North America', [
    'South America',
    'Europe',
  ]),
  Fact(_g2, _g5, 'Brazil is in…', '🇧🇷', 'South America', [
    'Africa',
    'North America',
  ]),
  Fact(_g2, _g5, 'France is in…', '🇫🇷', 'Europe', ['Asia', 'North America']),
  Fact(_g2, _g5, 'Egypt is in…', '🇪🇬', 'Africa', ['Asia', 'South America']),
  Fact(_g2, _g5, 'Japan is in…', '🇯🇵', 'Asia', ['Europe', 'Australia']),
  Fact(_g3, _g5, 'Kenya is in…', '🇰🇪', 'Africa', ['South America', 'Asia']),
  Fact(_g3, _g5, 'Canada is in…', '🇨🇦', 'North America', ['Europe', 'Asia']),
  Fact(_g3, _g5, 'Mexico is in…', '🇲🇽', 'North America', [
    'South America',
    'Europe',
  ]),
  // Oceans between places.
  Fact(
    _g2,
    _g5,
    'Which ocean goes all the way around Antarctica?',
    '🐧',
    'Southern Ocean',
    ['Arctic Ocean', 'Indian Ocean'],
  ),
  Fact(
    _g3,
    _g5,
    'Which ocean is between the Americas and Europe?',
    '🚢',
    'Atlantic Ocean',
    ['Pacific Ocean', 'Indian Ocean'],
  ),
  Fact(
    _g3,
    _g5,
    'Which ocean is between Asia and the Americas?',
    '🌊',
    'Pacific Ocean',
    ['Atlantic Ocean', 'Arctic Ocean'],
  ),
  Fact(_g3, _g5, 'Which ocean is south of India?', '🇮🇳', 'Indian Ocean', [
    'Arctic Ocean',
    'Atlantic Ocean',
  ]),
  Fact(
    _g4,
    _g5,
    'The imaginary line around the middle of Earth is the…',
    '🌍',
    'Equator',
    ['North Pole', 'Prime Meridian'],
  ),
  Fact(
    _g4,
    _g5,
    'Which continent does the equator NOT cross?',
    '🌍',
    'Europe',
    ['Africa', 'South America'],
  ),
];

// ------------------------------------------------------------- map skills
const mapFacts = [
  Fact(_g1, _g5, 'On most maps, north is at the…', '🗺️', 'Top', [
    'Bottom',
    'Left',
  ]),
  Fact(_g1, _g5, 'What is the opposite of north?', '🧭', 'South', [
    'East',
    'West',
  ]),
  Fact(_g1, _g5, 'What is the opposite of east?', '🧭', 'West', [
    'North',
    'South',
  ]),
  Fact(_g1, _g5, 'The sun rises in the…', '☀️', 'East', ['West', 'North']),
  Fact(_g1, _g5, 'The sun sets in the…', '🌙', 'West', ['East', 'South']),
  Fact(_g1, _g5, 'Which tool shows which way is north?', '🗺️', '🧭', [
    '🕐',
    '📏',
  ]),
  Fact(_g1, _g5, 'A globe is a round model of…', '🌍', 'Earth', [
    'The Moon',
    'The Sun',
  ]),
  Fact(_g1, _g5, 'A map is a drawing of a place seen from…', '🗺️', 'Above', [
    'Underground',
    'Inside',
  ]),
  Fact(
    _g2,
    _g5,
    'What tells you what the symbols on a map mean?',
    '🗺️',
    'The map key',
    ['The title', 'The compass'],
  ),
  Fact(
    _g2,
    _g5,
    'What do we call the arrows showing N, E, S and W on a map?',
    '🧭',
    'Compass rose',
    ['Map key', 'Scale'],
  ),
  Fact(_g2, _g5, 'On a map, blue usually shows…', '🗺️', 'Water', [
    'Roads',
    'Mountains',
  ]),
  Fact(_g2, _g5, 'On a map, green usually shows…', '🗺️', 'Forests and parks', [
    'Water',
    'Deserts',
  ]),
  Fact(
    _g2,
    _g5,
    'Going from north to south, you travel…',
    '🧭',
    'Down the map',
    ['Up the map', 'Across the map'],
  ),
  Fact(
    _g3,
    _g5,
    'What does a map scale help you work out?',
    '📏',
    'Real distances',
    ['The weather', 'The time'],
  ),
  Fact(
    _g3,
    _g5,
    'Which direction is halfway between north and east?',
    '🧭',
    'North-east',
    ['South-west', 'North-west'],
  ),
  Fact(
    _g3,
    _g5,
    'Which direction is halfway between south and west?',
    '🧭',
    'South-west',
    ['North-east', 'South-east'],
  ),
  Fact(_g3, _g5, 'The North Pole is at the very… of a globe', '🌍', 'Top', [
    'Middle',
    'Bottom',
  ]),
  Fact(
    _g3,
    _g5,
    'Which is colder: near the poles or near the equator?',
    '🧊',
    'Near the poles',
    ['Near the equator', 'They are the same'],
  ),
  Fact(
    _g4,
    _g5,
    'Lines on a map that run east to west are called…',
    '🌍',
    'Latitude',
    ['Longitude', 'Borders'],
  ),
  Fact(
    _g4,
    _g5,
    'Lines on a map that run from pole to pole are called…',
    '🌍',
    'Longitude',
    ['Latitude', 'Rivers'],
  ),
  Fact(_g4, _g5, 'The equator is at 0° of…', '🌍', 'Latitude', [
    'Longitude',
    'Altitude',
  ]),
  Fact(
    _g4,
    _g5,
    'Earth is split into a northern and southern…',
    '🌍',
    'Hemisphere',
    ['Continent', 'Ocean'],
  ),
  Fact(
    _g5,
    _g5,
    'A line of 0° longitude through London is the…',
    '🇬🇧',
    'Prime Meridian',
    ['Equator', 'Tropic of Cancer'],
  ),
  Fact(
    _g5,
    _g5,
    'A map showing hills with lines of equal height is a…',
    '🏔️',
    'Contour map',
    ['Road map', 'Weather map'],
  ),
];

// --------------------------------------------------------- capital cities
/// (country, flag or picture, capital) — capitals of well-known countries.
const capitalCities = [
  ('India', '🇮🇳', 'New Delhi'),
  ('the United States', '🇺🇸', 'Washington, D.C.'),
  ('the United Kingdom', '🇬🇧', 'London'),
  ('Japan', '🇯🇵', 'Tokyo'),
  ('China', '🇨🇳', 'Beijing'),
  ('Brazil', '🇧🇷', 'Brasília'),
  ('Egypt', '🇪🇬', 'Cairo'),
  ('Australia', '🇦🇺', 'Canberra'),
  ('Canada', '🇨🇦', 'Ottawa'),
  ('Mexico', '🇲🇽', 'Mexico City'),
  ('France', '🇫🇷', 'Paris'),
  ('Kenya', '🇰🇪', 'Nairobi'),
  ('Italy', '🗺️', 'Rome'),
  ('Germany', '🗺️', 'Berlin'),
  ('Spain', '🗺️', 'Madrid'),
  ('Russia', '🗺️', 'Moscow'),
  ('South Africa', '🗺️', 'Pretoria'),
  ('Argentina', '🗺️', 'Buenos Aires'),
  ('South Korea', '🗺️', 'Seoul'),
  ('Greece', '🗺️', 'Athens'),
  ('Thailand', '🗺️', 'Bangkok'),
  ('Peru', '🗺️', 'Lima'),
  ('New Zealand', '🗺️', 'Wellington'),
  ('Nigeria', '🗺️', 'Abuja'),
];
