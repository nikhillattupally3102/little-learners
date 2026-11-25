import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:little_learners/content/photo_credits.dart';
import 'package:little_learners/content/topics.dart';
import 'package:little_learners/widgets/real_photo.dart';

void main() {
  test('every credited photo file exists, and every licence is app-safe', () {
    final ok = RegExp(r'^(public domain|pd|cc0|cc by(-sa)?\b)', caseSensitive: false);
    for (final e in photoCredits.entries) {
      expect(File(photoAsset(e.key)).existsSync(), isTrue, reason: e.key);
      expect(ok.hasMatch(e.value.license), isTrue, reason: '${e.key}: ${e.value.license}');
      expect(e.value.source, startsWith('https://commons.wikimedia.org/'));
    }
  });

  test('items without a photo simply have none (no errors)', () {
    var withPhoto = 0, without = 0;
    for (final t in topics) {
      for (final i in t.items) {
        final id = photoIdFor(t, i);
        if (id == null) {
          without++;
        } else {
          withPhoto++;
          expect(photoCredits.containsKey(id), isTrue);
        }
      }
    }
    expect(withPhoto, greaterThan(150));
    expect(without, greaterThan(0)); // numbers, some letters, a few body parts
    final body = topics.firstWhere((t) => t.id == 'body');
    expect(photoIdFor(body, body.items.firstWhere((i) => i.name == 'Brain')), isNull);
    final abc = topics.firstWhere((t) => t.id == 'abc1');
    expect(photoIdFor(abc, abc.items.first), 'fruits__apple'); // A is for apple
    expect(photoIdFor(abc, abc.items[1]), isNull); // B is for ball: no photo
  });

  testWidgets('a missing photo file renders nothing instead of an error', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: RealPhoto('not_a_real_photo', width: 200))),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}
