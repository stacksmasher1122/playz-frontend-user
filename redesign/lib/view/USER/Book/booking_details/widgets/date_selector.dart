import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

class DateSelector extends StatelessWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const DateSelector({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  static const _kGreen = AppColors.accent;
  static const _kMuted = Color(0xFFA7A7A7);

  @override
  Widget build(BuildContext context) {
    final DateTime today = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(text: 'Select Date'),
        const SizedBox(height: 12),

        /// Height is constrained, not fixed (prevents overflow)
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 90),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  width: 72,
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: selected ? _kGreen : Colors.black,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: selected ? _kGreen : Colors.grey.shade800,
                      width: 1.2,
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
                        textHeightBehavior: const TextHeightBehavior(
                          applyHeightToFirstAscent: false,
                        ),
                        style: TextStyle(
                          color: selected ? Colors.black : _kMuted,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          height: 1.1,
                          letterSpacing: 0.6,
                        ),
                      ),

                      const SizedBox(height: 6),

                      /// DATE NUMBER
                      Text(
                        dateNum,
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          color: selected ? Colors.black : Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          height: 1.0,
                        ),
                      ),

                      const SizedBox(height: 2),

                      /// MONTH
                      Text(
                        month.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          color: selected ? Colors.black : _kMuted,
                          fontSize: 11,
                          height: 1.0,
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
  const _SectionTitle({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
