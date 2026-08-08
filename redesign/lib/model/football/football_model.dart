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

  factory FootballMatchModel.fromJson(Map<String, dynamic> json) {
    return FootballMatchModel(
      id: json['id']?.toString() ?? '',
      createdBy: json['createdBy']?.toString() ?? 'unknown',
      sport: json['sport']?.toString() ?? 'football',
      allPlayers: List<String>.from(json['allPlayers'] ?? []),
      homeTeamPlayers: List<String>.from(json['homeTeamPlayers'] ?? []),
      awayTeamPlayers: List<String>.from(json['awayTeamPlayers'] ?? []),
      config: Map<String, dynamic>.from(json['config'] ?? {}),
      isFriendlyRules: json['isFriendlyRules'] == true,
      status: json['status']?.toString() ?? 'pending',
      engineState: json['engineState'] != null
          ? FootballMatchState.fromJson(Map<String, dynamic>.from(json['engineState']))
          : FootballMatchState(),
      matchResult: json['matchResult']?.toString() ?? '',
      lastUpdatedAt: json['lastUpdatedAt'] != null
          ? DateTime.tryParse(json['lastUpdatedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      tournamentId: json['tournamentId']?.toString(),
      bracketMatchId: json['bracketMatchId']?.toString(),
    );
  }
}
