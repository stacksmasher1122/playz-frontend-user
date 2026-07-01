import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class CameraCaptureOverlay extends StatelessWidget {
  CameraCaptureOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      color: Colors.black.withValues(alpha: 0.4),
      child: Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}
