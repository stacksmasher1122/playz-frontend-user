import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SportFilters extends StatelessWidget {
  SportFilters({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final sports = [
      ('Cricket', Icons.sports_cricket),
      ('Football', Icons.sports_soccer),
      ('Badminton', Icons.sports_tennis),
    ];

    return SizedBox(
      height: ResponsiveHelper.h(44),
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(20)),
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, i) {
          final active = i == 0;
          return Container(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(14)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(24)),
              border: Border.all(
                color: active ? AppColors.accent : Colors.transparent,
              ),
              color: AppColors.surface,
            ),
            child: Row(
              children: [
                Icon(
                  sports[i].$2,
                  size: 16,
                  color: active ? AppColors.accent : Colors.white,
                ),
                SizedBox(width: 6),
                Text(
                  sports[i].$1,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (_, __) => SizedBox(width: 12),
        itemCount: sports.length,
      ),
    );
  }
}
