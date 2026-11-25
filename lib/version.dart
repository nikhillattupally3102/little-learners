import 'package:flutter/foundation.dart';

/// Shown in feedback so problems can be traced to a release.
/// Keep in step with `version:` in pubspec.yaml.
const appVersion = '1.0.0';

String get platformName => kIsWeb ? 'web' : defaultTargetPlatform.name;
