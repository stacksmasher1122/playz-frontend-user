class MatchResultModel {
  final String winnerName;
  final String winnerImage; // Placeholder asset path
  final String playerOneName;
  final String playerTwoName;
  final String finalScore;
  final String gameOneScore;
  final String gameTwoScore;
  final String gameThreeScore;
  final String matchDuration;
  final String winnerCountry;
  final String tournamentName;
  final String playerOfMatch;
  final bool isTournamentChampion;

  const MatchResultModel({
    required this.winnerName,
    required this.winnerImage,
    required this.playerOneName,
    required this.playerTwoName,
    required this.finalScore,
    required this.gameOneScore,
    required this.gameTwoScore,
    required this.gameThreeScore,
    required this.matchDuration,
    required this.winnerCountry,
    required this.tournamentName,
    required this.playerOfMatch,
    required this.isTournamentChampion,
  });
}
