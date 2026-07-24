import 'package:redesign/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class FormationChipWidget extends StatelessWidget {
  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  FormationChipWidget({
    super.key,
    required this.name,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        margin: EdgeInsets.only(right: 12),
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.w(24),
          vertical: ResponsiveHelper.h(12),
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : Color(0xFF121212),
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.3),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Text(
          name,
          style: TextStyle(
            color: isSelected ? AppColors.background : Colors.white,
            fontSize: ResponsiveHelper.sp(16),
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
