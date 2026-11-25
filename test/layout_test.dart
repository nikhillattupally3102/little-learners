import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:little_learners/main.dart';
import 'package:little_learners/state/progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The profile screens must fit common screen sizes without overflowing.
void main() {
  const sizes = [
    Size(360, 640),
    Size(390, 844),
    Size(820, 1180),
    Size(1280, 800),
    Size(1024, 600),
  ];

  for (final firstRun in [true, false]) {
    for (final size in sizes) {
      testWidgets(
        '${firstRun ? 'welcome' : 'picker'} fits ${size.width.toInt()}×${size.height.toInt()}',
        (tester) async {
          tester.view.physicalSize = size;
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.reset);
          SharedPreferences.setMockInitialValues({
            if (!firstRun)
              'profiles': jsonEncode([
                for (var i = 0; i < 4; i++)
                  {
                    'id': 'k$i',
                    'name': 'Kid $i',
                    'avatar': '🦁',
                    'color': i * 3,
                    'level': 'grade$i',
                  },
              ]),
          });
          await tester.pumpWidget(
            LittleLearnersApp(progress: await Progress.load()),
          );
          for (var i = 0; i < 20; i++) {
            await tester.pump(const Duration(milliseconds: 100));
          }
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
