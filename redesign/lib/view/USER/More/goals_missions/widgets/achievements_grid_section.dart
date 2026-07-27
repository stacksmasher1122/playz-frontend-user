import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/More_Models/goals_missions_model.dart';

class AchievementsGridSection extends StatelessWidget {
  final List<AchievementModel> achievements;
  final Function(AchievementModel) onAchievementTap;

  const AchievementsGridSection({
    super.key,
    required this.achievements,
    required this.onAchievementTap,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            'Achievements',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: ResponsiveHelper.sp(18),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(14)),

          // 2-Column Grid
          GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: achievements.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: ResponsiveHelper.h(14),
              crossAxisSpacing: ResponsiveHelper.w(14),
              childAspectRatio: 1.15,
            ),
            itemBuilder: (context, index) {
              final a = achievements[index];
              final isUnlocked = a.isUnlocked;

              return InkWell(
                onTap: () => onAchievementTap(a),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: EdgeInsets.all(ResponsiveHelper.w(14)),
                  decoration: BoxDecoration(
                    color: const Color(0xFF141414),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isUnlocked ? AppColors.accent : Colors.white.withValues(alpha: 0.05),
                      width: isUnlocked ? 1.5 : 1.0,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        a.icon,
                        color: isUnlocked ? AppColors.accent : Colors.white38,
                        size: 32,
                      ),
                      SizedBox(height: ResponsiveHelper.h(10)),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          a.title,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: ResponsiveHelper.sp(14),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        isUnlocked ? 'Unlocked' : 'Locked',
                        style: GoogleFonts.inter(
                          color: isUnlocked ? AppColors.accent : AppColors.muted,
                          fontSize: ResponsiveHelper.sp(11),
                          fontWeight: isUnlocked ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
