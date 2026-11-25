import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:little_learners/models/models.dart';
import 'package:little_learners/models/result.dart';
import 'package:little_learners/state/progress.dart';
import 'package:little_learners/state/report.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _mia = Profile(
  id: 'mia',
  name: 'Mia',
  avatar: '🦊',
  colorIndex: 0,
  level: Level.kindergarten,
);

WorksheetResult _r(String kind, int stars, DateTime at, {String? cat}) =>
    WorksheetResult(
      id: '$kind$at',
      childId: 'mia',
      worksheetId: '${at.year}_$kind',
      kind: kind,
      category: cat,
      level: 'kindergarten',
      stars: stars,
      questions: 5,
      mistakes: 3 - stars,
      seconds: 90,
      completedAt: at,
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('a finished worksheet is stored with its details', () async {
    SharedPreferences.setMockInitialValues({});
    final progress = await Progress.load();
    await progress.saveProfile(_mia, makeActive: true);
    await progress.complete(
      '20261120_addition',
      2,
      category: Category.math,
      kind: 'addition',
      level: Level.grade1,
      questions: 5,
      mistakes: 2,
      seconds: 75,
    );
    final r = progress.resultsOf(_mia).single;
    expect(r.kind, 'addition');
    expect(r.level, 'grade1');
    expect(r.mistakes, 2);
    expect(r.seconds, 75);
    expect(progress.starsFor('20261120_addition'), 2);

    // Survives a restart, and round-trips through JSON (the cloud format).
    final again = await Progress.load();
    again.select(again.profiles.single);
    expect(again.resultsOf(_mia).single.id, r.id);
    expect(WorksheetResult.fromJson(r.toJson()).completedAt, r.completedAt);
  });

  test('stars from the old format become results', () async {
    SharedPreferences.setMockInitialValues({
      'profiles': jsonEncode([_mia.toJson()]),
      'mia_ws_20261118_addition': 3,
      'mia_ws_20261119_topic_farm': 2,
      'mia_stars': 5,
    });
    final progress = await Progress.load();
    final results = progress.resultsOf(_mia);
    expect(results.length, 2);
    expect(progress.starsOf(_mia), 5);
    expect(results.map((r) => r.kind), containsAll(['addition', 'topicQuiz']));
    expect(results.firstWhere((r) => r.kind == 'addition').category, 'math');
  });

  test('streak counts consecutive days with results', () async {
    final now = DateTime(2026, 11, 20, 18);
    SharedPreferences.setMockInitialValues({
      'profiles': jsonEncode([_mia.toJson()]),
      'mia_results': jsonEncode([
        for (final d in [0, 1, 2, 4])
          _r('addition', 3, now.subtract(Duration(days: d))).toJson(),
      ]),
    });
    final progress = await Progress.load();
    expect(progress.streakOf(_mia, now: now), 3);
    // Not played yet today: yesterday's streak still counts.
    expect(progress.streakOf(_mia, now: now.add(const Duration(days: 1))), 3);
    expect(progress.streakOf(_mia, now: now.add(const Duration(days: 2))), 0);
  });

  test('report finds weak spots, strengths and activity', () {
    final now = DateTime(2026, 11, 20, 18);
    DateTime ago(int d) => now.subtract(Duration(days: d));
    final report = ChildReport([
      _r('addition', 1, ago(0), cat: 'math'),
      _r('addition', 1, ago(1), cat: 'math'),
      _r('rhymes', 3, ago(1), cat: 'reading'),
      _r('rhymes', 3, ago(2), cat: 'reading'),
      _r('shapes', 3, ago(9), cat: 'math'),
    ], now: now);
    expect(report.worksheets, 5);
    expect(report.thisWeek, 4);
    expect(report.needsPractice.single.kindName, 'addition');
    expect(report.strengths.single.kindName, 'rhymes');
    final activity = report.activity();
    expect(activity.last, 1);
    expect(activity[12], 2);
    final math = report.subjects().firstWhere(
      (s) => s.category == Category.math,
    );
    expect(math.count, 3);
    expect(math.accuracy, closeTo((15 - 4) / 15, 1e-9));
  });
}
