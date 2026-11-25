import 'dart:math';

import 'pic.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';
import '../theme.dart';

/// A reading passage with a "Read to me" button; the sentence being read glows.
class PassageCard extends StatelessWidget {
  const PassageCard(
    this.passage, {
    super.key,
    required this.accent,
    required this.highlight,
    required this.onRead,
  });
  final PassageVisual passage;
  final Color accent;
  final ValueListenable<int> highlight;
  final VoidCallback onRead;

  @override
  Widget build(BuildContext context) {
    final sentences = passage.sentences;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.lighter(accent, .9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.lighter(accent, .5), width: 2),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 8, 4),
            child: Row(
              children: [
                PicLabel(passage.emoji, style: const TextStyle(fontSize: 28)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    passage.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: onRead,
                  icon: Icon(Icons.volume_up_rounded, color: accent),
                  label: Text(
                    'Read to me',
                    style: TextStyle(
                      color: AppColors.darker(accent),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: ValueListenableBuilder<int>(
                valueListenable: highlight,
                builder: (context, current, _) => Text.rich(
                  TextSpan(
                    children: [
                      for (var i = 0; i < sentences.length; i++)
                        TextSpan(
                          text: '${sentences[i]} ',
                          style: TextStyle(
                            backgroundColor: i == current
                                ? AppColors.sunshine.withValues(alpha: .55)
                                : null,
                          ),
                        ),
                    ],
                  ),
                  style: const TextStyle(fontSize: 20, height: 1.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A card for sentences, riddles and word problems.
class TextCard extends StatelessWidget {
  const TextCard(this.text, {super.key, this.emoji, required this.accent});
  final String text;
  final String? emoji;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final short = text.length <= 24 && !text.contains('\n');
    return Center(
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.lighter(accent, .9),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.lighter(accent, .5), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (emoji != null) Pic(emoji!, size: 48),
              if (emoji != null) const SizedBox(height: 8),
              short
                  ? FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        text,
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  : Text(
                      text,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        height: 1.45,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

/// An emoji drawn as a solid black silhouette.
class ShadowEmoji extends StatelessWidget {
  const ShadowEmoji(this.emoji, {super.key, this.size = 120});
  final String emoji;
  final double size;

  @override
  Widget build(BuildContext context) => ColorFiltered(
    colorFilter: const ColorFilter.mode(Color(0xFF2D2A4A), BlendMode.srcIn),
    child: Pic(emoji, size: size),
  );
}

class ClockFace extends StatelessWidget {
  const ClockFace(this.hour, this.minute, {super.key, required this.accent});
  final int hour;
  final int minute;
  final Color accent;

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: const Size.square(230),
    painter: _ClockPainter(hour, minute, accent),
  );
}

class _ClockPainter extends CustomPainter {
  _ClockPainter(this.hour, this.minute, this.accent);
  final int hour;
  final int minute;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.width / 2;
    canvas.drawCircle(
      c + const Offset(0, 6),
      r - 4,
      Paint()..color = AppColors.darker(accent),
    );
    canvas.drawCircle(c, r - 4, Paint()..color = accent);
    canvas.drawCircle(c, r - 16, Paint()..color = Colors.white);
    for (var i = 0; i < 60; i++) {
      final a = i * pi / 30 - pi / 2;
      final long = i % 5 == 0;
      final p1 = c + Offset(cos(a), sin(a)) * (r - 20);
      final p2 = c + Offset(cos(a), sin(a)) * (r - (long ? 32 : 26));
      canvas.drawLine(
        p1,
        p2,
        Paint()
          ..color = AppColors.ink.withValues(alpha: long ? .8 : .3)
          ..strokeWidth = long ? 3 : 1.5,
      );
    }
    for (var n = 1; n <= 12; n++) {
      final a = n * pi / 6 - pi / 2;
      final tp = TextPainter(
        text: TextSpan(
          text: '$n',
          style: const TextStyle(
            fontFamily: 'Fredoka',
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        canvas,
        c +
            Offset(cos(a), sin(a)) * (r - 50) -
            Offset(tp.width / 2, tp.height / 2),
      );
    }
    void hand(double angle, double length, double width, Color color) {
      canvas.drawLine(
        c,
        c + Offset(cos(angle), sin(angle)) * length,
        Paint()
          ..color = color
          ..strokeWidth = width
          ..strokeCap = StrokeCap.round,
      );
    }

    hand(
      ((hour % 12) + minute / 60) * pi / 6 - pi / 2,
      r * .45,
      9,
      AppColors.ink,
    );
    hand(minute * pi / 30 - pi / 2, r * .7, 6, AppColors.bubblegum);
    canvas.drawCircle(c, 9, Paint()..color = AppColors.ink);
  }

  @override
  bool shouldRepaint(_ClockPainter old) =>
      old.hour != hour || old.minute != minute;
}

class CoinsRow extends StatelessWidget {
  const CoinsRow(this.coins, {super.key});
  final List<int> coins;

  static const _info = {
    1: ('1¢', 60.0, Color(0xFFD9885A), Color(0xFFB0643A)),
    5: ('5¢', 72.0, Color(0xFFCFD3DA), Color(0xFF9AA0AA)),
    10: ('10¢', 56.0, Color(0xFFE3E6EB), Color(0xFFA5ABB5)),
    25: ('25¢', 84.0, Color(0xFFD4D8DF), Color(0xFF959CA7)),
  };

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 420,
    child: Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 10,
      runSpacing: 10,
      children: [
        for (var i = 0; i < coins.length; i++)
          () {
            final (label, size, face, edge) = _info[coins[i]]!;
            return Container(
              width: size,
              height: size,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Colors.white, face],
                  center: const Alignment(-.4, -.4),
                  radius: .9,
                ),
                border: Border.all(color: edge, width: 4),
                boxShadow: [BoxShadow(color: edge, offset: const Offset(0, 4))],
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: size * .3,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darker(edge, .4),
                ),
              ),
            );
          }(),
      ],
    ),
  );
}

class FractionPicture extends StatelessWidget {
  const FractionPicture(
    this.parts,
    this.shaded, {
    super.key,
    required this.bar,
    required this.color,
  });
  final int parts;
  final int shaded;
  final bool bar;
  final Color color;

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: bar ? const Size(360, 90) : const Size.square(210),
    painter: _FractionPainter(parts, shaded, bar, color),
  );
}

class _FractionPainter extends CustomPainter {
  _FractionPainter(this.parts, this.shaded, this.bar, this.color);
  final int parts;
  final int shaded;
  final bool bar;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()..color = color;
    final empty = Paint()..color = Colors.white;
    final line = Paint()
      ..color = AppColors.ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    if (bar) {
      final w = size.width / parts;
      for (var i = 0; i < parts; i++) {
        final rect = Rect.fromLTWH(i * w, 0, w, size.height);
        canvas.drawRect(rect, i < shaded ? fill : empty);
        canvas.drawRect(rect, line);
      }
      return;
    }
    final rect = Offset.zero & size;
    final sweep = 2 * pi / parts;
    for (var i = 0; i < parts; i++) {
      canvas.drawArc(
        rect.deflate(4),
        -pi / 2 + i * sweep,
        sweep,
        true,
        i < shaded ? fill : empty,
      );
      canvas.drawArc(rect.deflate(4), -pi / 2 + i * sweep, sweep, true, line);
    }
  }

  @override
  bool shouldRepaint(_FractionPainter old) => true;
}

class RectPicture extends StatelessWidget {
  const RectPicture(
    this.w,
    this.h, {
    super.key,
    required this.grid,
    required this.color,
  });
  final int w;
  final int h;
  final bool grid;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final cell = grid ? 44.0 : 300 / max(w, h);
    final width = w * cell, height = h * cell;
    return SizedBox(
      width: width + (grid ? 0 : 90),
      height: height + (grid ? 0 : 60),
      child: Stack(
        children: [
          Positioned(
            left: grid ? 0 : 0,
            top: grid ? 0 : 30,
            child: CustomPaint(
              size: Size(width, height),
              painter: _RectPainter(w, h, grid, color),
            ),
          ),
          if (!grid) ...[
            Positioned(
              left: 0,
              width: width,
              top: 0,
              child: Center(
                child: Text(
                  '$w cm',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Positioned(
              left: width + 8,
              top: 30 + height / 2 - 14,
              child: Text(
                '$h cm',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _RectPainter extends CustomPainter {
  _RectPainter(this.w, this.h, this.grid, this.color);
  final int w;
  final int h;
  final bool grid;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(rect, Paint()..color = AppColors.lighter(color, .55));
    if (grid) {
      final line = Paint()
        ..color = Colors.white
        ..strokeWidth = 2;
      for (var x = 1; x < w; x++) {
        canvas.drawLine(
          Offset(size.width / w * x, 0),
          Offset(size.width / w * x, size.height),
          line,
        );
      }
      for (var y = 1; y < h; y++) {
        canvas.drawLine(
          Offset(0, size.height / h * y),
          Offset(size.width, size.height / h * y),
          line,
        );
      }
    }
    canvas.drawRect(
      rect,
      Paint()
        ..color = AppColors.darker(color)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    );
  }

  @override
  bool shouldRepaint(_RectPainter old) => true;
}

class SudokuGrid extends StatelessWidget {
  const SudokuGrid(this.cells, {super.key, required this.accent});
  final List<String> cells;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    const size = 64.0;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.ink, width: 4),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var r = 0; r < 4; r++)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var c = 0; c < 4; c++)
                  () {
                    final v = cells[r * 4 + c];
                    final target = v == '?';
                    return Container(
                      width: size,
                      height: size,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: target
                            ? AppColors.lighter(accent, .6)
                            : ((r ~/ 2 + c ~/ 2).isEven
                                  ? Colors.white
                                  : AppColors.lighter(accent, .88)),
                        border: Border(
                          right: BorderSide(
                            color: AppColors.ink.withValues(
                              alpha: c == 1 ? 1 : .2,
                            ),
                            width: c == 1 ? 4 : 1,
                          ),
                          bottom: BorderSide(
                            color: AppColors.ink.withValues(
                              alpha: r == 1 ? 1 : .2,
                            ),
                            width: r == 1 ? 4 : 1,
                          ),
                        ),
                      ),
                      child: Text(
                        v,
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                          color: target
                              ? AppColors.darker(accent)
                              : AppColors.ink,
                        ),
                      ),
                    );
                  }(),
              ],
            ),
        ],
      ),
    );
  }
}
