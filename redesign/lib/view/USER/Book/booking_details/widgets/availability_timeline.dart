import 'package:flutter/material.dart';
import 'package:redesign/model/User_Models/Booking_Models/slot_model.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
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
          padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
          child: Row(
            children: [
              Text(
                'Availability Timeline',
                style: AppTypography.headlineSm.copyWith(
                  color: AppColors.muted,
                  fontSize: context.responsiveFont(14),
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (isLoading) ...[
                SizedBox(width: context.widthPct(2)),
                const SizedBox(
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
        SizedBox(height: context.heightPct(1.5)),

        /// SINGLE SCROLLABLE TIMELINE
        SingleChildScrollView(
          controller: controller,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
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
                      width: 2,
                      height: context.heightPct(7.5).clamp(50.0, 70.0),
                      color: AppColors.borderDark,
                    ),
                ],
              );
            }),
          ),
        ),

        SizedBox(height: context.heightPct(1.5)),

        /// LEGEND
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
          child: Row(
            children: [
              const _LegendDot(color: AppColors.error),
              SizedBox(width: context.widthPct(1.5)),
              Text(
                'Booked',
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.muted,
                  fontSize: context.responsiveFont(12),
                ),
              ),
              SizedBox(width: context.widthPct(4)),
              const _LegendDot(color: AppColors.accent),
              SizedBox(width: context.widthPct(1.5)),
              Text(
                'Available',
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.muted,
                  fontSize: context.responsiveFont(12),
                ),
              ),
              SizedBox(width: context.widthPct(4)),
              const _LegendDot(color: AppColors.borderDark),
              SizedBox(width: context.widthPct(1.5)),
              Text(
                'Unavailable',
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.muted,
                  fontSize: context.responsiveFont(12),
                ),
              ),
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
      width: 10,
      height: 10,
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
      bgColor = AppColors.surface; // Past / unavailable
      textColor = AppColors.muted;
      statusLabel = 'UNAVAILABLE';
    } else if (slot.isFree) {
      bgColor = AppColors.accent; // Available - green
      textColor = AppColors.background;
      statusLabel = 'AVAILABLE';
    } else {
      bgColor = AppColors.error; // Booked - red
      textColor = AppColors.textPrimary;
      statusLabel = 'BOOKED';
    }

    final blockWidth = context.widthPct(28).clamp(90.0, 130.0);
    final blockHeight = context.heightPct(7.5).clamp(50.0, 70.0);

    return Container(
      width: blockWidth,
      height: blockHeight,
      padding: EdgeInsets.symmetric(
        horizontal: context.widthPct(1),
        vertical: context.heightPct(0.3),
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.horizontal(
          left: isFirst ? Radius.circular(context.minDimensionPct(3)) : Radius.zero,
          right: isLast ? Radius.circular(context.minDimensionPct(3)) : Radius.zero,
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
              style: AppTypography.headlineSm.copyWith(
                color: textColor,
                fontSize: context.responsiveFont(10),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: context.heightPct(0.3)),

            /// STATUS PILL
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.widthPct(1.5),
                vertical: context.heightPct(0.1),
              ),
              decoration: BoxDecoration(
                color: AppColors.background.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(context.minDimensionPct(1)),
              ),
              child: Text(
                statusLabel,
                style: AppTypography.labelCaps10.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: context.responsiveFont(9),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),

            if (slot.price > 0) ...[
              SizedBox(height: context.heightPct(0.2)),
              Text(
                '₹${slot.price.toInt()}',
                style: AppTypography.bodySm.copyWith(
                  color: textColor.withValues(alpha: 0.9),
                  fontSize: context.responsiveFont(9),
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
