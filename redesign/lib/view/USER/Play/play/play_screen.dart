import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/user_profile_controller.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';

import 'widgets/play_top_bar.dart';
import 'widgets/sport_filters.dart';
import 'widgets/date_selector.dart';
import 'widgets/play_action_row.dart';
import 'widgets/game_list.dart';
import 'widgets/end_of_results.dart';
import 'package:redesign/theme/responsive_helper.dart';
import '../tournaments/tournaments_list_screen.dart';
import 'widgets/game_diary_section.dart';

class GameDiaryScreen extends StatefulWidget {
  const GameDiaryScreen({super.key});

  @override
  State<GameDiaryScreen> createState() => _GameDiaryScreenState();
}

class _GameDiaryScreenState extends State<GameDiaryScreen> with SingleTickerProviderStateMixin {
  final _controller = Get.find<UserProfileController>();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final docId = await UserPreferences.getDocId();
    if (docId != null) {
      _controller.fetchUserProfile(docId);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: true,
        bottom: false,
        child: Column(
          children: [
            PlayTopBar(),
            TabBar(
              controller: _tabController,
              indicatorColor: AppColors.accent,
              labelColor: AppColors.accent,
              unselectedLabelColor: AppColors.muted,
              labelStyle: AppTypography.headlineSm.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: context.responsiveFont(14),
              ),
              tabs: const [
                Tab(text: "All Games"),
                Tab(text: "Tournaments"),
                Tab(text: "Game Diary"),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // All Games
                  ListView(
                    padding: EdgeInsets.only(bottom: context.heightPct(10)),
                    children: [
                      SizedBox(height: context.heightPct(1.5)),
                      const SportFilters(),
                      SizedBox(height: context.heightPct(2.5)),
                      const DateSelector(),
                      SizedBox(height: context.heightPct(1.2)),
                      PlayActionRow(),
                      SizedBox(height: context.heightPct(1.5)),
                      const GameList(),
                      EndOfResults(),
                    ],
                  ),
                  // Tournaments
                  TournamentsListScreen(),
                  // Game Diary
                  const GameDiaryWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
