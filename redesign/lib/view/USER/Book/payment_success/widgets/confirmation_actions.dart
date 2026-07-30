import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ConfirmationActions extends StatelessWidget {
  final VoidCallback onGoToBookings;

  const ConfirmationActions({
    super.key,
    required this.onGoToBookings,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.minDimensionPct(8)),
          ),
          padding: EdgeInsets.symmetric(vertical: context.heightPct(1.8)),
        ),
        onPressed: onGoToBookings,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'Go to My Bookings',
            style: AppTypography.headlineSm.copyWith(
              color: AppColors.background,
              fontSize: context.responsiveFont(16),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
