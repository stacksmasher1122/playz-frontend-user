class PickleballStatisticsModel {
  final String matchId;
  final String winner;
  final String loser;
  final List<Map<String, dynamic>> games;
  final Map<String, dynamic> statistics;
  final List<double> momentum;
  final Map<String, dynamic> errors;
  final List<Map<String, dynamic>> timeline;
  final List<List<double>> heatMapData;
  final List<String> coachInsights;

  PickleballStatisticsModel({
    required this.matchId,
    required this.winner,
    required this.loser,
    required this.games,
    required this.statistics,
    required this.momentum,
    required this.errors,
    required this.timeline,
    required this.heatMapData,
    required this.coachInsights,
  });
}
