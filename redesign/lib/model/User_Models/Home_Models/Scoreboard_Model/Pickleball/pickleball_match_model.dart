class PickleballMatchModel {
  final String matchName;
  final String? tournament;
  final String courtNumber;
  final DateTime dateTime;
  final String? referee;
  final String category;
  final String format;
  final String matchType;
  final String courtSurface;
  final String skillLevel;
  final String servingRule;
  final int timeouts;
  final int maximumScore;
  final bool goldenPoint;
  final bool medicalTimeout;
  final bool winByTwo;
  final bool rallyScoring;
  final bool traditionalScoring;

  PickleballMatchModel({
    required this.matchName,
    this.tournament,
    required this.courtNumber,
    required this.dateTime,
    this.referee,
    required this.category,
    required this.format,
    required this.matchType,
    required this.courtSurface,
    required this.skillLevel,
    required this.servingRule,
    required this.timeouts,
    required this.maximumScore,
    required this.goldenPoint,
    required this.medicalTimeout,
    required this.winByTwo,
    required this.rallyScoring,
    required this.traditionalScoring,
  });
}
