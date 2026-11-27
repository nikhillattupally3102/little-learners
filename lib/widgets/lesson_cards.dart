import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';
import '../theme.dart';
import 'backgrounds.dart' show PopIn;
import 'pic.dart';

/// "Let's learn!" picture cards. The card being read aloud lights up
/// (speech segment 0 is the page title, then one segment per card).
class LessonCards extends StatelessWidget {
  const LessonCards(
    this.v, {
    super.key,
    required this.accent,
    required this.segment,
  });
  final LessonVisual v;
  final Color accent;
  final ValueListenable<int> segment;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      final n = v.cards.length;
      final width = box.maxWidth.isFinite ? box.maxWidth : 700.0;
      final height = box.maxHeight.isFinite ? box.maxHeight : 520.0;
      const gap = 12.0;
      final cols = min(n, width >= 560 ? 3 : 2);
      final rows = (n / cols).ceil();
      final w = min(230.0, (width - gap * (cols - 1)) / cols);
      final h = min(w * 1.05, (height - gap * (rows - 1)) / rows);
      return ValueListenableBuilder<int>(
        valueListenable: segment,
        builder: (context, spoken, _) => Wrap(
          alignment: WrapAlignment.center,
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final (i, c) in v.cards.indexed)
              PopIn(
                delay: Duration(milliseconds: 90 * i),
                child: _LessonCard(
                  c,
                  width: w,
                  height: h,
                  accent: accent,
                  lit: spoken == i + 1,
                ),
              ),
          ],
        ),
      );
    },
  );
}

class _LessonCard extends StatelessWidget {
  const _LessonCard(
    this.c, {
    required this.width,
    required this.height,
    required this.accent,
    required this.lit,
  });
  final LessonCard c;
  final double width;
  final double height;
  final Color accent;
  final bool lit;

  /// A picture, a few pictures (🔥🧊), or a word or letters ("the", "A B C D").
  Widget _picture() {
    final size = height * .4;
    if (Pic.has(c.pic)) return Pic(c.pic, size: size);
    final chars = c.pic.characters.toList();
    if (chars.length > 1 && chars.every(Pic.has)) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [for (final ch in chars) Pic(ch, size: size * .8)],
      );
    }
    return Text(
      c.pic,
      style: TextStyle(
        fontSize: size * .7,
        fontWeight: FontWeight.w700,
        color: AppColors.darker(accent, .25),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => AnimatedContainer(
    duration: const Duration(milliseconds: 250),
    width: width,
    height: height,
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: lit ? AppColors.lighter(accent, .8) : Colors.white,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: accent, width: lit ? 4 : 2),
      boxShadow: [
        BoxShadow(
          color: accent.withValues(alpha: .25),
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      children: [
        Expanded(
          flex: 5,
          child: FittedBox(fit: BoxFit.scaleDown, child: _picture()),
        ),
        if (c.label.isNotEmpty)
          FittedBox(
            fit: BoxFit.scaleDown,
            child: PicLabel(
              c.label,
              style: TextStyle(
                fontSize: max(16, height * .12),
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
          ),
        const SizedBox(height: 4),
        Expanded(
          flex: 3,
          child: Center(
            child: Text(
              c.sentence,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: (height * .075).clamp(12, 17).toDouble(),
                fontWeight: FontWeight.w600,
                color: AppColors.ink.withValues(alpha: .8),
                height: 1.15,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
