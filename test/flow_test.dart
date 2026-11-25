import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:little_learners/main.dart';
import 'package:little_learners/screens/home_screen.dart';
import 'package:little_learners/screens/profiles_screen.dart';
import 'package:little_learners/state/progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Pumps frames for a while (the app has never-ending background animations).
Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 30; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  testWidgets('first run: create learner then reach home; switch shows picker', (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 2.6;
    SharedPreferences.setMockInitialValues({});
    final progress = await Progress.load();
    await tester.pumpWidget(LittleLearnersApp(progress: progress));
    await settle(tester);

    await tester.enterText(find.byType(TextField), 'Mia');
    await tester.pump();
    await tester.tap(find.textContaining("Let's go", findRichText: true));
    await settle(tester);
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.textContaining('Mia!', findRichText: true), findsOneWidget);

    // Tap the buddy avatar to switch learner.
    await tester.tap(find.byIcon(Icons.swap_horiz_rounded));
    await settle(tester);
    expect(find.byType(ProfilesScreen), findsOneWidget);

    // Pick Mia again → back home.
    await tester.tap(find.text('Mia'));
    await settle(tester);
    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
