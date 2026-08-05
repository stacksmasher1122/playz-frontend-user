import 'dart:convert';

class WrestlingMatchModel {
  final String matchId;
  final String userId;
  final String wrestlerA;
  final String wrestlerB;
  final int wrestlerAScore;
  final int wrestlerBScore;
  final String currentPeriodDisplay;
  final bool isCompleted;
  final String matchResult;
  final Map<String, dynamic>? engineState;
  final DateTime createdAt;
  final DateTime updatedAt;

  WrestlingMatchModel({
    required this.matchId,
    required this.userId,
    required this.wrestlerA,
    required this.wrestlerB,
    required this.wrestlerAScore,
    required this.wrestlerBScore,
    required this.currentPeriodDisplay,
    required this.isCompleted,
    required this.matchResult,
    this.engineState,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'matchId': matchId,
      'userId': userId,
      'wrestlerA': wrestlerA,
      'wrestlerB': wrestlerB,
      'wrestlerAScore': wrestlerAScore,
      'wrestlerBScore': wrestlerBScore,
      'currentPeriodDisplay': currentPeriodDisplay,
      'isCompleted': isCompleted ? 1 : 0,
      'matchResult': matchResult,
      'engineState': engineState != null ? jsonEncode(engineState) : null,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory WrestlingMatchModel.fromMap(Map<String, dynamic> map) {
    return WrestlingMatchModel(
      matchId: map['matchId']?.toString() ?? '',
      userId: map['userId']?.toString() ?? '',
      wrestlerA: map['wrestlerA']?.toString() ?? 'Red Corner',
      wrestlerB: map['wrestlerB']?.toString() ?? 'Blue Corner',
      wrestlerAScore: map['wrestlerAScore'] is int
          ? map['wrestlerAScore']
          : int.tryParse(map['wrestlerAScore']?.toString() ?? '') ?? 0,
      wrestlerBScore: map['wrestlerBScore'] is int
          ? map['wrestlerBScore']
          : int.tryParse(map['wrestlerBScore']?.toString() ?? '') ?? 0,
      currentPeriodDisplay: map['currentPeriodDisplay']?.toString() ?? 'Period 1 of 2',
      isCompleted: map['isCompleted'] == 1 || map['isCompleted'] == true,
      matchResult: map['matchResult']?.toString() ?? '',
      engineState: map['engineState'] != null
          ? (map['engineState'] is String
              ? jsonDecode(map['engineState'])
              : Map<String, dynamic>.from(map['engineState']))
          : null,
      createdAt: map['createdAt'] != null ? DateTime.tryParse(map['createdAt'].toString()) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.tryParse(map['updatedAt'].toString()) : null,
    );
  }

  Map<String, dynamic> toFirebaseJson() => toMap();

  factory WrestlingMatchModel.fromFirebaseJson(Map<String, dynamic> json) =>
      WrestlingMatchModel.fromMap(json);
}
