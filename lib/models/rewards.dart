import '../content/topics.dart';

/// A real-life reward a grown-up sets up, e.g. "Trip to the park" for 30 ⭐.
class RewardGoal {
  const RewardGoal({
    required this.id,
    required this.title,
    required this.emoji,
    required this.cost,
    this.claimed = 0,
  });

  final String id;
  final String title;
  final String emoji;
  final int cost;

  /// How many times it has been given (goals can be earned again).
  final int claimed;

  RewardGoal copyWith({
    String? title,
    String? emoji,
    int? cost,
    int? claimed,
  }) => RewardGoal(
    id: id,
    title: title ?? this.title,
    emoji: emoji ?? this.emoji,
    cost: cost ?? this.cost,
    claimed: claimed ?? this.claimed,
  );

  Map<String, Object> toJson() => {
    'id': id,
    'title': title,
    'emoji': emoji,
    'cost': cost,
    'claimed': claimed,
  };

  factory RewardGoal.fromJson(Map<String, dynamic> j) => RewardGoal(
    id: j['id'] as String,
    title: j['title'] as String,
    emoji: j['emoji'] as String? ?? '🎁',
    cost: (j['cost'] as num).toInt(),
    claimed: (j['claimed'] as num?)?.toInt() ?? 0,
  );
}

/// One child's rewards. Stored on the device and in `children.rewards`.
class Rewards {
  const Rewards({
    this.enabled = false,
    this.spent = 0,
    this.stickers = const [],
    this.goals = const [],
  });

  /// Off until a grown-up switches rewards on for this child.
  final bool enabled;

  /// Stars spent on stickers and goals (earned stars are never reduced).
  final int spent;

  /// Collected sticker ids (see [Sticker.id]), in the order they were bought.
  final List<String> stickers;
  final List<RewardGoal> goals;

  Rewards copyWith({
    bool? enabled,
    int? spent,
    List<String>? stickers,
    List<RewardGoal>? goals,
  }) => Rewards(
    enabled: enabled ?? this.enabled,
    spent: spent ?? this.spent,
    stickers: stickers ?? this.stickers,
    goals: goals ?? this.goals,
  );

  Map<String, Object> toJson() => {
    'enabled': enabled,
    'spent': spent,
    'stickers': stickers,
    'goals': [for (final g in goals) g.toJson()],
  };

  factory Rewards.fromJson(Map<String, dynamic> j) => Rewards(
    enabled: j['enabled'] as bool? ?? false,
    spent: (j['spent'] as num?)?.toInt() ?? 0,
    stickers: [for (final s in j['stickers'] as List? ?? const []) s as String],
    goals: [
      for (final g in j['goals'] as List? ?? const [])
        RewardGoal.fromJson(Map<String, dynamic>.from(g as Map)),
    ],
  );
}

/// A collectible sticker: one picture from a learning topic.
class Sticker {
  const Sticker(this.topic, this.item);
  final Topic topic;
  final TopicItem item;

  String get id => '${topic.id}:${item.name}';

  /// Stars needed. Flat and predictable — kids choose what to get.
  static const cost = 5;

  /// Album pages: one per learning topic.
  static List<(Topic, List<Sticker>)> get album => [
    for (final t in topics)
      if (!t.toddlerOnly) (t, [for (final i in t.items) Sticker(t, i)]),
  ];

  static int get total => album.fold(0, (a, p) => a + p.$2.length);
}

/// Ideas offered when a grown-up adds a goal.
const goalIdeas = [
  ('🌳', 'Trip to the park'),
  ('📖', 'Extra bedtime story'),
  ('🍦', 'Ice cream treat'),
  ('🎨', 'Art and craft time'),
  ('🎮', 'Extra play time'),
  ('🎬', 'Family movie night'),
  ('🍕', 'Pick dinner'),
  ('🧸', 'A small toy'),
];
