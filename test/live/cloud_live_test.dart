// Live test against the real Supabase project. Run with:
//   flutter test test/live --dart-define-from-file=supabase.env.json
// Skipped when the app is built without Supabase settings.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:little_learners/models/models.dart';
import 'package:little_learners/services/cloud.dart';
import 'package:little_learners/state/progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = null; // allow real network calls

  test(
    'two devices share a family through Supabase',
    () async {
      SharedPreferences.setMockInitialValues({});
      await Cloud.instance.init();
      final email =
          'll.test.${DateTime.now().millisecondsSinceEpoch}@mailinator.com';
      const password = 'test-pass-123';

      // ---- Device A: create account, add a child, play.
      final a = await Progress.load();
      expect(
        await a.signUp(email, password),
        isTrue,
        reason: 'sign-up should sign in straight away (confirm email off)',
      );
      expect(a.signedIn, isTrue);
      const kid = Profile(
        id: 'p_livetest',
        name: 'Testy',
        avatar: '🦊',
        colorIndex: 3,
        level: Level.grade1,
      );
      await a.saveProfile(kid, makeActive: true);
      await a.complete(
        '20261123_addition',
        3,
        category: Category.math,
        kind: 'addition',
        questions: 5,
        mistakes: 0,
        seconds: 42,
      );
      await a.complete(
        '20261123_rhymes',
        2,
        category: Category.reading,
        kind: 'rhymes',
        questions: 5,
        mistakes: 1,
        seconds: 61,
      );
      await a.markSeen([
        const ChoiceQuestion(
          prompt: 'Live?',
          visual: EmojiVisual('🦊'),
          choices: [Choice.label('yes'), Choice.label('no')],
          answer: 0,
        ),
      ]);
      await a.sync();
      expect(a.syncError, isNull, reason: a.syncError);
      print('device A synced as $email');
      await a.signOut();
      a.dispose();

      // ---- Device B: empty device, sign in, everything comes back.
      SharedPreferences.setMockInitialValues({});
      final b = await Progress.load();
      expect(b.profiles, isEmpty);
      await b.signIn(email, password);
      expect(b.syncError, isNull, reason: b.syncError);
      expect(b.profiles.map((p) => p.name), ['Testy']);
      final child = b.profiles.single;
      expect(child.level, Level.grade1);
      final results = b.resultsOf(child);
      expect(results.length, 2);
      expect(results.map((r) => r.kind).toSet(), {'addition', 'rhymes'});
      expect(results.firstWhere((r) => r.kind == 'rhymes').mistakes, 1);
      expect(b.starsOf(child), 5);
      b.select(child);
      expect(
        b.recentlySeen(now: DateTime.now().add(const Duration(days: 1))),
        isNotEmpty,
      );
      print(
        'device B restored: ${results.length} results, ${b.starsOf(child)} stars',
      );

      // ---- Clean up: deleting on B removes it from the cloud.
      await b.deleteProfile(child);
      await b.sync();
      expect(b.syncError, isNull, reason: b.syncError);
      await b.signOut();
      b.dispose();
      SharedPreferences.setMockInitialValues({});
      final c = await Progress.load();
      await c.signIn(email, password);
      expect(
        c.profiles,
        isEmpty,
        reason: 'deleted child should be gone from the cloud',
      );
      await c.deleteAccountAndData(); // leave no test accounts behind
      c.dispose();
      print('cleanup ok');
    },
    skip: !Cloud.configured,
    timeout: const Timeout(Duration(minutes: 2)),
  );

  test(
    'deleting the account removes the family everywhere',
    () async {
      SharedPreferences.setMockInitialValues({});
      await Cloud.instance.init();
      final email =
          'll.del.${DateTime.now().millisecondsSinceEpoch}@mailinator.com';
      const password = 'test-pass-123';
      final a = await Progress.load();
      expect(await a.signUp(email, password), isTrue);
      const kid = Profile(
        id: 'p_deltest',
        name: 'Gone',
        avatar: '🐼',
        colorIndex: 1,
        level: Level.preK,
      );
      await a.saveProfile(kid, makeActive: true);
      await a.complete(
        '20261123_counting',
        3,
        category: Category.math,
        kind: 'counting',
        questions: 5,
      );
      await a.sync();
      expect(a.syncError, isNull, reason: a.syncError);

      await a.deleteAccountAndData();
      expect(a.signedIn, isFalse);
      expect(a.profiles, isEmpty);
      a.dispose();

      // The account no longer exists: signing in again must fail.
      SharedPreferences.setMockInitialValues({});
      final b = await Progress.load();
      await expectLater(b.signIn(email, password), throwsA(anything));
      b.dispose();
      print('account $email deleted');
    },
    skip: !Cloud.configured,
    timeout: const Timeout(Duration(minutes: 2)),
  );
}
