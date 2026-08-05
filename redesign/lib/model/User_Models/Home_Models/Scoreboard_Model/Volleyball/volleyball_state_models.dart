import 'dart:convert';

class VolleyballPlayer {
  final String id;
  final String name;
  final bool isCaptain;
  final bool isOnCourt;
  final int pointsScored;
  final int servesMade;
  final int spikesMade;
  final int blocksMade;
  final int substitutionsCount;

  const VolleyballPlayer({
    required this.id,
    required this.name,
    this.isCaptain = false,
    this.isOnCourt = true,
    this.pointsScored = 0,
    this.servesMade = 0,
    this.spikesMade = 0,
    this.blocksMade = 0,
    this.substitutionsCount = 0,
  });

  VolleyballPlayer copyWith({
    String? id,
    String? name,
    bool? isCaptain,
    bool? isOnCourt,
    int? pointsScored,
    int? servesMade,
    int? spikesMade,
    int? blocksMade,
    int? substitutionsCount,
  }) {
    return VolleyballPlayer(
      id: id ?? this.id,
      name: name ?? this.name,
      isCaptain: isCaptain ?? this.isCaptain,
      isOnCourt: isOnCourt ?? this.isOnCourt,
      pointsScored: pointsScored ?? this.pointsScored,
      servesMade: servesMade ?? this.servesMade,
      spikesMade: spikesMade ?? this.spikesMade,
      blocksMade: blocksMade ?? this.blocksMade,
      substitutionsCount: substitutionsCount ?? this.substitutionsCount,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'isCaptain': isCaptain,
        'isOnCourt': isOnCourt,
        'pointsScored': pointsScored,
        'servesMade': servesMade,
        'spikesMade': spikesMade,
        'blocksMade': blocksMade,
        'substitutionsCount': substitutionsCount,
      };

  factory VolleyballPlayer.fromJson(Map<String, dynamic> json) => VolleyballPlayer(
        id: json['id'] as String? ?? 'p_${DateTime.now().millisecondsSinceEpoch}',
        name: json['name'] as String? ?? 'Player',
        isCaptain: json['isCaptain'] as bool? ?? false,
        isOnCourt: json['isOnCourt'] as bool? ?? true,
        pointsScored: json['pointsScored'] as int? ?? 0,
        servesMade: json['servesMade'] as int? ?? 0,
        spikesMade: json['spikesMade'] as int? ?? 0,
        blocksMade: json['blocksMade'] as int? ?? 0,
        substitutionsCount: json['substitutionsCount'] as int? ?? 0,
      );
}

class VolleyballSetResult {
  final int setNumber;
  final int sideAScore;
  final int sideBScore;
  final String winnerTeam; // 'sideA' or 'sideB'

  const VolleyballSetResult({
    required this.setNumber,
    required this.sideAScore,
    required this.sideBScore,
    required this.winnerTeam,
  });

  Map<String, dynamic> toJson() => {
        'setNumber': setNumber,
        'sideAScore': sideAScore,
        'sideBScore': sideBScore,
        'winnerTeam': winnerTeam,
      };

  factory VolleyballSetResult.fromJson(Map<String, dynamic> json) => VolleyballSetResult(
        setNumber: json['setNumber'] as int? ?? 1,
        sideAScore: json['sideAScore'] as int? ?? 0,
        sideBScore: json['sideBScore'] as int? ?? 0,
        winnerTeam: json['winnerTeam'] as String? ?? 'sideA',
      );
}

class VolleyballMatchConfig {
  final int maxSets; // Best of 1, 3, or 5
  final int setTargetPoints; // 15, 21, or 25
  final int finalSetTargetPoints; // 15 (5th set tie-breaker)
  final bool isProRules;
  final int squadLimit;
  final bool subsEnabled;
  final int maxSubstitutes;
  final bool winByTwoPoints;
  final int timeoutsPerSet;

  const VolleyballMatchConfig({
    this.maxSets = 5,
    this.setTargetPoints = 25,
    this.finalSetTargetPoints = 15,
    this.isProRules = true,
    this.squadLimit = 6,
    this.subsEnabled = true,
    this.maxSubstitutes = 6,
    this.winByTwoPoints = true,
    this.timeoutsPerSet = 2,
  });

  bool get isFriendlyRules => !isProRules;

  int get setsNeededToWin => (maxSets / 2).ceil();

  Map<String, dynamic> toJson() => {
        'maxSets': maxSets,
        'setTargetPoints': setTargetPoints,
        'finalSetTargetPoints': finalSetTargetPoints,
        'isProRules': isProRules,
        'squadLimit': squadLimit,
        'subsEnabled': subsEnabled,
        'maxSubstitutes': maxSubstitutes,
        'winByTwoPoints': winByTwoPoints,
        'timeoutsPerSet': timeoutsPerSet,
      };

  factory VolleyballMatchConfig.fromJson(Map<String, dynamic> json) => VolleyballMatchConfig(
        maxSets: json['maxSets'] as int? ?? 5,
        setTargetPoints: json['setTargetPoints'] as int? ?? 25,
        finalSetTargetPoints: json['finalSetTargetPoints'] as int? ?? 15,
        isProRules: json['isProRules'] as bool? ?? true,
        squadLimit: json['squadLimit'] as int? ?? 6,
        subsEnabled: json['subsEnabled'] as bool? ?? true,
        maxSubstitutes: json['maxSubstitutes'] as int? ?? 6,
        winByTwoPoints: json['winByTwoPoints'] as bool? ?? true,
        timeoutsPerSet: json['timeoutsPerSet'] as int? ?? 2,
      );
}

class VolleyballMatchState {
  final List<VolleyballPlayer> teamA;
  final List<VolleyballPlayer> teamB;
  final int setsWonA;
  final int setsWonB;
  final int currentSetPointsA;
  final int currentSetPointsB;
  final int currentSetNumber; // 1, 2, 3, 4, 5
  final String servingTeam; // 'sideA' or 'sideB'
  final List<VolleyballSetResult> setHistory;
  final int timeoutsRemainingA;
  final int timeoutsRemainingB;
  final VolleyballMatchConfig config;
  final bool isSetCompleted;
  final bool isMatchFinished;
  final String? matchWinner;

  int get currentTargetPoints {
    if (currentSetNumber == config.maxSets) {
      return config.finalSetTargetPoints;
    }
    return config.setTargetPoints;
  }

  const VolleyballMatchState({
    required this.teamA,
    required this.teamB,
    required this.setsWonA,
    required this.setsWonB,
    required this.currentSetPointsA,
    required this.currentSetPointsB,
    required this.currentSetNumber,
    required this.servingTeam,
    required this.setHistory,
    required this.timeoutsRemainingA,
    required this.timeoutsRemainingB,
    required this.config,
    this.isSetCompleted = false,
    this.isMatchFinished = false,
    this.matchWinner,
  });

  factory VolleyballMatchState.initial({
    required List<VolleyballPlayer> teamA,
    required List<VolleyballPlayer> teamB,
    required VolleyballMatchConfig config,
    required String initialServingTeam,
  }) {
    return VolleyballMatchState(
      teamA: teamA,
      teamB: teamB,
      setsWonA: 0,
      setsWonB: 0,
      currentSetPointsA: 0,
      currentSetPointsB: 0,
      currentSetNumber: 1,
      servingTeam: initialServingTeam,
      setHistory: const [],
      timeoutsRemainingA: config.timeoutsPerSet,
      timeoutsRemainingB: config.timeoutsPerSet,
      config: config,
      isSetCompleted: false,
      isMatchFinished: false,
      matchWinner: null,
    );
  }

  VolleyballMatchState copyWith({
    List<VolleyballPlayer>? teamA,
    List<VolleyballPlayer>? teamB,
    int? setsWonA,
    int? setsWonB,
    int? currentSetPointsA,
    int? currentSetPointsB,
    int? currentSetNumber,
    String? servingTeam,
    List<VolleyballSetResult>? setHistory,
    int? timeoutsRemainingA,
    int? timeoutsRemainingB,
    VolleyballMatchConfig? config,
    bool? isSetCompleted,
    bool? isMatchFinished,
    String? matchWinner,
  }) {
    return VolleyballMatchState(
      teamA: teamA ?? this.teamA,
      teamB: teamB ?? this.teamB,
      setsWonA: setsWonA ?? this.setsWonA,
      setsWonB: setsWonB ?? this.setsWonB,
      currentSetPointsA: currentSetPointsA ?? this.currentSetPointsA,
      currentSetPointsB: currentSetPointsB ?? this.currentSetPointsB,
      currentSetNumber: currentSetNumber ?? this.currentSetNumber,
      servingTeam: servingTeam ?? this.servingTeam,
      setHistory: setHistory ?? this.setHistory,
      timeoutsRemainingA: timeoutsRemainingA ?? this.timeoutsRemainingA,
      timeoutsRemainingB: timeoutsRemainingB ?? this.timeoutsRemainingB,
      config: config ?? this.config,
      isSetCompleted: isSetCompleted ?? this.isSetCompleted,
      isMatchFinished: isMatchFinished ?? this.isMatchFinished,
      matchWinner: matchWinner ?? this.matchWinner,
    );
  }

  Map<String, dynamic> toJson() => {
        'teamA': teamA.map((p) => p.toJson()).toList(),
        'teamB': teamB.map((p) => p.toJson()).toList(),
        'setsWonA': setsWonA,
        'setsWonB': setsWonB,
        'currentSetPointsA': currentSetPointsA,
        'currentSetPointsB': currentSetPointsB,
        'currentSetNumber': currentSetNumber,
        'servingTeam': servingTeam,
        'setHistory': setHistory.map((s) => s.toJson()).toList(),
        'timeoutsRemainingA': timeoutsRemainingA,
        'timeoutsRemainingB': timeoutsRemainingB,
        'config': config.toJson(),
        'isSetCompleted': isSetCompleted,
        'isMatchFinished': isMatchFinished,
        'matchWinner': matchWinner,
      };

  factory VolleyballMatchState.fromJson(Map<String, dynamic> json) => VolleyballMatchState(
        teamA: (json['teamA'] as List? ?? [])
            .map((p) => VolleyballPlayer.fromJson(p as Map<String, dynamic>))
            .toList(),
        teamB: (json['teamB'] as List? ?? [])
            .map((p) => VolleyballPlayer.fromJson(p as Map<String, dynamic>))
            .toList(),
        setsWonA: json['setsWonA'] as int? ?? 0,
        setsWonB: json['setsWonB'] as int? ?? 0,
        currentSetPointsA: json['currentSetPointsA'] as int? ?? 0,
        currentSetPointsB: json['currentSetPointsB'] as int? ?? 0,
        currentSetNumber: json['currentSetNumber'] as int? ?? 1,
        servingTeam: json['servingTeam'] as String? ?? 'sideA',
        setHistory: (json['setHistory'] as List? ?? [])
            .map((s) => VolleyballSetResult.fromJson(s as Map<String, dynamic>))
            .toList(),
        timeoutsRemainingA: json['timeoutsRemainingA'] as int? ?? 2,
        timeoutsRemainingB: json['timeoutsRemainingB'] as int? ?? 2,
        config: json['config'] != null
            ? VolleyballMatchConfig.fromJson(json['config'] as Map<String, dynamic>)
            : const VolleyballMatchConfig(),
        isSetCompleted: json['isSetCompleted'] as bool? ?? false,
        isMatchFinished: json['isMatchFinished'] as bool? ?? false,
        matchWinner: json['matchWinner'] as String?,
      );
}

class VolleyballMatchEngine {
  VolleyballMatchState _state;
  final List<VolleyballMatchState> _history = [];

  VolleyballMatchEngine(this._state) {
    _history.add(_state);
  }

  VolleyballMatchState get state => _state;
  bool get canUndo => _history.length > 1;

  void _pushState(VolleyballMatchState newState) {
    _state = newState;
    _history.add(_state);
  }

  void scorePoint(String team, {String? scorerId}) {
    if (_state.isMatchFinished) return;

    final isTeamA = team == 'sideA';
    final newPtsA = _state.currentSetPointsA + (isTeamA ? 1 : 0);
    final newPtsB = _state.currentSetPointsB + (!isTeamA ? 1 : 0);

    final roster = isTeamA ? _state.teamA : _state.teamB;
    final updatedRoster = roster.map((p) {
      if (scorerId != null && p.id == scorerId) {
        return p.copyWith(pointsScored: p.pointsScored + 1);
      }
      return p;
    }).toList();

    // Auto-update serving team to point winner (Rally Scoring System)
    final nextServingTeam = team;

    // Check set win condition
    final targetPts = _state.currentTargetPoints;
    final leadingPts = isTeamA ? newPtsA : newPtsB;
    final trailingPts = isTeamA ? newPtsB : newPtsA;
    final diff = leadingPts - trailingPts;

    bool setWon = false;
    if (_state.config.winByTwoPoints) {
      setWon = leadingPts >= targetPts && diff >= 2;
    } else {
      setWon = leadingPts >= targetPts;
    }

    if (setWon) {
      final newSetsWonA = _state.setsWonA + (isTeamA ? 1 : 0);
      final newSetsWonB = _state.setsWonB + (!isTeamA ? 1 : 0);

      final setResult = VolleyballSetResult(
        setNumber: _state.currentSetNumber,
        sideAScore: newPtsA,
        sideBScore: newPtsB,
        winnerTeam: team,
      );

      final updatedHistory = List<VolleyballSetResult>.from(_state.setHistory)..add(setResult);

      final setsNeeded = _state.config.setsNeededToWin;
      final matchWon = newSetsWonA >= setsNeeded || newSetsWonB >= setsNeeded;
      String? winner;
      if (matchWon) {
        winner = newSetsWonA > newSetsWonB ? 'sideA' : 'sideB';
      }

      _pushState(_state.copyWith(
        teamA: isTeamA ? updatedRoster : _state.teamA,
        teamB: !isTeamA ? updatedRoster : _state.teamB,
        setsWonA: newSetsWonA,
        setsWonB: newSetsWonB,
        currentSetPointsA: newPtsA,
        currentSetPointsB: newPtsB,
        servingTeam: nextServingTeam,
        setHistory: updatedHistory,
        isSetCompleted: true,
        isMatchFinished: matchWon,
        matchWinner: winner,
      ));
    } else {
      _pushState(_state.copyWith(
        teamA: isTeamA ? updatedRoster : _state.teamA,
        teamB: !isTeamA ? updatedRoster : _state.teamB,
        currentSetPointsA: newPtsA,
        currentSetPointsB: newPtsB,
        servingTeam: nextServingTeam,
      ));
    }
  }

  void advanceToNextSet() {
    if (_state.isMatchFinished || !_state.isSetCompleted) return;

    _pushState(_state.copyWith(
      currentSetNumber: _state.currentSetNumber + 1,
      currentSetPointsA: 0,
      currentSetPointsB: 0,
      timeoutsRemainingA: _state.config.timeoutsPerSet,
      timeoutsRemainingB: _state.config.timeoutsPerSet,
      isSetCompleted: false,
    ));
  }

  void toggleServingTeam() {
    if (_state.isMatchFinished) return;
    final nextServer = _state.servingTeam == 'sideA' ? 'sideB' : 'sideA';
    _pushState(_state.copyWith(servingTeam: nextServer));
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

  void endMatch() {
    String? winner;
    if (_state.setsWonA > _state.setsWonB) {
      winner = 'sideA';
    } else if (_state.setsWonB > _state.setsWonA) {
      winner = 'sideB';
    } else {
      winner = _state.currentSetPointsA >= _state.currentSetPointsB ? 'sideA' : 'sideB';
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
