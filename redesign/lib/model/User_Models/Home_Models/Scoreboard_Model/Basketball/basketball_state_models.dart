class BasketballPlayer {
  final String id;
  final String name;
  final bool isCaptain;
  final bool isOnCourt;
  final int pointsScored;
  final int twoPointersMade;
  final int threePointersMade;
  final int freeThrowsMade;
  final int personalFouls;
  final bool isFouledOut;

  const BasketballPlayer({
    required this.id,
    required this.name,
    this.isCaptain = false,
    this.isOnCourt = true,
    this.pointsScored = 0,
    this.twoPointersMade = 0,
    this.threePointersMade = 0,
    this.freeThrowsMade = 0,
    this.personalFouls = 0,
    this.isFouledOut = false,
  });

  BasketballPlayer copyWith({
    String? id,
    String? name,
    bool? isCaptain,
    bool? isOnCourt,
    int? pointsScored,
    int? twoPointersMade,
    int? threePointersMade,
    int? freeThrowsMade,
    int? personalFouls,
    bool? isFouledOut,
  }) {
    return BasketballPlayer(
      id: id ?? this.id,
      name: name ?? this.name,
      isCaptain: isCaptain ?? this.isCaptain,
      isOnCourt: isOnCourt ?? this.isOnCourt,
      pointsScored: pointsScored ?? this.pointsScored,
      twoPointersMade: twoPointersMade ?? this.twoPointersMade,
      threePointersMade: threePointersMade ?? this.threePointersMade,
      freeThrowsMade: freeThrowsMade ?? this.freeThrowsMade,
      personalFouls: personalFouls ?? this.personalFouls,
      isFouledOut: isFouledOut ?? this.isFouledOut,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'isCaptain': isCaptain,
        'isOnCourt': isOnCourt,
        'pointsScored': pointsScored,
        'twoPointersMade': twoPointersMade,
        'threePointersMade': threePointersMade,
        'freeThrowsMade': freeThrowsMade,
        'personalFouls': personalFouls,
        'isFouledOut': isFouledOut,
      };

  factory BasketballPlayer.fromJson(Map<String, dynamic> json) => BasketballPlayer(
        id: json['id'] as String? ?? 'p_${DateTime.now().millisecondsSinceEpoch}',
        name: json['name'] as String? ?? 'Player',
        isCaptain: json['isCaptain'] as bool? ?? false,
        isOnCourt: json['isOnCourt'] as bool? ?? true,
        pointsScored: json['pointsScored'] as int? ?? 0,
        twoPointersMade: json['twoPointersMade'] as int? ?? 0,
        threePointersMade: json['threePointersMade'] as int? ?? 0,
        freeThrowsMade: json['freeThrowsMade'] as int? ?? 0,
        personalFouls: json['personalFouls'] as int? ?? 0,
        isFouledOut: json['isFouledOut'] as bool? ?? false,
      );
}

class BasketballMatchConfig {
  final int quarterDurationMinutes;
  final bool isProRules;
  final bool enableShotClock;
  final int squadLimit;
  final bool subsEnabled;
  final int maxSubstitutes;
  final int teamFoulPenaltyThreshold;
  final int playerFoulOutLimit;
  final int timeoutsPerHalf;

  const BasketballMatchConfig({
    this.quarterDurationMinutes = 10,
    this.isProRules = true,
    this.enableShotClock = true,
    this.squadLimit = 5,
    this.subsEnabled = true,
    this.maxSubstitutes = 7,
    this.teamFoulPenaltyThreshold = 5,
    this.playerFoulOutLimit = 5,
    this.timeoutsPerHalf = 2,
  });

  bool get isFriendlyRules => !isProRules;

  Map<String, dynamic> toJson() => {
        'quarterDurationMinutes': quarterDurationMinutes,
        'isProRules': isProRules,
        'enableShotClock': enableShotClock,
        'squadLimit': squadLimit,
        'subsEnabled': subsEnabled,
        'maxSubstitutes': maxSubstitutes,
        'teamFoulPenaltyThreshold': teamFoulPenaltyThreshold,
        'playerFoulOutLimit': playerFoulOutLimit,
        'timeoutsPerHalf': timeoutsPerHalf,
      };

  factory BasketballMatchConfig.fromJson(Map<String, dynamic> json) => BasketballMatchConfig(
        quarterDurationMinutes: json['quarterDurationMinutes'] as int? ?? 10,
        isProRules: json['isProRules'] as bool? ?? true,
        enableShotClock: json['enableShotClock'] as bool? ?? true,
        squadLimit: json['squadLimit'] as int? ?? 5,
        subsEnabled: json['subsEnabled'] as bool? ?? true,
        maxSubstitutes: json['maxSubstitutes'] as int? ?? 7,
        teamFoulPenaltyThreshold: json['teamFoulPenaltyThreshold'] as int? ?? 5,
        playerFoulOutLimit: json['playerFoulOutLimit'] as int? ?? 5,
        timeoutsPerHalf: json['timeoutsPerHalf'] as int? ?? 2,
      );
}

class BasketballMatchState {
  final List<BasketballPlayer> teamA;
  final List<BasketballPlayer> teamB;
  final int sideAScore;
  final int sideBScore;
  final int teamFoulsA;
  final int teamFoulsB;
  final int timeoutsRemainingA;
  final int timeoutsRemainingB;
  final int currentQuarter; // 1, 2, 3, 4, 5 (OT1), 6 (OT2)...
  final String possessionTeam; // Alternating possession arrow: 'sideA' or 'sideB'
  final BasketballMatchConfig config;
  final bool isQuarterCompleted;
  final bool isMatchFinished;
  final String? matchWinner;

  bool get isBonusPenaltyA => teamFoulsA >= config.teamFoulPenaltyThreshold;
  bool get isBonusPenaltyB => teamFoulsB >= config.teamFoulPenaltyThreshold;

  String get quarterDisplay {
    if (currentQuarter <= 4) return 'Q$currentQuarter';
    return 'OT${currentQuarter - 4}';
  }

  const BasketballMatchState({
    required this.teamA,
    required this.teamB,
    required this.sideAScore,
    required this.sideBScore,
    required this.teamFoulsA,
    required this.teamFoulsB,
    required this.timeoutsRemainingA,
    required this.timeoutsRemainingB,
    required this.currentQuarter,
    required this.possessionTeam,
    required this.config,
    this.isQuarterCompleted = false,
    this.isMatchFinished = false,
    this.matchWinner,
  });

  factory BasketballMatchState.initial({
    required List<BasketballPlayer> teamA,
    required List<BasketballPlayer> teamB,
    required BasketballMatchConfig config,
    required String initialPossession,
  }) {
    return BasketballMatchState(
      teamA: teamA,
      teamB: teamB,
      sideAScore: 0,
      sideBScore: 0,
      teamFoulsA: 0,
      teamFoulsB: 0,
      timeoutsRemainingA: config.timeoutsPerHalf,
      timeoutsRemainingB: config.timeoutsPerHalf,
      currentQuarter: 1,
      possessionTeam: initialPossession,
      config: config,
      isQuarterCompleted: false,
      isMatchFinished: false,
      matchWinner: null,
    );
  }

  BasketballMatchState copyWith({
    List<BasketballPlayer>? teamA,
    List<BasketballPlayer>? teamB,
    int? sideAScore,
    int? sideBScore,
    int? teamFoulsA,
    int? teamFoulsB,
    int? timeoutsRemainingA,
    int? timeoutsRemainingB,
    int? currentQuarter,
    String? possessionTeam,
    BasketballMatchConfig? config,
    bool? isQuarterCompleted,
    bool? isMatchFinished,
    String? matchWinner,
  }) {
    return BasketballMatchState(
      teamA: teamA ?? this.teamA,
      teamB: teamB ?? this.teamB,
      sideAScore: sideAScore ?? this.sideAScore,
      sideBScore: sideBScore ?? this.sideBScore,
      teamFoulsA: teamFoulsA ?? this.teamFoulsA,
      teamFoulsB: teamFoulsB ?? this.teamFoulsB,
      timeoutsRemainingA: timeoutsRemainingA ?? this.timeoutsRemainingA,
      timeoutsRemainingB: timeoutsRemainingB ?? this.timeoutsRemainingB,
      currentQuarter: currentQuarter ?? this.currentQuarter,
      possessionTeam: possessionTeam ?? this.possessionTeam,
      config: config ?? this.config,
      isQuarterCompleted: isQuarterCompleted ?? this.isQuarterCompleted,
      isMatchFinished: isMatchFinished ?? this.isMatchFinished,
      matchWinner: matchWinner ?? this.matchWinner,
    );
  }

  Map<String, dynamic> toJson() => {
        'teamA': teamA.map((p) => p.toJson()).toList(),
        'teamB': teamB.map((p) => p.toJson()).toList(),
        'sideAScore': sideAScore,
        'sideBScore': sideBScore,
        'teamFoulsA': teamFoulsA,
        'teamFoulsB': teamFoulsB,
        'timeoutsRemainingA': timeoutsRemainingA,
        'timeoutsRemainingB': timeoutsRemainingB,
        'currentQuarter': currentQuarter,
        'possessionTeam': possessionTeam,
        'config': config.toJson(),
        'isQuarterCompleted': isQuarterCompleted,
        'isMatchFinished': isMatchFinished,
        'matchWinner': matchWinner,
      };

  factory BasketballMatchState.fromJson(Map<String, dynamic> json) => BasketballMatchState(
        teamA: (json['teamA'] as List? ?? [])
            .map((p) => BasketballPlayer.fromJson(p as Map<String, dynamic>))
            .toList(),
        teamB: (json['teamB'] as List? ?? [])
            .map((p) => BasketballPlayer.fromJson(p as Map<String, dynamic>))
            .toList(),
        sideAScore: json['sideAScore'] as int? ?? 0,
        sideBScore: json['sideBScore'] as int? ?? 0,
        teamFoulsA: json['teamFoulsA'] as int? ?? 0,
        teamFoulsB: json['teamFoulsB'] as int? ?? 0,
        timeoutsRemainingA: json['timeoutsRemainingA'] as int? ?? 2,
        timeoutsRemainingB: json['timeoutsRemainingB'] as int? ?? 2,
        currentQuarter: json['currentQuarter'] as int? ?? 1,
        possessionTeam: json['possessionTeam'] as String? ?? 'sideA',
        config: json['config'] != null
            ? BasketballMatchConfig.fromJson(json['config'] as Map<String, dynamic>)
            : const BasketballMatchConfig(),
        isQuarterCompleted: json['isQuarterCompleted'] as bool? ?? false,
        isMatchFinished: json['isMatchFinished'] as bool? ?? false,
        matchWinner: json['matchWinner'] as String?,
      );
}

class BasketballMatchEngine {
  BasketballMatchState _state;
  final List<BasketballMatchState> _history = [];

  BasketballMatchEngine(this._state) {
    _history.add(_state);
  }

  BasketballMatchState get state => _state;
  bool get canUndo => _history.length > 1;

  void _pushState(BasketballMatchState newState) {
    _state = newState;
    _history.add(_state);
  }

  void scorePoints(String team, int points, {String? scorerId}) {
    if (_state.isMatchFinished) return;

    final isTeamA = team == 'sideA';
    final newAScore = _state.sideAScore + (isTeamA ? points : 0);
    final newBScore = _state.sideBScore + (!isTeamA ? points : 0);

    final roster = isTeamA ? _state.teamA : _state.teamB;
    final updatedRoster = roster.map((p) {
      if (scorerId != null && p.id == scorerId) {
        return p.copyWith(
          pointsScored: p.pointsScored + points,
          freeThrowsMade: points == 1 ? p.freeThrowsMade + 1 : p.freeThrowsMade,
          twoPointersMade: points == 2 ? p.twoPointersMade + 1 : p.twoPointersMade,
          threePointersMade: points == 3 ? p.threePointersMade + 1 : p.threePointersMade,
        );
      }
      return p;
    }).toList();

    // Made baskets DO NOT toggle the alternating possession arrow!
    // The ball simply goes to the opposing team on the baseline.
    _pushState(_state.copyWith(
      sideAScore: newAScore,
      sideBScore: newBScore,
      teamA: isTeamA ? updatedRoster : _state.teamA,
      teamB: !isTeamA ? updatedRoster : _state.teamB,
    ));
  }

  void recordFoul(String team, {String? playerFouledId, bool isTechnical = false}) {
    if (_state.isMatchFinished) return;

    final isTeamA = team == 'sideA';
    final newTFoulsA = _state.teamFoulsA + (isTeamA ? 1 : 0);
    final newTFoulsB = _state.teamFoulsB + (!isTeamA ? 1 : 0);

    final roster = isTeamA ? _state.teamA : _state.teamB;
    final updatedRoster = roster.map((p) {
      if (playerFouledId != null && p.id == playerFouledId) {
        final newPF = p.personalFouls + 1;
        final fouledOut = newPF >= _state.config.playerFoulOutLimit;
        return p.copyWith(
          personalFouls: newPF,
          isFouledOut: fouledOut,
          isOnCourt: fouledOut ? false : p.isOnCourt,
        );
      }
      return p;
    }).toList();

    _pushState(_state.copyWith(
      teamFoulsA: newTFoulsA,
      teamFoulsB: newTFoulsB,
      teamA: isTeamA ? updatedRoster : _state.teamA,
      teamB: !isTeamA ? updatedRoster : _state.teamB,
    ));
  }

  void recordHeldBallJumpBall() {
    if (_state.isMatchFinished) return;

    // Flip the alternating possession arrow ONLY on held ball / jump ball situations
    final nextArrow = _state.possessionTeam == 'sideA' ? 'sideB' : 'sideA';
    _pushState(_state.copyWith(possessionTeam: nextArrow));
  }

  void togglePossessionArrow() {
    if (_state.isMatchFinished) return;
    final nextArrow = _state.possessionTeam == 'sideA' ? 'sideB' : 'sideA';
    _pushState(_state.copyWith(possessionTeam: nextArrow));
  }

  void useTimeout(String team) {
    if (_state.isMatchFinished) return;

    final isTeamA = team == 'sideA';
    final remA = isTeamA ? (_state.timeoutsRemainingA - 1).clamp(0, 5) : _state.timeoutsRemainingA;
    final remB = !isTeamA ? (_state.timeoutsRemainingB - 1).clamp(0, 5) : _state.timeoutsRemainingB;

    _pushState(_state.copyWith(
      timeoutsRemainingA: remA,
      timeoutsRemainingB: remB,
    ));
  }

  void advanceQuarter() {
    final nextQ = _state.currentQuarter + 1;

    // Restock timeouts at half time (Q3 start)
    int remA = _state.timeoutsRemainingA;
    int remB = _state.timeoutsRemainingB;
    if (nextQ == 3) {
      remA = 3;
      remB = 3;
    } else if (nextQ > 4) {
      // Overtime gives 1 timeout
      remA = 1;
      remB = 1;
    }

    _pushState(_state.copyWith(
      currentQuarter: nextQ,
      teamFoulsA: 0, // Reset team fouls per quarter
      teamFoulsB: 0,
      timeoutsRemainingA: remA,
      timeoutsRemainingB: remB,
      isQuarterCompleted: false,
    ));
  }

  void endMatch() {
    String? winner;
    if (_state.sideAScore > _state.sideBScore) {
      winner = 'sideA';
    } else if (_state.sideBScore > _state.sideAScore) {
      winner = 'sideB';
    }

    _pushState(_state.copyWith(
      isMatchFinished: true,
      matchWinner: winner,
    ));
  }

  void undo() {
    if (!canUndo) return;
    _history.removeLast();
    _state = _history.last;
  }
}
