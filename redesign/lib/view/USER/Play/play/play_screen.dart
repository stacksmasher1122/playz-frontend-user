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

class GameDiaryScreen extends StatefulWidget {
  GameDiaryScreen({super.key});

  @override
  State<GameDiaryScreen> createState() => _GameDiaryScreenState();
}

class _GameDiaryScreenState extends State<GameDiaryScreen> with SingleTickerProviderStateMixin {
  final _controller = Get.find<UserProfileController>();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
              labelStyle: AppTypography.headlineSm.copyWith(fontWeight: FontWeight.bold),
              tabs: const [
                Tab(text: "All Games"),
                Tab(text: "Tournaments"),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // All Games
                  ListView(
                    children: [
                      SizedBox(height: 12),
                      SportFilters(),
                      SizedBox(height: 22),
                      DateSelector(),
                      SizedBox(height: 10),
                      PlayActionRow(),
                      SizedBox(height: 12),
                      GameList(),
                      EndOfResults(),
                    ],
                  ),
                  // Tournaments
                  TournamentsListScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
