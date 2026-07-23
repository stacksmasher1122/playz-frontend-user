enum MatchPhase { setup, tipOff, live, quarterBreak, halfTime, overtime, completed }
enum MatchMode { friendly, professional }
enum FoulType { personal, technical, flagrant }
enum EventType { fieldGoalMade, fieldGoalMissed, freeThrowMade, freeThrowMissed, foul, timeout, substitution, quarterEnd, jumpBall }

class BasketballMatchConfig {
  final int quarterLengthMinutes;
  final int shotClockSeconds;
  final int foulOutLimit;
  final bool technicalFoulsEnabled;
  final int timeoutsPerTeam;
  final MatchMode mode;
  final int overtimeLengthMinutes;
  final int bonusFoulLimit;

  const BasketballMatchConfig({
    this.quarterLengthMinutes = 10,
    this.shotClockSeconds = 24,
    this.foulOutLimit = 5,
    this.technicalFoulsEnabled = false,
    this.timeoutsPerTeam = 5,
    this.mode = MatchMode.friendly,
    this.overtimeLengthMinutes = 5,
    this.bonusFoulLimit = 5,
  });

  Map<String, dynamic> toJson() => {
        'quarterLengthMinutes': quarterLengthMinutes,
        'shotClockSeconds': shotClockSeconds,
        'foulOutLimit': foulOutLimit,
        'technicalFoulsEnabled': technicalFoulsEnabled,
        'timeoutsPerTeam': timeoutsPerTeam,
        'mode': mode.name,
        'overtimeLengthMinutes': overtimeLengthMinutes,
        'bonusFoulLimit': bonusFoulLimit,
      };

  factory BasketballMatchConfig.fromJson(Map<String, dynamic> json) =>
      BasketballMatchConfig(
        quarterLengthMinutes: json['quarterLengthMinutes'] ?? 10,
        shotClockSeconds: json['shotClockSeconds'] ?? 24,
        foulOutLimit: json['foulOutLimit'] ?? 5,
        technicalFoulsEnabled: json['technicalFoulsEnabled'] ?? false,
        timeoutsPerTeam: json['timeoutsPerTeam'] ?? 5,
        mode: MatchMode.values.firstWhere((e) => e.name == json['mode'], orElse: () => MatchMode.friendly),
        overtimeLengthMinutes: json['overtimeLengthMinutes'] ?? 5,
        bonusFoulLimit: json['bonusFoulLimit'] ?? 5,
      );

  BasketballMatchConfig copyWith({
    int? quarterLengthMinutes,
    int? shotClockSeconds,
    int? foulOutLimit,
    bool? technicalFoulsEnabled,
    int? timeoutsPerTeam,
    MatchMode? mode,
    int? overtimeLengthMinutes,
    int? bonusFoulLimit,
  }) {
    return BasketballMatchConfig(
      quarterLengthMinutes: quarterLengthMinutes ?? this.quarterLengthMinutes,
      shotClockSeconds: shotClockSeconds ?? this.shotClockSeconds,
      foulOutLimit: foulOutLimit ?? this.foulOutLimit,
      technicalFoulsEnabled: technicalFoulsEnabled ?? this.technicalFoulsEnabled,
      timeoutsPerTeam: timeoutsPerTeam ?? this.timeoutsPerTeam,
      mode: mode ?? this.mode,
      overtimeLengthMinutes: overtimeLengthMinutes ?? this.overtimeLengthMinutes,
      bonusFoulLimit: bonusFoulLimit ?? this.bonusFoulLimit,
    );
  }
}

class BasketballPlayer {
  final String id;
  final String name;
  final int points;
  final int twoPointersMade;
  final int threePointersMade;
  final int freeThrowsMade;
  final int fouls;
  final int technicalFouls;
  final bool isFouledOut;
  final bool isEjected;

  const BasketballPlayer({
    required this.id,
    required this.name,
    this.points = 0,
    this.twoPointersMade = 0,
    this.threePointersMade = 0,
    this.freeThrowsMade = 0,
    this.fouls = 0,
    this.technicalFouls = 0,
    this.isFouledOut = false,
    this.isEjected = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'points': points,
        'twoPointersMade': twoPointersMade,
        'threePointersMade': threePointersMade,
        'freeThrowsMade': freeThrowsMade,
        'fouls': fouls,
        'technicalFouls': technicalFouls,
        'isFouledOut': isFouledOut,
        'isEjected': isEjected,
      };

  factory BasketballPlayer.fromJson(Map<String, dynamic> json) =>
      BasketballPlayer(
        id: json['id'] as String,
        name: json['name'] as String,
        points: json['points'] ?? 0,
        twoPointersMade: json['twoPointersMade'] ?? 0,
        threePointersMade: json['threePointersMade'] ?? 0,
        freeThrowsMade: json['freeThrowsMade'] ?? 0,
        fouls: json['fouls'] ?? 0,
        technicalFouls: json['technicalFouls'] ?? 0,
        isFouledOut: json['isFouledOut'] ?? false,
        isEjected: json['isEjected'] ?? false,
      );

  BasketballPlayer copyWith({
    String? id,
    String? name,
    int? points,
    int? twoPointersMade,
    int? threePointersMade,
    int? freeThrowsMade,
    int? fouls,
    int? technicalFouls,
    bool? isFouledOut,
    bool? isEjected,
  }) {
    return BasketballPlayer(
      id: id ?? this.id,
      name: name ?? this.name,
      points: points ?? this.points,
      twoPointersMade: twoPointersMade ?? this.twoPointersMade,
      threePointersMade: threePointersMade ?? this.threePointersMade,
      freeThrowsMade: freeThrowsMade ?? this.freeThrowsMade,
      fouls: fouls ?? this.fouls,
      technicalFouls: technicalFouls ?? this.technicalFouls,
      isFouledOut: isFouledOut ?? this.isFouledOut,
      isEjected: isEjected ?? this.isEjected,
    );
  }
}

class BasketballTeamState {
  final String teamName;
  final int score;
  final int timeoutsRemaining;
  final int teamFoulsInQuarter;
  final bool isInBonus;
  final List<BasketballPlayer> roster;
  final List<String> onCourtIds;

  const BasketballTeamState({
    required this.teamName,
    this.score = 0,
    required this.timeoutsRemaining,
    this.teamFoulsInQuarter = 0,
    this.isInBonus = false,
    this.roster = const [],
    this.onCourtIds = const [],
  });

  Map<String, dynamic> toJson() => {
        'teamName': teamName,
        'score': score,
        'timeoutsRemaining': timeoutsRemaining,
        'teamFoulsInQuarter': teamFoulsInQuarter,
        'isInBonus': isInBonus,
        'roster': roster.map((p) => p.toJson()).toList(),
        'onCourtIds': onCourtIds,
      };

  factory BasketballTeamState.fromJson(Map<String, dynamic> json) =>
      BasketballTeamState(
        teamName: json['teamName'] as String,
        score: json['score'] ?? 0,
        timeoutsRemaining: json['timeoutsRemaining'] ?? 0,
        teamFoulsInQuarter: json['teamFoulsInQuarter'] ?? 0,
        isInBonus: json['isInBonus'] ?? false,
        roster: (json['roster'] as List<dynamic>?)
                ?.map((e) => BasketballPlayer.fromJson(e as Map<String, dynamic>))
                .toList() ?? [],
        onCourtIds: (json['onCourtIds'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      );

  BasketballTeamState copyWith({
    String? teamName,
    int? score,
    int? timeoutsRemaining,
    int? teamFoulsInQuarter,
    bool? isInBonus,
    List<BasketballPlayer>? roster,
    List<String>? onCourtIds,
  }) {
    return BasketballTeamState(
      teamName: teamName ?? this.teamName,
      score: score ?? this.score,
      timeoutsRemaining: timeoutsRemaining ?? this.timeoutsRemaining,
      teamFoulsInQuarter: teamFoulsInQuarter ?? this.teamFoulsInQuarter,
      isInBonus: isInBonus ?? this.isInBonus,
      roster: roster ?? this.roster,
      onCourtIds: onCourtIds ?? this.onCourtIds,
    );
  }
}

class BasketballMatchState {
  final BasketballMatchConfig config;
  final BasketballTeamState homeTeam;
  final BasketballTeamState awayTeam;
  final int currentQuarter;
  final int gameClockSeconds;
  final int shotClockSeconds;
  final bool isClockRunning;
  final String? possessionTeamId;
  final String? possessionArrowTeamId;
  final MatchPhase phase;
  final String? matchResult;
  final Map<int, Map<String, int>> quarterScores;

  const BasketballMatchState({
    required this.config,
    required this.homeTeam,
    required this.awayTeam,
    this.currentQuarter = 1,
    required this.gameClockSeconds,
    required this.shotClockSeconds,
    this.isClockRunning = false,
    this.possessionTeamId,
    this.possessionArrowTeamId,
    this.phase = MatchPhase.setup,
    this.matchResult,
    this.quarterScores = const {},
  });

  Map<String, dynamic> toJson() => {
        'config': config.toJson(),
        'homeTeam': homeTeam.toJson(),
        'awayTeam': awayTeam.toJson(),
        'currentQuarter': currentQuarter,
        'gameClockSeconds': gameClockSeconds,
        'shotClockSeconds': shotClockSeconds,
        'isClockRunning': isClockRunning,
        'possessionTeamId': possessionTeamId,
        'possessionArrowTeamId': possessionArrowTeamId,
        'phase': phase.name,
        'matchResult': matchResult,
        'quarterScores': quarterScores.map((k, v) => MapEntry(k.toString(), v)),
      };

  factory BasketballMatchState.fromJson(Map<String, dynamic> json) =>
      BasketballMatchState(
        config: BasketballMatchConfig.fromJson(json['config'] as Map<String, dynamic>),
        homeTeam: BasketballTeamState.fromJson(json['homeTeam'] as Map<String, dynamic>),
        awayTeam: BasketballTeamState.fromJson(json['awayTeam'] as Map<String, dynamic>),
        currentQuarter: json['currentQuarter'] ?? 1,
        gameClockSeconds: json['gameClockSeconds'] ?? 0,
        shotClockSeconds: json['shotClockSeconds'] ?? 0,
        isClockRunning: json['isClockRunning'] ?? false,
        possessionTeamId: json['possessionTeamId'],
        possessionArrowTeamId: json['possessionArrowTeamId'],
        phase: MatchPhase.values.firstWhere((e) => e.name == json['phase'], orElse: () => MatchPhase.setup),
        matchResult: json['matchResult'],
        quarterScores: (json['quarterScores'] as Map<String, dynamic>?)
                ?.map((k, v) => MapEntry(int.parse(k), Map<String, int>.from(v as Map))) ?? {},
      );

  BasketballMatchState copyWith({
    BasketballMatchConfig? config,
    BasketballTeamState? homeTeam,
    BasketballTeamState? awayTeam,
    int? currentQuarter,
    int? gameClockSeconds,
    int? shotClockSeconds,
    bool? isClockRunning,
    String? possessionTeamId,
    String? possessionArrowTeamId,
    MatchPhase? phase,
    String? matchResult,
    Map<int, Map<String, int>>? quarterScores,
  }) {
    return BasketballMatchState(
      config: config ?? this.config,
      homeTeam: homeTeam ?? this.homeTeam,
      awayTeam: awayTeam ?? this.awayTeam,
      currentQuarter: currentQuarter ?? this.currentQuarter,
      gameClockSeconds: gameClockSeconds ?? this.gameClockSeconds,
      shotClockSeconds: shotClockSeconds ?? this.shotClockSeconds,
      isClockRunning: isClockRunning ?? this.isClockRunning,
      possessionTeamId: possessionTeamId ?? this.possessionTeamId,
      possessionArrowTeamId: possessionArrowTeamId ?? this.possessionArrowTeamId,
      phase: phase ?? this.phase,
      matchResult: matchResult ?? this.matchResult,
      quarterScores: quarterScores ?? this.quarterScores,
    );
  }
}

class BasketballEvent {
  final String id;
  final EventType type;
  final String? teamId;
  final String? playerId;
  final int quarter;
  final int gameClockRemaining;
  final int? points;
  final FoulType? foulType;
  final DateTime timestamp;

  const BasketballEvent({
    required this.id,
    required this.type,
    this.teamId,
    this.playerId,
    required this.quarter,
    required this.gameClockRemaining,
    this.points,
    this.foulType,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'teamId': teamId,
        'playerId': playerId,
        'quarter': quarter,
        'gameClockRemaining': gameClockRemaining,
        'points': points,
        'foulType': foulType?.name,
        'timestamp': timestamp.toIso8601String(),
      };

  factory BasketballEvent.fromJson(Map<String, dynamic> json) => BasketballEvent(
        id: json['id'] as String,
        type: EventType.values.firstWhere((e) => e.name == json['type'], orElse: () => EventType.fieldGoalMade),
        teamId: json['teamId'],
        playerId: json['playerId'],
        quarter: json['quarter'] ?? 1,
        gameClockRemaining: json['gameClockRemaining'] ?? 0,
        points: json['points'],
        foulType: json['foulType'] != null ? FoulType.values.firstWhere((e) => e.name == json['foulType'], orElse: () => FoulType.personal) : null,
        timestamp: DateTime.parse(json['timestamp'] as String),
      );
}
