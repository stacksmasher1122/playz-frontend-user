import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SecondaryActionButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  SecondaryActionButton({
    super.key,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
        child: Center(
          child: Text(
            text,
            style: AppTypography.bodyMd.copyWith(color: AppColors.primary),
          ),
        ),
      ),
    );
  }
}
