import 'package:flutter/material.dart';

import '../content/photo_credits.dart';
import '../content/topics.dart';

/// The real-life photo for a learning item, if we have one (null otherwise —
/// callers simply show the drawing alone).
String? photoIdFor(Topic topic, TopicItem item) {
  if (topic.id.startsWith('abc')) return letterPhotos[item.name];
  final id = '${item.from ?? topic.id}__${_slug(item.name)}';
  return photoCredits.containsKey(id) ? id : null;
}

String _slug(String s) => s
    .toLowerCase()
    .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
    .replaceAll(RegExp(r'^_+|_+$'), '');

String photoAsset(String id) => 'assets/photos/$id.jpg';

/// A rounded real-life photo. Tap to see it big; ⓘ shows who took it.
/// If the image can't load for any reason, it quietly takes no space.
class RealPhoto extends StatelessWidget {
  const RealPhoto(this.id, {super.key, required this.width, this.height});
  final String id;
  final double width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final credit = photoCredits[id];
    if (credit == null) return const SizedBox.shrink();
    final h = height ?? width * .78;
    return Semantics(
      image: true,
      label: 'Photo of ${credit.subject}',
      child: GestureDetector(
        onTap: () => _showBig(context, credit),
        child: Container(
          width: width,
          height: h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white, width: 5),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(19),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  photoAsset(id),
                  fit: BoxFit.cover,
                  // Fade in once loaded (on the web the photo downloads first).
                  frameBuilder: (_, child, frame, sync) => sync
                      ? child
                      : AnimatedOpacity(
                          opacity: frame == null ? 0 : 1,
                          duration: const Duration(milliseconds: 300),
                          child: child,
                        ),
                  errorBuilder: (_, _, _) => const SizedBox.shrink(),
                ),
                Positioned(
                  right: 6,
                  bottom: 6,
                  child: _InfoDot(credit: credit),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showBig(BuildContext context, PhotoCredit credit) => showDialog<void>(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset(
                photoAsset(id),
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => const SizedBox.shrink(),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Photo: ${credit.artist} · ${credit.license}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Small "i" that shows the photographer and licence (no links — kids use it).
class _InfoDot extends StatelessWidget {
  const _InfoDot({required this.credit});
  final PhotoCredit credit;

  @override
  Widget build(BuildContext context) => Tooltip(
    triggerMode: TooltipTriggerMode.tap,
    showDuration: const Duration(seconds: 4),
    message: 'Photo: ${credit.artist}\n${credit.license} · Wikimedia Commons',
    child: Container(
      width: 26,
      height: 26,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Color(0xAA000000),
        shape: BoxShape.circle,
      ),
      child: const Text(
        'i',
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.italic,
        ),
      ),
    ),
  );
}
