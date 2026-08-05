import 'dart:convert';

class PickleballMatchModel {
  final String matchId;
  final String userId;
  final String homeTeam;
  final String awayTeam;
  final int homeGamesWon;
  final int awayGamesWon;
  final String currentScoreDisplay;
  final bool isCompleted;
  final String matchResult;
  final Map<String, dynamic>? engineState;
  final DateTime createdAt;
  final DateTime updatedAt;

  PickleballMatchModel({
    required this.matchId,
    required this.userId,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeGamesWon,
    required this.awayGamesWon,
    required this.currentScoreDisplay,
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
        'homeGamesWon': homeGamesWon,
        'awayGamesWon': awayGamesWon,
        'currentScoreDisplay': currentScoreDisplay,
        'isCompleted': isCompleted ? 1 : 0,
        'matchResult': matchResult,
        'engineState': engineState != null ? jsonEncode(engineState) : null,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory PickleballMatchModel.fromMap(Map<String, dynamic> map) => PickleballMatchModel(
        matchId: map['matchId']?.toString() ?? '',
        userId: map['userId']?.toString() ?? '',
        homeTeam: map['homeTeam']?.toString() ?? 'Side A',
        awayTeam: map['awayTeam']?.toString() ?? 'Side B',
        homeGamesWon: map['homeGamesWon'] is int ? map['homeGamesWon'] : int.tryParse(map['homeGamesWon']?.toString() ?? '') ?? 0,
        awayGamesWon: map['awayGamesWon'] is int ? map['awayGamesWon'] : int.tryParse(map['awayGamesWon']?.toString() ?? '') ?? 0,
        currentScoreDisplay: map['currentScoreDisplay']?.toString() ?? 'Game 1',
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
        'homeTeam': homeTeam,
        'awayTeam': awayTeam,
        'homeGamesWon': homeGamesWon,
        'awayGamesWon': awayGamesWon,
        'currentScoreDisplay': currentScoreDisplay,
        'isCompleted': isCompleted,
        'matchResult': matchResult,
        'engineState': engineState,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory PickleballMatchModel.fromFirebaseJson(Map<String, dynamic> json) => PickleballMatchModel(
        matchId: json['matchId']?.toString() ?? '',
        userId: json['userId']?.toString() ?? '',
        homeTeam: json['homeTeam']?.toString() ?? 'Side A',
        awayTeam: json['awayTeam']?.toString() ?? 'Side B',
        homeGamesWon: json['homeGamesWon'] is int ? json['homeGamesWon'] : int.tryParse(json['homeGamesWon']?.toString() ?? '') ?? 0,
        awayGamesWon: json['awayGamesWon'] is int ? json['awayGamesWon'] : int.tryParse(json['awayGamesWon']?.toString() ?? '') ?? 0,
        currentScoreDisplay: json['currentScoreDisplay']?.toString() ?? 'Game 1',
        isCompleted: json['isCompleted'] == true || json['isCompleted'] == 1,
        matchResult: json['matchResult']?.toString() ?? '',
        engineState: json['engineState'] != null
            ? json['engineState'] as Map<String, dynamic>
            : null,
        createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'].toString()) : DateTime.now(),
        updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'].toString()) : DateTime.now(),
      );
}
