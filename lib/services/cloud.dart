import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// The Supabase backend: grown-up sign-in plus the `children`, `results` and
/// `seen` tables (see supabase/schema.sql).
///
/// Configured at build time:
///   flutter run --dart-define-from-file=supabase.env.json
/// with supabase.env.json containing SUPABASE_URL and SUPABASE_ANON_KEY.
/// Without them the app works fully offline and this class does nothing.
class Cloud {
  Cloud._();
  static final instance = Cloud._();

  static const _url = String.fromEnvironment('SUPABASE_URL');
  static const _anonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  /// True when the app was built with Supabase settings.
  static bool get configured => _url.isNotEmpty && _anonKey.isNotEmpty;

  bool _ready = false;

  Future<void> init() async {
    if (!configured || _ready) return;
    try {
      await Supabase.initialize(url: _url, publishableKey: _anonKey);
      _ready = true;
    } catch (e) {
      debugPrint('Cloud: could not start Supabase: $e');
    }
  }

  SupabaseClient get _db => Supabase.instance.client;

  /// True when a grown-up is signed in, so data can sync.
  bool get signedIn => _ready && _db.auth.currentUser != null;

  String? get email => _ready ? _db.auth.currentUser?.email : null;

  String? get userId => _ready ? _db.auth.currentUser?.id : null;

  /// Fires when someone signs in or out.
  Stream<void> get authChanges =>
      _ready ? _db.auth.onAuthStateChange.map((_) {}) : const Stream.empty();

  // ------------------------------------------------------------------ auth

  /// Creates a grown-up account. Returns true when signed in straight away,
  /// false when Supabase sent a confirmation email first.
  Future<bool> signUp(String email, String password) async {
    final res = await _db.auth.signUp(email: email, password: password);
    return res.session != null;
  }

  Future<void> signIn(String email, String password) =>
      _db.auth.signInWithPassword(email: email, password: password);

  Future<void> resetPassword(String email) =>
      _db.auth.resetPasswordForEmail(email);

  Future<void> signOut() => _db.auth.signOut();

  /// Permanently deletes the signed-in grown-up's account and, through the
  /// database's cascading deletes, all of the family's data in the cloud.
  Future<void> deleteAccount() async {
    await _db.rpc('delete_my_account');
    try {
      await _db.auth.signOut();
    } catch (_) {
      // The account is already gone; clearing the local session is enough.
    }
  }

  // -------------------------------------------------------------- children

  Future<List<Map<String, dynamic>>> fetchChildren() async =>
      List<Map<String, dynamic>>.from(await _db.from('children').select());

  Future<void> upsertChildren(List<Map<String, Object?>> rows) async {
    if (rows.isEmpty) return;
    await _db.from('children').upsert(rows);
  }

  Future<void> deleteChildren(List<String> ids) async {
    if (ids.isEmpty) return;
    await _db.from('children').delete().inFilter('id', ids);
  }

  // --------------------------------------------------------------- results

  Future<void> upsertResults(List<Map<String, Object?>> rows) async {
    for (var i = 0; i < rows.length; i += 500) {
      await _db
          .from('results')
          .upsert(rows.sublist(i, (i + 500).clamp(0, rows.length)));
    }
  }

  Future<List<Map<String, dynamic>>> fetchResults(String childId) async =>
      List<Map<String, dynamic>>.from(
        await _db
            .from('results')
            .select()
            .eq('child_id', childId)
            .order('completed_at', ascending: false)
            .limit(5000),
      );

  // -------------------------------------------------------------- feedback

  /// True when Supabase is running (feedback can be sent signed in or not).
  bool get ready => _ready;

  Future<void> sendFeedback(List<Map<String, Object?>> rows) async {
    if (rows.isEmpty) return;
    await _db.from('feedback').insert(rows);
  }

  /// Whether the signed-in grown-up may read the feedback inbox.
  Future<bool> isFeedbackAdmin() async {
    if (!signedIn) return false;
    return await _db.rpc('is_feedback_admin') == true;
  }

  Future<List<Map<String, dynamic>>> fetchFeedback({int limit = 500}) async =>
      List<Map<String, dynamic>>.from(
        await _db
            .from('feedback')
            .select()
            .order('created_at', ascending: false)
            .limit(limit),
      );

  Future<void> setFeedbackStatus(int id, String status) =>
      _db.from('feedback').update({'status': status}).eq('id', id);

  // ------------------------------------------------------------------ seen

  Future<void> upsertSeen(String childId, Map<String, int> seen) async {
    final rows = [
      for (final e in seen.entries)
        {'child_id': childId, 'fingerprint': e.key, 'day': e.value},
    ];
    for (var i = 0; i < rows.length; i += 500) {
      await _db
          .from('seen')
          .upsert(rows.sublist(i, (i + 500).clamp(0, rows.length)));
    }
  }

  Future<Map<String, int>> fetchSeen(String childId, int sinceDay) async {
    final rows = await _db
        .from('seen')
        .select('fingerprint, day')
        .eq('child_id', childId)
        .gte('day', sinceDay);
    return {
      for (final r in rows)
        r['fingerprint'] as String: (r['day'] as num).toInt(),
    };
  }
}
