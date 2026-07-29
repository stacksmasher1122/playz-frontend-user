import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'shutter_button.dart';
import 'package:redesign/theme/responsive_helper.dart';

class CameraBottomControls extends StatelessWidget {
  final VoidCallback onCapture;
  final VoidCallback onSwitchCamera;

  const CameraBottomControls({
    super.key,
    required this.onCapture,
    required this.onSwitchCamera,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Positioned(
      bottom: context.heightPct(5),
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Flash Toggle (Placeholder)
          IconButton(
            icon: const Icon(Icons.flash_off, color: AppColors.textSecondary, size: 28),
            onPressed: () {
              // Future feature: flash toggle
            },
          ),

          // Shutter Button
          ShutterButton(onTap: onCapture),

          // Switch Camera Button
          IconButton(
            icon: const Icon(Icons.flip_camera_ios, color: AppColors.textPrimary, size: 32),
            onPressed: onSwitchCamera,
          ),
        ],
      ),
    );
  }
}
