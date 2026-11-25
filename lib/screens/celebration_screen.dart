import 'package:flutter/material.dart';

import '../state/progress.dart';

import '../widgets/pic.dart';

import '../models/models.dart';
import '../theme.dart';
import '../widgets/backgrounds.dart';
import '../widgets/bubbly_button.dart';
import '../widgets/shape_icon.dart';
import 'worksheet_screen.dart';

class CelebrationScreen extends StatelessWidget {
  const CelebrationScreen({
    super.key,
    required this.worksheet,
    required this.stars,
    this.levelChange = 0,
  });
  final Worksheet worksheet;
  final int stars;

  /// +1 when the next worksheets get harder, -1 when they get easier.
  final int levelChange;

  @override
  Widget build(BuildContext context) {
    final title = switch (stars) {
      3 => 'Perfect!',
      2 => 'Amazing work!',
      _ => 'You did it!',
    };
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: BubblesBackground(tint: worksheet.color)),
          const Positioned.fill(child: Confetti()),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PopIn(
                      child: Container(
                        width: 190,
                        height: 190,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const RadialGradient(
                            colors: [Colors.white, Color(0xFFFFF1C2)],
                          ),
                          border: Border.all(
                            color: AppColors.sunshine,
                            width: 8,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x66FFC93C),
                              blurRadius: 40,
                              spreadRadius: 8,
                            ),
                          ],
                        ),
                        child: const ShapeIcon(
                          ShapeKind.star,
                          AppColors.sunshine,
                          size: 140,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    PopIn(
                      delay: const Duration(milliseconds: 200),
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'You finished ${worksheet.title}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (var i = 0; i < 3; i++)
                          PopIn(
                            delay: Duration(milliseconds: 500 + i * 300),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                              child: ShapeIcon(
                                ShapeKind.star,
                                i < stars
                                    ? AppColors.sunshine
                                    : const Color(0xFFD9D4E4),
                                size: i == 1 ? 84 : 64,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (levelChange != 0) ...[
                      const SizedBox(height: 20),
                      PopIn(
                        delay: const Duration(milliseconds: 1400),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: levelChange > 0
                                ? AppColors.lighter(AppColors.sunshine, .6)
                                : AppColors.lighter(AppColors.sky, .7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: PicLabel(
                            levelChange > 0
                                ? "🚀 You're on fire! Next time it gets a little harder."
                                : "💪 Great try! Next time we'll make it a bit easier.",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 28),
                    _Reaction(worksheet: worksheet, stars: stars),
                    const SizedBox(height: 28),
                    BubblyButton(
                      color: AppColors.grape,
                      onTap: () => Navigator.of(context).pop(),
                      child: const PicLabel(
                        '🏠  More worksheets',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    BubblyButton(
                      color: Colors.white,
                      shadowColor: Colors.black12,
                      onTap: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => WorksheetScreen(worksheet: worksheet),
                        ),
                      ),
                      child: const PicLabel(
                        '🔁  Play again',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// "How was this one?" — one tap, no typing. Tells us which worksheets
/// children enjoy, per grade, so the weakest ones get improved first.
class _Reaction extends StatefulWidget {
  const _Reaction({required this.worksheet, required this.stars});
  final Worksheet worksheet;
  final int stars;

  @override
  State<_Reaction> createState() => _ReactionState();
}

class _ReactionState extends State<_Reaction> {
  int? _picked;

  static const _faces = [(3, '😍'), (2, '🙂'), (1, '😕')];

  void _pick(int rating) {
    if (_picked != null) return;
    setState(() => _picked = rating);
    final ws = widget.worksheet;
    ProgressScope.read(context).sendFeedback(
      kind: 'reaction',
      rating: rating,
      context: {
        'worksheet_kind': ws.kind.name,
        'worksheet_id': ws.id,
        'level': ?ws.level?.name,
        'stars': widget.stars,
        if (ws.kind == WorksheetKind.topicQuiz) 'topic': ws.title,
      },
    );
  }

  @override
  Widget build(BuildContext context) => AnimatedSwitcher(
    duration: const Duration(milliseconds: 250),
    child: _picked != null
        ? const PicLabel(
            'Thanks for telling us! 💛',
            key: ValueKey('thanks'),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          )
        : Column(
            key: const ValueKey('ask'),
            children: [
              Text(
                'How was this one?',
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final (rating, face) in _faces)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: InkResponse(
                        onTap: () => _pick(rating),
                        radius: 44,
                        child: Container(
                          width: 76,
                          height: 76,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Pic(face, size: 44),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
  );
}
