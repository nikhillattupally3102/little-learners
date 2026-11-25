# Little Learners 🦉

A bright, playful daily-learning app for children from age 2 to Grade 5, built
with Flutter and used mainly as a web app on **iPads and touchscreen laptops**.

Live at **https://little-learners.little-learners.workers.dev**

## Levels
Age 2 · Age 3 · Pre-K · Kindergarten · Grade 1 · Grade 2 · Grade 3 · Grade 4 · Grade 5

Each child has a profile with their own level, stars, streak, progress and
"recently seen" question memory. Difficulty adapts within a level.

## Today's Plan (home screen)
One blended daily plan per child. The youngest levels follow a fixed daily
curriculum ("today's focus", `lib/content/daily_focus.dart`), shared by the
learning cards and the worksheets so each thing is met several ways:

- **Age 2** (4 tiles): Letters (2 a day, A–Z in order), Numbers (2 a day,
  1–5) and today's theme — 6 animals, colors, shapes, fruits & veggies or
  vehicles. Each tile is picture cards, then 3 quick picture games on the
  same things, each shown a different way (heard, same picture, shadow,
  sound, big/small…). Plus "Remember?": yesterday's letter, number and item.
  The theme changes every day; when it comes back it brings the next 6.
- **Age 3** (5 tiles): the same with 3 letters and 3 numbers (1–10) a day
  and 5 games per tile, plus Trace (today's letters and numbers).
- **Pre-K**: 2 sight words (Dolch pre-primer) and 2 three-letter words a
  day, plus yesterday's for review. Sight Words, Sound It Out and Trace &
  Write use only these. Add or Take Away (within 5) every day.
- **K–Grade 5**: 1 learning session, then 2 Math, 2 Reading, 1 Science,
  1 Puzzle, 1 Writing, 1 Geography and 1 Thinking Skills, rotating daily.
  Same day = same sheets on every device.
- **Learn more** (below the plan): picture-card sessions to open any time,
  chosen by age (`lib/generators/learn_more.dart`). Age 2–3: letters,
  numbers, shapes, colors, animals (+ fruits for Age 3); Pre-K adds sight
  words and three-letter words (sounds read aloud), body and a few
  countries; K+ drops the toddler basics and adds more topics each grade.
- A bonus sheet (not for Age 2) and the rewards pill (if grown-ups enabled rewards).

## Worksheets
**85 worksheet kinds** across 7 subjects. Each has a level range and gets
harder with the level.

Per level: Age 2: 3 · Age 3: 16 · Pre-K: 25 · K: 29 · G1: 41 ·
G2: 38 · G3: 37 · G4: 31 · G5: 25.

Questions per sheet: Age 2–3: 3 · Pre-K: 5 · K: 6 · G1–2: 7 · G3–5: 8.

| Subject | Examples |
|---|---|
| Math | counting, shapes, add/subtract, compare, place value, clocks, coins, times tables, division, fractions, word problems, area & perimeter, rounding, decimals |
| Reading | letter sounds, ABC order, rhymes, sight words (Dolch), syllables, comprehension passages (K–5), synonyms/antonyms, homophones, prefixes & suffixes |
| Science | my body, weather, animal homes, plants, life cycles, matter, space, human body, Earth, forces & energy, ecosystems |
| Puzzles | odd one out, shadow match, patterns, mini sudoku, number riddles, missing number |
| Writing | tracing, spelling, fix the sentence |
| Geography | land & water (Pre-K–G2), continents & oceans (K–G5), map skills (G1–5), flags (G1–4), capital cities (G3–5) |
| Thinking Skills (K–5) | CogAT-style reasoning, one battery per sheet. **Word Thinking**: analogies, sentence completion, classification. **Number Thinking**: number analogies, number puzzles, number series. **Shape Thinking**: figure matrices (2×2; 3×3 from G4), figure classification, paper folding (folded twice from G4). K–2 are pictures read aloud (3 choices in K); G3+ use words and harder rules |

Question types: multiple choice, matching (**tap or drag**), reading passages,
finger tracing. Grade 1+ math has a **scratch pad** for rough work.
Timing, mistakes and stars are recorded for every sheet.

**Toddlers (Age 2–3)**: picture-only, nothing to read, auto-spoken prompts
(`lib/generators/toddler_sheets.dart`, the `t*` kinds). Letters and numbers
appear only in their own sheets.

**Worked examples**: Times Tables and Division open with a "💡 Let's learn!"
card (`ExampleQuestion`, read aloud step by step, not scored) that grows
with the grade: equal groups (G2) → skip counting (G3) → tens and ones (G4)
→ splitting a 2-digit number (G5); sharing (G3) → splitting (G4–5).

### Variety rules (`lib/generators/gen.dart`)
Seeded per day/level/kind. At most one matching round per sheet, no repeated
words, no back-to-back same prompts, and a 21-day "seen" memory of question
fingerprints (FNV-1a, web-safe) so the same questions don't come back.
Rules relax step by step only when a bank runs out.

## Learning topics (`lib/content/topics.dart`)
16 rotating topics: farm, wild, ocean, colors, space, countries, body, fruits,
veggies, vehicles, bugs, birds, sports, helpers, continents & oceans, land & water
(+ toddler-only abc1, abc2, numbers).

**Depth by grade** (`lib/content/topic_depth.dart`):
- Pre-K/K: simple fact per card; quiz = picture matching, "Find the…", "Who am I?".
- Grade 2+: each card also shows a **"Did you know?"** fact (also spoken).
- Grade 1+: quizzes add graded questions per topic (`topicQuestions`, each with a
  level range), e.g. veggies: plant parts → tubers/bulbs → capsaicin.
- Grade 3+: no picture games; quiz is mostly reasoning, fill-in-the-blank and
  clues from the deeper facts.

Clues must never contain the item's name (a test enforces it).

## Pictures and photos
- **Drawings**: 453 hand-made SVGs, keyed by emoji code points or `pic:name`.
  Sources are `tool/pics/batch_*.py`; run `python3 tool/make_pics.py` to regenerate
  `assets/pics/` and `lib/widgets/pic_index.dart`. `PicLabel` renders drawings inside text.
- **Globes**: `tool/make_globes.py` draws continent/ocean globes from Natural Earth
  data (public domain) → `tool/pics/batch_10_globes.py`.
- **Real photos**: 163 Wikimedia Commons photos on learning cards
  (`assets/photos/<topic>__<slug>.jpg`, licences PD/CC0/CC BY/CC BY-SA only).
  `tool/fetch_photos.py` fetches; `tool/make_photo_credits.py` writes
  `lib/content/photo_credits.dart` and `web/credits.html`. Credits show in the
  app (Grown-ups → Photo credits) and at `/credits`. Missing photos just don't show.

## Rewards (off by default)
Grown-ups enable them in Grown-ups → Rewards. Stars buy stickers for a sticker
book (5 stars each) and count towards parent-set goals.

## Feedback
Grown-ups can send feedback; kids tap a reaction after each sheet. Stored in
Supabase `feedback`. Admin inbox in-app for addresses in `feedback_admins`.
Read from the terminal with `./tool/feedback.sh` (token-gated `read_feedback` RPC).
A periodic feedback-review agent is planned but **not set up yet**.

## Adding content
- Science fact banks: `lib/content/science.dart` (each `Fact` has a level range)
- Geography facts and capitals: `lib/content/geography.dart`
- Topic cards: `lib/content/topics.dart`; older-grade depth: `lib/content/topic_depth.dart`
- Passages, word lists, sentences: `lib/content/reading.dart`
- Thinking Skills words and pictures: `lib/content/thinking.dart`; figures and
  paper folding: `lib/content/figures.dart` (figures are spec strings like
  `fig:triangle.1.2.o.1.b`, drawn by `Pic`)
- Generators: `lib/generators/`; worksheet kinds and levels: `lib/models/models.dart`
- Daily rotation: `lib/models/generator.dart`

All passages and questions are written for this app.

## References used to plan the curriculum
- K5 Learning: https://www.k5learning.com/free-math-worksheets/first-grade-1, https://www.k5learning.com/science-worksheets
- Kindergarten Worksheets: https://www.kindergartenworksheets.net/
- Super Teacher Worksheets: https://www.superteacherworksheets.com/comprehension.html,
  5th grade: https://www.superteacherworksheets.com/fifth-grade-worksheets-5th.html
- Dolch sight word lists (public domain); Natural Earth (public domain); Wikimedia Commons
- CogAT question types (K–5), as outlined at
  https://www.testingmom.com/tests/cogat-test/cogat-practice-tests-for-all-grade-levels/
  — structure only; every Thinking Skills question is original

## Run and test
```bash
flutter pub get
flutter run -d chrome --dart-define-from-file=supabase.env.json
flutter test                      # 53 tests; test/live/ needs the backend
```

## Backend (Supabase)

The app works fully offline. With a grown-up signed in, children's profiles,
worksheet results, adaptive difficulty, rewards and the "recently seen" memory
sync to Supabase (offline-first: children merge by `updated_at`, results merge by id).

**Setup**: run [`supabase/schema.sql`](supabase/schema.sql), then each file in
`supabase/migrations/` in order (002 delete account, 003 feedback, 004 feedback
reader, 005 rewards, 006 keep-alive), all in the `public` schema with RLS.
Put the Project URL and publishable key in `supabase.env.json` (copy
`supabase.env.example.json`; it's gitignored). Never ship the `service_role` key.

**Before real users**: turn **Confirm email** back on (Authentication → Email)
and delete leftover test accounts.

**What is stored**: grown-up email (Supabase Auth); each child's first name /
nickname, avatar, colour, grade, adaptive settings and rewards; one row per
finished worksheet (kind, level, stars, questions, mistakes, seconds, time);
fingerprints of recently seen questions; feedback. No child email, photos or
location. Grown-ups can delete the account and all data in the app.

## Hosting (Cloudflare)

```sh
./tool/build_web.sh          # build only
./tool/build_web.sh deploy   # build with Supabase settings and publish
```

Config: `wrangler.jsonc` (static assets from `build/web`). Privacy policy at
`/privacy` (operator: Nikhil Lattupalli). First time on a new machine:
`npx wrangler login`. On iPad: Safari → Share → **Add to Home Screen**.

## Keeping the free Supabase project awake

Free projects pause after ~7 days idle. The Cloudflare worker
`little-learners-keepalive` (`tool/keepalive/`) calls `keep_alive()` daily at
06:17 UTC; no computer needs to be on. Redeploy: `cd tool/keepalive && npx wrangler deploy`.

## Where we left off / ideas
- **Grade 5 gaps** (vs Super Teacher Worksheets): order of operations, coordinate
  grids, unlike-denominator fractions; Greek/Latin roots, homographs, active/passive
  voice, commas & appositives; weather/climate/clouds/storms, rocks & minerals,
  layers of the Earth, cells; US government & history (if US audience).
- Feedback said "worksheets need more focus" — idea: one skill per worksheet (not decided).
- More Grade 3–5 reading and more Age 3 content.
- App Store / Android packaging (not started).
