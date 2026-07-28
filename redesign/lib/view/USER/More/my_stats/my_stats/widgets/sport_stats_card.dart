import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/More_Models/sport_stat_model.dart';

class SportStatsCard extends StatelessWidget {
  final SportStatModel stat;
  final VoidCallback onTap;

  const SportStatsCard({
    super.key,
    required this.stat,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveHelper.h(14)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        border: Border.all(
          color: AppColors.divider,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
          splashColor: Colors.white.withValues(alpha: 0.05),
          highlightColor: Colors.white.withValues(alpha: 0.02),
          child: Padding(
            padding: EdgeInsets.all(ResponsiveHelper.w(14)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header Row
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(ResponsiveHelper.w(10)),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: Icon(
                        stat.icon,
                        color: AppColors.accent,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: ResponsiveHelper.w(12)),

                    // Name & Category
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  stat.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: ResponsiveHelper.sp(16),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(width: ResponsiveHelper.w(6)),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: ResponsiveHelper.w(6),
                                  vertical: ResponsiveHelper.h(2),
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.card,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  stat.skillLevel,
                                  style: GoogleFonts.inter(
                                    color: AppColors.accent,
                                    fontSize: ResponsiveHelper.sp(10),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: ResponsiveHelper.h(2)),
                          Text(
                            stat.category,
                            style: GoogleFonts.inter(
                              color: AppColors.muted,
                              fontSize: ResponsiveHelper.sp(11),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: ResponsiveHelper.w(8)),

                    // Matches Counter Badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.w(10),
                        vertical: ResponsiveHelper.h(6),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(ResponsiveHelper.w(10)),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${stat.matchesPlayed}',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: ResponsiveHelper.sp(14),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Matches',
                            style: GoogleFonts.inter(
                              color: AppColors.muted,
                              fontSize: ResponsiveHelper.sp(9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: ResponsiveHelper.h(12)),

                // Win Rate & Progress Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Win Rate: ${stat.winRate.toStringAsFixed(1)}%',
                      style: GoogleFonts.inter(
                        color: Colors.white70,
                        fontSize: ResponsiveHelper.sp(12),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${stat.wins}W - ${stat.losses}L${stat.draws > 0 ? " - ${stat.draws}D" : ""}',
                      style: GoogleFonts.inter(
                        color: AppColors.muted,
                        fontSize: ResponsiveHelper.sp(11),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveHelper.h(6)),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: stat.winRate / 100,
                    backgroundColor: AppColors.card,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
                    minHeight: 6,
                  ),
                ),

                SizedBox(height: ResponsiveHelper.h(12)),

                // Footer Row: Form Chips & CTA (Overflow-safe)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Form Chips
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Text(
                              'Form: ',
                              style: GoogleFonts.inter(
                                color: AppColors.muted,
                                fontSize: ResponsiveHelper.sp(11),
                              ),
                            ),
                            ...stat.recentForm.take(5).map((f) {
                              final isWin = f == 'W';
                              final isDraw = f == 'D';
                              return Container(
                                margin: EdgeInsets.only(right: ResponsiveHelper.w(4)),
                                padding: EdgeInsets.symmetric(
                                  horizontal: ResponsiveHelper.w(5),
                                  vertical: ResponsiveHelper.h(2),
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.card,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  f,
                                  style: GoogleFonts.inter(
                                    color: isWin
                                        ? AppColors.accent
                                        : isDraw
                                            ? Colors.amber
                                            : Colors.redAccent,
                                    fontSize: ResponsiveHelper.sp(10),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(width: ResponsiveHelper.w(8)),

                    // Action Link
                    Row(
                      children: [
                        Text(
                          'Full Stats',
                          style: GoogleFonts.inter(
                            color: AppColors.accent,
                            fontSize: ResponsiveHelper.sp(11),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: ResponsiveHelper.w(4)),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: AppColors.accent,
                          size: 10,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
