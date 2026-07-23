import 'package:cloud_firestore/cloud_firestore.dart';

class BasketballMatchModel {
  final String id;
  final String createdBy;
  final String homeTeamName;
  final String awayTeamName;
  final List<String> allPlayers;
  final List<String> homeTeamPlayers;
  final List<String> awayTeamPlayers;
  final String matchMode; // 'friendly' | 'professional'
  final Map<String, dynamic> config;
  final String status; // 'pending' | 'live' | 'completed'
  final Map<String, dynamic> engineState;
  final String? matchResult;
  final DateTime createdAt;
  final DateTime? lastUpdatedAt;
  final String sport;

  BasketballMatchModel({
    required this.id,
    required this.createdBy,
    required this.homeTeamName,
    required this.awayTeamName,
    required this.allPlayers,
    required this.homeTeamPlayers,
    required this.awayTeamPlayers,
    required this.matchMode,
    required this.config,
    required this.status,
    required this.engineState,
    this.matchResult,
    required this.createdAt,
    this.lastUpdatedAt,
    this.sport = 'basketball',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdBy': createdBy,
      'homeTeamName': homeTeamName,
      'awayTeamName': awayTeamName,
      'allPlayers': allPlayers,
      'homeTeamPlayers': homeTeamPlayers,
      'awayTeamPlayers': awayTeamPlayers,
      'matchMode': matchMode,
      'config': config,
      'status': status,
      'engineState': engineState,
      'matchResult': matchResult,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastUpdatedAt': lastUpdatedAt != null ? Timestamp.fromDate(lastUpdatedAt!) : null,
      'sport': sport,
    };
  }

  factory BasketballMatchModel.fromMap(Map<String, dynamic> map, String docId) {
    return BasketballMatchModel(
      id: docId,
      createdBy: map['createdBy'] ?? '',
      homeTeamName: map['homeTeamName'] ?? 'Home Team',
      awayTeamName: map['awayTeamName'] ?? 'Away Team',
      allPlayers: List<String>.from(map['allPlayers'] ?? []),
      homeTeamPlayers: List<String>.from(map['homeTeamPlayers'] ?? []),
      awayTeamPlayers: List<String>.from(map['awayTeamPlayers'] ?? []),
      matchMode: map['matchMode'] ?? 'friendly',
      config: Map<String, dynamic>.from(map['config'] ?? {}),
      status: map['status'] ?? 'pending',
      engineState: Map<String, dynamic>.from(map['engineState'] ?? {}),
      matchResult: map['matchResult'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastUpdatedAt: (map['lastUpdatedAt'] as Timestamp?)?.toDate(),
      sport: map['sport'] ?? 'basketball',
    );
  }
}
