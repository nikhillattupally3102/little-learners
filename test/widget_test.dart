import 'package:flutter_test/flutter_test.dart';
import 'package:little_learners/models/generator.dart';
import 'package:little_learners/models/models.dart';

void main() {
  test('every worksheet kind builds valid questions at every level for 120 days', () {
    final problems = <String>[];
    for (var d = 0; d < 120; d++) {
      final date = DateTime(2026, 1, 1).add(Duration(days: d));
      for (final level in Level.values) {
        for (final kind in level.kinds) {
          final Worksheet ws;
          try {
            ws = WorksheetGenerator.build(date, level, kind);
          } catch (e, st) {
            problems.add('${level.name}/${kind.name} day $d threw $e\n${st.toString().split('\n').take(3).join('\n')}');
            continue;
          }
          final minimum = kind == WorksheetKind.comprehension ? 3 : 3;
          if (ws.questions.length < minimum) {
            problems.add('${level.name}/${kind.name} day $d only ${ws.questions.length} questions');
          }
          for (final q in ws.questions) {
            switch (q) {
              case ChoiceQuestion():
                if (q.choices.length < 2) problems.add('${level.name}/${kind.name}: <2 choices "${q.prompt}"');
                if (q.answer < 0 || q.answer >= q.choices.length) problems.add('${level.name}/${kind.name}: bad answer index');
                final labels = q.choices.map((c) => '${c.label}${c.shape}${c.color}${c.scale}').toSet();
                if (labels.length != q.choices.length) {
                  problems.add('${level.name}/${kind.name}: duplicate choices "${q.prompt}" ${q.choices.map((c) => c.label)}');
                }
              case MatchQuestion():
                if (q.left.length != q.right.length || q.answers.toSet().length != q.left.length) {
                  problems.add('${level.name}/${kind.name}: bad match');
                }
              case TraceQuestion():
                break;
              case ExampleQuestion():
                if (q.steps.isEmpty) problems.add('${level.name}/${kind.name}: empty example');
            }
          }
        }
      }
    }
    expect(problems.toSet().take(40).join('\n'), isEmpty);
  });

  test('daily set has every category and no repeats', () {
    for (final level in Level.values) {
      final sheets = WorksheetGenerator.forDay(DateTime(2026, 3, 1), level);
      expect(sheets.map((w) => w.kind).toSet().length, sheets.length);
      if (level.atMost(Level.age3)) continue; // toddlers: a few picture activities
      // Thinking Skills starts in Kindergarten.
      final expected = Category.values.length - (level == Level.preK ? 1 : 0);
      expect(sheets.map((w) => w.kind.category).toSet().length, expected,
          reason: '${level.name} is missing a category');
    }
  });

  test('same day gives same worksheets, next day differs', () {
    String sig(DateTime d) => WorksheetGenerator.forDay(d, Level.grade2)
        .map((w) => '${w.kind.name}:${w.questions.length}:${(w.questions.first as dynamic).toString()}')
        .join();
    expect(sig(DateTime(2026, 3, 1)), sig(DateTime(2026, 3, 1)));
    final a = WorksheetGenerator.forDay(DateTime(2026, 3, 1), Level.grade2).map((w) => w.kind).toList();
    final b = WorksheetGenerator.forDay(DateTime(2026, 3, 2), Level.grade2).map((w) => w.kind).toList();
    expect(a, isNot(equals(b)));
  });
}
