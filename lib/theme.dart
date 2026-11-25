import 'package:flutter/material.dart';

/// Bright, friendly palette used everywhere in the app.
class AppColors {
  static const bubblegum = Color(0xFFFF5D8F);
  static const tangerine = Color(0xFFFF8C42);
  static const sunshine = Color(0xFFFFC93C);
  static const lime = Color(0xFF8BD346);
  static const mint = Color(0xFF2ED8A3);
  static const sky = Color(0xFF3FA9F5);
  static const grape = Color(0xFF8E5CF7);
  static const cream = Color(0xFFFFF8EC);
  static const ink = Color(0xFF2D2A4A);

  static const palette = [
    bubblegum,
    tangerine,
    sunshine,
    lime,
    mint,
    sky,
    grape,
  ];

  /// Favourite-colour choices for profiles. The first seven match [palette]
  /// so profiles saved earlier keep their colour.
  static const profileColors = [
    ...palette,
    Color(0xFFFF4757), // red
    Color(0xFFFF7F6B), // coral
    Color(0xFFF4B400), // gold
    Color(0xFF2ECC71), // green
    Color(0xFF14B8A6), // teal
    Color(0xFF22C3E6), // cyan
    Color(0xFF3B6CF6), // blue
    Color(0xFF5B5BD6), // indigo
    Color(0xFFD946EF), // magenta
    Color(0xFFFF8FC7), // pink
    Color(0xFFB07A4F), // brown
    Color(0xFF64748B), // slate
    Color(0xFF2D2A4A), // night
  ];

  static Color darker(Color c, [double amount = .22]) =>
      Color.lerp(c, Colors.black, amount)!;
  static Color lighter(Color c, [double amount = .75]) =>
      Color.lerp(c, Colors.white, amount)!;
}

ThemeData buildTheme() {
  final base = ThemeData(
    useMaterial3: true,
    fontFamily: 'Fredoka',
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.grape),
    scaffoldBackgroundColor: AppColors.cream,
  );
  return base.copyWith(
    textTheme: base.textTheme.apply(
      bodyColor: AppColors.ink,
      displayColor: AppColors.ink,
      // Prefer full-colour emoji over monochrome symbol fonts.
      fontFamilyFallback: const ['Apple Color Emoji', 'Noto Color Emoji'],
    ),
  );
}
