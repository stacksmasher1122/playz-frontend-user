import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/view/USER/Home/Bookings/bookings/bookings_screen.dart';
import 'package:redesign/view/USER/Home/Friends/friends/friends_screen.dart';
import 'package:redesign/view/USER/Home/Groups/groups/groups_screen.dart';
import 'package:redesign/view/USER/Home/Ranking/rankings/rankings_screen.dart';
import 'package:redesign/view/USER/Home/scoreboard_screen/scoreboards_screen.dart';

/* ============================================================
   QUICK ACCESS TILES
   ============================================================ */
class HomeQuickAccessTiles extends StatelessWidget {
  const HomeQuickAccessTiles({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.widthPct(5)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWideScreen = constraints.maxWidth > 500;
          final crossAxisCount = isWideScreen ? 3 : 2;

          return GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: context.widthPct(3),
              mainAxisSpacing: context.widthPct(3),
              childAspectRatio: isWideScreen ? 2.4 : 2.15,
            ),
            itemCount: _tiles.length,
            itemBuilder: (_, i) => _tiles[i],
          );
        },
      ),
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
  ),
];

class HomeQuickTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? badge;
  final bool highlight;
  final Widget? destination;

  const HomeQuickTile(
    this.icon,
    this.title,
    this.subtitle, {
    super.key,
    this.badge,
    this.highlight = false,
    this.destination,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final iconContainerSize = context.minDimensionPct(11).clamp(38.0, 48.0);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
        onTap: destination == null
            ? null
            : () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => destination!),
                );
              },
        child: Container(
          padding: EdgeInsets.all(context.widthPct(3)),
          decoration: BoxDecoration(
            gradient: AppColors.quickActionGreyGreen,
            borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
            border: Border.all(
              color: highlight
                  ? AppColors.accent.withValues(alpha: 0.5)
                  : Colors.white.withValues(alpha: 0.08),
              width: 1,
            ),
          ),
          child: Stack(
            children: [
              // Badge (BETA/NEW/Active)
              if (badge != null)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.widthPct(1.5),
                      vertical: context.heightPct(0.3),
                    ),
                    decoration: BoxDecoration(
                      color: badge == 'Beta' || badge == 'New'
                          ? AppColors.accent
                          : Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      badge!.toUpperCase(),
                      style: AppTypography.labelCaps10.copyWith(
                        fontSize: context.responsiveFont(8),
                        color: badge == 'Beta' || badge == 'New'
                            ? AppColors.background
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),

              Row(
                children: [
                  // Icon Container
                  Container(
                    height: iconContainerSize,
                    width: iconContainerSize,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(
                        context.minDimensionPct(2.5),
                      ),
                    ),
                    child: Icon(
                      icon,
                      size: iconContainerSize * 0.5,
                      color: highlight ? AppColors.accent : AppColors.textPrimary.withValues(alpha: 0.85),
                    ),
                  ),
                  SizedBox(width: context.widthPct(2.5)),
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
                          style: AppTypography.headlineSm.copyWith(
                            fontSize: context.responsiveFont(13),
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: context.heightPct(0.3)),
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.bodySm.copyWith(
                            fontSize: context.responsiveFont(10),
                            color: AppColors.textSecondary,
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
