import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:little_learners/models/models.dart';
import 'package:little_learners/widgets/match_view.dart';

void main() {
  const q = MatchQuestion(
    prompt: 'Match!',
    left: [MatchItem('Cat'), MatchItem('Dog'), MatchItem('Cow')],
    right: [MatchItem('Moo'), MatchItem('Meow'), MatchItem('Woof')],
    answers: [1, 2, 0], // Cat→Meow, Dog→Woof, Cow→Moo
  );

  Future<List<String>> run(
    WidgetTester tester,
    Future<void> Function() act,
  ) async {
    final events = <String>[];
    tester.view.physicalSize = const Size(820, 1180);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MatchView(
            question: q,
            accent: Colors.blue,
            onMistake: () => events.add('mistake'),
            onPair: () => events.add('pair'),
            onDone: () => events.add('done'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await act();
    await tester.pumpAndSettle();
    return events;
  }

  Future<void> drag(WidgetTester tester, String from, String to) async {
    final start = tester.getCenter(find.text(from));
    final end = tester.getCenter(find.text(to));
    final g = await tester.startGesture(start);
    await tester.pump();
    for (var i = 1; i <= 10; i++) {
      await g.moveTo(Offset.lerp(start, end, i / 10)!);
      await tester.pump();
    }
    await g.up();
  }

  testWidgets('drag to the right partner matches', (tester) async {
    expect(await run(tester, () => drag(tester, 'Cat', 'Meow')), ['pair']);
  });

  testWidgets('drag works from the right side too', (tester) async {
    expect(await run(tester, () => drag(tester, 'Woof', 'Dog')), ['pair']);
  });

  testWidgets('drag to the wrong partner is a mistake', (tester) async {
    expect(await run(tester, () => drag(tester, 'Cat', 'Moo')), ['mistake']);
  });

  testWidgets('letting go in empty space does nothing', (tester) async {
    final events = await run(tester, () async {
      final start = tester.getCenter(find.text('Cat'));
      final g = await tester.startGesture(start);
      await g.moveBy(const Offset(120, 0));
      await tester.pump();
      await g.up();
    });
    expect(events, isEmpty);
  });

  testWidgets('tapping still works, and all pairs finish', (tester) async {
    final events = await run(tester, () async {
      await tester.tap(find.text('Cow'));
      await tester.pump();
      await tester.tap(find.text('Moo'));
      await tester.pump();
      await drag(tester, 'Cat', 'Meow');
      await tester.pump();
      await drag(tester, 'Dog', 'Woof');
    });
    expect(events, ['pair', 'pair', 'done']);
  });
}
