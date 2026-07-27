import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/More_Models/goals_missions_model.dart';

class DailyMissionsSection extends StatelessWidget {
  final List<DailyMissionModel> missions;
  final String resetCountdown;
  final Function(DailyMissionModel) onClaim;

  const DailyMissionsSection({
    super.key,
    required this.missions,
    required this.resetCountdown,
    required this.onClaim,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daily Missions',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.sp(18),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.timer_outlined, color: AppColors.muted, size: 13),
                  SizedBox(width: ResponsiveHelper.w(4)),
                  Text(
                    'Resets in $resetCountdown',
                    style: GoogleFonts.inter(
                      color: AppColors.muted,
                      fontSize: ResponsiveHelper.sp(11),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: ResponsiveHelper.h(14)),

        // Horizontal Carousel
        SizedBox(
          height: 160,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: missions.length,
            itemBuilder: (context, index) {
              final m = missions[index];
              final isCompleted = m.isCompleted;
              final progressFraction = (m.currentProgress / m.totalTarget).clamp(0.0, 1.0);

              return Container(
                width: ResponsiveHelper.w(260),
                margin: EdgeInsets.only(right: ResponsiveHelper.w(14)),
                padding: EdgeInsets.all(ResponsiveHelper.w(16)),
                decoration: BoxDecoration(
                  color: const Color(0xFF141414),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isCompleted ? AppColors.accent.withValues(alpha: 0.6) : Colors.white.withValues(alpha: 0.05),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top Row: Reward Tag + Icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveHelper.w(10),
                            vertical: ResponsiveHelper.h(4),
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1B2B20),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.stars, color: AppColors.accent, size: 12),
                              SizedBox(width: ResponsiveHelper.w(4)),
                              Text(
                                '+${m.zCoinsReward} Z Coins',
                                style: GoogleFonts.inter(
                                  color: AppColors.accent,
                                  fontSize: ResponsiveHelper.sp(11),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(m.icon, color: Colors.white70, size: 20),
                      ],
                    ),

                    // Title
                    Text(
                      m.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.sp(16),
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // Progress Section
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Progress',
                              style: GoogleFonts.inter(
                                color: AppColors.muted,
                                fontSize: ResponsiveHelper.sp(11),
                              ),
                            ),
                            Text(
                              '${m.currentProgress}/${m.totalTarget}',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: ResponsiveHelper.sp(12),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: ResponsiveHelper.h(6)),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progressFraction,
                            backgroundColor: const Color(0xFF242424),
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
