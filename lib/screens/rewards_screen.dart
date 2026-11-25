import 'package:flutter/material.dart';

import '../content/topics.dart';
import '../models/models.dart';
import '../models/rewards.dart';
import '../state/progress.dart';
import '../theme.dart';
import '../widgets/backgrounds.dart';
import '../widgets/bubbly_button.dart';
import '../widgets/fit_grid.dart';
import '../widgets/parent_gate.dart';
import '../widgets/pic.dart';

/// The child's rewards: spend stars on stickers, and see grown-up goals.
class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  int _page = 0;
  bool _goalsTab = false;

  @override
  Widget build(BuildContext context) {
    final progress = ProgressScope.of(context);
    final child = progress.active!;
    final rewards = progress.rewardsOf(child);
    final wallet = progress.walletOf(child);
    final album = Sticker.album;
    final hasGoals = rewards.goals.isNotEmpty;
    final showGoals = _goalsTab && hasGoals;
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: BubblesBackground()),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 20, 4),
                  child: Row(
                    children: [
                      IconButton(
                        iconSize: 30,
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back_rounded),
                      ),
                      Expanded(
                        child: Text(
                          'My rewards',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.lighter(AppColors.sunshine, .6),
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(
                            color: AppColors.sunshine,
                            width: 3,
                          ),
                        ),
                        child: PicLabel(
                          '⭐ $wallet',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (hasGoals)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: SegmentedButton<bool>(
                      segments: const [
                        ButtonSegment(
                          value: false,
                          label: Text('Sticker book'),
                        ),
                        ButtonSegment(value: true, label: Text('Goals')),
                      ],
                      selected: {showGoals},
                      onSelectionChanged: (v) =>
                          setState(() => _goalsTab = v.first),
                    ),
                  ),
                Expanded(
                  child: showGoals
                      ? _Goals(child: child, wallet: wallet, rewards: rewards)
                      : _album(
                          context,
                          progress,
                          child,
                          rewards,
                          wallet,
                          album,
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _album(
    BuildContext context,
    Progress progress,
    Profile child,
    Rewards rewards,
    int wallet,
    List<(Topic, List<Sticker>)> album,
  ) {
    final (topic, stickers) = album[_page.clamp(0, album.length - 1)];
    final owned = rewards.stickers.toSet();
    final have = stickers.where((s) => owned.contains(s.id)).length;
    return Column(
      children: [
        SizedBox(
          height: 66,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: album.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, i) {
              final (t, items) = album[i];
              final n = items.where((s) => owned.contains(s.id)).length;
              final selected = i == _page;
              return GestureDetector(
                onTap: () => setState(() => _page = i),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: selected ? t.color : Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: t.color, width: 3),
                  ),
                  alignment: Alignment.center,
                  child: PicLabel(
                    '${t.emoji} ${t.title}${n == items.length ? ' ✅' : '  $n/${items.length}'}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: selected ? Colors.white : AppColors.ink,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
          child: Text(
            have == stickers.length
                ? 'You collected every ${topic.title} sticker! 🎉'
                : 'Tap a sticker to get it for ${Sticker.cost} ⭐',
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: FitGrid(
              count: stickers.length,
              aspect: .9,
              gap: 14,
              maxCell: 200,
              builder: (context, i, size) {
                final s = stickers[i];
                final mine = owned.contains(s.id);
                return _StickerCard(
                  sticker: s,
                  owned: mine,
                  size: size,
                  affordable: wallet >= Sticker.cost,
                  onTap: mine ? null : () => _buy(context, progress, child, s),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _buy(
    BuildContext context,
    Progress progress,
    Profile child,
    Sticker s,
  ) async {
    final wallet = progress.walletOf(child);
    final enough = wallet >= Sticker.cost;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Pic(s.item.emoji, size: 110),
            const SizedBox(height: 8),
            Text(
              s.item.name,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            PicLabel(
              enough
                  ? 'Get this sticker for ${Sticker.cost} ⭐?'
                  : 'You need ${Sticker.cost - wallet} more ⭐.\n'
                        'Finish a worksheet to earn stars!',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              enough ? 'Not now' : 'OK',
              style: const TextStyle(fontSize: 18),
            ),
          ),
          if (enough)
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes, get it!', style: TextStyle(fontSize: 18)),
            ),
        ],
      ),
    );
    if (ok == true) await progress.buySticker(child, s);
  }
}

class _StickerCard extends StatelessWidget {
  const _StickerCard({
    required this.sticker,
    required this.owned,
    required this.size,
    required this.affordable,
    required this.onTap,
  });
  final Sticker sticker;
  final bool owned;
  final Size size;
  final bool affordable;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final pic = Pic(sticker.item.emoji, size: size.shortestSide * .42);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: owned ? Colors.white : const Color(0xFFF3F0F8),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: owned ? sticker.topic.color : const Color(0xFFDCD6E6),
            width: 3,
          ),
          boxShadow: owned
              ? [
                  BoxShadow(
                    color: sticker.topic.color.withValues(alpha: .35),
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            owned
                ? pic
                : Opacity(
                    opacity: .35,
                    child: ColorFiltered(
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF8E88A3),
                        BlendMode.srcIn,
                      ),
                      child: pic,
                    ),
                  ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: owned
                  ? Text(
                      sticker.item.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  : PicLabel(
                      '${Sticker.cost} ⭐',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: affordable ? AppColors.ink : Colors.black38,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Goals extends StatelessWidget {
  const _Goals({
    required this.child,
    required this.wallet,
    required this.rewards,
  });
  final Profile child;
  final int wallet;
  final Rewards rewards;

  Future<void> _ask(BuildContext context, RewardGoal g) async {
    final progress = ProgressScope.read(context);
    if (!await showParentGate(context) || !context.mounted) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Give "${g.title}"?'),
        content: Text(
          '${child.name} has $wallet stars. This uses ${g.cost} of them.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Not yet'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes, give it'),
          ),
        ],
      ),
    );
    if (ok == true && await progress.claimGoal(child, g) && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🎉 Enjoy your reward: ${g.title}!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
    children: [
      for (final g in rewards.goals)
        Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Pic(g.emoji, size: 52),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      g.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: (wallet / g.cost).clamp(0, 1),
                        minHeight: 16,
                        backgroundColor: const Color(0xFFEDE9F3),
                        color: AppColors.sunshine,
                      ),
                    ),
                    const SizedBox(height: 6),
                    PicLabel(
                      wallet >= g.cost
                          ? 'You have enough stars! ⭐'
                          : '${wallet.clamp(0, g.cost)} / ${g.cost} ⭐',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (wallet >= g.cost) ...[
                const SizedBox(width: 12),
                BubblyButton(
                  color: AppColors.mint,
                  onTap: () => _ask(context, g),
                  child: const PicLabel(
                    'Ask a grown-up 🙋',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
    ],
  );
}
