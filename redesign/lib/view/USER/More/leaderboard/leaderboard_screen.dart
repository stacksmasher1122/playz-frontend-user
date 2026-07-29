import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/User_Controller/Ranking_Controller/ranking_controller.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

import 'widgets/leaderboard_app_bar.dart';
import 'widgets/leaderboard_podium.dart';
import 'widgets/leaderboard_scope_toggle.dart';
import 'widgets/leaderboard_sport_filter.dart';
import 'widgets/leaderboard_tile.dart';
import 'widgets/leaderboard_user_sticky_tile.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final controller = Get.isRegistered<RankingController>()
        ? Get.find<RankingController>()
        : Get.put(RankingController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const LeaderboardAppBar(),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            );
          }

          final allFiltered = controller.filteredPlayers;
          final top3 = allFiltered.take(3).toList();
          final remainingPlayers = allFiltered.length > 3 ? allFiltered.sublist(3) : [];
          final currentUser = controller.currentUserModel;

          final selectedScopeName = controller.scopes[controller.selectedScopeIndex.value];
          final selectedSportName = controller.sports[controller.selectedSportIndex.value];

          return Stack(
            children: [
              // Scrollable Leaderboard Content
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(child: SizedBox(height: context.heightPct(1.2))),

                  // Scope Toggle (Global, Friends, Groups)
                  SliverToBoxAdapter(
                    child: LeaderboardScopeToggle(
                      selectedScope: selectedScopeName,
                      onScopeChanged: (scope) {
                        final idx = controller.scopes.indexOf(scope);
                        if (idx != -1) controller.setScope(idx);
                      },
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: context.heightPct(2))),

                  // Sport Filter Pills
                  SliverToBoxAdapter(
                    child: LeaderboardSportFilter(
                      selectedSport: selectedSportName,
                      onSportChanged: (sport) {
                        final idx = controller.sports.indexOf(sport);
                        if (idx != -1) controller.setSport(idx);
                      },
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: context.heightPct(3))),

                  // Podium Top 3 Section
                  if (top3.isNotEmpty)
                    SliverToBoxAdapter(
                      child: LeaderboardPodium(top3: top3),
                    ),

                  SliverToBoxAdapter(child: SizedBox(height: context.heightPct(2.5))),

                  // Remaining Player List (Rank 4+)
                  if (remainingPlayers.isNotEmpty)
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

                  // Bottom padding for sticky user tile
                  SliverToBoxAdapter(child: SizedBox(height: context.heightPct(11))),
                ],
              ),

              // Bottom Sticky "You" Tile
              Positioned(
                left: context.widthPct(4),
                right: context.widthPct(4),
                bottom: context.heightPct(1.5),
                child: LeaderboardUserStickyTile(userPlayer: currentUser),
              ),
            ],
          );
        }),
      ),
    );
  }
}
