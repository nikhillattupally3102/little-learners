// Figures for the shape-thinking puzzles (figure matrices, figure groups and
// paper folding). A figure is written as a short spec string, so it can be
// used anywhere a picture can (choices, matrix cells) and drawn by [Pic]:
//
//   fig:triangle.1.2.o.1.b  → 2 blue outlined triangles, turned a quarter, big
//   paper:0.1,3.2           → an unfolded sheet with holes at (0,1) and (3,2)

import 'package:flutter/painting.dart' show Color;

import '../models/models.dart' show ShapeKind;

/// Colors figures come in, with their names (for speech).
const figColors = <(Color, String)>[
  (Color(0xFFFF4757), 'red'),
  (Color(0xFF3FA9F5), 'blue'),
  (Color(0xFF2ECC71), 'green'),
  (Color(0xFFFFB627), 'yellow'),
  (Color(0xFF8E5CF7), 'purple'),
];

/// Shapes whose quarter turns are easy to see.
const turnableShapes = [ShapeKind.triangle, ShapeKind.heart];

/// Shapes used in figure puzzles (each clearly different from the others).
const figShapes = [
  ShapeKind.circle,
  ShapeKind.square,
  ShapeKind.triangle,
  ShapeKind.star,
  ShapeKind.heart,
  ShapeKind.diamond,
];

class Fig {
  const Fig(
    this.shape, {
    this.color = 0,
    this.count = 1,
    this.outline = false,
    this.turn = 0,
    this.small = false,
  });

  final ShapeKind shape;

  /// Index into [figColors].
  final int color;

  /// How many of the shape (1–4).
  final int count;

  /// Empty (just the edge) instead of filled in.
  final bool outline;

  /// Quarter turns clockwise (0–3).
  final int turn;
  final bool small;

  String get spec =>
      'fig:${shape.name}.$color.$count.${outline ? 'o' : 's'}.$turn.'
      '${small ? 's' : 'b'}';

  static Fig? parse(String s) {
    if (!s.startsWith('fig:')) return null;
    final p = s.substring(4).split('.');
    if (p.length != 6) return null;
    final shape = ShapeKind.values.asNameMap()[p[0]];
    if (shape == null) return null;
    return Fig(
      shape,
      color: int.parse(p[1]),
      count: int.parse(p[2]),
      outline: p[3] == 'o',
      turn: int.parse(p[4]),
      small: p[5] == 's',
    );
  }

  Fig copyWith({
    ShapeKind? shape,
    int? color,
    int? count,
    bool? outline,
    int? turn,
    bool? small,
  }) => Fig(
    shape ?? this.shape,
    color: color ?? this.color,
    count: count ?? this.count,
    outline: outline ?? this.outline,
    turn: turn ?? this.turn,
    small: small ?? this.small,
  );

  @override
  bool operator ==(Object other) => other is Fig && other.spec == spec;

  @override
  int get hashCode => spec.hashCode;
}

/// An unfolded sheet of paper with holes on a 4×4 grid.
String paperSpec(Iterable<(int, int)> holes) {
  final sorted = holes.toSet().toList()
    ..sort((a, b) => a.$1 != b.$1 ? a.$1 - b.$1 : a.$2 - b.$2);
  return 'paper:${sorted.map((h) => '${h.$1}.${h.$2}').join(',')}';
}

List<(int, int)>? parsePaper(String s) {
  if (!s.startsWith('paper:')) return null;
  final body = s.substring(6);
  if (body.isEmpty) return const [];
  return [
    for (final h in body.split(','))
      (int.parse(h.split('.')[0]), int.parse(h.split('.')[1])),
  ];
}

/// Where holes punched in folded paper end up once it's opened again.
/// 'v': left half folded onto the right (paper is columns 2–3);
/// 'h': top half folded onto the bottom (rows 2–3); 'vh': both.
Set<(int, int)> unfold(String fold, Iterable<(int, int)> holes) {
  var out = holes.toSet();
  if (fold.contains('h')) {
    out = {
      for (final (r, c) in out) ...{(r, c), (3 - r, c)},
    };
  }
  if (fold.contains('v')) {
    out = {
      for (final (r, c) in out) ...{(r, c), (r, 3 - c)},
    };
  }
  return out;
}
