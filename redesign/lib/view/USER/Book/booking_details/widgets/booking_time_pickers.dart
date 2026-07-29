import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class BookingTimePickers extends StatelessWidget {
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final VoidCallback onPickStartTime;
  final VoidCallback onPickEndTime;

  const BookingTimePickers({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.onPickStartTime,
    required this.onPickEndTime,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
      child: Row(
        children: [
          /// START TIME
          Expanded(
            child: _TimeCard(
              label: 'Start Time',
              time: startTime,
              onTap: onPickStartTime,
            ),
          ),

          SizedBox(width: context.widthPct(3)),

          /// END TIME
          Expanded(
            child: _TimeCard(
              label: 'End Time',
              time: endTime,
              onTap: onPickEndTime,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeCard extends StatelessWidget {
  final String label;
  final TimeOfDay? time;
  final VoidCallback onTap;

  const _TimeCard({
    required this.label,
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return InkWell(
      borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.widthPct(4),
          vertical: context.heightPct(1.5),
        ),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
          border: Border.all(color: AppColors.accent, width: 1.2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// LABEL
            Text(
              label,
              maxLines: 1,
              style: AppTypography.bodySm.copyWith(
                color: AppColors.muted,
                fontSize: context.responsiveFont(12),
                fontWeight: FontWeight.w500,
              ),
            ),

            SizedBox(height: context.heightPct(0.8)),

            /// TIME + ICON ROW
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  _formatTime(time),
                  style: AppTypography.headlineSm.copyWith(
                    color: time == null ? AppColors.muted : AppColors.textPrimary,
                    fontSize: context.responsiveFont(18),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.access_time, color: AppColors.accent, size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return '--:--';
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:00 $period';
  }
}
