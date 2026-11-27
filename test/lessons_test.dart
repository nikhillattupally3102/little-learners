import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:little_learners/generators/lessons.dart';
import 'package:little_learners/models/generator.dart';
import 'package:little_learners/models/models.dart';
import 'package:little_learners/widgets/lesson_cards.dart';

void main() {
  test('every sheet (Pre-K up) comes with a short lesson', () {
    final problems = <String>[];
    final missing = <String, int>{};
    for (final level in Level.values.where((l) => l.atLeast(Level.preK))) {
      for (final kind in level.kinds.where((k) => hasLesson(k, level))) {
        for (var d = 0; d < 40; d++) {
          final ws = WorksheetGenerator.build(
            DateTime(2026, 1, 1).add(Duration(days: d)),
            level,
            kind,
          );
          final where = '${level.name}/${kind.name}';
          if (ws.lesson.isEmpty) {
            missing.update(where, (n) => n + 1, ifAbsent: () => 1);
          }
          if (ws.lesson.length > 2) {
            problems.add('$where: ${ws.lesson.length} pages');
          }
          for (final page in ws.lesson) {
            if (page.steps.isEmpty || page.steps.any((s) => s.trim().isEmpty)) {
              problems.add('$where: empty step');
            }
            if (page.steps.any((s) => s.contains('-1') || s.contains('null'))) {
              problems.add('$where: odd step ${page.steps}');
            }
            if (page.visual is! LessonVisual) continue;
            final cards = (page.visual as LessonVisual).cards;
            if (cards.length > lessonPageSize) {
              problems.add('$where: ${cards.length} cards');
            }
            for (final c in cards) {
              if (c.sentence.trim().isEmpty || c.pic.isEmpty) {
                problems.add('$where: empty card');
              }
              // A picture answer we have no word for: the card can't say it.
              if (c.label.isEmpty && !RegExp(r'[a-zA-Z]').hasMatch(c.pic)) {
                problems.add('no word: ${c.pic} "${c.sentence}"');
              }
            }
          }
        }
      }
    }
    expect(problems.toSet().join('\n'), isEmpty);
    // A sheet may miss its lesson now and then (too little to teach), but
    // never most of the time.
    expect(
      missing.entries
          .where((e) => e.value > 4)
          .map((e) => '${e.key} ${e.value}/40'),
      isEmpty,
    );
  });

  test('times tables teach with their own worked example instead', () {
    final ws = WorksheetGenerator.build(
      DateTime(2026, 1, 5),
      Level.grade2,
      WorksheetKind.multiplication,
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
