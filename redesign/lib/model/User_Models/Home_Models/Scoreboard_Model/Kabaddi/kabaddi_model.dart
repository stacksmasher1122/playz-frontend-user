import 'dart:convert';

class KabaddiMatchModel {
  final String matchId;
  final String userId;
  final String homeTeam;
  final String awayTeam;
  final int homeScore;
  final int awayScore;
  final String currentHalf;
  final bool isCompleted;
  final String matchResult;
  final String sport;
  final String matchType;
  final String? bookingId;
  final Map<String, dynamic>? engineState;
  final DateTime createdAt;
  final DateTime updatedAt;

  KabaddiMatchModel({
    required this.matchId,
    required this.userId,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeScore,
    required this.awayScore,
    required this.currentHalf,
    required this.isCompleted,
    required this.matchResult,
    this.sport = 'kabaddi',
    this.matchType = 'NORMAL',
    this.bookingId,
    this.engineState,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'matchId': matchId,
      'userId': userId,
      'homeTeam': homeTeam,
      'awayTeam': awayTeam,
      'homeScore': homeScore,
      'awayScore': awayScore,
      'currentHalf': currentHalf,
      'isCompleted': isCompleted ? 1 : 0,
      'matchResult': matchResult,
      'sport': sport,
      'matchType': matchType,
      'bookingId': bookingId,
      'engineState': engineState != null ? jsonEncode(engineState) : null,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toFirebaseJson() {
    return {
      'matchId': matchId,
      'userId': userId,
      'homeTeam': homeTeam,
      'awayTeam': awayTeam,
      'homeScore': homeScore,
      'awayScore': awayScore,
      'currentHalf': currentHalf,
      'isCompleted': isCompleted,
      'matchResult': matchResult,
      'sport': sport,
      'matchType': matchType,
      'bookingId': bookingId,
      'engineState': engineState,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory KabaddiMatchModel.fromMap(Map<String, dynamic> map) {
    Map<String, dynamic>? parsedEngine;
    if (map['engineState'] != null) {
      if (map['engineState'] is String) {
        try {
          parsedEngine = jsonDecode(map['engineState'] as String) as Map<String, dynamic>;
        } catch (_) {}
      } else if (map['engineState'] is Map) {
        parsedEngine = Map<String, dynamic>.from(map['engineState'] as Map);
      }
    }

    return KabaddiMatchModel(
      matchId: map['matchId'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
      homeTeam: map['homeTeam'] as String? ?? 'Side A',
      awayTeam: map['awayTeam'] as String? ?? 'Side B',
      homeScore: map['homeScore'] as int? ?? 0,
      awayScore: map['awayScore'] as int? ?? 0,
      currentHalf: map['currentHalf'] as String? ?? '1st Half',
      isCompleted: map['isCompleted'] == 1 || map['isCompleted'] == true,
      matchResult: map['matchResult'] as String? ?? '',
      sport: map['sport'] as String? ?? 'kabaddi',
      matchType: map['matchType'] as String? ?? 'NORMAL',
      bookingId: map['bookingId'] as String?,
      engineState: parsedEngine,
      createdAt: map['createdAt'] != null ? DateTime.tryParse(map['createdAt'].toString()) : DateTime.now(),
      updatedAt: map['updatedAt'] != null ? DateTime.tryParse(map['updatedAt'].toString()) : DateTime.now(),
    );
  }

  factory KabaddiMatchModel.fromFirebaseJson(Map<String, dynamic> json) {
    return KabaddiMatchModel.fromMap(json);
  }
}
