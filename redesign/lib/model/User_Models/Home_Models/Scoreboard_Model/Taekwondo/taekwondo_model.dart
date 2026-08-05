import 'dart:convert';

class TaekwondoMatchModel {
  final String matchId;
  final String userId;
  final String hongFighter;
  final String chongFighter;
  final int hongScore;
  final int chongScore;
  final String currentRoundDisplay;
  final bool isCompleted;
  final String matchResult;
  final Map<String, dynamic>? engineState;
  final DateTime createdAt;
  final DateTime updatedAt;

  TaekwondoMatchModel({
    required this.matchId,
    required this.userId,
    required this.hongFighter,
    required this.chongFighter,
    required this.hongScore,
    required this.chongScore,
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
      'hongFighter': hongFighter,
      'chongFighter': chongFighter,
      'hongScore': hongScore,
      'chongScore': chongScore,
      'currentRoundDisplay': currentRoundDisplay,
      'isCompleted': isCompleted ? 1 : 0,
      'matchResult': matchResult,
      'engineState': engineState != null ? jsonEncode(engineState) : null,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory TaekwondoMatchModel.fromMap(Map<String, dynamic> map) {
    return TaekwondoMatchModel(
      matchId: map['matchId']?.toString() ?? '',
      userId: map['userId']?.toString() ?? '',
      hongFighter: map['hongFighter']?.toString() ?? 'HONG (Red)',
      chongFighter: map['chongFighter']?.toString() ?? 'CHONG (Blue)',
      hongScore: map['hongScore'] is int
          ? map['hongScore']
          : int.tryParse(map['hongScore']?.toString() ?? '') ?? 0,
      chongScore: map['chongScore'] is int
          ? map['chongScore']
          : int.tryParse(map['chongScore']?.toString() ?? '') ?? 0,
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

  factory TaekwondoMatchModel.fromFirebaseJson(Map<String, dynamic> json) =>
      TaekwondoMatchModel.fromMap(json);
}
