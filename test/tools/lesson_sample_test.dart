import 'package:flutter_test/flutter_test.dart';
import 'package:little_learners/generators/lessons.dart';
import 'package:little_learners/models/generator.dart';
import 'package:little_learners/models/models.dart';

/// Prints one lesson per kind and level, to read through.
void main() {
  test('lesson samples', () {
    final out = StringBuffer();
    for (final kind in WorksheetKind.values) {
      for (final level in Level.values) {
        if (!kind.suits(level) || !hasLesson(kind, level)) continue;
        if (kind.category == Category.science ||
            kind.category == Category.geography)
          continue;
        final ws = WorksheetGenerator.build(DateTime(2026, 1, 7), level, kind);
        out.writeln('== ${level.name}/${kind.name}');
        for (final p in ws.lesson) {
          out.writeln('  # ${p.title}');
          if (p.visual is LessonVisual) {
            for (final c in (p.visual as LessonVisual).cards) {
              out.writeln('    ${c.pic} [${c.label}] ${c.sentence}');
            }
          } else {
            for (final s in p.steps) {
              out.writeln('    - $s');
            }
          }
        }
      }
    }
    // ignore: avoid_print
    print(out);
  });
}
