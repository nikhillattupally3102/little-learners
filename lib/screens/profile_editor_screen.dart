import 'dart:math';

import 'package:flutter/material.dart';

import '../widgets/pic.dart';

import '../models/models.dart';
import '../state/progress.dart';
import '../theme.dart';
import '../widgets/backgrounds.dart';
import '../widgets/bubbly_button.dart';
import '../widgets/fit_grid.dart';

const _avatars = [
  '🦁',
  '🐼',
  '🐨',
  '🦊',
  '🐸',
  '🐵',
  '🦄',
  '🐯',
  '🐰',
  '🐻',
  '🐙',
  '🦖',
  '🐧',
  '🐶',
  '🐱',
  '🦋',
  '🐷',
  '🐮',
  '🦒',
  '🐳',
];

/// Create or edit a learner. With [profile] null, a new learner is created.
///
/// The layout fills the screen without scrolling: one column on phones,
/// two columns on wide screens. It only scrolls on very short screens.
class ProfileEditorScreen extends StatefulWidget {
  const ProfileEditorScreen({super.key, this.profile, this.firstRun = false});
  final Profile? profile;

  /// The very first profile: shown as the app's welcome screen.
  final bool firstRun;

  @override
  State<ProfileEditorScreen> createState() => _ProfileEditorScreenState();
}

class _ProfileEditorScreenState extends State<ProfileEditorScreen> {
  late final _name = TextEditingController(text: widget.profile?.name ?? '');
  late String _avatar = widget.profile?.avatar ?? _avatars.first;
  late int _color = widget.profile?.colorIndex ?? 0;
  late Level _level = widget.profile?.level ?? Level.preK;

  bool get _editing => widget.profile != null;
  Color get _accent =>
      AppColors.profileColors[_color % AppColors.profileColors.length];

  @override
  void initState() {
    super.initState();
    _name.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final progress = ProgressScope.read(context);
    final name = _name.text.trim();
    final profile =
        (widget.profile ??
                Profile(
                  id: Progress.newId(),
                  name: name,
                  avatar: _avatar,
                  colorIndex: _color,
                  level: _level,
                ))
            .copyWith(
              name: name,
              avatar: _avatar,
              colorIndex: _color,
              level: _level,
            );
    await progress.saveProfile(profile, makeActive: widget.firstRun);
    if (mounted && Navigator.of(context).canPop()) Navigator.of(context).pop();
  }

  Future<void> _delete() async {
    final p = widget.profile!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cream,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: Text('Delete ${p.name}?'),
        content: const Text(
          "Their stars, streak and progress will be removed. This can't be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFE5484D),
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    await ProgressScope.read(context).deleteProfile(p);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The keyboard covers the lower sections instead of squashing the layout.
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(child: BubblesBackground(tint: _accent)),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, c) {
                const minHeight = 560.0;
                final wide =
                    c.maxWidth > 760 && c.maxWidth > c.maxHeight * 1.15;
                final pad = c.maxWidth < 400 ? 12.0 : 20.0;
                final height = max(c.maxHeight, minHeight);
                return SingleChildScrollView(
                  physics: c.maxHeight < minHeight
                      ? null
                      : const NeverScrollableScrollPhysics(),
                  child: SizedBox(
                    height: height,
                    child: Padding(
                      padding: EdgeInsets.all(pad),
                      child: wide ? _wideLayout(height) : _tallLayout(height),
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

  Widget _tallLayout(double height) {
    final preview = (height * .11).clamp(60.0, 120.0);
    return Column(
      children: [
        _topBar(),
        const SizedBox(height: 10),
        Row(
          children: [
            _preview(preview),
            const SizedBox(width: 14),
            Expanded(child: _nameField()),
          ],
        ),
        const SizedBox(height: 10),
        const _Label('Pick a buddy'),
        Expanded(flex: 4, child: _buddies()),
        const SizedBox(height: 8),
        const _Label('Favourite colour'),
        Expanded(flex: 2, child: _colors()),
        const SizedBox(height: 8),
        const _Label('Age or grade'),
        Expanded(flex: 5, child: _levels(short: height < 720)),
        const SizedBox(height: 10),
        _actions(),
      ],
    );
  }

  Widget _wideLayout(double height) {
    return Column(
      children: [
        _topBar(),
        const SizedBox(height: 12),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: _preview((height * .2).clamp(90.0, 170.0)),
                      ),
                    ),
                    _nameField(),
                    const SizedBox(height: 12),
                    const _Label('Pick a buddy'),
                    Expanded(flex: 5, child: _buddies()),
                  ],
                ),
              ),
              const SizedBox(width: 28),
              Expanded(
                flex: 6,
                child: Column(
                  children: [
                    const _Label('Favourite colour'),
                    Expanded(flex: 2, child: _colors()),
                    const SizedBox(height: 10),
                    const _Label('Age or grade'),
                    Expanded(flex: 4, child: _levels()),
                    const SizedBox(height: 12),
                    _actions(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _topBar() => Row(
    children: [
      if (Navigator.of(context).canPop()) ...[
        BubblyButton(
          color: Colors.white,
          shadowColor: Colors.black12,
          radius: 20,
          padding: const EdgeInsets.all(8),
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(
            Icons.arrow_back_rounded,
            size: 26,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(width: 12),
      ],
      Expanded(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            widget.firstRun
                ? 'Welcome to Little Learners!'
                : _editing
                ? 'Edit learner'
                : 'New learner',
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
      ),
    ],
  );

  Widget _preview(double size) => AnimatedContainer(
    duration: const Duration(milliseconds: 250),
    width: size,
    height: size,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: _accent,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(color: AppColors.darker(_accent), offset: const Offset(0, 5)),
      ],
    ),
    child: PicLabel(_avatar, style: TextStyle(fontSize: size * .58)),
  );

  Widget _nameField() => TextField(
    controller: _name,
    textCapitalization: TextCapitalization.words,
    maxLength: 16,
    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
    decoration: InputDecoration(
      hintText: "Child's name",
      counterText: '',
      filled: true,
      fillColor: Colors.white,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
    ),
  );

  Widget _buddies() => FitGrid(
    count: _avatars.length,
    gap: 8,
    maxCell: 84,
    builder: (context, i, size) {
      final a = _avatars[i];
      final selected = a == _avatar;
      return GestureDetector(
        onTap: () => setState(() => _avatar = a),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.lighter(_accent, .6) : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: selected ? _accent : Colors.transparent,
              width: 3,
            ),
          ),
          child: Pic(a, size: size.width * .5),
        ),
      );
    },
  );

  Widget _colors() => FitGrid(
    count: AppColors.profileColors.length,
    gap: 8,
    maxCell: 60,
    builder: (context, i, size) {
      final selected = i == _color;
      final c = AppColors.profileColors[i];
      return GestureDetector(
        onTap: () => setState(() => _color = i),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: c,
            shape: BoxShape.circle,
            border: Border.all(
              color: selected ? AppColors.ink : Colors.white,
              width: selected ? 4 : 3,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.darker(c).withValues(alpha: .5),
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: selected
              ? Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: size.width * .55,
                )
              : null,
        ),
      );
    },
  );

  /// On short screens the buttons are wide and flat, with the icon beside the text.
  Widget _levels({bool short = false}) => FitGrid(
    count: Level.values.length,
    aspect: short ? 2.8 : 1.7,
    gap: short ? 8 : 10,
    maxCell: 220,
    builder: (context, i, size) {
      final l = Level.values[i];
      final selected = l == _level;
      final label = Text(
        l.title,
        style: TextStyle(
          fontSize: short ? 15 : max(12, size.height * .2),
          fontWeight: FontWeight.w700,
          color: selected ? Colors.white : AppColors.ink,
        ),
      );
      final emoji = PicLabel(
        l.emoji,
        style: TextStyle(fontSize: short ? 20 : size.height * .34),
      );
      return BubblyButton(
        color: selected ? _accent : Colors.white,
        shadowColor: selected ? null : Colors.black12,
        radius: 16,
        depth: 4,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        onTap: () => setState(() => _level = l),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: short
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [emoji, const SizedBox(width: 6), label],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [emoji, label],
                  ),
          ),
        ),
      );
    },
  );

  Widget _actions() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      if (_editing) ...[
        TextButton.icon(
          onPressed: _delete,
          icon: const Icon(
            Icons.delete_outline_rounded,
            color: Color(0xFFE5484D),
          ),
          label: const Text(
            'Delete',
            style: TextStyle(
              color: Color(0xFFE5484D),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 16),
      ],
      BubblyButton(
        color: AppColors.mint,
        onTap: _name.text.trim().isEmpty ? null : _save,
        padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 14),
        child: PicLabel(
          widget.firstRun ? "Let's go! 🚀" : 'Save',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    ],
  );
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerLeft,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 4),
      child: Text(
        text,
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
      ),
    ),
  );
}
