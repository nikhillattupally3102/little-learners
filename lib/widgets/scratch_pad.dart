import 'dart:math';

import 'package:flutter/material.dart';

import '../theme.dart';

/// Rough-work paper for maths: draw with a finger or pencil, tap to make
/// counting dots, erase, undo or clear. Each question gets a fresh pad
/// (give it a new key).
class ScratchPad extends StatefulWidget {
  const ScratchPad({super.key, required this.accent, this.onToggle});

  final Color accent;

  /// When set, a button in the header hides the pad.
  final VoidCallback? onToggle;

  @override
  State<ScratchPad> createState() => _ScratchPadState();
}

class _Stroke {
  _Stroke(this.color, this.width, this.points);
  final Color color;
  final double width;
  final List<Offset> points;
}

class _ScratchPadState extends State<ScratchPad> {
  static const _pens = [
    AppColors.ink,
    Color(0xFFE53935),
    Color(0xFF1E88E5),
    Color(0xFF43A047),
  ];

  final _strokes = <_Stroke>[];
  Color _pen = _pens.first;
  bool _erasing = false;

  void _start(Offset p) {
    if (_erasing) return _eraseAt(p);
    setState(() => _strokes.add(_Stroke(_pen, 5, [p])));
  }

  void _move(Offset p) {
    if (_erasing) return _eraseAt(p);
    if (_strokes.isEmpty) return;
    setState(() => _strokes.last.points.add(p));
  }

  /// Taps make a big dot — handy for counting ("two dots and two dots").
  void _dot(Offset p) {
    if (_erasing) return _eraseAt(p);
    setState(() => _strokes.add(_Stroke(_pen, 18, [p])));
  }

  /// The eraser removes whole strokes it touches.
  void _eraseAt(Offset p) {
    final before = _strokes.length;
    _strokes.removeWhere(
      (s) => s.points.any((q) => (q - p).distance < 18 + s.width / 2),
    );
    if (_strokes.length != before) setState(() {});
  }

  Widget _tool({
    required Widget child,
    required bool selected,
    required VoidCallback? onTap,
    String? tooltip,
  }) => Tooltip(
    message: tooltip ?? '',
    child: InkResponse(
      onTap: onTap,
      radius: 26,
      child: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selected ? AppColors.lighter(widget.accent, .65) : null,
          border: Border.all(
            color: selected ? widget.accent : Colors.transparent,
            width: 3,
          ),
        ),
        child: child,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDF7),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppColors.lighter(widget.accent, .5),
          width: 3,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, c) {
              final tools = [
                for (final pen in _pens)
                  _tool(
                    selected: !_erasing && _pen == pen,
                    onTap: () => setState(() {
                      _pen = pen;
                      _erasing = false;
                    }),
                    child: CircleAvatar(radius: 12, backgroundColor: pen),
                  ),
                _tool(
                  tooltip: 'Eraser',
                  selected: _erasing,
                  onTap: () => setState(() => _erasing = !_erasing),
                  child: const Icon(Icons.auto_fix_normal_rounded),
                ),
                _tool(
                  tooltip: 'Undo',
                  selected: false,
                  onTap: _strokes.isEmpty
                      ? null
                      : () => setState(_strokes.removeLast),
                  child: const Icon(Icons.undo_rounded),
                ),
                _tool(
                  tooltip: 'Clear',
                  selected: false,
                  onTap: _strokes.isEmpty
                      ? null
                      : () => setState(_strokes.clear),
                  child: const Icon(Icons.delete_outline_rounded),
                ),
                if (widget.onToggle != null)
                  _tool(
                    tooltip: 'Hide',
                    selected: false,
                    onTap: widget.onToggle,
                    child: const Icon(Icons.close_rounded),
                  ),
              ];
              // Show the title only when the buttons still fit at full size.
              final roomy = c.maxWidth >= tools.length * 46 + 170;
              return Padding(
                padding: const EdgeInsets.fromLTRB(12, 6, 6, 0),
                child: Row(
                  children: [
                    if (roomy)
                      const Text(
                        '✏️ Rough work',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    const Spacer(),
                    Flexible(
                      flex: 20,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: Row(children: tools),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(26),
              ),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapUp: (d) => _dot(d.localPosition),
                onPanStart: (d) => _start(d.localPosition),
                onPanUpdate: (d) => _move(d.localPosition),
                child: CustomPaint(
                  painter: _PadPainter(_strokes, _strokes.length),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PadPainter extends CustomPainter {
  _PadPainter(this.strokes, this.count);
  final List<_Stroke> strokes;

  /// Changes whenever strokes are added or removed (for repaint).
  final int count;

  @override
  void paint(Canvas canvas, Size size) {
    // Dotted paper.
    final dot = Paint()..color = const Color(0xFFE4DFEE);
    for (var y = 24.0; y < size.height; y += 32) {
      for (var x = 24.0; x < size.width; x += 32) {
        canvas.drawCircle(Offset(x, y), 1.6, dot);
      }
    }
    for (final s in strokes) {
      final paint = Paint()
        ..color = s.color
        ..strokeWidth = s.width
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;
      if (s.points.length == 1) {
        canvas.drawCircle(
          s.points.first,
          max(s.width / 2, 3),
          paint..style = PaintingStyle.fill,
        );
        continue;
      }
      final path = Path()..moveTo(s.points.first.dx, s.points.first.dy);
      for (var i = 1; i < s.points.length - 1; i++) {
        final mid = (s.points[i] + s.points[i + 1]) / 2;
        path.quadraticBezierTo(s.points[i].dx, s.points[i].dy, mid.dx, mid.dy);
      }
      path.lineTo(s.points.last.dx, s.points.last.dy);
      canvas.drawPath(path, paint);
    }
  }

  // Strokes grow in place while drawing, so always repaint; it's cheap.
  @override
  bool shouldRepaint(_PadPainter old) => true;
}
