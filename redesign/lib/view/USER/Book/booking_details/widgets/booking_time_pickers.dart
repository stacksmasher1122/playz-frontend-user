import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class BookingTimePickers extends StatelessWidget {
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final VoidCallback onPickStartTime;
  final VoidCallback onPickEndTime;

  BookingTimePickers({
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
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
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

          SizedBox(width: 12),

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

  _TimeCard({
    required this.label,
    required this.time,
    required this.onTap,
  });

  static const _kGreen = AppColors.accent;
  static const _kMuted = Color(0xFFA7A7A7);

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return InkWell(
      borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(14)),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
          border: Border.all(color: _kGreen, width: 1.2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// LABEL
            Text(
              label,
              maxLines: 1,
              style: TextStyle(
                color: _kMuted,
                fontSize: ResponsiveHelper.sp(12),
                fontWeight: FontWeight.w500,
                height: ResponsiveHelper.h(1.1),
              ),
            ),

            SizedBox(height: 8),

            /// TIME + ICON ROW (PROPERLY ALIGNED)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  _formatTime(time),
                  style: TextStyle(
                    color: time == null ? _kMuted : Colors.white,
                    fontSize: ResponsiveHelper.sp(18),
                    fontWeight: FontWeight.bold,
                    height: ResponsiveHelper.h(1.1),
                  ),
                ),
                Spacer(),
                Icon(Icons.access_time, color: _kGreen, size: 18),
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
