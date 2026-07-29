import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class CameraCaptureOverlay extends StatelessWidget {
  const CameraCaptureOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      color: Colors.black.withValues(alpha: 0.4),
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.accent),
      ),
    );
  }
}
