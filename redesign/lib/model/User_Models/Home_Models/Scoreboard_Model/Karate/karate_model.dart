import 'dart:convert';

class KarateMatchModel {
  final String matchId;
  final String userId;
  final String akaFighter;
  final String aoFighter;
  final int akaScore;
  final int aoScore;
  final String currentBoutDisplay;
  final bool isCompleted;
  final String matchResult;
  final Map<String, dynamic>? engineState;
  final DateTime createdAt;
  final DateTime updatedAt;

  KarateMatchModel({
    required this.matchId,
    required this.userId,
    required this.akaFighter,
    required this.aoFighter,
    required this.akaScore,
    required this.aoScore,
    required this.currentBoutDisplay,
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
      'akaFighter': akaFighter,
      'aoFighter': aoFighter,
      'akaScore': akaScore,
      'aoScore': aoScore,
      'currentBoutDisplay': currentBoutDisplay,
      'isCompleted': isCompleted ? 1 : 0,
      'matchResult': matchResult,
      'engineState': engineState != null ? jsonEncode(engineState) : null,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory KarateMatchModel.fromMap(Map<String, dynamic> map) {
    return KarateMatchModel(
      matchId: map['matchId']?.toString() ?? '',
      userId: map['userId']?.toString() ?? '',
      akaFighter: map['akaFighter']?.toString() ?? 'AKA (Red)',
      aoFighter: map['aoFighter']?.toString() ?? 'AO (Blue)',
      akaScore: map['akaScore'] is int
          ? map['akaScore']
          : int.tryParse(map['akaScore']?.toString() ?? '') ?? 0,
      aoScore: map['aoScore'] is int
          ? map['aoScore']
          : int.tryParse(map['aoScore']?.toString() ?? '') ?? 0,
      currentBoutDisplay: map['currentBoutDisplay']?.toString() ?? 'Kumite Bout',
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

  factory KarateMatchModel.fromFirebaseJson(Map<String, dynamic> json) =>
      KarateMatchModel.fromMap(json);
}
