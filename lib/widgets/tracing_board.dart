import 'package:flutter/material.dart';

import 'pic.dart';

import '../theme.dart';
import 'bubbly_button.dart';

/// A big faded letter that kids trace over with their finger.
class TracingBoard extends StatefulWidget {
  const TracingBoard({
    super.key,
    required this.glyph,
    required this.hint,
    required this.color,
    required this.onDone,
  });

  final String glyph;
  final String hint;
  final Color color;
  final VoidCallback onDone;

  @override
  State<TracingBoard> createState() => _TracingBoardState();
}

class _TracingBoardState extends State<TracingBoard> {
  final List<List<Offset>> _strokes = [];
  double _ink = 0;
  double _boardSize = 0;

  bool get _enough => _boardSize > 0 && _ink > _boardSize * 1.2;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Trace with your finger!',
          style: Theme.of(context).textTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(widget.hint, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        Expanded(
          child: LayoutBuilder(
            builder: (context, c) {
              _boardSize = c.biggest.shortestSide;
              return ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: GestureDetector(
                  onPanStart: (d) =>
                      setState(() => _strokes.add([d.localPosition])),
                  onPanUpdate: (d) => setState(() {
                    final s = _strokes.last;
                    _ink += (d.localPosition - s.last).distance;
                    s.add(d.localPosition);
                  }),
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: _TracePainter(
                      widget.glyph,
                      _strokes,
                      widget.color,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BubblyButton(
              color: Colors.white,
              shadowColor: Colors.black12,
              onTap: _strokes.isEmpty
                  ? null
                  : () => setState(() {
                      _strokes.clear();
                      _ink = 0;
                    }),
              child: const PicLabel(
                '🧽 Clear',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(width: 16),
            BubblyButton(
              color: AppColors.mint,
              onTap: _enough ? widget.onDone : null,
              child: const PicLabel(
                '✅ Done!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TracePainter extends CustomPainter {
  _TracePainter(this.glyph, this.strokes, this.color);
  final String glyph;
  final List<List<Offset>> strokes;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.white);

    // Handwriting guide lines.
    final line = Paint()
      ..color = AppColors.sky.withValues(alpha: .25)
      ..strokeWidth = 3;
    for (final f in [.15, .85]) {
      canvas.drawLine(
        Offset(0, size.height * f),
        Offset(size.width, size.height * f),
        line,
      );
    }
    for (var x = 0.0; x < size.width; x += 24) {
      canvas.drawLine(
        Offset(x, size.height * .5),
        Offset(x + 12, size.height * .5),
        line,
      );
    }

    // Faded letter with a dotted-looking outline.
    // Single letters fill the height; words shrink to fit the width.
    final fontSize = glyph.length == 1
        ? size.height * .82
        : (size.width / (glyph.length * .62)).clamp(40.0, size.height * .7);
    for (final paint in [
      Paint()..color = color.withValues(alpha: .14),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = color.withValues(alpha: .55),
    ]) {
      final tp = TextPainter(
        text: TextSpan(
          text: glyph,
          style: TextStyle(
            fontFamily: 'Fredoka',
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            foreground: paint,
            height: 1,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        canvas,
        Offset((size.width - tp.width) / 2, (size.height - tp.height) / 2),
      );
    }

    // Kid's ink.
    final ink = Paint()
      ..color = color
      ..strokeWidth = (size.shortestSide * .07).clamp(14, 34)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    for (final s in strokes) {
      if (s.length == 1) {
        canvas.drawCircle(s.first, ink.strokeWidth / 2, Paint()..color = color);
        continue;
      }
      final path = Path()..moveTo(s.first.dx, s.first.dy);
      for (final p in s.skip(1)) {
        path.lineTo(p.dx, p.dy);
      }
      canvas.drawPath(path, ink);
    }
  }

  @override
  bool shouldRepaint(_TracePainter old) => true;
}
