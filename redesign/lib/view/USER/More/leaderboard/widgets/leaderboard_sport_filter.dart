import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class LeaderboardSportFilter extends StatelessWidget {
  final String selectedSport;
  final ValueChanged<String> onSportChanged;

  const LeaderboardSportFilter({
    super.key,
    required this.selectedSport,
    required this.onSportChanged,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final sports = ['All', 'Cricket', 'Football', 'Tennis', 'Badminton'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
      child: Row(
        children: sports.map((sport) {
          final isSelected = sport == selectedSport;
          return Padding(
            padding: EdgeInsets.only(right: ResponsiveHelper.w(10)),
            child: InkWell(
              onTap: () => onSportChanged(sport),
              borderRadius: BorderRadius.circular(20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.w(18),
                  vertical: ResponsiveHelper.h(8),
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppColors.accent : Colors.white24,
                    width: 1,
                  ),
                ),
                child: Text(
                  sport,
                  style: GoogleFonts.inter(
                    color: isSelected ? Colors.black : Colors.white,
                    fontSize: ResponsiveHelper.sp(13),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
