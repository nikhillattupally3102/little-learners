import 'package:flutter/material.dart';

import '../state/progress.dart';
import '../theme.dart';
import '../widgets/backgrounds.dart';
import '../widgets/bubbly_button.dart';
import '../widgets/privacy_link.dart';
import 'credits_screen.dart';

/// Grown-up account: sign in / create an account so children's profiles and
/// results are backed up and shared across devices.
class AccountScreen extends StatefulWidget {
  const AccountScreen({
    super.key,
    this.startCreating = false,
    this.closeWhenSignedIn = false,
  });

  /// Open on "Create a family account" instead of "Sign in".
  final bool startCreating;

  /// Go back automatically once signed in (used from the welcome screen).
  final bool closeWhenSignedIn;

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  late bool _creating = widget.startCreating;
  bool _busy = false;
  String? _message;
  bool _messageIsError = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _run(Future<String?> Function() action) async {
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      final note = await action();
      if (mounted &&
          widget.closeWhenSignedIn &&
          ProgressScope.read(context).signedIn) {
        Navigator.of(context).pop();
        return;
      }
      if (mounted) {
        setState(() {
          _message = note;
          _messageIsError = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _message = _friendly(e);
          _messageIsError = true;
        });
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  static String _friendly(Object e) {
    final s = '$e';
    if (s.contains('Invalid login')) return 'Wrong email or password.';
    if (s.contains('already registered')) {
      return 'That email already has an account — sign in instead.';
    }
    if (s.contains('Password should')) {
      return 'Please use a password of at least 6 characters.';
    }
    if (s.contains('SocketException') || s.contains('Failed to fetch')) {
      return 'No internet connection. Try again in a moment.';
    }
    return s.replaceFirst(RegExp(r'^\w*Exception\(?'), '');
  }

  bool get _valid =>
      _email.text.contains('@') && _password.text.trim().length >= 6;

  @override
  Widget build(BuildContext context) {
    final progress = ProgressScope.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                      Text(
                        'Grown-up account',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 480),
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
                          child: !progress.cloudConfigured
                              ? const _NotConfigured()
                              : progress.signedIn
                              ? _signedIn(progress)
                              : _signInForm(progress),
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

  Widget _signedIn(Progress progress) {
    final last = progress.lastSync;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(Icons.cloud_done_rounded, size: 56, color: AppColors.mint),
        const SizedBox(height: 8),
        Text(
          progress.accountEmail ?? '',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(
          progress.syncing
              ? 'Syncing…'
              : progress.syncError != null
              ? "Couldn't sync — will try again. (${progress.syncError})"
              : last == null
              ? 'Not synced yet'
              : 'Last synced ${_ago(last)}',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: progress.syncError != null
                ? AppColors.tangerine
                : Colors.black54,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${progress.profiles.length} learner${progress.profiles.length == 1 ? '' : 's'} '
          'backed up. Sign in with this email on another iPad or computer to '
          'see the same learners and progress.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        BubblyButton(
          color: AppColors.sky,
          onTap: progress.syncing ? null : progress.sync,
          child: const Text(
            'Sync now',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => _run(() async {
            await progress.signOut();
            return 'Signed out. Everything stays saved on this device.';
          }),
          child: const Text('Sign out'),
        ),
        const Divider(height: 32),
        TextButton(
          style: TextButton.styleFrom(foregroundColor: Colors.red.shade700),
          onPressed: _busy ? null : () => _confirmDelete(progress),
          child: const Text('Delete account and all data'),
        ),
        if (_message != null) _messageText(),
        const PrivacyLink(),
        TextButton(
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const CreditsScreen())),
          child: const Text(
            'Photo credits',
            style: TextStyle(color: Colors.black54),
          ),
        ),
      ],
    );
  }

  Future<void> _confirmDelete(Progress progress) async {
    final typed = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialog) => AlertDialog(
          title: const Text('Delete account?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'This permanently deletes ${progress.accountEmail}, every '
                "learner, and all of their progress — in the cloud and on "
                'this device. It cannot be undone.',
              ),
              const SizedBox(height: 16),
              const Text('Type DELETE to confirm:'),
              const SizedBox(height: 8),
              TextField(
                controller: typed,
                autofocus: true,
                onChanged: (_) => setDialog(() {}),
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red.shade700,
              ),
              onPressed: typed.text.trim().toUpperCase() == 'DELETE'
                  ? () => Navigator.of(context).pop(true)
                  : null,
              child: const Text('Delete forever'),
            ),
          ],
        ),
      ),
    );
    typed.dispose();
    if (ok != true || !mounted) return;
    await _run(() async {
      await progress.deleteAccountAndData();
      if (mounted) Navigator.of(context).popUntil((r) => r.isFirst);
      return null;
    });
  }

  Widget _signInForm(Progress progress) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const Icon(Icons.family_restroom_rounded, size: 56, color: AppColors.sky),
      const SizedBox(height: 8),
      Text(
        _creating ? 'Create a family account' : 'Sign in',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: 6),
      const Text(
        "Back up your children's progress and use the app on more than one "
        'device. We only store first names, avatars and worksheet results.',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black54),
      ),
      const SizedBox(height: 20),
      TextField(
        controller: _email,
        keyboardType: TextInputType.emailAddress,
        autofillHints: const [AutofillHints.email],
        decoration: const InputDecoration(
          labelText: 'Email',
          border: OutlineInputBorder(),
        ),
        onChanged: (_) => setState(() {}),
      ),
      const SizedBox(height: 12),
      TextField(
        controller: _password,
        obscureText: true,
        autofillHints: [
          _creating ? AutofillHints.newPassword : AutofillHints.password,
        ],
        decoration: InputDecoration(
          labelText: _creating
              ? 'Choose a password (6+ characters)'
              : 'Password',
          border: const OutlineInputBorder(),
        ),
        onChanged: (_) => setState(() {}),
      ),
      const SizedBox(height: 20),
      BubblyButton(
        color: _valid && !_busy ? AppColors.mint : const Color(0xFFC9C5D3),
        onTap: !_valid || _busy
            ? null
            : () => _run(() async {
                final email = _email.text.trim();
                final password = _password.text.trim();
                if (_creating) {
                  final signedIn = await progress.signUp(email, password);
                  if (!signedIn) {
                    return 'Check your email to confirm the account, then sign in here.';
                  }
                  await progress.sync();
                  return null;
                }
                await progress.signIn(email, password);
                return null;
              }),
        child: Text(
          _busy
              ? 'Please wait…'
              : _creating
              ? 'Create account'
              : 'Sign in',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      const SizedBox(height: 8),
      TextButton(
        onPressed: () => setState(() {
          _creating = !_creating;
          _message = null;
        }),
        child: Text(
          _creating
              ? 'Already have an account? Sign in'
              : 'New here? Create a family account',
        ),
      ),
      if (!_creating)
        TextButton(
          onPressed: !_email.text.contains('@') || _busy
              ? null
              : () => _run(() async {
                  await progress.resetPassword(_email.text.trim());
                  return 'We emailed you a link to reset your password.';
                }),
          child: const Text('Forgot password?'),
        ),
      if (_message != null) _messageText(),
      const PrivacyLink(),
      TextButton(
        onPressed: () =>
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const CreditsScreen())),
        child: const Text(
          'Photo credits',
          style: TextStyle(color: Colors.black54),
        ),
      ),
    ],
  );

  Widget _messageText() => Padding(
    padding: const EdgeInsets.only(top: 12),
    child: Text(
      _message!,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: _messageIsError ? AppColors.tangerine : AppColors.ink,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  static String _ago(DateTime t) {
    final d = DateTime.now().difference(t);
    if (d.inMinutes < 1) return 'just now';
    if (d.inHours < 1) return '${d.inMinutes} min ago';
    if (d.inDays < 1) return '${d.inHours} h ago';
    return '${d.inDays} days ago';
  }
}

class _NotConfigured extends StatelessWidget {
  const _NotConfigured();

  @override
  Widget build(BuildContext context) => const Column(
    children: [
      Icon(Icons.cloud_off_rounded, size: 56, color: Colors.black38),
      SizedBox(height: 8),
      Text(
        'Cloud backup is not set up in this build',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
      ),
      SizedBox(height: 8),
      Text(
        'Everything is saved on this device. To turn on accounts and '
        'syncing, build the app with the Supabase settings '
        '(see README → Backend).',
        textAlign: TextAlign.center,
      ),
    ],
  );
}
