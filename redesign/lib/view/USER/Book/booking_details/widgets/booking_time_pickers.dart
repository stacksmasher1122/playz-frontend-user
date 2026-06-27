import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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

          const SizedBox(width: 12),

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

  static const _kGreen = AppColors.accent;
  static const _kMuted = Color(0xFFA7A7A7);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(14),
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
              style: const TextStyle(
                color: _kMuted,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 1.1,
              ),
            ),

            const SizedBox(height: 8),

            /// TIME + ICON ROW (PROPERLY ALIGNED)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  _formatTime(time),
                  style: TextStyle(
                    color: time == null ? _kMuted : Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.access_time, color: _kGreen, size: 18),
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
