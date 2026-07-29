import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/More_Models/leaderboard_model.dart';

import 'widgets/leaderboard_app_bar.dart';
import 'widgets/leaderboard_scope_toggle.dart';
import 'widgets/leaderboard_sport_filter.dart';
import 'widgets/leaderboard_podium.dart';
import 'widgets/leaderboard_tile.dart';
import 'widgets/leaderboard_user_sticky_tile.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  String _selectedScope = 'Friends';
  String _selectedSport = 'Football';
  late List<LeaderboardPlayerModel> _players;

  @override
  void initState() {
    super.initState();
    _players = LeaderboardPlayerModel.getSampleLeaderboard();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final top3 = _players.where((p) => p.rank <= 3).toList();
    final remainingPlayers = _players.where((p) => p.rank > 3 && !p.isCurrentUser).toList();
    final currentUser = _players.firstWhere((p) => p.isCurrentUser);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const LeaderboardAppBar(),
      body: SafeArea(
        child: Stack(
          children: [
            // Scrollable Leaderboard Content
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: SizedBox(height: context.heightPct(1.2))),

                // Scope Toggle (Friends, City, Global)
                SliverToBoxAdapter(
                  child: LeaderboardScopeToggle(
                    selectedScope: _selectedScope,
                    onScopeChanged: (scope) => setState(() => _selectedScope = scope),
                  ),
                ),

                SliverToBoxAdapter(child: SizedBox(height: context.heightPct(2))),

                // Sport Filter Pills (All, Cricket, Football, Tennis, Badminton)
                SliverToBoxAdapter(
                  child: LeaderboardSportFilter(
                    selectedSport: _selectedSport,
                    onSportChanged: (sport) => setState(() => _selectedSport = sport),
                  ),
                ),

                SliverToBoxAdapter(child: SizedBox(height: context.heightPct(3))),

                // Podium Top 3 Section (Rank 1, 2, 3)
                SliverToBoxAdapter(
                  child: LeaderboardPodium(top3: top3),
                ),

                SliverToBoxAdapter(child: SizedBox(height: context.heightPct(2.5))),

                // Ranking List Items (Rank 4, 5, 6, 7...)
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return LeaderboardTile(player: remainingPlayers[index]);
                      },
                      childCount: remainingPlayers.length,
                    ),
                  ),
                ),

                // Space for bottom sticky user tile
                SliverToBoxAdapter(child: SizedBox(height: context.heightPct(11))),
              ],
            ),

            // Bottom Sticky "You" Tile (Rank 47)
            Positioned(
              left: context.widthPct(4),
              right: context.widthPct(4),
              bottom: context.heightPct(1.5),
              child: LeaderboardUserStickyTile(userPlayer: currentUser),
            ),
          ],
        ),
      ),
    );
  }
}
