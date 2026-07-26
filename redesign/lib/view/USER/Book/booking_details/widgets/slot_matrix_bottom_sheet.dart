import 'package:flutter/material.dart';
import 'package:redesign/model/User_Models/Booking_Models/slot_model.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SlotMatrixBottomSheet extends StatelessWidget {
  final bool isStart;
  final TimeOfDay? startTime;
  final TimeOfDay? selectedTime;
  final DateTime? selectedDate;
  final List<SlotModel> slots;
  final ValueChanged<TimeOfDay> onSlotSelected;

  const SlotMatrixBottomSheet({
    super.key,
    required this.isStart,
    this.startTime,
    required this.selectedTime,
    this.selectedDate,
    required this.slots,
    required this.onSlotSelected,
  });

  // Matte Colors
  static const _kMatteGreenBorder = Color(0xFF00B45D);
  static const _kMatteRedBorder = Color(0xFF8B2626);

  int get _turfStartHour {
    if (slots.isNotEmpty) {
      final hours = slots.map((s) => s.startHour).whereType<int>().toList();
      if (hours.isNotEmpty) {
        hours.sort();
        return hours.first;
      }
    }
    return 6; // Default 6 AM
  }

  int get _turfEndHour {
    if (slots.isNotEmpty) {
      final hours = slots.map((s) => s.endHour ?? ((s.startHour ?? 0) + 1)).whereType<int>().toList();
      if (hours.isNotEmpty) {
        hours.sort();
        final last = hours.last;
        return last == 0 ? 24 : last;
      }
    }
    return 24; // Default 12 AM Midnight
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final now = DateTime.now();
    final isToday = selectedDate == null ||
        (selectedDate!.year == now.year &&
            selectedDate!.month == now.month &&
            selectedDate!.day == now.day);
    final currentHour = now.hour;

    final List<_MatrixItem> items = [];

    if (isStart) {
      // START TIME SHEET: Only hours from turf opening to closing - 1
      final startH = _turfStartHour;
      final endH = _turfEndHour;

      final totalStartHours = (endH > startH) ? (endH - startH) : (24 - startH + endH);

      for (int i = 0; i < totalStartHours; i++) {
        final hour = (startH + i) % 24;

        // Skip past hours if booking date is TODAY
        if (isToday && hour < currentHour) {
          continue;
        }

        final slot = _findSlotByHour(hour);
        final bool isAvailable = slot != null
            ? (slot.isAvailable && !slot.isBooked && slot.status == 'available')
            : true;

        items.add(_MatrixItem(
          displayTime: _formatHour(hour),
          targetHour: hour,
          subtitle: null,
          isAvailable: isAvailable,
        ));
      }
    } else {
      // END TIME SHEET: Only hours AFTER startTime up to turf closing hour
      final int startH = startTime?.hour ?? _turfStartHour;
      final int maxEndH = _turfEndHour;

      final maxPossibleOffset = (maxEndH > startH) ? (maxEndH - startH) : (24 - startH + maxEndH);
      final limitOffset = maxPossibleOffset > 0 ? maxPossibleOffset : 12;

      for (int offset = 1; offset <= limitOffset; offset++) {
        final int endH = (startH + offset) % 24;
        final int durationHours = offset;

        // Verify if all slots between startH and endH are free
        bool allSlotsFree = true;
        for (int step = 0; step < offset; step++) {
          final checkH = (startH + step) % 24;
          final s = _findSlotByHour(checkH);
          if (s != null && (!s.isAvailable || s.isBooked || s.status != 'available')) {
            allSlotsFree = false;
            break;
          }
        }

        final durationText = durationHours == 1 ? '1 hr' : '$durationHours hrs';

        items.add(_MatrixItem(
          displayTime: _formatHour(endH),
          targetHour: endH,
          subtitle: durationText,
          isAvailable: allSlotsFree,
        ));
      }
    }

    final title = isStart
        ? 'Select Start Time'
        : 'Select End Time (From ${_formatHour(startTime?.hour ?? _turfStartHour)})';

    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ResponsiveHelper.w(24)),
        ),
      ),
      child: Column(
        children: [
          /// HEADER
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.w(16),
              vertical: ResponsiveHelper.h(14),
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
              ),
            ),
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade600,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ResponsiveHelper.sp(15),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white70),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                SizedBox(height: 4),

                /// LEGEND
                Row(
                  children: [
                    _LegendItem(color: _kMatteGreenBorder, label: 'Available'),
                    SizedBox(width: 16),
                    _LegendItem(color: _kMatteRedBorder, label: 'Booked'),
                  ],
                ),
              ],
            ),
          ),

          /// 4 COLUMNS MATRIX GRID
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Text(
                        'No more slots available for today.',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ),
                  )
                : GridView.builder(
                    padding: EdgeInsets.all(ResponsiveHelper.w(12)),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 1.35,
                      crossAxisSpacing: 6,
                      mainAxisSpacing: 6,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final isSelected = selectedTime != null &&
                          selectedTime!.hour == item.targetHour;

                      return _MatteSlotCard(
                        item: item,
                        isSelected: isSelected,
                        onTap: () {
                          if (!item.isAvailable) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isStart
                                      ? 'This start time is already booked!'
                                      : 'Slot range includes booked hours!',
                                ),
                                backgroundColor: _kMatteRedBorder,
                                duration: Duration(seconds: 2),
                              ),
                            );
                            return;
                          }

                          onSlotSelected(TimeOfDay(hour: item.targetHour, minute: 0));
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  SlotModel? _findSlotByHour(int hour) {
    if (slots.isEmpty) return null;
    for (final s in slots) {
      if (s.startHour == hour) return s;
    }
    return null;
  }

  String _formatHour(int hour) {
    final int h = hour % 24;
    final int displayHour = h == 0 ? 12 : (h > 12 ? h - 12 : h);
    final String period = h >= 12 ? 'PM' : 'AM';
    final String hourStr = displayHour < 10 ? '0$displayHour' : '$displayHour';
    return '$hourStr:00 $period';
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: Color(0xFFA7A7A7),
            fontSize: ResponsiveHelper.sp(12),
          ),
        ),
      ],
    );
  }
}

class _MatteSlotCard extends StatelessWidget {
  final _MatrixItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _MatteSlotCard({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  static const _kMatteGreenBg = Color(0xFF1B382B);
  static const _kMatteGreenBorder = Color(0xFF00B45D);
  static const _kMatteRedBg = Color(0xFF381B1B);
  static const _kMatteRedBorder = Color(0xFF8B2626);

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final Color bgColor = item.isAvailable ? _kMatteGreenBg : _kMatteRedBg;
    final Color borderColor = item.isAvailable ? _kMatteGreenBorder : _kMatteRedBorder;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 180),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.w(4),
          vertical: ResponsiveHelper.h(4),
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
          border: Border.all(
            color: isSelected ? Colors.white : borderColor,
            width: isSelected ? 1.8 : 1.0,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                item.displayTime,
                maxLines: 1,
                style: TextStyle(
                  color: item.isAvailable ? Colors.white : Colors.white54,
                  fontSize: ResponsiveHelper.sp(10.5),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (item.subtitle != null) ...[
              SizedBox(height: 2),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  item.subtitle!,
                  style: TextStyle(
                    color: item.isAvailable ? AppColors.accent : Colors.white38,
                    fontSize: ResponsiveHelper.sp(9.5),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MatrixItem {
  final String displayTime;
  final int targetHour;
  final String? subtitle;
  final bool isAvailable;

  _MatrixItem({
    required this.displayTime,
    required this.targetHour,
    this.subtitle,
    required this.isAvailable,
  });
}
