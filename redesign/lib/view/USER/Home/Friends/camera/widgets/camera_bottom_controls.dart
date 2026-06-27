import 'package:flutter/material.dart';
import 'shutter_button.dart';

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
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Flash Toggle (Placeholder)
          IconButton(
            icon: const Icon(Icons.flash_off, color: Colors.white70, size: 28),
            onPressed: () {
              // Future feature: flash toggle
            },
          ),

          // Shutter Button
          ShutterButton(onTap: onCapture),

          // Switch Camera Button
          IconButton(
            icon: const Icon(Icons.flip_camera_ios, color: Colors.white, size: 32),
            onPressed: onSwitchCamera,
          ),
        ],
      ),
    );
  }
}
