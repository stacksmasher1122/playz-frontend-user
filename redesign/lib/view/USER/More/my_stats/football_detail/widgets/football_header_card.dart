import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/More_Models/sport_stat_model.dart';

class FootballHeaderCard extends StatelessWidget {
  final SportStatModel stat;

  const FootballHeaderCard({super.key, required this.stat});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(14)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(ResponsiveHelper.w(12)),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.sports_soccer, color: AppColors.accent, size: 28),
          ),
          SizedBox(width: ResponsiveHelper.w(14)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Football • Forward / Winger',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.sp(17),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  '${stat.matchesPlayed} Matches • ${stat.wins} Wins • Win Rate ${stat.winRate.toStringAsFixed(1)}%',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: AppColors.muted,
                    fontSize: ResponsiveHelper.sp(12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
