import 'dart:convert';
import 'tennis_state_models.dart';

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

class TennisMatchModel {
  final String matchId;
  final String createdBy;
  final String sport;
  final String status;
  final String matchResult;
  final List<String> allPlayers;
  final String homeTeamName;
  final String awayTeamName;
  final List<String> homeTeamPlayers;
  final List<String> awayTeamPlayers;
  final Map<String, dynamic>? engineState;
  final Map<String, dynamic> config;
  final DateTime createdAt;
  final DateTime lastUpdatedAt;
  final String matchType;
  final String? bookingId;
  final bool isRecoverable;
  final String? tournamentId;
  final String? bracketMatchId;

  TennisMatchModel({
    required this.matchId,
    required this.createdBy,
    this.sport = 'tennis',
    required this.status,
    this.matchResult = '',
    required this.allPlayers,
    required this.homeTeamName,
    required this.awayTeamName,
    required this.homeTeamPlayers,
    required this.awayTeamPlayers,
    this.engineState,
    required this.config,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
    this.matchType = 'NORMAL',
    this.bookingId,
    this.isRecoverable = true,
    this.tournamentId,
    this.bracketMatchId,
  })  : createdAt = createdAt ?? DateTime.now(),
        lastUpdatedAt = lastUpdatedAt ?? DateTime.now();

  TennisMatchState? get parsedEngineState {
    if (engineState == null || engineState!.isEmpty) return null;
    return TennisMatchState.fromJson(engineState!);
  }

  Map<String, dynamic> toFirebaseJson() {
    return {
      'matchId': matchId,
      'createdBy': createdBy,
      'sport': 'tennis',
      'status': status,
      'matchResult': matchResult,
      'allPlayers': allPlayers,
      'homeTeamName': homeTeamName,
      'awayTeamName': awayTeamName,
      'homeTeamPlayers': homeTeamPlayers,
      'awayTeamPlayers': awayTeamPlayers,
      'engineState': engineState,
      'config': config,
      'createdAt': createdAt.toIso8601String(),
      'lastUpdatedAt': lastUpdatedAt.toIso8601String(),
      'matchType': matchType,
      'bookingId': bookingId,
      'isRecoverable': isRecoverable,
      'tournamentId': tournamentId,
      'bracketMatchId': bracketMatchId,
    };
  }

  factory TennisMatchModel.fromFirebaseJson(Map<String, dynamic> json) {
    return TennisMatchModel(
      matchId: json['matchId'] ?? '',
      createdBy: json['createdBy'] ?? '',
      sport: json['sport'] ?? 'tennis',
      status: json['status'] ?? 'in_progress',
      matchResult: json['matchResult'] ?? '',
      allPlayers: _toList<String>(json['allPlayers']),
      homeTeamName: json['homeTeamName'] ?? 'Team A',
      awayTeamName: json['awayTeamName'] ?? 'Team B',
      homeTeamPlayers: _toList<String>(json['homeTeamPlayers']),
      awayTeamPlayers: _toList<String>(json['awayTeamPlayers']),
      engineState: _toMap(json['engineState']),
      config: _toMap(json['config']),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      lastUpdatedAt: json['lastUpdatedAt'] != null
          ? DateTime.parse(json['lastUpdatedAt'])
          : DateTime.now(),
      matchType: json['matchType'] ?? 'NORMAL',
      bookingId: json['bookingId'],
      isRecoverable: json['isRecoverable'] ?? true,
      tournamentId: json['tournamentId'],
      bracketMatchId: json['bracketMatchId'],
    );
  }

  Map<String, dynamic> toSqfliteMap() {
    return {
      'matchId': matchId,
      'createdBy': createdBy,
      'sport': sport,
      'status': status,
      'matchResult': matchResult,
      'allPlayers': jsonEncode(allPlayers),
      'homeTeamName': homeTeamName,
      'awayTeamName': awayTeamName,
      'homeTeamPlayers': jsonEncode(homeTeamPlayers),
      'awayTeamPlayers': jsonEncode(awayTeamPlayers),
      'engineState': engineState != null ? jsonEncode(engineState) : null,
      'config': jsonEncode(config),
      'createdAt': createdAt.toIso8601String(),
      'lastUpdatedAt': lastUpdatedAt.toIso8601String(),
      'matchType': matchType,
      'bookingId': bookingId,
      'isRecoverable': isRecoverable ? 1 : 0,
      'tournamentId': tournamentId,
      'bracketMatchId': bracketMatchId,
    };
  }

  factory TennisMatchModel.fromSqfliteMap(Map<String, dynamic> map) {
    return TennisMatchModel(
      matchId: map['matchId'] ?? '',
      createdBy: map['createdBy'] ?? '',
      sport: map['sport'] ?? 'tennis',
      status: map['status'] ?? 'in_progress',
      matchResult: map['matchResult'] ?? '',
      allPlayers: _toList<String>(map['allPlayers']),
      homeTeamName: map['homeTeamName'] ?? 'Team A',
      awayTeamName: map['awayTeamName'] ?? 'Team B',
      homeTeamPlayers: _toList<String>(map['homeTeamPlayers']),
      awayTeamPlayers: _toList<String>(map['awayTeamPlayers']),
      engineState: _toMap(map['engineState']),
      config: _toMap(map['config']),
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      lastUpdatedAt: map['lastUpdatedAt'] != null
          ? DateTime.parse(map['lastUpdatedAt'])
          : DateTime.now(),
      matchType: map['matchType'] ?? 'NORMAL',
      bookingId: map['bookingId'],
      isRecoverable: map['isRecoverable'] == 1,
      tournamentId: map['tournamentId'],
      bracketMatchId: map['bracketMatchId'],
    );
  }
}
