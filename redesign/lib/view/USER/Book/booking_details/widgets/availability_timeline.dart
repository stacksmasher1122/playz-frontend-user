import 'package:flutter/material.dart';
import 'package:redesign/model/User_Models/Booking_Models/slot_model.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class AvailabilityTimeline extends StatelessWidget {
  final ScrollController controller;
  final List<SlotModel> slots;
  final bool isLoading;
  final DateTime? selectedDate;

  const AvailabilityTimeline({
    super.key,
    required this.controller,
    required this.slots,
    this.isLoading = false,
    this.selectedDate,
  });

  static const _kMuted = Color(0xFFA7A7A7);

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final now = DateTime.now();
    final isToday = selectedDate == null ||
        (selectedDate!.year == now.year &&
            selectedDate!.month == now.month &&
            selectedDate!.day == now.day);
    final currentHour = now.hour;

    // Build timeline slots — use real data if available, otherwise generate defaults
    final List<_TimelineSlotData> timelineSlots;

    if (slots.isNotEmpty) {
      final sortedSlots = List<SlotModel>.from(slots)
        ..sort((a, b) => (a.startHour ?? 0).compareTo(b.startHour ?? 0));

      timelineSlots = sortedSlots.map((slot) {
        final startH = slot.startHour;
        final endH = slot.endHour;
        final startFormatted = startH != null ? _formatHour(startH) : '';
        final endFormatted = endH != null ? _formatHour(endH) : '';
        final bool isPast = isToday && (startH != null && startH < currentHour);
        final bool isFree = !isPast && (slot.isAvailable && !slot.isBooked && slot.status == 'available');

        return _TimelineSlotData(
          start: startFormatted,
          end: endFormatted,
          timeRange: slot.timeRange.isNotEmpty
              ? slot.timeRange
              : '$startFormatted - $endFormatted',
          isFree: isFree,
          isPast: isPast,
          isPeak: slot.isPeak,
          price: slot.price,
        );
      }).toList();
    } else {
      timelineSlots = List.generate(24, (index) {
        final int start = index; // 0..23 (12 AM to 11 PM)
        final int end = (index + 1) % 24;
        final startFormatted = _formatHour(start);
        final endFormatted = _formatHour(end);

        final bool isPast = isToday && (start < currentHour);

        return _TimelineSlotData(
          start: startFormatted,
          end: endFormatted,
          timeRange: '$startFormatted - $endFormatted',
          isFree: !isPast, // Past slots marked unavailable
          isPast: isPast,
          isPeak: false,
          price: 0,
        );
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
          child: Row(
            children: [
              Text(
                'Availability Timeline',
                style: TextStyle(
                  color: _kMuted,
                  fontSize: ResponsiveHelper.sp(14),
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (isLoading) ...[
                SizedBox(width: 8),
                SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ],
          ),
        ),
        SizedBox(height: 12),

        /// SINGLE SCROLLABLE TIMELINE
        SingleChildScrollView(
          controller: controller,
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
          child: Row(
            children: List.generate(timelineSlots.length, (index) {
              final slot = timelineSlots[index];
              final bool isFirst = index == 0;
              final bool isLast = index == timelineSlots.length - 1;

              return Row(
                children: [
                  _TimelineBlock(
                    slot: slot,
                    isFirst: isFirst,
                    isLast: isLast,
                  ),
                  if (!isLast)
                    Container(
                      width: ResponsiveHelper.w(2),
                      height: ResponsiveHelper.h(64),
                      color: Colors.grey.shade800,
                    ),
                ],
              );
            }),
          ),
        ),

        SizedBox(height: 12),

        /// LEGEND
        Padding(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
          child: Row(
            children: [
              _LegendDot(color: Color(0xFFD60101)),
              SizedBox(width: 6),
              Text('Booked', style: TextStyle(color: _kMuted, fontSize: ResponsiveHelper.sp(12))),
              SizedBox(width: 16),
              _LegendDot(color: Color(0xFF00B45D)),
              SizedBox(width: 6),
              Text('Available', style: TextStyle(color: _kMuted, fontSize: ResponsiveHelper.sp(12))),
              SizedBox(width: 16),
              _LegendDot(color: Color(0xFF555555)),
              SizedBox(width: 6),
              Text('Unavailable', style: TextStyle(color: _kMuted, fontSize: ResponsiveHelper.sp(12))),
            ],
          ),
        ),
      ],
    );
  }

  String _formatHour(int hour) {
    final int h = hour % 24;
    final int displayHour = h == 0 ? 12 : (h > 12 ? h - 12 : h);
    final String period = h >= 12 ? 'PM' : 'AM';
    final String hourStr = displayHour < 10 ? '0$displayHour' : '$displayHour';
    return '$hourStr:00 $period';
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  const _LegendDot({required this.color});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      width: ResponsiveHelper.w(10),
      height: ResponsiveHelper.h(10),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}



class _TimelineBlock extends StatelessWidget {
  final _TimelineSlotData slot;
  final bool isFirst;
  final bool isLast;

  const _TimelineBlock({
    required this.slot,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    Color bgColor;
    Color textColor;
    String statusLabel;

    if (slot.isPast) {
      bgColor = Color(0xFF333333); // Grey - past / unavailable
      textColor = Colors.white54;
      statusLabel = 'UNAVAILABLE';
    } else if (slot.isFree) {
      bgColor = Color.fromARGB(255, 0, 180, 93); // Available - green
      textColor = Colors.black;
      statusLabel = 'AVAILABLE';
    } else {
      bgColor = Color.fromARGB(255, 214, 1, 1); // Booked - red
      textColor = Colors.white;
      statusLabel = 'BOOKED';
    }

    return Container(
      width: ResponsiveHelper.w(110),
      height: ResponsiveHelper.h(64),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.w(4),
        vertical: ResponsiveHelper.h(2),
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.horizontal(
          left: isFirst ? Radius.circular(ResponsiveHelper.w(12)) : Radius.zero,
          right: isLast ? Radius.circular(ResponsiveHelper.w(12)) : Radius.zero,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            /// EXACT TIME RANGE ON TAB
            Text(
              slot.timeRange,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: textColor,
                fontSize: ResponsiveHelper.sp(10),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2),

            /// STATUS PILL
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.w(6),
                vertical: ResponsiveHelper.h(1),
              ),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(4)),
              ),
              child: Text(
                statusLabel,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.sp(9),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),

            if (slot.price > 0) ...[
              SizedBox(height: 1),
              Text(
                '₹${slot.price.toInt()}',
                style: TextStyle(
                  color: textColor.withValues(alpha: 0.9),
                  fontSize: ResponsiveHelper.sp(9),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Internal data class for timeline rendering
class _TimelineSlotData {
  final String start;
  final String end;
  final String timeRange;
  final bool isFree;
  final bool isPast;
  final bool isPeak;
  final double price;

  _TimelineSlotData({
    required this.start,
    required this.end,
    required this.timeRange,
    required this.isFree,
    this.isPast = false,
    this.isPeak = false,
    this.price = 0,
  });
}
