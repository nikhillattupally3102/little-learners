import '../models/models.dart';

class PassageQuestion {
  const PassageQuestion(this.question, this.answer, this.wrong);
  final String question;
  final String answer;
  final List<String> wrong;
}

class Passage {
  const Passage(this.level, this.title, this.emoji, this.text, this.questions);
  final Level level;
  final String title;
  final String emoji;
  final String text;
  final List<PassageQuestion> questions;
}

typedef Q = PassageQuestion;

/// Original reading-comprehension passages, levelled K–5. Each passage has a
/// mix of question types: details, sequence, vocabulary, feelings, inference,
/// main idea, and (for older readers) fact vs. opinion and author's purpose.
const passages = [
  // ------------------------------------------------------------ kindergarten
  Passage(
    Level.kindergarten,
    "Sam's Red Ball",
    '🔴',
    'Sam has a red ball. He kicks the ball to his dog. The dog runs and gets it.',
    [
      Q('What color is the ball?', 'Red', ['Blue', 'Green']),
      Q('Who gets the ball?', 'The dog', ['The cat', 'Mom']),
      Q('What does Sam do with the ball?', 'Kicks it', ['Eats it', 'Hides it']),
      Q('What does the dog do?', 'Runs and gets the ball', [
        'Takes a nap',
        'Eats the ball',
      ]),
      Q('What is this story about?', 'Sam and his dog play ball', [
        'Sam goes to school',
        'A dog takes a bath',
      ]),
    ],
  ),
  Passage(
    Level.kindergarten,
    'The Hot Sun',
    '☀️',
    'The sun is up. It is hot. Mia puts on her hat and goes to the park.',
    [
      Q('Is it hot or cold?', 'Hot', ['Cold', 'Snowy']),
      Q('What does Mia put on?', 'Her hat', ['Her coat', 'Her boots']),
      Q('Where does Mia go?', 'The park', ['School', 'The store']),
      Q('Why does Mia put on a hat?', 'It is hot and sunny', [
        'It is snowing',
        'It is night',
      ]),
      Q('What is up in the sky?', 'The sun', ['The moon', 'A kite']),
    ],
  ),
  Passage(
    Level.kindergarten,
    'Ben the Frog',
    '🐸',
    'Ben is a green frog. He sits on a log. He jumps in the pond with a big splash!',
    [
      Q('What is Ben?', 'A frog', ['A dog', 'A fish']),
      Q('Where does Ben sit?', 'On a log', ['On a bed', 'In a car']),
      Q('Where does Ben jump?', 'In the pond', ['In the sand', 'On the bus']),
      Q('What color is Ben?', 'Green', ['Red', 'Blue']),
      Q('What happens when Ben jumps?', 'A big splash', [
        'He falls asleep',
        'He flies away',
      ]),
    ],
  ),
  Passage(
    Level.kindergarten,
    'Bedtime',
    '🌙',
    'It is night. Kim takes a bath. Dad reads her a book. Kim hugs her bear and goes to sleep.',
    [
      Q('When does the story happen?', 'At night', [
        'In the morning',
        'At lunch',
      ]),
      Q('Who reads the book?', 'Dad', ['Kim', 'Grandma']),
      Q('What does Kim hug?', 'Her bear', ['Her cat', 'Her pillow']),
      Q('What does Kim do first?', 'Takes a bath', [
        'Goes to sleep',
        'Hugs her bear',
      ]),
      Q('How does Kim feel at the end?', 'Sleepy', ['Hungry', 'Scared']),
    ],
  ),
  Passage(
    Level.kindergarten,
    'The Big Box',
    '📦',
    'Zara has a big box. She puts it on her head. Now she is a robot! Beep, beep!',
    [
      Q('What does Zara have?', 'A big box', ['A big ball', 'A red hat']),
      Q('Where does Zara put the box?', 'On her head', [
        'On the bed',
        'In the car',
      ]),
      Q('What does Zara pretend to be?', 'A robot', ['A cat', 'A fish']),
      Q('What happens first?', 'Zara gets a big box', [
        'Zara says beep',
        'Zara is a robot',
      ]),
      Q('How does Zara feel?', 'Happy', ['Sad', 'Mad']),
    ],
  ),
  Passage(
    Level.kindergarten,
    'Duck in the Rain',
    '🦆',
    'It is raining. Omar sees a duck. The duck is wet, but it is happy. Ducks like the rain! Quack, quack!',
    [
      Q('What is the weather like?', 'Rainy', ['Sunny', 'Snowy']),
      Q('What does Omar see?', 'A duck', ['A dog', 'A frog']),
      Q('Is the duck happy or sad?', 'Happy', ['Sad', 'Mad']),
      Q('Why is the duck happy?', 'Ducks like the rain', [
        'It has a hat',
        'It is hot',
      ]),
      Q('What sound does the duck make?', 'Quack', ['Moo', 'Woof']),
    ],
  ),
  Passage(
    Level.kindergarten,
    'Lunch Time',
    '🥪',
    'Kai is hungry. Mom makes him a sandwich. Kai eats it all up. Then he has an apple too.',
    [
      Q('How does Kai feel at the start?', 'Hungry', ['Sleepy', 'Cold']),
      Q('Who makes the sandwich?', 'Mom', ['Dad', 'Kai']),
      Q('What does Kai eat first?', 'A sandwich', ['An apple', 'A cookie']),
      Q('What does Kai eat last?', 'An apple', ['A sandwich', 'A banana']),
      Q('How much of the sandwich does Kai eat?', 'All of it', [
        'None of it',
        'One bite',
      ]),
    ],
  ),

  // ----------------------------------------------------------------- grade 1
  Passage(
    Level.grade1,
    'The Picnic',
    '🧺',
    'Lily and her dad went on a picnic. They packed sandwiches, apples and juice. '
        'They sat on a blue blanket under a big tree. A little bird came to eat the crumbs. '
        'Lily laughed and gave it a piece of bread.',
    [
      Q('Who went on the picnic?', 'Lily and her dad', [
        'Lily and her mom',
        "Lily's class",
      ]),
      Q('Where did they sit?', 'Under a big tree', [
        'On the beach',
        'In the kitchen',
      ]),
      Q('What did Lily give the bird?', 'Bread', ['An apple', 'Juice']),
      Q('What did they pack to drink?', 'Juice', ['Milk', 'Water']),
      Q('How did Lily feel when the bird came?', 'Happy', ['Scared', 'Angry']),
    ],
  ),
  Passage(
    Level.grade1,
    'Rainy Day Fort',
    '🌧️',
    'It was raining, so Max could not play outside. He built a fort with pillows and blankets. '
        'His sister crawled in with a flashlight. They read books in the fort until the rain stopped.',
    [
      Q("Why couldn't Max play outside?", 'It was raining', [
        'It was dark',
        'He was sick',
      ]),
      Q('What did Max build?', 'A fort', ['A boat', 'A snowman']),
      Q('What did they do in the fort?', 'Read books', [
        'Ate cake',
        'Played soccer',
      ]),
      Q('When did they stop reading?', 'When the rain stopped', [
        'When it got dark',
        'When Mom called',
      ]),
      Q('Who crawled into the fort?', 'His sister', ['His dog', 'His dad']),
    ],
  ),
  Passage(
    Level.grade1,
    'My Puppy Pip',
    '🐶',
    'I have a puppy named Pip. Pip has soft brown fur and floppy ears. '
        'Every morning Pip wakes me up by licking my nose. Then we go for a walk to the park.',
    [
      Q("What is the puppy's name?", 'Pip', ['Pat', 'Pop']),
      Q("What color is Pip's fur?", 'Brown', ['Black', 'White']),
      Q('How does Pip wake me up?', 'By licking my nose', [
        'By barking loudly',
        'By jumping on the bed',
      ]),
      Q('What do we do after Pip wakes me up?', 'Go for a walk', [
        'Eat breakfast',
        'Take a nap',
      ]),
      Q('What does "floppy" mean?', 'Soft and hanging down', [
        'Very tiny',
        'Stiff and pointy',
      ]),
    ],
  ),
  Passage(
    Level.grade1,
    'The Snail Race',
    '🐌',
    'Ravi and his sister found two snails in the garden. They drew a chalk line and put the snails at the start. '
        "Ravi's snail went the wrong way! His sister's snail slowly crossed the finish line. Everyone cheered, even Ravi.",
    [
      Q('Where did they find the snails?', 'In the garden', [
        'At school',
        'In the pond',
      ]),
      Q('What did they use to draw the line?', 'Chalk', ['Paint', 'A stick']),
      Q("What did Ravi's snail do?", 'Went the wrong way', [
        'Won the race',
        'Fell asleep',
      ]),
      Q('Whose snail won the race?', "His sister's snail", [
        "Ravi's snail",
        'Nobody won',
      ]),
      Q('What does "slowly" mean?', 'Not fast', ['Very loud', 'Very fast']),
      Q('What did Ravi do at the end?', 'He cheered too', [
        'He cried',
        'He went home',
      ]),
    ],
  ),
  Passage(
    Level.grade1,
    "Grandpa's Garden",
    '🍅',
    'Amara helps Grandpa in his garden. First, they dig small holes. Next, they drop in tomato seeds. '
        'Then they water the seeds. In a few weeks, little green plants pop up!',
    [
      Q('Who does Amara help?', 'Grandpa', ['Grandma', 'Her teacher']),
      Q('What do they do first?', 'Dig small holes', [
        'Water the seeds',
        'Pick tomatoes',
      ]),
      Q('What kind of seeds do they plant?', 'Tomato seeds', [
        'Apple seeds',
        'Sunflower seeds',
      ]),
      Q('What do they do after they drop in the seeds?', 'Water them', [
        'Dig holes',
        'Eat them',
      ]),
      Q('What happens in a few weeks?', 'Little plants pop up', [
        'It snows',
        'The seeds blow away',
      ]),
    ],
  ),
  Passage(
    Level.grade1,
    'The New Kid',
    '🎒',
    'Today a new boy named Diego came to our class. He sat alone at lunch and looked down at his tray. '
        'Hana asked him to sit with us. Diego smiled and told us about his pet turtle. Now he is our friend.',
    [
      Q('Who is new in the class?', 'Diego', ['Hana', 'The teacher']),
      Q('How did Diego feel at lunch at first?', 'Lonely', ['Silly', 'Angry']),
      Q('What did Hana do?', 'Asked Diego to sit with them', [
        'Gave him a turtle',
        'Told the teacher',
      ]),
      Q('What pet does Diego have?', 'A turtle', ['A puppy', 'A fish']),
      Q('What does this story teach?', 'Be kind to new kids', [
        'Always eat fast',
        'Turtles are slow',
      ]),
    ],
  ),

  // ----------------------------------------------------------------- grade 2
  Passage(
    Level.grade2,
    'The Class Garden',
    '🌱',
    "Ms. Lee's class planted a garden behind the school. Each student chose a seed to plant. "
        'Ava planted sunflowers, and Jay planted beans. Every day they watered the soil and pulled out weeds. '
        "After six weeks, Ava's sunflowers were taller than the fence! The class shared the beans at a garden party.",
    [
      Q('Where was the garden?', 'Behind the school', [
        "At Ava's house",
        'In the park',
      ]),
      Q('What did Jay plant?', 'Beans', ['Sunflowers', 'Carrots']),
      Q(
        'What did the students do every day?',
        'Watered the soil and pulled weeds',
        ['Picked flowers', 'Painted the fence'],
      ),
      Q(
        'What happened after six weeks?',
        'The sunflowers grew taller than the fence',
        ['The garden flooded', 'Birds ate all the seeds'],
      ),
      Q('How did the class most likely feel at the party?', 'Proud and happy', [
        'Bored',
        'Angry',
      ]),
    ],
  ),
  Passage(
    Level.grade2,
    'The Lost Mitten',
    '🧤',
    'On a snowy morning, Noah lost one of his red mittens. He looked under his bed, in his backpack and behind the couch. '
        'It was nowhere! Later, he saw his cat, Pepper, sleeping in a cozy ball. Tucked under her paws was the missing mitten.',
    [
      Q('What did Noah lose?', 'A red mitten', ['A blue hat', 'His backpack']),
      Q('Where did Noah NOT look?', 'In the kitchen', [
        'Under his bed',
        'Behind the couch',
      ]),
      Q('Who had the mitten?', 'Pepper the cat', ['His sister', 'The dog']),
      Q('What was the weather like?', 'Snowy', ['Sunny', 'Rainy']),
      Q('Which of these happened last?', 'Noah found the mitten under Pepper', [
        'Noah looked under his bed',
        'Noah lost his mitten',
      ]),
    ],
  ),
  Passage(
    Level.grade2,
    'Amazing Octopus',
    '🐙',
    'An octopus is a sea animal with eight arms. Each arm is covered in suckers that help it grab food. '
        'An octopus can change color to hide from enemies. If it is scared, it can squirt dark ink and swim away fast.',
    [
      Q('How many arms does an octopus have?', 'Eight', ['Six', 'Ten']),
      Q('What helps an octopus grab food?', 'Suckers', ['Teeth', 'Fins']),
      Q('Why does an octopus change color?', 'To hide from enemies', [
        'To find friends',
        'To stay warm',
      ]),
      Q('What does it squirt when it is scared?', 'Ink', ['Water', 'Bubbles']),
      Q(
        'What is the main idea?',
        'An octopus has clever ways to stay safe and eat',
        ['Octopuses live in trees', 'Ink is used for writing'],
      ),
    ],
  ),
  Passage(
    Level.grade2,
    'How Penguins Stay Warm',
    '🐧',
    'Emperor penguins live in Antarctica, one of the coldest places on Earth. '
        'They have a thick layer of fat under their skin and tightly packed feathers. '
        'In winter storms, hundreds of penguins huddle together in a big group. '
        'They take turns standing in the warm middle and on the chilly outside edge.',
    [
      Q('Where do emperor penguins live?', 'Antarctica', [
        'The desert',
        'The rainforest',
      ]),
      Q('What helps keep penguins warm?', 'Fat and thick feathers', [
        'Warm coats',
        'Hot water',
      ]),
      Q('What does "huddle" mean?', 'Crowd close together', [
        'Run away',
        'Dive deep',
      ]),
      Q(
        'Why do penguins take turns in the middle?',
        'So every penguin gets warm',
        ['To find food', 'To play a game'],
      ),
      Q('What is the main idea?', 'Penguins have ways to stay warm', [
        'Penguins can fly',
        'Antarctica is hot',
      ]),
    ],
  ),
  Passage(
    Level.grade2,
    'The Kite Contest',
    '🌬️',
    'Sofia built a kite from paper, sticks and string. On the day of the contest, the wind was weak, and most kites fell to the ground. '
        'Sofia ran as fast as she could, and her kite rose higher and higher. '
        'She did not win the prize for the highest kite, but the judges gave her a ribbon for the most colorful one. Sofia grinned all the way home.',
    [
      Q('What did Sofia use to build her kite?', 'Paper, sticks and string', [
        'Plastic and wood',
        'Cloth and glue',
      ]),
      Q('Why did most kites fall?', 'The wind was weak', [
        'It was raining',
        'The strings broke',
      ]),
      Q('What prize did Sofia get?', 'A ribbon for the most colorful kite', [
        'The prize for the highest kite',
        'A new kite',
      ]),
      Q('How did Sofia feel at the end?', 'Happy', ['Upset', 'Bored']),
      Q('What does "grinned" mean?', 'Smiled widely', ['Cried', 'Yawned']),
    ],
  ),
  Passage(
    Level.grade2,
    'The Library Card',
    '📚',
    'Malik turned seven and got his very first library card. He wanted to borrow every book about sharks. '
        'The librarian said he could take five books at a time. '
        'Malik picked five shark books and promised to bring them back in two weeks. Each night he read a chapter to his little brother.',
    [
      Q('How old did Malik turn?', 'Seven', ['Six', 'Eight']),
      Q('How many books could he take at a time?', 'Five', ['Two', 'Ten']),
      Q('What did Malik want to read about?', 'Sharks', ['Dinosaurs', 'Space']),
      Q('What did Malik do each night?', 'Read to his little brother', [
        'Watched TV',
        'Went to the library',
      ]),
      Q('When must Malik return the books?', 'In two weeks', [
        'Tomorrow',
        'In one year',
      ]),
    ],
  ),

  // ----------------------------------------------------------------- grade 3
  Passage(
    Level.grade3,
    "The Honeybee's Job",
    '🐝',
    'Honeybees live together in a hive that can hold thousands of bees. Worker bees fly from flower to flower collecting nectar, a sweet liquid. '
        'Back at the hive, they turn the nectar into honey and store it in wax cells. '
        'While visiting flowers, bees also carry pollen from one flower to another. '
        'This helps plants make seeds, so bees are very important to farmers.',
    [
      Q('What do worker bees collect from flowers?', 'Nectar', [
        'Water',
        'Leaves',
        'Seeds',
      ]),
      Q('Where is the honey stored?', 'In wax cells', [
        'Inside flowers',
        'Underground',
        'In leaves',
      ]),
      Q('Why are bees important to farmers?', 'They help plants make seeds', [
        'They scare away birds',
        'They water the crops',
        'They eat weeds',
      ]),
      Q('What is the main idea?', 'Honeybees have important jobs', [
        'Bees are scary',
        'Flowers are colorful',
        'Farmers like honey',
      ]),
      Q('What is nectar?', 'A sweet liquid in flowers', [
        'A kind of wax',
        'A type of bee',
        'A seed',
      ]),
    ],
  ),
  Passage(
    Level.grade3,
    "Maya's Lemonade Stand",
    '🍋',
    'Maya wanted to buy a new bike helmet that cost \$20. She decided to open a lemonade stand on Saturday. '
        'She sold each cup for 50 cents. By noon, the sun was blazing and a long line of thirsty neighbors had formed. '
        'At the end of the day, Maya counted her money: she had exactly \$20! She smiled, knowing she had earned the helmet herself.',
    [
      Q('Why did Maya open a lemonade stand?', 'To buy a bike helmet', [
        'To buy a new bike',
        'To meet her neighbors',
        'To help a friend',
      ]),
      Q('How much did each cup cost?', '50 cents', ['\$1', '25 cents', '\$2']),
      Q(
        'Why did a long line form by noon?',
        'It was hot and people were thirsty',
        ['The lemonade was free', 'There was a parade', 'It was raining'],
      ),
      Q('How did Maya most likely feel at the end?', 'Proud', [
        'Angry',
        'Bored',
        'Scared',
      ]),
      Q('Which word best describes Maya?', 'Hardworking', [
        'Lazy',
        'Rude',
        'Forgetful',
      ]),
    ],
  ),
  Passage(
    Level.grade3,
    'Why Leaves Change Color',
    '🍁',
    'In spring and summer, leaves are green because they contain chlorophyll, which helps trees make food from sunlight. '
        'In autumn, the days get shorter and cooler. Trees stop making chlorophyll, and the green fades away. '
        'Then the yellow and orange colors that were hidden in the leaves can finally be seen.',
    [
      Q('What makes leaves green?', 'Chlorophyll', ['Rain', 'Soil', 'Wind']),
      Q('In which season do leaves change color?', 'Autumn', [
        'Spring',
        'Summer',
      ]),
      Q('Why does the green color fade?', 'Trees stop making chlorophyll', [
        'The leaves get wet',
        'Birds eat the green',
        'The wind blows it off',
      ]),
      Q('What does "hidden" mean?', 'Not able to be seen', [
        'Very bright',
        'Broken',
        'Brand new',
      ]),
      Q(
        'What is the main idea?',
        'Leaves change color when trees stop making chlorophyll',
        [
          'Trees grow in spring',
          'Leaves are always green',
          'Wind blows leaves away',
        ],
      ),
    ],
  ),
  Passage(
    Level.grade3,
    'The Water Cycle',
    '💧',
    'The water on Earth is always moving. When the sun warms oceans and lakes, some water turns into an invisible gas called water vapor. '
        'This is called evaporation. High in the sky, the vapor cools and forms tiny drops that make clouds. '
        'When the drops grow heavy, they fall as rain or snow. The water flows into rivers and back to the ocean, and the cycle begins again.',
    [
      Q('What is evaporation?', 'Water turning into vapor', [
        'Rain falling',
        'Water freezing',
        'Rivers flowing',
      ]),
      Q('What happens when the vapor cools?', 'It forms clouds', [
        'It disappears forever',
        'It turns into sand',
        'It gets hotter',
      ]),
      Q('When does rain fall?', 'When the drops grow heavy', [
        'When the sun sets',
        'When the wind stops',
        'Only at night',
      ]),
      Q('What does "invisible" mean?', 'Cannot be seen', [
        'Very cold',
        'Very loud',
        'Very heavy',
      ]),
      Q('What is the main idea?', 'Water moves around Earth in a cycle', [
        'Clouds are white',
        'Oceans are salty',
        'Snow is cold',
      ]),
    ],
  ),
  Passage(
    Level.grade3,
    "Kofi's Big Kick",
    '⚽',
    'Kofi had practiced his soccer kicks every afternoon for a month. During the final game, the score was tied with one minute left. '
        'His coach called his name to take the penalty kick. Kofi\'s knees shook, but he remembered his practice. '
        'He took a deep breath and kicked the ball into the corner of the net. His teammates lifted him onto their shoulders.',
    [
      Q('How long had Kofi practiced?', 'Every afternoon for a month', [
        'Only once',
        'For one day',
        'Never',
      ]),
      Q("Why were Kofi's knees shaking?", 'He was nervous', [
        'He was cold',
        'He was hurt',
        'He was bored',
      ]),
      Q('What helped Kofi stay calm?', 'Remembering his practice', [
        'Closing his eyes',
        'Talking to the crowd',
        'Running away',
      ]),
      Q('What happened right after the kick?', 'His teammates lifted him up', [
        'The game was cancelled',
        'He fell down',
        'It started to rain',
      ]),
      Q('What lesson does the story show?', 'Practice pays off', [
        'Soccer is easy',
        'Never play sports',
        'Coaches are strict',
      ]),
    ],
  ),
  Passage(
    Level.grade3,
    "Lucia's Banana Bread",
    '🍌',
    'Lucia wanted to bake banana bread for her grandmother. First, she mashed three ripe bananas in a bowl. '
        'Next, she mixed in eggs, flour and a little sugar. Then her dad helped her put the pan in the hot oven. '
        'After an hour, the kitchen smelled sweet and warm. Her grandmother said it was the best banana bread she had ever tasted.',
    [
      Q('Who was the bread for?', 'Her grandmother', [
        'Her teacher',
        'Her dad',
        'Her friend',
      ]),
      Q('What did Lucia do first?', 'Mashed the bananas', [
        'Mixed in the flour',
        'Put the pan in the oven',
        'Washed the bowl',
      ]),
      Q('Why did her dad help with the oven?', 'The oven was hot', [
        'He was hungry',
        'Lucia was asleep',
        'The oven was broken',
      ]),
      Q('How long did the bread bake?', 'An hour', [
        'Ten minutes',
        'All day',
        'Two days',
      ]),
      Q('Which of these is an opinion?', 'It was the best banana bread ever', [
        'Lucia mashed three bananas',
        'Her dad helped with the oven',
        'The bread baked for an hour',
      ]),
    ],
  ),

  // ----------------------------------------------------------------- grade 4
  Passage(
    Level.grade4,
    'The Great Wall',
    '🧱',
    'The Great Wall of China is one of the largest structures ever built. It stretches thousands of miles across mountains, deserts and grasslands. '
        'Workers began building parts of it more than 2,000 years ago to protect the land from invaders. '
        'Guards stood in watchtowers along the wall and used smoke signals to warn of danger. '
        'Today, millions of tourists visit the wall each year to walk along its ancient stones.',
    [
      Q('Why was the Great Wall built?', 'To protect the land from invaders', [
        'To hold back floods',
        'To make a race track',
        'To store food',
      ]),
      Q('How did guards warn of danger?', 'With smoke signals', [
        'With radios',
        'By sending letters',
        'With fireworks',
      ]),
      Q('What does "ancient" mean?', 'Very old', [
        'Very large',
        'Brand new',
        'Broken',
      ]),
      Q(
        'Which statement is a fact from the passage?',
        'Building began over 2,000 years ago',
        [
          'The wall is made of gold',
          'The wall is one mile long',
          'Nobody visits the wall',
        ],
      ),
      Q(
        'What is the main idea?',
        'The Great Wall is a huge, ancient structure built for protection',
        ['Tourists like to walk', 'Smoke is dangerous', 'China has deserts'],
      ),
    ],
  ),
  Passage(
    Level.grade4,
    'The Science Fair',
    '🔬',
    'Priya wondered which brand of paper towel soaked up the most water. For the science fair, she poured 100 milliliters of water into each of three cups. '
        'She dipped a sheet of each brand into a cup for ten seconds and then measured how much water was left. '
        'Brand C left only 30 milliliters, the least of all. Priya concluded that Brand C was the most absorbent. '
        'Her teacher praised her for keeping the test fair by using the same amount of water and the same amount of time.',
    [
      Q(
        'What question did Priya want to answer?',
        'Which paper towel soaks up the most water',
        [
          'Which paper towel is cheapest',
          'Which paper towel is softest',
          'Which cup holds the most water',
        ],
      ),
      Q('Which brand was the most absorbent?', 'Brand C', [
        'Brand A',
        'Brand B',
      ]),
      Q('What made her test fair?', 'Same amount of water and time', [
        'She used her favorite brand',
        'She tested only one towel',
        'She asked her friends',
      ]),
      Q('What does "concluded" mean?', 'Decided after looking at the results', [
        'Started again',
        'Forgot about it',
        'Guessed before testing',
      ]),
      Q('How much water did Brand C leave in its cup?', '30 milliliters', [
        '100 milliliters',
        '10 milliliters',
        '50 milliliters',
      ]),
    ],
  ),
  Passage(
    Level.grade4,
    'Monarch Migration',
    '🦋',
    'Every autumn, millions of monarch butterflies leave Canada and the northern United States. '
        'They fly as far as 3,000 miles to forests in the mountains of Mexico. '
        'Scientists believe the butterflies use the position of the sun to find their way. '
        'In the warm forests, monarchs cluster together on tree branches to stay safe through winter. '
        'In spring, they begin the long journey back north.',
    [
      Q('Where do the monarchs travel in autumn?', 'Mexico', [
        'Canada',
        'Alaska',
        'Brazil',
      ]),
      Q(
        'How do scientists think monarchs find their way?',
        'By the position of the sun',
        ['By following roads', 'By the smell of the sea', 'By following birds'],
      ),
      Q(
        'Why do the monarchs fly south?',
        'To survive winter somewhere warmer',
        ['To find snow', 'To lay eggs in the ocean', 'To escape the rain'],
      ),
      Q('What does "cluster" mean?', 'Gather close together', [
        'Fly away quickly',
        'Change color',
        'Fall asleep',
      ]),
      Q(
        'What happens first in the passage?',
        'Monarchs leave Canada and the northern US',
        [
          'Monarchs cluster on branches',
          'Monarchs fly back north',
          'Spring arrives',
        ],
      ),
    ],
  ),
  Passage(
    Level.grade4,
    'Louis Braille',
    '📖',
    'Louis Braille was born in France in 1809. After an accident, he lost his sight when he was very young. '
        'At his school, books for blind students used large raised letters that were slow and hard to read. '
        'When Louis was only fifteen, he invented a system of raised dots that readers could feel with their fingertips. '
        'Today, people around the world read braille.',
    [
      Q('How did Louis lose his sight?', 'In an accident', [
        'He was born blind',
        'From old age',
        'From reading too much',
      ]),
      Q(
        'What was the problem with the old books?',
        'The raised letters were slow and hard to read',
        ['They had no pages', 'They were too colorful', 'They were too short'],
      ),
      Q('How old was Louis when he invented braille?', 'Fifteen', [
        'Five',
        'Thirty',
        'Fifty',
      ]),
      Q(
        'What does "system" mean in this passage?',
        'An organized way of doing something',
        ['A kind of book', 'A school building', 'A pair of glasses'],
      ),
      Q(
        "What is the author's purpose?",
        'To inform readers about Louis Braille',
        [
          'To persuade readers to visit France',
          'To tell a funny story',
          'To teach how to bake',
        ],
      ),
      Q(
        'Which detail shows Louis was determined?',
        'He invented a new system as a teenager',
        ['He was born in France', 'He went to school', 'He was born in 1809'],
      ),
    ],
  ),
  Passage(
    Level.grade4,
    'Under a Sky Full of Stars',
    '⛺',
    'On their first camping trip, Yuki and her mom set up a tent beside a quiet lake. '
        'As the sun went down, the air grew chilly, so Yuki zipped up her jacket. '
        'They roasted vegetables over the campfire and listened to frogs croaking in the reeds. '
        'Later, lying on her back, Yuki saw more stars than she had ever seen in the city. '
        'Her mom explained that bright city lights make it hard to see the stars.',
    [
      Q('Where did they set up the tent?', 'Beside a quiet lake', [
        'In the city',
        'On a mountain top',
        'In a backyard',
      ]),
      Q('Why did Yuki zip up her jacket?', 'The air grew chilly', [
        'It started raining',
        'She saw a bear',
        'She was going to sleep',
      ]),
      Q(
        'Why could Yuki see more stars at the lake?',
        'There were no bright city lights',
        ['The stars were closer', 'It was daytime', 'She used a telescope'],
      ),
      Q('What sound did they hear in the reeds?', 'Frogs croaking', [
        'Cars honking',
        'Dogs barking',
        'Owls hooting',
      ]),
      Q('What are "reeds"?', 'Tall grassy plants near water', [
        'Small fish',
        'Smooth rocks',
        'Wooden boats',
      ]),
    ],
  ),
  Passage(
    Level.grade4,
    'Every School Needs a Garden',
    '🥕',
    'Every school should have a garden. Gardens give students a chance to learn science outdoors as they watch seeds sprout and insects at work. '
        'Students who grow vegetables are often more willing to taste them. '
        'A garden also teaches responsibility, because plants need water and care every day. '
        'Some people say gardens cost too much, but many can be started with donated seeds and simple tools.',
    [
      Q(
        "What is the author's purpose?",
        'To persuade readers that schools should have gardens',
        [
          'To explain how to cook vegetables',
          'To tell a story about a farmer',
          'To describe a vacation',
        ],
      ),
      Q('Which is a reason the author gives?', 'Gardens teach responsibility', [
        'Gardens are noisy',
        'Vegetables are expensive',
        'Insects are scary',
      ]),
      Q('Which sentence is an opinion?', 'Every school should have a garden', [
        'Plants need water',
        'Seeds can sprout',
        'Insects live in gardens',
      ]),
      Q(
        'How does the author answer people who say gardens cost too much?',
        'Many can start with donated seeds and simple tools',
        [
          'Gardens are always free',
          'Schools have lots of money',
          'Students can pay for them',
        ],
      ),
      Q('What does "responsibility" mean?', 'Taking care of a duty', [
        'Running very fast',
        'Being silly',
        'Winning a prize',
      ]),
    ],
  ),

  // ----------------------------------------------------------------- grade 5
  Passage(
    Level.grade5,
    'Coral Reefs in Danger',
    '🐠',
    'Coral reefs cover less than one percent of the ocean floor, yet they are home to about a quarter of all ocean species. '
        'Although corals look like colorful rocks, they are actually made of tiny animals called polyps. '
        'Corals get much of their food from algae that live inside them. '
        'When ocean water becomes too warm, the corals push out the algae and turn white, a process called bleaching. '
        'Scientists and volunteers are working to protect reefs by reducing pollution and growing new corals in underwater nurseries.',
    [
      Q('What are corals made of?', 'Tiny animals called polyps', [
        'Colorful rocks',
        'Seaweed',
        'Sand',
      ]),
      Q('What causes coral bleaching?', 'Water that is too warm', [
        'Too many fish',
        'Strong waves',
        'Moonlight',
      ]),
      Q(
        'Why are reefs important even though they are small?',
        'They are home to many ocean species',
        [
          'They are made of gold',
          'They make the ocean salty',
          'They stop all storms',
        ],
      ),
      Q(
        "What is the author's main purpose?",
        'To inform readers about coral reefs',
        ['To make readers laugh', 'To sell a boat', 'To describe a vacation'],
      ),
      Q(
        'Which of these is an opinion, not a fact?',
        'Coral reefs are the most beautiful places on Earth',
        [
          'Corals are made of polyps',
          'Warm water can cause bleaching',
          'Algae live inside corals',
        ],
      ),
    ],
  ),
  Passage(
    Level.grade5,
    'The Missing Notebook',
    '🕵️',
    "When Leo's science notebook vanished the day before his project was due, he immediately blamed his little brother, Theo. "
        'But Theo had been at soccer practice all afternoon. Leo retraced his steps: the library, the bus, the kitchen table. '
        'At the library, the librarian smiled and pulled a blue notebook from the lost-and-found box. '
        'Leo felt his cheeks burn as he remembered accusing Theo. That evening, he apologized and offered to help Theo practice his penalty kicks.',
    [
      Q(
        "Why couldn't Theo have taken the notebook?",
        'He was at soccer practice',
        ['He was asleep', 'He was at the library', 'He was on the bus'],
      ),
      Q('Where was the notebook?', "In the library's lost-and-found", [
        'On the bus',
        'On the kitchen table',
        "In Theo's room",
      ]),
      Q('"Leo felt his cheeks burn" shows that he felt…', 'Embarrassed', [
        'Feverish',
        'Cold',
        'Excited',
      ]),
      Q(
        'What lesson does the story teach?',
        "Don't blame others without proof",
        [
          'Always play soccer',
          'Libraries are boring',
          'Never write in notebooks',
        ],
      ),
      Q('Which of these happened first?', 'Leo blamed Theo', [
        'Leo apologized',
        'The librarian found the notebook',
        'Leo helped Theo practice',
      ]),
    ],
  ),
  Passage(
    Level.grade5,
    'Power from Water',
    '⚡',
    'Moving water can be used to make electricity. At a hydroelectric dam, a river is blocked by a huge concrete wall, creating a lake called a reservoir. '
        'When gates in the dam open, water rushes through tunnels and spins giant wheels called turbines. '
        'The spinning turbines power generators, which produce electricity for homes and businesses. '
        'Because rivers keep flowing, hydroelectric power is a renewable energy source, but dams can also change habitats for fish and other wildlife.',
    [
      Q('What spins the turbines?', 'Rushing water', [
        'Wind',
        'Burning coal',
        'Sunlight',
      ]),
      Q('What is a reservoir?', 'A lake created by a dam', [
        'A kind of turbine',
        'A power line',
        'A type of fish',
      ]),
      Q('Why is hydroelectric power renewable?', 'Rivers keep flowing', [
        'Concrete lasts forever',
        'It burns coal',
        'It only works at night',
      ]),
      Q(
        'What is one drawback of dams?',
        'They can change habitats for wildlife',
        ['They stop the rain', 'They make too much smoke', 'They cool the Sun'],
      ),
      Q('What does "renewable" mean?', 'Able to be replaced naturally', [
        'Very expensive',
        'Used only once',
        'Dangerous',
      ]),
    ],
  ),
  Passage(
    Level.grade5,
    'The Secret of Mangroves',
    '🌳',
    'Mangrove trees grow along tropical coastlines where salty ocean water meets the land. '
        'Most plants would die in salt water, but mangroves can filter out much of the salt through their roots. '
        'Their tangled roots rise above the mud like stilts, slowing down waves and protecting the shore from storms. '
        'Beneath the water, those same roots shelter young fish, crabs and shrimp. '
        'Because mangroves store large amounts of carbon, scientists consider them important in fighting climate change.',
    [
      Q('Where do mangroves grow?', 'Along tropical coastlines', [
        'In deserts',
        'On mountain tops',
        'In the Arctic',
      ]),
      Q('How do mangrove roots protect the shore?', 'They slow down waves', [
        'They pull in more water',
        'They make the sand salty',
        'They block sunlight',
      ]),
      Q('What does "shelter" mean in this passage?', 'Give a safe place to', [
        'Eat',
        'Push away',
        'Count',
      ]),
      Q(
        'Why are mangroves important for the climate?',
        'They store large amounts of carbon',
        [
          'They create rain clouds',
          'They melt ice',
          'They make the sea warmer',
        ],
      ),
      Q(
        'What is the main idea?',
        'Mangroves are special trees that protect coasts and sea life',
        [
          'Salt water kills all plants',
          'Crabs live in mud',
          'Storms are dangerous',
        ],
      ),
      Q('What makes mangroves unusual?', 'They can live in salty water', [
        'They have no roots',
        'They grow in snow',
        'They are made of coral',
      ]),
    ],
  ),
  Passage(
    Level.grade5,
    'The Audition',
    '🎻',
    'Elena had practiced her violin solo for weeks, but when she stepped onto the stage for the orchestra audition, her mind went blank. '
        'The judges waited. Her hands trembled as she raised the bow. '
        'Then she noticed her teacher in the back row, quietly tapping the rhythm on her knee. '
        'Elena closed her eyes, followed the beat and let the music carry her. '
        'When the last note faded, one judge smiled and wrote something on her clipboard.',
    [
      Q(
        'What does "her mind went blank" mean?',
        'She could not remember what to do',
        ['She fell asleep', 'She felt very happy', 'She saw something white'],
      ),
      Q('How did Elena feel when she first stepped on stage?', 'Nervous', [
        'Bored',
        'Sleepy',
        'Angry',
      ]),
      Q('What helped Elena begin playing?', 'Her teacher tapping the rhythm', [
        'The judges clapping',
        'A loud noise',
        'Reading a book',
      ]),
      Q("What can you infer from the judge's smile?", 'Elena played well', [
        'Elena made many mistakes',
        'The judge was bored',
        'The audition was cancelled',
      ]),
      Q('What does "trembled" mean?', 'Shook', ['Glowed', 'Stretched', 'Grew']),
      Q(
        'What is the theme of the story?',
        'Staying calm can help you overcome fear',
        ['Violins are hard to carry', 'Judges are mean', 'Never practice'],
      ),
    ],
  ),
  Passage(
    Level.grade5,
    'Mae Jemison, Space Pioneer',
    '🚀',
    'Mae Jemison grew up in Chicago dreaming of space. She studied chemical engineering in college and later became a medical doctor. '
        'In 1987, NASA selected her for its astronaut program. '
        'In 1992, she flew aboard the space shuttle Endeavour, becoming the first African American woman to travel into space. '
        'During the mission, she helped carry out science experiments while orbiting Earth.',
    [
      Q(
        'Which two subjects did Mae Jemison study?',
        'Engineering and medicine',
        ['Art and music', 'History and law', 'Cooking and farming'],
      ),
      Q('In what year did she fly into space?', '1992', [
        '1987',
        '1969',
        '2001',
      ]),
      Q(
        'Why was her flight important?',
        'She was the first African American woman in space',
        [
          'She was the first person on the Moon',
          'She built the shuttle herself',
          'She flew alone',
        ],
      ),
      Q('How is this passage organized?', 'In time order', [
        'As a list of problems and solutions',
        'By comparing two people',
        'As questions and answers',
      ]),
      Q('What does "selected" mean?', 'Chosen', [
        'Rejected',
        'Paid',
        'Forgotten',
      ]),
    ],
  ),
];

// ------------------------------------------------------------- word lists

const letterWords = {
  'A': ('🍎', 'APPLE'),
  'B': ('🐻', 'BEAR'),
  'C': ('🐱', 'CAT'),
  'D': ('🐶', 'DOG'),
  'E': ('🐘', 'ELEPHANT'),
  'F': ('🐸', 'FROG'),
  'G': ('🍇', 'GRAPES'),
  'H': ('🏠', 'HOUSE'),
  'I': ('🍦', 'ICE CREAM'),
  'J': ('🧃', 'JUICE'),
  'K': ('🔑', 'KEY'),
  'L': ('🦁', 'LION'),
  'M': ('🐒', 'MONKEY'),
  'N': ('👃', 'NOSE'),
  'O': ('🐙', 'OCTOPUS'),
  'P': ('🐷', 'PIG'),
  'Q': ('👑', 'QUEEN'),
  'R': ('🌈', 'RAINBOW'),
  'S': ('☀️', 'SUN'),
  'T': ('🐯', 'TIGER'),
  'U': ('☂️', 'UMBRELLA'),
  'V': ('🎻', 'VIOLIN'),
  'W': ('🍉', 'WATERMELON'),
  'X': ('❌', 'X'),
  'Y': ('🧶', 'YARN'),
  'Z': ('🦓', 'ZEBRA'),
};

const listenWords = [
  ('🐱', 'cat'),
  ('🐶', 'dog'),
  ('🐟', 'fish'),
  ('🍎', 'apple'),
  ('⚽', 'ball'),
  ('🚗', 'car'),
  ('🦆', 'duck'),
  ('🐦', 'bird'),
  ('🎂', 'cake'),
  ('☀️', 'sun'),
  ('🌙', 'moon'),
  ('⭐', 'star'),
  ('🌳', 'tree'),
  ('🌸', 'flower'),
  ('🍌', 'banana'),
  ('🚌', 'bus'),
  ('🐮', 'cow'),
  ('🐷', 'pig'),
  ('🐸', 'frog'),
  ('🐻', 'bear'),
  ('🏠', 'house'),
  ('👟', 'shoe'),
  ('🎩', 'hat'),
  ('📖', 'book'),
  ('🎈', 'balloon'),
  ('👶', 'baby'),
  ('🥚', 'egg'),
  ('🍪', 'cookie'),
  ('🐘', 'elephant'),
  ('🦒', 'giraffe'),
];

/// (emoji, word split into sound chunks)
const soundOutWords = [
  ('🐱', 'c-a-t'),
  ('🐶', 'd-o-g'),
  ('☀️', 's-u-n'),
  ('🐷', 'p-i-g'),
  ('🚌', 'b-u-s'),
  ('🎩', 'h-a-t'),
  ('🛏️', 'b-e-d'),
  ('☕', 'c-u-p'),
  ('🦊', 'f-o-x'),
  ('🐔', 'h-e-n'),
  ('🦇', 'b-a-t'),
  ('🗺️', 'm-a-p'),
  ('🐀', 'r-a-t'),
  ('🐛', 'b-u-g'),
  ('📦', 'b-o-x'),
  ('🚐', 'v-a-n'),
  ('🕸️', 'w-e-b'),
  ('🔟', 't-e-n'),
  ('🍳', 'p-a-n'),
  ('🧢', 'c-a-p'),
  ('🦵', 'l-e-g'),
  ('🥅', 'n-e-t'),
];

/// Harder words with blends and digraphs (grade 1).
const blendWords = [
  ('🐸', 'f-r-o-g'),
  ('🚩', 'f-l-a-g'),
  ('🦀', 'c-r-a-b'),
  ('🥁', 'd-r-u-m'),
  ('⛺', 't-e-n-t'),
  ('🥛', 'm-i-l-k'),
  ('✋', 'h-a-n-d'),
  ('🛷', 's-l-e-d'),
  ('🚢', 'sh-i-p'),
  ('🦆', 'd-u-ck'),
  ('🐟', 'f-i-sh'),
  ('🧀', 'ch-ee-se'),
];

const letterSounds = {
  'a': 'ah',
  'b': 'buh',
  'c': 'kuh',
  'd': 'duh',
  'e': 'eh',
  'f': 'fff',
  'g': 'guh',
  'h': 'huh',
  'i': 'ih',
  'j': 'juh',
  'k': 'kuh',
  'l': 'lll',
  'm': 'mmm',
  'n': 'nnn',
  'o': 'aw',
  'p': 'puh',
  'q': 'kwuh',
  'r': 'rrr',
  's': 'sss',
  't': 'tuh',
  'u': 'uh',
  'v': 'vvv',
  'w': 'wuh',
  'x': 'ks',
  'y': 'yuh',
  'z': 'zzz',
  'sh': 'shh',
  'ch': 'chuh',
  'ck': 'kuh',
  'ee': 'ee',
};

/// Groups of rhyming words.
const rhymeGroups = [
  [('🐱', 'cat'), ('🎩', 'hat'), ('🦇', 'bat')],
  [('🐶', 'dog'), ('🐸', 'frog'), ('🌫️', 'fog')],
  [('🐝', 'bee'), ('🌳', 'tree'), ('🔑', 'key')],
  [('🎂', 'cake'), ('🐍', 'snake'), ('🏞️', 'lake')],
  [('🌙', 'moon'), ('🥄', 'spoon'), ('🎈', 'balloon')],
  [('⭐', 'star'), ('🚗', 'car'), ('🎸', 'guitar')],
  [('⛵', 'boat'), ('🐐', 'goat'), ('🧥', 'coat')],
  [('🐻', 'bear'), ('🪑', 'chair'), ('🍐', 'pear')],
  [('🦊', 'fox'), ('📦', 'box'), ('🧦', 'socks')],
  [('🐭', 'mouse'), ('🏠', 'house')],
  [('🐛', 'bug'), ('☕', 'mug'), ('🤗', 'hug')],
  [('🛏️', 'bed'), ('🍞', 'bread'), ('🛷', 'sled')],
  [('🐟', 'fish'), ('🍽️', 'dish')],
  [('💍', 'ring'), ('👑', 'king')],
];

/// (left, left emoji, right, right emoji)
const oppositePairs = [
  ('hot', '🔥', 'cold', '🧊'),
  ('up', '⬆️', 'down', '⬇️'),
  ('day', '☀️', 'night', '🌙'),
  ('happy', '😀', 'sad', '😢'),
  ('fast', '🐇', 'slow', '🐢'),
  ('big', '🐘', 'small', '🐭'),
  ('loud', '📢', 'quiet', '🤫'),
  ('left', '⬅️', 'right', '➡️'),
  ('wet', '💦', 'dry', '🏜️'),
  ('full', '🍔', 'empty', '🍽️'),
  ('open', '📖', 'closed', '📕'),
  ('awake', '😃', 'asleep', '😴'),
  ('old', '👴', 'young', '👶'),
  ('hard', '🧱', 'soft', '🧸'),
  ('light', '💡', 'dark', '🌑'),
  ('in', '📥', 'out', '📤'),
  ('tall', '🦒', 'short', '🐁'),
  ('sink', '⚓', 'float', '🦆'),
];

const sightWordsByLevel = {
  Level.kindergarten: [
    'and',
    'away',
    'big',
    'blue',
    'can',
    'come',
    'down',
    'find',
    'for',
    'funny',
    'go',
    'help',
    'here',
    'in',
    'is',
    'it',
    'jump',
    'little',
    'look',
    'make',
    'me',
    'my',
    'not',
    'one',
    'play',
    'red',
    'run',
    'said',
    'see',
    'the',
    'three',
    'to',
    'two',
    'up',
    'we',
    'where',
    'yellow',
    'you',
    'all',
    'am',
    'are',
    'at',
    'be',
    'but',
    'came',
    'did',
    'do',
    'eat',
    'get',
    'good',
    'have',
    'he',
    'like',
    'no',
    'now',
    'on',
    'out',
    'she',
    'so',
    'that',
    'they',
    'this',
    'was',
    'went',
    'what',
    'who',
    'will',
    'with',
    'yes',
  ],
  Level.grade1: [
    'after',
    'again',
    'any',
    'as',
    'ask',
    'by',
    'could',
    'every',
    'fly',
    'from',
    'give',
    'going',
    'had',
    'has',
    'her',
    'him',
    'his',
    'how',
    'just',
    'know',
    'let',
    'may',
    'of',
    'old',
    'once',
    'open',
    'over',
    'put',
    'round',
    'some',
    'stop',
    'take',
    'thank',
    'them',
    'then',
    'think',
    'walk',
    'were',
    'when',
  ],
  Level.grade2: [
    'always',
    'around',
    'because',
    'been',
    'before',
    'best',
    'both',
    'buy',
    'call',
    'cold',
    'does',
    'fast',
    'first',
    'five',
    'found',
    'gave',
    'goes',
    'green',
    'made',
    'many',
    'off',
    'or',
    'pull',
    'right',
    'sing',
    'sit',
    'sleep',
    'tell',
    'their',
    'these',
    'those',
    'upon',
    'us',
    'use',
    'very',
    'wash',
    'which',
    'why',
    'wish',
    'work',
    'would',
    'write',
    'your',
  ],
};

/// (emoji, word, syllables)
const syllableWords = [
  ('🐱', 'cat', 1),
  ('🐶', 'dog', 1),
  ('☀️', 'sun', 1),
  ('🐟', 'fish', 1),
  ('🌳', 'tree', 1),
  ('🍎', 'apple', 2),
  ('🐯', 'tiger', 2),
  ('🐰', 'rabbit', 2),
  ('✏️', 'pencil', 2),
  ('🐒', 'monkey', 2),
  ('🌈', 'rainbow', 2),
  ('🍕', 'pizza', 2),
  ('🐼', 'panda', 2),
  ('🍌', 'banana', 3),
  ('🐘', 'elephant', 3),
  ('🦋', 'butterfly', 3),
  ('🦕', 'dinosaur', 3),
  ('☂️', 'umbrella', 3),
  ('🍅', 'tomato', 3),
  ('🦘', 'kangaroo', 3),
  ('🍉', 'watermelon', 4),
  ('🐛', 'caterpillar', 4),
  ('🐊', 'alligator', 4),
  ('🚁', 'helicopter', 4),
  ('🥑', 'avocado', 4),
];

const nouns = [
  'dog',
  'school',
  'apple',
  'teacher',
  'park',
  'ball',
  'river',
  'book',
  'city',
  'bird',
  'chair',
  'sister',
];
const verbs = [
  'run',
  'jump',
  'swim',
  'eat',
  'sing',
  'write',
  'climb',
  'throw',
  'laugh',
  'build',
  'dance',
  'shout',
];
const adjectives = [
  'happy',
  'tall',
  'red',
  'soft',
  'tiny',
  'loud',
  'cold',
  'shiny',
  'brave',
  'sticky',
  'gentle',
  'fuzzy',
];
const adverbs = [
  'quickly',
  'softly',
  'loudly',
  'slowly',
  'happily',
  'carefully',
  'neatly',
  'gently',
  'bravely',
  'quietly',
];

const compoundWords = [
  ('sun', 'flower'),
  ('rain', 'bow'),
  ('foot', 'ball'),
  ('cup', 'cake'),
  ('star', 'fish'),
  ('butter', 'fly'),
  ('pan', 'cake'),
  ('tooth', 'brush'),
  ('snow', 'man'),
  ('bed', 'room'),
  ('sea', 'shell'),
  ('play', 'ground'),
  ('back', 'pack'),
  ('light', 'house'),
  ('pop', 'corn'),
  ('gold', 'fish'),
  ('air', 'plane'),
  ('home', 'work'),
  ('lady', 'bug'),
  ('pea', 'nut'),
];

/// (sentence with ___, answer, wrong options, level range)
const gapSentences = [
  (Level.grade1, Level.grade1, 'I can ___ the ball.', 'kick', ['sky', 'blue']),
  (Level.grade1, Level.grade1, 'The sun is very ___.', 'hot', ['cold', 'wet']),
  (Level.grade1, Level.grade2, 'A fish can ___.', 'swim', ['fly', 'read']),
  (
    Level.grade1,
    Level.grade1,
    'We ___ with our eyes.',
    'see',
    ['hear', 'smell'],
  ),
  (
    Level.grade1,
    Level.grade2,
    'The dog ___ at the cat.',
    'barked',
    ['sang', 'read'],
  ),
  (
    Level.grade1,
    Level.grade1,
    'I drink ___ from a cup.',
    'milk',
    ['shoes', 'bread'],
  ),
  (
    Level.grade1,
    Level.grade2,
    'Birds use their ___ to fly.',
    'wings',
    ['wheels', 'fins'],
  ),
  (
    Level.grade1,
    Level.grade2,
    'Put on your ___ before it rains.',
    'raincoat',
    ['sunglasses', 'swimsuit'],
  ),
  (
    Level.grade2,
    Level.grade3,
    'We need an ___ when it rains.',
    'umbrella',
    ['apple', 'eagle'],
  ),
  (
    Level.grade2,
    Level.grade3,
    'My brother is taller ___ me.',
    'than',
    ['then', 'that'],
  ),
  (
    Level.grade2,
    Level.grade3,
    'They ___ to the park yesterday.',
    'went',
    ['go', 'going'],
  ),
  (
    Level.grade2,
    Level.grade3,
    'The baby was tired, so she went to ___.',
    'bed',
    ['school', 'lunch'],
  ),
  (
    Level.grade2,
    Level.grade3,
    'She ___ her teeth every morning.',
    'brushes',
    ['sleeps', 'paints'],
  ),
  (
    Level.grade2,
    Level.grade3,
    'The giraffe used its long ___ to reach the leaves.',
    'neck',
    ['tail', 'ears'],
  ),
  (
    Level.grade3,
    Level.grade3,
    'The scientist looked through a ___ to see the stars.',
    'telescope',
    ['microscope', 'stethoscope'],
  ),
  (
    Level.grade3,
    Level.grade3,
    'He was so ___ that he ate two sandwiches.',
    'hungry',
    ['sleepy', 'tiny'],
  ),
  (
    Level.grade3,
    Level.grade3,
    'Please ___ the window. It is cold in here.',
    'close',
    ['open', 'paint'],
  ),
  (
    Level.grade3,
    Level.grade3,
    'The team ___ the game, so they got a trophy.',
    'won',
    ['lost', 'forgot'],
  ),
];

/// (word, synonym, antonym, level range)
const meaningWords = [
  (Level.grade2, Level.grade3, 'happy', 'glad', 'sad'),
  (Level.grade2, Level.grade3, 'big', 'large', 'small'),
  (Level.grade2, Level.grade3, 'fast', 'quick', 'slow'),
  (Level.grade2, Level.grade3, 'begin', 'start', 'finish'),
  (Level.grade2, Level.grade3, 'shout', 'yell', 'whisper'),
  (Level.grade2, Level.grade3, 'scared', 'afraid', 'brave'),
  (Level.grade2, Level.grade4, 'smart', 'clever', 'foolish'),
  (Level.grade3, Level.grade4, 'difficult', 'hard', 'easy'),
  (Level.grade3, Level.grade4, 'gather', 'collect', 'scatter'),
  (Level.grade3, Level.grade5, 'enormous', 'huge', 'tiny'),
  (Level.grade3, Level.grade5, 'ancient', 'old', 'modern'),
  (Level.grade4, Level.grade5, 'fortunate', 'lucky', 'unlucky'),
  (Level.grade4, Level.grade5, 'furious', 'angry', 'calm'),
  (Level.grade4, Level.grade5, 'timid', 'shy', 'bold'),
  (Level.grade4, Level.grade5, 'vanish', 'disappear', 'appear'),
  (Level.grade4, Level.grade5, 'generous', 'giving', 'selfish'),
  (Level.grade4, Level.grade5, 'rare', 'uncommon', 'common'),
  (Level.grade5, Level.grade5, 'expand', 'grow', 'shrink'),
  (Level.grade5, Level.grade5, 'temporary', 'brief', 'permanent'),
  (Level.grade5, Level.grade5, 'artificial', 'fake', 'natural'),
];

/// (sentence with ___, answer, wrong)
const homophoneSentences = [
  ('I can ___ the ocean from here.', 'see', ['sea']),
  ('The ___ is shining brightly.', 'sun', ['son']),
  ('I have ___ dogs.', 'two', ['too', 'to']),
  ('I want ___ go home.', 'to', ['two', 'too']),
  ('Can you ___ the music?', 'hear', ['here']),
  ("___ going to the park.", "They're", ['There', 'Their']),
  ('Put the box over ___.', 'there', ['their', "they're"]),
  ('The kids put on ___ coats.', 'their', ['there', "they're"]),
  ('We ___ the race!', 'won', ['one']),
  ('Please ___ your name.', 'write', ['right']),
  ('Turn ___ at the corner.', 'right', ['write']),
  ('I ___ a sandwich for lunch.', 'ate', ['eight']),
  ('The spider has ___ legs.', 'eight', ['ate']),
  ('The wind ___ my hat away.', 'blew', ['blue']),
  ('Do you ___ the answer?', 'know', ['no']),
  ('A ___ ran into the forest.', 'deer', ['dear']),
  ('She ___ the ball to me.', 'threw', ['through']),
  ('We walked ___ the tunnel.', 'through', ['threw']),
  ('___ is my backpack?', 'Where', ['Wear']),
  ('We waited for an ___.', 'hour', ['our']),
];

/// (prefix/suffix, meaning, example word, base word, is prefix)
const wordParts = [
  ('un', 'not', 'unhappy', 'happy', true),
  ('re', 'again', 'replay', 'play', true),
  ('pre', 'before', 'preheat', 'heat', true),
  ('dis', 'the opposite of', 'disagree', 'agree', true),
  ('mis', 'wrongly', 'misspell', 'spell', true),
  ('over', 'too much', 'overcook', 'cook', true),
  ('ful', 'full of', 'helpful', 'help', false),
  ('less', 'without', 'fearless', 'fear', false),
  ('er', 'a person who', 'teacher', 'teach', false),
  ('able', 'able to be', 'washable', 'wash', false),
  ('ness', 'the state of being', 'kindness', 'kind', false),
];

/// (correct sentence, wrong versions, level range)
const sentenceFixes = [
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
    "\"Let's go,\" said Dad.",
    ["\"Let's go\" said Dad.", "Let's go, said Dad.", "\"lets go,\" said Dad."],
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
];

/// (correct spelling, misspellings, level range)
const spellingWords = [
  (Level.grade2, Level.grade3, 'because', ['becuase', 'becos']),
  (Level.grade2, Level.grade3, 'friend', ['freind', 'frend']),
  (Level.grade2, Level.grade2, 'said', ['sed', 'siad']),
  (Level.grade2, Level.grade3, 'would', ['wuld', 'woud']),
  (Level.grade2, Level.grade3, 'people', ['peple', 'poeple']),
  (Level.grade2, Level.grade3, 'school', ['skool', 'shcool']),
  (Level.grade2, Level.grade2, 'again', ['agin', 'agen']),
  (Level.grade2, Level.grade2, 'they', ['thay', 'tey']),
  (Level.grade3, Level.grade4, 'different', ['diffrent', 'diferent']),
  (Level.grade3, Level.grade4, 'beautiful', ['beutiful', 'beautifull']),
  (Level.grade3, Level.grade4, 'favorite', ['favrite', 'faverite']),
  (Level.grade3, Level.grade5, 'believe', ['beleive', 'belive']),
  (Level.grade3, Level.grade4, 'tomorrow', ['tommorow', 'tomorow']),
  (Level.grade3, Level.grade4, 'library', ['libary', 'librery']),
  (Level.grade4, Level.grade5, 'February', ['Febuary', 'Februery']),
  (Level.grade4, Level.grade5, 'Wednesday', ['Wensday', 'Wednsday']),
  (Level.grade4, Level.grade5, 'surprise', ['suprise', 'surprize']),
  (Level.grade4, Level.grade5, 'calendar', ['calender', 'calandar']),
  (Level.grade4, Level.grade5, 'necessary', ['neccessary', 'necesary']),
  (Level.grade4, Level.grade5, 'receive', ['recieve', 'receeve']),
  (Level.grade5, Level.grade5, 'definitely', ['definately', 'definitly']),
  (Level.grade5, Level.grade5, 'environment', ['enviroment', 'environmint']),
  (Level.grade5, Level.grade5, 'restaurant', ['resturant', 'restaraunt']),
  (Level.grade5, Level.grade5, 'rhythm', ['rythm', 'rhythem']),
  (Level.grade5, Level.grade5, 'knowledge', ['knowlege', 'nowledge']),
];

/// Simple picture words for missing-letter spelling (K–1).
const pictureSpellWords = [
  ('🐱', 'CAT'),
  ('🐶', 'DOG'),
  ('☀️', 'SUN'),
  ('🐟', 'FISH'),
  ('🐝', 'BEE'),
  ('🎂', 'CAKE'),
  ('⭐', 'STAR'),
  ('🐸', 'FROG'),
  ('🌳', 'TREE'),
  ('🌙', 'MOON'),
  ('🦆', 'DUCK'),
  ('📖', 'BOOK'),
  ('🚗', 'CAR'),
  ('🎩', 'HAT'),
  ('🐷', 'PIG'),
  ('🐮', 'COW'),
  ('🚌', 'BUS'),
  ('🍎', 'APPLE'),
  ('🏠', 'HOUSE'),
  ('🐻', 'BEAR'),
];

// ------------------------------------------------- extra formats (listen)

/// (animal emoji, the sound it makes)
const animalSoundWords = [
  ('🐮', 'moo'),
  ('🐶', 'woof'),
  ('🐱', 'meow'),
  ('🦆', 'quack'),
  ('🐷', 'oink'),
  ('🐑', 'baa'),
  ('🦁', 'roar'),
  ('🐸', 'ribbit'),
  ('🐝', 'buzz'),
  ('🐴', 'neigh'),
  ('🦉', 'hoot'),
  ('🐍', 'hiss'),
];

/// (emoji, color name) — hearts, so every picture is the same shape.
const colorHearts = [
  ('❤️', 'red'),
  ('💙', 'blue'),
  ('💚', 'green'),
  ('💛', 'yellow'),
  ('💜', 'purple'),
  ('🧡', 'orange'),
];

/// (emoji, body part)
const bodyParts = [
  ('👃', 'nose'),
  ('👀', 'eyes'),
  ('👂', 'ear'),
  ('👄', 'mouth'),
  ('✋', 'hand'),
  ('🦶', 'foot'),
  ('🦷', 'tooth'),
  ('👅', 'tongue'),
];

/// (animal emoji, animal, favorite food emoji)
const animalFoods = [
  ('🐰', 'bunny', '🥕'),
  ('🐒', 'monkey', '🍌'),
  ('🐭', 'mouse', '🧀'),
  ('🐶', 'dog', '🦴'),
  ('🐻', 'bear', '🍯'),
  ('🐱', 'cat', '🐟'),
];

const thingsThatFly = ['🐦', '🦋', '✈️', '🐝', '🚁', '🦅'];
const thingsThatDontFly = ['🐶', '🚗', '🐟', '🐢', '🏠', '🐘', '🚂', '🐄'];

// ------------------------------------------------ extra formats (letters)

/// Lots of pictures to sort by their first letter.
const startPictures = [
  ('🍎', 'APPLE'),
  ('🐜', 'ANT'),
  ('🐊', 'ALLIGATOR'),
  ('🐻', 'BEAR'),
  ('⚽', 'BALL'),
  ('🍌', 'BANANA'),
  ('🐝', 'BEE'),
  ('🚌', 'BUS'),
  ('🐱', 'CAT'),
  ('🎂', 'CAKE'),
  ('🚗', 'CAR'),
  ('🐄', 'COW'),
  ('🥕', 'CARROT'),
  ('🐶', 'DOG'),
  ('🦆', 'DUCK'),
  ('🥁', 'DRUM'),
  ('🍩', 'DONUT'),
  ('🐘', 'ELEPHANT'),
  ('🥚', 'EGG'),
  ('🐸', 'FROG'),
  ('🐟', 'FISH'),
  ('🦊', 'FOX'),
  ('🔥', 'FIRE'),
  ('🍇', 'GRAPES'),
  ('🐐', 'GOAT'),
  ('🎁', 'GIFT'),
  ('🏠', 'HOUSE'),
  ('🎩', 'HAT'),
  ('🐴', 'HORSE'),
  ('❤️', 'HEART'),
  ('🧃', 'JUICE'),
  ('🧥', 'JACKET'),
  ('👖', 'JEANS'),
  ('🔑', 'KEY'),
  ('🦘', 'KANGAROO'),
  ('🐨', 'KOALA'),
  ('🦁', 'LION'),
  ('🍋', 'LEMON'),
  ('🍃', 'LEAF'),
  ('🐞', 'LADYBUG'),
  ('🐒', 'MONKEY'),
  ('🌙', 'MOON'),
  ('🥛', 'MILK'),
  ('🐭', 'MOUSE'),
  ('👃', 'NOSE'),
  ('🍜', 'NOODLES'),
  ('🐙', 'OCTOPUS'),
  ('🦉', 'OWL'),
  ('🍊', 'ORANGE'),
  ('🐷', 'PIG'),
  ('🍕', 'PIZZA'),
  ('🐧', 'PENGUIN'),
  ('🍐', 'PEAR'),
  ('✏️', 'PENCIL'),
  ('👑', 'QUEEN'),
  ('🌈', 'RAINBOW'),
  ('🐰', 'RABBIT'),
  ('🚀', 'ROCKET'),
  ('🤖', 'ROBOT'),
  ('💍', 'RING'),
  ('☀️', 'SUN'),
  ('🐍', 'SNAKE'),
  ('🧦', 'SOCKS'),
  ('⭐', 'STAR'),
  ('🥄', 'SPOON'),
  ('🐯', 'TIGER'),
  ('🌳', 'TREE'),
  ('🐢', 'TURTLE'),
  ('🍅', 'TOMATO'),
  ('🚂', 'TRAIN'),
  ('☂️', 'UMBRELLA'),
  ('🦄', 'UNICORN'),
  ('🎻', 'VIOLIN'),
  ('🚐', 'VAN'),
  ('🌋', 'VOLCANO'),
  ('🍉', 'WATERMELON'),
  ('🐳', 'WHALE'),
  ('🐺', 'WOLF'),
  ('⌚', 'WATCH'),
  ('🧶', 'YARN'),
  ('🦓', 'ZEBRA'),
];

/// Consonants whose spoken sound is easy to tell apart (no c/k/q/x clashes).
const clearSoundLetters = [
  'b',
  'd',
  'f',
  'g',
  'h',
  'j',
  'l',
  'm',
  'n',
  'p',
  'r',
  's',
  't',
  'v',
  'w',
  'z',
];

// --------------------------------------------- extra formats (ABC order)

/// Words that share a first letter but differ at the second letter.
const sameStartWords = [
  ['bat', 'bed', 'big', 'box', 'bus'],
  ['hat', 'hen', 'hip', 'hot', 'hug'],
  ['man', 'men', 'mix', 'mop', 'mud'],
  ['pan', 'pet', 'pig', 'pot', 'pup'],
  ['tap', 'ten', 'tip', 'top', 'tub'],
  ['sad', 'set', 'sit', 'sock', 'sun'],
  ['fan', 'fed', 'fit', 'fox', 'fun'],
];

// ---------------------------------------------- extra formats (sound out)

/// Word families: swap the first letter to make a new word.
const wordFamilies = [
  ['cat', 'hat', 'bat', 'mat', 'rat', 'sat', 'pat'],
  ['can', 'fan', 'man', 'pan', 'van', 'ran'],
  ['big', 'dig', 'pig', 'wig', 'fig'],
  ['dog', 'fog', 'log', 'hog', 'jog'],
  ['bun', 'fun', 'run', 'sun'],
  ['bug', 'hug', 'mug', 'rug', 'jug'],
  ['hen', 'pen', 'ten', 'men'],
  ['hop', 'mop', 'pop', 'top'],
  ['bed', 'red', 'fed', 'led'],
  ['lip', 'sip', 'tip', 'zip', 'hip', 'dip'],
  ['jet', 'net', 'pet', 'wet', 'vet', 'set'],
];

/// Made-up words for "which one is real?" (none are English words).
const nonsenseWords = [
  'dax',
  'fep',
  'gub',
  'hif',
  'jop',
  'kem',
  'mip',
  'rif',
  'sut',
  'tob',
  'vam',
  'yot',
  'zib',
  'bem',
  'fot',
  'nid',
  'lom',
  'tiv',
  'pab',
  'vog',
  'fim',
  'zem',
];

// --------------------------------------------------- extra formats (rhymes)

/// (sentence with ___, answer emoji, answer word). Every answer rhymes with
/// a word in its own sentence and with no other answer.
const rhymeSentences = [
  ('The cat wore a ___.', '🎩', 'hat'),
  ('The goat sailed a ___.', '⛵', 'boat'),
  ('The bear sat on a ___.', '🪑', 'chair'),
  ('The fox hid in a ___.', '📦', 'box'),
  ('The mouse ran into the ___.', '🏠', 'house'),
  ('The snake ate some ___.', '🎂', 'cake'),
  ('The bee sat in a ___.', '🌳', 'tree'),
  ('The dog played with a ___.', '🐸', 'frog'),
  ('Look at the moon! Look at my ___.', '🎈', 'balloon'),
  ('The king has a gold ___.', '💍', 'ring'),
  ('The fish swam to a ___.', '🍽️', 'dish'),
  ('Ted ate bread in his ___.', '🛏️', 'bed'),
  ('The bug gave me a ___.', '🤗', 'hug'),
  ('I wished on a star from my ___.', '🚗', 'car'),
];

// ---------------------------------------------- extra formats (word match)

const wordCategories = {
  'an animal': [
    'cat',
    'dog',
    'fish',
    'duck',
    'bird',
    'cow',
    'pig',
    'frog',
    'bear',
    'horse',
  ],
  'a food': [
    'apple',
    'banana',
    'cake',
    'egg',
    'cookie',
    'bread',
    'milk',
    'pizza',
    'grapes',
  ],
  'something you wear': ['shoe', 'hat', 'sock', 'coat', 'shirt', 'mitten'],
  'something that goes': ['car', 'bus', 'train', 'boat', 'plane', 'bike'],
};

// ----------------------------------------------- extra formats (opposites)

/// Opposite pairs whose pictures are easy to tell apart (left word).
const clearOpposites = {
  'hot',
  'up',
  'day',
  'happy',
  'fast',
  'big',
  'awake',
  'old',
  'wet',
  'hard',
};

/// (sentence with ___, answer, wrong)
const oppositeSentences = [
  ('The elephant is big, but the mouse is ___.', 'small', ['huge', 'loud']),
  ('Summer is hot, but winter is ___.', 'cold', ['warm', 'sunny']),
  ('The turtle is slow, but the rabbit is ___.', 'fast', ['green', 'slow']),
  ('The door was open, but now it is ___.', 'closed', ['open', 'hungry']),
  ('I walk up the stairs, then I come ___.', 'down', ['up', 'blue']),
  ('My cup was full, but now it is ___.', 'empty', ['full', 'happy']),
  ('The baby was awake, but now she is ___.', 'asleep', ['awake', 'tall']),
  ('The lion is loud, but the mouse is ___.', 'quiet', ['loud', 'wet']),
  ('We play in the day and sleep at ___.', 'night', ['noon', 'lunch']),
  ('Grandpa is old, and the baby is ___.', 'young', ['old', 'tall']),
  ('A rock is hard, but a pillow is ___.', 'soft', ['hard', 'heavy']),
  ('The giraffe is tall, but the mouse is ___.', 'short', ['tall', 'long']),
  ('My towel was wet, but the sun made it ___.', 'dry', ['wet', 'loud']),
];

// --------------------------------------------- extra formats (sight words)

/// (level, sentence with ___, answer, wrong)
const sightSentences = [
  (Level.kindergarten, 'I ___ a big red ball.', 'see', ['the', 'up']),
  (Level.kindergarten, 'Look at ___ cat!', 'the', ['is', 'we']),
  (Level.kindergarten, 'We can ___ and play.', 'run', ['the', 'is']),
  (Level.kindergarten, 'The ball is ___ the box.', 'in', ['and', 'see']),
  (Level.kindergarten, 'Can you ___ me?', 'help', ['the', 'is']),
  (Level.kindergarten, 'Mom ___, "Come here!"', 'said', ['is', 'up']),
  (Level.kindergarten, 'I like ___ dog.', 'my', ['am', 'at']),
  (Level.kindergarten, 'The sun is ___.', 'yellow', ['and', 'where']),
  (
    Level.grade1,
    '___ upon a time, there was a king.',
    'Once',
    ['Could', 'Every'],
  ),
  (Level.grade1, 'Can I ___ you a gift?', 'give', ['of', 'them']),
  (Level.grade1, 'Please ___ the door.', 'open', ['over', 'of']),
  (Level.grade1, 'I ___ how to swim.', 'know', ['once', 'from']),
  (Level.grade1, 'The bird can ___ high.', 'fly', ['had', 'of']),
  (Level.grade1, 'I ate ___ cake.', 'some', ['once', 'fly']),
  (Level.grade1, 'Mia ___ a new puppy.', 'has', ['of', 'then']),
  (Level.grade1, 'We will ___ to school.', 'walk', ['when', 'any']),
  (
    Level.grade2,
    'I like ice cream ___ it is sweet.',
    'because',
    ['before', 'which'],
  ),
  (Level.grade2, 'Please ___ your hands.', 'wash', ['sing', 'upon']),
  (Level.grade2, 'I will ___ my name.', 'write', ['wish', 'very']),
  (Level.grade2, 'The cookies are ___ good!', 'very', ['upon', 'both']),
  (Level.grade2, 'Do you know ___ the sky is blue?', 'why', ['been', 'those']),
  (Level.grade2, 'We ___ go to bed at eight.', 'always', ['upon', 'those']),
  (Level.grade2, 'They put on ___ coats.', 'their', ['upon', 'been']),
  (Level.grade2, 'I ___ a new book at the store.', 'found', ['upon', 'does']),
];

// ----------------------------------------------- extra formats (syllables)

/// More picture words for clapping: (emoji, word, syllables).
const moreSyllableWords = [
  ('🐸', 'frog', 1),
  ('⭐', 'star', 1),
  ('🐝', 'bee', 1),
  ('🚀', 'rocket', 2),
  ('🍪', 'cookie', 2),
  ('🐧', 'penguin', 2),
  ('🐢', 'turtle', 2),
  ('🥕', 'carrot', 2),
  ('🎃', 'pumpkin', 2),
  ('🌻', 'sunflower', 3),
  ('🍍', 'pineapple', 3),
  ('🎹', 'piano', 3),
  ('🐞', 'ladybug', 3),
  ('🚲', 'bicycle', 3),
  ('📺', 'television', 4),
];

/// Syllable breaks for multi-syllable words.
const syllableSplits = {
  'apple': 'ap-ple',
  'tiger': 'ti-ger',
  'rabbit': 'rab-bit',
  'pencil': 'pen-cil',
  'monkey': 'mon-key',
  'rainbow': 'rain-bow',
  'pizza': 'piz-za',
  'panda': 'pan-da',
  'banana': 'ba-na-na',
  'elephant': 'el-e-phant',
  'butterfly': 'but-ter-fly',
  'dinosaur': 'di-no-saur',
  'umbrella': 'um-brel-la',
  'tomato': 'to-ma-to',
  'kangaroo': 'kan-ga-roo',
  'watermelon': 'wa-ter-mel-on',
  'caterpillar': 'cat-er-pil-lar',
  'alligator': 'al-li-ga-tor',
  'helicopter': 'hel-i-cop-ter',
  'avocado': 'av-o-ca-do',
  'rocket': 'rock-et',
  'cookie': 'cook-ie',
  'penguin': 'pen-guin',
  'turtle': 'tur-tle',
  'carrot': 'car-rot',
  'pumpkin': 'pump-kin',
  'sunflower': 'sun-flow-er',
  'pineapple': 'pine-ap-ple',
  'piano': 'pi-an-o',
  'ladybug': 'la-dy-bug',
  'bicycle': 'bi-cy-cle',
  'television': 'tel-e-vi-sion',
};

// ------------------------------------------------- extra formats (grammar)

/// (sentence, noun, verb, adjective, adverb)
const taggedSentences = [
  ('The happy dog runs quickly.', 'dog', 'runs', 'happy', 'quickly'),
  ('A tiny bird sings softly.', 'bird', 'sings', 'tiny', 'softly'),
  ('The brave girl climbs carefully.', 'girl', 'climbs', 'brave', 'carefully'),
  ('My little brother laughs loudly.', 'brother', 'laughs', 'little', 'loudly'),
  ('The hungry cat eats slowly.', 'cat', 'eats', 'hungry', 'slowly'),
  ('The kind teacher smiles warmly.', 'teacher', 'smiles', 'kind', 'warmly'),
  ('Two sleepy owls hoot quietly.', 'owls', 'hoot', 'sleepy', 'quietly'),
  ('Our noisy class claps happily.', 'class', 'claps', 'noisy', 'happily'),
  ('The shiny car stops suddenly.', 'car', 'stops', 'shiny', 'suddenly'),
  ('A huge whale swims gracefully.', 'whale', 'swims', 'huge', 'gracefully'),
  ('The busy baker works fast.', 'baker', 'works', 'busy', 'fast'),
];

/// (level, singular, plural, wrong)
const plurals = [
  (Level.grade1, 'fox', 'foxes', ['foxs', 'foxies']),
  (Level.grade1, 'box', 'boxes', ['boxs', 'boxies']),
  (Level.grade1, 'dish', 'dishes', ['dishs', 'dishies']),
  (Level.grade1, 'bus', 'buses', ['buss', 'busies']),
  (Level.grade1, 'cat', 'cats', ['cates', 'caties']),
  (Level.grade1, 'dog', 'dogs', ['doges', 'dogies']),
  (Level.grade1, 'bench', 'benches', ['benchs', 'benchies']),
  (Level.grade1, 'baby', 'babies', ['babys', 'babyes']),
  (Level.grade1, 'puppy', 'puppies', ['puppys', 'puppyes']),
  (Level.grade2, 'child', 'children', ['childs', 'childrens']),
  (Level.grade2, 'mouse', 'mice', ['mouses', 'mices']),
  (Level.grade2, 'tooth', 'teeth', ['tooths', 'teeths']),
  (Level.grade2, 'foot', 'feet', ['foots', 'feets']),
  (Level.grade2, 'man', 'men', ['mans', 'mens']),
  (Level.grade2, 'wolf', 'wolves', ['wolfs', 'wolfes']),
  (Level.grade2, 'sheep', 'sheep', ['sheeps', 'sheepes']),
  (Level.grade3, 'goose', 'geese', ['gooses', 'geeses']),
  (Level.grade3, 'knife', 'knives', ['knifes', 'knifs']),
  (Level.grade3, 'cactus', 'cacti', ['cactuss', 'cactuses']),
];

/// (level, present, past, wrong)
const pastTenses = [
  (Level.grade1, 'jump', 'jumped', ['jumpt', 'jumps']),
  (Level.grade1, 'play', 'played', ['plaied', 'plays']),
  (Level.grade1, 'walk', 'walked', ['walkt', 'walks']),
  (Level.grade1, 'hop', 'hopped', ['hopt', 'hops']),
  (Level.grade1, 'bake', 'baked', ['bakeed', 'bakes']),
  (Level.grade1, 'cry', 'cried', ['cryed', 'cries']),
  (Level.grade1, 'look', 'looked', ['lookt', 'looks']),
  (Level.grade2, 'run', 'ran', ['runned', 'runs']),
  (Level.grade2, 'eat', 'ate', ['eated', 'eats']),
  (Level.grade2, 'go', 'went', ['goed', 'goes']),
  (Level.grade2, 'see', 'saw', ['seen', 'sees']),
  (Level.grade2, 'swim', 'swam', ['swimmed', 'swims']),
  (Level.grade2, 'write', 'wrote', ['writed', 'writes']),
  (Level.grade2, 'take', 'took', ['taked', 'takes']),
  (Level.grade3, 'think', 'thought', ['thinked', 'thinks']),
  (Level.grade3, 'catch', 'caught', ['catched', 'catches']),
  (Level.grade3, 'bring', 'brought', ['bringed', 'brang']),
  (Level.grade3, 'teach', 'taught', ['teached', 'teaches']),
];

const properNouns = [
  'monday',
  'friday',
  'june',
  'texas',
  'canada',
  'mexico',
  'maya',
  'omar',
  'london',
  'december',
  'saturday',
  'kenya',
];
const commonNouns = [
  'city',
  'dog',
  'school',
  'morning',
  'park',
  'river',
  'apple',
  'teacher',
  'day',
  'month',
  'country',
  'girl',
];

/// (sentence, sentence with ___, pronoun)
const pronounSentences = [
  ('Maya plays soccer.', '___ plays soccer.', 'She'),
  ('Omar reads a book.', '___ reads a book.', 'He'),
  ('The dog wags its tail.', '___ wags its tail.', 'It'),
  ('Leo and Ava ride bikes.', '___ ride bikes.', 'They'),
  ('My friend and I like pizza.', '___ like pizza.', 'We'),
  ('Grandma bakes bread.', '___ bakes bread.', 'She'),
  ('Mr. Kim drives the bus.', '___ drives the bus.', 'He'),
  ('The kites fly high.', '___ fly high.', 'They'),
  ('The bell rings at noon.', '___ rings at noon.', 'It'),
];

/// (long form, contraction, wrong)
const contractions = [
  ('do not', "don't", ['dont', "do'nt"]),
  ('cannot', "can't", ['cant', "ca'nt"]),
  ('I am', "I'm", ['Im', "I'am"]),
  ('it is', "it's", ['its', "it'is"]),
  ('we are', "we're", ['were', "we'ar"]),
  ('is not', "isn't", ['isnt', "is'nt"]),
  ('you will', "you'll", ['youll', "you'ill"]),
  ('she is', "she's", ['shes', "she'is"]),
  ('did not', "didn't", ['didnt', "did'nt"]),
  ('I have', "I've", ['Ive', "I'hve"]),
  ('let us', "let's", ['lets', "let'us"]),
  ('they are', "they're", ['theyre', "the'yre"]),
];

// ---------------------------------------------- extra formats (compounds)

/// Compound words with a picture.
const compoundPictures = [
  ('🌻', 'sunflower'),
  ('🌈', 'rainbow'),
  ('🏈', 'football'),
  ('🧁', 'cupcake'),
  ('🦋', 'butterfly'),
  ('🥞', 'pancake'),
  ('⛄', 'snowman'),
  ('🐚', 'seashell'),
  ('🎒', 'backpack'),
  ('🍿', 'popcorn'),
  ('🐠', 'goldfish'),
  ('✈️', 'airplane'),
  ('🐞', 'ladybug'),
  ('🥜', 'peanut'),
];

/// Made-up joins that are NOT real compound words.
const fakeCompounds = [
  'cupbow',
  'sunpack',
  'footcorn',
  'rainnut',
  'bedfly',
  'snowshell',
  'toothplane',
  'backcake',
  'homeshell',
  'ladycorn',
  'popground',
  'peaflower',
];

/// (sentence with ___ for the second part, answer, wrong)
const compoundSentences = [
  ('I put my books in my back___.', 'pack', ['cake', 'fish']),
  ('We built a snow___ with a carrot nose.', 'man', ['cake', 'bug']),
  ('A lady___ landed on my hand.', 'bug', ['cake', 'room']),
  ('We ate pop___ at the movies.', 'corn', ['fish', 'shell']),
  ('The butter___ has orange wings.', 'fly', ['room', 'shell']),
  ('I found a sea___ on the beach.', 'shell', ['cake', 'bow']),
  ('After school, I do my home___.', 'work', ['fly', 'corn']),
  ('A rain___ came out after the storm.', 'bow', ['cake', 'shell']),
  ("Let's play foot___ at recess.", 'ball', ['cake', 'fly']),
  ('Dad flipped a pan___ for breakfast.', 'cake', ['fly', 'shell']),
  ('My bed___ has blue walls.', 'room', ['fly', 'corn']),
];

// ------------------------------------------------- extra formats (fill gap)

/// (min, max, emoji clue, sentence with ___, answer, wrong)
const pictureGaps = [
  (
    Level.grade1,
    Level.grade2,
    '🐟',
    'The ___ swims in the pond.',
    'fish',
    ['cow', 'bus'],
  ),
  (
    Level.grade1,
    Level.grade2,
    '🌧️',
    'Take an umbrella. It is going to ___.',
    'rain',
    ['sing', 'jump'],
  ),
  (
    Level.grade1,
    Level.grade3,
    '🎂',
    'We ate ___ at my birthday party.',
    'cake',
    ['rocks', 'socks'],
  ),
  (
    Level.grade1,
    Level.grade2,
    '🚌',
    'We ride the ___ to school.',
    'bus',
    ['cow', 'cake'],
  ),
  (
    Level.grade1,
    Level.grade2,
    '🌙',
    'At night, the ___ shines in the sky.',
    'moon',
    ['sun', 'grass'],
  ),
  (
    Level.grade1,
    Level.grade3,
    '🐝',
    'A ___ makes honey.',
    'bee',
    ['frog', 'cat'],
  ),
  (
    Level.grade2,
    Level.grade3,
    '🧤',
    'My hands are cold, so I wear ___.',
    'mittens',
    ['sandals', 'goggles'],
  ),
  (
    Level.grade2,
    Level.grade3,
    '🔥',
    'Do not touch the stove. It is ___.',
    'hot',
    ['cold', 'soft'],
  ),
  (
    Level.grade2,
    Level.grade3,
    '🦷',
    'I brush my ___ every night.',
    'teeth',
    ['shoes', 'books'],
  ),
  (
    Level.grade2,
    Level.grade3,
    '🌈',
    'After the rain, we saw a ___ in the sky.',
    'rainbow',
    ['river', 'fence'],
  ),
  (
    Level.grade3,
    Level.grade3,
    '🧭',
    'The hikers used a ___ to find north.',
    'compass',
    ['calendar', 'camera'],
  ),
  (
    Level.grade3,
    Level.grade3,
    '🌋',
    'Hot lava poured out of the ___.',
    'volcano',
    ['glacier', 'meadow'],
  ),
  (
    Level.grade3,
    Level.grade3,
    '🧲',
    'The ___ pulled the paper clips toward it.',
    'magnet',
    ['pillow', 'ruler'],
  ),
];

/// (min, max, sentence with ___, two words that fit, one that does not)
const notFitGaps = [
  (
    Level.grade1,
    Level.grade2,
    'I ate an ___ for a snack.',
    ['apple', 'orange'],
    'chair',
  ),
  (
    Level.grade1,
    Level.grade2,
    'The ___ ran across the yard.',
    ['dog', 'cat'],
    'house',
  ),
  (
    Level.grade1,
    Level.grade2,
    'I like to ___ at the park.',
    ['play', 'run'],
    'table',
  ),
  (
    Level.grade1,
    Level.grade2,
    'The sky is ___ today.',
    ['blue', 'gray'],
    'hungry',
  ),
  (
    Level.grade1,
    Level.grade3,
    'We read a ___ in class.',
    ['book', 'story'],
    'banana',
  ),
  (
    Level.grade2,
    Level.grade3,
    'She ___ to school every day.',
    ['walks', 'rides'],
    'sleeps',
  ),
  (
    Level.grade2,
    Level.grade3,
    'The ___ kitten slept in a basket.',
    ['tiny', 'fluffy'],
    'loudly',
  ),
  (
    Level.grade2,
    Level.grade3,
    'Please ___ the dishes after dinner.',
    ['wash', 'dry'],
    'sing',
  ),
  (
    Level.grade3,
    Level.grade3,
    'The explorers ___ the dark cave.',
    ['entered', 'explored'],
    'swallowed',
  ),
  (
    Level.grade3,
    Level.grade3,
    'He felt ___ before his big test.',
    ['nervous', 'worried'],
    'triangle',
  ),
];

/// (min, max, sentence with two ___, answer "a / b", wrong)
const doubleGaps = [
  (
    Level.grade2,
    Level.grade3,
    'The ___ dog ___ at the mail carrier.',
    'big / barked',
    ['big / meowed', 'blue / slept'],
  ),
  (
    Level.grade2,
    Level.grade3,
    'I ___ my teeth before I go to ___.',
    'brush / bed',
    ['comb / bed', 'brush / sky'],
  ),
  (
    Level.grade2,
    Level.grade3,
    'We wore ___ because it was ___ outside.',
    'coats / cold',
    ['shorts / cold', 'coats / hot'],
  ),
  (
    Level.grade2,
    Level.grade3,
    'Plants need ___ and ___ to grow.',
    'water / sunlight',
    ['juice / darkness', 'water / candy'],
  ),
  (
    Level.grade2,
    Level.grade3,
    'The ___ fell from the tree in the ___.',
    'leaves / fall',
    ['leaves / ocean', 'rocks / fall'],
  ),
  (
    Level.grade3,
    Level.grade3,
    'Leo was ___ because he ___ the race.',
    'proud / won',
    ['proud / lost', 'sad / won'],
  ),
  (
    Level.grade3,
    Level.grade3,
    'The library is ___, so please speak ___.',
    'quiet / softly',
    ['loud / softly', 'quiet / loudly'],
  ),
  (
    Level.grade3,
    Level.grade3,
    'The ___ astronaut floated ___ the space station.',
    'brave / inside',
    ['brave / under the sea', 'sleepy / inside a pond'],
  ),
];

/// (emoji, noun) for "a" or "an".
const anNouns = [
  ('🍎', 'apple'),
  ('🥚', 'egg'),
  ('🦉', 'owl'),
  ('🐙', 'octopus'),
  ('🐜', 'ant'),
  ('☂️', 'umbrella'),
  ('🍊', 'orange'),
  ('🐘', 'elephant'),
];
const aNouns = [
  ('🐶', 'dog'),
  ('🍌', 'banana'),
  ('🐸', 'frog'),
  ('🚗', 'car'),
  ('⭐', 'star'),
  ('🐝', 'bee'),
  ('🦒', 'giraffe'),
  ('🎈', 'balloon'),
];

// -------------------------------------------- extra formats (word meanings)

/// A sentence using each word in [meaningWords].
const meaningSentences = {
  'happy': 'Ava was happy to see her friend.',
  'big': 'We saw a big truck on the road.',
  'fast': 'The fast runner won the race.',
  'begin': 'The show will begin at noon.',
  'shout': 'Please do not shout in the hallway.',
  'scared': 'The kitten was scared of the thunder.',
  'smart': 'The smart fox found a way out.',
  'difficult': 'The puzzle was difficult to solve.',
  'gather': 'We gather shells at the beach.',
  'enormous': 'An enormous whale swam past the boat.',
  'ancient': 'The museum has ancient coins.',
  'fortunate': 'We were fortunate to find a seat.',
  'furious': 'The coach was furious about the broken window.',
  'timid': 'The timid puppy hid behind the couch.',
  'vanish': 'The magician made the coin vanish.',
  'generous': 'Our generous neighbor shared her tomatoes.',
  'rare': 'Snow is rare in this warm town.',
  'expand': 'A balloon will expand when you blow air into it.',
  'temporary': 'The road closing is only temporary.',
  'artificial': 'The candy was made with artificial colors.',
};

/// (min, max, sentence, word, meaning, wrong)
const contextClues = [
  (
    Level.grade3,
    Level.grade4,
    'The path was so narrow that only one person could walk on it at a time.',
    'narrow',
    'not wide',
    ['very long', 'muddy'],
  ),
  (
    Level.grade3,
    Level.grade4,
    'Ravi was exhausted after running five miles, so he lay down to rest.',
    'exhausted',
    'very tired',
    ['very hungry', 'excited'],
  ),
  (
    Level.grade3,
    Level.grade4,
    'The soup was scalding, so we waited for it to cool before eating.',
    'scalding',
    'very hot',
    ['very salty', 'frozen'],
  ),
  (
    Level.grade3,
    Level.grade5,
    'Mei was reluctant to jump into the cold lake and stood on the shore for a long time.',
    'reluctant',
    'not wanting to do something',
    ['excited', 'in a hurry'],
  ),
  (
    Level.grade3,
    Level.grade5,
    'The fragile vase broke when it fell off the shelf.',
    'fragile',
    'easily broken',
    ['very heavy', 'brand new'],
  ),
  (
    Level.grade4,
    Level.grade5,
    'The desert is arid; it hardly ever rains there.',
    'arid',
    'very dry',
    ['very windy', 'crowded'],
  ),
  (
    Level.grade4,
    Level.grade5,
    'After the long drought, the farmers were thrilled when the rain finally came.',
    'drought',
    'a long time without rain',
    ['a big storm', 'a busy market'],
  ),
  (
    Level.grade4,
    Level.grade5,
    'Jamal was famished after skipping lunch, so he ate two plates of rice.',
    'famished',
    'very hungry',
    ['very sleepy', 'angry'],
  ),
  (
    Level.grade4,
    Level.grade5,
    'The directions were so vague that nobody knew what to do.',
    'vague',
    'not clear',
    ['very short', 'funny'],
  ),
  (
    Level.grade5,
    Level.grade5,
    'The scientist was meticulous, checking every measurement three times.',
    'meticulous',
    'very careful about details',
    ['careless', 'in a hurry'],
  ),
  (
    Level.grade5,
    Level.grade5,
    'The crowd was jubilant when the team scored the winning goal.',
    'jubilant',
    'full of joy',
    ['very quiet', 'disappointed'],
  ),
  (
    Level.grade5,
    Level.grade5,
    'Because the bridge was unstable, officials closed it until repairs were made.',
    'unstable',
    'not steady or safe',
    ['brand new', 'very long'],
  ),
];

/// Words from weakest to strongest.
const shadesOfMeaning = [
  ['warm', 'hot', 'boiling'],
  ['cool', 'cold', 'freezing'],
  ['like', 'love', 'adore'],
  ['nibble', 'eat', 'devour'],
  ['walk', 'jog', 'sprint'],
  ['whisper', 'talk', 'shout'],
  ['damp', 'wet', 'soaked'],
  ['glad', 'happy', 'overjoyed'],
  ['big', 'huge', 'gigantic'],
  ['upset', 'angry', 'furious'],
  ['good', 'great', 'fantastic'],
  ['small', 'tiny', 'microscopic'],
];

// --------------------------------------------- extra formats (homophones)

/// Groups of words that sound the same: (word, meaning).
const homophoneSets = [
  [('sea', 'the ocean'), ('see', 'to look at')],
  [('sun', 'the star that lights the day'), ('son', 'a boy child')],
  [('two', 'the number 2'), ('too', 'also'), ('to', 'toward')],
  [('hear', 'to listen'), ('here', 'in this place')],
  [('won', 'came in first'), ('one', 'the number 1')],
  [('write', 'to put words on paper'), ('right', 'correct')],
  [('ate', 'had food'), ('eight', 'the number 8')],
  [('blew', 'pushed out air'), ('blue', 'a color')],
  [('know', 'to understand'), ('no', 'the opposite of yes')],
  [('deer', 'a forest animal'), ('dear', 'loved')],
  [('threw', 'tossed'), ('through', 'in one side and out the other')],
  [('flower', 'a blooming plant'), ('flour', 'powder used for baking')],
  [('night', 'when it is dark'), ('knight', 'a soldier in armor')],
  [('pair', 'a set of two'), ('pear', 'a fruit')],
  [('tail', 'part of an animal'), ('tale', 'a story')],
  [('meet', 'to get together'), ('meat', 'food from animals')],
  [('week', 'seven days'), ('weak', 'not strong')],
  [('sail', 'to travel by boat'), ('sale', 'selling at a low price')],
  [('road', 'a street'), ('rode', 'traveled on')],
  [('hole', 'an opening'), ('whole', 'all of something')],
  [('knew', 'understood'), ('new', 'not old')],
  [('for', 'meant for someone'), ('four', 'the number 4')],
  [('buy', 'to pay for'), ('by', 'next to')],
  [('plain', 'simple'), ('plane', 'an airplane')],
];

/// Pairs that look alike but do NOT sound the same.
const nearHomophones = [
  ('then', 'than'),
  ('were', 'where'),
  ('quiet', 'quite'),
  ('lose', 'loose'),
  ('dessert', 'desert'),
  ('chose', 'choose'),
  ('angel', 'angle'),
  ('breath', 'breathe'),
  ('cloth', 'clothe'),
  ('later', 'latter'),
];

/// (sentence with one wrong sound-alike, the wrong word, other words from the sentence)
const homophoneMistakes = [
  ('I ate eight grapes and a pair for lunch.', 'pair', ['eight', 'grapes']),
  ('The knight road his horse to the castle.', 'road', ['knight', 'horse']),
  ('We went to sea the new movie.', 'sea', ['went', 'new']),
  ('My brother is to tall for the ride.', 'to', ['brother', 'tall']),
  ('Please right your name at the top.', 'right', ['Please', 'name']),
  ('The wind blue my hat away.', 'blue', ['wind', 'hat']),
  ('I need for apples to make the pie.', 'for', ['need', 'apples']),
  ('We saw a dear eating grass in the field.', 'dear', ['saw', 'grass']),
  ('Mix the flower, eggs and sugar in a bowl.', 'flower', ['eggs', 'bowl']),
  ('The dog wagged its tale happily.', 'tale', ['dog', 'wagged']),
  ('She red three books last week.', 'red', ['three', 'week']),
  ('Their going to the beach tomorrow.', 'Their', ['going', 'beach']),
];

// --------------------------------------------- extra formats (word parts)

/// (affix, is prefix, word, base, what the word means)
const affixWords = [
  ('un', true, 'unhappy', 'happy', 'not happy'),
  ('un', true, 'unkind', 'kind', 'not kind'),
  ('un', true, 'unfair', 'fair', 'not fair'),
  ('un', true, 'unsafe', 'safe', 'not safe'),
  ('re', true, 'replay', 'play', 'play again'),
  ('re', true, 'reread', 'read', 'read again'),
  ('re', true, 'rebuild', 'build', 'build again'),
  ('re', true, 'refill', 'fill', 'fill again'),
  ('pre', true, 'preheat', 'heat', 'heat before'),
  ('pre', true, 'preview', 'view', 'view before'),
  ('dis', true, 'disagree', 'agree', 'the opposite of agree'),
  ('dis', true, 'dislike', 'like', 'the opposite of like'),
  ('dis', true, 'disappear', 'appear', 'the opposite of appear'),
  ('mis', true, 'misspell', 'spell', 'spell wrongly'),
  ('mis', true, 'misread', 'read', 'read wrongly'),
  ('over', true, 'overcook', 'cook', 'cook too much'),
  ('over', true, 'oversleep', 'sleep', 'sleep too much'),
  ('ful', false, 'helpful', 'help', 'full of help'),
  ('ful', false, 'joyful', 'joy', 'full of joy'),
  ('ful', false, 'careful', 'care', 'full of care'),
  ('less', false, 'fearless', 'fear', 'without fear'),
  ('less', false, 'careless', 'care', 'without care'),
  ('less', false, 'harmless', 'harm', 'without harm'),
  ('er', false, 'teacher', 'teach', 'a person who teaches'),
  ('er', false, 'painter', 'paint', 'a person who paints'),
  ('er', false, 'farmer', 'farm', 'a person who farms'),
  ('able', false, 'washable', 'wash', 'able to be washed'),
  ('able', false, 'breakable', 'break', 'able to be broken'),
  ('able', false, 'readable', 'read', 'able to be read'),
  ('ness', false, 'kindness', 'kind', 'the state of being kind'),
  ('ness', false, 'darkness', 'dark', 'the state of being dark'),
  ('ness', false, 'sadness', 'sad', 'the state of being sad'),
  ('ly', false, 'quickly', 'quick', 'in a quick way'),
  ('ly', false, 'softly', 'soft', 'in a soft way'),
];

const affixMeanings = {
  'un': 'not',
  're': 'again',
  'pre': 'before',
  'dis': 'the opposite of',
  'mis': 'wrongly',
  'over': 'too much',
  'ful': 'full of',
  'less': 'without',
  'er': 'a person who',
  'able': 'able to be',
  'ness': 'the state of being',
  'ly': 'in a certain way',
};

/// (sentence with ___, answer, wrong)
const affixSentences = [
  (
    'Be careful! That glass vase is ___.',
    'breakable',
    ['breakless', 'rebreak'],
  ),
  (
    'Please ___ your water bottle before the hike.',
    'refill',
    ['disfill', 'fillness'],
  ),
  ('The puppy is ___; it never bites.', 'harmless', ['harmful', 'misharm']),
  (
    'Thank you for being so ___ when I was sick.',
    'helpful',
    ['helpless', 'prehelp'],
  ),
  (
    'It is ___ to cross the street without looking.',
    'unsafe',
    ['safeful', 'resafe'],
  ),
  ('The ___ painted a mural on the wall.', 'painter', ['repaint', 'paintless']),
  (
    'Please ___ the oven before you bake the cookies.',
    'preheat',
    ['misheat', 'heatful'],
  ),
  (
    'The firefighter was ___ as she ran toward the smoke.',
    'fearless',
    ['fearness', 'refear'],
  ),
  (
    'After the storm, we had to ___ the fence.',
    'rebuild',
    ['unbuild', 'buildness'],
  ),
  (
    'The ___ of the night sky made the stars easy to see.',
    'darkness',
    ['darkful', 'predark'],
  ),
  (
    'I often ___ that word, so I check my spelling.',
    'misspell',
    ['prespell', 'spellful'],
  ),
];

/// (root, meaning, example words)
const wordRoots = [
  ('tele', 'far', 'telephone, telescope'),
  ('graph', 'write or draw', 'autograph, paragraph'),
  ('bio', 'life', 'biology, biography'),
  ('micro', 'small', 'microscope, microwave'),
  ('port', 'carry', 'transport, portable'),
  ('aqua', 'water', 'aquarium, aquatic'),
  ('geo', 'earth', 'geography, geology'),
  ('phon', 'sound', 'telephone, phonics'),
  ('scope', 'see or look at', 'telescope, microscope'),
  ('auto', 'self', 'autograph, automatic'),
  ('rupt', 'break', 'erupt, interrupt'),
  ('dict', 'say', 'predict, dictionary'),
  ('therm', 'heat', 'thermometer, thermal'),
];
