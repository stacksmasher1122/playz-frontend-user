import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

/// A reusable, non-sticky Start Match button widget with custom padding,
/// margin, rounded corners, and glowing elevation. Designed to sit naturally
/// inside scrollable layout columns instead of sticking to the screen bottom.
class CommonStartMatchButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isLoading;

  const CommonStartMatchButton({
    super.key,
    this.label = 'START MATCH',
    required this.onPressed,
    this.margin,
    this.backgroundColor,
    this.textColor,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final bg = backgroundColor ?? AppColors.accent;
    final fg = textColor ?? AppColors.background;

    return Container(
      margin: margin ?? EdgeInsets.symmetric(
        vertical: ResponsiveHelper.h(24.0),
      ),
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          minimumSize: Size(double.infinity, ResponsiveHelper.h(56.0)),
          padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16.0)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(16.0)),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                width: ResponsiveHelper.w(24.0),
                height: ResponsiveHelper.w(24.0),
                child: CircularProgressIndicator(
                  color: fg,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                label.toUpperCase(),
                style: AppTypography.headlineSm.copyWith(
                  color: fg,
                  fontSize: ResponsiveHelper.sp(16.0),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ).responsive(context),
              ),
      ),
    );
  }
}
