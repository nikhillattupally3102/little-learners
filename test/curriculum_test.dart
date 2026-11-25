import 'package:flutter_test/flutter_test.dart';
import 'package:little_learners/content/daily_focus.dart';
import 'package:little_learners/models/generator.dart';
import 'package:little_learners/models/models.dart';

void main() {
  DateTime day(int d) => DateTime(2026, 11, 1).add(Duration(days: d));

  test('Pre-K: sight words, three-letter words, tracing and +/− every day', () {
    for (var d = 0; d < 30; d++) {
      final kinds = WorksheetGenerator.kindsForDay(day(d), Level.preK);
      expect(
        kinds,
        containsAll([
          WorksheetKind.sightWords,
          WorksheetKind.soundOut,
          WorksheetKind.tracing,
        ]),
      );
      expect(
        kinds.contains(WorksheetKind.addition) ||
            kinds.contains(WorksheetKind.subtraction),
        isTrue,
      );
      expect(kinds.toSet().length, kinds.length);
    }
  });

  test(
    'Pre-K reading and tracing use only today\'s (and yesterday\'s) words',
    () {
      for (var d = 0; d < 30; d++) {
        final w = PreKWords.of(day(d));
        final cvc = [
          ...w.cvc,
          ...w.reviewCvc,
        ].map((x) => x.$2.replaceAll('-', '')).toSet();
        final pics = [...w.cvc, ...w.reviewCvc].map((x) => x.$1).toSet();
        final sight = {...w.sight, ...w.reviewSight};
        final tracing = WorksheetGenerator.build(
          day(d),
          Level.preK,
          WorksheetKind.tracing,
        );
        final traced = tracing.questions
            .whereType<TraceQuestion>()
            .map((q) => q.glyph)
            .toSet();
        expect(traced, {
          ...w.sight,
          ...w.cvc.map((x) => x.$2.replaceAll('-', '')),
        });

        final sightSheet = WorksheetGenerator.build(
          day(d),
          Level.preK,
          WorksheetKind.sightWords,
        );
        for (final q in sightSheet.questions.cast<ChoiceQuestion>()) {
          expect(sight, contains(q.choices[q.answer].label));
        }
        final cvcSheet = WorksheetGenerator.build(
          day(d),
          Level.preK,
          WorksheetKind.soundOut,
        );
        for (final q in cvcSheet.questions.cast<ChoiceQuestion>()) {
          final a = q.choices[q.answer].label!;
          final v = q.visual;
          final about = v is WordPictureVisual ? v.word.toLowerCase() : a;
          expect(
            cvc.contains(about) || pics.contains(about),
            isTrue,
            reason: '${q.prompt} → $a',
          );
        }
      }
    },
  );

  test('Pre-K maths stays within 5', () {
    for (var d = 0; d < 30; d++) {
      for (final kind in [WorksheetKind.addition, WorksheetKind.subtraction]) {
        final ws = WorksheetGenerator.build(day(d), Level.preK, kind);
        for (final q in ws.questions.cast<ChoiceQuestion>()) {
          final v = q.visual;
          if (v is EquationVisual) {
            expect(v.a, lessThanOrEqualTo(5));
            expect(
              kind == WorksheetKind.addition ? v.a + v.b : v.a,
              lessThanOrEqualTo(5),
            );
          }
        }
      }
    }
  });

  test('multiplication and division open with a correct worked example', () {
    for (var d = 0; d < 20; d++) {
      for (final level in Level.values) {
        for (final kind in [
          WorksheetKind.multiplication,
          WorksheetKind.division,
        ]) {
          if (!kind.suits(level)) continue;
          final ws = WorksheetGenerator.build(day(d), level, kind);
          final ex = ws.questions.first;
          expect(
            ex,
            isA<ExampleQuestion>(),
            reason: '${level.name} ${kind.name}',
          );
          expect(ws.questions.skip(1).whereType<ExampleQuestion>(), isEmpty);
          // The final step states the result; check its arithmetic.
          final last = (ex as ExampleQuestion).steps.last;
          final m = RegExp(r'So ([\d,]+) ([×÷]) (\d+) = ([\d,]+)')
              .firstMatch(last)!;
          int n(int i) => int.parse(m.group(i)!.replaceAll(',', ''));
          expect(
            m.group(2) == '×' ? n(1) * n(3) : n(1) ~/ n(3),
            n(4),
            reason: last,
          );
          if (m.group(2) == '÷') expect(n(1) % n(3), 0);
        }
      }
    }
  });
}
