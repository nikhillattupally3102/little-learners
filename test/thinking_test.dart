import 'package:flutter/widgets.dart' show StringCharacters;
import 'package:flutter_test/flutter_test.dart';
import 'package:little_learners/content/daily_focus.dart' show isDrawn;
import 'package:little_learners/content/figures.dart';
import 'package:little_learners/models/generator.dart';
import 'package:little_learners/models/models.dart';

void main() {
  const kinds = [
    WorksheetKind.wordThinking,
    WorksheetKind.numberThinking,
    WorksheetKind.shapeThinking,
  ];
  final start = DateTime(2026, 11, 1);
  final grades = Level.values.where((l) => l.atLeast(Level.kindergarten));

  test('K–5 get one Thinking Skills sheet a day; younger children none', () {
    for (var d = 0; d < 30; d++) {
      final date = start.add(Duration(days: d));
      for (final level in Level.values) {
        final n = WorksheetGenerator.forDay(
          date,
          level,
        ).where((w) => w.kind.category == Category.thinking).length;
        expect(
          n,
          level.atLeast(Level.kindergarten) ? 1 : 0,
          reason: level.name,
        );
      }
    }
  });

  test('every puzzle is well formed, at every grade, for 90 days', () {
    for (var d = 0; d < 90; d++) {
      final date = start.add(Duration(days: d));
      for (final level in grades) {
        for (final kind in kinds) {
          final ws = WorksheetGenerator.build(date, level, kind);
          expect(
            ws.questions.length,
            greaterThanOrEqualTo(5),
            reason: '${level.name} ${kind.name}',
          );
          for (final q in ws.questions.cast<ChoiceQuestion>()) {
            final labels = q.choices.map((c) => c.label!).toList();
            expect(
              labels.toSet().length,
              labels.length,
              reason: '${q.prompt} $labels',
            );
            expect(
              labels.length,
              level == Level.kindergarten ? 3 : 4,
              reason: '${level.name} ${q.prompt} $labels',
            );
            // K–2: no reading needed in the answers (pictures and numbers).
            if (level.atMost(Level.grade2) &&
                kind != WorksheetKind.numberThinking) {
              for (final l in labels) {
                expect(
                  RegExp(
                    r'[a-z]{2,}',
                  ).hasMatch(l.replaceFirst(RegExp(r'^(fig|paper):\S*'), '')),
                  isFalse,
                  reason: '${kind.name}: $l',
                );
              }
            }
          }
        }
      }
    }
  });

  test('paper folding answers are the unfolded holes', () {
    for (var d = 0; d < 60; d++) {
      for (final level in grades) {
        final ws = WorksheetGenerator.build(
          start.add(Duration(days: d)),
          level,
          WorksheetKind.shapeThinking,
        );
        for (final q in ws.questions.cast<ChoiceQuestion>()) {
          if (q.visual case FoldVisual(:final fold, :final holes)) {
            expect(q.choices[q.answer].label, paperSpec(unfold(fold, holes)));
            // Holes are punched in the folded part of the paper.
            for (final (r, c) in holes) {
              if (fold.contains('v')) expect(c, greaterThanOrEqualTo(2));
              if (fold.contains('h')) expect(r, greaterThanOrEqualTo(2));
            }
            if (level.atMost(Level.grade1)) expect(fold.length, 1);
          }
        }
      }
    }
  });

  test('figure matrices: the answer makes the same change as the example', () {
    for (var d = 0; d < 60; d++) {
      for (final level in grades) {
        final ws = WorksheetGenerator.build(
          start.add(Duration(days: d)),
          level,
          WorksheetKind.shapeThinking,
        );
        for (final q in ws.questions.cast<ChoiceQuestion>()) {
          final v = q.visual;
          if (v is! MatrixVisual || v.cells.length != 4) continue;
          final [a, b, c] = [for (final s in v.cells.take(3)) Fig.parse(s)!];
          final ans = Fig.parse(q.choices[q.answer].label!)!;
          // Whatever changed from a to b changed the same way from c to the answer.
          expect(a.color == b.color, c.color == ans.color);
          expect(a.count == b.count, c.count == ans.count);
          expect(a.outline == b.outline, c.outline == ans.outline);
          expect(a.small == b.small, c.small == ans.small);
          expect(a.turn == b.turn, c.turn == ans.turn);
          if (a.color != b.color) expect(ans.color, b.color);
          if (a.count != b.count) expect(ans.count, b.count);
          // Only one choice is right.
          final specs = q.choices.map((x) => x.label).toList();
          expect(specs.where((s) => s == ans.spec).length, 1);
        }
      }
    }
  });

  test(
    'figure groups: only the answer shares what the three have in common',
    () {
      for (var d = 0; d < 60; d++) {
        for (final level in grades) {
          final ws = WorksheetGenerator.build(
            start.add(Duration(days: d)),
            level,
            WorksheetKind.shapeThinking,
          );
          for (final q in ws.questions.cast<ChoiceQuestion>()) {
            final v = q.visual;
            if (v is! MatrixVisual || v.cells.length != 3) continue;
            final shown = [for (final s in v.cells) Fig.parse(s)!];
            Map<String, Object> shared(List<Fig> fs) => {
              if (fs.every((f) => f.shape == fs[0].shape)) 'shape': fs[0].shape,
              if (fs.every((f) => f.color == fs[0].color)) 'color': fs[0].color,
              if (fs.every((f) => f.count == fs[0].count)) 'count': fs[0].count,
              if (fs.every((f) => f.outline == fs[0].outline))
                'fill': fs[0].outline,
            };
            final common = shared(shown);
            expect(common, isNotEmpty);
            bool fits(Fig f) => shared([...shown, f]).length == common.length;
            for (var i = 0; i < q.choices.length; i++) {
              final f = Fig.parse(q.choices[i].label!)!;
              expect(
                fits(f),
                i == q.answer,
                reason: '${v.cells} → ${q.choices[i].label}',
              );
            }
          }
        }
      }
    },
  );

  test('number series and analogies have the right answers', () {
    for (var d = 0; d < 60; d++) {
      for (final level in grades) {
        final ws = WorksheetGenerator.build(
          start.add(Duration(days: d)),
          level,
          WorksheetKind.numberThinking,
        );
        for (final q in ws.questions.cast<ChoiceQuestion>()) {
          if (q.visual case MatrixVisual(:final cells) when cells.length == 6) {
            // Two worked rows with a +, −, ×, ÷ or simple rule; check one fits.
            final ins = [
              int.parse(cells[0]),
              int.parse(cells[2]),
              int.parse(cells[4]),
            ];
            final outs = [int.parse(cells[1]), int.parse(cells[3])];
            final ans = int.parse(
              q.choices[q.answer].label!.replaceAll(',', ''),
            );
            final rules = <int? Function(int)>[
              for (var k = 1; k <= 30; k++) (n) => n + k,
              for (var k = 1; k <= 30; k++) (n) => n - k,
              for (var k = 2; k <= 9; k++) (n) => n * k,
              for (var k = 2; k <= 9; k++) (n) => n % k == 0 ? n ~/ k : null,
              for (var k = 2; k <= 5; k++) (n) => n * k + 1,
              for (var k = 2; k <= 5; k++) (n) => n * k - 1,
              (n) => n * n,
            ];
            final fitting = rules.where(
              (r) => r(ins[0]) == outs[0] && r(ins[1]) == outs[1],
            );
            expect(fitting, isNotEmpty);
            for (final r in fitting) {
              expect(r(ins[2]), ans, reason: '$cells');
            }
          }
        }
      }
    }
  });

  test('K–2 picture puzzles only use pictures we have drawings for', () {
    bool drawn(String s) =>
        s == '?' ||
        s.startsWith('fig:') ||
        s.startsWith('paper:') ||
        RegExp(r'^[\d,]+$').hasMatch(s) ||
        isDrawn(s.characters.first);
    for (var d = 0; d < 60; d++) {
      for (final level in [Level.kindergarten, Level.grade1, Level.grade2]) {
        for (final kind in kinds) {
          final ws = WorksheetGenerator.build(
            start.add(Duration(days: d)),
            level,
            kind,
          );
          for (final q in ws.questions.cast<ChoiceQuestion>()) {
            for (final c in q.choices) {
              expect(drawn(c.label!), isTrue, reason: '${q.prompt} ${c.label}');
            }
            if (q.visual case MatrixVisual(:final cells)) {
              for (final c in cells) {
                expect(drawn(c), isTrue, reason: '${q.prompt} $c');
              }
            }
          }
        }
      }
    }
  });
}
