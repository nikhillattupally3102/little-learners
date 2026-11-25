import 'package:flutter_test/flutter_test.dart';
import 'package:little_learners/content/daily_focus.dart';
import 'package:little_learners/content/topics.dart';
import 'package:little_learners/generators/topic_sheets.dart';
import 'package:little_learners/models/generator.dart';
import 'package:little_learners/models/models.dart';

/// Age 2 and Age 3 must never need reading.
void main() {
  final letters = RegExp(r'[A-Za-z0-9]');
  final start = DateTime(2026, 11, 1);
  DateTime day(int d) => start.add(Duration(days: d));

  test('toddlers only get toddler activities', () {
    for (final level in [Level.age2, Level.age3]) {
      for (final k in level.kinds) {
        expect(k.name.startsWith('t'), isTrue, reason: '${level.name}: ${k.name}');
      }
    }
    // …and older children never get them.
    for (final level in Level.values.where((l) => !l.atMost(Level.age3))) {
      expect(level.kinds.where((k) => k.max.atMost(Level.age3)), isEmpty);
    }
  });

  test('every toddler answer is a picture, except in letters & numbers', () {
    for (final level in [Level.age2, Level.age3]) {
      for (var d = 0; d < 60; d++) {
        final date = day(d);
        final sheets = [
          ...WorksheetGenerator.forDay(date, level),
          ...WorksheetGenerator.bonusForDay(date, level),
          // Every learning session ends in a short picture game.
          for (final t in topicsForDay(date, level))
              WorksheetGenerator.buildTopicQuiz(date, level, t),
        ];
        for (final ws in sheets) {
          final lettersOk = ws.kind == WorksheetKind.tLetters ||
              ws.kind == WorksheetKind.tNumbers ||
              ws.kind == WorksheetKind.tReview ||
              ws.id.contains('_topic_abc') ||
              ws.id.contains('_topic_numbers');
          final tracing = ws.kind == WorksheetKind.tTrace;
          expect(ws.questions, isNotEmpty, reason: ws.id);
          for (final q in ws.questions) {
            switch (q) {
              case ChoiceQuestion():
                expect(q.choices.length, level == Level.age2 ? 2 : 3,
                    reason: '${ws.kind.name}: ${q.prompt}');
                for (final c in q.choices) {
                  if (c.label == null || lettersOk) continue;
                  if (c.label!.startsWith('shape:')) continue;
                  expect(letters.hasMatch(c.label!), isFalse,
                      reason: '${ws.kind.name}: "${q.prompt}" → ${c.label}');
                }
                expect(q.visual is TextVisual || q.visual is PassageVisual,
                    isFalse, reason: '${ws.kind.name}: ${q.prompt}');
              case MatchQuestion():
                for (final i in [...q.left, ...q.right]) {
                  expect(i.text, isEmpty, reason: ws.kind.name);
                }
              case TraceQuestion():
                expect(tracing && level == Level.age3, isTrue,
                    reason: 'Only Age 3 traces, in its tracing sheets (${ws.kind.name})');
              case ExampleQuestion():
                fail('No worked examples for toddlers (${ws.kind.name})');
            }
          }
        }
      }
    }
  });

  test('daily plan: letters, numbers and a theme (+ tracing for Age 3)', () {
    final date = DateTime(2026, 11, 24);
    for (final level in [Level.age2, Level.age3]) {
      final learn = topicsForDay(date, level);
      expect(learn.map((t) => t.id), ['abc', 'numbers', isNotNull]);
      expect(learn.last.items.length, toddlerThemeSize);
      final sheets = WorksheetGenerator.forDay(date, level);
      // 3 learn-and-play sessions + review (+ tracing for Age 3):
      // 4 tiles for Age 2, 5 for Age 3; about 5 things in each for Age 3.
      expect(sheets.map((w) => w.kind), [
        if (level == Level.age3) WorksheetKind.tTrace,
        WorksheetKind.tReview,
      ]);
      expect(learn.length + sheets.length, level == Level.age2 ? 4 : 5);
      final per = level == Level.age2 ? 3 : 5;
      for (final ws in [
        ...sheets.where((w) => w.kind == WorksheetKind.tReview),
        for (final t in learn) WorksheetGenerator.buildTopicQuiz(date, level, t),
      ]) {
        expect(ws.questions.length, per, reason: ws.title);
      }
      if (level == Level.age3) expect(sheets.first.questions.length, 6);
    }
    expect(WorksheetGenerator.bonusForDay(date, Level.age2), isEmpty);
    expect(topicsForDay(date, Level.preK).length, 1);
  });

  test('worksheets use exactly today\'s letters, numbers and theme items', () {
    for (var d = 0; d < 40; d++) {
      for (final level in [Level.age2, Level.age3]) {
        final f = ToddlerFocus.of(day(d), level);
        expect(f.letters.length, level == Level.age2 ? 2 : 3);
        final names = {for (final l in f.letters) l.name};
        final nums = {for (final n in f.numbers) n.name};
        final sheets = [
          for (final t in topicsForDay(day(d), level))
            WorksheetGenerator.buildTopicQuiz(day(d), level, t),
          ...WorksheetGenerator.forDay(day(d), level)
              .where((w) => w.kind != WorksheetKind.tReview),
        ];
        for (final ws in sheets) {
          final kind = ws.id.contains('_topic_abc')
              ? WorksheetKind.tLetters
              : ws.id.contains('_topic_numbers')
              ? WorksheetKind.tNumbers
              : ws.kind == WorksheetKind.topicQuiz
              ? WorksheetKind.tTheme
              : ws.kind;
          for (final q in ws.questions) {
            if (kind == WorksheetKind.tLetters && q is ChoiceQuestion) {
              final labels = q.choices.map((c) => c.label).toSet();
              if (labels.every((l) => l!.length == 1)) {
                expect(names.containsAll(labels), isTrue, reason: '$labels vs $names');
              }
            }
            if (kind == WorksheetKind.tNumbers &&
                q is ChoiceQuestion &&
                q.visual is CountVisual) {
              expect(nums.containsAll(q.choices.map((c) => c.label)), isTrue);
            }
            if (q is TraceQuestion) {
              expect({...names, ...nums}, contains(q.glyph));
            }
            if (kind == WorksheetKind.tTheme &&
                q is ChoiceQuestion &&
                f.theme != ToddlerTheme.colors &&
                f.theme != ToddlerTheme.shapes) {
              final today = f.items.map((i) => i.emoji).toSet();
              expect(today, contains(q.choices[q.answer].label));
            }
          }
        }
      }
    }
  });

  test('the theme changes every day and brings new items when it returns', () {
    for (var d = 0; d < 60; d++) {
      final a = ToddlerFocus.of(day(d), Level.age2);
      final b = ToddlerFocus.of(day(d + 1), Level.age2);
      expect(a.theme, isNot(b.theme));
      expect(a.items.length, toddlerThemeSize);
      expect(a.items.map((i) => i.name).toSet().length, toddlerThemeSize);
      for (final i in a.items) {
        expect(isDrawn(i.emoji), isTrue, reason: i.emoji);
      }
      // Next time this theme comes round (5 days on), mostly new items.
      if (a.theme == ToddlerTheme.animals || a.theme == ToddlerTheme.food) {
        final next = ToddlerFocus.of(day(d + ToddlerTheme.values.length), Level.age2);
        final again = next.items.where((i) => a.items.any((x) => x.name == i.name));
        expect(again, isEmpty, reason: '${a.theme}: ${again.map((i) => i.name)}');
      }
    }
  });

  test('letters go through A–Z in order; numbers stay in range', () {
    final seen = <String>{};
    for (var d = 0; d < 13; d++) {
      seen.addAll(ToddlerFocus.of(day(d), Level.age2).letters.map((l) => l.name));
      for (final n in ToddlerFocus.of(day(d), Level.age2).numbers) {
        expect(int.parse(n.name), inInclusiveRange(1, 5));
      }
    }
    expect(seen.length, 26);
    // Toddler topics never leak into older children's rotation or stickers.
    for (var d = 0; d < 60; d++) {
      expect(topicForDay(day(d)).toddlerOnly, isFalse);
    }
    expect(topics.where((t) => t.id == 'animals'), isEmpty);
  });

  test('Age 2 plays with exactly what it just learned, and reviews yesterday', () {
    for (var d = 1; d < 30; d++) {
      final f = ToddlerFocus.of(day(d), Level.age2);
      final y = ToddlerFocus.of(day(d - 1), Level.age2);
      for (final t in topicsForDay(day(d), Level.age2)) {
        final quiz = WorksheetGenerator.buildTopicQuiz(day(d), Level.age2, t);
        expect(quiz.questions.length, 3, reason: t.id);
        if (t.id == 'abc') {
          for (final q in quiz.questions.cast<ChoiceQuestion>()) {
            expect(f.letters.map((l) => l.name), contains(q.choices[q.answer].label));
          }
        }
      }
      final review = WorksheetGenerator.forDay(day(d), Level.age2).single;
      expect(review.questions.length, 3);
      final letterQ = review.questions.cast<ChoiceQuestion>().where(
          (q) => q.choices.every((c) => c.label != null && RegExp(r'^[A-Z]$').hasMatch(c.label!)));
      for (final q in letterQ) {
        expect(y.letters.map((l) => l.name), contains(q.choices[q.answer].label));
      }
    }
  });
}
