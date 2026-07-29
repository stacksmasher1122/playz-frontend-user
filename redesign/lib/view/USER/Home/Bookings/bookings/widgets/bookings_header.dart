import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class BookingsHeader extends StatelessWidget {
  const BookingsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.widthPct(4),
        context.heightPct(1.5),
        context.widthPct(4),
        context.heightPct(1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Bookings',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.displayLg.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: context.responsiveFont(22),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: context.heightPct(0.4)),
                Text(
                  'Upcoming sessions & history',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: context.responsiveFont(13),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
