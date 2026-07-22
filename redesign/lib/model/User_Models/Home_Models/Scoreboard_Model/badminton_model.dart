import 'dart:convert';

List<T> _toList<T>(dynamic val) {
  if (val == null) return [];
  if (val is String) {
    try {
      return List<T>.from(jsonDecode(val));
    } catch (_) {
      return [];
    }
  }
  if (val is List) return List<T>.from(val);
  return [];
}

Map<String, dynamic> _toMap(dynamic val) {
  if (val == null) return {};
  if (val is String) {
    try {
      return Map<String, dynamic>.from(jsonDecode(val));
    } catch (_) {
      return {};
    }
  }
  if (val is Map) return Map<String, dynamic>.from(val);
  return {};
}

class BadmintonMatchModel {
  final String matchId;
  final String createdBy;
  final String sport;
  final List<String> allPlayers;
  final List<String> teamAPlayers;
  final List<String> teamBPlayers;

  // Settings
  final int maxAllowedPlayers;
  final bool isFriendlyRules;
  final int pointsToWin;
  final int maxPointCap;
  final bool winByTwo;
  final int gamesToWin;
  final bool intervalsEnabled;
  final bool endsChangeEnabled;

  final String status;
  final DateTime createdAt;

  // Live state
  final Map<String, dynamic>? engineState;
  final DateTime? lastUpdatedAt;
  final String matchResult;
  final List<Map<String, dynamic>> pointLog;

  // Tournament context
  final String? tournamentId;
  final String? bracketMatchId;

  BadmintonMatchModel({
    required this.matchId,
    required this.createdBy,
    this.sport = 'badminton',
    required this.allPlayers,
    required this.teamAPlayers,
    required this.teamBPlayers,
    this.maxAllowedPlayers = 2,
    this.isFriendlyRules = false,
    this.pointsToWin = 21,
    this.maxPointCap = 30,
    this.winByTwo = true,
    this.gamesToWin = 2,
    this.intervalsEnabled = true,
    this.endsChangeEnabled = true,
    required this.status,
    required this.createdAt,
    this.engineState,
    this.lastUpdatedAt,
    this.matchResult = '',
    this.pointLog = const [],
    this.tournamentId,
    this.bracketMatchId,
  });

  Map<String, dynamic> toJson() {
    return {
      'matchId': matchId,
      'createdBy': createdBy,
      'sport': sport,
      'allPlayers': allPlayers,
      'teamAPlayers': teamAPlayers,
      'teamBPlayers': teamBPlayers,
      'maxAllowedPlayers': maxAllowedPlayers,
      'isFriendlyRules': isFriendlyRules,
      'pointsToWin': pointsToWin,
      'maxPointCap': maxPointCap,
      'winByTwo': winByTwo,
      'gamesToWin': gamesToWin,
      'intervalsEnabled': intervalsEnabled,
      'endsChangeEnabled': endsChangeEnabled,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'engineState': engineState,
      'lastUpdatedAt': lastUpdatedAt?.toIso8601String(),
      'matchResult': matchResult,
      'pointLog': pointLog,
      'tournamentId': tournamentId,
      'bracketMatchId': bracketMatchId,
    };
  }

  factory BadmintonMatchModel.fromJson(Map<String, dynamic> json) {
    return BadmintonMatchModel(
      matchId: json['matchId'] ?? '',
      createdBy: json['createdBy'] ?? '',
      sport: json['sport'] ?? 'badminton',
      allPlayers: _toList<String>(json['allPlayers']),
      teamAPlayers: _toList<String>(json['teamAPlayers']),
      teamBPlayers: _toList<String>(json['teamBPlayers']),
      maxAllowedPlayers: json['maxAllowedPlayers'] ?? 2,
      isFriendlyRules: json['isFriendlyRules'] ?? false,
      pointsToWin: json['pointsToWin'] ?? 21,
      maxPointCap: json['maxPointCap'] ?? 30,
      winByTwo: json['winByTwo'] ?? true,
      gamesToWin: json['gamesToWin'] ?? 2,
      intervalsEnabled: json['intervalsEnabled'] ?? true,
      endsChangeEnabled: json['endsChangeEnabled'] ?? true,
      status: json['status'] ?? 'Upcoming',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      engineState: _toMap(json['engineState']),
      lastUpdatedAt: json['lastUpdatedAt'] != null ? DateTime.parse(json['lastUpdatedAt']) : null,
      matchResult: json['matchResult'] ?? '',
      pointLog: _toList<Map<String, dynamic>>(json['pointLog']),
      tournamentId: json['tournamentId'],
      bracketMatchId: json['bracketMatchId'],
    );
  }
}
