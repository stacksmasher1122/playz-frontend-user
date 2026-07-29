import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ScheduleSection extends StatelessWidget {
  final DateTime? selectedDate;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final VoidCallback onPickDate;
  final VoidCallback onPickStartTime;
  final VoidCallback onPickEndTime;

  const ScheduleSection({
    super.key,
    required this.selectedDate,
    required this.startTime,
    required this.endTime,
    required this.onPickDate,
    required this.onPickStartTime,
    required this.onPickEndTime,
  });

  String _formatTimeOfDay(TimeOfDay tod) {
    final hour = tod.hourOfPeriod == 0 ? 12 : tod.hourOfPeriod;
    final period = tod.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:00 $period';
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final dateStr = selectedDate != null
        ? DateFormat('EEE, d MMM yyyy').format(selectedDate!)
        : 'Select Match Date';

    final startStr = startTime != null ? _formatTimeOfDay(startTime!) : 'Start Time';
    final endStr = endTime != null ? _formatTimeOfDay(endTime!) : 'End Time';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.calendar_today_rounded, color: AppColors.accent, size: 18),
            SizedBox(width: context.widthPct(2)),
            Text(
              'Match Schedule & Timing',
              style: AppTypography.headlineSm.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
                fontSize: context.responsiveFont(14),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        SizedBox(height: context.heightPct(1.2)),

        // DATE PICKER TILE
        GestureDetector(
          onTap: onPickDate,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.widthPct(4),
              vertical: context.heightPct(1.5),
            ),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
              border: Border.all(color: AppColors.borderDark),
            ),
            child: Row(
              children: [
                const Icon(Icons.event_outlined, color: AppColors.accent, size: 20),
                SizedBox(width: context.widthPct(3)),
                Expanded(
                  child: Text(
                    dateStr,
                    style: AppTypography.headlineSm.copyWith(
                      color: selectedDate != null ? AppColors.textPrimary : AppColors.muted,
                      fontWeight: FontWeight.w600,
                      fontSize: context.responsiveFont(14),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.arrow_drop_down_rounded, color: AppColors.muted),
              ],
            ),
          ),
        ),

        SizedBox(height: context.heightPct(1.2)),

        // START & END TIME PICKERS ROW
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: onPickStartTime,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.widthPct(3.5),
                    vertical: context.heightPct(1.5),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
                    border: Border.all(color: AppColors.borderDark),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time_rounded, color: AppColors.accent, size: 18),
                      SizedBox(width: context.widthPct(2)),
                      Expanded(
                        child: Text(
                          startStr,
                          style: AppTypography.headlineSm.copyWith(
                            color: startTime != null ? AppColors.textPrimary : AppColors.muted,
                            fontWeight: FontWeight.w600,
                            fontSize: context.responsiveFont(13),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: context.widthPct(2.5)),
            Expanded(
              child: GestureDetector(
                onTap: onPickEndTime,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.widthPct(3.5),
                    vertical: context.heightPct(1.5),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
                    border: Border.all(color: AppColors.borderDark),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time_filled_rounded, color: AppColors.accent, size: 18),
                      SizedBox(width: context.widthPct(2)),
                      Expanded(
                        child: Text(
                          endStr,
                          style: AppTypography.headlineSm.copyWith(
                            color: endTime != null ? AppColors.textPrimary : AppColors.muted,
                            fontWeight: FontWeight.w600,
                            fontSize: context.responsiveFont(13),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
