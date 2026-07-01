import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class BottomEndMatchButton extends StatelessWidget {
  final VoidCallback onTap;

  BottomEndMatchButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      color: AppColors.background,
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(12)),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: ResponsiveHelper.h(50),
          decoration: BoxDecoration(
            color: Color(0xFF8B0000), // Dark red as requested for warning/serious tone
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
          ),
          child: Center(
            child: Text(
              'END MATCH',
              style: AppTypography.headlineMd.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
