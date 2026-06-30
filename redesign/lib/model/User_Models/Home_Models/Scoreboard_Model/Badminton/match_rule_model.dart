class MatchRuleModel {
  final int totalGames;
  final int pointsToWin;
  final String sideChangePoint;
  final String intervalDuration;
  final int warmupDuration;
  final bool autoSyncEnabled;

  const MatchRuleModel({
    required this.totalGames,
    required this.pointsToWin,
    required this.sideChangePoint,
    required this.intervalDuration,
    required this.warmupDuration,
    required this.autoSyncEnabled,
  });
}
