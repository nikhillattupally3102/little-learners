import 'package:flutter_test/flutter_test.dart';
import 'package:little_learners/generators/gen.dart';
import 'package:little_learners/models/generator.dart';
import 'package:little_learners/models/models.dart';

/// A worksheet shouldn't ask about the same thing twice, e.g. "Rabbits
/// live in burrows: true?" and then "Who lives in a burrow?".
void main() {
  List<String> factsOf(Question q) => switch (q) {
    ChoiceQuestion() => q.facts,
    MatchQuestion() => q.facts,
    _ => const [],
  };

  test('fact sheets never ask about the same fact twice', () {
    var tagged = 0;
    for (final kind in WorksheetKind.values) {
      for (final level in Level.values.where(kind.suits)) {
        for (var d = 0; d < 120; d += 3) {
          final ws = WorksheetGenerator.build(
            DateTime(2026, 1, 1).add(Duration(days: d)),
            level,
            kind,
          );
          final seen = <String>{};
          for (final q in ws.questions) {
            for (final f in factsOf(q)) {
              tagged++;
              expect(
                seen.add(f),
                isTrue,
                reason: '${kind.name} ${level.name} day $d: "$f" twice',
              );
            }
          }
        }
      }
    }
    expect(tagged, greaterThan(1000));
  });

  test('animal homes and baby animals: each animal comes up once', () {
    for (final kind in [WorksheetKind.animalHomes, WorksheetKind.babyAnimals]) {
      for (final level in Level.values.where(kind.suits)) {
        for (var d = 0; d < 120; d++) {
          final qs = WorksheetGenerator.build(
            DateTime(2026, 1, 1).add(Duration(days: d)),
            level,
            kind,
          ).questions;
          var related = 0;
          for (var i = 0; i < qs.length; i++) {
            for (var j = i + 1; j < qs.length; j++) {
              if (Gen.related(qs[i], qs[j])) related++;
            }
          }
          // A rare overlap is allowed only when the bank truly runs out.
          expect(
            related,
            lessThanOrEqualTo(1),
            reason: '${kind.name} ${level.name} day $d',
          );
        }
      }
    }
  });

  test('sheets rarely have two questions about the same thing', () {
    // Sheets that repeat on purpose: toddler and Pre-K "today's focus"
    // sheets show the same few letters, numbers and words several ways.
    const onPurpose = {
      WorksheetKind.tLetters,
      WorksheetKind.tNumbers,
      WorksheetKind.tTheme,
      WorksheetKind.tReview,
      WorksheetKind.tSame,
      WorksheetKind.sightWords,
      WorksheetKind.soundOut,
      WorksheetKind.sudoku,
    };
    var sheets = 0, withRelated = 0;
    for (final kind in WorksheetKind.values.where(
      (k) => !onPurpose.contains(k),
    )) {
      for (final level in Level.values.where(kind.suits)) {
        for (var d = 0; d < 30; d += 2) {
          final qs = WorksheetGenerator.build(
            DateTime(2026, 1, 1).add(Duration(days: d)),
            level,
            kind,
          ).questions;
          sheets++;
          var found = false;
          for (var i = 0; i < qs.length && !found; i++) {
            for (var j = i + 1; j < qs.length && !found; j++) {
              found = Gen.related(qs[i], qs[j]);
            }
          }
          if (found) withRelated++;
        }
      }
    }
    // Was 24% before; topic words (a map sheet saying "map") keep it above 0.
    expect(
      withRelated / sheets,
      lessThan(.06),
      reason: '$withRelated of $sheets',
    );
  });
}
