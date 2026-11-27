import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:little_learners/models/generator.dart';
import 'package:little_learners/models/models.dart';
import 'package:little_learners/screens/worksheet_screen.dart';
import 'package:little_learners/state/progress.dart';
import 'package:little_learners/widgets/lesson_cards.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  for (final size in const [
    Size(1180, 820),
    Size(820, 1180),
    Size(1366, 768),
  ]) {
    testWidgets(
      'a new child sees the lesson first (${size.width.toInt()}×${size.height.toInt()})',
      (tester) async {
        SharedPreferences.setMockInitialValues({});
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        late Progress progress;
        await tester.runAsync(() async {
          progress = await Progress.load();
          await progress.saveProfile(
            const Profile(
              id: 'k',
              name: 'K',
              avatar: '🦊',
              colorIndex: 0,
              level: Level.kindergarten,
            ),
            makeActive: true,
          );
        });
        final ws = WorksheetGenerator.build(
          DateTime(2026, 1, 5),
          Level.kindergarten,
          WorksheetKind.animalHomes,
        );
        expect(ws.lesson, isNotEmpty);
        await tester.pumpWidget(
          ProgressScope(
            notifier: progress,
            child: MaterialApp(home: WorksheetScreen(worksheet: ws)),
          ),
        );
        await tester.pump(const Duration(seconds: 1));
        expect(tester.takeException(), isNull);
        expect(find.byType(LessonCards), findsOneWidget);
        // Page 1 of 2 → Next → page 2 → Got it.
        if (ws.lesson.length > 1) {
          await tester.tap(find.text('Next'));
          for (var i = 0; i < 6; i++) {
            await tester.pump(const Duration(milliseconds: 500));
          }
          expect(tester.takeException(), isNull);
        }
        await tester.tap(find.text("Got it! Let's practice"));
        for (var i = 0; i < 6; i++) {
          await tester.pump(const Duration(milliseconds: 500));
        }
        expect(find.byType(LessonCards), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
