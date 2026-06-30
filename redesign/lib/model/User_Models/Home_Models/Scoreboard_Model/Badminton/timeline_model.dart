class TimelineModel {
  final int gameNumber;
  final int playerOneScore;
  final int playerTwoScore;
  final String duration;
  final List<double> momentumBars; // Normalized values 0.0 to 1.0 for heights
  final String description;
  final String winner; // 'AXELSEN' or 'GINTING'

  const TimelineModel({
    required this.gameNumber,
    required this.playerOneScore,
    required this.playerTwoScore,
    required this.duration,
    required this.momentumBars,
    required this.description,
    required this.winner,
  });
}
