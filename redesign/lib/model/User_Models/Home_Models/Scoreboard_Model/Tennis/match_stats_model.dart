class MatchStatsModel {
  // Player 1
  final String player1Name;
  final String player1Country;
  final String player1Rank;
  final int player1SetsWon;
  final String player1Image;
  
  // Player 2
  final String player2Name;
  final String player2Country;
  final String player2Rank;
  final int player2SetsWon;
  
  // Stats
  final int p1Aces;
  final int p2Aces;
  final int p1DoubleFaults;
  final int p2DoubleFaults;
  final int p1Winners;
  final int p2Winners;
  final int p1UnforcedErrors;
  final int p2UnforcedErrors;
  final int p1FirstServePercent;
  final int p2FirstServePercent;
  
  // Sets breakdown
  final List<SetBreakdownModel> setBreakdowns;
  
  // MVP
  final bool isPlayer1Mvp;
  final String mvpInsight;

  const MatchStatsModel({
    required this.player1Name,
    required this.player1Country,
    required this.player1Rank,
    required this.player1SetsWon,
    required this.player1Image,
    required this.player2Name,
    required this.player2Country,
    required this.player2Rank,
    required this.player2SetsWon,
    required this.p1Aces,
    required this.p2Aces,
    required this.p1DoubleFaults,
    required this.p2DoubleFaults,
    required this.p1Winners,
    required this.p2Winners,
    required this.p1UnforcedErrors,
    required this.p2UnforcedErrors,
    required this.p1FirstServePercent,
    required this.p2FirstServePercent,
    required this.setBreakdowns,
    required this.isPlayer1Mvp,
    required this.mvpInsight,
  });
}

class SetBreakdownModel {
  final int setNumber;
  final int p1Score;
  final int p2Score;
  final String duration;
  final String keyInsight;
  final bool isMatchPoint;
  final bool isP1Winner;

  const SetBreakdownModel({
    required this.setNumber,
    required this.p1Score,
    required this.p2Score,
    required this.duration,
    required this.keyInsight,
    this.isMatchPoint = false,
    required this.isP1Winner,
  });
}
