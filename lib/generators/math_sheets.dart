import 'dart:math';

import 'package:flutter/painting.dart' show Color;

import '../models/models.dart';
import 'gen.dart';

const namedColors = [
  ('red', 0xFFFF4757),
  ('blue', 0xFF3FA9F5),
  ('yellow', 0xFFFFD23F),
  ('green', 0xFF2ECC71),
  ('orange', 0xFFFF8C42),
  ('purple', 0xFF8E5CF7),
  ('pink', 0xFFFF6FB5),
];

List<Question> shapes(Gen g) {
  const simple = [
    ShapeKind.circle,
    ShapeKind.square,
    ShapeKind.triangle,
    ShapeKind.star,
    ShapeKind.heart,
    ShapeKind.diamond,
  ];
  final all = g.atLeast(Level.preK) ? ShapeKind.values : simple;
  Choice shapeChoice(ShapeKind s, int c) => Choice.shape(s, _color(c));

  return g.many(g.count, () {
    final type = g.atLeast(Level.grade1)
        ? g.one(['sides', 'sides', 'name'])
        : g.atLeast(Level.preK)
        ? g.one(['name', 'match', 'color'])
        : g.one(['match', 'color']);
    switch (type) {
      case 'sides':
        const sides = {
          ShapeKind.triangle: 3,
          ShapeKind.square: 4,
          ShapeKind.rectangle: 4,
          ShapeKind.diamond: 4,
          ShapeKind.circle: 0,
        };
        final s = g.one(sides.keys.toList());
        return g.number(
          prompt: 'How many sides does a ${s.label} have?',
          visual: ShapeVisual(s, _color(g.one(namedColors).$2)),
          answer: sides[s]!,
          count: 3,
        );
      case 'name':
        final picks = g.pick(all, 3);
        final colors = g.pick(namedColors, 3);
        final target = picks.first;
        final shuffled = [...picks]..shuffle(g.r);
        return ChoiceQuestion(
          prompt: 'Tap the ${target.label}!',
          visual: const ListenVisual(),
          choices: [
            for (var i = 0; i < 3; i++) shapeChoice(shuffled[i], colors[i].$2),
          ],
          answer: shuffled.indexOf(target),
        );
      case 'match':
        final picks = g.pick(all, g.atLeast(Level.age3) ? 3 : 2);
        final colors = g.pick(namedColors, 4);
        final target = picks.first;
        final shuffled = [...picks]..shuffle(g.r);
        return ChoiceQuestion(
          prompt: 'Find the same shape!',
          visual: ShapeVisual(target, _color(colors[3].$2)),
          choices: [
            for (var i = 0; i < shuffled.length; i++)
              shapeChoice(shuffled[i], colors[i].$2),
          ],
          answer: shuffled.indexOf(target),
        );
      default:
        final colors = g.pick(namedColors, g.atLeast(Level.age3) ? 3 : 2);
        final target = colors.first;
        final shuffled = [...colors]..shuffle(g.r);
        final shape = g.one(simple);
        return ChoiceQuestion(
          prompt: 'Tap the ${target.$1} one!',
          visual: ColorVisual(_color(target.$2), target.$1),
          choices: [for (final c in shuffled) shapeChoice(shape, c.$2)],
          answer: shuffled.indexOf(target),
        );
    }
  });
}

List<Question> decimals(Gen g) {
  String d(int hundredths) {
    final s = (hundredths / 100).toStringAsFixed(2);
    return s.endsWith('0') ? s.substring(0, s.length - 1) : s;
  }

  return g.many(g.count, () {
    final type = g.one(
      g.atLeast(Level.grade5)
          ? ['add', 'sub', 'times', 'compare']
          : ['compare', 'tenths', 'add'],
    );
    switch (type) {
      case 'tenths':
        final n = g.between(1, 9);
        return g.choice(
          prompt: 'Write $n/10 as a decimal.',
          visual: FractionVisual(10, n, bar: true),
          answer: '0.$n',
          wrong: {'$n.0', '0.0$n', '$n.10', '1.$n'},
          count: 4,
        );
      case 'add':
        final a = g.between(5, 450), b = g.between(5, 450);
        final ad = g.atLeast(Level.grade5) ? a : a ~/ 10 * 10,
            bd = g.atLeast(Level.grade5) ? b : b ~/ 10 * 10;
        return g.choice(
          prompt: 'Add the decimals!',
          visual: TextVisual('${d(ad)} + ${d(bd)} = ?'),
          answer: d(ad + bd),
          wrong: {
            d(ad + bd + 10),
            d(ad + bd - 10 < 0 ? ad + bd + 1 : ad + bd - 10),
            d(ad + bd + 100),
            d((ad + bd) * 10),
          }..remove(d(ad + bd)),
          count: 4,
        );
      case 'sub':
        final a = g.between(200, 900), b = g.between(5, a - 5);
        return g.choice(
          prompt: 'Subtract the decimals!',
          visual: TextVisual('${d(a)} − ${d(b)} = ?'),
          answer: d(a - b),
          wrong: {d(a - b + 10), d(a - b + 1), d((a - b - 10).abs()), d(a + b)}
            ..remove(d(a - b)),
          count: 4,
        );
      case 'times':
        final a = g.between(11, 999), k = g.one([10, 100]);
        return g.choice(
          prompt: 'Multiply by $k.',
          visual: TextVisual('${d(a)} × $k = ?'),
          answer: d(a * k),
          wrong: {d(a * k ~/ 10), d(a * k * 10), d(a + k * 100)}
            ..remove(d(a * k)),
          count: 4,
        );
      default:
        final a = g.between(1, 9) * 10, b = g.between(10, 99);
        final picks = [a, b]..shuffle(g.r);
        final bigger = max(a, b);
        if (a == b)
          return g.choice(
            prompt: 'Which is greater?',
            visual: const EmojiVisual('🔍'),
            answer: d(a),
            wrong: [d(a + 1)],
          );
        return g.choice(
          prompt: 'Which decimal is greater?',
          visual: TextVisual('${d(picks[0])}   or   ${d(picks[1])}'),
          answer: d(bigger),
          wrong: [d(min(a, b))],
        );
    }
  });
}

Color _color(int argb) => Color(argb);
