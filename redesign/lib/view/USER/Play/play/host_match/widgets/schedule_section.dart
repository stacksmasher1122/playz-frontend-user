import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/view/USER/Book/booking_details/widgets/booking_time_pickers.dart';

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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.calendar_today_rounded, color: AppColors.accent, size: 18),
            const SizedBox(width: 8),
            Text(
              'Match Schedule',
              style: GoogleFonts.inter(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
                fontSize: ResponsiveHelper.sp(14),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // MATCH DATE CARD
        GestureDetector(
          onTap: onPickDate,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white12),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_month_rounded, color: AppColors.accent, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MATCH DATE',
                        style: GoogleFonts.inter(
                          color: Colors.white54,
                          fontWeight: FontWeight.w600,
                          fontSize: ResponsiveHelper.sp(10),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        selectedDate != null
                            ? DateFormat('EEEE, dd MMMM yyyy').format(selectedDate!)
                            : 'Select Match Date',
                        style: GoogleFonts.inter(
                          color: selectedDate != null ? Colors.white : Colors.white54,
                          fontWeight: FontWeight.bold,
                          fontSize: ResponsiveHelper.sp(14),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_drop_down_rounded, color: Colors.white54, size: 24),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // START TIME & END TIME PICKERS (REUSED FROM BOOKING DETAILS)
        BookingTimePickers(
          startTime: startTime,
          endTime: endTime,
          onPickStartTime: onPickStartTime,
          onPickEndTime: onPickEndTime,
        ),
      ],
    );
  }
}
