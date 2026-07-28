import 'package:flutter/material.dart';

class DailyMissionModel {
  final String id;
  final String title;
  final int currentProgress;
  final int totalTarget;
  final int zCoinsReward;
  final IconData icon;
  final bool isClaimed;

  const DailyMissionModel({
    required this.id,
    required this.title,
    required this.currentProgress,
    required this.totalTarget,
    required this.zCoinsReward,
    required this.icon,
    this.isClaimed = false,
  });

  bool get isCompleted => currentProgress >= totalTarget;
}

class WeeklyChallengeModel {
  final String id;
  final String title;
  final int currentProgress;
  final int totalTarget;
  final int zCoinsReward;
  final IconData icon;
  final bool isClaimed;

  const WeeklyChallengeModel({
    required this.id,
    required this.title,
    required this.currentProgress,
    required this.totalTarget,
    required this.zCoinsReward,
    required this.icon,
    this.isClaimed = false,
  });

  bool get isCompleted => currentProgress >= totalTarget;
}

class AchievementModel {
  final String id;
  final String title;
  final String description;
  final bool isUnlocked;
  final IconData icon;

  const AchievementModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isUnlocked,
    required this.icon,
  });
}

class UserMissionProfileModel {
  final int zCoinsBalance;
  final int playerLevel;
  final String levelTitle;
  final int currentXp;
  final int maxXp;
  final String dailyResetCountdown;
  final List<DailyMissionModel> dailyMissions;
  final List<WeeklyChallengeModel> weeklyChallenges;
  final List<AchievementModel> achievements;

  const UserMissionProfileModel({
    required this.zCoinsBalance,
    required this.playerLevel,
    required this.levelTitle,
    required this.currentXp,
    required this.maxXp,
    required this.dailyResetCountdown,
    required this.dailyMissions,
    required this.weeklyChallenges,
    required this.achievements,
  });

  static UserMissionProfileModel getSampleData() {
    return const UserMissionProfileModel(
      zCoinsBalance: 340,
      playerLevel: 12,
      levelTitle: 'Pro Athlete',
      currentXp: 840,
      maxXp: 1000,
      dailyResetCountdown: '08h 24m',
      dailyMissions: [
        DailyMissionModel(
          id: 'dm1',
          title: 'Play 1 match',
          currentProgress: 2,
          totalTarget: 3,
          zCoinsReward: 20,
          icon: Icons.sports_esports_outlined,
        ),
        DailyMissionModel(
          id: 'dm2',
          title: 'Score 2 Goals / 50 Runs',
          currentProgress: 2,
          totalTarget: 2,
          zCoinsReward: 50,
          icon: Icons.sports_score_outlined,
        ),
        DailyMissionModel(
          id: 'dm3',
          title: 'Complete 1 Turf Booking',
          currentProgress: 0,
          totalTarget: 1,
          zCoinsReward: 30,
          icon: Icons.bookmark_added_outlined,
        ),
      ],
      weeklyChallenges: [
        WeeklyChallengeModel(
          id: 'wc1',
          title: 'Win 3 Matches',
          currentProgress: 0,
          totalTarget: 3,
          zCoinsReward: 150,
          icon: Icons.emoji_events_outlined,
        ),
        WeeklyChallengeModel(
          id: 'wc2',
          title: 'Play with a Friend',
          currentProgress: 1,
          totalTarget: 2,
          zCoinsReward: 100,
          icon: Icons.person_add_alt_outlined,
        ),
        WeeklyChallengeModel(
          id: 'wc3',
          title: 'Maintain a 3-Day Streak',
          currentProgress: 3,
          totalTarget: 3,
          zCoinsReward: 200,
          icon: Icons.local_fire_department_outlined,
        ),
      ],
      achievements: [
        AchievementModel(
          id: 'ac1',
          title: 'First Blood',
          description: 'Won your first official turf match',
          isUnlocked: true,
          icon: Icons.workspace_premium_outlined,
        ),
        AchievementModel(
          id: 'ac2',
          title: 'Top 10',
          description: 'Reach Top 10 in city leaderboards',
          isUnlocked: false,
          icon: Icons.military_tech_outlined,
        ),
        AchievementModel(
          id: 'ac3',
          title: 'Sharpshooter',
          description: 'Score 10+ goals in a single season',
          isUnlocked: false,
          icon: Icons.flag_outlined,
        ),
        AchievementModel(
          id: 'ac4',
          title: 'MVP',
          description: 'Earn 5 Player of the Match awards',
          isUnlocked: false,
          icon: Icons.stars_outlined,
        ),
        AchievementModel(
          id: 'ac5',
          title: 'Streak Master',
          description: 'Win 5 matches in a row',
          isUnlocked: true,
          icon: Icons.bolt_outlined,
        ),
        AchievementModel(
          id: 'ac6',
          title: 'Tournament Champ',
          description: 'Win an official PlayZ tournament',
          isUnlocked: false,
          icon: Icons.military_tech_outlined,
        ),
      ],
    );
  }
}
