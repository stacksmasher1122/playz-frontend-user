import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class NextButton extends StatelessWidget {
  final VoidCallback onPressed;

  NextButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.only(top: ResponsiveHelper.h(24.0), bottom: 32.0),
      child: SizedBox(
        width: double.infinity,
        height: ResponsiveHelper.h(60),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryContainer,
            foregroundColor: AppColors.onPrimaryContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
            ),
            elevation: 8,
            shadowColor: AppColors.primaryContainer.withOpacity(0.5),
          ),
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'NEXT',
                style: AppTypography.headlineSm.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(width: 12),
              Icon(Icons.arrow_forward),
            ],
          ),
        ),
      ),
    );
  }
}
