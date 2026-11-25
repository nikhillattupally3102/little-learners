import 'package:flutter/material.dart';

import '../models/models.dart';
import '../services/cloud.dart';
import '../state/progress.dart';
import '../theme.dart';
import '../widgets/backgrounds.dart';
import '../widgets/bubbly_button.dart';
import '../widgets/pic.dart';
import '../widgets/shape_icon.dart';
import 'feedback_inbox_screen.dart';

/// Grown-ups tell us what to improve. Works signed in or not, online or not.
class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  static const _kinds = [
    ('idea', '💡', 'An idea'),
    ('problem', '🐞', 'Something went wrong'),
    ('content', '📝', 'A worksheet or question'),
    ('love', '❤️', 'Something we love'),
  ];

  String _kind = 'idea';
  int? _rating;
  final _message = TextEditingController();
  late final _contact = TextEditingController(
    text: ProgressScope.read(context).accountEmail ?? '',
  );
  bool _sent = false;
  bool _admin = false;

  @override
  void initState() {
    super.initState();
    Cloud.instance.isFeedbackAdmin().then((v) {
      if (mounted && v) setState(() => _admin = true);
    }, onError: (_) {});
  }

  @override
  void dispose() {
    _message.dispose();
    _contact.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    await ProgressScope.read(context).sendFeedback(
      kind: _kind,
      rating: _rating,
      message: _message.text,
      contact: _contact.text,
      context: {'from': 'feedback_page'},
    );
    if (mounted) setState(() => _sent = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: BubblesBackground()),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 20, 0),
                  child: Row(
                    children: [
                      IconButton(
                        iconSize: 30,
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back_rounded),
                      ),
                      Expanded(
                        child: Text(
                          'Send feedback',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      if (_admin)
                        FilledButton.icon(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const FeedbackInboxScreen(),
                            ),
                          ),
                          icon: const Icon(Icons.inbox_rounded),
                          label: const Text('Inbox'),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 560),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 16,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: _sent ? _thanks() : _form(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _thanks() => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Pic('🎉', size: 64),
      const SizedBox(height: 12),
      const Text(
        'Thank you!',
        style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: 8),
      const Text(
        'We read every message and use it to make Little Learners better.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16),
      ),
      const SizedBox(height: 20),
      BubblyButton(
        color: AppColors.sky,
        onTap: () => setState(() {
          _sent = false;
          _message.clear();
          _rating = null;
        }),
        child: const Text(
          'Send more',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    ],
  );

  Widget _form() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: [
      const Text(
        'What would you like to tell us?',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: 12),
      Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          for (final (id, emoji, label) in _kinds)
            ChoiceChip(
              avatar: Pic(emoji, size: 18),
              label: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              selected: _kind == id,
              selectedColor: AppColors.lighter(AppColors.sky, .6),
              onSelected: (_) => setState(() => _kind = id),
            ),
        ],
      ),
      const SizedBox(height: 20),
      const Text(
        'How do you like Little Learners so far?',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 6),
      Row(
        children: [
          for (var i = 1; i <= 5; i++)
            IconButton(
              iconSize: 40,
              onPressed: () => setState(() => _rating = i),
              icon: ShapeIcon(
                ShapeKind.star,
                i <= (_rating ?? 0)
                    ? AppColors.sunshine
                    : const Color(0xFFE3E0EA),
                size: 36,
              ),
            ),
        ],
      ),
      const SizedBox(height: 12),
      TextField(
        controller: _message,
        minLines: 4,
        maxLines: 8,
        maxLength: 2000,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          hintText: switch (_kind) {
            'problem' => 'What happened? Which screen or worksheet?',
            'content' =>
              'Which worksheet or question? What was wrong or too hard/easy?',
            'love' => 'What does your child enjoy most?',
            _ => 'What should we add or change?',
          },
          border: const OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 8),
      TextField(
        controller: _contact,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
          labelText: 'Your email (optional — only if you want a reply)',
          border: OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 20),
      BubblyButton(
        color: _message.text.trim().isEmpty && _rating == null
            ? const Color(0xFFC9C5D3)
            : AppColors.mint,
        onTap: _message.text.trim().isEmpty && _rating == null ? null : _send,
        child: const Text(
          'Send feedback',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      const SizedBox(height: 8),
      const Text(
        "We'll see your child's grade and app version with your message — "
        'never names.',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black54, fontSize: 13),
      ),
    ],
  );
}
