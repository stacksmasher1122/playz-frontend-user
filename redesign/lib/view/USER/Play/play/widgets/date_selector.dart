import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class DateSelector extends StatelessWidget {
  DateSelector({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final dates = List.generate(
      10,
      (i) => DateTime.now().add(Duration(days: i)),
    );

    return SizedBox(
      height: ResponsiveHelper.h(76),
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(20)),
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        separatorBuilder: (_, __) => SizedBox(width: 10),
        itemBuilder: (_, i) {
          final selected = i == 0;
          final d = dates[i];

          return Container(
            width: ResponsiveHelper.w(56),
            decoration: BoxDecoration(
              color: selected ? AppColors.accent : AppColors.surface,
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// MONTH
                Text(
                  DateFormat('MMM').format(d), // Dec
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: ResponsiveHelper.sp(11),
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.black : AppColors.muted,
                  ),
                ),

                SizedBox(height: 2),

                /// DATE
                Text(
                  '${d.day}', // 4
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: ResponsiveHelper.sp(16),
                    fontWeight: FontWeight.w700,
                    color: selected ? Colors.black : Colors.white,
                  ),
                ),

                SizedBox(height: 2),

                /// DAY
                Text(
                  DateFormat('EEE').format(d), // Thu
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: ResponsiveHelper.sp(11),
                    fontWeight: FontWeight.w400,
                    color: selected ? Colors.black : AppColors.muted,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
