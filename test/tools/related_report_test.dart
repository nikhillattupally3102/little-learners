import 'package:flutter_test/flutter_test.dart';
import 'package:little_learners/generators/gen.dart';
import 'package:little_learners/models/generator.dart';
import 'package:little_learners/models/models.dart';

/// For each worksheet kind: how many sheets (all levels × 30 days) have two
/// questions about the same thing, and an example.
void main() {
  test('related questions report', () {
    final rows = <String>[];
    var sheets = 0, bad = 0;
    for (final kind in WorksheetKind.values) {
      var n = 0, hit = 0;
      String? example;
      for (final level in Level.values.where(kind.suits)) {
        for (var d = 0; d < 30; d++) {
          final ws = WorksheetGenerator.build(
            DateTime(2026, 1, 1).add(Duration(days: d)),
            level,
            kind,
          );
          n++;
          final qs = ws.questions;
          var found = false;
          for (var i = 0; i < qs.length && !found; i++) {
            for (var j = i + 1; j < qs.length && !found; j++) {
              if (Gen.related(qs[i], qs[j])) {
                found = true;
                final (aa, sa) = Gen.aboutOf(qs[i]);
                final (ba, sb) = Gen.aboutOf(qs[j]);
                final shared = {...aa, ...sa}.intersection({...ba, ...sb});
                example ??=
                    '${level.name}: ${_p(qs[i])}  ⟷  ${_p(qs[j])}  [$shared]';
              }
            }
          }
          if (found) hit++;
        }
      }
      sheets += n;
      bad += hit;
      if (hit > 0)
        rows.add(
          '${(100 * hit / n).round().toString().padLeft(3)}%  ${kind.name.padRight(16)} $example',
        );
    }
    rows.sort((a, b) => b.compareTo(a));
    // ignore: avoid_print
    print(
      '${(100 * bad / sheets).round()}% of $sheets sheets have related questions\n${rows.join('\n')}',
    );
  });
}

String _p(Question q) => switch (q) {
  ChoiceQuestion() =>
    '"${q.prompt}" ${q.visual is TextVisual
        ? (q.visual as TextVisual).text
        : q.visual is EmojiVisual
        ? (q.visual as EmojiVisual).emoji
        : ''} → ${q.choices[q.answer].label}',
  MatchQuestion() => 'match(${q.left.map((e) => e.text).join(',')})',
  _ => q.runtimeType.toString(),
};
