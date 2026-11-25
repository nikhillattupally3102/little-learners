import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../content/photo_credits.dart';
import '../widgets/backgrounds.dart';
import '../widgets/real_photo.dart';

/// Grown-ups: who took each real-life photo, and under which licence.
/// (Reached from the grown-ups area, so links out are fine here.)
class CreditsScreen extends StatelessWidget {
  const CreditsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ids = photoCredits.keys.toList();
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
                      Text(
                        'Photo credits',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(24, 4, 24, 8),
                  child: Text(
                    'The real-life photos in learning sessions come from '
                    'Wikimedia Commons. Thank you to every photographer. Each '
                    'photo is used under the licence shown and was resized for '
                    'the app. Tap a photo to see its original page.',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
                    itemCount: ids.length,
                    itemBuilder: (context, i) {
                      final c = photoCredits[ids[i]]!;
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 2),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            photoAsset(ids[i]),
                            width: 64,
                            height: 50,
                            fit: BoxFit.cover,
                            cacheWidth: 160,
                            errorBuilder: (_, _, _) =>
                                const SizedBox(width: 64, height: 50),
                          ),
                        ),
                        title: Text(
                          c.subject,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text('${c.artist} · ${c.license}'),
                        trailing: const Icon(Icons.open_in_new_rounded),
                        onTap: () => launchUrl(
                          Uri.parse(c.source),
                          webOnlyWindowName: '_blank',
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
