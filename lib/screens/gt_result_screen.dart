import 'package:flutter/material.dart';

import '../models/models.dart';
import '../services/speaker.dart';
import '../theme.dart';
import '../widgets/backgrounds.dart';
import '../widgets/bubbly_button.dart';
import '../widgets/pic.dart';

/// The weekly GT test's score: overall, and for each of its three parts.
class GtResultScreen extends StatefulWidget {
  const GtResultScreen({
    super.key,
    required this.worksheet,
    required this.parts,
    required this.minutes,
  });
  final Worksheet worksheet;

  /// (part name, right, questions)
  final List<(String, int, int)> parts;
  final int minutes;

  @override
  State<GtResultScreen> createState() => _GtResultScreenState();
}

class _GtResultScreenState extends State<GtResultScreen> {
  int get right => widget.parts.fold(0, (a, p) => a + p.$2);
  int get total => widget.parts.fold(0, (a, p) => a + p.$3);
  double get pct => total == 0 ? 0 : right / total;

  String get _title => pct >= .9
      ? 'Brilliant thinking!'
      : pct >= .7
      ? 'Great thinking!'
      : pct >= .5
      ? 'Good work!'
      : 'You finished the test!';

  /// The part with the lowest score — what to practise this week.
  (String, int, int)? get _practise {
    final sorted = [...widget.parts]
      ..sort((a, b) => (a.$2 / a.$3).compareTo(b.$2 / b.$3));
    final p = sorted.first;
    return p.$2 < p.$3 ? p : null;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => Speaker.instance.say([
        _title,
        'You got $right out of $total.',
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final practise = _practise;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: BubblesBackground(tint: widget.worksheet.color),
          ),
          if (pct >= .7) const Positioned.fill(child: Confetti()),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const PopIn(
                        child: PicLabel('🏆', style: TextStyle(fontSize: 96)),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _title,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$right out of $total right  ·  ${(pct * 100).round()}%',
                        style: Theme.of(context).textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.minutes} minute${widget.minutes == 1 ? '' : 's'}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Column(
                          children: [
                            for (final (i, (name, r, n))
                                in widget.parts.indexed) ...[
                              if (i > 0) const SizedBox(height: 16),
                              _PartBar(
                                name: name,
                                right: r,
                                total: n,
                                color: [
                                  AppColors.bubblegum,
                                  AppColors.sky,
                                  AppColors.grape,
                                ][i % 3],
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (practise != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.lighter(AppColors.sunshine, .6),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: PicLabel(
                            '💡 To practise this week: ${practise.$1}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 28),
                      BubblyButton(
                        color: AppColors.grape,
                        onTap: () => Navigator.of(context).pop(),
                        child: const PicLabel(
                          '🏠  Back home',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PartBar extends StatelessWidget {
  const _PartBar({
    required this.name,
    required this.right,
    required this.total,
    required this.color,
  });
  final String name;
  final int right;
  final int total;
  final Color color;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ),
          Text(
            '$right / $total',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.darker(color, .2),
            ),
          ),
        ],
      ),
      const SizedBox(height: 6),
      ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: LinearProgressIndicator(
          value: total == 0 ? 0 : right / total,
          minHeight: 16,
          backgroundColor: AppColors.lighter(color, .85),
          color: color,
        ),
      ),
    ],
  );
}
