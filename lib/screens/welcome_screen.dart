import 'package:flutter/material.dart';

import '../state/progress.dart';
import '../theme.dart';
import '../widgets/backgrounds.dart';
import '../widgets/bubbly_button.dart';
import '../widgets/pic.dart';
import 'account_screen.dart';
import '../widgets/privacy_link.dart';

/// First launch: a grown-up signs in, creates a family account, or tries the
/// app without one (they can sign in later from Grown-ups).
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const _friends = ['🦁', '🐼', '🦊', '🐸', '🦄', '🐙', '🐧', '🦒'];

  void _account(BuildContext context, {required bool create}) =>
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) =>
              AccountScreen(startCreating: create, closeWhenSignedIn: true),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final progress = ProgressScope.of(context);
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: BubblesBackground()),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, c) {
                final wide = c.maxWidth > c.maxHeight && c.maxWidth >= 700;
                final art = _Art(
                  size: wide ? c.maxHeight * .5 : c.maxHeight * .26,
                );
                final actions = _Actions(
                  onSignIn: () => _account(context, create: false),
                  onCreate: () => _account(context, create: true),
                  onSkip: progress.finishWelcome,
                );
                return Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: wide
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(child: art),
                              const SizedBox(width: 48),
                              ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 440,
                                ),
                                child: actions,
                              ),
                            ],
                          )
                        : ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 480),
                            child: Column(
                              children: [
                                art,
                                const SizedBox(height: 24),
                                actions,
                              ],
                            ),
                          ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Art extends StatelessWidget {
  const _Art({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: size * 1.2,
    height: size,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: size * .78,
          height: size * .78,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
        PopIn(child: Pic('🦉', size: size * .4)),
        for (var i = 0; i < WelcomeScreen._friends.length; i++)
          Align(
            alignment: Alignment(1.0 * _ring[i].$1, 1.0 * _ring[i].$2),
            child: PopIn(
              delay: Duration(milliseconds: 120 + 70 * i),
              child: Pic(WelcomeScreen._friends[i], size: size * .12),
            ),
          ),
      ],
    ),
  );

  static const _ring = [
    (-0.95, -0.55),
    (-0.45, -0.98),
    (0.45, -0.98),
    (0.95, -0.55),
    (0.95, 0.55),
    (0.45, 0.98),
    (-0.45, 0.98),
    (-0.95, 0.55),
  ];
}

class _Actions extends StatelessWidget {
  const _Actions({
    required this.onSignIn,
    required this.onCreate,
    required this.onSkip,
  });
  final VoidCallback onSignIn;
  final VoidCallback onCreate;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    Widget button(String label, Color color, VoidCallback onTap) =>
        BubblyButton(
          color: color,
          onTap: onTap,
          child: SizedBox(
            width: double.infinity,
            child: PicLabel(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        );
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Welcome to\nLittle Learners!',
          textAlign: TextAlign.center,
          style: text.headlineLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        const Text(
          'Daily worksheets and learning for ages 2 to Grade 5.\n'
          'Grown-ups: sign in to keep your children\'s progress safe '
          'and use it on every iPad and computer.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, height: 1.4),
        ),
        const SizedBox(height: 28),
        button('Sign in', AppColors.sky, onSignIn),
        const SizedBox(height: 14),
        button('Create a family account', AppColors.mint, onCreate),
        const SizedBox(height: 14),
        TextButton(
          onPressed: onSkip,
          child: const Text(
            'Try without an account',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          ),
        ),
        const Text(
          'You can sign in later from 👪 Grown-ups.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54),
        ),
        const PrivacyLink(),
      ],
    );
  }
}
