class LivePickleballMatchModel {
  final String matchId;
  final String teamA;
  final String teamB;
  final int scoreA;
  final int scoreB;
  final int setsA;
  final int setsB;
  final String server;
  final String game;
  final String set;
  final String court;
  final String status;
  final String duration;
  final Map<String, dynamic> statistics;

  LivePickleballMatchModel({
    required this.matchId,
    required this.teamA,
    required this.teamB,
    required this.scoreA,
    required this.scoreB,
    required this.setsA,
    required this.setsB,
    required this.server,
    required this.game,
    required this.set,
    required this.court,
    required this.status,
    required this.duration,
    required this.statistics,
  });
}
