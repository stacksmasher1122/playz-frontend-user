import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/More_Models/goals_missions_model.dart';
import 'package:redesign/controller/user_profile_controller.dart';

import 'widgets/goals_missions_app_bar.dart';
import 'widgets/goals_missions_level_card.dart';
import 'widgets/daily_missions_section.dart';
import 'widgets/weekly_challenges_section.dart';
import 'widgets/achievements_grid_section.dart';

class GoalsMissionsScreen extends StatefulWidget {
  const GoalsMissionsScreen({super.key});

  @override
  State<GoalsMissionsScreen> createState() => _GoalsMissionsScreenState();
}

class _GoalsMissionsScreenState extends State<GoalsMissionsScreen> {
  late UserMissionProfileModel _profile;

  @override
  void initState() {
    super.initState();
    _profile = UserMissionProfileModel.getSampleData();
  }

  void _onClaimMission(DailyMissionModel mission) async {
    final controller = Get.isRegistered<UserProfileController>()
        ? Get.find<UserProfileController>()
        : Get.put(UserProfileController());

    await controller.addZCoins(mission.zCoinsReward);
    await controller.addXp(50);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.surface,
          content: Text(
            'Claimed +${mission.zCoinsReward} Z-Coins & +50 XP for "${mission.title}"!',
            style: AppTypography.bodySm.copyWith(
              color: AppColors.accent,
              fontWeight: FontWeight.bold,
              fontSize: context.responsiveFont(13),
            ),
          ),
        ),
      );
    }
  }

  void _onAchievementTap(AchievementModel achievement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
        ),
        title: Row(
          children: [
            Icon(achievement.icon, color: achievement.isUnlocked ? AppColors.accent : AppColors.muted, size: 24),
            SizedBox(width: context.widthPct(2.5)),
            Expanded(
              child: Text(
                achievement.title,
                style: AppTypography.headlineSm.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: context.responsiveFont(16),
                ),
              ),
            ),
          ],
        ),
        content: Text(
          achievement.description,
          style: AppTypography.bodySm.copyWith(
            color: AppColors.muted,
            fontSize: context.responsiveFont(13),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: AppTypography.headlineSm.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
                fontSize: context.responsiveFont(14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GoalsMissionsAppBar(zCoinsBalance: _profile.zCoinsBalance),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            SizedBox(height: context.heightPct(1.5)),

            // Player Level & XP Card
            GoalsMissionsLevelCard(
              level: _profile.playerLevel,
              levelTitle: _profile.levelTitle,
              currentXp: _profile.currentXp,
              maxXp: _profile.maxXp,
            ),

            SizedBox(height: context.heightPct(2.5)),

            // Daily Missions Section (Carousel)
            DailyMissionsSection(
              missions: _profile.dailyMissions,
              resetCountdown: _profile.dailyResetCountdown,
              onClaim: _onClaimMission,
            ),

            SizedBox(height: context.heightPct(3)),

            // Weekly Challenges Section
            WeeklyChallengesSection(
              challenges: _profile.weeklyChallenges,
            ),

            SizedBox(height: context.heightPct(3)),

            // Achievements 2-Column Grid
            AchievementsGridSection(
              achievements: _profile.achievements,
              onAchievementTap: _onAchievementTap,
            ),

            SizedBox(height: context.heightPct(5)),
          ],
        ),
      ),
    );
  }
}
