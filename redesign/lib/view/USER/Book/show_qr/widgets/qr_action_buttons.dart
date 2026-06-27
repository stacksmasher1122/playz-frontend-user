import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

class QrActionButtons extends StatelessWidget {
  final VoidCallback onDownload;
  final VoidCallback onSave;

  const QrActionButtons({
    super.key,
    required this.onDownload,
    required this.onSave,
  });

  static const _kGreen = AppColors.accent;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onDownload,
            icon: const Icon(Icons.download, color: Colors.black),
            label: const Text(
              'Download QR',
              style: TextStyle(color: Colors.black),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _kGreen,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: onSave,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white24),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'Save to Gallery',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
