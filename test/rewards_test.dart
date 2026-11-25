import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:little_learners/models/models.dart';
import 'package:little_learners/models/rewards.dart';
import 'package:little_learners/screens/rewards_screen.dart';
import 'package:little_learners/state/progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _mia = Profile(
  id: 'mia',
  name: 'Mia',
  avatar: '🦊',
  colorIndex: 0,
  level: Level.kindergarten,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<Progress> withStars(int sheets) async {
    SharedPreferences.setMockInitialValues({});
    final p = await Progress.load();
    await p.saveProfile(_mia, makeActive: true);
    await p.setRewardsEnabled(_mia, true);
    for (var i = 0; i < sheets; i++) {
      await p.complete('2026112${i}_counting', 3);
    }
    return p;
  }

  test('stickers cost stars from the wallet, not from earned stars', () async {
    final p = await withStars(4); // 12 stars
    expect(p.walletOf(_mia), 12);
    final album = Sticker.album;
    final a = album.first.$2[0], b = album.first.$2[1], c = album.first.$2[2];
    expect(await p.buySticker(_mia, a), isTrue);
    expect(await p.buySticker(_mia, a), isFalse, reason: 'already owned');
    expect(await p.buySticker(_mia, b), isTrue);
    expect(p.walletOf(_mia), 2);
    expect(await p.buySticker(_mia, c), isFalse, reason: 'not enough stars');
    expect(p.starsOf(_mia), 12, reason: 'earned stars are not reduced');
    expect(p.rewardsOf(_mia).stickers, [a.id, b.id]);
  });

  test('goals are claimed by a grown-up and can repeat', () async {
    final p = await withStars(5); // 15 stars
    const goal = RewardGoal(id: 'g1', title: 'Park', emoji: '🌳', cost: 10);
    await p.saveGoal(_mia, goal);
    expect(await p.claimGoal(_mia, goal), isTrue);
    expect(p.walletOf(_mia), 5);
    expect(await p.claimGoal(_mia, goal), isFalse);
    expect(p.rewardsOf(_mia).goals.single.claimed, 1);
    await p.deleteGoal(_mia, goal);
    expect(p.rewardsOf(_mia).goals, isEmpty);
  });

  test('grown-ups can switch rewards off; nothing can be bought', () async {
    final p = await withStars(3);
    await p.setRewardsEnabled(_mia, false);
    expect(p.rewardsOf(_mia).enabled, isFalse);
    expect(await p.buySticker(_mia, Sticker.album.first.$2.first), isFalse);
    // Survives a restart.
    final again = await Progress.load();
    expect(again.rewardsOf(_mia).enabled, isFalse);
  });

  test('rewards start switched off until a grown-up turns them on', () async {
    SharedPreferences.setMockInitialValues({});
    final p = await Progress.load();
    await p.saveProfile(_mia, makeActive: true);
    await p.complete('20261120_counting', 3);
    expect(p.rewardsOf(_mia).enabled, isFalse);
    expect(await p.buySticker(_mia, Sticker.album.first.$2.first), isFalse);
  });

  test('every sticker has a unique id', () {
    final ids = [for (final (_, s) in Sticker.album) ...s.map((x) => x.id)];
    expect(ids.toSet().length, ids.length);
    expect(ids.length, Sticker.total);
  });

  testWidgets('sticker book opens and buys after confirming', (tester) async {
    late Progress p;
    await tester.runAsync(() async => p = await withStars(2));
    tester.view.physicalSize = const Size(1180, 820);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProgressScope(
        notifier: p,
        child: const MaterialApp(home: RewardsScreen()),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));
    final card = find.byWidgetPredicate(
      (w) => w.runtimeType.toString() == '_StickerCard',
    );
    expect(card, findsWidgets);
    await tester.tap(card.first);
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Yes, get it!'), findsOneWidget);
    await tester.runAsync(() async {
      await tester.tap(find.text('Yes, get it!'));
      await tester.pump();
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pump(const Duration(milliseconds: 400));
    expect(p.rewardsOf(_mia).stickers, [Sticker.album.first.$2.first.id]);
    expect(p.walletOf(_mia), 1);
    expect(tester.takeException(), isNull);
  });
}
