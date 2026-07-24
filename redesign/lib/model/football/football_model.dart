import '../../score_engine/footballMatchEngine/football_match_engine.dart';

class FootballMatchModel {
  String id;
  String createdBy;
  String sport;
  List<String> allPlayers;
  List<String> homeTeamPlayers;
  List<String> awayTeamPlayers;
  Map<String, dynamic> config;
  bool isFriendlyRules;
  String status;
  FootballMatchState engineState;
  String matchResult;
  DateTime lastUpdatedAt;
  DateTime createdAt;
  String? tournamentId;
  String? bracketMatchId;

  FootballMatchModel({
    required this.id,
    required this.createdBy,
    this.sport = 'football',
    required this.allPlayers,
    required this.homeTeamPlayers,
    required this.awayTeamPlayers,
    required this.config,
    this.isFriendlyRules = false,
    required this.status,
    required this.engineState,
    this.matchResult = '',
    required this.lastUpdatedAt,
    required this.createdAt,
    this.tournamentId,
    this.bracketMatchId,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdBy': createdBy,
        'sport': sport,
        'allPlayers': allPlayers,
        'homeTeamPlayers': homeTeamPlayers,
        'awayTeamPlayers': awayTeamPlayers,
        'config': config,
        'isFriendlyRules': isFriendlyRules,
        'status': status,
        'engineState': engineState.toJson(),
        'matchResult': matchResult,
        'lastUpdatedAt': lastUpdatedAt.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
        'tournamentId': tournamentId,
        'bracketMatchId': bracketMatchId,
      };
}
