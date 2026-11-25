import 'package:flutter_test/flutter_test.dart';
import 'package:little_learners/models/models.dart';
import 'package:little_learners/state/progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

Profile _kid(String id, String name) =>
    Profile(id: id, name: name, avatar: '🦁', colorIndex: 0, level: Level.preK);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test(
    'each learner keeps separate stars, and delete removes their data',
    () async {
      final progress = await Progress.load();
      expect(progress.profiles, isEmpty);

      final mia = _kid('mia', 'Mia');
      final leo = _kid('leo', 'Leo');
      await progress.saveProfile(mia, makeActive: true);
      await progress.saveProfile(leo);
      expect(progress.active?.name, 'Mia');

      await progress.complete('sheet1', 3);
      expect(progress.starsOf(mia), 3);
      expect(progress.starsOf(leo), 0);
      expect(progress.streakOf(mia), 1);

      progress.select(leo);
      expect(progress.starsFor('sheet1'), isNull);
      await progress.complete('sheet1', 2);
      expect(progress.starsOf(leo), 2);

      // Replaying only adds the improvement.
      await progress.complete('sheet1', 3);
      expect(progress.starsOf(leo), 3);

      await progress.saveProfile(
        leo.copyWith(name: 'Leo J', level: Level.grade3),
      );
      expect(
        progress.profiles.firstWhere((p) => p.id == 'leo').level,
        Level.grade3,
      );

      await progress.deleteProfile(mia);
      expect(progress.profiles.map((p) => p.name), ['Leo J']);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getKeys().where((k) => k.startsWith('mia_')), isEmpty);
    },
  );

  test(
    'profiles survive an app restart; a single learner is auto-selected',
    () async {
      final first = await Progress.load();
      await first.saveProfile(_kid('ava', 'Ava'));
      final reopened = await Progress.load();
      expect(reopened.profiles.single.name, 'Ava');
      expect(reopened.active?.id, 'ava');
    },
  );

  test('profiles saved by the older age-group version map onto levels', () {
    final p = Profile.fromJson({
      'id': 'x',
      'name': 'Old',
      'avatar': '🐼',
      'color': 1,
      'age': 'school',
    });
    expect(p.level, Level.grade1);
    expect(Profile.fromJson(p.toJson()).level, Level.grade1);
  });

  test(
    'difficulty adapts: two perfect sheets → harder, two tough ones → easier',
    () async {
      final progress = await Progress.load();
      await progress.saveProfile(_kid('zoe', 'Zoe'), makeActive: true); // Pre-K
      expect(progress.levelFor(WorksheetKind.counting), Level.preK);

      expect(await progress.complete('a', 3, category: Category.math), 0);
      expect(await progress.complete('b', 3, category: Category.math), 1);
      expect(progress.levelFor(WorksheetKind.counting), Level.kindergarten);
      // Other subjects are unaffected.
      expect(progress.levelFor(WorksheetKind.letters), Level.preK);

      expect(await progress.complete('c', 1, category: Category.math), 0);
      expect(await progress.complete('d', 1, category: Category.math), -1);
      expect(progress.levelFor(WorksheetKind.counting), Level.preK);

      // Never more than two levels away, and never outside a worksheet's range.
      for (var i = 0; i < 10; i++) {
        await progress.complete('e$i', 1, category: Category.math);
      }
      expect(progress.adjustment(progress.active!, Category.math), -2);
      // Counting and addition start at Pre-K (toddlers have their own set).
      expect(progress.levelFor(WorksheetKind.counting), Level.preK);
      expect(progress.levelFor(WorksheetKind.addition), Level.preK);

      // Changing the grade resets adaptation.
      await progress.saveProfile(
        progress.active!.copyWith(level: Level.grade2),
      );
      expect(progress.adjustment(progress.active!, Category.math), 0);
    },
  );
}
