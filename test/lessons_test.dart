import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:little_learners/generators/lessons.dart';
import 'package:little_learners/models/generator.dart';
import 'package:little_learners/models/models.dart';
import 'package:little_learners/widgets/lesson_cards.dart';

bool _teaches(WorksheetKind k) =>
    k.category == Category.science || k.category == Category.geography;

void main() {
  test('science and geography sheets come with a short lesson', () {
    final problems = <String>[];
    var sheets = 0, withLesson = 0;
    for (final level in Level.values.where((l) => l.atLeast(Level.preK))) {
      for (final kind in level.kinds.where(_teaches)) {
        for (var d = 0; d < 40; d++) {
          final ws = WorksheetGenerator.build(
            DateTime(2026, 1, 1).add(Duration(days: d)),
            level,
            kind,
          );
          sheets++;
          if (ws.lesson.isNotEmpty) withLesson++;
          if (ws.lesson.length > 2) {
            problems.add('${level.name}/${kind.name}: ${ws.lesson.length} pages');
          }
          for (final page in ws.lesson) {
            final cards = (page.visual as LessonVisual).cards;
            if (cards.length > lessonPageSize) {
              problems.add('${level.name}/${kind.name}: ${cards.length} cards');
            }
            for (final c in cards) {
              if (c.sentence.trim().isEmpty || c.pic.isEmpty) {
                problems.add('${level.name}/${kind.name}: empty card');
              }
              // A picture answer we have no word for: the card can't say it.
              if (c.label.isEmpty) {
                problems.add('no word: ${c.pic} "${c.sentence}"');
              }
            }
          }
        }
      }
    }
    expect(problems.toSet().join('\n'), isEmpty);
    expect(withLesson / sheets, greaterThan(.95));
  });

  test('other sheets have no lesson', () {
    final ws = WorksheetGenerator.build(
      DateTime(2026, 1, 5),
      Level.grade2,
      WorksheetKind.addition,
    );
    expect(ws.lesson, isEmpty);
  });

  for (final (w, h) in [(700.0, 430.0), (1000.0, 380.0), (360.0, 470.0)]) {
    testWidgets('lesson cards fit in ${w.toInt()}×${h.toInt()}', (t) async {
      final ws = WorksheetGenerator.build(
        DateTime(2026, 1, 5),
        Level.grade3,
        WorksheetKind.space,
      );
      await t.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: w,
                height: h,
                child: LessonCards(
                  ws.lesson.first.visual as LessonVisual,
                  accent: Colors.blue,
                  segment: ValueNotifier(1),
                ),
              ),
            ),
          ),
        ),
      );
      await t.pumpAndSettle();
      expect(t.takeException(), isNull);
    });
  }
}
