import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class DateSelector extends StatelessWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const DateSelector({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final DateTime today = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(text: 'Select Date'),
        SizedBox(height: context.heightPct(1.2)),

        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: context.heightPct(11).clamp(80.0, 100.0)),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
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
                  width: context.widthPct(18).clamp(64.0, 80.0),
                  margin: EdgeInsets.only(right: context.widthPct(3)),
                  padding: EdgeInsets.symmetric(vertical: context.heightPct(0.8)),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.accent : AppColors.card,
                    borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
                    border: Border.all(
                      color: selected ? AppColors.accent : AppColors.borderDark,
                      width: 1.2,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /// DAY
                      Text(
                        index == 0 ? 'TODAY' : day.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        style: AppTypography.labelCaps10.copyWith(
                          color: selected ? AppColors.background : AppColors.muted,
                          fontSize: context.responsiveFont(11),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.6,
                        ),
                      ),

                      SizedBox(height: context.heightPct(0.5)),

                      /// DATE NUMBER
                      Text(
                        dateNum,
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        style: AppTypography.headlineSm.copyWith(
                          color: selected ? AppColors.background : AppColors.textPrimary,
                          fontSize: context.responsiveFont(20),
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: context.heightPct(0.2)),

                      /// MONTH
                      Text(
                        month.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        style: AppTypography.labelCaps10.copyWith(
                          color: selected ? AppColors.background : AppColors.muted,
                          fontSize: context.responsiveFont(11),
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
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
      child: Text(
        text,
        style: AppTypography.headlineSm.copyWith(
          color: AppColors.textPrimary,
          fontSize: context.responsiveFont(18),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
