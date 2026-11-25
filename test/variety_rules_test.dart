import 'package:flutter_test/flutter_test.dart';
import 'package:little_learners/generators/gen.dart';
import 'package:little_learners/models/generator.dart';
import 'package:little_learners/models/models.dart';

/// Rules that keep worksheets from feeling repetitive.
void main() {
  final start = DateTime(2026, 11, 1);

  test('a worksheet never has more than one matching round', () {
    for (final level in Level.values) {
      for (var d = 0; d < 30; d++) {
        final date = start.add(Duration(days: d));
        for (final ws in [
          ...WorksheetGenerator.forDay(date, level),
          ...WorksheetGenerator.bonusForDay(date, level),
        ]) {
          expect(
            ws.questions.whereType<MatchQuestion>().length,
            lessThanOrEqualTo(1),
            reason: '${level.name} ${ws.kind.name} day $d',
          );
        }
      }
    }
  });

  test('bonus worksheets are not on today\'s plan', () {
    for (final level in Level.values) {
      final date = start;
      final today = WorksheetGenerator.kindsForDay(date, level).toSet();
      for (final ws in WorksheetGenerator.bonusForDay(date, level)) {
        expect(today.contains(ws.kind), isFalse);
      }
    }
  });

  test('remembering seen questions keeps 3-week repeats low', () {
    for (final level in [Level.kindergarten, Level.grade3]) {
      final seenDay = <String, int>{};
      var shown = 0, repeats = 0;
      for (var d = 0; d < 42; d++) {
        final avoid = {
          for (final e in seenDay.entries)
            if (e.value >= d - 21) e.key,
        };
        final sheets = WorksheetGenerator.forDay(
          start.add(Duration(days: d)),
          level,
          avoid: avoid,
        );
        for (final ws in sheets) {
          for (final q in ws.questions) {
            shown++;
            final last = seenDay[Gen.fingerprint(q)];
            if (last != null && last >= d - 21) repeats++;
          }
          for (final f in Gen.fingerprints(ws.questions)) {
            seenDay[f] = d;
          }
        }
      }
      // Older grades have longer worksheets and (for now) less reading
      // content, so they repeat a little more. Tighten as content grows.
      expect(
        repeats / shown,
        lessThan(level == Level.kindergarten ? .08 : .15),
        reason: level.name,
      );
    }
  });
}
