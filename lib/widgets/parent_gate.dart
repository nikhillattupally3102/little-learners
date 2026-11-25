import 'dart:math';

import 'package:flutter/material.dart';

import 'pic.dart';

import '../theme.dart';

/// Asks a quick multiplication question so only grown-ups can manage profiles.
Future<bool> showParentGate(BuildContext context) async {
  final r = Random();
  final a = r.nextInt(7) + 3, b = r.nextInt(7) + 3;
  final controller = TextEditingController();
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) {
      String? error;
      return StatefulBuilder(
        builder: (context, setState) {
          void check() {
            if (int.tryParse(controller.text.trim()) == a * b) {
              Navigator.of(context).pop(true);
            } else {
              setState(() => error = 'Not quite — try again');
            }
          }

          return AlertDialog(
            backgroundColor: AppColors.cream,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            title: const PicLabel(
              '👪 Grown-ups only',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'What is $a × $b?',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24),
                  decoration: InputDecoration(
                    errorText: error,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onSubmitted: (_) => check(),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              FilledButton(onPressed: check, child: const Text('Continue')),
            ],
          );
        },
      );
    },
  );
  controller.dispose();
  return ok ?? false;
}
