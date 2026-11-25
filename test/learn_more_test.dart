import 'package:flutter_test/flutter_test.dart';
import 'package:little_learners/generators/learn_more.dart';
import 'package:little_learners/models/generator.dart';
import 'package:little_learners/models/models.dart';

void main() {
  final start = DateTime(2026, 11, 1);
  DateTime day(int d) => start.add(Duration(days: d));
  List<String> ids(Level l, [int d = 0]) =>
      learnMoreFor(l, day(d)).map((m) => m.topic.id).toList();

  test('each level gets its own sessions, growing with age', () {
    expect(ids(Level.age2), [
      'abc1', 'abc2', 'numbers', 'shapes', 'colors', 'farm', //
    ]);
    expect(ids(Level.age3), containsAllInOrder(ids(Level.age2)));
    expect(ids(Level.age3), containsAll(['wild', 'fruits']));
    expect(
      ids(Level.preK),
      containsAll([
        ...ids(Level.age3).take(6),
        'sightwords',
        'words3',
        'countries',
      ]),
    );
    // From K on, the toddler basics drop away.
    for (final l in Level.values.where((l) => l.atLeast(Level.kindergarten))) {
      expect(ids(l), isNot(contains('abc1')), reason: l.name);
      expect(ids(l), isNot(contains('shapes')), reason: l.name);
    }
    expect(
      ids(Level.grade3).length,
      greaterThan(ids(Level.kindergarten).length),
    );
    // A few countries for Pre-K, more later.
    int countries(Level l) => learnMoreFor(
      l,
      day(0),
    ).firstWhere((m) => m.topic.id == 'countries').topic.items.length;
    expect(countries(Level.preK), lessThan(countries(Level.kindergarten)));
    expect(countries(Level.kindergarten), lessThan(countries(Level.grade1)));
    // Age 2 counts to 5; Age 3 to 10.
    expect(learnMoreFor(Level.age2, day(0))[2].topic.items.length, 5);
    expect(learnMoreFor(Level.age3, day(0))[2].topic.items.length, 10);
  });

  test('every session has cards and a working game, every day', () {
    for (var d = 0; d < 60; d += 3) {
      for (final level in Level.values) {
        final all = learnMoreFor(level, day(d));
        expect(all.map((m) => m.topic.id).toSet().length, all.length);
        for (final more in all) {
          final t = more.topic;
          expect(t.items, isNotEmpty, reason: '${level.name} ${t.id}');
          final quiz = WorksheetGenerator.buildLearnMoreQuiz(
            day(d),
            level,
            more,
          );
          expect(quiz.id, contains('_topic_more_'));
          expect(
            quiz.questions.length,
            greaterThanOrEqualTo(3),
            reason: '${level.name} ${t.id}',
          );
          for (final q in quiz.questions.whereType<ChoiceQuestion>()) {
            expect(q.answer, inInclusiveRange(0, q.choices.length - 1));
            expect(
              q.choices.length,
              greaterThanOrEqualTo(2),
              reason: '${level.name} ${t.id}: ${q.prompt}',
            );
            if (level.atMost(Level.age3)) {
              expect(q.choices.length, level == Level.age2 ? 2 : 3);
            }
          }
          // Word games only ask about the words on the cards.
          if (t.id == 'sightwords' || t.id == 'words3') {
            final words = {
              for (final i in t.items) i.name,
              for (final i in t.items) i.emoji,
            };
            for (final q in quiz.questions.cast<ChoiceQuestion>()) {
              expect(
                words,
                contains(q.choices[q.answer].label),
                reason: q.prompt,
              );
            }
          }
        }
      }
    }
  });

  test('Pre-K words are the ones met in the last few days', () {
    final more = learnMoreFor(Level.preK, day(10));
    final sight = more
        .firstWhere((m) => m.topic.id == 'sightwords')
        .topic
        .items;
    final cvc = more.firstWhere((m) => m.topic.id == 'words3').topic.items;
    expect(sight.length, inInclusiveRange(6, 10));
    expect(cvc.length, inInclusiveRange(4, 8));
    // Words are read aloud with their sounds.
    expect(cvc.first.say, isNotNull);
    expect(cvc.first.say!.length, greaterThan(3));
  });
}
