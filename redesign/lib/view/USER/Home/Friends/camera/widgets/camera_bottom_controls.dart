import 'package:flutter/material.dart';
import 'shutter_button.dart';
import 'package:redesign/theme/responsive_helper.dart';

class CameraBottomControls extends StatelessWidget {
  final VoidCallback onCapture;
  final VoidCallback onSwitchCamera;

  CameraBottomControls({
    super.key,
    required this.onCapture,
    required this.onSwitchCamera,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Positioned(
      bottom: ResponsiveHelper.h(40),
      left: ResponsiveHelper.w(0),
      right: ResponsiveHelper.w(0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Flash Toggle (Placeholder)
          IconButton(
            icon: Icon(Icons.flash_off, color: Colors.white70, size: 28),
            onPressed: () {
              // Future feature: flash toggle
            },
          ),

          // Shutter Button
          ShutterButton(onTap: onCapture),

          // Switch Camera Button
          IconButton(
            icon: Icon(Icons.flip_camera_ios, color: Colors.white, size: 32),
            onPressed: onSwitchCamera,
          ),
        ],
      ),
    );
  }
}
