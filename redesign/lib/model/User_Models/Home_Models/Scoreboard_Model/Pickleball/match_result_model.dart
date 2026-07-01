class GameResult {
  final String game;
  final int scoreA;
  final int scoreB;
  final String winner;

  GameResult({
    required this.game,
    required this.scoreA,
    required this.scoreB,
    required this.winner,
  });
}

class PlayerPerformance {
  final String name;
  final String image;
  final int pointsWon;
  final int aces;
  final int servePercent;
  final int errors;
  final int winners;
  final int reactionTime;

  PlayerPerformance({
    required this.name,
    required this.image,
    required this.pointsWon,
    required this.aces,
    required this.servePercent,
    required this.errors,
    required this.winners,
    required this.reactionTime,
  });
}

class MatchResultModel {
  final String matchId;
  final String winner;
  final String runnerUp;
  final List<GameResult> games;
  final String duration;
  final String mvpName;
  final String mvpImage;
  final String mvpTeamName;
  final String mvpWinRate;
  final Map<String, dynamic> statistics;
  final Map<String, dynamic> analytics;
  final List<PlayerPerformance> players;
  final List<String> achievements;
  final String tournament;
  final String court;
  final String referee;
  final String matchDate;
  final String matchTime;
  final String courtType;

  MatchResultModel({
    required this.matchId,
    required this.winner,
    required this.runnerUp,
    required this.games,
    required this.duration,
    required this.mvpName,
    required this.mvpImage,
    required this.mvpTeamName,
    required this.mvpWinRate,
    required this.statistics,
    required this.analytics,
    required this.players,
    required this.achievements,
    required this.tournament,
    required this.court,
    required this.referee,
    required this.matchDate,
    required this.matchTime,
    required this.courtType,
  });
}
