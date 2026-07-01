import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class QrActionButtons extends StatelessWidget {
  final VoidCallback onDownload;
  final VoidCallback onSave;

  QrActionButtons({
    super.key,
    required this.onDownload,
    required this.onSave,
  });

  static const _kGreen = AppColors.accent;

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onDownload,
            icon: Icon(Icons.download, color: Colors.black),
            label: Text(
              'Download QR',
              style: TextStyle(color: Colors.black),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _kGreen,
              padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(30)),
              ),
            ),
          ),
        ),
        SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: onSave,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.white24),
              padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(14)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(30)),
              ),
            ),
            child: Text(
              'Save to Gallery',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
