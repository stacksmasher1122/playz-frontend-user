import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class DateSelector extends StatelessWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  DateSelector({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  static const _kGreen = AppColors.accent;
  static const _kMuted = Color(0xFFA7A7A7);

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final DateTime today = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(text: 'Select Date'),
        SizedBox(height: 12),

        /// Height is constrained, not fixed (prevents overflow)
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 90),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
            itemCount: 7,
            itemBuilder: (_, index) {
              final date = today.add(Duration(days: index));
              final bool selected =
                  selectedDate != null && _isSameDate(selectedDate!, date);

              final String day = _weekdayShort(date.weekday);
              final String month = _monthShort(date.month);
              final String dateNum = date.day.toString();

              return GestureDetector(
                onTap: () => onDateSelected(date),
                child: Container(
                  width: ResponsiveHelper.w(72),
                  margin: EdgeInsets.only(right: 12),
                  padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(8)),
                  decoration: BoxDecoration(
                    color: selected ? _kGreen : Colors.black,
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
                    border: Border.all(
                      color: selected ? _kGreen : Colors.grey.shade800,
                      width: ResponsiveHelper.w(1.2),
                    ),
                  ),

                  /// IMPORTANT: mainAxisSize.min avoids overflow
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /// DAY
                      Text(
                        index == 0 ? 'TODAY' : day.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        textHeightBehavior: TextHeightBehavior(
                          applyHeightToFirstAscent: false,
                        ),
                        style: TextStyle(
                          color: selected ? Colors.black : _kMuted,
                          fontSize: ResponsiveHelper.sp(11),
                          fontWeight: FontWeight.w600,
                          height: ResponsiveHelper.h(1.1),
                          letterSpacing: 0.6,
                        ),
                      ),

                      SizedBox(height: 6),

                      /// DATE NUMBER
                      Text(
                        dateNum,
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          color: selected ? Colors.black : Colors.white,
                          fontSize: ResponsiveHelper.sp(20),
                          fontWeight: FontWeight.bold,
                          height: ResponsiveHelper.h(1.0),
                        ),
                      ),

                      SizedBox(height: 2),

                      /// MONTH
                      Text(
                        month.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          color: selected ? Colors.black : _kMuted,
                          fontSize: ResponsiveHelper.sp(11),
                          height: ResponsiveHelper.h(1.0),
                          letterSpacing: 0.6,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _weekdayShort(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  String _monthShort(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  _SectionTitle({required this.text});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: ResponsiveHelper.sp(18),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
