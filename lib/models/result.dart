import 'dart:math';

/// One finished worksheet. Stored on the device and, when a grown-up is
/// signed in, in the cloud (`results` table — same field names).
class WorksheetResult {
  const WorksheetResult({
    required this.id,
    required this.childId,
    required this.worksheetId,
    required this.kind,
    required this.category,
    required this.level,
    required this.stars,
    required this.questions,
    required this.mistakes,
    required this.seconds,
    required this.completedAt,
  });

  final String id;
  final String childId;

  /// e.g. `20261120_addition`, or `20261120_topic_farm` for a learning quiz.
  final String worksheetId;

  /// Worksheet kind name (e.g. `addition`, `topicQuiz`).
  final String kind;

  /// Category name, or null for a learning-session quiz.
  final String? category;

  /// Level name the worksheet was played at (after adaptive changes).
  final String level;
  final int stars;
  final int questions;
  final int mistakes;
  final int seconds;
  final DateTime completedAt;

  static final _rand = Random();

  /// A unique id, so uploading the same result twice never duplicates it.
  static String newId() =>
      'r${DateTime.now().microsecondsSinceEpoch.toRadixString(36)}'
      '${_rand.nextInt(1000000000).toRadixString(36)}';

  Map<String, Object?> toJson() => {
    'id': id,
    'child_id': childId,
    'worksheet_id': worksheetId,
    'kind': kind,
    'category': category,
    'level': level,
    'stars': stars,
    'questions': questions,
    'mistakes': mistakes,
    'seconds': seconds,
    'completed_at': completedAt.toUtc().toIso8601String(),
  };

  factory WorksheetResult.fromJson(Map<String, dynamic> j) => WorksheetResult(
    id: j['id'] as String,
    childId: j['child_id'] as String,
    worksheetId: j['worksheet_id'] as String,
    kind: j['kind'] as String,
    category: j['category'] as String?,
    level: j['level'] as String,
    stars: (j['stars'] as num).toInt(),
    questions: (j['questions'] as num?)?.toInt() ?? 0,
    mistakes: (j['mistakes'] as num?)?.toInt() ?? 0,
    seconds: (j['seconds'] as num?)?.toInt() ?? 0,
    completedAt: DateTime.parse(j['completed_at'] as String).toLocal(),
  );
}
