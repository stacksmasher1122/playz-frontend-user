import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ConfirmationActions extends StatelessWidget {
  final VoidCallback onGoToBookings;
  final VoidCallback onInviteFriends;

  const ConfirmationActions({
    super.key,
    required this.onGoToBookings,
    required this.onInviteFriends,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      children: [
        SizedBox(
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
        ),
        SizedBox(height: context.heightPct(1.5)),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.borderDark),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(context.minDimensionPct(8)),
            ),
            padding: EdgeInsets.symmetric(
              vertical: context.heightPct(1.5),
              horizontal: context.widthPct(8),
            ),
          ),
          onPressed: onInviteFriends,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Invite Friends',
              style: AppTypography.headlineSm.copyWith(
                color: AppColors.textPrimary,
                fontSize: context.responsiveFont(14),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
