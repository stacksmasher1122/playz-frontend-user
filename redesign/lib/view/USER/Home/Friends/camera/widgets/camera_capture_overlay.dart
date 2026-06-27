import 'package:flutter/material.dart';

class CameraCaptureOverlay extends StatelessWidget {
  const CameraCaptureOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.4),
      child: const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}
