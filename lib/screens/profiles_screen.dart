import 'dart:math';

import 'package:flutter/material.dart';

import '../widgets/pic.dart';

import '../models/models.dart';
import '../state/progress.dart';
import '../theme.dart';
import '../widgets/backgrounds.dart';
import '../widgets/bubbly_button.dart';
import '../widgets/fit_grid.dart';
import '../widgets/parent_gate.dart';
import 'account_screen.dart';
import 'feedback_screen.dart';
import 'report_screen.dart';
import 'rewards_settings_screen.dart';
import 'profile_editor_screen.dart';

/// "Who's learning today?" — pick a child. Grown-ups can add, edit and delete.
class ProfilesScreen extends StatefulWidget {
  const ProfilesScreen({super.key});

  @override
  State<ProfilesScreen> createState() => _ProfilesScreenState();
}

class _ProfilesScreenState extends State<ProfilesScreen> {
  bool _manage = false;

  Future<void> _toggleManage() async {
    if (_manage) return setState(() => _manage = false);
    if (await showParentGate(context)) setState(() => _manage = true);
  }

  void _edit([Profile? p]) => Navigator.of(context)
      .push(MaterialPageRoute(builder: (_) => ProfileEditorScreen(profile: p)));

  @override
  Widget build(BuildContext context) {
    final progress = ProgressScope.of(context);
    final profiles = progress.profiles;
    final cards = profiles.length + (_manage ? 1 : 0);
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: BubblesBackground()),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, c) {
                final compact = c.maxHeight < 640;
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: c.maxWidth < 400 ? 12 : 24,
                    vertical: compact ? 8 : 20,
                  ),
                  child: Column(
                    children: [
                      PopIn(
                        child: PicLabel(
                          '🦉',
                          style: TextStyle(
                            fontSize: (c.maxHeight * .09).clamp(40.0, 80.0),
                          ),
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          _manage ? 'Manage learners' : "Who's learning today?",
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      if (_manage)
                        const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(
                            'Tap a learner to edit or delete',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      SizedBox(height: compact ? 10 : 20),
                      Expanded(
                        child: FitGrid(
                          count: cards,
                          aspect: .82,
                          gap: compact ? 12 : 18,
                          maxCell: 260,
                          builder: (context, i, size) => i == profiles.length
                              ? _AddCard(onTap: _edit)
                              : PopIn(
                                  delay: Duration(milliseconds: 80 * i),
                                  child: _ProfileCard(
                                    profile: profiles[i],
                                    stars: progress.starsOf(profiles[i]),
                                    streak: progress.streakOf(profiles[i]),
                                    editing: _manage,
                                    size: size,
                                    onTap: () => _manage
                                        ? _edit(profiles[i])
                                        : progress.select(profiles[i]),
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: compact ? 10 : 20),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 12,
                        runSpacing: 10,
                        children: [
                          if (_manage) ...[
                            BubblyButton(
                              color: AppColors.sky,
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const ReportScreen(),
                                ),
                              ),
                              child: const PicLabel(
                                '📊  Progress',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            BubblyButton(
                              color: AppColors.bubblegum,
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const RewardsSettingsScreen(),
                                ),
                              ),
                              child: const PicLabel(
                                '🎁  Rewards',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            BubblyButton(
                              color: AppColors.tangerine,
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const FeedbackScreen(),
                                ),
                              ),
                              child: const PicLabel(
                                '💬  Feedback',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            BubblyButton(
                              color: AppColors.grape,
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const AccountScreen(),
                                ),
                              ),
                              child: PicLabel(
                                progress.signedIn
                                    ? '☁️  Account'
                                    : '☁️  Back up & sync',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                          BubblyButton(
                            color: _manage ? AppColors.mint : Colors.white,
                            shadowColor: _manage ? null : Colors.black12,
                            onTap: _toggleManage,
                            child: PicLabel(
                              _manage ? '✅  Done' : '👪  Grown-ups',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: _manage ? Colors.white : AppColors.ink,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.profile,
    required this.stars,
    required this.streak,
    required this.editing,
    required this.size,
    required this.onTap,
  });
  final Profile profile;
  final int stars;
  final int streak;
  final bool editing;
  final Size size;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => BubblyButton(
    color: profile.color,
    radius: 30,
    depth: 8,
    padding: const EdgeInsets.all(12),
    onTap: onTap,
    child: Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Center(
                child: Container(
                  width: size.width * .56,
                  height: size.width * .56,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: PicLabel(
                    profile.avatar,
                    style: TextStyle(fontSize: size.width * .33),
                  ),
                ),
              ),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                profile.name,
                style: TextStyle(
                  fontSize: max(16, size.width * .14),
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 2),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: PicLabel(
                '${profile.level.emoji} ${profile.level.short}   ⭐ $stars   🔥 $streak',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        if (editing)
          const Positioned(
            right: 0,
            top: 0,
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: Icon(Icons.edit_rounded, color: AppColors.ink, size: 20),
            ),
          ),
      ],
    ),
  );
}

class _AddCard extends StatelessWidget {
  const _AddCard({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => BubblyButton(
    color: Colors.white,
    shadowColor: Colors.black12,
    radius: 30,
    depth: 8,
    onTap: onTap,
    child: const Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_circle_rounded, size: 64, color: AppColors.grape),
            SizedBox(height: 8),
            Text(
              'Add learner',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    ),
  );
}
