import 'dart:math';

import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/models.dart';
import '../services/speaker.dart';
import '../state/progress.dart';
import '../theme.dart';
import '../widgets/backgrounds.dart';
import '../widgets/bubbly_button.dart';
import '../widgets/match_view.dart';
import '../widgets/pic.dart';
import '../widgets/scratch_pad.dart';
import '../widgets/shape_icon.dart';
import '../widgets/tracing_board.dart';
import '../widgets/visuals.dart';
import '../widgets/visuals_extra.dart' show ShadowEmoji;
import 'celebration_screen.dart';

const _praise = [
  ('Great job!', '🎉'),
  ('Awesome!', '🌟'),
  ('You did it!', '🥳'),
  ('Super!', '🚀'),
  ('Wow!', '🤩'),
  ('Brilliant!', '🌈'),
];

class WorksheetScreen extends StatefulWidget {
  const WorksheetScreen({super.key, required this.worksheet});
  final Worksheet worksheet;

  @override
  State<WorksheetScreen> createState() => _WorksheetScreenState();
}

class _WorksheetScreenState extends State<WorksheetScreen> {
  final _random = Random();
  int _index = 0;
  int _mistakes = 0;
  final _clock = Stopwatch();
  final Set<int> _wrong = {};
  int? _correct;
  String? _feedback;
  bool _feedbackGood = true;

  final _segment = ValueNotifier<int>(-1);
  final _readSegment = ValueNotifier<int>(-1);

  Worksheet get ws => widget.worksheet;
  Color get color => ws.color;

  @override
  void initState() {
    super.initState();
    _clock.start();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ProgressScope.read(context).markSeen(widget.worksheet.questions);
      _autoSpeak();
    });
  }

  @override
  void dispose() {
    Speaker.instance.stop();
    _segment.dispose();
    _readSegment.dispose();
    super.dispose();
  }

  /// Questions are only read aloud automatically for reading and listening
  /// tasks; everything else is silent until the 🔊 button is tapped.
  bool get _isListeningTask {
    final q = ws.questions[_index];
    // Toddlers can't read: every question is read aloud.
    if ((ws.level ?? Level.grade5).atMost(Level.age3)) return true;
    if (q is ExampleQuestion) return true;
    if (ws.kind.category == Category.reading ||
        ws.kind == WorksheetKind.animalSounds)
      return true;
    if (ws.kind == WorksheetKind.topicQuiz &&
        (ws.level ?? Level.grade5).atMost(Level.kindergarten))
      return true;
    return q is ChoiceQuestion &&
        (q.visual is ListenVisual || q.visual is SoundOutVisual);
  }

  void _autoSpeak() {
    if (mounted && _isListeningTask) _speakQuestion();
  }

  void _speakQuestion() {
    if (!mounted) return;
    final q = ws.questions[_index];
    if (q is ChoiceQuestion &&
        q.visual is PassageVisual &&
        (q.visual as PassageVisual).readFirst) {
      final sentences = (q.visual as PassageVisual).sentences;
      _readAloud([...sentences, ...q.speechSegments]);
      return;
    }
    final segments = switch (q) {
      ChoiceQuestion() => q.speechSegments,
      TraceQuestion() => [q.speech],
      MatchQuestion() => [q.prompt],
      ExampleQuestion() => [q.title, ...q.steps],
    };
    _segment.value = -1;
    _readSegment.value = -1;
    Speaker.instance.say(
      segments,
      onSegment: (i) {
        if (mounted) _segment.value = i;
      },
    );
  }

  /// Reads a passage aloud, highlighting each sentence as it is spoken.
  void _readAloud(List<String> sentences) {
    _readSegment.value = -1;
    Speaker.instance.say(
      sentences,
      onSegment: (i) {
        if (mounted) _readSegment.value = i;
      },
    );
  }

  void _mistake() {
    HapticFeedback.heavyImpact();
    setState(() {
      _mistakes++;
      _feedback = 'Oops! Try again 💪';
      _feedbackGood = false;
    });
    Speaker.instance.say(['Oops! Try again!']);
  }

  void _pick(int i) {
    final q = ws.questions[_index] as ChoiceQuestion;
    if (_correct != null || _wrong.contains(i)) return;
    if (i == q.answer) {
      HapticFeedback.mediumImpact();
      _succeed(() => _correct = i);
    } else {
      setState(() => _wrong.add(i));
      _mistake();
    }
  }

  void _succeed([VoidCallback? extra]) {
    final (words, emoji) = _praise[_random.nextInt(_praise.length)];
    setState(() {
      extra?.call();
      _feedback = '$words $emoji';
      _feedbackGood = true;
    });
    Speaker.instance.say([words]);
    Future.delayed(const Duration(milliseconds: 1400), _next);
  }

  void _next() {
    if (!mounted) return;
    if (_index + 1 >= ws.questions.length) {
      // Longer worksheets allow a slip or two before losing a star.
      // Worked examples aren't scored.
      final n = ws.questions.where((q) => q is! ExampleQuestion).length;
      final stars = _mistakes <= (n >= 8 ? 1 : 0)
          ? 3
          : _mistakes <= max(2, (n * .4).round())
          ? 2
          : 1;
      final category = ws.kind == WorksheetKind.topicQuiz
          ? null
          : ws.kind.category;
      ProgressScope.read(context)
          .complete(
            ws.id,
            stars,
            category: category,
            kind: ws.kind.name,
            level: ws.level,
            questions: n,
            mistakes: _mistakes,
            seconds: _clock.elapsed.inSeconds,
          )
          .then((change) {
            if (!mounted) return;
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => CelebrationScreen(
                  worksheet: ws,
                  stars: stars,
                  levelChange: change,
                ),
              ),
            );
          });
      return;
    }
    setState(() {
      _index++;
      _wrong.clear();
      _correct = null;
      _feedback = null;
    });
    _autoSpeak();
  }

  /// Rough-work paper next to maths questions from Grade 1 up.
  bool _padOpen = true;

  bool _padAllowed(Question q) {
    final level = ws.level ?? ProgressScope.read(context).active?.level;
    return q is ChoiceQuestion &&
        ws.kind.category == Category.math &&
        level != null &&
        level.atLeast(Level.grade1);
  }

  Widget _withPad(Question q, Widget card) {
    if (!_padAllowed(q) || !_padOpen) return card;
    return LayoutBuilder(
      builder: (context, c) {
        final pad = ScratchPad(
          key: ValueKey('pad$_index'),
          accent: color,
          onToggle: () => setState(() => _padOpen = false),
        );
        final wide = c.maxWidth >= 800 && c.maxWidth > c.maxHeight * 1.05;
        return wide
            ? Row(
                children: [
                  Expanded(flex: 3, child: card),
                  const SizedBox(width: 16),
                  Expanded(flex: 2, child: pad),
                ],
              )
            : Column(
                children: [
                  Expanded(flex: 3, child: card),
                  const SizedBox(height: 12),
                  Expanded(flex: 2, child: pad),
                ],
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final q = ws.questions[_index];
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: BubblesBackground(tint: color)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _TopBar(
                    ws: ws,
                    index: _index,
                    done: _correct != null,
                    onSpeak: _speakQuestion,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _withPad(
                      q,
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        transitionBuilder: (child, anim) => SlideTransition(
                          position:
                              Tween(
                                begin: const Offset(1, 0),
                                end: Offset.zero,
                              ).animate(
                                CurvedAnimation(
                                  parent: anim,
                                  curve: Curves.easeOutBack,
                                ),
                              ),
                          child: child,
                        ),
                        child: KeyedSubtree(
                          key: ValueKey(_index),
                          child: _Card(
                            child: switch (q) {
                              ChoiceQuestion() => _ChoiceView(
                                q: q,
                                color: color,
                                wrong: _wrong,
                                correct: _correct,
                                onPick: _pick,
                                segment: _segment,
                                onReplay: _speakQuestion,
                                readSegment: _readSegment,
                                onReadAloud: _readAloud,
                              ),
                              MatchQuestion() => MatchView(
                                question: q,
                                accent: color,
                                onMistake: _mistake,
                                onPair: () {
                                  HapticFeedback.mediumImpact();
                                  setState(() {
                                    _feedback = 'Yes! 👍';
                                    _feedbackGood = true;
                                  });
                                  Speaker.instance.say(['Yes!']);
                                },
                                onDone: _succeed,
                              ),
                              ExampleQuestion() => _ExampleView(
                                q: q,
                                color: color,
                                segment: _segment,
                                onReplay: _speakQuestion,
                                readSegment: _readSegment,
                                onReadAloud: _readAloud,
                                onDone: () {
                                  Speaker.instance.stop();
                                  _next();
                                },
                              ),
                              TraceQuestion() => TracingBoard(
                                glyph: q.glyph,
                                hint: q.hint,
                                color: color,
                                onDone: () {
                                  if (_feedback == null) _succeed();
                                },
                              ),
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 64,
                    child: _padAllowed(q) && !_padOpen && _feedback == null
                        ? Align(
                            alignment: Alignment.centerRight,
                            child: FilledButton.tonalIcon(
                              onPressed: () => setState(() => _padOpen = true),
                              icon: const Icon(Icons.edit_rounded),
                              label: const Text(
                                'Rough work',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          )
                        : AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            transitionBuilder: (c, a) =>
                                ScaleTransition(scale: a, child: c),
                            child: _feedback == null
                                ? const SizedBox.shrink()
                                : Center(
                                    key: ValueKey('$_feedback$_mistakes'),
                                    child: PicLabel(
                                      _feedback!,
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w700,
                                        color: _feedbackGood
                                            ? AppColors.darker(
                                                AppColors.mint,
                                                .1,
                                              )
                                            : AppColors.tangerine,
                                      ),
                                    ),
                                  ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.ws,
    required this.index,
    required this.done,
    required this.onSpeak,
  });
  final Worksheet ws;
  final int index;
  final bool done;
  final VoidCallback onSpeak;

  @override
  Widget build(BuildContext context) {
    final total = ws.questions.length;
    return Row(
      children: [
        BubblyButton(
          color: Colors.white,
          shadowColor: Colors.black12,
          radius: 20,
          padding: const EdgeInsets.all(10),
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(
            Icons.close_rounded,
            size: 28,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PicLabel(
                '${ws.emoji}  ${ws.title}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(end: (index + (done ? 1 : 0)) / total),
                  duration: const Duration(milliseconds: 400),
                  builder: (_, v, _) => LinearProgressIndicator(
                    value: v,
                    minHeight: 14,
                    backgroundColor: Colors.white,
                    color: ws.color,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 14),
        Text(
          '${index + 1}/$total',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        const SizedBox(width: 14),
        BubblyButton(
          color: Colors.white,
          shadowColor: Colors.black12,
          radius: 20,
          padding: const EdgeInsets.all(10),
          onTap: onSpeak,
          child: const Icon(
            Icons.volume_up_rounded,
            size: 28,
            color: AppColors.sky,
          ),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: .92),
      borderRadius: BorderRadius.circular(36),
      boxShadow: const [
        BoxShadow(
          color: Color(0x1A000000),
          blurRadius: 24,
          offset: Offset(0, 10),
        ),
      ],
    ),
    child: child,
  );
}

/// "Let's learn!": a worked example, read aloud step by step, before the
/// practice questions. Each step lights up as it is spoken.
class _ExampleView extends StatelessWidget {
  const _ExampleView({
    required this.q,
    required this.color,
    required this.segment,
    required this.onReplay,
    required this.readSegment,
    required this.onReadAloud,
    required this.onDone,
  });
  final ExampleQuestion q;
  final Color color;
  final ValueListenable<int> segment;
  final VoidCallback onReplay;
  final ValueListenable<int> readSegment;
  final void Function(List<String>) onReadAloud;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: .15),
            borderRadius: BorderRadius.circular(99),
          ),
          child: PicLabel(
            "💡 Let's learn!",
            style: text.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          q.title,
          textAlign: TextAlign.center,
          style: text.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Center(
            child: QuestionVisual(
              q.visual,
              accent: color,
              segment: segment,
              onReplay: onReplay,
              readSegment: readSegment,
              onReadAloud: onReadAloud,
            ),
          ),
        ),
        const SizedBox(height: 10),
        ValueListenableBuilder<int>(
          valueListenable: segment,
          builder: (context, spoken, _) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final (i, step) in q.steps.indexed)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    // Segment 0 is the title; steps follow.
                    color: spoken == i + 1
                        ? color.withValues(alpha: .22)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: color.withValues(alpha: .35)),
                  ),
                  child: Text(
                    '${i + 1}.  $step',
                    style: text.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        FilledButton.icon(
          onPressed: onDone,
          style: FilledButton.styleFrom(
            backgroundColor: color,
            minimumSize: const Size(220, 56),
            textStyle: const TextStyle(
              fontFamily: 'Fredoka',
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          icon: const Icon(Icons.thumb_up_alt_rounded),
          label: const Text("Got it! Let's practice"),
        ),
      ],
    );
  }
}

class _ChoiceView extends StatelessWidget {
  const _ChoiceView({
    required this.q,
    required this.color,
    required this.wrong,
    required this.correct,
    required this.onPick,
    required this.segment,
    required this.onReplay,
    required this.readSegment,
    required this.onReadAloud,
  });
  final ChoiceQuestion q;
  final Color color;
  final Set<int> wrong;
  final int? correct;
  final ValueChanged<int> onPick;
  final ValueListenable<int> segment;
  final VoidCallback onReplay;
  final ValueListenable<int> readSegment;
  final void Function(List<String>) onReadAloud;

  _ChoiceState _state(int i) => correct == i
      ? _ChoiceState.correct
      : wrong.contains(i)
      ? _ChoiceState.wrong
      : _ChoiceState.idle;

  @override
  Widget build(BuildContext context) {
    // Picture answers (even a group like 🍎🍎🍎) stay big square buttons.
    final longest = q.choices
        .map(
          (c) =>
              c.label == null ||
                  Pic.has(c.label!) ||
                  c.label!.characters.every(Pic.has)
              ? 0
              : c.label!.characters.length,
        )
        .reduce(max);
    final wide = longest > 4;
    final text = Theme.of(context).textTheme;
    final passage = q.visual is PassageVisual;
    return Column(
      children: [
        if (!passage) ...[
          Text(
            q.prompt,
            textAlign: TextAlign.center,
            style:
                (q.prompt.length > 40 ? text.titleLarge : text.headlineMedium)
                    ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
        ],
        Expanded(
          flex: passage ? 3 : 1,
          child: Center(
            child: QuestionVisual(
              q.visual,
              accent: color,
              segment: segment,
              onReplay: onReplay,
              readSegment: readSegment,
              onReadAloud: onReadAloud,
            ),
          ),
        ),
        if (passage) ...[
          const SizedBox(height: 12),
          Text(
            q.prompt,
            textAlign: TextAlign.center,
            style: text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
        const SizedBox(height: 14),
        LayoutBuilder(
          builder: (context, c) {
            final n = q.choices.length;
            if (wide) {
              final columns = longest > 16 ? 1 : 2;
              final w = (c.maxWidth - (columns - 1) * 12) / columns;
              return Wrap(
                spacing: 12,
                runSpacing: 4,
                alignment: WrapAlignment.center,
                children: [
                  for (var i = 0; i < n; i++)
                    _ChoiceButton(
                      choice: q.choices[i],
                      width: w,
                      height: columns == 1 ? 60 : 68,
                      accent: color,
                      state: _state(i),
                      onTap: () => onPick(i),
                    ),
                ],
              );
            }
            // One row of big buttons; on narrow screens with 4+ answers,
            // two rows so the pictures stay large.
            var size = min(150.0, (c.maxWidth - (n - 1) * 14) / n);
            if (n >= 4 && size < 100) {
              size = min(140.0, (c.maxWidth - 14) / 2);
            }
            return Wrap(
              alignment: WrapAlignment.center,
              spacing: 14,
              runSpacing: 14,
              children: [
                for (var i = 0; i < n; i++)
                  _ChoiceButton(
                    choice: q.choices[i],
                    width: size,
                    height: size,
                    accent: color,
                    state: _state(i),
                    onTap: () => onPick(i),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

enum _ChoiceState { idle, correct, wrong }

class _ChoiceButton extends StatefulWidget {
  const _ChoiceButton({
    required this.choice,
    required this.width,
    required this.height,
    required this.accent,
    required this.state,
    required this.onTap,
  });
  final Choice choice;
  final double width;
  final double height;
  final Color accent;
  final _ChoiceState state;
  final VoidCallback onTap;

  @override
  State<_ChoiceButton> createState() => _ChoiceButtonState();
}

class _ChoiceButtonState extends State<_ChoiceButton>
    with SingleTickerProviderStateMixin {
  late final _shake = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 450),
  );

  @override
  void didUpdateWidget(_ChoiceButton old) {
    super.didUpdateWidget(old);
    if (widget.state == _ChoiceState.wrong && old.state != _ChoiceState.wrong) {
      _shake.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _shake.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.choice;
    final s = min(widget.width, widget.height);
    final square = widget.width == widget.height;
    final textColor = widget.state == _ChoiceState.correct
        ? Colors.white
        : AppColors.ink;
    final bg = switch (widget.state) {
      _ChoiceState.correct => AppColors.mint,
      _ChoiceState.wrong => const Color(0xFFE9E6EF),
      _ChoiceState.idle => Colors.white,
    };
    final content = c.shape != null
        ? ShapeIcon(c.shape!, c.color!, size: s * .62)
        : square && !c.silhouette && Pic.has(c.label!)
        // A single drawing fills the button.
        ? Transform.scale(
            scale: c.scale,
            child: Pic(c.label!.trim(), size: s * .66),
          )
        : square &&
              c.label!.characters.length > 1 &&
              c.label!.characters.every(Pic.has)
        // A group of pictures to count: a neat grid filling the button.
        ? FittedBox(
            child: _PicGroup(c.label!.characters.toList(), size: s * .7),
          )
        : square
        ? Transform.scale(
            scale: c.scale,
            child: FittedBox(
              child: c.silhouette
                  ? ShadowEmoji(c.label!, size: s * .5)
                  : PicText(
                      c.label!,
                      // A single letter or number fills the button.
                      size: c.label!.characters.length <= 2 ? s * .42 : 44,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
            ),
          )
        : FittedBox(
            fit: BoxFit.scaleDown,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: widget.width - 24),
              child: c.label!.characters.every(Pic.has)
                  ? PicText(c.label!, size: widget.height * .42)
                  : Text(
                      c.label!,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                        height: 1.15,
                      ),
                    ),
            ),
          );

    return AnimatedBuilder(
      animation: _shake,
      builder: (context, child) => Transform.translate(
        offset: Offset(sin(_shake.value * pi * 6) * 12 * (1 - _shake.value), 0),
        child: child,
      ),
      child: AnimatedScale(
        scale: widget.state == _ChoiceState.correct
            ? (square ? 1.15 : 1.04)
            : 1,
        duration: const Duration(milliseconds: 350),
        curve: Curves.elasticOut,
        child: Opacity(
          opacity: widget.state == _ChoiceState.wrong ? .5 : 1,
          child: BubblyButton(
            color: bg,
            shadowColor: widget.state == _ChoiceState.idle
                ? AppColors.lighter(widget.accent, .3)
                : AppColors.darker(bg, .15),
            radius: square ? s * .3 : 22,
            padding: EdgeInsets.zero,
            onTap: widget.onTap,
            child: Container(
              width: widget.width,
              height: widget.height,
              alignment: Alignment.center,
              padding: square
                  ? EdgeInsets.all(
                      c.label != null && Pic.has(c.label!) ? s * .04 : s * .14,
                    )
                  : const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(square ? s * .3 : 22),
                border: Border.all(
                  color: widget.state == _ChoiceState.idle
                      ? AppColors.lighter(widget.accent, .3)
                      : bg,
                  width: 3,
                ),
              ),
              child: content,
            ),
          ),
        ),
      ),
    );
  }
}

/// A few pictures laid out in a small grid (e.g. three apples to count).
class _PicGroup extends StatelessWidget {
  const _PicGroup(this.pics, {required this.size});
  final List<String> pics;
  final double size;

  @override
  Widget build(BuildContext context) {
    final cols = pics.length <= 2 ? pics.length : (pics.length <= 4 ? 2 : 3);
    final cell = size / cols;
    return SizedBox(
      width: size,
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          for (final p in pics)
            SizedBox.square(
              dimension: cell,
              child: Center(child: Pic(p, size: cell * .62)),
            ),
        ],
      ),
    );
  }
}
