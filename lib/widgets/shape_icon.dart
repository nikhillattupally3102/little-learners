import 'dart:math';

import 'package:flutter/material.dart';

import '../models/models.dart';
import '../theme.dart';

class ShapeIcon extends StatelessWidget {
  const ShapeIcon(
    this.shape,
    this.color, {
    super.key,
    this.size = 80,
    this.outline = false,
  });
  final ShapeKind shape;
  final Color color;
  final double size;

  /// Draw just the edge (an empty shape) instead of a filled one.
  final bool outline;

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: Size.square(size),
    painter: _ShapePainter(shape, color, outline),
  );
}

class _ShapePainter extends CustomPainter {
  _ShapePainter(this.shape, this.color, this.outline);
  final ShapeKind shape;
  final Color color;
  final bool outline;

  Path _path(Size s) {
    final w = s.width, h = s.height;
    final p = Path();
    switch (shape) {
      case ShapeKind.circle:
        p.addOval(Rect.fromLTWH(w * .06, h * .06, w * .88, h * .88));
      case ShapeKind.square:
        p.addRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(w * .1, h * .1, w * .8, h * .8),
            Radius.circular(w * .1),
          ),
        );
      case ShapeKind.rectangle:
        p.addRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(w * .04, h * .24, w * .92, h * .52),
            Radius.circular(w * .08),
          ),
        );
      case ShapeKind.oval:
        p.addOval(Rect.fromLTWH(w * .04, h * .2, w * .92, h * .6));
      case ShapeKind.triangle:
        p
          ..moveTo(w * .5, h * .08)
          ..lineTo(w * .95, h * .88)
          ..lineTo(w * .05, h * .88)
          ..close();
      case ShapeKind.diamond:
        p
          ..moveTo(w * .5, h * .04)
          ..lineTo(w * .9, h * .5)
          ..lineTo(w * .5, h * .96)
          ..lineTo(w * .1, h * .5)
          ..close();
      case ShapeKind.star:
        final c = Offset(w / 2, h * .53);
        for (var i = 0; i < 10; i++) {
          final r = (i.isEven ? .48 : .2) * w;
          final a = -pi / 2 + i * pi / 5;
          final pt = c + Offset(cos(a) * r, sin(a) * r);
          i == 0 ? p.moveTo(pt.dx, pt.dy) : p.lineTo(pt.dx, pt.dy);
        }
        p.close();
      case ShapeKind.heart:
        p
          ..moveTo(w * .5, h * .92)
          ..cubicTo(w * .1, h * .66, -w * .02, h * .38, w * .2, h * .18)
          ..cubicTo(w * .36, h * .04, w * .48, h * .16, w * .5, h * .28)
          ..cubicTo(w * .52, h * .16, w * .64, h * .04, w * .8, h * .18)
          ..cubicTo(w * 1.02, h * .38, w * .9, h * .66, w * .5, h * .92)
          ..close();
    }
    return p;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final path = _path(size);
    if (outline) {
      canvas.drawPath(path, Paint()..color = Colors.white);
      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = size.width * .09
          ..strokeJoin = StrokeJoin.round
          ..color = color,
      );
      return;
    }
    canvas.drawShadow(path, AppColors.darker(color, .5), 3, false);
    canvas.drawPath(path, Paint()..color = color);
    // Glossy highlight.
    canvas.save();
    canvas.clipPath(path);
    canvas.drawOval(
      Rect.fromLTWH(
        size.width * .18,
        size.height * .14,
        size.width * .38,
        size.height * .22,
      ),
      Paint()..color = Colors.white.withValues(alpha: .35),
    );
    canvas.restore();
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * .04
        ..strokeJoin = StrokeJoin.round
        ..color = AppColors.darker(color),
    );
  }

  @override
  bool shouldRepaint(_ShapePainter old) =>
      old.shape != shape || old.color != color || old.outline != outline;
}
