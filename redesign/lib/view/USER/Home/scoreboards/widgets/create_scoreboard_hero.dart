import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/view/USER/Home/Scoreboard/select_sports/select_sports_screen.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kSurface = Color(0xFF0E0E0E);
const kGreen = AppColors.accent;

class CreateScoreboardHero extends StatelessWidget {
  CreateScoreboardHero({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 18),
      child: Container(
        padding: EdgeInsets.all(ResponsiveHelper.w(24)),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(24)),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              bottom: -20,
              child: Icon(
                Icons.analytics_outlined,
                size: 140,
                color: Colors.white.withValues(alpha: 0.15),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create a Scoreboard',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.sp(22),
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Track scores for friendly matches, practice games, or local tournaments.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: ResponsiveHelper.sp(14),
                    height: ResponsiveHelper.h(1.4),
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kGreen,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => SelectSportScreen()),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Create Now',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.sp(15),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(Icons.arrow_forward, size: 18),
                    ],
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
