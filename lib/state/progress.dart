import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../generators/gen.dart';
import '../models/generator.dart';
import '../models/models.dart';
import '../models/result.dart';
import '../models/rewards.dart';
import '../services/cloud.dart';
import '../services/speaker.dart';
import '../version.dart';

/// All saved app state: child profiles and each child's results, adaptive
/// difficulty and recently seen questions. Every per-child key is prefixed
/// with the profile id.
///
/// The device is the source of truth for the screens, so the app works
/// offline. When a grown-up is signed in, [sync] merges everything with the
/// cloud (see [Cloud]) — automatically after changes and on start-up.
class Progress extends ChangeNotifier {
  Progress._(this._prefs, this._cloud) {
    _profiles = _readProfiles();
    // One child? Skip the "who's learning" screen.
    if (_profiles.length == 1) _activeId = _profiles.first.id;
    Speaker.instance.enabled = soundOn;
    for (final p in _profiles) {
      _migrateLegacyStars(p);
    }
    _authSub = _cloud.authChanges.listen((_) {
      notifyListeners();
      if (_cloud.signedIn) sync();
    });
  }

  final SharedPreferences _prefs;
  final Cloud _cloud;
  late List<Profile> _profiles;
  String? _activeId;
  StreamSubscription<void>? _authSub;

  static Future<Progress> load({Cloud? cloud}) async {
    final progress = Progress._(
      await SharedPreferences.getInstance(),
      cloud ?? Cloud.instance,
    );
    if (progress._cloud.signedIn) unawaited(progress.sync());
    unawaited(progress.flushFeedback());
    return progress;
  }

  @override
  void dispose() {
    _authSub?.cancel();
    _syncTimer?.cancel();
    super.dispose();
  }

  // ---------------------------------------------------------------- profiles

  List<Profile> get profiles => List.unmodifiable(_profiles);

  Profile? get active {
    for (final p in _profiles) {
      if (p.id == _activeId) return p;
    }
    return null;
  }

  void select(Profile? profile) {
    _activeId = profile?.id;
    notifyListeners();
  }

  /// Adds a new profile or updates an existing one with the same id.
  Future<void> saveProfile(Profile profile, {bool makeActive = false}) async {
    final i = _profiles.indexWhere((p) => p.id == profile.id);
    if (i == -1) {
      _profiles.add(profile);
    } else {
      if (_profiles[i].level != profile.level) {
        // A grown-up chose a new grade: start adapting afresh from there.
        for (final key
            in _prefs
                .getKeys()
                .where(
                  (k) =>
                      k.startsWith('${profile.id}_adj_') ||
                      k.startsWith('${profile.id}_last_'),
                )
                .toList()) {
          await _prefs.remove(key);
        }
      }
      _profiles[i] = profile;
    }
    if (makeActive) _activeId = profile.id;
    await _writeProfiles();
    await _touch(profile.id);
    notifyListeners();
    _scheduleSync();
  }

  Future<void> deleteProfile(Profile profile) async {
    _profiles.removeWhere((p) => p.id == profile.id);
    if (_activeId == profile.id) _activeId = null;
    for (final key
        in _prefs
            .getKeys()
            .where((k) => k.startsWith('${profile.id}_'))
            .toList()) {
      await _prefs.remove(key);
    }
    _results.remove(profile.id);
    _seen.remove(profile.id);
    await _prefs.setStringList(_pendingDeletesKey, [
      ...?_prefs.getStringList(_pendingDeletesKey),
      profile.id,
    ]);
    await _writeProfiles();
    notifyListeners();
    _scheduleSync();
  }

  static String newId() => 'p${DateTime.now().microsecondsSinceEpoch}';

  List<Profile> _readProfiles() {
    final raw = _prefs.getString('profiles');
    if (raw == null) return [];
    try {
      return [
        for (final j in jsonDecode(raw) as List)
          Profile.fromJson(j as Map<String, dynamic>),
      ];
    } catch (_) {
      return [];
    }
  }

  Future<void> _writeProfiles() => _prefs.setString(
    'profiles',
    jsonEncode([for (final p in _profiles) p.toJson()]),
  );

  /// When this child's profile or difficulty last changed on this device.
  DateTime _updatedAt(String id) =>
      DateTime.tryParse(_prefs.getString('${id}_updated') ?? '') ??
      DateTime.fromMillisecondsSinceEpoch(0);

  Future<void> _touch(String id) => _prefs.setString(
    '${id}_updated',
    DateTime.now().toUtc().toIso8601String(),
  );

  // ------------------------------------------------------------------ sound

  bool get soundOn => _prefs.getBool('sound') ?? true;

  set soundOn(bool value) {
    _prefs.setBool('sound', value);
    Speaker.instance.enabled = value;
    if (!value) Speaker.instance.stop();
    notifyListeners();
  }

  // ---------------------------------------------------------------- results

  final _results = <String, List<WorksheetResult>>{};

  /// Every finished worksheet of a child, newest first.
  List<WorksheetResult> resultsOf(Profile p) =>
      List.unmodifiable(_resultsFor(p.id));

  List<WorksheetResult> _resultsFor(String id) => _results.putIfAbsent(id, () {
    try {
      final raw = _prefs.getString('${id}_results');
      if (raw == null) return [];
      return [
        for (final j in jsonDecode(raw) as List)
          WorksheetResult.fromJson(j as Map<String, dynamic>),
      ]..sort((a, b) => b.completedAt.compareTo(a.completedAt));
    } catch (_) {
      return [];
    }
  });

  Future<void> _saveResults(String id) => _prefs.setString(
    '${id}_results',
    jsonEncode([for (final r in _resultsFor(id)) r.toJson()]),
  );

  /// Results not uploaded yet.
  Set<String> _unsynced(String id) =>
      (_prefs.getStringList('${id}_unsynced') ?? const []).toSet();

  /// Days without a kind of sheet after which its "Let's learn!" pages
  /// come back.
  static const lessonGap = 14;

  /// Whether [p] should see the lesson before a [kind] sheet: they have
  /// never done one, or not for [lessonGap] days.
  bool needsLesson(Profile p, WorksheetKind kind, {DateTime? now}) {
    DateTime? last;
    for (final r in _resultsFor(p.id)) {
      if (r.kind == kind.name &&
          (last == null || r.completedAt.isAfter(last))) {
        last = r.completedAt;
      }
    }
    if (last == null) return true;
    return (now ?? DateTime.now()).difference(last).inDays >= lessonGap;
  }

  int starsOf(Profile p) {
    final best = <String, int>{};
    for (final r in _resultsFor(p.id)) {
      if (r.stars > (best[r.worksheetId] ?? -1)) best[r.worksheetId] = r.stars;
    }
    return best.values.fold(0, (a, b) => a + b);
  }

  /// Days in a row (up to today, or yesterday if not played yet today).
  int streakOf(Profile p, {DateTime? now}) {
    final days = {for (final r in _resultsFor(p.id)) dayNumber(r.completedAt)};
    var day = dayNumber(now ?? DateTime.now());
    if (!days.contains(day)) day--;
    var streak = 0;
    while (days.contains(day)) {
      streak++;
      day--;
    }
    return streak;
  }

  /// Best stars the active child earned on a worksheet, or null if not done yet.
  int? starsFor(String worksheetId) {
    final p = active;
    if (p == null) return null;
    int? best;
    for (final r in _resultsFor(p.id)) {
      if (r.worksheetId == worksheetId && r.stars > (best ?? -1)) {
        best = r.stars;
      }
    }
    return best;
  }

  /// Records a finished worksheet. With a [category], difficulty adapts and
  /// the result says how: +1 = harder next time, -1 = easier, 0 = unchanged.
  Future<int> complete(
    String worksheetId,
    int earned, {
    Category? category,
    String? kind,
    Level? level,
    int questions = 0,
    int mistakes = 0,
    int seconds = 0,
    bool adapt = true,
  }) async {
    final p = active;
    if (p == null) return 0;
    final result = WorksheetResult(
      id: WorksheetResult.newId(),
      childId: p.id,
      worksheetId: worksheetId,
      kind: kind ?? _kindFromId(worksheetId),
      category: category?.name,
      level: (level ?? p.level).name,
      stars: earned,
      questions: questions,
      mistakes: mistakes,
      seconds: seconds,
      completedAt: DateTime.now(),
    );
    _resultsFor(p.id).insert(0, result);
    await _saveResults(p.id);
    await _prefs.setStringList('${p.id}_unsynced', [
      ..._unsynced(p.id),
      result.id,
    ]);
    final change = category == null || !adapt
        ? 0
        : await _adapt(p, category, earned);
    notifyListeners();
    _scheduleSync();
    return change;
  }

  static String _kindFromId(String worksheetId) {
    final rest = worksheetId.contains('_')
        ? worksheetId.substring(worksheetId.indexOf('_') + 1)
        : worksheetId;
    return rest.startsWith('topic_') ? WorksheetKind.topicQuiz.name : rest;
  }

  /// Older versions kept only a star count per worksheet; turn those into
  /// results so reports, stars and streaks keep working.
  void _migrateLegacyStars(Profile p) {
    final prefix = '${p.id}_ws_';
    final legacy = _prefs.getKeys().where((k) => k.startsWith(prefix)).toList();
    if (legacy.isEmpty) return;
    final results = _resultsFor(p.id);
    for (final key in legacy) {
      final wsId = key.substring(prefix.length);
      final day = DateTime.tryParse(wsId.split('_').first);
      final kind = _kindFromId(wsId);
      results.add(
        WorksheetResult(
          id: 'legacy_${p.id}_$wsId',
          childId: p.id,
          worksheetId: wsId,
          kind: kind,
          category: WorksheetKind.values.asNameMap()[kind]?.category.name,
          level: p.level.name,
          stars: _prefs.getInt(key) ?? 0,
          questions: 0,
          mistakes: 0,
          seconds: 0,
          completedAt: (day ?? DateTime.now()).add(const Duration(hours: 12)),
        ),
      );
      _prefs.remove(key);
    }
    results.sort((a, b) => b.completedAt.compareTo(a.completedAt));
    _saveResults(p.id);
    _prefs.setStringList('${p.id}_unsynced', [
      ..._unsynced(p.id),
      for (final r in results)
        if (r.id.startsWith('legacy_')) r.id,
    ]);
    for (final k in ['stars', 'streak', 'lastDay']) {
      _prefs.remove('${p.id}_$k');
    }
  }

  // ---------------------------------------------------------------- rewards

  Rewards rewardsOf(Profile p) {
    try {
      final raw = _prefs.getString('${p.id}_rewards');
      return raw == null
          ? const Rewards()
          : Rewards.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return const Rewards();
    }
  }

  Future<void> _saveRewards(String id, Rewards r) async {
    await _prefs.setString('${id}_rewards', jsonEncode(r.toJson()));
    await _touch(id);
    notifyListeners();
    _scheduleSync();
  }

  /// Stars a child can spend: earned (best per worksheet) minus spent.
  int walletOf(Profile p) =>
      (starsOf(p) - rewardsOf(p).spent).clamp(0, 1 << 30);

  Future<void> setRewardsEnabled(Profile p, bool on) =>
      _saveRewards(p.id, rewardsOf(p).copyWith(enabled: on));

  /// Buys a sticker with stars. Returns false if not enough stars.
  Future<bool> buySticker(Profile p, Sticker s) async {
    final r = rewardsOf(p);
    if (!r.enabled || r.stickers.contains(s.id)) return false;
    if (walletOf(p) < Sticker.cost) return false;
    await _saveRewards(
      p.id,
      r.copyWith(
        spent: r.spent + Sticker.cost,
        stickers: [...r.stickers, s.id],
      ),
    );
    return true;
  }

  /// Adds or updates a grown-up reward goal.
  Future<void> saveGoal(Profile p, RewardGoal goal) {
    final r = rewardsOf(p);
    final goals = [...r.goals];
    final i = goals.indexWhere((g) => g.id == goal.id);
    if (i == -1) {
      goals.add(goal);
    } else {
      goals[i] = goal;
    }
    return _saveRewards(p.id, r.copyWith(goals: goals));
  }

  Future<void> deleteGoal(Profile p, RewardGoal goal) {
    final r = rewardsOf(p);
    return _saveRewards(
      p.id,
      r.copyWith(goals: [...r.goals.where((g) => g.id != goal.id)]),
    );
  }

  /// A grown-up hands over a goal: spends its stars. False if not enough.
  Future<bool> claimGoal(Profile p, RewardGoal goal) async {
    final r = rewardsOf(p);
    if (walletOf(p) < goal.cost) return false;
    await _saveRewards(
      p.id,
      r.copyWith(
        spent: r.spent + goal.cost,
        goals: [
          for (final g in r.goals)
            g.id == goal.id ? g.copyWith(claimed: g.claimed + 1) : g,
        ],
      ),
    );
    return true;
  }

  // ------------------------------------------------- recently seen questions

  /// Days since 1 Jan 2024 (local calendar day).
  static int dayNumber(DateTime d) => DateTime.utc(
    d.year,
    d.month,
    d.day,
  ).difference(DateTime.utc(2024)).inDays;

  final _seen = <String, Map<String, int>>{};

  Map<String, int> _seenFor(String id) => _seen.putIfAbsent(id, () {
    try {
      final raw = _prefs.getString('${id}_seen');
      return raw == null
          ? {}
          : (jsonDecode(raw) as Map<String, dynamic>).map(
              (k, v) => MapEntry(k, (v as num).toInt()),
            );
    } catch (_) {
      return {};
    }
  });

  /// Fingerprints of questions the active child saw in the last [days] days,
  /// not counting today — so today's worksheets stay the same all day.
  Set<String> recentlySeen({int days = 21, DateTime? now}) {
    final p = active;
    if (p == null) return const {};
    final today = dayNumber(now ?? DateTime.now());
    return {
      for (final e in _seenFor(p.id).entries)
        if (e.value < today && e.value >= today - days) e.key,
    };
  }

  /// Remembers the questions of a worksheet the active child opened.
  Future<void> markSeen(Iterable<Question> questions, {DateTime? now}) async {
    final p = active;
    if (p == null) return;
    final today = dayNumber(now ?? DateTime.now());
    final seen = _seenFor(p.id);
    final dirty = {...?_prefs.getStringList('${p.id}_seen_dirty')};
    for (final f in Gen.fingerprints(questions)) {
      seen[f] = today;
      dirty.add(f);
    }
    seen.removeWhere((_, day) => day < today - 30);
    await _prefs.setString('${p.id}_seen', jsonEncode(seen));
    await _prefs.setStringList('${p.id}_seen_dirty', dirty.toList());
    _scheduleSync();
  }

  // ------------------------------------------------------ adaptive levels

  /// How many levels above (+) or below (−) the child's grade a subject is
  /// currently pitched, based on recent results. Ranges from -2 to +2.
  int adjustment(Profile p, Category c) =>
      _prefs.getInt('${p.id}_adj_${c.name}') ?? 0;

  /// The difficulty to generate [kind] at for the active child.
  Level levelFor(WorksheetKind kind) {
    final p = active!;
    final target = p.level.index + adjustment(p, kind.category);
    return Level.values[target.clamp(kind.min.index, kind.max.index)];
  }

  /// Two perfect worksheets in a row in a subject → one level harder.
  /// Two tough ones (1 star) in a row → one level easier.
  Future<int> _adapt(Profile p, Category c, int stars) async {
    final lastKey = '${p.id}_last_${c.name}';
    final last = _prefs.getInt(lastKey);
    final adj = adjustment(p, c);
    var change = 0;
    if (stars == 3 && last == 3 && adj < 2) {
      await _prefs.setInt('${p.id}_adj_${c.name}', adj + 1);
      await _prefs.remove(lastKey);
      change = 1;
    } else if (stars == 1 && last == 1 && adj > -2) {
      await _prefs.setInt('${p.id}_adj_${c.name}', adj - 1);
      await _prefs.remove(lastKey);
      change = -1;
    } else {
      await _prefs.setInt(lastKey, stars);
    }
    await _touch(p.id);
    return change;
  }

  /// Adaptive state as stored in the cloud (`children.adjust`).
  Map<String, int> _adjustOf(String id) => {
    for (final k in _prefs.getKeys())
      if (k.startsWith('${id}_adj_') || k.startsWith('${id}_last_'))
        k.substring(id.length + 1): _prefs.getInt(k) ?? 0,
  };

  Future<void> _setAdjust(String id, Map<String, dynamic> adjust) async {
    for (final k in _adjustOf(id).keys) {
      await _prefs.remove('${id}_$k');
    }
    for (final e in adjust.entries) {
      await _prefs.setInt('${id}_${e.key}', (e.value as num).toInt());
    }
  }

  // ------------------------------------------------------------ cloud sync

  static const _pendingDeletesKey = 'pending_child_deletes';

  bool get cloudConfigured => Cloud.configured;
  bool get signedIn => _cloud.signedIn;
  String? get accountEmail => _cloud.email;

  bool _syncing = false;
  bool get syncing => _syncing;
  String? syncError;
  DateTime? get lastSync =>
      DateTime.tryParse(_prefs.getString('last_sync') ?? '')?.toLocal();

  Timer? _syncTimer;

  /// Syncs a couple of seconds after a change, batching quick changes.
  void _scheduleSync() {
    if (!_cloud.signedIn) return;
    _syncTimer?.cancel();
    _syncTimer = Timer(const Duration(seconds: 2), sync);
  }

  Map<String, Object?> _childRow(Profile p) => {
    'id': p.id,
    'name': p.name,
    'avatar': p.avatar,
    'color_index': p.colorIndex,
    'level': p.level.name,
    'adjust': _adjustOf(p.id),
    'rewards': rewardsOf(p).toJson(),
  };

  /// Two-way merge with the cloud. Safe to call any time; does nothing when
  /// signed out. Problems (e.g. no internet) are kept in [syncError] and the
  /// changes stay queued for next time.
  Future<void> sync() {
    if (!_cloud.signedIn) return Future.value();
    if (_running != null) {
      // A sync is already going: run once more right after it, so changes
      // made meanwhile are included.
      return _again ??= _running!.then((_) {
        _again = null;
        return sync();
      });
    }
    return _running = _syncOnce().whenComplete(() => _running = null);
  }

  Future<void>? _running;
  Future<void>? _again;

  Future<void> _syncOnce() async {
    _syncTimer?.cancel();
    _syncing = true;
    syncError = null;
    notifyListeners();
    try {
      // 1. Children deleted on this device.
      final deletes = _prefs.getStringList(_pendingDeletesKey) ?? const [];
      await _cloud.deleteChildren(deletes);
      await _prefs.remove(_pendingDeletesKey);

      // 2. Profiles: newest edit wins; new ones on either side are added.
      final remote = await _cloud.fetchChildren();
      final remoteIds = <String>{};
      final upload = <Map<String, Object?>>[];
      var profilesChanged = false;
      for (final row in remote) {
        final id = row['id'] as String;
        remoteIds.add(id);
        final remoteProfile = Profile.fromJson({
          'id': id,
          'name': row['name'],
          'avatar': row['avatar'],
          'color': (row['color_index'] as num).toInt(),
          'level': row['level'],
        });
        final remoteTime =
            DateTime.tryParse(row['updated_at'] as String? ?? '') ??
            DateTime.fromMillisecondsSinceEpoch(0);
        final i = _profiles.indexWhere((p) => p.id == id);
        if (i == -1 || remoteTime.isAfter(_updatedAt(id))) {
          if (i == -1) {
            _profiles.add(remoteProfile);
          } else {
            _profiles[i] = remoteProfile;
          }
          await _setAdjust(
            id,
            Map<String, dynamic>.from(row['adjust'] as Map? ?? {}),
          );
          if (row['rewards'] is Map && (row['rewards'] as Map).isNotEmpty) {
            await _prefs.setString('${id}_rewards', jsonEncode(row['rewards']));
          }
          await _prefs.setString(
            '${id}_updated',
            remoteTime.toUtc().toIso8601String(),
          );
          profilesChanged = true;
        } else if (_updatedAt(id).isAfter(remoteTime)) {
          upload.add(_childRow(_profiles[i]));
        }
      }
      // A child that was in the cloud before but isn't now was deleted on
      // another device; one that never was is new on this device.
      final wasSynced = (_prefs.getStringList('synced_children') ?? const [])
          .toSet();
      for (final p in [..._profiles]) {
        if (remoteIds.contains(p.id)) continue;
        if (wasSynced.contains(p.id)) {
          _profiles.remove(p);
          if (_activeId == p.id) _activeId = null;
          for (final k
              in _prefs
                  .getKeys()
                  .where((k) => k.startsWith('${p.id}_'))
                  .toList()) {
            await _prefs.remove(k);
          }
          _results.remove(p.id);
          _seen.remove(p.id);
          profilesChanged = true;
        } else {
          upload.add(_childRow(p));
        }
      }
      await _cloud.upsertChildren(upload);
      await _prefs.setStringList('synced_children', [
        for (final p in _profiles) p.id,
      ]);
      if (profilesChanged) {
        await _writeProfiles();
        if (_activeId == null && _profiles.length == 1) {
          _activeId = _profiles.first.id;
        }
      }

      // 3. Results and seen questions, per child.
      final since = dayNumber(DateTime.now()) - 30;
      for (final p in _profiles) {
        final mine = _resultsFor(p.id);
        final pending = _unsynced(p.id);
        await _cloud.upsertResults([
          for (final r in mine)
            if (pending.contains(r.id)) r.toJson(),
        ]);
        await _prefs.remove('${p.id}_unsynced');
        final known = {for (final r in mine) r.id};
        var added = false;
        for (final row in await _cloud.fetchResults(p.id)) {
          if (known.add(row['id'] as String)) {
            mine.add(WorksheetResult.fromJson(row));
            added = true;
          }
        }
        if (added) {
          mine.sort((a, b) => b.completedAt.compareTo(a.completedAt));
          await _saveResults(p.id);
        }

        final seen = _seenFor(p.id);
        final dirty = _prefs.getStringList('${p.id}_seen_dirty') ?? const [];
        await _cloud.upsertSeen(p.id, {
          for (final f in dirty)
            if (seen[f] != null) f: seen[f]!,
        });
        await _prefs.remove('${p.id}_seen_dirty');
        for (final e in (await _cloud.fetchSeen(p.id, since)).entries) {
          if ((seen[e.key] ?? -1) < e.value) seen[e.key] = e.value;
        }
        await _prefs.setString('${p.id}_seen', jsonEncode(seen));
      }
      await flushFeedback();
      await _prefs.setString(
        'last_sync',
        DateTime.now().toUtc().toIso8601String(),
      );
    } catch (e) {
      syncError = '$e';
      debugPrint('Sync failed: $e');
    } finally {
      _syncing = false;
      notifyListeners();
    }
  }

  // -------------------------------------------------------------- feedback

  static const _feedbackKey = 'feedback_queue';

  /// Queues feedback and sends it as soon as possible (works signed out too).
  /// [context] says where it came from, e.g. worksheet kind and level.
  Future<void> sendFeedback({
    required String kind,
    int? rating,
    String? message,
    String? contact,
    Map<String, Object?> context = const {},
  }) async {
    final p = active;
    final row = <String, Object?>{
      'kind': kind,
      'rating': ?rating,
      if (message != null && message.trim().isNotEmpty)
        'message': message.trim(),
      if (contact != null && contact.trim().isNotEmpty)
        'contact': contact.trim(),
      'context': {
        'app': appVersion,
        'platform': platformName,
        'child_level': ?p?.level.name,
        ...context,
        'sent_at': DateTime.now().toUtc().toIso8601String(),
      },
    };
    final queue = [...?_prefs.getStringList(_feedbackKey), jsonEncode(row)];
    // Keep the queue small if a device stays offline for a long time.
    await _prefs.setStringList(
      _feedbackKey,
      queue.length > 200 ? queue.sublist(queue.length - 200) : queue,
    );
    await flushFeedback();
  }

  /// How many feedback items are waiting to be sent.
  int get pendingFeedback => _prefs.getStringList(_feedbackKey)?.length ?? 0;

  Future<void> flushFeedback() async {
    final queue = _prefs.getStringList(_feedbackKey) ?? const [];
    if (queue.isEmpty || !_cloud.ready) return;
    try {
      final rows = [
        for (final r in queue) Map<String, Object?>.from(jsonDecode(r) as Map),
      ];
      if (_cloud.signedIn) {
        // Signed-in feedback is linked to the family (for replies).
        for (final r in rows) {
          r['parent_id'] = _cloud.userId;
        }
      }
      await _cloud.sendFeedback(rows);
      await _prefs.remove(_feedbackKey);
    } catch (e) {
      debugPrint('Feedback not sent yet: $e');
    }
  }

  // --------------------------------------------------------------- account

  /// Whether the first-launch welcome (sign in / create account / skip) has
  /// been answered on this device.
  bool get welcomeDone => _prefs.getBool('welcome_done') ?? false;

  Future<void> finishWelcome() async {
    await _prefs.setBool('welcome_done', true);
    notifyListeners();
  }

  Future<bool> signUp(String email, String password) async {
    final signedIn = await _cloud.signUp(email, password);
    if (signedIn) await _prefs.setBool('welcome_done', true);
    return signedIn;
  }

  Future<void> signIn(String email, String password) async {
    await _cloud.signIn(email, password);
    await _prefs.setBool('welcome_done', true);
    await sync();
  }

  Future<void> resetPassword(String email) => _cloud.resetPassword(email);

  /// Deletes the grown-up account and all cloud data, then removes every
  /// learner and their progress from this device too.
  Future<void> deleteAccountAndData() async {
    _syncTimer?.cancel();
    await _running;
    await _cloud.deleteAccount();
    for (final p in [..._profiles]) {
      for (final k
          in _prefs.getKeys().where((k) => k.startsWith('${p.id}_')).toList()) {
        await _prefs.remove(k);
      }
    }
    _profiles.clear();
    _results.clear();
    _seen.clear();
    _activeId = null;
    for (final k in [
      'profiles',
      'synced_children',
      _pendingDeletesKey,
      'last_sync',
      'welcome_done',
    ]) {
      await _prefs.remove(k);
    }
    notifyListeners();
  }

  /// Signs out. Data stays on this device.
  Future<void> signOut() async {
    _syncTimer?.cancel();
    await _running;
    await _cloud.signOut();
    notifyListeners();
  }
}

class ProgressScope extends InheritedNotifier<Progress> {
  const ProgressScope({
    super.key,
    required Progress super.notifier,
    required super.child,
  });

  /// Subscribes the calling widget to progress changes.
  static Progress of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ProgressScope>()!.notifier!;

  /// Reads progress without subscribing (for use in callbacks).
  static Progress read(BuildContext context) =>
      context.getInheritedWidgetOfExactType<ProgressScope>()!.notifier!;
}
