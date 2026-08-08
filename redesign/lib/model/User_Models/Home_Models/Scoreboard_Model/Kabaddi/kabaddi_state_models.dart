enum PlayerSide { sideA, sideB }
enum RaidOutcome { touchPoint, tacklePoint, superTackle, bonusPoint, emptyRaid, allOut }

class KabaddiPlayer {
  final String id;
  final String name;
  final bool isCaptain;
  final bool isOnCourt;
  final int raidPointsScored;
  final int tacklePointsScored;

  const KabaddiPlayer({
    required this.id,
    required this.name,
    this.isCaptain = false,
    this.isOnCourt = true,
    this.raidPointsScored = 0,
    this.tacklePointsScored = 0,
  });

  KabaddiPlayer copyWith({
    String? id,
    String? name,
    bool? isCaptain,
    bool? isOnCourt,
    int? raidPointsScored,
    int? tacklePointsScored,
  }) {
    return KabaddiPlayer(
      id: id ?? this.id,
      name: name ?? this.name,
      isCaptain: isCaptain ?? this.isCaptain,
      isOnCourt: isOnCourt ?? this.isOnCourt,
      raidPointsScored: raidPointsScored ?? this.raidPointsScored,
      tacklePointsScored: tacklePointsScored ?? this.tacklePointsScored,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'isCaptain': isCaptain,
        'isOnCourt': isOnCourt,
        'raidPointsScored': raidPointsScored,
        'tacklePointsScored': tacklePointsScored,
      };

  factory KabaddiPlayer.fromJson(Map<String, dynamic> json) => KabaddiPlayer(
        id: json['id'] as String? ?? 'p_${DateTime.now().millisecondsSinceEpoch}',
        name: json['name'] as String? ?? 'Player',
        isCaptain: json['isCaptain'] as bool? ?? false,
        isOnCourt: json['isOnCourt'] as bool? ?? true,
        raidPointsScored: json['raidPointsScored'] as int? ?? 0,
        tacklePointsScored: json['tacklePointsScored'] as int? ?? 0,
      );
}

class KabaddiMatchConfig {
  final int halfDurationMinutes;
  final bool isProRules;
  final int activePlayersPerTeam;
  final bool enableSuperTackle;
  final bool enableBonusLine;
  final bool enableDoOrDie;

  const KabaddiMatchConfig({
    this.halfDurationMinutes = 15,
    this.isProRules = true,
    this.activePlayersPerTeam = 7,
    this.enableSuperTackle = true,
    this.enableBonusLine = true,
    this.enableDoOrDie = true,
  });

  bool get isFriendlyRules => !isProRules;

  Map<String, dynamic> toJson() => {
        'halfDurationMinutes': halfDurationMinutes,
        'isProRules': isProRules,
        'activePlayersPerTeam': activePlayersPerTeam,
        'enableSuperTackle': enableSuperTackle,
        'enableBonusLine': enableBonusLine,
        'enableDoOrDie': enableDoOrDie,
      };

  factory KabaddiMatchConfig.fromJson(Map<String, dynamic> json) => KabaddiMatchConfig(
        halfDurationMinutes: json['halfDurationMinutes'] as int? ?? 15,
        isProRules: json['isProRules'] as bool? ?? true,
        activePlayersPerTeam: json['activePlayersPerTeam'] as int? ?? 7,
        enableSuperTackle: json['enableSuperTackle'] as bool? ?? true,
        enableBonusLine: json['enableBonusLine'] as bool? ?? true,
        enableDoOrDie: json['enableDoOrDie'] as bool? ?? true,
      );
}

class KabaddiMatchState {
  final List<KabaddiPlayer> teamA;
  final List<KabaddiPlayer> teamB;
  final int sideAScore;
  final int sideBScore;
  final int currentHalf; // 1 or 2
  final PlayerSide raidingSide;
  final int consecutiveEmptyRaidsA;
  final int consecutiveEmptyRaidsB;
  final KabaddiMatchConfig config;
  final bool isHalfCompleted;
  final bool isMatchFinished;
  final PlayerSide? matchWinner;

  int get sideAActiveCount => teamA.isEmpty ? config.activePlayersPerTeam : teamA.where((p) => p.isOnCourt).length;
  int get sideBActiveCount => teamB.isEmpty ? config.activePlayersPerTeam : teamB.where((p) => p.isOnCourt).length;

  bool get isDoOrDieA => config.isProRules && config.enableDoOrDie && consecutiveEmptyRaidsA >= 2;
  bool get isDoOrDieB => config.isProRules && config.enableDoOrDie && consecutiveEmptyRaidsB >= 2;
  bool get isCurrentRaidDoOrDie => raidingSide == PlayerSide.sideA ? isDoOrDieA : isDoOrDieB;

  const KabaddiMatchState({
    required this.teamA,
    required this.teamB,
    required this.sideAScore,
    required this.sideBScore,
    required this.currentHalf,
    required this.raidingSide,
    required this.consecutiveEmptyRaidsA,
    required this.consecutiveEmptyRaidsB,
    required this.config,
    this.isHalfCompleted = false,
    this.isMatchFinished = false,
    this.matchWinner,
  });

  factory KabaddiMatchState.initial({
    required List<KabaddiPlayer> teamA,
    required List<KabaddiPlayer> teamB,
    required KabaddiMatchConfig config,
    required PlayerSide initialRaidingSide,
  }) {
    return KabaddiMatchState(
      teamA: teamA,
      teamB: teamB,
      sideAScore: 0,
      sideBScore: 0,
      currentHalf: 1,
      raidingSide: initialRaidingSide,
      consecutiveEmptyRaidsA: 0,
      consecutiveEmptyRaidsB: 0,
      config: config,
      isHalfCompleted: false,
      isMatchFinished: false,
      matchWinner: null,
    );
  }

  KabaddiMatchState copyWith({
    List<KabaddiPlayer>? teamA,
    List<KabaddiPlayer>? teamB,
    int? sideAScore,
    int? sideBScore,
    int? currentHalf,
    PlayerSide? raidingSide,
    int? consecutiveEmptyRaidsA,
    int? consecutiveEmptyRaidsB,
    KabaddiMatchConfig? config,
    bool? isHalfCompleted,
    bool? isMatchFinished,
    PlayerSide? matchWinner,
    bool clearMatchWinner = false,
  }) {
    return KabaddiMatchState(
      teamA: teamA ?? this.teamA,
      teamB: teamB ?? this.teamB,
      sideAScore: sideAScore ?? this.sideAScore,
      sideBScore: sideBScore ?? this.sideBScore,
      currentHalf: currentHalf ?? this.currentHalf,
      raidingSide: raidingSide ?? this.raidingSide,
      consecutiveEmptyRaidsA: consecutiveEmptyRaidsA ?? this.consecutiveEmptyRaidsA,
      consecutiveEmptyRaidsB: consecutiveEmptyRaidsB ?? this.consecutiveEmptyRaidsB,
      config: config ?? this.config,
      isHalfCompleted: isHalfCompleted ?? this.isHalfCompleted,
      isMatchFinished: isMatchFinished ?? this.isMatchFinished,
      matchWinner: clearMatchWinner ? null : (matchWinner ?? this.matchWinner),
    );
  }

  Map<String, dynamic> toJson() => {
        'teamA': teamA.map((p) => p.toJson()).toList(),
        'teamB': teamB.map((p) => p.toJson()).toList(),
        'sideAScore': sideAScore,
        'sideBScore': sideBScore,
        'sideAActiveCount': sideAActiveCount,
        'sideBActiveCount': sideBActiveCount,
        'currentHalf': currentHalf,
        'raidingSide': raidingSide.name,
        'consecutiveEmptyRaidsA': consecutiveEmptyRaidsA,
        'consecutiveEmptyRaidsB': consecutiveEmptyRaidsB,
        'config': config.toJson(),
        'isHalfCompleted': isHalfCompleted,
        'isMatchFinished': isMatchFinished,
        'matchWinner': matchWinner?.name,
      };

  factory KabaddiMatchState.fromJson(Map<String, dynamic> json) => KabaddiMatchState(
        teamA: (json['teamA'] as List? ?? [])
            .map((p) => KabaddiPlayer.fromJson(p as Map<String, dynamic>))
            .toList(),
        teamB: (json['teamB'] as List? ?? [])
            .map((p) => KabaddiPlayer.fromJson(p as Map<String, dynamic>))
            .toList(),
        sideAScore: json['sideAScore'] as int? ?? 0,
        sideBScore: json['sideBScore'] as int? ?? 0,
        currentHalf: json['currentHalf'] as int? ?? 1,
        raidingSide: json['raidingSide'] == 'sideB' ? PlayerSide.sideB : PlayerSide.sideA,
        consecutiveEmptyRaidsA: json['consecutiveEmptyRaidsA'] as int? ?? 0,
        consecutiveEmptyRaidsB: json['consecutiveEmptyRaidsB'] as int? ?? 0,
        config: json['config'] != null
            ? KabaddiMatchConfig.fromJson(json['config'] as Map<String, dynamic>)
            : const KabaddiMatchConfig(),
        isHalfCompleted: json['isHalfCompleted'] as bool? ?? false,
        isMatchFinished: json['isMatchFinished'] as bool? ?? false,
        matchWinner: json['matchWinner'] != null
            ? (json['matchWinner'] == 'sideA' ? PlayerSide.sideA : PlayerSide.sideB)
            : null,
      );
}

class KabaddiMatchEngine {
  KabaddiMatchState _state;
  final List<KabaddiMatchState> _history = [];

  KabaddiMatchEngine(this._state) {
    _history.add(_state);
  }

  KabaddiMatchState get state => _state;
  bool get canUndo => _history.length > 1;

  void _pushState(KabaddiMatchState newState) {
    _state = newState;
    _history.add(_state);
    if (_history.length > 50) {
      _history.removeAt(0);
    }
  }

  void scoreRaidPoint(PlayerSide raidingTeam, {int points = 1, String? raiderId, String? revivedPlayerId}) {
    if (_state.isMatchFinished) return;

    final maxActive = _state.config.activePlayersPerTeam;
    final isTeamA = raidingTeam == PlayerSide.sideA;

    int newAScore = _state.sideAScore + (isTeamA ? points : 0);
    int newBScore = _state.sideBScore + (!isTeamA ? points : 0);

    List<KabaddiPlayer> updatedTeamA = List.from(_state.teamA);
    List<KabaddiPlayer> updatedTeamB = List.from(_state.teamB);

    var raidingSquad = isTeamA ? updatedTeamA : updatedTeamB;
    var defendingSquad = isTeamA ? updatedTeamB : updatedTeamA;

    // Eliminate 'points' defender(s) from defending squad
    int eliminatedCount = 0;
    for (int i = 0; i < defendingSquad.length; i++) {
      if (defendingSquad[i].isOnCourt && eliminatedCount < points) {
        defendingSquad[i] = defendingSquad[i].copyWith(isOnCourt: false);
        eliminatedCount++;
      }
    }

    // Revive 'points' player(s) for raiding squad
    int revivedCount = 0;
    if (revivedPlayerId != null) {
      for (int i = 0; i < raidingSquad.length; i++) {
        if (raidingSquad[i].id == revivedPlayerId) {
          raidingSquad[i] = raidingSquad[i].copyWith(isOnCourt: true);
          revivedCount++;
          break;
        }
      }
    }
    // Auto-revive any remaining out players up to 'points'
    for (int i = 0; i < raidingSquad.length; i++) {
      if (!raidingSquad[i].isOnCourt && revivedCount < points) {
        raidingSquad[i] = raidingSquad[i].copyWith(isOnCourt: true);
        revivedCount++;
      }
    }

    int newAActive = updatedTeamA.isEmpty ? maxActive : updatedTeamA.where((p) => p.isOnCourt).length;
    int newBActive = updatedTeamB.isEmpty ? maxActive : updatedTeamB.where((p) => p.isOnCourt).length;

    // Check All-Out for defending team
    if (newBActive == 0 && updatedTeamB.isNotEmpty) {
      newAScore += 2;
      updatedTeamB = updatedTeamB.map((p) => p.copyWith(isOnCourt: true)).toList();
    }
    if (newAActive == 0 && updatedTeamA.isNotEmpty) {
      newBScore += 2;
      updatedTeamA = updatedTeamA.map((p) => p.copyWith(isOnCourt: true)).toList();
    }

    final nextRaidSide = isTeamA ? PlayerSide.sideB : PlayerSide.sideA;

    _pushState(_state.copyWith(
      teamA: updatedTeamA,
      teamB: updatedTeamB,
      sideAScore: newAScore,
      sideBScore: newBScore,
      raidingSide: nextRaidSide,
      consecutiveEmptyRaidsA: isTeamA ? 0 : _state.consecutiveEmptyRaidsA,
      consecutiveEmptyRaidsB: !isTeamA ? 0 : _state.consecutiveEmptyRaidsB,
    ));
  }

  void scoreEmptyRaid(PlayerSide raidingTeam) {
    if (_state.isMatchFinished) return;

    final isTeamA = raidingTeam == PlayerSide.sideA;
    final isDoOrDie = isTeamA ? _state.isDoOrDieA : _state.isDoOrDieB;

    if (isDoOrDie) {
      // Raider is OUT on Do-or-Die! Defending team scores +1 tackle point & revives 1 defender
      scoreTacklePoint(isTeamA ? PlayerSide.sideB : PlayerSide.sideA);
      return;
    }

    // Normal Empty Raid
    final nextRaidSide = isTeamA ? PlayerSide.sideB : PlayerSide.sideA;
    _pushState(_state.copyWith(
      raidingSide: nextRaidSide,
      consecutiveEmptyRaidsA: isTeamA ? _state.consecutiveEmptyRaidsA + 1 : _state.consecutiveEmptyRaidsA,
      consecutiveEmptyRaidsB: !isTeamA ? _state.consecutiveEmptyRaidsB + 1 : _state.consecutiveEmptyRaidsB,
    ));
  }

  void scoreTacklePoint(PlayerSide defendingTeam, {String? revivedPlayerId}) {
    if (_state.isMatchFinished) return;

    final isDefendingA = defendingTeam == PlayerSide.sideA;

    final defendersActive = isDefendingA ? _state.sideAActiveCount : _state.sideBActiveCount;
    final isSuperTackle = _state.config.enableSuperTackle && defendersActive <= 3;
    final pointsEarned = isSuperTackle ? 2 : 1;

    int newAScore = _state.sideAScore + (isDefendingA ? pointsEarned : 0);
    int newBScore = _state.sideBScore + (!isDefendingA ? pointsEarned : 0);

    List<KabaddiPlayer> updatedTeamA = List.from(_state.teamA);
    List<KabaddiPlayer> updatedTeamB = List.from(_state.teamB);

    var defendingSquad = isDefendingA ? updatedTeamA : updatedTeamB;
    var raidingSquad = isDefendingA ? updatedTeamB : updatedTeamA;

    // Eliminate 1 raider from raiding squad
    for (int i = 0; i < raidingSquad.length; i++) {
      if (raidingSquad[i].isOnCourt) {
        raidingSquad[i] = raidingSquad[i].copyWith(isOnCourt: false);
        break;
      }
    }

    // Revive 1 defender in defending squad (only if someone is out)
    if (defendingSquad.any((p) => !p.isOnCourt)) {
      if (revivedPlayerId != null) {
        for (int i = 0; i < defendingSquad.length; i++) {
          if (defendingSquad[i].id == revivedPlayerId) {
            defendingSquad[i] = defendingSquad[i].copyWith(isOnCourt: true);
            break;
          }
        }
      } else {
        for (int i = 0; i < defendingSquad.length; i++) {
          if (!defendingSquad[i].isOnCourt) {
            defendingSquad[i] = defendingSquad[i].copyWith(isOnCourt: true);
            break;
          }
        }
      }
    }

    int newAActive = updatedTeamA.isEmpty ? _state.config.activePlayersPerTeam : updatedTeamA.where((p) => p.isOnCourt).length;
    int newBActive = updatedTeamB.isEmpty ? _state.config.activePlayersPerTeam : updatedTeamB.where((p) => p.isOnCourt).length;

    // Check All-Out
    if (newBActive == 0 && updatedTeamB.isNotEmpty) {
      newAScore += 2;
      updatedTeamB = updatedTeamB.map((p) => p.copyWith(isOnCourt: true)).toList();
    }
    if (newAActive == 0 && updatedTeamA.isNotEmpty) {
      newBScore += 2;
      updatedTeamA = updatedTeamA.map((p) => p.copyWith(isOnCourt: true)).toList();
    }

    final nextRaidSide = isDefendingA ? PlayerSide.sideA : PlayerSide.sideB;

    _pushState(_state.copyWith(
      teamA: updatedTeamA,
      teamB: updatedTeamB,
      sideAScore: newAScore,
      sideBScore: newBScore,
      raidingSide: nextRaidSide,
      consecutiveEmptyRaidsA: isDefendingA ? _state.consecutiveEmptyRaidsA : 0,
      consecutiveEmptyRaidsB: !isDefendingA ? _state.consecutiveEmptyRaidsB : 0,
    ));
  }

  void scoreAllOut(PlayerSide teamAwarded) {
    if (_state.isMatchFinished) return;

    final isTeamA = teamAwarded == PlayerSide.sideA;
    int newAScore = _state.sideAScore + (isTeamA ? 2 : 0);
    int newBScore = _state.sideBScore + (!isTeamA ? 2 : 0);

    final updatedTeamA = _state.teamA.map((p) => p.copyWith(isOnCourt: true)).toList();
    final updatedTeamB = _state.teamB.map((p) => p.copyWith(isOnCourt: true)).toList();

    _pushState(_state.copyWith(
      teamA: updatedTeamA,
      teamB: updatedTeamB,
      sideAScore: newAScore,
      sideBScore: newBScore,
    ));
  }

  void scoreBonusPoint(PlayerSide raidingTeam) {
    if (_state.isMatchFinished) return;

    final isTeamA = raidingTeam == PlayerSide.sideA;
    final defendersActive = isTeamA ? _state.sideBActiveCount : _state.sideAActiveCount;
    // Guard: Bonus point requires 6+ defenders on court in Pro Mode
    if (_state.config.isProRules && defendersActive < 6) return;

    int newAScore = _state.sideAScore + (isTeamA ? 1 : 0);
    int newBScore = _state.sideBScore + (!isTeamA ? 1 : 0);

    _pushState(_state.copyWith(
      sideAScore: newAScore,
      sideBScore: newBScore,
    ));
  }

  void switchHalf() {
    if (_state.currentHalf >= 2) {
      endMatch();
      return;
    }

    final updatedTeamA = _state.teamA.map((p) => p.copyWith(isOnCourt: true)).toList();
    final updatedTeamB = _state.teamB.map((p) => p.copyWith(isOnCourt: true)).toList();

    _pushState(_state.copyWith(
      teamA: updatedTeamA,
      teamB: updatedTeamB,
      currentHalf: 2,
      isHalfCompleted: true,
      consecutiveEmptyRaidsA: 0,
      consecutiveEmptyRaidsB: 0,
      raidingSide: _state.raidingSide == PlayerSide.sideA ? PlayerSide.sideB : PlayerSide.sideA,
    ));
  }

  void endMatch() {
    PlayerSide? winner;
    if (_state.sideAScore > _state.sideBScore) {
      winner = PlayerSide.sideA;
    } else if (_state.sideBScore > _state.sideAScore) {
      winner = PlayerSide.sideB;
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
