import 'package:flutter/material.dart';

import '../models/models.dart';
import '../models/rewards.dart';
import '../state/progress.dart';
import '../theme.dart';
import '../widgets/backgrounds.dart';
import '../widgets/pic.dart';

/// Grown-ups: switch rewards on/off per child and set real-life goals.
class RewardsSettingsScreen extends StatelessWidget {
  const RewardsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = ProgressScope.of(context);
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
                      Text(
                        'Rewards',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: Text(
                          'Children earn stars on worksheets. With rewards on, '
                          'they can spend stars on stickers, and on real-life '
                          'goals you set here — you confirm each goal before '
                          'stars are used.',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      for (final p in progress.profiles)
                        _ChildRewards(child: p, progress: progress),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChildRewards extends StatelessWidget {
  const _ChildRewards({required this.child, required this.progress});
  final Profile child;
  final Progress progress;

  @override
  Widget build(BuildContext context) {
    final r = progress.rewardsOf(child);
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: AppColors.lighter(child.color, .6),
                child: Pic(child.avatar, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  child.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Text('Rewards', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Switch(
                value: r.enabled,
                onChanged: (v) => progress.setRewardsEnabled(child, v),
              ),
            ],
          ),
          if (r.enabled) ...[
            const SizedBox(height: 8),
            PicLabel(
              '⭐ ${progress.walletOf(child)} to spend · '
              '${progress.starsOf(child)} earned · ${r.spent} spent · '
              '${r.stickers.length}/${Sticker.total} stickers',
              style: const TextStyle(color: Colors.black54, fontSize: 15),
            ),
            const SizedBox(height: 14),
            const Text(
              'Goals',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            if (r.goals.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  'No goals yet. Add one your child can work towards.',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            for (final g in r.goals)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Pic(g.emoji, size: 30),
                title: Text(
                  g.title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  '${g.cost} stars'
                  '${g.claimed > 0 ? ' · given ${g.claimed}×' : ''}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_rounded),
                      onPressed: () => _editGoal(context, g),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded),
                      onPressed: () => progress.deleteGoal(child, g),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 6),
            OutlinedButton.icon(
              onPressed: () => _editGoal(context, null),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add a goal'),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _editGoal(BuildContext context, RewardGoal? goal) async {
    final result = await showDialog<RewardGoal>(
      context: context,
      builder: (_) => _GoalDialog(goal: goal),
    );
    if (result != null) await progress.saveGoal(child, result);
  }
}

class _GoalDialog extends StatefulWidget {
  const _GoalDialog({this.goal});
  final RewardGoal? goal;

  @override
  State<_GoalDialog> createState() => _GoalDialogState();
}

class _GoalDialogState extends State<_GoalDialog> {
  late final _title = TextEditingController(text: widget.goal?.title ?? '');
  late String _emoji = widget.goal?.emoji ?? '🎁';
  late double _cost = (widget.goal?.cost ?? 30).toDouble();

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.goal == null ? 'New goal' : 'Edit goal'),
    content: SizedBox(
      width: 460,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Ideas:'),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final (e, t) in goalIdeas)
                  ActionChip(
                    avatar: Pic(e, size: 16),
                    label: Text(t),
                    onPressed: () => setState(() {
                      _emoji = e;
                      _title.text = t;
                    }),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _title,
              maxLength: 40,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: 'Reward',
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Pic(_emoji, size: 20),
                ),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Stars needed: ${_cost.round()}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Slider(
              value: _cost,
              min: 5,
              max: 200,
              divisions: 39,
              label: '${_cost.round()}',
              onChanged: (v) => setState(() => _cost = v),
            ),
            const Text(
              'A child earns about 10–20 stars on a full day of worksheets.',
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Cancel'),
      ),
      FilledButton(
        onPressed: _title.text.trim().isEmpty
            ? null
            : () => Navigator.of(context).pop(
                (widget.goal ??
                        RewardGoal(
                          id: 'g${DateTime.now().microsecondsSinceEpoch}',
                          title: '',
                          emoji: _emoji,
                          cost: 0,
                        ))
                    .copyWith(
                      title: _title.text.trim(),
                      emoji: _emoji,
                      cost: _cost.round(),
                    ),
              ),
        child: const Text('Save'),
      ),
    ],
  );
}
