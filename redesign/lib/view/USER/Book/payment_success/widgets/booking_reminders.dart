import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class BookingReminders extends StatelessWidget {
  const BookingReminders({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final reminders = [
      'Arrive 15 minutes early',
      'Wear non-marking shoes / rubber studs',
      'Show QR code at reception',
      'Full refund if cancelled at least 5 days prior to booking date. No refund thereafter.',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Things to Remember',
          style: AppTypography.headlineSm.copyWith(
            color: AppColors.textPrimary,
            fontSize: context.responsiveFont(16),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: context.heightPct(1.2)),
        ...reminders.map(
          (e) => Padding(
            padding: EdgeInsets.only(bottom: context.heightPct(0.8)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: context.heightPct(0.6)),
                  child: const Icon(Icons.circle, size: 6, color: AppColors.accent),
                ),
                SizedBox(width: context.widthPct(2.5)),
                Expanded(
                  child: Text(
                    e,
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.muted,
                      fontSize: context.responsiveFont(13),
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
