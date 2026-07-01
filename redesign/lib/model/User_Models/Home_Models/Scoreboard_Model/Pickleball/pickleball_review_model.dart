class PickleballReviewModel {
  final String teamAName;
  final String teamBName;
  final String teamAImage;
  final String teamBImage;
  final String courtName;
  final String matchTime;
  final String gamesFormat;
  final int targetPoints;
  final bool winByTwo;
  final String scoringMode;
  final String timeLimit;
  final String switchSides;
  final bool recordReplays;

  PickleballReviewModel({
    required this.teamAName,
    required this.teamBName,
    required this.teamAImage,
    required this.teamBImage,
    required this.courtName,
    required this.matchTime,
    required this.gamesFormat,
    required this.targetPoints,
    required this.winByTwo,
    required this.scoringMode,
    required this.timeLimit,
    required this.switchSides,
    required this.recordReplays,
  });
}
