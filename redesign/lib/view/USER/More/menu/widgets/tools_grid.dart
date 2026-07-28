import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/view/USER/Home/Bookings/bookings/bookings_screen.dart';
import 'package:redesign/view/USER/Home/Groups/groups/groups_screen.dart';
import 'package:redesign/view/USER/More/my_stats/my_stats/my_stats_screen.dart';
import 'package:redesign/view/USER/More/leaderboard/leaderboard_screen.dart';
import 'package:redesign/view/USER/More/goals_missions/goals_missions_screen.dart';
import 'package:redesign/view/USER/Home/home/widgets/notification_screen.dart';
import 'package:redesign/view/USER/More/join_premium/join_premium_screen.dart';

class ToolsGrid extends StatelessWidget {
  const ToolsGrid({super.key});

  void _onToolTap(BuildContext context, String toolName) {
    switch (toolName) {
      case 'My Bookings':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MyBookingsScreen()),
        );
        break;
      case 'My Groups':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => GroupsScreen()),
        );
        break;
      case 'My Stats':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MyStatsScreen()),
        );
        break;
      case 'Leaderboards':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LeaderboardScreen()),
        );
        break;
      case 'Goals & Missions':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const GoalsMissionsScreen()),
        );
        break;
      case 'Notifications':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NotificationsScreen()),
        );
        break;
      case 'Join Premium':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const JoinPremiumScreen()),
        );
        break;
      default:
        Get.snackbar(
          toolName,
          '$toolName section accessed.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.surface,
          colorText: Colors.white,
        );
        break;
    }
  }



  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final tools = [
      ('My Bookings', Icons.event),
      ('My Stats', Icons.bar_chart_rounded),
      ('My Groups', Icons.groups),
      ('Join Premium', Icons.workspace_premium),
      ('Leaderboards', Icons.leaderboard),
      ('Goals & Missions', Icons.track_changes),
      ('Notifications', Icons.notifications),
      ('AI Coach', Icons.psychology),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: tools.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.9,
        ),
        itemBuilder: (_, i) {
          final toolName = tools[i].$1;
          final icon = tools[i].$2;
          final highlight = toolName == 'AI Coach';
          final isPremium = toolName == 'Join Premium';

          return Container(
            decoration: BoxDecoration(
              color: highlight
                  ? AppColors.accent
                  : isPremium
                      ? Colors.amber.withValues(alpha: 0.15)
                      : AppColors.surface,
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
              border: isPremium ? Border.all(color: Colors.amber.withValues(alpha: 0.6)) : null,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _onToolTap(context, toolName),
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
                child: Padding(
                  padding: EdgeInsets.all(ResponsiveHelper.w(8)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        color: highlight
                            ? Colors.black
                            : isPremium
                                ? Colors.amber
                                : Colors.white,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        toolName,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: highlight
                              ? Colors.black
                              : isPremium
                                  ? Colors.amber
                                  : Colors.white,
                          fontSize: ResponsiveHelper.sp(11),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


