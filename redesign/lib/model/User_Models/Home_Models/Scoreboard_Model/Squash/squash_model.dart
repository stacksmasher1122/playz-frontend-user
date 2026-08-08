class SquashMatchModel {
  final String matchId;
  final String createdBy;
  final String sport;
  final List<String> allPlayers;
  final List<String> teamAPlayers;
  final List<String> teamBPlayers;
  final int maxAllowedPlayers;
  final bool isFriendlyRules;
  final String scoringSystem; // 'pars' or 'hiho'
  final int pointsToWin;
  final int gamesToWin;
  final bool winByTwo;
  final String status; // 'In Progress', 'completed', etc.
  final DateTime createdAt;
  final Map<String, dynamic>? engineState;
  final DateTime? lastUpdatedAt;
  final String matchResult;
  final List<Map<String, dynamic>> pointLog;
  final String? tournamentId;
  final String? bracketMatchId;
  final String? bookingId;
  final String matchType; // 'NORMAL' or 'SLOT_DEDICATED'
  final bool isRecoverable;

  SquashMatchModel({
    required this.matchId,
    required this.createdBy,
    this.sport = 'squash',
    required this.allPlayers,
    required this.teamAPlayers,
    required this.teamBPlayers,
    this.maxAllowedPlayers = 1,
    this.isFriendlyRules = false,
    this.scoringSystem = 'pars',
    this.pointsToWin = 11,
    this.gamesToWin = 2,
    this.winByTwo = true,
    required this.status,
    required this.createdAt,
    this.engineState,
    this.lastUpdatedAt,
    this.matchResult = '',
    this.pointLog = const [],
    this.tournamentId,
    this.bracketMatchId,
    this.bookingId,
    this.matchType = 'NORMAL',
    this.isRecoverable = true,
  });

  Map<String, dynamic> toJson() => {
        'matchId': matchId,
        'createdBy': createdBy,
        'sport': sport,
        'allPlayers': allPlayers,
        'teamAPlayers': teamAPlayers,
        'teamBPlayers': teamBPlayers,
        'maxAllowedPlayers': maxAllowedPlayers,
        'isFriendlyRules': isFriendlyRules,
        'scoringSystem': scoringSystem,
        'pointsToWin': pointsToWin,
        'gamesToWin': gamesToWin,
        'winByTwo': winByTwo,
        'status': status,
        'createdAt': createdAt.toIso8601String(),
        'engineState': engineState,
        'lastUpdatedAt': (lastUpdatedAt ?? DateTime.now()).toIso8601String(),
        'matchResult': matchResult,
        'pointLog': pointLog,
        'tournamentId': tournamentId,
        'bracketMatchId': bracketMatchId,
        'bookingId': bookingId,
        'matchType': matchType,
        'isRecoverable': isRecoverable,
      };

  factory SquashMatchModel.fromJson(Map<String, dynamic> json) {
    return SquashMatchModel(
      matchId: json['matchId'] as String? ?? '',
      createdBy: json['createdBy'] as String? ?? '',
      sport: json['sport'] as String? ?? 'squash',
      allPlayers: List<String>.from(json['allPlayers'] as List? ?? []),
      teamAPlayers: List<String>.from(json['teamAPlayers'] as List? ?? []),
      teamBPlayers: List<String>.from(json['teamBPlayers'] as List? ?? []),
      maxAllowedPlayers: json['maxAllowedPlayers'] as int? ?? 1,
      isFriendlyRules: json['isFriendlyRules'] as bool? ?? false,
      scoringSystem: json['scoringSystem'] as String? ?? 'pars',
      pointsToWin: json['pointsToWin'] as int? ?? 11,
      gamesToWin: json['gamesToWin'] as int? ?? 2,
      winByTwo: json['winByTwo'] as bool? ?? true,
      status: json['status'] as String? ?? 'In Progress',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      engineState: json['engineState'] as Map<String, dynamic>?,
      lastUpdatedAt: json['lastUpdatedAt'] != null
          ? DateTime.parse(json['lastUpdatedAt'] as String)
          : null,
      matchResult: json['matchResult'] as String? ?? '',
      pointLog: (json['pointLog'] as List? ?? [])
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList(),
      tournamentId: json['tournamentId'] as String?,
      bracketMatchId: json['bracketMatchId'] as String?,
      bookingId: json['bookingId'] as String?,
      matchType: json['matchType'] as String? ?? 'NORMAL',
      isRecoverable: json['isRecoverable'] as bool? ?? true,
    );
  }
}
