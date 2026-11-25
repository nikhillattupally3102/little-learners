import 'dart:math';

import 'package:flutter/material.dart';

/// Lays out [count] cells so they fill the available space as fully as
/// possible: it tries every column count and keeps the one with the largest cells.
class FitGrid extends StatelessWidget {
  const FitGrid({
    super.key,
    required this.count,
    required this.builder,
    this.aspect = 1,
    this.gap = 10,
    this.maxCell = double.infinity,
  });

  final int count;

  /// Builds cell [index] at the given [size].
  final Widget Function(BuildContext context, int index, Size size) builder;

  /// Cell width ÷ height.
  final double aspect;
  final double gap;

  /// Largest allowed cell width.
  final double maxCell;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        var bestCols = 1;
        var best = Size.zero;
        for (var cols = 1; cols <= count; cols++) {
          final rows = (count / cols).ceil();
          final cw = (c.maxWidth - (cols - 1) * gap) / cols;
          final ch = (c.maxHeight - (rows - 1) * gap) / rows;
          if (cw <= 0 || ch <= 0) continue;
          final w = min(min(cw, ch * aspect), maxCell);
          final size = Size(w, w / aspect);
          if (size.width * size.height > best.width * best.height) {
            best = size;
            bestCols = cols;
          }
        }
        final rows = (count / bestCols).ceil();
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var r = 0; r < rows; r++) ...[
                if (r > 0) SizedBox(height: gap),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (
                      var i = r * bestCols;
                      i < min(count, (r + 1) * bestCols);
                      i++
                    ) ...[
                      if (i > r * bestCols) SizedBox(width: gap),
                      SizedBox.fromSize(
                        size: best,
                        child: builder(context, i, best),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
