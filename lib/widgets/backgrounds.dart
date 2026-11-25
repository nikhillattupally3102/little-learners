import 'dart:math';

import 'package:flutter/material.dart';

import '../theme.dart';

/// Soft, slowly floating bubbles behind every screen.
class BubblesBackground extends StatefulWidget {
  const BubblesBackground({super.key, this.tint});
  final Color? tint;

  @override
  State<BubblesBackground> createState() => _BubblesBackgroundState();
}

class _BubblesBackgroundState extends State<BubblesBackground>
    with SingleTickerProviderStateMixin {
  late final _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 14),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tint = widget.tint;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: tint == null
              ? const [Color(0xFFFFF1D6), AppColors.cream]
              : [AppColors.lighter(tint, .7), AppColors.cream],
        ),
      ),
      child: RepaintBoundary(
        child: CustomPaint(painter: _BubblePainter(_c), size: Size.infinite),
      ),
    );
  }
}

class _BubblePainter extends CustomPainter {
  _BubblePainter(this.anim) : super(repaint: anim);
  final Animation<double> anim;
  static final _bubbles = () {
    final r = Random(7);
    return List.generate(
      14,
      (i) => (
        x: r.nextDouble(),
        y: r.nextDouble(),
        size: 20 + r.nextDouble() * 70,
        color: AppColors.palette[i % AppColors.palette.length],
        phase: r.nextDouble() * 2 * pi,
      ),
    );
  }();

  @override
  void paint(Canvas canvas, Size size) {
    final t = anim.value * 2 * pi;
    for (final b in _bubbles) {
      final o = Offset(
        b.x * size.width + sin(t + b.phase) * 12,
        b.y * size.height + cos(t + b.phase) * 18,
      );
      canvas.drawCircle(
        o,
        b.size / 2,
        Paint()..color = b.color.withValues(alpha: .13),
      );
    }
  }

  @override
  bool shouldRepaint(_BubblePainter old) => false;
}

/// Falling confetti for celebrations.
class Confetti extends StatefulWidget {
  const Confetti({super.key});

  @override
  State<Confetti> createState() => _ConfettiState();
}

class _ConfettiState extends State<Confetti>
    with SingleTickerProviderStateMixin {
  late final _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 5),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: CustomPaint(painter: _ConfettiPainter(_c), size: Size.infinite),
  );
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.anim) : super(repaint: anim);
  final Animation<double> anim;
  static final _bits = () {
    final r = Random(42);
    return List.generate(
      90,
      (i) => (
        x: r.nextDouble(),
        y: r.nextDouble(),
        speed: .6 + r.nextDouble() * .8,
        spin: (r.nextDouble() - .5) * 12,
        wobble: r.nextDouble() * 2 * pi,
        color: AppColors.palette[r.nextInt(AppColors.palette.length)],
        w: 6 + r.nextDouble() * 8,
        round: r.nextBool(),
      ),
    );
  }();

  @override
  void paint(Canvas canvas, Size size) {
    final t = anim.value;
    for (final b in _bits) {
      final y = ((b.y + t * b.speed) % 1.1 - .05) * size.height;
      final x = b.x * size.width + sin(t * 2 * pi * 2 + b.wobble) * 20;
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(t * b.spin);
      final paint = Paint()..color = b.color;
      if (b.round) {
        canvas.drawCircle(Offset.zero, b.w / 2, paint);
      } else {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset.zero, width: b.w, height: b.w * 1.8),
            const Radius.circular(2),
          ),
          paint,
        );
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => false;
}

/// Pops a child in with a springy scale, optionally after a delay.
class PopIn extends StatelessWidget {
  const PopIn({super.key, required this.child, this.delay = Duration.zero});
  final Widget child;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    final total = delay + const Duration(milliseconds: 600);
    final start = delay.inMilliseconds / total.inMilliseconds;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: total,
      builder: (context, v, child) {
        final local = ((v - start) / (1 - start)).clamp(0.0, 1.0);
        return Transform.scale(
          scale: Curves.elasticOut.transform(local),
          child: child,
        );
      },
      child: child,
    );
  }
}
