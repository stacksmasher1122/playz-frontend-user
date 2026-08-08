import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ScheduleDateTimeWidget extends StatelessWidget {
  final DateTime? startDate;
  final TimeOfDay? startTime;
  final DateTime? endDate;
  final TimeOfDay? endTime;
  final VoidCallback onSelectStartDate;
  final VoidCallback onSelectStartTime;
  final VoidCallback onSelectEndDate;
  final VoidCallback onSelectEndTime;

  const ScheduleDateTimeWidget({
    super.key,
    required this.startDate,
    required this.startTime,
    required this.endDate,
    required this.endTime,
    required this.onSelectStartDate,
    required this.onSelectStartTime,
    required this.onSelectEndDate,
    required this.onSelectEndTime,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final String startDateStr = startDate != null
        ? DateFormat('MMM dd, yyyy').format(startDate!)
        : 'Select Start Date';
    final String startTimeStr = startTime != null
        ? startTime!.format(context)
        : 'Select Start Time';
    final String endDateStr = endDate != null
        ? DateFormat('MMM dd, yyyy').format(endDate!)
        : 'Select End Date';
    final String endTimeStr = endTime != null
        ? endTime!.format(context)
        : 'Select End Time';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Match Schedule & Timings",
          style: AppTypography.headlineSm.copyWith(
            color: AppColors.textPrimary,
            fontSize: ResponsiveHelper.sp(16.0),
            fontWeight: FontWeight.w900,
          ).responsive(context),
        ),
        SizedBox(height: ResponsiveHelper.h(4.0)),
        Text(
          "Set the exact start and end dates and times for the tournament",
          style: AppTypography.bodySm.copyWith(
            color: AppColors.mutedText,
            fontSize: ResponsiveHelper.sp(13.0),
          ).responsive(context),
        ),
        SizedBox(height: ResponsiveHelper.h(14.0)),

        // 2x2 Grid of Start/End Date & Time Cards
        Row(
          children: [
            // Start Date
            Expanded(
              child: _buildPickerCard(
                context,
                title: "START DATE",
                value: startDateStr,
                icon: Icons.calendar_today_rounded,
                onTap: onSelectStartDate,
              ),
            ),
            SizedBox(width: ResponsiveHelper.w(12.0)),
            // Start Time
            Expanded(
              child: _buildPickerCard(
                context,
                title: "START TIME",
                value: startTimeStr,
                icon: Icons.access_time_rounded,
                onTap: onSelectStartTime,
              ),
            ),
          ],
        ),
        SizedBox(height: ResponsiveHelper.h(12.0)),
        Row(
          children: [
            // End Date
            Expanded(
              child: _buildPickerCard(
                context,
                title: "END DATE",
                value: endDateStr,
                icon: Icons.event_rounded,
                onTap: onSelectEndDate,
              ),
            ),
            SizedBox(width: ResponsiveHelper.w(12.0)),
            // End Time
            Expanded(
              child: _buildPickerCard(
                context,
                title: "END TIME",
                value: endTimeStr,
                icon: Icons.timer_outlined,
                onTap: onSelectEndTime,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPickerCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.w(14.0),
          vertical: ResponsiveHelper.h(12.0),
        ),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
          border: Border.all(color: AppColors.borderDark, width: 1.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: AppColors.primary,
                  size: ResponsiveHelper.w(16.0),
                ),
                SizedBox(width: ResponsiveHelper.w(6.0)),
                Text(
                  title,
                  style: AppTypography.labelCaps.copyWith(
                    color: AppColors.mutedText,
                    fontSize: ResponsiveHelper.sp(10.5),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                  ).responsive(context),
                ),
              ],
            ),
            SizedBox(height: ResponsiveHelper.h(8.0)),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: AppTypography.bodyMd.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: ResponsiveHelper.sp(14.0),
                  fontWeight: FontWeight.bold,
                ).responsive(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
