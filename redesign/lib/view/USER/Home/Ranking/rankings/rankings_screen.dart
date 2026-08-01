import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/User_Controller/Ranking_Controller/ranking_controller.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

import 'widgets/league_sections.dart';
import 'widgets/rankings_app_bar.dart';
import 'widgets/scope_tabs.dart';
import 'widgets/sport_filter_row.dart';
import 'widgets/user_rank_card.dart';

class RankingsScreen extends StatelessWidget {
  const RankingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.isRegistered<RankingController>()
        ? Get.find<RankingController>()
        : Get.put(RankingController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            );
          }

          final currentUser = controller.currentUserModel;
          final scopeName = controller.scopes[controller.selectedScopeIndex.value];

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              const RankingsAppBar(),
              SliverToBoxAdapter(
                child: UserRankCard(
                  userPlayer: currentUser,
                  scopeName: scopeName,
                ),
              ),
              SliverToBoxAdapter(
                child: ScopeTabs(
                  selected: controller.selectedScopeIndex.value,
                  onChanged: (index) => controller.setScope(index),
                ),
              ),
              SliverToBoxAdapter(
                child: SportFilterRow(
                  selected: controller.selectedSportIndex.value,
                  onChanged: (index) => controller.setSport(index),
                ),
              ),
              SliverToBoxAdapter(
                child: LeagueSections(
                  players: controller.filteredPlayers,
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.only(bottom: context.heightPct(5)),
              ),
            ],
          );
        }),
      ),
    );
  }
}
