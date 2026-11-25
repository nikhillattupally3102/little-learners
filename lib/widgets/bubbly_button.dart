import 'package:flutter/material.dart';

import '../theme.dart';

/// A chunky, squishy "3D" button that sinks when pressed — easy for small fingers.
class BubblyButton extends StatefulWidget {
  const BubblyButton({
    super.key,
    required this.child,
    required this.color,
    this.onTap,
    this.shadowColor,
    this.radius = 28,
    this.depth = 6,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
  });

  final Widget child;
  final Color color;
  final Color? shadowColor;
  final VoidCallback? onTap;
  final double radius;
  final double depth;
  final EdgeInsets padding;

  @override
  State<BubblyButton> createState() => _BubblyButtonState();
}

class _BubblyButtonState extends State<BubblyButton> {
  bool _pressed = false;

  void _set(bool v) {
    if (widget.onTap != null && _pressed != v) setState(() => _pressed = v);
  }

  @override
  Widget build(BuildContext context) {
    final depth = _pressed ? 1.0 : widget.depth;
    return Opacity(
      opacity: widget.onTap == null ? .45 : 1,
      child: GestureDetector(
        onTapDown: (_) => _set(true),
        onTapUp: (_) => _set(false),
        onTapCancel: () => _set(false),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 70),
          margin: EdgeInsets.only(top: widget.depth - depth, bottom: depth),
          padding: widget.padding,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(widget.radius),
            boxShadow: [
              BoxShadow(
                color: widget.shadowColor ?? AppColors.darker(widget.color),
                offset: Offset(0, depth),
              ),
            ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
