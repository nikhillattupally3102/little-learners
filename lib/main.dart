import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/profile_editor_screen.dart';
import 'screens/profiles_screen.dart';
import 'screens/welcome_screen.dart';
import 'widgets/backgrounds.dart';
import 'services/cloud.dart';
import 'state/progress.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Cloud.instance.init();
  final progress = await Progress.load();
  runApp(LittleLearnersApp(progress: progress));
}

class LittleLearnersApp extends StatelessWidget {
  const LittleLearnersApp({super.key, required this.progress});
  final Progress progress;

  @override
  Widget build(BuildContext context) => ProgressScope(
    notifier: progress,
    child: MaterialApp(
      title: 'Little Learners',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: const _RootGate(),
    ),
  );
}

/// First launch → welcome (sign in, create a family account, or skip).
/// No learners yet → create one. Several learners → pick one. Otherwise → home.
class _RootGate extends StatelessWidget {
  const _RootGate();

  @override
  Widget build(BuildContext context) {
    final progress = ProgressScope.of(context);
    final noLearners = progress.profiles.isEmpty;
    final Widget child =
        noLearners &&
            progress.cloudConfigured &&
            !progress.signedIn &&
            !progress.welcomeDone
        ? const WelcomeScreen()
        : noLearners && progress.syncing
        ? const _Loading()
        : noLearners
        ? const ProfileEditorScreen(firstRun: true)
        : progress.active == null
        ? const ProfilesScreen()
        : const HomeScreen();
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: child,
    );
  }
}

/// Shown while a signed-in family's learners download on a new device.
class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) => const Scaffold(
    body: Stack(
      children: [
        Positioned.fill(child: BubblesBackground()),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                'Getting your family ready…',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
