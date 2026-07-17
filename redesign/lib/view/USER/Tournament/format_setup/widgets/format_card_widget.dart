import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class FormatCardWidget extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isFullWidth;

  const FormatCardWidget({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.isFullWidth = false,
  });

  @override
  State<FormatCardWidget> createState() => _FormatCardWidgetState();
}

class _FormatCardWidgetState extends State<FormatCardWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(ResponsiveHelper.w(16)),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
          border: Border.all(
            color: widget.isSelected ? AppColors.accent : Colors.transparent,
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: ResponsiveHelper.w(40),
                  height: ResponsiveHelper.w(40),
                  decoration: BoxDecoration(
                    color: widget.isSelected
                        ? AppColors.accent.withValues(alpha: 0.2)
                        : AppColors.surface,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.icon,
                    color: widget.isSelected ? AppColors.accent : AppColors.muted,
                    size: ResponsiveHelper.w(20),
                  ),
                ),
                SizedBox(height: ResponsiveHelper.h(12)),
                Text(
                  widget.title,
                  style: AppTypography.headlineSm.copyWith(
                    color: widget.isSelected ? AppColors.accent : AppColors.onPrimary,
                  ),
                ),
                SizedBox(height: ResponsiveHelper.h(4)),
                Text(
                  widget.description,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
            if (widget.isSelected)
              Positioned(
                top: 0,
                right: 0,
                child: Icon(
                  Icons.check_circle,
                  color: AppColors.accent,
                  size: ResponsiveHelper.w(24),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
