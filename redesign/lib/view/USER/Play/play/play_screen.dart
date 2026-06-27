import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/controller/user_profile_controller.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';

import 'widgets/play_top_bar.dart';
import 'widgets/play_tabs.dart';
import 'widgets/sport_filters.dart';
import 'widgets/date_selector.dart';
import 'widgets/play_action_row.dart';
import 'widgets/game_list.dart';
import 'widgets/end_of_results.dart';

class GameDiaryScreen extends StatefulWidget {
  const GameDiaryScreen({super.key});

  @override
  State<GameDiaryScreen> createState() => _GameDiaryScreenState();
}

class _GameDiaryScreenState extends State<GameDiaryScreen> {
  final _controller = Get.find<UserProfileController>();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final docId = await UserPreferences.getDocId();
    if (docId != null) {
      _controller.fetchUserProfile(docId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: true,
        bottom: false,
        child: ListView(
          children: const [
            PlayTopBar(),
            PlayTabs(),
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
      ),
    );
  }
}
