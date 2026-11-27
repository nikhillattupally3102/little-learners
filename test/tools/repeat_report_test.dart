import 'package:flutter_test/flutter_test.dart';
import 'package:little_learners/generators/gen.dart';
import 'package:little_learners/models/generator.dart';
import 'package:little_learners/models/models.dart';

/// Over 3 months of daily plans: what share of questions a child has already
/// seen in the last 30 days, per level and per worksheet kind.
void main() {
  test('repeat report', () {
    final byKind = <String, (int, int)>{};
    final out = StringBuffer();
    for (final level in Level.values) {
      final seen = <String, int>{};
      var n = 0, rep = 0;
      for (var d = 0; d < 90; d++) {
        final date = DateTime(2026, 1, 1).add(Duration(days: d));
        for (final ws in WorksheetGenerator.forDay(date, level)) {
          for (final q in ws.questions) {
            if (q is ExampleQuestion || q is TraceQuestion) continue;
            final f = Gen.fingerprint(q);
            final last = seen[f];
            final r = last != null && d - last <= 30;
            if (d >= 30) {
              n++;
              if (r) rep++;
              final k = '${level.name}/${ws.kind.name}';
              final (a, b) = byKind[k] ?? (0, 0);
              byKind[k] = (a + (r ? 1 : 0), b + 1);
            }
            seen[f] = d;
          }
        }
      }
      if (n > 0) out.writeln('${level.name.padRight(13)} ${(100 * rep / n).round()}% repeats of $n');
    }
    final worst = byKind.entries.where((e) => e.value.$2 >= 15).toList()
      ..sort((a, b) => (b.value.$1 / b.value.$2).compareTo(a.value.$1 / a.value.$2));
    for (final e in worst.take(30)) {
      out.writeln('${(100 * e.value.$1 / e.value.$2).round().toString().padLeft(3)}%  ${e.key} (${e.value.$2})');
    }
    // ignore: avoid_print
    print(out);
  });
}
