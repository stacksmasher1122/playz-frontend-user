import 'dart:convert';

class MuayThaiMatchModel {
  final String matchId;
  final String userId;
  final String fighterA; // Red Corner
  final String fighterB; // Blue Corner
  final int fighterAScore;
  final int fighterBScore;
  final String currentRoundDisplay;
  final bool isCompleted;
  final String matchResult;
  final Map<String, dynamic>? engineState;
  final DateTime createdAt;
  final DateTime updatedAt;

  MuayThaiMatchModel({
    required this.matchId,
    required this.userId,
    required this.fighterA,
    required this.fighterB,
    required this.fighterAScore,
    required this.fighterBScore,
    required this.currentRoundDisplay,
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
      'fighterA': fighterA,
      'fighterB': fighterB,
      'fighterAScore': fighterAScore,
      'fighterBScore': fighterBScore,
      'currentRoundDisplay': currentRoundDisplay,
      'isCompleted': isCompleted ? 1 : 0,
      'matchResult': matchResult,
      'engineState': engineState != null ? jsonEncode(engineState) : null,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory MuayThaiMatchModel.fromMap(Map<String, dynamic> map) {
    return MuayThaiMatchModel(
      matchId: map['matchId']?.toString() ?? '',
      userId: map['userId']?.toString() ?? '',
      fighterA: map['fighterA']?.toString() ?? 'RED Corner',
      fighterB: map['fighterB']?.toString() ?? 'BLUE Corner',
      fighterAScore: map['fighterAScore'] is int
          ? map['fighterAScore']
          : int.tryParse(map['fighterAScore']?.toString() ?? '') ?? 0,
      fighterBScore: map['fighterBScore'] is int
          ? map['fighterBScore']
          : int.tryParse(map['fighterBScore']?.toString() ?? '') ?? 0,
      currentRoundDisplay: map['currentRoundDisplay']?.toString() ?? 'Round 1',
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

  factory MuayThaiMatchModel.fromFirebaseJson(Map<String, dynamic> json) =>
      MuayThaiMatchModel.fromMap(json);
}
