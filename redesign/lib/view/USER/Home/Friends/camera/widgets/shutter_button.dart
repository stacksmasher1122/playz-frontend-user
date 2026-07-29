import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ShutterButton extends StatelessWidget {
  final VoidCallback onTap;

  const ShutterButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final shutterSize = context.minDimensionPct(18).clamp(64.0, 80.0);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(context.widthPct(1)),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.textPrimary, width: 3),
        ),
        child: Container(
          width: shutterSize,
          height: shutterSize,
          decoration: const BoxDecoration(
            color: AppColors.textPrimary,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
