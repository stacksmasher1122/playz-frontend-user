import 'dart:convert';

class BoxingMatchModel {
  final String matchId;
  final String userId;
  final String fighterA;
  final String fighterB;
  final int fighterAScore;
  final int fighterBScore;
  final String currentRoundDisplay;
  final bool isCompleted;
  final String matchResult;
  final Map<String, dynamic>? engineState;
  final DateTime createdAt;
  final DateTime updatedAt;

  BoxingMatchModel({
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

  Map<String, dynamic> toMap() => {
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

  factory BoxingMatchModel.fromMap(Map<String, dynamic> map) => BoxingMatchModel(
        matchId: map['matchId']?.toString() ?? '',
        userId: map['userId']?.toString() ?? '',
        fighterA: map['fighterA']?.toString() ?? 'Red Corner',
        fighterB: map['fighterB']?.toString() ?? 'Blue Corner',
        fighterAScore: map['fighterAScore'] is int ? map['fighterAScore'] : int.tryParse(map['fighterAScore']?.toString() ?? '') ?? 0,
        fighterBScore: map['fighterBScore'] is int ? map['fighterBScore'] : int.tryParse(map['fighterBScore']?.toString() ?? '') ?? 0,
        currentRoundDisplay: map['currentRoundDisplay']?.toString() ?? 'Round 1',
        isCompleted: map['isCompleted'] == 1 || map['isCompleted'] == true,
        matchResult: map['matchResult']?.toString() ?? '',
        engineState: map['engineState'] != null
            ? jsonDecode(map['engineState'] as String) as Map<String, dynamic>
            : null,
        createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt'].toString()) : DateTime.now(),
        updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt'].toString()) : DateTime.now(),
      );

  Map<String, dynamic> toFirebaseJson() => {
        'matchId': matchId,
        'userId': userId,
        'fighterA': fighterA,
        'fighterB': fighterB,
        'fighterAScore': fighterAScore,
        'fighterBScore': fighterBScore,
        'currentRoundDisplay': currentRoundDisplay,
        'isCompleted': isCompleted,
        'matchResult': matchResult,
        'engineState': engineState,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory BoxingMatchModel.fromFirebaseJson(Map<String, dynamic> json) => BoxingMatchModel(
        matchId: json['matchId']?.toString() ?? '',
        userId: json['userId']?.toString() ?? '',
        fighterA: json['fighterA']?.toString() ?? 'Red Corner',
        fighterB: json['fighterB']?.toString() ?? 'Blue Corner',
        fighterAScore: json['fighterAScore'] is int ? json['fighterAScore'] : int.tryParse(json['fighterAScore']?.toString() ?? '') ?? 0,
        fighterBScore: json['fighterBScore'] is int ? json['fighterBScore'] : int.tryParse(json['fighterBScore']?.toString() ?? '') ?? 0,
        currentRoundDisplay: json['currentRoundDisplay']?.toString() ?? 'Round 1',
        isCompleted: json['isCompleted'] == true || json['isCompleted'] == 1,
        matchResult: json['matchResult']?.toString() ?? '',
        engineState: json['engineState'] != null
            ? json['engineState'] as Map<String, dynamic>
            : null,
        createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'].toString()) : DateTime.now(),
        updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'].toString()) : DateTime.now(),
      );
}
