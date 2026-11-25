import 'package:flutter_test/flutter_test.dart';
import 'package:little_learners/generators/topic_sheets.dart';
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
            problems.add(
              '${level.name}/${kind.name} day $d threw $e\n${st.toString().split('\n').take(3).join('\n')}',
            );
            continue;
          }
          final minimum = kind == WorksheetKind.comprehension ? 3 : 3;
          if (ws.questions.length < minimum) {
            problems.add(
              '${level.name}/${kind.name} day $d only ${ws.questions.length} questions',
            );
          }
          for (final q in ws.questions) {
            switch (q) {
              case ChoiceQuestion():
                if (q.choices.length < 2)
                  problems.add(
                    '${level.name}/${kind.name}: <2 choices "${q.prompt}"',
                  );
                if (q.answer < 0 || q.answer >= q.choices.length)
                  problems.add('${level.name}/${kind.name}: bad answer index');
                final labels = q.choices
                    .map((c) => '${c.label}${c.shape}${c.color}${c.scale}')
                    .toSet();
                if (labels.length != q.choices.length) {
                  problems.add(
                    '${level.name}/${kind.name}: duplicate choices "${q.prompt}" ${q.choices.map((c) => c.label)}',
                  );
                }
              case MatchQuestion():
                if (q.left.length != q.right.length ||
                    q.answers.toSet().length != q.left.length) {
                  problems.add('${level.name}/${kind.name}: bad match');
                }
              case TraceQuestion():
                break;
              case ExampleQuestion():
                if (q.steps.isEmpty)
                  problems.add('${level.name}/${kind.name}: empty example');
            }
          }
        }
      }
    }
    expect(problems.toSet().take(40).join('\n'), isEmpty);
  });

  test('daily plan size and questions per sheet, by level', () {
    // Tiles a day (learning sessions + sheets) and questions per sheet.
    const plan = {
      Level.age2: (3, 3),
      Level.age3: (5, 5),
      Level.preK: (5, 5),
      Level.kindergarten: (5, 5),
      Level.grade1: (6, 5),
      Level.grade2: (6, 7),
      Level.grade3: (7, 7),
      Level.grade4: (8, 8),
      Level.grade5: (8, 8),
    };
    for (var d = 0; d < 21; d++) {
      // Mondays to Saturdays (Sundays are the GT test for K–5).
      final date = DateTime(2026, 3, 2).add(Duration(days: d));
      if (date.weekday == DateTime.sunday) continue;
      for (final MapEntry(key: level, value: (tiles, perSheet))
          in plan.entries) {
        final sheets = WorksheetGenerator.forDay(date, level);
        final learn = topicsForDay(date, level);
        expect(
          sheets.length + learn.length,
          tiles,
          reason: '${level.name} $date',
        );
        expect(sheets.map((w) => w.kind).toSet().length, sheets.length);
        for (final ws in sheets) {
          // Toddler tracing has 6; worked examples aren't questions.
          if (level.atMost(Level.age3)) continue;
          // A reading passage has as many questions as were written for it.
          if (ws.kind == WorksheetKind.comprehension) continue;
          expect(
            ws.questions.where((q) => q is! ExampleQuestion).length,
            perSheet,
            reason: '${level.name} ${ws.kind.name}',
          );
        }
        // Math and reading every day from K.
        if (level.atLeast(Level.kindergarten)) {
          final cats = sheets.map((w) => w.kind.category).toSet();
          expect(cats, containsAll([Category.math, Category.reading]));
        }
      }
    }
  });

  test('same day gives same worksheets, next day differs', () {
    String sig(DateTime d) => WorksheetGenerator.forDay(d, Level.grade2)
        .map(
          (w) =>
              '${w.kind.name}:${w.questions.length}:${(w.questions.first as dynamic).toString()}',
        )
        .join();
    expect(sig(DateTime(2026, 3, 1)), sig(DateTime(2026, 3, 1)));
    final a = WorksheetGenerator.forDay(
      DateTime(2026, 3, 1),
      Level.grade2,
    ).map((w) => w.kind).toList();
    final b = WorksheetGenerator.forDay(
      DateTime(2026, 3, 2),
      Level.grade2,
    ).map((w) => w.kind).toList();
    expect(a, isNot(equals(b)));
  });
}
