import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class CameraTopBar extends StatelessWidget {
  CameraTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Positioned(
      top: ResponsiveHelper.h(40),
      left: ResponsiveHelper.w(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.4),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(Icons.close, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}
