import 'dart:math';

import 'package:flutter/material.dart';

import '../content/figures.dart';
import '../models/models.dart';
import '../theme.dart';
import 'backgrounds.dart' show PopIn;
import 'pic.dart';
import 'shape_icon.dart';

/// One figure: 1–4 shapes, filled or empty, maybe turned, big or small.
class FigureIcon extends StatelessWidget {
  const FigureIcon(this.fig, {super.key, required this.size});
  final Fig fig;
  final double size;

  static const _spots = {
    1: [Offset(.5, .5)],
    2: [Offset(.27, .5), Offset(.73, .5)],
    3: [Offset(.27, .3), Offset(.73, .3), Offset(.5, .74)],
    4: [Offset(.27, .27), Offset(.73, .27), Offset(.27, .73), Offset(.73, .73)],
  };

  @override
  Widget build(BuildContext context) {
    final spots = _spots[fig.count.clamp(1, 4)]!;
    final each = size * (fig.count == 1 ? .86 : .44) * (fig.small ? .55 : 1);
    return SizedBox.square(
      dimension: size,
      child: Stack(
        children: [
          for (final o in spots)
            Positioned(
              left: o.dx * size - each / 2,
              top: o.dy * size - each / 2,
              child: Transform.rotate(
                angle: fig.turn * pi / 2,
                child: ShapeIcon(
                  fig.shape,
                  figColors[fig.color % figColors.length].$1,
                  size: each,
                  outline: fig.outline,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// A sheet of paper on a 4×4 grid, showing part of it ([rows] × [cols]
/// from the bottom-right corner when folded), with holes.
class PaperIcon extends StatelessWidget {
  const PaperIcon(
    this.holes, {
    super.key,
    required this.size,
    this.fromRow = 0,
    this.fromCol = 0,
    this.foldLine,
  });
  final List<(int, int)> holes;
  final double size;

  /// The first row and column still showing (2 once folded in half).
  final int fromRow;
  final int fromCol;

  /// A dashed line where the next fold goes: 'v' or 'h'.
  final String? foldLine;

  @override
  Widget build(BuildContext context) {
    final cell = size / 4;
    return SizedBox(
      width: cell * (4 - fromCol),
      height: cell * (4 - fromRow),
      child: CustomPaint(
        painter: _PaperPainter(
          holes,
          cell,
          fromRow,
          fromCol,
          foldLine,
          layers: (fromRow > 0 ? 2 : 1) * (fromCol > 0 ? 2 : 1),
        ),
      ),
    );
  }
}

class _PaperPainter extends CustomPainter {
  _PaperPainter(
    this.holes,
    this.cell,
    this.fromRow,
    this.fromCol,
    this.foldLine, {
    required this.layers,
  });
  final List<(int, int)> holes;
  final double cell;
  final int fromRow;
  final int fromCol;
  final String? foldLine;
  final int layers;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paper = RRect.fromRectAndRadius(rect, Radius.circular(cell * .12));
    // Folded paper is a little darker: more layers.
    final shade = layers == 1 ? 0.0 : (layers == 2 ? .06 : .12);
    canvas.drawRRect(
      paper,
      Paint()..color = Color.lerp(Colors.white, AppColors.sky, shade)!,
    );
    canvas.drawRRect(
      paper,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = AppColors.ink.withValues(alpha: .55),
    );
    final dash = Paint()
      ..strokeWidth = 3
      ..color = AppColors.tangerine;
    void dashed(Offset a, Offset b) {
      final len = (b - a).distance;
      final dir = (b - a) / len;
      for (var t = 0.0; t < len; t += 14) {
        canvas.drawLine(a + dir * t, a + dir * min(t + 8, len), dash);
      }
    }

    if (foldLine == 'v') {
      dashed(
        Offset(size.width / 2, 4),
        Offset(size.width / 2, size.height - 4),
      );
      _arrow(
        canvas,
        Offset(size.width * .25, size.height * .5),
        Offset(size.width * .75, size.height * .5),
      );
    } else if (foldLine == 'h') {
      dashed(
        Offset(4, size.height / 2),
        Offset(size.width - 4, size.height / 2),
      );
      _arrow(
        canvas,
        Offset(size.width * .5, size.height * .25),
        Offset(size.width * .5, size.height * .75),
      );
    }
    for (final (r, c) in holes) {
      if (r < fromRow || c < fromCol) continue;
      final center = Offset(
        (c - fromCol + .5) * cell,
        (r - fromRow + .5) * cell,
      );
      canvas.drawCircle(center, cell * .22, Paint()..color = AppColors.ink);
    }
  }

  /// A curved "fold this way" arrow from [a] over to [b].
  void _arrow(Canvas canvas, Offset a, Offset b) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..color = AppColors.tangerine;
    final mid = (a + b) / 2;
    final normal = Offset(-(b - a).dy, (b - a).dx) / (b - a).distance;
    final ctrl = mid - normal * cell * .9;
    final path = Path()
      ..moveTo(a.dx, a.dy)
      ..quadraticBezierTo(ctrl.dx, ctrl.dy, b.dx, b.dy);
    canvas.drawPath(path, paint);
    final dir = (b - ctrl) / (b - ctrl).distance;
    final side = Offset(-dir.dy, dir.dx);
    final head = Path()
      ..moveTo(b.dx, b.dy)
      ..lineTo((b - dir * 14 + side * 9).dx, (b - dir * 14 + side * 9).dy)
      ..moveTo(b.dx, b.dy)
      ..lineTo((b - dir * 14 - side * 9).dx, (b - dir * 14 - side * 9).dy);
    canvas.drawPath(head, paint);
  }

  @override
  bool shouldRepaint(_PaperPainter old) => true;
}

/// Paper folding, step by step: the sheet with a fold line, folded, and
/// (last) folded with the holes punched through it.
class FoldView extends StatelessWidget {
  const FoldView(this.v, {super.key, required this.accent});
  final FoldVisual v;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    const size = 190.0;
    final steps = <Widget>[
      PaperIcon(const [], size: size, foldLine: v.fold[0]),
      if (v.fold == 'vh')
        PaperIcon(const [], size: size, fromCol: 2, foldLine: 'h'),
      PaperIcon(
        v.holes,
        size: size,
        fromRow: v.fold.contains('h') ? 2 : 0,
        fromCol: v.fold.contains('v') ? 2 : 0,
      ),
    ];
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          if (i > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Icon(Icons.arrow_forward_rounded, size: 40, color: accent),
            ),
          PopIn(
            delay: Duration(milliseconds: 250 * i),
            child: steps[i],
          ),
        ],
      ],
    );
  }
}

/// Rows of cells with joins between them: "🐰 → 🥕 / 🐒 → ?", a 3×3 figure
/// grid, or a balance "🍎🍎 + ? = 🍎🍎🍎🍎".
class MatrixView extends StatelessWidget {
  const MatrixView(this.v, {super.key, required this.accent});
  final MatrixVisual v;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final rows = (v.cells.length / v.cols).ceil();
    final cell = v.cols >= 3 && v.joins.isEmpty ? 112.0 : 124.0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var r = 0; r < rows; r++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var c = 0; c < v.cols; c++) ...[
                  if (c > 0)
                    v.joins.isEmpty
                        ? const SizedBox(width: 12)
                        : SizedBox(
                            width: 56,
                            child: _join(
                              v.joins[min(c - 1, v.joins.length - 1)],
                            ),
                          ),
                  if (r * v.cols + c < v.cells.length)
                    PopIn(
                      delay: Duration(milliseconds: 120 * (r * v.cols + c)),
                      child: _Cell(v.cells[r * v.cols + c], accent, cell),
                    ),
                ],
              ],
            ),
          ),
      ],
    );
  }

  /// "→" is drawn as an icon (the app font has no arrow); "+" and "=" as text.
  Widget _join(String j) => j == '→'
      ? Icon(Icons.arrow_forward_rounded, size: 40, color: accent)
      : Text(
          j,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w700,
            color: accent,
          ),
        );
}

class _Cell extends StatelessWidget {
  const _Cell(this.text, this.accent, this.size);
  final String text;
  final Color accent;
  final double size;

  @override
  Widget build(BuildContext context) {
    final blank = text == '?';
    final chars = text.characters.where((c) => c.trim().isNotEmpty).toList();
    final Widget child;
    if (blank) {
      child = Text(
        '?',
        style: TextStyle(
          fontSize: size * .5,
          fontWeight: FontWeight.w700,
          color: accent,
        ),
      );
    } else if (Pic.has(text)) {
      child = Pic(text.trim(), size: size * .62);
    } else if (chars.length > 1 && chars.every(Pic.has)) {
      // A few of the same picture, e.g. 🍎🍎🍎.
      final each = size * (chars.length <= 4 ? .34 : .26);
      child = Wrap(
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.center,
        spacing: 2,
        runSpacing: 2,
        children: [for (final c in chars) Pic(c, size: each)],
      );
    } else {
      child = Padding(
        padding: const EdgeInsets.all(8),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            text,
            style: TextStyle(
              fontSize: size * .36,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
        ),
      );
    }
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: blank ? AppColors.lighter(accent, .85) : Colors.white,
        borderRadius: BorderRadius.circular(size * .2),
        border: Border.all(color: accent, width: blank ? 4 : 3),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: .3),
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
