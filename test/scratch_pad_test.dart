import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:little_learners/models/generator.dart';
import 'package:little_learners/models/models.dart';
import 'package:little_learners/screens/worksheet_screen.dart';
import 'package:little_learners/state/progress.dart';
import 'package:little_learners/widgets/scratch_pad.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<void> open(
    WidgetTester tester,
    Level level,
    WorksheetKind kind,
  ) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(1180, 820);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    late Progress progress;
    await tester.runAsync(() async {
      progress = await Progress.load();
      await progress.saveProfile(
        Profile(id: 'k', name: 'K', avatar: '🦊', colorIndex: 0, level: level),
        makeActive: true,
      );
    });
    final ws = WorksheetGenerator.build(DateTime(2026, 11, 24), level, kind);
    await tester.pumpWidget(
      ProgressScope(
        notifier: progress,
        child: MaterialApp(home: WorksheetScreen(worksheet: ws)),
      ),
    );
    await tester.pump(const Duration(milliseconds: 600));
    // A new child sees the "Let's learn!" page first.
    expect(tester.takeException(), isNull);
    final start = find.text("Got it! Let's practice");
    if (start.evaluate().isNotEmpty) {
      await tester.tap(start);
      await tester.pump(const Duration(milliseconds: 600));
    }
  }

  testWidgets('Grade 1 maths shows rough-work paper', (tester) async {
    await open(tester, Level.grade1, WorksheetKind.addition);
    expect(find.byType(ScratchPad), findsOneWidget);

    // Draw a line, tap two dots, undo, clear — no errors.
    final pad = tester.getRect(find.byType(ScratchPad));
    final g = await tester.startGesture(pad.center);
    await g.moveBy(const Offset(60, 20));
    await g.moveBy(const Offset(40, -30));
    await g.up();
    await tester.tapAt(pad.center + const Offset(-80, 40));
    await tester.tapAt(pad.center + const Offset(-50, 40));
    await tester.tap(find.byIcon(Icons.undo_rounded));
    await tester.tap(find.byIcon(Icons.delete_outline_rounded));
    await tester.pump();

    // It can be hidden and brought back.
    await tester.tap(
      find.descendant(
        of: find.byType(ScratchPad),
        matching: find.byIcon(Icons.close_rounded),
      ),
    );
    await tester.pump();
    expect(find.byType(ScratchPad), findsNothing);
    await tester.tap(find.text('Rough work'));
    await tester.pump();
    expect(find.byType(ScratchPad), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Kindergarten maths has no pad', (tester) async {
    await open(tester, Level.kindergarten, WorksheetKind.addition);
    expect(find.byType(ScratchPad), findsNothing);
  });

  testWidgets('Reading worksheets have no pad', (tester) async {
    await open(tester, Level.grade2, WorksheetKind.rhymes);
    expect(find.byType(ScratchPad), findsNothing);
  });
}
