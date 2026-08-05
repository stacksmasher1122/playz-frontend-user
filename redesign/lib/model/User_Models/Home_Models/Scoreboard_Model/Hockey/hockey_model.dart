import 'dart:convert';

class HockeyMatchModel {
  final String matchId;
  final String userId;
  final String homeTeam;
  final String awayTeam;
  final int homeGoals;
  final int awayGoals;
  final String currentPeriodDisplay;
  final bool isCompleted;
  final String matchResult;
  final Map<String, dynamic>? engineState;
  final DateTime createdAt;
  final DateTime updatedAt;

  HockeyMatchModel({
    required this.matchId,
    required this.userId,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeGoals,
    required this.awayGoals,
    required this.currentPeriodDisplay,
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
        'homeGoals': homeGoals,
        'awayGoals': awayGoals,
        'currentPeriodDisplay': currentPeriodDisplay,
        'isCompleted': isCompleted ? 1 : 0,
        'matchResult': matchResult,
        'engineState': engineState != null ? jsonEncode(engineState) : null,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory HockeyMatchModel.fromMap(Map<String, dynamic> map) => HockeyMatchModel(
        matchId: map['matchId'] as String,
        userId: map['userId'] as String? ?? '',
        homeTeam: map['homeTeam'] as String? ?? 'Side A',
        awayTeam: map['awayTeam'] as String? ?? 'Side B',
        homeGoals: map['homeGoals'] as int? ?? 0,
        awayGoals: map['awayGoals'] as int? ?? 0,
        currentPeriodDisplay: map['currentPeriodDisplay'] as String? ?? 'Q1',
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
        'homeGoals': homeGoals,
        'awayGoals': awayGoals,
        'currentPeriodDisplay': currentPeriodDisplay,
        'isCompleted': isCompleted,
        'matchResult': matchResult,
        'engineState': engineState,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory HockeyMatchModel.fromFirebaseJson(Map<String, dynamic> json) => HockeyMatchModel(
        matchId: json['matchId'] as String? ?? '',
        userId: json['userId'] as String? ?? '',
        homeTeam: json['homeTeam'] as String? ?? 'Side A',
        awayTeam: json['awayTeam'] as String? ?? 'Side B',
        homeGoals: json['homeGoals'] as int? ?? 0,
        awayGoals: json['awayGoals'] as int? ?? 0,
        currentPeriodDisplay: json['currentPeriodDisplay'] as String? ?? 'Q1',
        isCompleted: json['isCompleted'] as bool? ?? false,
        matchResult: json['matchResult'] as String? ?? '',
        engineState: json['engineState'] != null
            ? json['engineState'] as Map<String, dynamic>
            : null,
        createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : DateTime.now(),
        updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : DateTime.now(),
      );
}
