import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PlayTabs extends StatelessWidget {
  PlayTabs({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(20), vertical: ResponsiveHelper.h(8)),
      child: Row(
        children: [
          Text(
            'Game Diary',
            style: GoogleFonts.inter(
              color: AppColors.muted,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 20),
          Text(
            'All Games',
            style: GoogleFonts.inter(
              color: AppColors.accent,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
