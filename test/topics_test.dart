import 'package:flutter_test/flutter_test.dart';
import 'package:little_learners/content/topic_depth.dart';
import 'package:little_learners/content/topics.dart';
import 'package:little_learners/models/generator.dart';
import 'package:little_learners/models/models.dart';

void main() {
  test('every topic has at least 10 distinct items', () {
    for (final t in topics) {
      expect(t.items.length, greaterThanOrEqualTo(10), reason: t.id);
      expect(t.items.map((i) => i.name).toSet().length, t.items.length, reason: '${t.id} duplicate name');
      expect(t.items.map((i) => i.emoji).toSet().length, t.items.length, reason: '${t.id} duplicate emoji');
    }
  });

  test('topic quizzes are valid at every level', () {
    for (final t in topics) {
      for (final level in Level.values) {
        if (t.toddlerOnly && !level.atMost(Level.age3)) continue;
        for (var d = 0; d < 15; d++) {
          final ws = WorksheetGenerator.buildTopicQuiz(DateTime(2026, 2, 1).add(Duration(days: d)), level, t);
          if (level.atMost(Level.age3)) {
            // Toddlers: picture taps only — no matching, nothing to read.
            expect(ws.questions.length, greaterThanOrEqualTo(3));
            expect(ws.questions.whereType<MatchQuestion>(), isEmpty);
          } else if (level.atMost(Level.grade2)) {
            expect(ws.questions.length, greaterThanOrEqualTo(4));
            final match = ws.questions.first as MatchQuestion;
            // Up to 8 pairs, leaving fresh things for the other questions.
            expect(match.left.length, inInclusiveRange(4, 8));
          } else {
            // Grade 3+: no picture matching, a full set of questions.
            expect(ws.questions.length, greaterThanOrEqualTo(8));
            expect(ws.questions.whereType<MatchQuestion>(), isEmpty);
          }
          for (final q in ws.questions.whereType<ChoiceQuestion>()) {
            expect(q.choices.map((c) => '${c.label}${c.shape}${c.color}').toSet().length, q.choices.length,
                reason: '${t.id} ${q.prompt}');
            expect(q.answer, inInclusiveRange(0, q.choices.length - 1));
          }
        }
      }
    }
  });

  test('matching has 4–8 pairs (3–4 for toddlers)', () {
    for (final level in Level.values) {
      for (final kind in level.kinds) {
        final ws = WorksheetGenerator.build(DateTime(2026, 3, 3), level, kind);
        for (final m in ws.questions.whereType<MatchQuestion>()) {
          expect(
            m.left.length,
            level == Level.age2
                ? 3
                : level == Level.age3
                ? 4
                : inInclusiveRange(4, 8),
            reason: '${level.name}/${kind.name}',
          );
        }
      }
    }
  });

  test('every rotating topic has deeper facts and graded questions', () {
    for (final t in topics.where((t) => !t.toddlerOnly)) {
      final more = deeperFacts[t.id];
      expect(more, isNotNull, reason: t.id);
      for (final i in t.items) {
        final f = more![i.name];
        expect(f, isNotNull, reason: '${t.id}/${i.name}');
        // Clues must not give the answer away.
        expect(f!.toLowerCase().contains(i.name.toLowerCase()), isFalse, reason: '${t.id}/${i.name}: $f');
      }
      expect(more!.keys.toSet(), t.items.map((i) => i.name).toSet(), reason: t.id);
      final bank = topicQuestions[t.id]!;
      for (final l in [Level.grade1, Level.grade2, Level.grade3, Level.grade4, Level.grade5]) {
        expect(bank.where((f) => f.suits(l)).length, greaterThanOrEqualTo(3), reason: '${t.id} ${l.name}');
      }
      for (final f in bank) {
        expect(f.wrong.contains(f.answer), isFalse, reason: f.question);
      }
    }
  });

  test('Kindergarten and Grade 5 get different topic quizzes', () {
    for (final t in topics.where((t) => !t.toddlerOnly)) {
      for (var d = 0; d < 5; d++) {
        final day = DateTime(2026, 2, 1).add(Duration(days: d));
        String sig(Question q) => q is ChoiceQuestion
            ? '${q.prompt}|${q.speech?.join(' ')}|${q.choices[q.answer].label}'
            : (q as MatchQuestion).prompt;
        final k = WorksheetGenerator.buildTopicQuiz(day, Level.kindergarten, t).questions.map(sig).toSet();
        final g5 = WorksheetGenerator.buildTopicQuiz(day, Level.grade5, t).questions.map(sig).toSet();
        expect(k.intersection(g5).length, lessThanOrEqualTo(1), reason: '${t.id} ${k.intersection(g5)}');
      }
    }
  });
}
