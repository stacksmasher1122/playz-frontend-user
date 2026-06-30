class MatchStatisticsModel {
  final int totalPoints;
  final int longestRally;
  final double servicePointsWon; // e.g. 0.68 for 68%
  final int winnerCount;
  final int smashCount;
  final int netWinnerCount;
  final int unforcedErrors;
  final double dominancePercentage;
  final String matchDuration;

  const MatchStatisticsModel({
    required this.totalPoints,
    required this.longestRally,
    required this.servicePointsWon,
    required this.winnerCount,
    required this.smashCount,
    required this.netWinnerCount,
    required this.unforcedErrors,
    required this.dominancePercentage,
    required this.matchDuration,
  });
}
