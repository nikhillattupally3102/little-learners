import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens the privacy policy (web/privacy.html, published next to the app).
class PrivacyLink extends StatelessWidget {
  const PrivacyLink({super.key});

  /// Where the policy lives for the iPad app; the web app uses its own copy.
  static const hostedUrl = String.fromEnvironment(
    'PRIVACY_URL',
    defaultValue: 'privacy.html',
  );

  @override
  Widget build(BuildContext context) => TextButton(
    onPressed: () => launchUrl(
      kIsWeb ? Uri.base.resolve('privacy.html') : Uri.parse(hostedUrl),
      webOnlyWindowName: '_blank',
    ),
    child: const Text(
      'Privacy policy',
      style: TextStyle(color: Colors.black54),
    ),
  );
}
