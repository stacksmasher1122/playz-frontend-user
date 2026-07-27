import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/More_Models/sport_stat_model.dart';

class MyStatsHeader extends StatelessWidget {
  final List<SportStatModel> allStats;

  const MyStatsHeader({super.key, required this.allStats});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    int totalMatches = allStats.fold(0, (sum, item) => sum + item.matchesPlayed);
    int totalWins = allStats.fold(0, (sum, item) => sum + item.wins);
    double totalHours = allStats.fold(0.0, (sum, item) => sum + item.hoursPlayed);
    int totalMvps = allStats.fold(0, (sum, item) => sum + item.mvpCount);
    double overallWinRate = totalMatches > 0 ? (totalWins / totalMatches) * 100 : 0.0;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        border: Border.all(
          color: AppColors.divider,
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveHelper.w(14)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top User Info & Badge Row
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(ResponsiveHelper.w(8)),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: const Icon(
                    Icons.bar_chart_rounded,
                    color: AppColors.accent,
                    size: 20,
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(10)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Player Performance',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: ResponsiveHelper.sp(15),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Cricket • Football • Badminton',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          color: AppColors.muted,
                          fontSize: ResponsiveHelper.sp(11),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(6)),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.w(8),
                    vertical: ResponsiveHelper.h(4),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 12),
                      SizedBox(width: ResponsiveHelper.w(4)),
                      Text(
                        'Pro Level',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: ResponsiveHelper.sp(10),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: ResponsiveHelper.h(12)),
            const Divider(color: AppColors.divider, height: 1),
            SizedBox(height: ResponsiveHelper.h(12)),

            // Stats Counters Grid Row (Overflow-safe with Flexible)
            Row(
              children: [
                Expanded(
                  child: _StatTile(
                    label: 'Matches',
                    value: '$totalMatches',
                    icon: Icons.sports_score_rounded,
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(6)),
                Expanded(
                  child: _StatTile(
                    label: 'Win Rate',
                    value: '${overallWinRate.toStringAsFixed(1)}%',
                    icon: Icons.emoji_events_rounded,
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(6)),
                Expanded(
                  child: _StatTile(
                    label: 'Hours',
                    value: '${totalHours.toStringAsFixed(0)}h',
                    icon: Icons.timer_rounded,
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(6)),
                Expanded(
                  child: _StatTile(
                    label: 'MVPs',
                    value: '$totalMvps',
                    icon: Icons.workspace_premium_rounded,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.w(4),
        vertical: ResponsiveHelper.h(8),
      ),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(10)),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.accent, size: 14),
          SizedBox(height: ResponsiveHelper.h(2)),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: ResponsiveHelper.sp(13),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(2)),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              color: AppColors.muted,
              fontSize: ResponsiveHelper.sp(9),
            ),
          ),
        ],
      ),
    );
  }
}
