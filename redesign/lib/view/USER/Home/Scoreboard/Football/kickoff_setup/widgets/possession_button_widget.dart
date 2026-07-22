import 'package:redesign/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PossessionButtonWidget extends StatelessWidget {
  final String badgeText;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  PossessionButtonWidget({
    super.key,
    required this.badgeText,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(16)),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : Color(0xFF121212),
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(8), vertical: ResponsiveHelper.h(4)),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.background.withValues(alpha: 0.1) : Color(0xFF121212),
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(4)),
              ),
              child: Text(
                badgeText,
                style: TextStyle(
                  color: isSelected ? AppColors.background : Colors.grey.shade400,
                  fontSize: ResponsiveHelper.sp(12),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.background : Colors.white,
                fontSize: ResponsiveHelper.sp(14),
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
