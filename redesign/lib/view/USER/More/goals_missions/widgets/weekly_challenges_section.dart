import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/More_Models/goals_missions_model.dart';

class WeeklyChallengesSection extends StatelessWidget {
  final List<WeeklyChallengeModel> challenges;

  const WeeklyChallengesSection({
    super.key,
    required this.challenges,
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
            'Weekly Challenges',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: ResponsiveHelper.sp(18),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(14)),

          ...challenges.map((c) {
            final progressFraction = (c.currentProgress / c.totalTarget).clamp(0.0, 1.0);

            return Container(
              margin: EdgeInsets.only(bottom: ResponsiveHelper.h(12)),
              padding: EdgeInsets.all(ResponsiveHelper.w(16)),
              decoration: BoxDecoration(
                color: const Color(0xFF141414),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: Row(
                children: [
                  // Circular Icon Box
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1E1E1E),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(c.icon, color: AppColors.accent, size: 22),
                  ),
                  SizedBox(width: ResponsiveHelper.w(14)),

                  // Title & Progress Bar
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                c.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: ResponsiveHelper.sp(15),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: ResponsiveHelper.w(8)),
                            Text(
                              '+${c.zCoinsReward} Z',
                              style: GoogleFonts.inter(
                                color: AppColors.accent,
                                fontSize: ResponsiveHelper.sp(13),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: ResponsiveHelper.h(8)),
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: progressFraction,
                                  backgroundColor: const Color(0xFF242424),
                                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
                                  minHeight: 5,
                                ),
                              ),
                            ),
                            SizedBox(width: ResponsiveHelper.w(10)),
                            Text(
                              '${c.currentProgress}/${c.totalTarget}',
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
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
