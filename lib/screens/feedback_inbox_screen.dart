import 'package:flutter/material.dart';

import '../models/models.dart';
import '../services/cloud.dart';
import '../theme.dart';
import '../widgets/backgrounds.dart';
import '../widgets/pic.dart';

/// Admin-only: everything families sent, plus what kids think of each
/// worksheet kind. Readable only by emails in `feedback_admins`.
class FeedbackInboxScreen extends StatefulWidget {
  const FeedbackInboxScreen({super.key});

  @override
  State<FeedbackInboxScreen> createState() => _FeedbackInboxScreenState();
}

class _FeedbackInboxScreenState extends State<FeedbackInboxScreen> {
  List<Map<String, dynamic>>? _rows;
  String? _error;
  bool _onlyNew = true;

  static const _kindEmoji = {
    'idea': '💡',
    'problem': '🐞',
    'content': '📝',
    'love': '❤️',
    'reaction': '🙂',
  };

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final rows = await Cloud.instance.fetchFeedback();
      if (mounted) setState(() => _rows = rows);
    } catch (e) {
      if (mounted) setState(() => _error = '$e');
    }
  }

  Future<void> _setStatus(Map<String, dynamic> row, String status) async {
    await Cloud.instance.setFeedbackStatus((row['id'] as num).toInt(), status);
    setState(() => row['status'] = status);
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
                          'Feedback inbox',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      IconButton(
                        onPressed: _load,
                        icon: const Icon(Icons.refresh_rounded),
                      ),
                    ],
                  ),
                ),
                Expanded(child: _body()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _body() {
    if (_error != null) {
      return Center(child: Text("Couldn't load feedback: $_error"));
    }
    final rows = _rows;
    if (rows == null) return const Center(child: CircularProgressIndicator());
    final messages = [
      for (final r in rows)
        if (r['kind'] != 'reaction' && (!_onlyNew || r['status'] == 'new')) r,
    ];
    return LayoutBuilder(
      builder: (context, c) {
        final wide = c.maxWidth >= 900;
        final summary = [_weekSummary(rows), _reactions(rows)];
        final list = [
          Row(
            children: [
              const Text(
                'Messages',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              FilterChip(
                label: const Text('Only new'),
                selected: _onlyNew,
                onSelected: (v) => setState(() => _onlyNew = v),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (messages.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Text('Nothing here. 🎉', textAlign: TextAlign.center),
            ),
          for (final r in messages) _message(r),
        ];
        if (!wide) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [...summary, ...list],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 400,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 10, 32),
                children: summary,
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(10, 8, 20, 32),
                children: list,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _card(String title, Widget child) => Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      boxShadow: const [
        BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        child,
      ],
    ),
  );

  static DateTime _time(Map<String, dynamic> r) =>
      DateTime.parse(r['created_at'] as String).toLocal();

  Widget _weekSummary(List<Map<String, dynamic>> rows) {
    final week = rows
        .where((r) => DateTime.now().difference(_time(r)).inDays < 7)
        .toList();
    final today = week
        .where((r) => DateTime.now().difference(_time(r)).inHours < 24)
        .length;
    final ratings = [
      for (final r in week)
        if (r['kind'] != 'reaction' && r['rating'] != null)
          (r['rating'] as num).toInt(),
    ];
    final avg = ratings.isEmpty
        ? '–'
        : (ratings.reduce((a, b) => a + b) / ratings.length).toStringAsFixed(1);
    final byKind = <String, int>{};
    for (final r in week) {
      byKind[r['kind'] as String] = (byKind[r['kind'] as String] ?? 0) + 1;
    }
    return _card(
      'Last 7 days',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$today new today · ${week.length} this week · $avg ★ average'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 14,
            runSpacing: 6,
            children: [
              for (final e in byKind.entries)
                PicLabel(
                  '${_kindEmoji[e.key] ?? '•'} ${e.value} ${e.key}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// Kids' one-tap reactions per worksheet kind, least liked first.
  Widget _reactions(List<Map<String, dynamic>> rows) {
    final by = <String, List<int>>{};
    for (final r in rows) {
      if (r['kind'] != 'reaction' || r['rating'] == null) continue;
      final ctx = Map<String, dynamic>.from(r['context'] as Map? ?? {});
      final k = ctx['worksheet_kind'] as String? ?? '?';
      by.putIfAbsent(k, () => []).add((r['rating'] as num).toInt());
    }
    final entries = by.entries.toList()
      ..sort((a, b) {
        double liked(List<int> v) => v.where((x) => x == 3).length / v.length;
        return liked(a.value).compareTo(liked(b.value));
      });
    return _card(
      "What kids think (worksheet reactions)",
      entries.isEmpty
          ? const Text('No reactions yet.')
          : Column(
              children: [
                for (final e in entries.take(15))
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Pic(
                          WorksheetKind.values.asNameMap()[e.key]?.emoji ??
                              '📄',
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            WorksheetKind.values.asNameMap()[e.key]?.title ??
                                e.key,
                          ),
                        ),
                        PicLabel(
                          '😍 ${e.value.where((x) => x == 3).length}  '
                          '🙂 ${e.value.where((x) => x == 2).length}  '
                          '😕 ${e.value.where((x) => x == 1).length}',
                        ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _message(Map<String, dynamic> r) {
    final ctx = Map<String, dynamic>.from(r['context'] as Map? ?? {});
    final t = _time(r);
    final details = [
      '${t.day}/${t.month} ${t.hour}:${t.minute.toString().padLeft(2, '0')}',
      if (r['rating'] != null) '${r['rating']} ★',
      if (ctx['child_level'] != null)
        Level.values.asNameMap()[ctx['child_level']]?.short ??
            ctx['child_level'],
      if (ctx['platform'] != null) ctx['platform'],
      if (ctx['app'] != null) 'v${ctx['app']}',
      if (r['contact'] != null) r['contact'],
    ].join(' · ');
    final done = r['status'] == 'done';
    return Opacity(
      opacity: done ? .55 : 1,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: r['kind'] == 'problem'
                ? AppColors.tangerine
                : const Color(0xFFEAE6F2),
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Pic(_kindEmoji[r['kind']] ?? '•', size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    details,
                    style: const TextStyle(color: Colors.black54, fontSize: 13),
                  ),
                ),
                TextButton(
                  onPressed: () => _setStatus(r, done ? 'new' : 'done'),
                  child: Text(done ? 'Reopen' : 'Mark done'),
                ),
              ],
            ),
            if (r['message'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: SelectableText(
                  r['message'] as String,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
