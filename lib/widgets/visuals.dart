import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'figure_views.dart';

import 'pic.dart';

import '../models/models.dart';
import '../theme.dart';
import 'backgrounds.dart';
import 'shape_icon.dart';
import 'visuals_extra.dart';

/// Draws the picture part of a question.
class QuestionVisual extends StatelessWidget {
  const QuestionVisual(
    this.visual, {
    super.key,
    required this.accent,
    required this.segment,
    required this.onReplay,
    required this.readSegment,
    required this.onReadAloud,
  });
  final Visual visual;
  final Color accent;

  /// Index of the speech segment currently being read aloud.
  final ValueListenable<int> segment;
  final VoidCallback onReplay;

  /// Sentence of a reading passage currently being read aloud.
  final ValueListenable<int> readSegment;
  final void Function(List<String> sentences) onReadAloud;

  @override
  Widget build(BuildContext context) {
    // Text-heavy visuals need real width constraints rather than scaling.
    switch (visual) {
      case PassageVisual():
        final p = visual as PassageVisual;
        return PassageCard(
          p,
          accent: accent,
          highlight: readSegment,
          onRead: () => onReadAloud(p.sentences),
        );
      case TextVisual(:final text, :final emoji):
        return TextCard(text, emoji: emoji, accent: accent);
      default:
    }
    final child = switch (visual) {
      CountVisual(:final emoji, :final count) => _emojiWrap(
        emoji,
        count,
        count <= 4
            ? 96
            : count <= 8
            ? 72
            : 60,
        width: 460,
      ),
      ShapeVisual(:final shape, :final color) => PopIn(
        child: ShapeIcon(shape, color, size: 170),
      ),
      ColorVisual(:final color, :final name) => PopIn(
        child: _ColorBlob(color, name),
      ),
      EquationVisual() => _Equation(visual as EquationVisual, accent),
      PatternVisual(:final items) => _Pattern(items, accent),
      WordPictureVisual(:final emoji, :final word, :final missingIndex) =>
        _WordPicture(emoji, word, missingIndex, accent),
      ListenVisual() => _ListenButton(accent: accent, onTap: onReplay),
      SoundOutVisual(:final letters) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ValueListenableBuilder<int>(
            valueListenable: segment,
            builder: (context, i, _) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var k = 0; k < letters.length; k++)
                  AnimatedScale(
                    scale: i == k ? 1.2 : 1,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutBack,
                    child: _Tile(
                      letters[k],
                      accent,
                      size: 96,
                      lit: i == k || i >= letters.length,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _ListenButton(accent: accent, onTap: onReplay, size: 76),
        ],
      ),
      EmojiVisual(:final emoji, :final caption) => PopIn(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Pic(emoji, size: 120),
            if (caption != null)
              Text(
                caption,
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                ),
              ),
          ],
        ),
      ),
      ShadowVisual(:final emoji) => PopIn(child: ShadowEmoji(emoji, size: 150)),
      MatrixVisual() => MatrixView(visual as MatrixVisual, accent: accent),
      FoldVisual() => FoldView(visual as FoldVisual, accent: accent),
      MixedVisual(:final items) => SizedBox(
        width: 460,
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            for (var i = 0; i < items.length; i++)
              PopIn(
                delay: Duration(milliseconds: 70 * i),
                child: Pic(
                  items[i],
                  size: items.length <= 6
                      ? 84
                      : items.length <= 10
                      ? 64
                      : 52,
                ),
              ),
          ],
        ),
      ),
      ClockVisual(:final hour, :final minute) => PopIn(
        child: ClockFace(hour, minute, accent: accent),
      ),
      CoinsVisual(:final coins) => CoinsRow(coins),
      FractionVisual(:final parts, :final shaded, :final bar) => PopIn(
        child: FractionPicture(parts, shaded, bar: bar, color: accent),
      ),
      ArrayVisual(:final emoji, :final rows, :final cols) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var r = 0; r < rows; r++)
            PopIn(
              delay: Duration(milliseconds: 120 * r),
              child: PicText(List.filled(cols, emoji).join(), size: 44),
            ),
        ],
      ),
      RectVisual(:final width, :final height, :final grid) => PopIn(
        child: RectPicture(width, height, grid: grid, color: accent),
      ),
      SudokuVisual(:final cells) => PopIn(
        child: SudokuGrid(cells, accent: accent),
      ),
      PassageVisual() || TextVisual() => const SizedBox(),
    };
    return FittedBox(fit: BoxFit.scaleDown, child: child);
  }
}

Widget _emojiWrap(
  String emoji,
  int count,
  double size, {
  int faded = 0,
  double width = 380,
}) {
  return SizedBox(
    width: width,
    child: Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        for (var i = 0; i < count; i++)
          PopIn(
            delay: Duration(milliseconds: 90 * i),
            child: Opacity(
              opacity: i >= count - faded ? .3 : 1,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Pic(emoji, size: size),
                  if (i >= count - faded)
                    PicLabel(
                      '✖',
                      style: TextStyle(fontSize: size * .8, color: Colors.red),
                    ),
                ],
              ),
            ),
          ),
      ],
    ),
  );
}

class _ColorBlob extends StatelessWidget {
  const _ColorBlob(this.color, this.name);
  final Color color;
  final String name;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      const PicLabel('🎨', style: TextStyle(fontSize: 56)),
      Container(
        width: 160,
        height: 110,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(Radius.elliptical(90, 60)),
          boxShadow: [
            BoxShadow(
              color: AppColors.darker(color),
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Text(
          name.toUpperCase(),
          style: const TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    ],
  );
}

class _Tile extends StatelessWidget {
  const _Tile(
    this.text,
    this.color, {
    this.blank = false,
    this.size = 64,
    this.lit = false,
    this.wide = false,
  });
  final String text;
  final Color color;
  final bool blank;
  final double size;
  final bool lit;

  /// Grow horizontally to fit long numbers.
  final bool wide;

  @override
  Widget build(BuildContext context) => Container(
    width: wide ? null : size,
    constraints: BoxConstraints(minWidth: size),
    padding: wide ? EdgeInsets.symmetric(horizontal: size * .18) : null,
    height: size,
    margin: const EdgeInsets.all(4),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: lit
          ? color
          : blank
          ? AppColors.lighter(color, .85)
          : Colors.white,
      borderRadius: BorderRadius.circular(size * .28),
      border: Border.all(color: color, width: blank ? 4 : 3),
      boxShadow: [
        BoxShadow(
          color: color.withValues(alpha: .35),
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: !blank && Pic.has(text)
        ? Pic(text, size: size * .55)
        : Text(
            blank ? '?' : text,
            style: TextStyle(
              fontSize: size * .55,
              fontWeight: FontWeight.w700,
              color: lit
                  ? Colors.white
                  : blank
                  ? color
                  : AppColors.ink,
            ),
          ),
  );
}

class _Pattern extends StatelessWidget {
  const _Pattern(this.items, this.accent);
  final List<String> items;
  final Color accent;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      for (var i = 0; i < items.length; i++)
        PopIn(
          delay: Duration(milliseconds: 100 * i),
          child: _Tile(
            items[i],
            accent,
            blank: items[i] == '?',
            wide: items[i].length > 2,
          ),
        ),
    ],
  );
}

class _WordPicture extends StatelessWidget {
  const _WordPicture(this.emoji, this.word, this.missing, this.accent);
  final String emoji;
  final String word;
  final int missing;
  final Color accent;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      PopIn(child: Pic(emoji, size: 120)),
      const SizedBox(height: 12),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < word.length; i++)
            word[i] == ' '
                ? const SizedBox(width: 20)
                : _Tile(word[i], accent, blank: i == missing, size: 56),
        ],
      ),
    ],
  );
}

class _Equation extends StatelessWidget {
  const _Equation(this.v, this.accent);
  final EquationVisual v;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final tokens = ['${v.a}', v.op, '${v.b}', '=', '?'];
    final colors = [
      AppColors.sky,
      AppColors.tangerine,
      AppColors.bubblegum,
      AppColors.grape,
      accent,
    ];
    final wide = '${v.a}'.length > 2 || '${v.b}'.length > 2;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (v.emoji != null) ...[
          if (v.op == '+')
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _emojiWrap(v.emoji!, v.a, 52, width: 190),
                const Text(
                  '+',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w700,
                    color: AppColors.tangerine,
                  ),
                ),
                _emojiWrap(v.emoji!, v.b, 52, width: 190),
              ],
            )
          else
            _emojiWrap(v.emoji!, v.a, 52, faded: v.b, width: 400),
          const SizedBox(height: 20),
        ],
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < tokens.length; i++)
              PopIn(
                delay: Duration(milliseconds: 120 * i),
                child: i.isOdd
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          tokens[i],
                          style: TextStyle(
                            fontSize: 52,
                            fontWeight: FontWeight.w700,
                            color: colors[i],
                          ),
                        ),
                      )
                    : _Tile(
                        tokens[i],
                        colors[i],
                        blank: i == 4,
                        size: 76,
                        wide: wide && i != 4,
                      ),
              ),
          ],
        ),
      ],
    );
  }
}

/// Big pulsing "tap to listen again" button.
class _ListenButton extends StatefulWidget {
  const _ListenButton({
    required this.accent,
    required this.onTap,
    this.size = 150,
  });
  final Color accent;
  final VoidCallback onTap;
  final double size;

  @override
  State<_ListenButton> createState() => _ListenButtonState();
}

class _ListenButtonState extends State<_ListenButton>
    with SingleTickerProviderStateMixin {
  late final _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.size;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ScaleTransition(
          scale: Tween(
            begin: 1.0,
            end: 1.08,
          ).animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut)),
          child: GestureDetector(
            onTap: widget.onTap,
            child: Container(
              width: s,
              height: s,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.lighter(widget.accent, .25),
                    widget.accent,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.darker(widget.accent),
                    offset: const Offset(0, 6),
                  ),
                  BoxShadow(
                    color: widget.accent.withValues(alpha: .35),
                    blurRadius: 30,
                    spreadRadius: 6,
                  ),
                ],
              ),
              child: Icon(
                Icons.volume_up_rounded,
                color: Colors.white,
                size: s * .5,
              ),
            ),
          ),
        ),
        if (s >= 120) ...[
          const SizedBox(height: 14),
          const Text(
            'Tap to hear it again',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ],
      ],
    );
  }
}
