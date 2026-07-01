class VolleyballMatchConfigurationModel {
  final String matchName;
  final String tournament;
  final String date;
  final String time;
  final String venue;
  final String court;
  final String referee;
  final String assistantReferee;
  final String lineJudge1;
  final String lineJudge2;
  final String category;
  final String format;
  final int pointsPerSet;
  final int finalSetPoints;
  final int timeouts;
  final int substitutions;
  final bool technicalTimeout;
  final bool liberoEnabled;
  final bool challengeEnabled;
  final bool videoReview;
  final int warmupDuration;
  final bool coinToss;
  final bool winByTwo;

  VolleyballMatchConfigurationModel({
    required this.matchName,
    required this.tournament,
    required this.date,
    required this.time,
    required this.venue,
    required this.court,
    required this.referee,
    required this.assistantReferee,
    required this.lineJudge1,
    required this.lineJudge2,
    required this.category,
    required this.format,
    required this.pointsPerSet,
    required this.finalSetPoints,
    required this.timeouts,
    required this.substitutions,
    required this.technicalTimeout,
    required this.liberoEnabled,
    required this.challengeEnabled,
    required this.videoReview,
    required this.warmupDuration,
    required this.coinToss,
    required this.winByTwo,
  });
}
