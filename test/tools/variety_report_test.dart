import 'package:flutter_test/flutter_test.dart';
import 'package:little_learners/models/generator.dart';
import 'package:little_learners/models/models.dart';

/// A question's "format": the first two words of its prompt, the picture type
/// and the answer style. Swapping only the item ("apples" → "cars") is the
/// same format.
String formatKey(Question q) => switch (q) {
  ChoiceQuestion() => () {
    final words = q.prompt
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z ]'), ' ')
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .take(2)
        .join(' ');
    final c = q.choices.first;
    final answerStyle = c.shape != null
        ? 'shape'
        : RegExp(r'^[0-9,.¢$/: ]+$').hasMatch(c.label!)
        ? 'num'
        : 'text';
    return '$words|${q.visual.runtimeType}|$answerStyle';
  }(),
  MatchQuestion() => 'match',
  TraceQuestion() => 'trace',
  ExampleQuestion() => 'example',
};

/// Average number of distinct formats per worksheet for [kind], over levels and days.
double variety(WorksheetKind kind) {
  var total = 0, n = 0;
  for (final level in Level.values.where(kind.suits)) {
    for (var d = 0; d < 10; d++) {
      final ws = WorksheetGenerator.build(
        DateTime(2026, 1, 1).add(Duration(days: d)),
        level,
        kind,
      );
      total += ws.questions.map(formatKey).toSet().length;
      n++;
    }
  }
  return total / n;
}

void main() {
  test('variety report', () {
    final rows = [
      for (final k in WorksheetKind.values)
        '${variety(k).toStringAsFixed(1).padLeft(4)}  ${k.category.name.padRight(8)} ${k.name}',
    ]..sort();
    // ignore: avoid_print
    print(rows.join('\n'));
  });
}
