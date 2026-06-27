import 'package:flutter/material.dart';

const kDarkGreen = Color(0xFF0D7E3C);

/* ═══════════════════ ENUMS ═══════════════════ */

enum DismissalType {
  bowled,
  caught,
  lbw,
  runOut,
  stumped,
  hitWicket,
  retiredHurt,
  retiredOut,
  obstructingField,
  hitBallTwice,
  handledBall,
  timedOut,
}

enum PlayerStatus {
  batter,
  out,
  retiredHurt,
  retiredOut,
  absentHurt,
  timedOut,
}

enum ExtraType { wide, noBall, bye, legBye, penalty }

/* ═══════════════════ DATA MODELS ═══════════════════ */

class MatchConfig {
  final int maxOvers;
  final int maxOversPerBowler;
  final bool isFormalRules;
  final String format; // T20, ODI, Test

  const MatchConfig({
    this.maxOvers = 20,
    this.maxOversPerBowler = 4,
    this.isFormalRules = true,
    this.format = 'T20',
  });

  Map<String, dynamic> toJson() => {
        'maxOvers': maxOvers,
        'maxOversPerBowler': maxOversPerBowler,
        'isFormalRules': isFormalRules,
        'format': format,
      };

  MatchConfig copyWith({
    int? maxOvers,
    int? maxOversPerBowler,
    bool? isFormalRules,
    String? format,
  }) {
    return MatchConfig(
      maxOvers: maxOvers ?? this.maxOvers,
      maxOversPerBowler: maxOversPerBowler ?? this.maxOversPerBowler,
      isFormalRules: isFormalRules ?? this.isFormalRules,
      format: format ?? this.format,
    );
  }

  factory MatchConfig.fromJson(Map<String, dynamic> json) => MatchConfig(
        maxOvers: json['maxOvers'] ?? 20,
        maxOversPerBowler: json['maxOversPerBowler'] ?? 4,
        isFormalRules: json['isFormalRules'] ?? true,
        format: json['format'] ?? 'T20',
      );
}

// Fully immutable Player model
class Player {
  final String name;
  final int runs;
  final int ballsFaced;
  final int fours;
  final int sixes;
  final int ballsBowled;
  final int maidens;
  final int runsConceded;
  final int wicketsTaken;
  final int dotBalls;
  final int catches;
  final int stumpings;
  final int runOuts;
  final PlayerStatus status;
  // Extra flags to remember if player batted/bowled
  final bool hasBatted;
  final bool hasBowled;

  const Player({
    required this.name,
    this.runs = 0,
    this.ballsFaced = 0,
    this.fours = 0,
    this.sixes = 0,
    this.ballsBowled = 0,
    this.maidens = 0,
    this.runsConceded = 0,
    this.wicketsTaken = 0,
    this.dotBalls = 0,
    this.catches = 0,
    this.stumpings = 0,
    this.runOuts = 0,
    this.status = PlayerStatus.batter,
    this.hasBatted = false,
    this.hasBowled = false,
  });

  double get strikeRate => ballsFaced > 0 ? (runs / ballsFaced) * 100 : 0.0;
  double get economy {
    final double oversLocal = ballsBowled ~/ 6 + (ballsBowled % 6) / 6.0;
    return oversLocal > 0 ? runsConceded / oversLocal : 0.0;
  }
  
  bool get isOut => status != PlayerStatus.batter && status != PlayerStatus.retiredHurt;

  String get oversBowledDisplay => '${ballsBowled ~/ 6}.${ballsBowled % 6}';

  Player copyWith({
    String? name,
    int? runs,
    int? ballsFaced,
    int? fours,
    int? sixes,
    int? ballsBowled,
    int? maidens,
    int? runsConceded,
    int? wicketsTaken,
    int? dotBalls,
    int? catches,
    int? stumpings,
    int? runOuts,
    PlayerStatus? status,
    bool? hasBatted,
    bool? hasBowled,
  }) {
    return Player(
      name: name ?? this.name,
      runs: runs ?? this.runs,
      ballsFaced: ballsFaced ?? this.ballsFaced,
      fours: fours ?? this.fours,
      sixes: sixes ?? this.sixes,
      ballsBowled: ballsBowled ?? this.ballsBowled,
      maidens: maidens ?? this.maidens,
      runsConceded: runsConceded ?? this.runsConceded,
      wicketsTaken: wicketsTaken ?? this.wicketsTaken,
      dotBalls: dotBalls ?? this.dotBalls,
      catches: catches ?? this.catches,
      stumpings: stumpings ?? this.stumpings,
      runOuts: runOuts ?? this.runOuts,
      status: status ?? this.status,
      hasBatted: hasBatted ?? this.hasBatted,
      hasBowled: hasBowled ?? this.hasBowled,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'runs': runs,
        'ballsFaced': ballsFaced,
        'fours': fours,
        'sixes': sixes,
        'ballsBowled': ballsBowled,
        'maidens': maidens,
        'runsConceded': runsConceded,
        'wicketsTaken': wicketsTaken,
        'dotBalls': dotBalls,
        'catches': catches,
        'stumpings': stumpings,
        'runOuts': runOuts,
        'status': status.name,
        'hasBatted': hasBatted,
        'hasBowled': hasBowled,
      };

  factory Player.fromJson(Map<String, dynamic> json) => Player(
        name: json['name'] ?? '',
        runs: json['runs'] ?? 0,
        ballsFaced: json['ballsFaced'] ?? 0,
        fours: json['fours'] ?? 0,
        sixes: json['sixes'] ?? 0,
        ballsBowled: json['ballsBowled'] ?? 0,
        maidens: json['maidens'] ?? 0,
        runsConceded: json['runsConceded'] ?? 0,
        wicketsTaken: json['wicketsTaken'] ?? 0,
        dotBalls: json['dotBalls'] ?? 0,
        catches: json['catches'] ?? 0,
        stumpings: json['stumpings'] ?? 0,
        runOuts: json['runOuts'] ?? 0,
        status: json['status'] != null ? PlayerStatus.values.firstWhere((e) => e.name == json['status'], orElse: () => PlayerStatus.batter) : (json['isOut'] == true ? PlayerStatus.out : PlayerStatus.batter),
        hasBatted: json['hasBatted'] ?? false,
        hasBowled: json['hasBowled'] ?? false,
      );
}

class WicketDetails {
  final DismissalType type;
  final String outPlayerName;
  final String? fielderName;

  const WicketDetails({
    required this.type,
    required this.outPlayerName,
    this.fielderName,
  });

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'outPlayerName': outPlayerName,
    'fielderName': fielderName,
  };

  factory WicketDetails.fromJson(Map<String, dynamic> json) => WicketDetails(
    type: DismissalType.values.firstWhere((e) => e.name == json['type']),
    outPlayerName: json['outPlayerName'],
    fielderName: json['fielderName'],
  );
}

class BallEvent {
  final String id; 
  final int runs;  // Runs scored by bat
  final ExtraType? extraType;
  final int extraRuns;
  final DismissalType? dismissalType;
  final String? fielder;
  final String? batterOutName; // Specific batter out
  final String? nonStrikerName; // Reference to non-striker at the time
  final String? strikerName;    // Reference to striker at the time
  final String? bowlerName;     // Reference to bowler
  final String? newBatter;
  final int overNumber;
  final int ballNumber;
  final bool isLegalDelivery;
  final String commentary;

  const BallEvent({
    required this.id,
    required this.runs,
    this.extraType,
    this.extraRuns = 0,
    this.dismissalType,
    this.fielder,
    this.batterOutName,
    this.nonStrikerName,
    this.strikerName,
    this.bowlerName,
    this.newBatter,
    required this.overNumber,
    required this.ballNumber,
    this.isLegalDelivery = true,
    this.commentary = '',
  });

  BallEvent copyWith({
    String? id,
    int? runs,
    ExtraType? extraType,
    int? extraRuns,
    DismissalType? dismissalType,
    String? fielder,
    String? batterOutName,
    String? nonStrikerName,
    String? strikerName,
    String? bowlerName,
    String? newBatter,
    int? overNumber,
    int? ballNumber,
    bool? isLegalDelivery,
    String? commentary,
  }) {
    return BallEvent(
      id: id ?? this.id,
      runs: runs ?? this.runs,
      extraType: extraType ?? this.extraType,
      extraRuns: extraRuns ?? this.extraRuns,
      dismissalType: dismissalType ?? this.dismissalType,
      fielder: fielder ?? this.fielder,
      batterOutName: batterOutName ?? this.batterOutName,
      nonStrikerName: nonStrikerName ?? this.nonStrikerName,
      strikerName: strikerName ?? this.strikerName,
      bowlerName: bowlerName ?? this.bowlerName,
      newBatter: newBatter ?? this.newBatter,
      overNumber: overNumber ?? this.overNumber,
      ballNumber: ballNumber ?? this.ballNumber,
      isLegalDelivery: isLegalDelivery ?? this.isLegalDelivery,
      commentary: commentary ?? this.commentary,
    );
  }

  int get totalRuns => runs + extraRuns;
  bool get isWicket => dismissalType != null;
  bool get isBoundary => runs == 4 || runs == 6;
  bool get isExtra => extraType != null;

  String get displayText {
    if (isWicket) return 'W';
    if (extraType == ExtraType.wide) return '${totalRuns}WD';
    if (extraType == ExtraType.noBall) return '${totalRuns}NB';
    if (extraType == ExtraType.bye) return '${extraRuns}B';
    if (extraType == ExtraType.legBye) return '${extraRuns}LB';
    if (extraType == ExtraType.penalty) return '${extraRuns}P';
    return '$totalRuns';
  }

  Color get displayColor {
    if (isWicket) return const Color(0xFFE53935); // Red
    if (isBoundary) return const Color(0xFF0D7E3C); // Dark Green
    if (isExtra) return const Color(0xFFFFC107); // Amber
    if (runs == 0 && extraRuns == 0) return const Color(0xFF9E9E9E); // Muted
    return const Color(0xFF1DB954); // Green
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'runs': runs,
        'extraType': extraType?.name,
        'extraRuns': extraRuns,
        'dismissalType': dismissalType?.name,
        'fielder': fielder,
        'batterOutName': batterOutName,
        'nonStrikerName': nonStrikerName,
        'strikerName': strikerName,
        'bowlerName': bowlerName,
        'newBatter': newBatter,
        'overNumber': overNumber,
        'ballNumber': ballNumber,
        'isLegalDelivery': isLegalDelivery,
        'commentary': commentary,
      };

  factory BallEvent.fromJson(Map<String, dynamic> json) => BallEvent(
        id: json['id'] ?? '',
        runs: json['runs'] ?? 0,
        extraType: json['extraType'] != null ? ExtraType.values.firstWhere((e) => e.name == json['extraType']) : null,
        extraRuns: json['extraRuns'] ?? 0,
        dismissalType: json['dismissalType'] != null ? DismissalType.values.firstWhere((e) => e.name == json['dismissalType']) : null,
        fielder: json['fielder'],
        batterOutName: json['batterOutName'],
        nonStrikerName: json['nonStrikerName'],
        strikerName: json['strikerName'],
        bowlerName: json['bowlerName'],
        newBatter: json['newBatter'],
        overNumber: json['overNumber'] ?? 0,
        ballNumber: json['ballNumber'] ?? 0,
        isLegalDelivery: json['isLegalDelivery'] ?? true,
        commentary: json['commentary'] ?? '',
      );
}

class Partnership {
  final Player batsman1;
  final Player batsman2;
  final int runs;
  final int balls;

  const Partnership({
    required this.batsman1,
    required this.batsman2,
    this.runs = 0,
    this.balls = 0,
  });

  Partnership copyWith({
    Player? batsman1,
    Player? batsman2,
    int? runs,
    int? balls,
  }) {
    return Partnership(
      batsman1: batsman1 ?? this.batsman1,
      batsman2: batsman2 ?? this.batsman2,
      runs: runs ?? this.runs,
      balls: balls ?? this.balls,
    );
  }

  Map<String, dynamic> toJson() => {
        'batsman1': batsman1.toJson(),
        'batsman2': batsman2.toJson(),
        'runs': runs,
        'balls': balls,
      };

  factory Partnership.fromJson(Map<String, dynamic> json) => Partnership(
        batsman1: Player.fromJson(json['batsman1']),
        batsman2: Player.fromJson(json['batsman2']),
        runs: json['runs'] ?? 0,
        balls: json['balls'] ?? 0,
      );
}

// Fully immutable
class MatchState {
  final int totalRuns;
  final int wickets;
  final int overs;
  final int balls;
  final int inningsNumber;
  final int? targetScore;
  final String matchStatus;

  final List<Player> battingTeam;
  final List<Player> bowlingTeam;
  
  final Player? striker;
  final Player? nonStriker;
  final Player? currentBowler;

  final List<BallEvent> ballHistory;
  final List<BallEvent> currentOverBalls;

  final Partnership? partnership;
  final MatchConfig matchConfig;
  final bool isFreeHit;
  final String? matchResult;
  final String currentPhase;

  const MatchState({
    required this.totalRuns,
    required this.wickets,
    required this.overs,
    required this.balls,
    required this.inningsNumber,
    this.targetScore,
    required this.matchStatus,
    required this.battingTeam,
    required this.bowlingTeam,
    this.striker,
    this.nonStriker,
    this.currentBowler,
    required this.ballHistory,
    required this.currentOverBalls,
    this.partnership,
    this.matchConfig = const MatchConfig(),
    this.isFreeHit = false,
    this.matchResult,
    this.currentPhase = 'POWERPLAY',
  });

  MatchState copyWith({
    int? totalRuns,
    int? wickets,
    int? overs,
    int? balls,
    int? inningsNumber,
    int? targetScore,
    String? matchStatus,
    List<Player>? battingTeam,
    List<Player>? bowlingTeam,
    Player? striker,
    Player? nonStriker,
    Player? currentBowler,
    List<BallEvent>? ballHistory,
    List<BallEvent>? currentOverBalls,
    Partnership? partnership,
    MatchConfig? matchConfig,
    bool? isFreeHit,
    String? matchResult,
    String? currentPhase,
  }) {
    return MatchState(
      totalRuns: totalRuns ?? this.totalRuns,
      wickets: wickets ?? this.wickets,
      overs: overs ?? this.overs,
      balls: balls ?? this.balls,
      inningsNumber: inningsNumber ?? this.inningsNumber,
      targetScore: targetScore ?? this.targetScore,
      matchStatus: matchStatus ?? this.matchStatus,
      battingTeam: battingTeam ?? this.battingTeam,
      bowlingTeam: bowlingTeam ?? this.bowlingTeam,
      striker: striker ?? this.striker,
      nonStriker: nonStriker ?? this.nonStriker,
      currentBowler: currentBowler ?? this.currentBowler,
      ballHistory: ballHistory ?? this.ballHistory,
      currentOverBalls: currentOverBalls ?? this.currentOverBalls,
      partnership: partnership ?? this.partnership,
      matchConfig: matchConfig ?? this.matchConfig,
      isFreeHit: isFreeHit ?? this.isFreeHit,
      matchResult: matchResult ?? this.matchResult,
      currentPhase: currentPhase ?? this.currentPhase,
    );
  }

  Map<String, dynamic> toJson() => {
        'totalRuns': totalRuns,
        'wickets': wickets,
        'overs': overs,
        'balls': balls,
        'inningsNumber': inningsNumber,
        'targetScore': targetScore,
        'matchStatus': matchStatus,
        'battingTeam': battingTeam.map((e) => e.toJson()).toList(),
        'bowlingTeam': bowlingTeam.map((e) => e.toJson()).toList(),
        'striker': striker?.toJson(),
        'nonStriker': nonStriker?.toJson(),
        'currentBowler': currentBowler?.toJson(),
        'ballHistory': ballHistory.map((e) => e.toJson()).toList(),
        'currentOverBalls': currentOverBalls.map((e) => e.toJson()).toList(),
        'partnership': partnership?.toJson(),
        'matchConfig': matchConfig.toJson(),
        'isFreeHit': isFreeHit,
        'matchResult': matchResult,
        'currentPhase': currentPhase,
      };

  factory MatchState.fromJson(Map<String, dynamic> json) => MatchState(
        totalRuns: json['totalRuns'] ?? 0,
        wickets: json['wickets'] ?? 0,
        overs: json['overs'] ?? 0,
        balls: json['balls'] ?? 0,
        inningsNumber: json['inningsNumber'] ?? 1,
        targetScore: json['targetScore'],
        matchStatus: json['matchStatus'] ?? 'INITIALIZING',
        battingTeam: List<Player>.from((json['battingTeam'] ?? []).map((x) => Player.fromJson(x))),
        bowlingTeam: List<Player>.from((json['bowlingTeam'] ?? []).map((x) => Player.fromJson(x))),
        striker: json['striker'] != null ? Player.fromJson(json['striker']) : null,
        nonStriker: json['nonStriker'] != null ? Player.fromJson(json['nonStriker']) : null,
        currentBowler: json['currentBowler'] != null ? Player.fromJson(json['currentBowler']) : null,
        ballHistory: List<BallEvent>.from((json['ballHistory'] ?? []).map((x) => BallEvent.fromJson(x))),
        currentOverBalls: List<BallEvent>.from((json['currentOverBalls'] ?? []).map((x) => BallEvent.fromJson(x))),
        partnership: json['partnership'] != null ? Partnership.fromJson(json['partnership']) : null,
        matchConfig: json['matchConfig'] != null ? MatchConfig.fromJson(json['matchConfig']) : const MatchConfig(),
        isFreeHit: json['isFreeHit'] ?? false,
        matchResult: json['matchResult'],
        currentPhase: json['currentPhase'] ?? 'POWERPLAY',
      );
}

/* ═══════════════════ EVENT SOURCING COMMANDS ═══════════════════ */

/* ═══════════════════ EVENT SOURCING COMMANDS ═══════════════════ */

abstract class MatchEvent {}

class DeliveryEvent extends MatchEvent {
  final ExtraType? extra;
  final int runs;           // Off the bat
  final int overthrowRuns; 
  final bool crossedBeforeThrow;
  final bool isDeadBall;
  final List<WicketDetails> wickets; // Supports 2 wickets on 1 ball
  final String? newBatterName; // Name of new batter coming in (optional in the engine flow to handle sequentially)
  final bool newBatterOnStrike; 

  DeliveryEvent({
    this.extra,
    this.runs = 0,
    this.overthrowRuns = 0,
    this.crossedBeforeThrow = false,
    this.isDeadBall = false,
    this.wickets = const [],
    this.newBatterName,
    this.newBatterOnStrike = true,
  });
}
