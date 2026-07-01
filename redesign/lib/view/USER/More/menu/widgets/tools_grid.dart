import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ToolsGrid extends StatelessWidget {
  ToolsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final tools = [
      ('My Bookings', Icons.event),
      ('My Games & Teams', Icons.emoji_events),
      ('My Groups', Icons.groups),
      ('Invites & Requests', Icons.mail),
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
        physics: NeverScrollableScrollPhysics(),
        itemCount: tools.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.9,
        ),
        itemBuilder: (_, i) {
          final highlight = tools[i].$1 == 'AI Coach';
          return Container(
            decoration: BoxDecoration(
              color: highlight ? AppColors.accent : AppColors.surface,
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
            ),
            padding: EdgeInsets.all(ResponsiveHelper.w(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  tools[i].$2,
                  color: highlight ? Colors.black : Colors.white,
                ),
                SizedBox(height: 6),
                Text(
                  tools[i].$1,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: highlight ? Colors.black : Colors.white,
                    fontSize: ResponsiveHelper.sp(11),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
