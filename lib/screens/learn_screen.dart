import 'dart:math';

import '../widgets/pic.dart';

import 'package:flutter/material.dart';

import '../content/topics.dart';
import '../generators/topic_sheets.dart';
import '../models/generator.dart';
import '../models/models.dart';
import '../services/speaker.dart';
import '../state/progress.dart';
import '../theme.dart';
import '../widgets/backgrounds.dart';
import '../widgets/bubbly_button.dart';
import '../widgets/real_photo.dart';
import 'worksheet_screen.dart';

/// A learning session: swipe through picture cards about one topic (each
/// read aloud), then take a quiz on what you learned.
class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key, required this.topic, required this.level});
  final Topic topic;
  final Level level;

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  final _pages = PageController();
  int _index = 0;

  Topic get topic => widget.topic;

  /// Every session ends in a quiz — a short picture game for toddlers.
  bool get _toddler => widget.level.atMost(Level.age3);

  int get count => topic.items.length;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _speak());
  }

  @override
  void dispose() {
    Speaker.instance.stop();
    _pages.dispose();
    super.dispose();
  }

  void _speak() {
    if (!mounted) return;
    if (_index < count) {
      final item = topic.items[_index];
      final more = deeperFact(topic, item, widget.level);
      Speaker.instance.say([item.name, item.fact, ?more]);
    } else {
      Speaker.instance.say([
        _toddler
            ? 'You learned $count things! Let\'s play!'
            : 'You learned $count things about ${topic.title}! Ready for the quiz?',
      ]);
    }
  }

  void _go(int page) => _pages.animateToPage(
    page,
    duration: const Duration(milliseconds: 350),
    curve: Curves.easeOutCubic,
  );

  void _startQuiz() {
    final quiz = WorksheetGenerator.buildTopicQuiz(
      DateTime.now(),
      widget.level,
      topic,
      avoid: ProgressScope.read(context).recentlySeen(),
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => WorksheetScreen(worksheet: quiz)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final last = _index >= count;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: BubblesBackground(tint: topic.color)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      _RoundButton(
                        icon: Icons.close_rounded,
                        onTap: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: PicLabel(
                                '${topic.emoji}  ${topic.title}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: LinearProgressIndicator(
                                value: min(1, (_index + 1) / count),
                                minHeight: 12,
                                backgroundColor: Colors.white,
                                color: topic.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      PicLabel(
                        last ? '🎉' : '${_index + 1}/$count',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 12),
                      _RoundButton(
                        icon: Icons.volume_up_rounded,
                        color: AppColors.sky,
                        onTap: _speak,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: PageView.builder(
                      controller: _pages,
                      itemCount: count + 1,
                      onPageChanged: (i) {
                        setState(() => _index = i);
                        _speak();
                      },
                      itemBuilder: (context, i) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: i < count
                            ? _FactCard(
                                item: topic.items[i],
                                color: topic.color,
                                topic: topic,
                                more: deeperFact(
                                  topic,
                                  topic.items[i],
                                  widget.level,
                                ),
                              )
                            : _SummaryCard(topic: topic, toddler: _toddler),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_index > 0) ...[
                        BubblyButton(
                          color: Colors.white,
                          shadowColor: Colors.black12,
                          onTap: () => _go(_index - 1),
                          child: const Text(
                            '◀  Back',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                      ],
                      BubblyButton(
                        color: last ? AppColors.mint : topic.color,
                        onTap: last ? _startQuiz : () => _go(_index + 1),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 14,
                        ),
                        child: PicLabel(
                          last
                              ? (_toddler
                                    ? "Let's play! 🎈"
                                    : 'Start the quiz 🎓')
                              : 'Next  ▶',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
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

class _FactCard extends StatelessWidget {
  const _FactCard({
    required this.item,
    required this.color,
    required this.topic,
    this.more,
  });
  final TopicItem item;
  final Color color;
  final Topic topic;

  /// The "Did you know?" fact for older children.
  final String? more;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, c) {
      final emojiSize = min(c.maxHeight * (more == null ? .34 : .26), 200.0);
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(36),
          border: Border.all(color: AppColors.lighter(color, .4), width: 4),
          boxShadow: [
            BoxShadow(
              color: AppColors.lighter(color, .3),
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // The drawing, with a real-life photo beside it when we have one.
            Builder(
              builder: (context) {
                final photo = photoIdFor(topic, item);
                if (photo == null) {
                  return PopIn(child: Pic(item.emoji, size: emojiSize));
                }
                final w = c.maxWidth - 48;
                final draw = min(emojiSize * .8, w * .36);
                final photoW = min(emojiSize * 1.55, w * .55);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PopIn(child: Pic(item.emoji, size: draw)),
                    SizedBox(width: w * .05),
                    PopIn(
                      delay: const Duration(milliseconds: 150),
                      child: RealPhoto(photo, width: photoW),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: c.maxHeight * .04),
            // Letters and numbers are already shown big — no need to repeat.
            if (item.name != item.emoji)
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darker(color, .3),
                  ),
                ),
              ),
            if (item.picture != null) ...[
              const SizedBox(height: 8),
              PicText(item.picture!, size: min(c.maxHeight * .1, 80.0)),
            ],
            const SizedBox(height: 12),
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.lighter(color, .85),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        item.fact,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 22, height: 1.35),
                      ),
                      if (more != null) ...[
                        const SizedBox(height: 10),
                        Text(
                          'Did you know?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.darker(color, .35),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          more!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 19, height: 1.35),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.topic, this.toddler = false});
  final Topic topic;
  final bool toddler;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(36),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const PicLabel('🎉', style: TextStyle(fontSize: 72)),
        Text(
          'You learned ${topic.items.length} things!',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 16),
        Flexible(
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final i in topic.items)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Pic(i.emoji, size: 40),
                    Text(
                      i.name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          toddler
              ? "Great job! Now let's play! 🎈"
              : 'Now show what you know in the quiz!',
          style: const TextStyle(fontSize: 18),
        ),
      ],
    ),
  );
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({
    required this.icon,
    required this.onTap,
    this.color = AppColors.ink,
  });
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) => BubblyButton(
    color: Colors.white,
    shadowColor: Colors.black12,
    radius: 20,
    padding: const EdgeInsets.all(10),
    onTap: onTap,
    child: Icon(icon, size: 28, color: color),
  );
}
