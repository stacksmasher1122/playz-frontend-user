class LiveMatchModel {
  final String matchId;
  final String playerOneName;
  final String playerTwoName;
  final String playerOneAvatar;
  final String playerTwoAvatar;
  final int playerOneScore;
  final int playerTwoScore;
  final int currentGame;
  final int totalGames;
  final String matchTime;
  final String serviceSide; // 'left' or 'right'
  final String serverPlayer;
  final String momentum;
  final bool isPaused;
  final String matchStatus;

  const LiveMatchModel({
    required this.matchId,
    required this.playerOneName,
    required this.playerTwoName,
    required this.playerOneAvatar,
    required this.playerTwoAvatar,
    required this.playerOneScore,
    required this.playerTwoScore,
    required this.currentGame,
    required this.totalGames,
    required this.matchTime,
    required this.serviceSide,
    required this.serverPlayer,
    required this.momentum,
    required this.isPaused,
    required this.matchStatus,
  });
}
