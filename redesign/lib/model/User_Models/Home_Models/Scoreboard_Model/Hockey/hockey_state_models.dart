// Hockey State Models

class HockeyPlayer {
  final String id;
  final String name;
  final int number;
  final bool isOnField;
  final int greenCards;
  final int yellowCards;
  final int redCards;
  final int goals;

  const HockeyPlayer({
    required this.id,
    required this.name,
    this.number = 0,
    this.isOnField = true,
    this.greenCards = 0,
    this.yellowCards = 0,
    this.redCards = 0,
    this.goals = 0,
  });

  HockeyPlayer copyWith({
    String? id,
    String? name,
    int? number,
    bool? isOnField,
    int? greenCards,
    int? yellowCards,
    int? redCards,
    int? goals,
  }) {
    return HockeyPlayer(
      id: id ?? this.id,
      name: name ?? this.name,
      number: number ?? this.number,
      isOnField: isOnField ?? this.isOnField,
      greenCards: greenCards ?? this.greenCards,
      yellowCards: yellowCards ?? this.yellowCards,
      redCards: redCards ?? this.redCards,
      goals: goals ?? this.goals,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'number': number,
        'isOnField': isOnField,
        'greenCards': greenCards,
        'yellowCards': yellowCards,
        'redCards': redCards,
        'goals': goals,
      };

  factory HockeyPlayer.fromJson(Map<String, dynamic> json) => HockeyPlayer(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        number: json['number'] as int? ?? 0,
        isOnField: json['isOnField'] as bool? ?? true,
        greenCards: json['greenCards'] as int? ?? 0,
        yellowCards: json['yellowCards'] as int? ?? 0,
        redCards: json['redCards'] as int? ?? 0,
        goals: json['goals'] as int? ?? 0,
      );
}

enum GoalType { fieldGoal, penaltyCorner, penaltyStroke }

class HockeyGoalEvent {
  final String team; // 'sideA' or 'sideB'
  final String scorerName;
  final GoalType goalType;
  final int period;
  final int minute;

  const HockeyGoalEvent({
    required this.team,
    required this.scorerName,
    required this.goalType,
    required this.period,
    required this.minute,
  });

  Map<String, dynamic> toJson() => {
        'team': team,
        'scorerName': scorerName,
        'goalType': goalType.name,
        'period': period,
        'minute': minute,
      };

  factory HockeyGoalEvent.fromJson(Map<String, dynamic> json) => HockeyGoalEvent(
        team: json['team'] as String? ?? 'sideA',
        scorerName: json['scorerName'] as String? ?? 'Player',
        goalType: GoalType.values.firstWhere(
          (e) => e.name == json['goalType'],
          orElse: () => GoalType.fieldGoal,
        ),
        period: json['period'] as int? ?? 1,
        minute: json['minute'] as int? ?? 1,
      );
}

class HockeyMatchConfig {
  final int maxPeriods; // 2 (halves) or 4 (quarters)
  final int periodDurationMinutes; // 15m for quarters, 35m for halves
  final bool isProRules;
  final int squadLimit;
  final bool subsEnabled;
  final int maxSubstitutes;

  const HockeyMatchConfig({
    this.maxPeriods = 4,
    this.periodDurationMinutes = 15,
    this.isProRules = true,
    this.squadLimit = 11,
    this.subsEnabled = true,
    this.maxSubstitutes = 5,
  });

  Map<String, dynamic> toJson() => {
        'maxPeriods': maxPeriods,
        'periodDurationMinutes': periodDurationMinutes,
        'isProRules': isProRules,
        'squadLimit': squadLimit,
        'subsEnabled': subsEnabled,
        'maxSubstitutes': maxSubstitutes,
      };

  factory HockeyMatchConfig.fromJson(Map<String, dynamic> json) => HockeyMatchConfig(
        maxPeriods: json['maxPeriods'] as int? ?? 4,
        periodDurationMinutes: json['periodDurationMinutes'] as int? ?? 15,
        isProRules: json['isProRules'] as bool? ?? true,
        squadLimit: json['squadLimit'] as int? ?? 11,
        subsEnabled: json['subsEnabled'] as bool? ?? true,
        maxSubstitutes: json['maxSubstitutes'] as int? ?? 5,
      );
}

class HockeyMatchState {
  final List<HockeyPlayer> teamA;
  final List<HockeyPlayer> teamB;
  final int goalsA;
  final int goalsB;
  final int currentPeriod;
  final bool isPeriodCompleted;
  final bool isMatchFinished;
  final String? matchWinner;
  final HockeyMatchConfig config;
  final List<HockeyGoalEvent> goalEvents;
  final int penaltyCornersA;
  final int penaltyCornersB;

  const HockeyMatchState({
    required this.teamA,
    required this.teamB,
    required this.goalsA,
    required this.goalsB,
    required this.currentPeriod,
    required this.isPeriodCompleted,
    required this.isMatchFinished,
    this.matchWinner,
    required this.config,
    required this.goalEvents,
    required this.penaltyCornersA,
    required this.penaltyCornersB,
  });

  factory HockeyMatchState.initial({
    required List<HockeyPlayer> teamA,
    required List<HockeyPlayer> teamB,
    required HockeyMatchConfig config,
  }) {
    return HockeyMatchState(
      teamA: teamA,
      teamB: teamB,
      goalsA: 0,
      goalsB: 0,
      currentPeriod: 1,
      isPeriodCompleted: false,
      isMatchFinished: false,
      matchWinner: null,
      config: config,
      goalEvents: const [],
      penaltyCornersA: 0,
      penaltyCornersB: 0,
    );
  }

  HockeyMatchState copyWith({
    List<HockeyPlayer>? teamA,
    List<HockeyPlayer>? teamB,
    int? goalsA,
    int? goalsB,
    int? currentPeriod,
    bool? isPeriodCompleted,
    bool? isMatchFinished,
    String? matchWinner,
    HockeyMatchConfig? config,
    List<HockeyGoalEvent>? goalEvents,
    int? penaltyCornersA,
    int? penaltyCornersB,
  }) {
    return HockeyMatchState(
      teamA: teamA ?? this.teamA,
      teamB: teamB ?? this.teamB,
      goalsA: goalsA ?? this.goalsA,
      goalsB: goalsB ?? this.goalsB,
      currentPeriod: currentPeriod ?? this.currentPeriod,
      isPeriodCompleted: isPeriodCompleted ?? this.isPeriodCompleted,
      isMatchFinished: isMatchFinished ?? this.isMatchFinished,
      matchWinner: matchWinner ?? this.matchWinner,
      config: config ?? this.config,
      goalEvents: goalEvents ?? this.goalEvents,
      penaltyCornersA: penaltyCornersA ?? this.penaltyCornersA,
      penaltyCornersB: penaltyCornersB ?? this.penaltyCornersB,
    );
  }

  Map<String, dynamic> toJson() => {
        'teamA': teamA.map((p) => p.toJson()).toList(),
        'teamB': teamB.map((p) => p.toJson()).toList(),
        'goalsA': goalsA,
        'goalsB': goalsB,
        'currentPeriod': currentPeriod,
        'isPeriodCompleted': isPeriodCompleted,
        'isMatchFinished': isMatchFinished,
        'matchWinner': matchWinner,
        'config': config.toJson(),
        'goalEvents': goalEvents.map((g) => g.toJson()).toList(),
        'penaltyCornersA': penaltyCornersA,
        'penaltyCornersB': penaltyCornersB,
      };

  factory HockeyMatchState.fromJson(Map<String, dynamic> json) => HockeyMatchState(
        teamA: (json['teamA'] as List? ?? [])
            .map((p) => HockeyPlayer.fromJson(p as Map<String, dynamic>))
            .toList(),
        teamB: (json['teamB'] as List? ?? [])
            .map((p) => HockeyPlayer.fromJson(p as Map<String, dynamic>))
            .toList(),
        goalsA: json['goalsA'] as int? ?? 0,
        goalsB: json['goalsB'] as int? ?? 0,
        currentPeriod: json['currentPeriod'] as int? ?? 1,
        isPeriodCompleted: json['isPeriodCompleted'] as bool? ?? false,
        isMatchFinished: json['isMatchFinished'] as bool? ?? false,
        matchWinner: json['matchWinner'] as String?,
        config: json['config'] != null
            ? HockeyMatchConfig.fromJson(json['config'] as Map<String, dynamic>)
            : const HockeyMatchConfig(),
        goalEvents: (json['goalEvents'] as List? ?? [])
            .map((g) => HockeyGoalEvent.fromJson(g as Map<String, dynamic>))
            .toList(),
        penaltyCornersA: json['penaltyCornersA'] as int? ?? 0,
        penaltyCornersB: json['penaltyCornersB'] as int? ?? 0,
      );
}

class HockeyMatchEngine {
  HockeyMatchState _state;
  final List<HockeyMatchState> _history = [];

  HockeyMatchEngine(this._state) {
    _history.add(_state);
  }

  HockeyMatchState get state => _state;

  void scoreGoal(String team, {String? scorerName, GoalType goalType = GoalType.fieldGoal}) {
    if (_state.isMatchFinished) return;

    _history.add(_state);
    int newGoalsA = _state.goalsA;
    int newGoalsB = _state.goalsB;

    if (team == 'sideA') {
      newGoalsA++;
    } else {
      newGoalsB++;
    }

    final name = scorerName ?? (team == 'sideA' ? 'Side A Player' : 'Side B Player');
    final isTeamA = team == 'sideA';
    final targetRoster = isTeamA ? _state.teamA : _state.teamB;

    final updatedRoster = targetRoster.map((p) {
      if (p.name == name || p.id == name) {
        return HockeyPlayer(
          id: p.id,
          name: p.name,
          number: p.number,
          isOnField: p.isOnField,
          greenCards: p.greenCards,
          yellowCards: p.yellowCards,
          redCards: p.redCards,
          goals: p.goals + 1,
        );
      }
      return p;
    }).toList();

    final newGoalEvent = HockeyGoalEvent(
      team: team,
      scorerName: name,
      goalType: goalType,
      period: _state.currentPeriod,
      minute: 1,
    );

    final newGoalEvents = List<HockeyGoalEvent>.from(_state.goalEvents)..add(newGoalEvent);

    _state = _state.copyWith(
      goalsA: newGoalsA,
      goalsB: newGoalsB,
      teamA: isTeamA ? updatedRoster : _state.teamA,
      teamB: isTeamA ? _state.teamB : updatedRoster,
      goalEvents: newGoalEvents,
    );
  }

  void addPenaltyCorner(String team) {
    if (_state.isMatchFinished) return;

    _history.add(_state);
    if (team == 'sideA') {
      _state = _state.copyWith(
        penaltyCornersA: _state.penaltyCornersA + 1,
      );
    } else {
      _state = _state.copyWith(
        penaltyCornersB: _state.penaltyCornersB + 1,
      );
    }
  }

  void advancePeriod() {
    if (_state.isMatchFinished) return;

    _history.add(_state);
    final nextPeriod = _state.currentPeriod + 1;

    if (nextPeriod > _state.config.maxPeriods) {
      endMatch();
    } else {
      _state = _state.copyWith(
        currentPeriod: nextPeriod,
        isPeriodCompleted: false,
      );
    }
  }

  void completeCurrentPeriod() {
    if (_state.isMatchFinished) return;
    _history.add(_state);
    _state = _state.copyWith(
      isPeriodCompleted: true,
    );
  }

  void endMatch() {
    _history.add(_state);
    String? winner;
    if (_state.goalsA > _state.goalsB) {
      winner = 'sideA';
    } else if (_state.goalsB > _state.goalsA) {
      winner = 'sideB';
    } else {
      winner = 'draw';
    }

    _state = _state.copyWith(
      isMatchFinished: true,
      matchWinner: winner,
    );
  }

  bool get canUndo => _history.length > 1;

  void undo() {
    if (!canUndo) return;
    _history.removeLast();
    _state = _history.last;
  }
}
