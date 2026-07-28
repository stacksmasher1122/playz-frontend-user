// pickleball_rule_engine.dart

enum PickleballMatchFormat { bestOf3, bestOf5, oneGame }

enum WinningPoints { points11, points15, points21, custom }

enum WinByRule { winBy1, winBy2, unlimited }

enum TeamType { singles, doubles, mixedDoubles }

enum ScoringSystem { traditional, rally }

enum SideChangeRule {
  automatic,
  manual,
  afterGame,
  duringFinal,
  point6,
  point8,
  point11,
}

enum CoinTossChoice { serve, receive, courtSide }

enum DisciplinaryAction {
  warning,
  technicalWarning,
  technicalFoul,
  matchSuspension,
  disqualification,
}

enum FaultType {
  // Local Rules
  netFault,
  outBall,
  doubleBounce,
  wrongServer,
  wrongReceiver,
  footFault,
  kitchenFault,
  paddleTouchNet,
  ballHitPlayer,
  illegalVolley,
  other,
  
  // Professional Rules
  incorrectServerSequence,
  incorrectReceiverPosition,
  illegalServe,
  spinServeFault,
  distractionFault,
  equipmentFault,
  technicalWarning,
  technicalFoul,
  conductViolation,
  refereePenalty,
  
  replay,
}

enum PointType {
  rallyWinner,
  opponentFault,
  ace,
  forcedError,
  unforcedError,
  netCordWinner,
  penaltyPoint,
  replay,
}

enum TimeoutType { standard, medical, equipment }

class PickleballRuleProfile {
  final String profileName;

  // SECTION 1: Match Format
  final PickleballMatchFormat matchFormat;
  final WinningPoints winningPoints;
  final WinByRule winByRule;

  // SECTION 2: Team Type
  final TeamType teamType;

  // SECTION 3: Scoring System
  final ScoringSystem scoringSystem;

  // SECTION 4: Serving Rules
  final bool underhandServe;
  final bool diagonalServe;
  final bool correctServerValidation;
  final bool oneServeAttempt;
  final bool letServeAllowed;

  // SECTION 5 & 6: Violations
  final bool doubleBounceRuleEnabled;
  final bool kitchenRuleEnabled;

  // SECTION 7: Timeouts
  final int timeoutsPerTeam;
  final int timeoutDurationSeconds;
  final bool medicalTimeoutEnabled;
  final bool equipmentTimeoutEnabled;

  // SECTION 8: Side Change
  final SideChangeRule sideChangeRule;
  final bool switchAfterEveryGame;
  final bool switchDuringFinalGame;

  // SECTION 9: Coin Toss
  final bool coinTossEnabled;

  // SECTION 10: Match Officials
  final bool officialsEnabled;

  // SECTION 13: Challenge System
  final bool challengeSystemEnabled;
  final int maxChallengesPerTeam;

  const PickleballRuleProfile({
    required this.profileName,
    required this.matchFormat,
    required this.winningPoints,
    required this.winByRule,
    required this.teamType,
    required this.scoringSystem,
    required this.underhandServe,
    required this.diagonalServe,
    required this.correctServerValidation,
    required this.oneServeAttempt,
    required this.letServeAllowed,
    required this.doubleBounceRuleEnabled,
    required this.kitchenRuleEnabled,
    required this.timeoutsPerTeam,
    required this.timeoutDurationSeconds,
    required this.medicalTimeoutEnabled,
    required this.equipmentTimeoutEnabled,
    required this.sideChangeRule,
    required this.switchAfterEveryGame,
    required this.switchDuringFinalGame,
    required this.coinTossEnabled,
    required this.officialsEnabled,
    required this.challengeSystemEnabled,
    required this.maxChallengesPerTeam,
  });

  // Predefined Profiles
  static const PickleballRuleProfile localTournament = PickleballRuleProfile(
    profileName: "Local Tournament",
    matchFormat: PickleballMatchFormat.oneGame,
    winningPoints: WinningPoints.points11,
    winByRule: WinByRule.winBy2,
    teamType: TeamType.doubles,
    scoringSystem: ScoringSystem.traditional,
    underhandServe: true,
    diagonalServe: true,
    correctServerValidation: false,
    oneServeAttempt: true,
    letServeAllowed: true,
    doubleBounceRuleEnabled: true,
    kitchenRuleEnabled: true,
    timeoutsPerTeam: 1,
    timeoutDurationSeconds: 60,
    medicalTimeoutEnabled: true,
    equipmentTimeoutEnabled: false,
    sideChangeRule: SideChangeRule.manual,
    switchAfterEveryGame: true,
    switchDuringFinalGame: false,
    coinTossEnabled: true,
    officialsEnabled: false,
    challengeSystemEnabled: false,
    maxChallengesPerTeam: 0,
  );

  static const PickleballRuleProfile proTournament = PickleballRuleProfile(
    profileName: "Professional Tournament",
    matchFormat: PickleballMatchFormat.bestOf3,
    winningPoints: WinningPoints.points11,
    winByRule: WinByRule.winBy2,
    teamType: TeamType.doubles,
    scoringSystem: ScoringSystem.traditional,
    underhandServe: true,
    diagonalServe: true,
    correctServerValidation: true,
    oneServeAttempt: true,
    letServeAllowed: false,
    doubleBounceRuleEnabled: true,
    kitchenRuleEnabled: true,
    timeoutsPerTeam: 2,
    timeoutDurationSeconds: 60,
    medicalTimeoutEnabled: true,
    equipmentTimeoutEnabled: true,
    sideChangeRule: SideChangeRule.automatic,
    switchAfterEveryGame: true,
    switchDuringFinalGame: true,
    coinTossEnabled: true,
    officialsEnabled: true,
    challengeSystemEnabled: true,
    maxChallengesPerTeam: 2,
  );

  PickleballRuleProfile copyWith({
    String? profileName,
    PickleballMatchFormat? matchFormat,
    WinningPoints? winningPoints,
    WinByRule? winByRule,
    TeamType? teamType,
    ScoringSystem? scoringSystem,
    bool? underhandServe,
    bool? diagonalServe,
    bool? correctServerValidation,
    bool? oneServeAttempt,
    bool? letServeAllowed,
    bool? doubleBounceRuleEnabled,
    bool? kitchenRuleEnabled,
    int? timeoutsPerTeam,
    int? timeoutDurationSeconds,
    bool? medicalTimeoutEnabled,
    bool? equipmentTimeoutEnabled,
    SideChangeRule? sideChangeRule,
    bool? switchAfterEveryGame,
    bool? switchDuringFinalGame,
    bool? coinTossEnabled,
    bool? officialsEnabled,
    bool? challengeSystemEnabled,
    int? maxChallengesPerTeam,
  }) {
    return PickleballRuleProfile(
      profileName: profileName ?? this.profileName,
      matchFormat: matchFormat ?? this.matchFormat,
      winningPoints: winningPoints ?? this.winningPoints,
      winByRule: winByRule ?? this.winByRule,
      teamType: teamType ?? this.teamType,
      scoringSystem: scoringSystem ?? this.scoringSystem,
      underhandServe: underhandServe ?? this.underhandServe,
      diagonalServe: diagonalServe ?? this.diagonalServe,
      correctServerValidation:
          correctServerValidation ?? this.correctServerValidation,
      oneServeAttempt: oneServeAttempt ?? this.oneServeAttempt,
      letServeAllowed: letServeAllowed ?? this.letServeAllowed,
      doubleBounceRuleEnabled:
          doubleBounceRuleEnabled ?? this.doubleBounceRuleEnabled,
      kitchenRuleEnabled: kitchenRuleEnabled ?? this.kitchenRuleEnabled,
      timeoutsPerTeam: timeoutsPerTeam ?? this.timeoutsPerTeam,
      timeoutDurationSeconds:
          timeoutDurationSeconds ?? this.timeoutDurationSeconds,
      medicalTimeoutEnabled:
          medicalTimeoutEnabled ?? this.medicalTimeoutEnabled,
      equipmentTimeoutEnabled:
          equipmentTimeoutEnabled ?? this.equipmentTimeoutEnabled,
      sideChangeRule: sideChangeRule ?? this.sideChangeRule,
      switchAfterEveryGame: switchAfterEveryGame ?? this.switchAfterEveryGame,
      switchDuringFinalGame:
          switchDuringFinalGame ?? this.switchDuringFinalGame,
      coinTossEnabled: coinTossEnabled ?? this.coinTossEnabled,
      officialsEnabled: officialsEnabled ?? this.officialsEnabled,
      challengeSystemEnabled:
          challengeSystemEnabled ?? this.challengeSystemEnabled,
      maxChallengesPerTeam: maxChallengesPerTeam ?? this.maxChallengesPerTeam,
    );
  }
}

class PickleballMatchEvent {
  final DateTime timestamp;
  final String description;
  final String? eventType; // "Point", "Fault", "Timeout", "Warning"
  final Map<String, dynamic>? metadata;

  PickleballMatchEvent({
    required this.timestamp,
    required this.description,
    this.eventType,
    this.metadata,
  });
}
