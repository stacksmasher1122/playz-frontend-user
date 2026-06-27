import 'dart:convert';

List<T> _toList<T>(dynamic val) {
  if (val == null) return [];
  if (val is String) {
    try {
      return List<T>.from(jsonDecode(val));
    } catch (_) {
      return [];
    }
  }
  if (val is List) return List<T>.from(val);
  return [];
}

Map<String, dynamic> _toMap(dynamic val) {
  if (val == null) return {};
  if (val is String) {
    try {
      return Map<String, dynamic>.from(jsonDecode(val));
    } catch (_) {
      return {};
    }
  }
  if (val is Map) return Map<String, dynamic>.from(val);
  return {};
}

class CricketMatchModel {
  final String matchId;
  final String createdBy;
  final List<String> allPlayers;
  final String homeTeamName;
  final String awayTeamName;
  final List<String> homeTeamPlayers;
  final List<String> awayTeamPlayers;
  final int squadLimit;
  final bool subsEnabled;
  final int maxSubstitutes;
  final int overs;
  final String status;
  final Map<String, dynamic> scorecard;
  final DateTime createdAt;
  final String tossWinner;
  final String tossDecision;
  final String battingFirstTeam;
  final String bowlingFirstTeam;

  // Live match state fields
  final int currentInnings;
  final int innings1Score;
  final int innings1Wickets;
  final int innings1Overs;
  final int innings1Balls;
  final int innings2Score;
  final int innings2Wickets;
  final int innings2Overs;
  final int innings2Balls;
  final Map<String, dynamic>? engineState;
  final DateTime lastUpdatedAt;
  final String currentBattingTeam;
  final String currentBowlingTeam;
  final String matchResult;
  final List<Map<String, dynamic>> ballEvents;
  final List<Map<String, dynamic>> inningsArray;

  CricketMatchModel({
    required this.matchId,
    required this.createdBy,
    required this.allPlayers,
    required this.homeTeamName,
    required this.awayTeamName,
    required this.homeTeamPlayers,
    required this.awayTeamPlayers,
    required this.squadLimit,
    required this.subsEnabled,
    required this.maxSubstitutes,
    required this.overs,
    required this.status,
    required this.scorecard,
    required this.createdAt,
    required this.tossWinner,
    required this.tossDecision,
    required this.battingFirstTeam,
    required this.bowlingFirstTeam,
    this.currentInnings = 1,
    this.innings1Score = 0,
    this.innings1Wickets = 0,
    this.innings1Overs = 0,
    this.innings1Balls = 0,
    this.innings2Score = 0,
    this.innings2Wickets = 0,
    this.innings2Overs = 0,
    this.innings2Balls = 0,
    this.engineState,
    DateTime? lastUpdatedAt,
    this.currentBattingTeam = '',
    this.currentBowlingTeam = '',
    this.matchResult = '',
    this.ballEvents = const [],
    this.inningsArray = const [],
  }) : lastUpdatedAt = lastUpdatedAt ?? DateTime.now();

  CricketMatchModel copyWith({
    String? matchId,
    String? createdBy,
    List<String>? allPlayers,
    String? homeTeamName,
    String? awayTeamName,
    List<String>? homeTeamPlayers,
    List<String>? awayTeamPlayers,
    int? squadLimit,
    bool? subsEnabled,
    int? maxSubstitutes,
    int? overs,
    String? status,
    Map<String, dynamic>? scorecard,
    DateTime? createdAt,
    String? tossWinner,
    String? tossDecision,
    String? battingFirstTeam,
    String? bowlingFirstTeam,
    int? currentInnings,
    int? innings1Score,
    int? innings1Wickets,
    int? innings1Overs,
    int? innings1Balls,
    int? innings2Score,
    int? innings2Wickets,
    int? innings2Overs,
    int? innings2Balls,
    Map<String, dynamic>? engineState,
    DateTime? lastUpdatedAt,
    String? currentBattingTeam,
    String? currentBowlingTeam,
    String? matchResult,
    List<Map<String, dynamic>>? ballEvents,
    List<Map<String, dynamic>>? inningsArray,
  }) {
    return CricketMatchModel(
      matchId: matchId ?? this.matchId,
      createdBy: createdBy ?? this.createdBy,
      allPlayers: allPlayers ?? this.allPlayers,
      homeTeamName: homeTeamName ?? this.homeTeamName,
      awayTeamName: awayTeamName ?? this.awayTeamName,
      homeTeamPlayers: homeTeamPlayers ?? this.homeTeamPlayers,
      awayTeamPlayers: awayTeamPlayers ?? this.awayTeamPlayers,
      squadLimit: squadLimit ?? this.squadLimit,
      subsEnabled: subsEnabled ?? this.subsEnabled,
      maxSubstitutes: maxSubstitutes ?? this.maxSubstitutes,
      overs: overs ?? this.overs,
      status: status ?? this.status,
      scorecard: scorecard ?? this.scorecard,
      createdAt: createdAt ?? this.createdAt,
      tossWinner: tossWinner ?? this.tossWinner,
      tossDecision: tossDecision ?? this.tossDecision,
      battingFirstTeam: battingFirstTeam ?? this.battingFirstTeam,
      bowlingFirstTeam: bowlingFirstTeam ?? this.bowlingFirstTeam,
      currentInnings: currentInnings ?? this.currentInnings,
      innings1Score: innings1Score ?? this.innings1Score,
      innings1Wickets: innings1Wickets ?? this.innings1Wickets,
      innings1Overs: innings1Overs ?? this.innings1Overs,
      innings1Balls: innings1Balls ?? this.innings1Balls,
      innings2Score: innings2Score ?? this.innings2Score,
      innings2Wickets: innings2Wickets ?? this.innings2Wickets,
      innings2Overs: innings2Overs ?? this.innings2Overs,
      innings2Balls: innings2Balls ?? this.innings2Balls,
      engineState: engineState ?? this.engineState,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      currentBattingTeam: currentBattingTeam ?? this.currentBattingTeam,
      currentBowlingTeam: currentBowlingTeam ?? this.currentBowlingTeam,
      matchResult: matchResult ?? this.matchResult,
      ballEvents: ballEvents ?? this.ballEvents,
      inningsArray: inningsArray ?? this.inningsArray,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'matchId': matchId,
      'createdBy': createdBy,
      'allPlayers': jsonEncode(allPlayers),
      'homeTeamName': homeTeamName,
      'awayTeamName': awayTeamName,
      'homeTeamPlayers': jsonEncode(homeTeamPlayers),
      'awayTeamPlayers': jsonEncode(awayTeamPlayers),
      'squadLimit': squadLimit,
      'subsEnabled': subsEnabled ? 1 : 0,
      'maxSubstitutes': maxSubstitutes,
      'overs': overs,
      'status': status,
      'scorecard': jsonEncode(scorecard),
      'createdAt': createdAt.toIso8601String(),
      'tossWinner': tossWinner,
      'tossDecision': tossDecision,
      'battingFirstTeam': battingFirstTeam,
      'bowlingFirstTeam': bowlingFirstTeam,
      'currentInnings': currentInnings,
      'innings1Score': innings1Score,
      'innings1Wickets': innings1Wickets,
      'innings1Overs': innings1Overs,
      'innings1Balls': innings1Balls,
      'innings2Score': innings2Score,
      'innings2Wickets': innings2Wickets,
      'innings2Overs': innings2Overs,
      'innings2Balls': innings2Balls,
      'engineState': engineState != null ? jsonEncode(engineState) : null,
      'lastUpdatedAt': lastUpdatedAt.toIso8601String(),
      'currentBattingTeam': currentBattingTeam,
      'currentBowlingTeam': currentBowlingTeam,
      'matchResult': matchResult,
      'ballEvents': jsonEncode(ballEvents),
      'inningsArray': jsonEncode(inningsArray),
    };
  }

  factory CricketMatchModel.fromMap(Map<String, dynamic> map) {
    return CricketMatchModel(
      matchId: map['matchId'] ?? '',
      createdBy: map['createdBy'] ?? '',
      allPlayers: _toList<String>(map['allPlayers']),
      homeTeamName: map['homeTeamName'] ?? '',
      awayTeamName: map['awayTeamName'] ?? '',
      homeTeamPlayers: _toList<String>(map['homeTeamPlayers']),
      awayTeamPlayers: _toList<String>(map['awayTeamPlayers']),
      squadLimit: map['squadLimit']?.toInt() ?? 11,
      subsEnabled: map['subsEnabled'] == 1,
      maxSubstitutes: map['maxSubstitutes']?.toInt() ?? 3,
      overs: map['overs']?.toInt() ?? 20,
      status: map['status'] ?? 'pending',
      scorecard: _toMap(map['scorecard']),
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      tossWinner: map['tossWinner'] ?? '',
      tossDecision: map['tossDecision'] ?? '',
      battingFirstTeam: map['battingFirstTeam'] ?? '',
      bowlingFirstTeam: map['bowlingFirstTeam'] ?? '',
      currentInnings: map['currentInnings']?.toInt() ?? 1,
      innings1Score: map['innings1Score']?.toInt() ?? 0,
      innings1Wickets: map['innings1Wickets']?.toInt() ?? 0,
      innings1Overs: map['innings1Overs']?.toInt() ?? 0,
      innings1Balls: map['innings1Balls']?.toInt() ?? 0,
      innings2Score: map['innings2Score']?.toInt() ?? 0,
      innings2Wickets: map['innings2Wickets']?.toInt() ?? 0,
      innings2Overs: map['innings2Overs']?.toInt() ?? 0,
      innings2Balls: map['innings2Balls']?.toInt() ?? 0,
      engineState: map['engineState'] != null ? _toMap(map['engineState']) : null,
      lastUpdatedAt: DateTime.parse(map['lastUpdatedAt'] ?? DateTime.now().toIso8601String()),
      currentBattingTeam: map['currentBattingTeam'] ?? '',
      currentBowlingTeam: map['currentBowlingTeam'] ?? '',
      matchResult: map['matchResult'] ?? '',
      ballEvents: _toList<dynamic>(map['ballEvents'])
          .map((e) => Map<String, dynamic>.from(e))
          .toList(),
      inningsArray: _toList<dynamic>(map['inningsArray'])
          .map((e) => Map<String, dynamic>.from(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'matchId': matchId,
      'createdBy': createdBy,
      'allPlayers': allPlayers,
      'homeTeamName': homeTeamName,
      'awayTeamName': awayTeamName,
      'homeTeamPlayers': homeTeamPlayers,
      'awayTeamPlayers': awayTeamPlayers,
      'squadLimit': squadLimit,
      'subsEnabled': subsEnabled,
      'maxSubstitutes': maxSubstitutes,
      'overs': overs,
      'status': status,
      'scorecard': scorecard,
      'createdAt': createdAt.toIso8601String(),
      'tossWinner': tossWinner,
      'tossDecision': tossDecision,
      'battingFirstTeam': battingFirstTeam,
      'bowlingFirstTeam': bowlingFirstTeam,
      'currentInnings': currentInnings,
      'innings1Score': innings1Score,
      'innings1Wickets': innings1Wickets,
      'innings1Overs': innings1Overs,
      'innings1Balls': innings1Balls,
      'innings2Score': innings2Score,
      'innings2Wickets': innings2Wickets,
      'innings2Overs': innings2Overs,
      'innings2Balls': innings2Balls,
      'engineState': engineState,
      'lastUpdatedAt': lastUpdatedAt.toIso8601String(),
      'currentBattingTeam': currentBattingTeam,
      'currentBowlingTeam': currentBowlingTeam,
      'matchResult': matchResult,
      'ballEvents': ballEvents,
      'inningsArray': inningsArray,
    };
  }

  factory CricketMatchModel.fromJson(Map<String, dynamic> json) {
    return CricketMatchModel(
      matchId: json['matchId'] ?? '',
      createdBy: json['createdBy'] ?? '',
      allPlayers: List<String>.from(json['allPlayers'] ?? []),
      homeTeamName: json['homeTeamName'] ?? '',
      awayTeamName: json['awayTeamName'] ?? '',
      homeTeamPlayers: List<String>.from(json['homeTeamPlayers'] ?? []),
      awayTeamPlayers: List<String>.from(json['awayTeamPlayers'] ?? []),
      squadLimit: json['squadLimit']?.toInt() ?? 11,
      subsEnabled: json['subsEnabled'] ?? true,
      maxSubstitutes: json['maxSubstitutes']?.toInt() ?? 3,
      overs: json['overs']?.toInt() ?? 20,
      status: json['status'] ?? 'pending',
      scorecard: Map<String, dynamic>.from(json['scorecard'] ?? {}),
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      tossWinner: json['tossWinner'] ?? '',
      tossDecision: json['tossDecision'] ?? '',
      battingFirstTeam: json['battingFirstTeam'] ?? '',
      bowlingFirstTeam: json['bowlingFirstTeam'] ?? '',
      currentInnings: json['currentInnings']?.toInt() ?? 1,
      innings1Score: json['innings1Score']?.toInt() ?? 0,
      innings1Wickets: json['innings1Wickets']?.toInt() ?? 0,
      innings1Overs: json['innings1Overs']?.toInt() ?? 0,
      innings1Balls: json['innings1Balls']?.toInt() ?? 0,
      innings2Score: json['innings2Score']?.toInt() ?? 0,
      innings2Wickets: json['innings2Wickets']?.toInt() ?? 0,
      innings2Overs: json['innings2Overs']?.toInt() ?? 0,
      innings2Balls: json['innings2Balls']?.toInt() ?? 0,
      engineState: json['engineState'] != null ? Map<String, dynamic>.from(json['engineState']) : null,
      lastUpdatedAt: DateTime.tryParse(json['lastUpdatedAt'] ?? '') ?? DateTime.now(),
      currentBattingTeam: json['currentBattingTeam'] ?? '',
      currentBowlingTeam: json['currentBowlingTeam'] ?? '',
      matchResult: json['matchResult'] ?? '',
      ballEvents: List<Map<String, dynamic>>.from(
        (json['ballEvents'] ?? []).map((e) => Map<String, dynamic>.from(e)),
      ),
      inningsArray: List<Map<String, dynamic>>.from(
        (json['inningsArray'] ?? []).map((e) => Map<String, dynamic>.from(e)),
      ),
    );
  }
}
