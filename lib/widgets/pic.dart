import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/models.dart' show ShapeKind;
import '../theme.dart';
import '../content/figures.dart';
import 'figure_views.dart';
import 'pic_index.dart';
import 'shape_icon.dart';

/// Shows the app's own hand-drawn picture for [emoji] when one exists, and
/// falls back to the emoji character otherwise. Drawings live in
/// assets/pics/<code points>.svg (see pic_index.dart).
class Pic extends StatelessWidget {
  const Pic(this.emoji, {super.key, required this.size});
  final String emoji;
  final double size;

  /// Emoji map to their code points; names like `pic:mars` (pictures with
  /// no emoji equivalent) map to the name.
  static String _code(String e) => e.startsWith('pic:')
      ? e.substring(4)
      : e.runes
            .where((r) => r != 0xFE0F)
            .map((r) => r.toRadixString(16))
            .join('-');

  static bool has(String emoji) =>
      shapeOf(emoji) != null ||
      emoji.startsWith('fig:') ||
      emoji.startsWith('paper:') ||
      drawnPictures.contains(_code(emoji.trim()));

  /// `shape:circle` → a drawn circle (shapes have no good emoji).
  static ShapeKind? shapeOf(String emoji) => emoji.trim().startsWith('shape:')
      ? ShapeKind.values.asNameMap()[emoji.trim().substring(6)]
      : null;

  /// The colour each shape is drawn in when shown on its own.
  static const shapeColors = {
    ShapeKind.circle: Color(0xFFFF4757),
    ShapeKind.square: AppColors.sky,
    ShapeKind.triangle: AppColors.mint,
    ShapeKind.star: AppColors.sunshine,
    ShapeKind.heart: AppColors.bubblegum,
    ShapeKind.rectangle: AppColors.tangerine,
    ShapeKind.oval: AppColors.grape,
    ShapeKind.diamond: AppColors.lime,
  };

  @override
  Widget build(BuildContext context) {
    final fig = Fig.parse(emoji.trim());
    if (fig != null) return FigureIcon(fig, size: size * 1.3);
    final paper = parsePaper(emoji.trim());
    if (paper != null) return PaperIcon(paper, size: size * 1.2);
    final shape = shapeOf(emoji);
    if (shape != null) {
      return ShapeIcon(shape, shapeColors[shape]!, size: size * 1.3);
    }
    final code = _code(emoji.trim());
    if (!drawnPictures.contains(code)) {
      return Text(emoji, style: TextStyle(fontSize: size, height: 1.15));
    }
    // Drawings are a little larger than the emoji glyph box they replace.
    final s = size * 1.3;
    return SizedBox.square(
      dimension: s,
      child: SvgPicture.asset('assets/pics/$code.svg', width: s, height: s),
    );
  }
}

/// Text that may contain emoji: if it is made only of emoji that have
/// drawings (e.g. "🍎🍎🍎"), they are shown as pictures; otherwise as text.
class PicText extends StatelessWidget {
  const PicText(this.text, {super.key, required this.size, this.style});
  final String text;
  final double size;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    if (Pic.has(text)) return Pic(text.trim(), size: size);
    final parts = text.characters.where((c) => c.trim().isNotEmpty).toList();
    if (parts.isNotEmpty && parts.every(Pic.has)) {
      if (parts.length == 1) return Pic(parts.first, size: size);
      return Wrap(
        alignment: WrapAlignment.center,
        spacing: 2,
        runSpacing: 2,
        children: [for (final p in parts) Pic(p, size: size)],
      );
    }
    return PicLabel(
      text,
      style: (style ?? const TextStyle()).copyWith(fontSize: size),
      textAlign: TextAlign.center,
    );
  }
}

/// A drop-in for [Text] whose string mixes words and emoji
/// (e.g. "🎓 Kindergarten"): every emoji that has a drawing is shown
/// inline as the picture, at roughly the size of the text.
class PicLabel extends StatelessWidget {
  const PicLabel(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.scale = 1.15,
  });
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  /// Picture size relative to the font size.
  final double scale;

  @override
  Widget build(BuildContext context) {
    final effective = DefaultTextStyle.of(context).style.merge(style);
    final fontSize = effective.fontSize ?? 14;
    final spans = <InlineSpan>[];
    final buffer = StringBuffer();
    void flush() {
      if (buffer.isEmpty) return;
      spans.add(TextSpan(text: buffer.toString()));
      buffer.clear();
    }

    for (final c in text.characters) {
      if (c.runes.first > 0x2000 && Pic.has(c)) {
        flush();
        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Pic(c, size: fontSize * scale / 1.3),
          ),
        );
      } else {
        buffer.write(c);
      }
    }
    flush();
    return Text.rich(
      TextSpan(children: spans),
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
