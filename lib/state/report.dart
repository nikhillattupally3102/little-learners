import '../models/models.dart';
import '../models/result.dart';

/// Numbers for the grown-ups' progress report, computed from a child's results.
class ChildReport {
  ChildReport(this.results, {DateTime? now}) : now = now ?? DateTime.now();

  /// Newest first.
  final List<WorksheetResult> results;
  final DateTime now;

  int get worksheets => results.length;

  int get minutes =>
      (results.fold<int>(0, (a, r) => a + r.seconds) / 60).round();

  int get thisWeek =>
      results.where((r) => now.difference(r.completedAt).inDays < 7).length;

  double? get averageStars => results.isEmpty
      ? null
      : results.fold<int>(0, (a, r) => a + r.stars) / results.length;

  /// Worksheets finished on each of the last [days] days, oldest first.
  List<int> activity({int days = 14}) {
    final today = DateTime(now.year, now.month, now.day);
    final counts = List.filled(days, 0);
    for (final r in results) {
      final d = DateTime(
        r.completedAt.year,
        r.completedAt.month,
        r.completedAt.day,
      );
      final ago = today.difference(d).inDays;
      if (ago >= 0 && ago < days) counts[days - 1 - ago]++;
    }
    return counts;
  }

  /// Per subject: how many, average stars and share of answers right first time.
  List<SubjectStats> subjects() => [
    for (final c in Category.values)
      SubjectStats(c, [
        for (final r in results)
          if (r.category == c.name) r,
      ]),
  ];

  /// Learning-session quizzes.
  List<WorksheetResult> get quizzes => [
    for (final r in results)
      if (r.kind == WorksheetKind.topicQuiz.name) r,
  ];

  /// Worksheet kinds sorted from weakest to strongest (at least [minTries]).
  List<KindStats> kinds({int minTries = 2}) {
    final by = <String, List<WorksheetResult>>{};
    for (final r in results) {
      if (r.kind == WorksheetKind.topicQuiz.name || r.kind == 'learn') continue;
      by.putIfAbsent(r.kind, () => []).add(r);
    }
    final out = [
      for (final e in by.entries)
        if (e.value.length >= minTries) KindStats(e.key, e.value),
    ]..sort((a, b) => a.averageStars.compareTo(b.averageStars));
    return out;
  }

  /// Kinds that need more practice: average under 2 stars.
  List<KindStats> get needsPractice =>
      kinds().where((k) => k.averageStars < 2).take(3).toList();

  /// Kinds the child is great at: average 2.7 stars or more.
  List<KindStats> get strengths =>
      kinds().reversed.where((k) => k.averageStars >= 2.7).take(3).toList();
}

class SubjectStats {
  SubjectStats(this.category, this.results);
  final Category category;
  final List<WorksheetResult> results;

  int get count => results.length;

  double? get averageStars => results.isEmpty
      ? null
      : results.fold<int>(0, (a, r) => a + r.stars) / results.length;

  /// Share of questions answered without a mistake (null without data).
  double? get accuracy {
    final qs = results.fold<int>(0, (a, r) => a + r.questions);
    if (qs == 0) return null;
    final wrong = results.fold<int>(0, (a, r) => a + r.mistakes);
    return ((qs - wrong) / qs).clamp(0.0, 1.0);
  }
}

class KindStats {
  KindStats(this.kindName, this.results);
  final String kindName;
  final List<WorksheetResult> results;

  WorksheetKind? get kind => WorksheetKind.values.asNameMap()[kindName];

  double get averageStars =>
      results.fold<int>(0, (a, r) => a + r.stars) / results.length;
}
