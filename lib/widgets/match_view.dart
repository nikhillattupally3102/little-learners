import 'dart:math';

import 'pic.dart';

import 'package:flutter/material.dart';

import '../models/models.dart';
import '../theme.dart';

/// Tap an item on one side, then its partner on the other side.
/// Matched pairs are joined with a coloured line.
class MatchView extends StatefulWidget {
  const MatchView({
    super.key,
    required this.question,
    required this.accent,
    required this.onMistake,
    required this.onPair,
    required this.onDone,
  });

  final MatchQuestion question;
  final Color accent;
  final VoidCallback onMistake;
  final VoidCallback onPair;
  final VoidCallback onDone;

  @override
  State<MatchView> createState() => _MatchViewState();
}

class _MatchViewState extends State<MatchView> {
  final _stackKey = GlobalKey();
  late final _leftKeys = List.generate(
    widget.question.left.length,
    (_) => GlobalKey(),
  );
  late final _rightKeys = List.generate(
    widget.question.right.length,
    (_) => GlobalKey(),
  );

  int? _selLeft;
  int? _selRight;

  /// left index → right index, for matched pairs.
  final Map<int, int> _matched = {};
  (bool, int)? _wrong;
  List<(Offset, Offset, Color)> _lines = [];

  /// Wide screens put the two sets in a top and bottom row so the
  /// pictures can be much bigger.
  bool _horizontal = false;

  MatchQuestion get q => widget.question;

  Color _pairColor(int left) =>
      AppColors.palette[(left * 2 + 1) % AppColors.palette.length];

  bool _isMatched(bool isLeft, int i) =>
      isLeft ? _matched.containsKey(i) : _matched.containsValue(i);

  void _tap(bool isLeft, int i) {
    if (_isMatched(isLeft, i)) return;
    setState(() {
      _wrong = null;
      if (isLeft) {
        _selLeft = _selLeft == i ? null : i;
      } else {
        _selRight = _selRight == i ? null : i;
      }
    });
    final l = _selLeft, r = _selRight;
    if (l == null || r == null) return;
    _attempt(l, r, blame: (isLeft, i));
  }

  /// Tries to pair left [l] with right [r]; [blame] shakes on a mistake.
  void _attempt(int l, int r, {required (bool, int) blame}) {
    if (q.answers[l] == r) {
      setState(() {
        _matched[l] = r;
        _selLeft = _selRight = null;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
      if (_matched.length == q.left.length) {
        widget.onDone();
      } else {
        widget.onPair();
      }
    } else {
      widget.onMistake();
      setState(() {
        _wrong = blame;
        _selLeft = _selRight = null;
      });
    }
  }

  // ------------------------------------------------------------ dragging

  /// The tile a drag started from, the line's start, and the finger.
  (bool, int)? _dragFrom;
  Offset? _dragStart;
  Offset? _dragPos;
  int? _hover;

  RenderBox? get _stackBox =>
      _stackKey.currentContext?.findRenderObject() as RenderBox?;

  Rect? _rectOf(bool isLeft, int i) {
    final stack = _stackBox;
    final box =
        (isLeft ? _leftKeys : _rightKeys)[i].currentContext?.findRenderObject()
            as RenderBox?;
    if (stack == null || box == null) return null;
    return stack.globalToLocal(box.localToGlobal(Offset.zero)) & box.size;
  }

  /// Which tile on the other side is under [pos] (with a little slack).
  int? _targetAt(Offset pos, bool targetIsLeft) {
    final n = targetIsLeft ? q.left.length : q.right.length;
    for (var i = 0; i < n; i++) {
      if (_isMatched(targetIsLeft, i)) continue;
      if (_rectOf(targetIsLeft, i)?.inflate(10).contains(pos) ?? false) {
        return i;
      }
    }
    return null;
  }

  void _dragStartAt(bool isLeft, int i, Offset global) {
    if (_isMatched(isLeft, i)) return;
    final stack = _stackBox;
    final rect = _rectOf(isLeft, i);
    if (stack == null || rect == null) return;
    setState(() {
      _wrong = null;
      _dragFrom = (isLeft, i);
      _dragStart = _horizontal
          ? Offset(rect.center.dx, isLeft ? rect.bottom : rect.top)
          : Offset(isLeft ? rect.right : rect.left, rect.center.dy);
      _dragPos = stack.globalToLocal(global);
      _selLeft = isLeft ? i : null;
      _selRight = isLeft ? null : i;
    });
  }

  void _dragMove(Offset global) {
    final from = _dragFrom, stack = _stackBox;
    if (from == null || stack == null) return;
    final pos = stack.globalToLocal(global);
    setState(() {
      _dragPos = pos;
      _hover = _targetAt(pos, !from.$1);
    });
  }

  void _dragEnd() {
    final from = _dragFrom, pos = _dragPos;
    setState(() {
      _dragFrom = _dragStart = _dragPos = null;
      _hover = null;
    });
    if (from == null || pos == null) return;
    final target = _targetAt(pos, !from.$1);
    if (target == null) {
      // Let go somewhere else: just drop the selection.
      setState(() => _selLeft = _selRight = null);
      return;
    }
    final (fromLeft, i) = from;
    _attempt(
      fromLeft ? i : target,
      fromLeft ? target : i,
      blame: (!fromLeft, target),
    );
  }

  void _measure() {
    final stack = _stackKey.currentContext?.findRenderObject() as RenderBox?;
    if (stack == null || !mounted) return;
    Offset edge(GlobalKey k, bool first) {
      final box = k.currentContext!.findRenderObject() as RenderBox;
      final local = stack.globalToLocal(box.localToGlobal(Offset.zero));
      if (_horizontal) {
        return local + Offset(box.size.width / 2, first ? box.size.height : 0);
      }
      return local + Offset(first ? box.size.width : 0, box.size.height / 2);
    }

    setState(() {
      _lines = [
        for (final e in _matched.entries)
          (
            edge(_leftKeys[e.key], true),
            edge(_rightKeys[e.value], false),
            _pairColor(e.key),
          ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    final n = q.left.length;
    return Column(
      children: [
        Text(
          q.prompt,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: LayoutBuilder(
            builder: (context, c) {
              const gap = 8.0;
              // Option A: two columns side by side.
              final vGapX = max(40.0, c.maxWidth * .14);
              final vh = min(170.0, (c.maxHeight - (n - 1) * 6) / n);
              final vw = (c.maxWidth - vGapX) / 2;
              // Option B: two rows, top and bottom.
              final hw = (c.maxWidth - (n - 1) * gap) / n;
              final hGapY = max(48.0, c.maxHeight * .16);
              final hh = min(hw * 1.45, (c.maxHeight - hGapY) / 2);
              final horizontal = min(hw, hh) > min(vw, vh) * 1.1;
              if (horizontal != _horizontal) {
                _horizontal = horizontal;
                WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
              }
              return NotificationListener<SizeChangedLayoutNotification>(
                onNotification: (_) {
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) => _measure(),
                  );
                  return false;
                },
                child: SizeChangedLayoutNotifier(
                  child: Stack(
                    key: _stackKey,
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _LinePainter(
                            _lines,
                            horizontal,
                            drag: _dragStart == null || _dragPos == null
                                ? null
                                : (_dragStart!, _dragPos!),
                            dragColor: widget.accent,
                          ),
                        ),
                      ),
                      if (horizontal)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [_line(true, hw, hh), _line(false, hw, hh)],
                        )
                      else
                        Row(
                          children: [
                            Expanded(child: _line(true, vw, vh)),
                            SizedBox(width: vGapX),
                            Expanded(child: _line(false, vw, vh)),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _line(bool isLeft, double width, double height) {
    final items = isLeft ? q.left : q.right;
    final keys = isLeft ? _leftKeys : _rightKeys;
    return Flex(
      direction: _horizontal ? Axis.horizontal : Axis.vertical,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (var i = 0; i < items.length; i++)
          () {
            final matchedLeft = isLeft
                ? (_matched.containsKey(i) ? i : null)
                : _matched.entries
                      .where((e) => e.value == i)
                      .map((e) => e.key)
                      .firstOrNull;
            final selected =
                (isLeft ? _selLeft == i : _selRight == i) ||
                (_dragFrom != null && _dragFrom!.$1 != isLeft && _hover == i);
            final wrong = _wrong == (isLeft, i);
            return GestureDetector(
              onPanStart: (d) => _dragStartAt(isLeft, i, d.globalPosition),
              onPanUpdate: (d) => _dragMove(d.globalPosition),
              onPanEnd: (_) => _dragEnd(),
              onPanCancel: () {
                if (_dragFrom != null) _dragEnd();
              },
              child: _MatchTile(
                key: keys[i],
                item: items[i],
                width: _horizontal ? width : double.infinity,
                height: height,
                accent: widget.accent,
                matchedColor: matchedLeft == null
                    ? null
                    : _pairColor(matchedLeft),
                selected: selected,
                wrong: wrong,
                onTap: () => _tap(isLeft, i),
              ),
            );
          }(),
      ],
    );
  }
}

class _MatchTile extends StatelessWidget {
  const _MatchTile({
    super.key,
    required this.item,
    required this.width,
    required this.height,
    required this.accent,
    required this.matchedColor,
    required this.selected,
    required this.wrong,
    required this.onTap,
  });

  final MatchItem item;
  final double width;
  final double height;
  final Color accent;
  final Color? matchedColor;
  final bool selected;
  final bool wrong;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final border =
        matchedColor ??
        (selected
            ? accent
            : wrong
            ? AppColors.tangerine
            : AppColors.lighter(accent, .45));
    final bg = matchedColor != null
        ? AppColors.lighter(matchedColor!, .75)
        : selected
        ? AppColors.lighter(accent, .7)
        : Colors.white;
    return TweenAnimationBuilder<double>(
      key: ValueKey(wrong),
      tween: Tween(begin: wrong ? 1 : 0, end: 0),
      duration: const Duration(milliseconds: 450),
      builder: (context, t, child) => Transform.translate(
        offset: Offset(sin(t * pi * 6) * 10 * t, 0),
        child: child,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: height,
          width: width,
          padding: EdgeInsets.all(item.text.isEmpty ? 2 : 6),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(min(height, 120) * .25),
            border: Border.all(
              color: border,
              width: selected || matchedColor != null ? 4 : 3,
            ),
            boxShadow: [
              BoxShadow(
                color: border.withValues(alpha: .4),
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: _content(),
        ),
      ),
    );
  }

  Widget _content() {
    final hasText = item.text.isNotEmpty;
    final emoji = item.emoji;
    // A picture with no words fills the whole tile.
    if (emoji != null && !hasText) {
      return Center(
        child: Pic(
          emoji,
          size: min(height, width.isFinite ? width : height) * .8,
        ),
      );
    }
    final stacked = width.isFinite && width < height * 1.6;
    final fontSize = (stacked ? min(width, height) * .2 : height * .3).clamp(
      12.0,
      40.0,
    );
    final text = Text(
      item.text,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w700),
    );
    if (emoji == null) {
      return Center(
        child: FittedBox(fit: BoxFit.scaleDown, child: text),
      );
    }
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Flex(
        direction: stacked ? Axis.vertical : Axis.horizontal,
        mainAxisSize: MainAxisSize.min,
        children: [
          Pic(emoji, size: (stacked ? min(width, height) * .56 : height * .55)),
          const SizedBox(width: 8, height: 4),
          text,
        ],
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  _LinePainter(this.lines, this.horizontal, {this.drag, this.dragColor});
  final List<(Offset, Offset, Color)> lines;
  final bool horizontal;

  /// The line following the finger while dragging (start, finger).
  final (Offset, Offset)? drag;
  final Color? dragColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (drag case (final a, final b)) {
      final color = dragColor ?? Colors.grey;
      canvas.drawLine(
        a,
        b,
        Paint()
          ..color = color.withValues(alpha: .7)
          ..strokeWidth = 7
          ..strokeCap = StrokeCap.round,
      );
      canvas.drawCircle(a, 8, Paint()..color = color);
      canvas.drawCircle(b, 14, Paint()..color = color.withValues(alpha: .35));
      canvas.drawCircle(b, 8, Paint()..color = color);
    }
    for (final (a, b, color) in lines) {
      final paint = Paint()
        ..color = color
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      final midX = (a.dx + b.dx) / 2, midY = (a.dy + b.dy) / 2;
      canvas.drawPath(
        horizontal
            ? (Path()
                ..moveTo(a.dx, a.dy)
                ..cubicTo(a.dx, midY, b.dx, midY, b.dx, b.dy))
            : (Path()
                ..moveTo(a.dx, a.dy)
                ..cubicTo(midX, a.dy, midX, b.dy, b.dx, b.dy)),
        paint,
      );
      canvas.drawCircle(a, 7, Paint()..color = color);
      canvas.drawCircle(b, 7, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(_LinePainter old) =>
      old.lines != lines || old.horizontal != horizontal || old.drag != drag;
}
