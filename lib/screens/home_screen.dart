import 'dart:math';

import 'package:flutter/material.dart';

import '../widgets/pic.dart';

import '../models/generator.dart';
import '../models/models.dart';
import '../state/progress.dart';
import '../theme.dart';
import '../widgets/backgrounds.dart';
import '../widgets/bubbly_button.dart';
import '../widgets/shape_icon.dart';
import '../content/topics.dart';
import '../generators/learn_more.dart';
import '../generators/topic_sheets.dart';
import 'learn_screen.dart';
import 'rewards_screen.dart';
import 'worksheet_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = ProgressScope.of(context);
    final profile = progress.active!;
    final level = profile.level;
    final today = DateTime.now();
    final avoid = progress.recentlySeen(now: today);
    final worksheets = WorksheetGenerator.forDay(
      today,
      level,
      levelFor: progress.levelFor,
      avoid: avoid,
    );
    final learnTopics = topicsForDay(today, level);
    final done =
        worksheets.where((w) => progress.starsFor(w.id) != null).length +
        learnTopics
            .where((t) => progress.starsFor(topicQuizId(today, t)) != null)
            .length;
    final total = worksheets.length + learnTopics.length;
    final allDone = done == total;
    final bonus = allDone
        ? WorksheetGenerator.bonusForDay(
            today,
            level,
            levelFor: progress.levelFor,
            avoid: avoid,
          )
        : const <Worksheet>[];

    // Today's plan: the learning session first, then the worksheets, then
    // (once everything is done) a few bonus worksheets.
    final tiles = <Widget>[
      for (final topic in learnTopics)
        _PlanCard(
          color: topic.color,
          emoji: topic.emoji,
          title: topic.title,
          subtitle: level.atMost(Level.age3)
              ? '🎓 Look, learn & play'
              : '🎓 Learn & quiz',
          footer: '${topic.items.length} things to learn  ▶',
          stars: progress.starsFor(topicQuizId(today, topic)),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => LearnScreen(topic: topic, level: level),
            ),
          ),
        ),
      for (final ws in worksheets)
        _WorksheetCard(ws, progress.starsFor(ws.id), base: level),
      for (final ws in bonus)
        _WorksheetCard(ws, progress.starsFor(ws.id), base: level, bonus: true),
    ];

    // Learning sessions to open any time, chosen for the child's age.
    final moreTiles = <Widget>[
      for (final more in learnMoreFor(level, today))
        _PlanCard(
          color: more.topic.color,
          emoji: more.topic.emoji,
          title: more.topic.title,
          subtitle: level.atMost(Level.age3)
              ? '🎓 Look, learn & play'
              : '🎓 Learn & quiz',
          footer: '${more.topic.items.length} things to learn  ▶',
          stars: progress.starsFor(learnMoreQuizId(today, more.topic)),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) =>
                  LearnScreen(topic: more.topic, level: level, more: more),
            ),
          ),
        ),
    ];

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: BubblesBackground()),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _Header(profile: profile, progress: progress),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Today's Plan",
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        _Pill('$done / $total done', AppColors.mint),
                      ],
                    ),
                  ),
                ),
                if (level.kinds.contains(WorksheetKind.gtTest) &&
                    !WorksheetGenerator.isGtDay(today))
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
                      child: PicLabel(
                        _nextGtTest(today),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.ink.withValues(alpha: .7),
                        ),
                      ),
                    ),
                  ),
                if (allDone) const SliverToBoxAdapter(child: _AllDoneBanner()),
                _grid(tiles, bottom: 12),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Learn more 📚',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Look at the cards any time, then play!',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.ink.withValues(alpha: .7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _grid(moreTiles, bottom: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// "🏆 Weekly GT test: this Sunday" (or tomorrow).
String _nextGtTest(DateTime today) {
  final days = (DateTime.sunday - today.weekday) % 7;
  return days == 1
      ? '🏆 Weekly GT test: tomorrow!'
      : '🏆 Weekly GT test: this Sunday (in $days days)';
}

/// A grid of plan cards that pop in one after another.
Widget _grid(List<Widget> tiles, {required double bottom}) => SliverPadding(
  padding: EdgeInsets.fromLTRB(20, 8, 20, bottom),
  sliver: SliverGrid(
    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
      maxCrossAxisExtent: 240,
      mainAxisSpacing: 18,
      crossAxisSpacing: 18,
      childAspectRatio: .86,
    ),
    delegate: SliverChildBuilderDelegate(
      childCount: tiles.length,
      (context, i) => PopIn(
        delay: Duration(milliseconds: 60 * min(i, 8)),
        child: tiles[i],
      ),
    ),
  ),
);

class _Header extends StatelessWidget {
  const _Header({required this.profile, required this.progress});
  final Profile profile;
  final Progress progress;

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good morning'
        : hour < 17
        ? 'Good afternoon'
        : 'Good evening';
    final sun = hour < 17 ? '🌞' : '🌙';
    final multiple = progress.profiles.length > 1;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => progress.select(null),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 68,
                      height: 68,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: profile.color,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.darker(profile.color),
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: PicLabel(
                        profile.avatar,
                        style: const TextStyle(fontSize: 40),
                      ),
                    ),
                    const Positioned(
                      right: -4,
                      bottom: -4,
                      child: CircleAvatar(
                        radius: 13,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.swap_horiz_rounded,
                          size: 18,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$greeting, ${profile.name}! $sun',
                      style: Theme.of(context).textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      multiple
                          ? 'Tap your buddy to switch learner'
                          : "Ready for today's fun?",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              BubblyButton(
                color: Colors.white,
                shadowColor: Colors.black12,
                radius: 20,
                padding: const EdgeInsets.all(10),
                onTap: () => progress.soundOn = !progress.soundOn,
                child: Icon(
                  progress.soundOn
                      ? Icons.volume_up_rounded
                      : Icons.volume_off_rounded,
                  size: 28,
                  color: progress.soundOn
                      ? AppColors.sky
                      : AppColors.ink.withValues(alpha: .4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _Pill('⭐ ${progress.starsOf(profile)} stars', AppColors.sunshine),
              if (progress.rewardsOf(profile).enabled)
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const RewardsScreen()),
                  ),
                  child: _Pill(
                    '🎁 Rewards · ⭐ ${progress.walletOf(profile)} to spend',
                    AppColors.grape,
                  ),
                ),
              _Pill(
                '🔥 ${progress.streakOf(profile)} day streak',
                AppColors.tangerine,
              ),
              _Pill(
                '${profile.level.emoji} ${profile.level.title}',
                profile.color,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill(this.text, this.color);
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    decoration: BoxDecoration(
      color: AppColors.lighter(color, .7),
      borderRadius: BorderRadius.circular(40),
      border: Border.all(color: color, width: 2),
    ),
    child: PicLabel(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
  );
}

class _WorksheetCard extends StatelessWidget {
  const _WorksheetCard(
    this.worksheet,
    this.stars, {
    required this.base,
    this.bonus = false,
  });
  final Worksheet worksheet;
  final int? stars;
  final bool bonus;

  /// The child's grade; a badge shows when this worksheet is pitched above or below it.
  final Level base;

  String? get _adapted {
    final l = worksheet.level;
    if (l == null || l == base) return null;
    return l.index > base.index ? '⬆️ ${l.short}' : '⬇️ ${l.short}';
  }

  @override
  Widget build(BuildContext context) {
    final kind = worksheet.kind;
    // Worked examples ("Let's learn!") aren't puzzles.
    final puzzles = worksheet.questions
        .where((q) => q is! ExampleQuestion)
        .length;
    return _PlanCard(
      color: worksheet.color,
      emoji: worksheet.emoji,
      title: worksheet.title,
      // Toddlers play games; "Puzzles" or "Math" means nothing to them.
      subtitle: kind == WorksheetKind.gtTest
          ? '🧠 Words · numbers · shapes'
          : kind == WorksheetKind.tReview
          ? "🔁 Yesterday's things"
          : base.atMost(Level.age3)
          ? '🎈 Play'
          : '${kind.category.emoji} ${kind.category.title}',
      footer: kind == WorksheetKind.gtTest
          ? '$puzzles questions · one try each  ▶'
          : '$puzzles ${base.atMost(Level.age3) ? 'quick games' : 'puzzles'}${_adapted == null ? '' : '  ·  $_adapted'}  ▶',
      stars: stars,
      ribbon: bonus
          ? 'BONUS'
          : kind == WorksheetKind.gtTest
          ? 'SUNDAY'
          : null,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => WorksheetScreen(worksheet: worksheet),
        ),
      ),
    );
  }
}

/// A tile on today's plan: a worksheet or the learning session.
class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.color,
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.footer,
    required this.stars,
    required this.onTap,
    this.ribbon,
  });
  final Color color;
  final String emoji;
  final String title;
  final String subtitle;
  final String footer;
  final int? stars;
  final String? ribbon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => BubblyButton(
    color: color,
    radius: 30,
    depth: 8,
    padding: const EdgeInsets.all(14),
    onTap: onTap,
    child: Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Center(
                child: Container(
                  width: 92,
                  height: 92,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Pic(emoji, size: 54),
                ),
              ),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            Center(
              child: PicLabel(
                subtitle,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: .9),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: stars == null
                  ? FittedBox(
                      fit: BoxFit.scaleDown,
                      child: PicLabel(
                        footer,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (var i = 0; i < 3; i++)
                          ShapeIcon(
                            ShapeKind.star,
                            i < stars!
                                ? AppColors.sunshine
                                : Colors.white.withValues(alpha: .5),
                            size: 26,
                          ),
                      ],
                    ),
            ),
          ],
        ),
        if (stars != null)
          const Positioned(
            left: 0,
            top: 0,
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white,
              child: Icon(Icons.check_rounded, color: AppColors.mint, size: 24),
            ),
          ),
        if (ribbon != null)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.sunshine,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                ribbon!,
                style: const TextStyle(
                  color: AppColors.ink,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
      ],
    ),
  );
}

class _AllDoneBanner extends StatelessWidget {
  const _AllDoneBanner();

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.fromLTRB(20, 8, 20, 4),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [AppColors.grape, AppColors.bubblegum],
      ),
      borderRadius: BorderRadius.circular(24),
    ),
    child: const Row(
      children: [
        PicLabel('🏆', style: TextStyle(fontSize: 40)),
        SizedBox(width: 12),
        Expanded(
          child: PicLabel(
            'All done for today! Try a bonus worksheet, or come back tomorrow 🌙',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}
