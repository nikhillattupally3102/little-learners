import 'dart:math';

import 'package:flutter/material.dart';

import '../models/models.dart';
import '../models/result.dart';
import '../state/progress.dart';
import '../state/report.dart';
import '../theme.dart';
import '../widgets/backgrounds.dart';
import '../widgets/pic.dart';
import '../widgets/shape_icon.dart';
import 'account_screen.dart';

/// Grown-ups' progress report: activity, subjects, strengths and recent work.
class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String? _childId;

  @override
  Widget build(BuildContext context) {
    final progress = ProgressScope.of(context);
    final children = progress.profiles;
    final child =
        children.where((p) => p.id == _childId).firstOrNull ??
        progress.active ??
        children.firstOrNull;
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: BubblesBackground()),
          SafeArea(
            child: Column(
              children: [
                _TopBar(progress: progress),
                if (children.length > 1)
                  SizedBox(
                    height: 64,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        for (final p in children)
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: ChoiceChip(
                              avatar: Pic(p.avatar, size: 18),
                              label: Text(
                                p.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              selected: p.id == child?.id,
                              selectedColor: AppColors.lighter(p.color, .55),
                              onSelected: (_) =>
                                  setState(() => _childId = p.id),
                            ),
                          ),
                      ],
                    ),
                  ),
                Expanded(
                  child: child == null
                      ? const Center(child: Text('No learners yet.'))
                      : _Report(child: child, progress: progress),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.progress});
  final Progress progress;

  @override
  Widget build(BuildContext context) {
    final cloud = !progress.cloudConfigured
        ? 'This device only'
        : progress.signedIn
        ? (progress.syncing ? 'Syncing…' : 'Synced to ${progress.accountEmail}')
        : 'Not signed in — saved on this device';
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 20, 4),
      child: Row(
        children: [
          IconButton(
            iconSize: 30,
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              'Progress report',
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          TextButton.icon(
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const AccountScreen())),
            icon: Icon(
              progress.signedIn
                  ? Icons.cloud_done_rounded
                  : Icons.cloud_off_rounded,
            ),
            label: Text(cloud, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}

class _Report extends StatelessWidget {
  const _Report({required this.child, required this.progress});
  final Profile child;
  final Progress progress;

  @override
  Widget build(BuildContext context) {
    final results = progress.resultsOf(child);
    final report = ChildReport(results);
    final avg = report.averageStars;
    return LayoutBuilder(
      builder: (context, c) {
        final wide = c.maxWidth >= 820;
        final left = <Widget>[
          _Card(
            title: 'Overview',
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _Stat('${report.worksheets}', 'worksheets', AppColors.sky),
                _Stat(
                  '${progress.starsOf(child)}',
                  'stars',
                  AppColors.sunshine,
                ),
                _Stat(
                  '${progress.streakOf(child)}',
                  'day streak',
                  AppColors.tangerine,
                ),
                _Stat('${report.thisWeek}', 'this week', AppColors.mint),
                _Stat('${report.minutes}', 'minutes', AppColors.grape),
                _Stat(
                  avg == null ? '–' : avg.toStringAsFixed(1),
                  'avg stars',
                  AppColors.bubblegum,
                ),
              ],
            ),
          ),
          _Card(title: 'Last 14 days', child: _ActivityBars(report.activity())),
          _Card(
            title: 'Subjects',
            child: Column(
              children: [
                for (final s in report.subjects())
                  _SubjectRow(
                    stats: s,
                    level:
                        Level.values[(child.level.index +
                                progress.adjustment(child, s.category))
                            .clamp(0, Level.values.length - 1)],
                    base: child.level,
                  ),
              ],
            ),
          ),
        ];
        final right = <Widget>[
          _Card(
            title: 'Needs practice',
            child: _KindList(
              report.needsPractice,
              empty: 'Nothing yet — keep going!',
            ),
          ),
          _Card(
            title: 'Strengths',
            child: _KindList(
              report.strengths,
              empty: 'Finish a few more worksheets to see strengths.',
            ),
          ),
          _Card(
            title: 'Recent worksheets',
            child: results.isEmpty
                ? const Text('No worksheets finished yet.')
                : Column(
                    children: [for (final r in results.take(15)) _ResultRow(r)],
                  ),
          ),
        ];
        if (!wide) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [...left, ...right],
          );
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Column(children: left)),
              const SizedBox(width: 20),
              Expanded(child: Column(children: right)),
            ],
          ),
        );
      },
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 18),
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      boxShadow: const [
        BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 4)),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        child,
      ],
    ),
  );
}

class _Stat extends StatelessWidget {
  const _Stat(this.value, this.label, this.color);
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: 120,
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
    decoration: BoxDecoration(
      color: AppColors.lighter(color, .78),
      borderRadius: BorderRadius.circular(18),
    ),
    child: Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.darker(color, .35),
          ),
        ),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    ),
  );
}

class _ActivityBars extends StatelessWidget {
  const _ActivityBars(this.counts);
  final List<int> counts;

  @override
  Widget build(BuildContext context) {
    final top = max(1, counts.reduce(max));
    final today = DateTime.now();
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return SizedBox(
      height: 130,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < counts.length; i++)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (counts[i] > 0)
                      Text(
                        '${counts[i]}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    Container(
                      height: 4 + 80 * counts[i] / top,
                      decoration: BoxDecoration(
                        color: counts[i] == 0
                            ? const Color(0xFFE9E6EF)
                            : AppColors.sky,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      days[today
                              .subtract(Duration(days: counts.length - 1 - i))
                              .weekday -
                          1],
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SubjectRow extends StatelessWidget {
  const _SubjectRow({
    required this.stats,
    required this.level,
    required this.base,
  });
  final SubjectStats stats;
  final Level level;
  final Level base;

  @override
  Widget build(BuildContext context) {
    final avg = stats.averageStars;
    final acc = stats.accuracy;
    final pitch = level == base
        ? level.short
        : '${level.short} ${level.index > base.index ? '⬆️' : '⬇️'}';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.lighter(stats.category.color, .7),
              shape: BoxShape.circle,
            ),
            child: Pic(stats.category.emoji, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stats.category.title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  stats.count == 0
                      ? 'Not started'
                      : '${stats.count} done · '
                            '${avg!.toStringAsFixed(1)} ★ avg'
                            '${acc == null ? '' : ' · ${(acc * 100).round()}% right first time'}',
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
          PicLabel(
            pitch,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _KindList extends StatelessWidget {
  const _KindList(this.kinds, {required this.empty});
  final List<KindStats> kinds;
  final String empty;

  @override
  Widget build(BuildContext context) {
    if (kinds.isEmpty) {
      return Text(empty, style: const TextStyle(color: Colors.black54));
    }
    return Column(
      children: [
        for (final k in kinds)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                Pic(k.kind?.emoji ?? '📄', size: 26),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    k.kind?.title ?? k.kindName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  '${k.averageStars.toStringAsFixed(1)} ★ · ${k.results.length} tries',
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow(this.r);
  final WorksheetResult r;

  @override
  Widget build(BuildContext context) {
    final kind = WorksheetKind.values.asNameMap()[r.kind];
    final level = Level.values.asNameMap()[r.level];
    final d = r.completedAt;
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final time = r.seconds == 0
        ? ''
        : ' · ${r.seconds >= 60 ? '${r.seconds ~/ 60} min' : '${r.seconds} s'}';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Pic(kind?.emoji ?? '🎓', size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  kind == WorksheetKind.topicQuiz
                      ? 'Learning quiz'
                      : r.kind == 'learn'
                      ? 'Learning session'
                      : kind?.title ?? r.kind,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${d.day} ${months[d.month - 1]} · ${level?.short ?? r.level}'
                  ' · ${r.mistakes} mistake${r.mistakes == 1 ? '' : 's'}$time',
                  style: const TextStyle(color: Colors.black54, fontSize: 13),
                ),
              ],
            ),
          ),
          for (var i = 0; i < 3; i++)
            ShapeIcon(
              ShapeKind.star,
              i < r.stars ? AppColors.sunshine : const Color(0xFFE3E0EA),
              size: 20,
            ),
        ],
      ),
    );
  }
}
