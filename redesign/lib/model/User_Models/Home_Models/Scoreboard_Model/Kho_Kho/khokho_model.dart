import 'dart:convert';

class KhoKhoMatchModel {
  final String matchId;
  final String userId;
  final String homeTeam;
  final String awayTeam;
  final int homePoints;
  final int awayPoints;
  final String currentTurnDisplay;
  final bool isCompleted;
  final String matchResult;
  final Map<String, dynamic>? engineState;
  final DateTime createdAt;
  final DateTime updatedAt;

  KhoKhoMatchModel({
    required this.matchId,
    required this.userId,
    required this.homeTeam,
    required this.awayTeam,
    required this.homePoints,
    required this.awayPoints,
    required this.currentTurnDisplay,
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
        'homeTeam': homeTeam,
        'awayTeam': awayTeam,
        'homePoints': homePoints,
        'awayPoints': awayPoints,
        'currentTurnDisplay': currentTurnDisplay,
        'isCompleted': isCompleted ? 1 : 0,
        'matchResult': matchResult,
        'engineState': engineState != null ? jsonEncode(engineState) : null,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory KhoKhoMatchModel.fromMap(Map<String, dynamic> map) => KhoKhoMatchModel(
        matchId: map['matchId'] as String,
        userId: map['userId'] as String? ?? '',
        homeTeam: map['homeTeam'] as String? ?? 'Side A',
        awayTeam: map['awayTeam'] as String? ?? 'Side B',
        homePoints: map['homePoints'] as int? ?? 0,
        awayPoints: map['awayPoints'] as int? ?? 0,
        currentTurnDisplay: map['currentTurnDisplay'] as String? ?? 'Turn 1',
        isCompleted: map['isCompleted'] == 1 || map['isCompleted'] == true,
        matchResult: map['matchResult'] as String? ?? '',
        engineState: map['engineState'] != null
            ? jsonDecode(map['engineState'] as String) as Map<String, dynamic>
            : null,
        createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt'] as String) : DateTime.now(),
        updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt'] as String) : DateTime.now(),
      );

  Map<String, dynamic> toFirebaseJson() => {
        'matchId': matchId,
        'userId': userId,
        'homeTeam': homeTeam,
        'awayTeam': awayTeam,
        'homePoints': homePoints,
        'awayPoints': awayPoints,
        'currentTurnDisplay': currentTurnDisplay,
        'isCompleted': isCompleted,
        'matchResult': matchResult,
        'engineState': engineState,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory KhoKhoMatchModel.fromFirebaseJson(Map<String, dynamic> json) => KhoKhoMatchModel(
        matchId: json['matchId'] as String? ?? '',
        userId: json['userId'] as String? ?? '',
        homeTeam: json['homeTeam'] as String? ?? 'Side A',
        awayTeam: json['awayTeam'] as String? ?? 'Side B',
        homePoints: json['homePoints'] as int? ?? 0,
        awayPoints: json['awayPoints'] as int? ?? 0,
        currentTurnDisplay: json['currentTurnDisplay'] as String? ?? 'Turn 1',
        isCompleted: json['isCompleted'] as bool? ?? false,
        matchResult: json['matchResult'] as String? ?? '',
        engineState: json['engineState'] != null
            ? json['engineState'] as Map<String, dynamic>
            : null,
        createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : DateTime.now(),
        updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : DateTime.now(),
      );
}
