import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/view/USER/Home/Bookings/bookings/bookings_screen.dart';
import 'package:redesign/view/USER/Home/Friends/friends/friends_screen.dart';
import 'package:redesign/view/USER/Home/Groups/groups/groups_screen.dart';
import 'package:redesign/view/USER/Home/Ranking/rankings/rankings_screen.dart';
import 'package:redesign/view/USER/Home/scoreboards/scoreboards_screen.dart';
import '../home_screen.dart';
import 'package:redesign/theme/responsive_helper.dart';

/* ============================================================
   QUICK ACCESS TILES
   ============================================================ */
class HomeQuickAccessTiles extends StatelessWidget {
  HomeQuickAccessTiles({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        // 2 columns for a dashboard feel
        const crossAxisCount = 2;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(20)),
          child: GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              // Wide ratio for horizontal layout
              childAspectRatio: 2.1,
            ),
            itemCount: _tiles.length,
            itemBuilder: (_, i) => _tiles[i],
          ),
        );
      },
    );
  }
}

final List<HomeQuickTile> _tiles = [
  HomeQuickTile(
    Icons.groups,
    'Groups',
    'Find your crew',
    destination: GroupsScreen(),
  ),
  HomeQuickTile(
    Icons.calendar_month,
    'Bookings',
    'Reserve slots',
    destination: MyBookingsScreen(),
  ),
  HomeQuickTile(
    Icons.people_outline,
    'Friends',
    'Build squad',
    destination: FriendsHubScreen(),
  ),
  HomeQuickTile(
    Icons.emoji_events,
    'Rankings',
    'Track stats',
    destination: RankingsScreen(),
  ),
  HomeQuickTile(
    Icons.scoreboard_outlined,
    'Scoreboard',
    'Live scores',
    destination: ScoreboardHubScreen(),
  ),
  HomeQuickTile(
    Icons.smart_toy_outlined,
    'AI Trainer',
    'Train smarter',
    highlight: true,
    // destination: AiTrainerScreen(),
  ),
];

class HomeQuickTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? badge;
  final bool highlight;
  final Widget? destination;

  HomeQuickTile(
    this.icon,
    this.title,
    this.subtitle, {super.key, 
    this.badge,
    this.highlight = false,
    this.destination,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        onTap: destination == null
            ? null
            : () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => destination!));
              },
        child: Container(
          padding: EdgeInsets.all(ResponsiveHelper.w(12)),
          decoration: BoxDecoration(
            color: UserHomePage.surface, // #181818
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
            border: Border.all(
              color: highlight
                  ? UserHomePage.accent.withValues(alpha: 0.5)
                  : Colors.white.withValues(alpha: 0.05),
              width: ResponsiveHelper.w(1),
            ),
          ),
          child: Stack(
            children: [
              // Badge (BETA/NEW/Active)
              if (badge != null)
                Positioned(
                  top: ResponsiveHelper.h(0),
                  right: ResponsiveHelper.w(0),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: badge == 'Beta' || badge == 'New'
                          ? UserHomePage.accent
                          : Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(ResponsiveHelper.w(4)),
                    ),
                    child: Text(
                      badge!.toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: ResponsiveHelper.sp(8),
                        fontWeight: FontWeight.w900,
                        color: badge == 'Beta' || badge == 'New'
                            ? Colors.black
                            : Colors.white70,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),

              Row(
                children: [
                  // Icon Container
                  Container(
                    height: ResponsiveHelper.h(44),
                    width: ResponsiveHelper.w(44),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(ResponsiveHelper.w(10)),
                    ),
                    child: Icon(
                      icon,
                      size: 22,
                      color: highlight ? UserHomePage.accent : Colors.white70,
                    ),
                  ),
                  SizedBox(width: 12),
                  // Text Info
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: ResponsiveHelper.sp(14),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            color: UserHomePage.muted,
                            fontSize: ResponsiveHelper.sp(11),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
