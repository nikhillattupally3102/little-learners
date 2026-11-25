import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Reads text aloud with the device's built-in voice.
///
/// [say] speaks a list of segments one after another (e.g. letter sounds),
/// reporting which segment is playing so the UI can highlight it.
class Speaker {
  Speaker._();
  static final instance = Speaker._();

  late final _tts = FlutterTts();
  bool enabled = true;
  bool _ready = false;
  int _generation = 0;
  Completer<void>? _current;
  DateTime _startedAt = DateTime.now();

  Future<void> _init() async {
    if (_ready) return;
    _ready = true;
    try {
      await _tts.setLanguage('en-US');
      // Slow and a little higher-pitched: friendlier for small children.
      await _tts.setSpeechRate(kIsWeb ? 0.8 : 0.42);
      await _tts.setPitch(1.15);
      _tts.setCompletionHandler(_onEnd);
      _tts.setCancelHandler(_onEnd);
      _tts.setErrorHandler((_) => _onEnd());
    } catch (_) {
      // Speech unavailable: the app still works silently.
    }
  }

  void _onEnd() {
    // Ignore late "cancelled" events from the previous utterance.
    if (DateTime.now().difference(_startedAt) <
        const Duration(milliseconds: 150))
      return;
    _complete();
  }

  void _complete() {
    final c = _current;
    _current = null;
    if (c != null && !c.isCompleted) c.complete();
  }

  Future<void> stop() async {
    _generation++;
    _complete();
    try {
      await _tts.stop();
    } catch (_) {}
  }

  /// Speaks [segments] in order. [onSegment] receives the index being spoken,
  /// then `segments.length` when everything has finished.
  Future<void> say(
    List<String> segments, {
    void Function(int index)? onSegment,
    Duration gap = const Duration(milliseconds: 250),
  }) async {
    if (!enabled || segments.isEmpty) return;
    await _init();
    await stop();
    final gen = _generation;
    for (var i = 0; i < segments.length; i++) {
      if (gen != _generation) return;
      onSegment?.call(i);
      final done = Completer<void>();
      _current = done;
      _startedAt = DateTime.now();
      try {
        await _tts.speak(segments[i]);
      } catch (_) {
        _complete();
      }
      // Fallback in case the platform never reports completion.
      final estimate = Duration(milliseconds: 1200 + segments[i].length * 120);
      await done.future.timeout(estimate, onTimeout: () {});
      if (gen != _generation) return;
      await Future<void>.delayed(gap);
    }
    if (gen == _generation) onSegment?.call(segments.length);
  }
}
