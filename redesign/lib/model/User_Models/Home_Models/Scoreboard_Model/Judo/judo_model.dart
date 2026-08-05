import 'dart:convert';

class JudoMatchModel {
  final String matchId;
  final String userId;
  final String whiteFighter;
  final String blueFighter;
  final int whiteWazaAri;
  final int blueWazaAri;
  final String currentContestDisplay;
  final bool isCompleted;
  final String matchResult;
  final Map<String, dynamic>? engineState;
  final DateTime createdAt;
  final DateTime updatedAt;

  JudoMatchModel({
    required this.matchId,
    required this.userId,
    required this.whiteFighter,
    required this.blueFighter,
    required this.whiteWazaAri,
    required this.blueWazaAri,
    required this.currentContestDisplay,
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
      'whiteFighter': whiteFighter,
      'blueFighter': blueFighter,
      'whiteWazaAri': whiteWazaAri,
      'blueWazaAri': blueWazaAri,
      'currentContestDisplay': currentContestDisplay,
      'isCompleted': isCompleted ? 1 : 0,
      'matchResult': matchResult,
      'engineState': engineState != null ? jsonEncode(engineState) : null,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory JudoMatchModel.fromMap(Map<String, dynamic> map) {
    return JudoMatchModel(
      matchId: map['matchId']?.toString() ?? '',
      userId: map['userId']?.toString() ?? '',
      whiteFighter: map['whiteFighter']?.toString() ?? 'WHITE Corner',
      blueFighter: map['blueFighter']?.toString() ?? 'BLUE Corner',
      whiteWazaAri: map['whiteWazaAri'] is int
          ? map['whiteWazaAri']
          : int.tryParse(map['whiteWazaAri']?.toString() ?? '') ?? 0,
      blueWazaAri: map['blueWazaAri'] is int
          ? map['blueWazaAri']
          : int.tryParse(map['blueWazaAri']?.toString() ?? '') ?? 0,
      currentContestDisplay: map['currentContestDisplay']?.toString() ?? 'Judo Contest',
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

  factory JudoMatchModel.fromFirebaseJson(Map<String, dynamic> json) =>
      JudoMatchModel.fromMap(json);
}
