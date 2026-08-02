import 'package:uuid/uuid.dart';
import '../../model/User_Models/Home_Models/Scoreboard_Model/cricket_state_models.dart';

class MatchEngine {
  late MatchState _state;
  final List<MatchState> _history = [];
  final int maxOvers;

  MatchEngine({
    int? targetScore,
    required this.maxOvers,
    required List<Player> battingTeam,
    required List<Player> bowlingTeam,
    MatchConfig? matchConfig,
  }) {
    _state = MatchState(
      totalRuns: 0,
      wickets: 0,
      overs: 0,
      balls: 0,
      inningsNumber: targetScore == null ? 1 : 2,
      matchStatus: 'INITIALIZING',
      battingTeam: battingTeam,
      bowlingTeam: bowlingTeam,
      ballHistory: [],
      currentOverBalls: [],
      targetScore: targetScore,
      matchConfig: matchConfig ?? const MatchConfig(),
    );
  }

  MatchState get state => _state;
  bool get canUndo => _history.isNotEmpty;
  int get undoCount => _history.length;

  void _saveSnapshot() {
    _history.add(MatchState.fromJson(_state.toJson()));
  }

  bool undo() {
    if (_history.isNotEmpty) {
      _state = _history.removeLast();
      return true;
    }
    return false;
  }

  void restoreState(Map<String, dynamic> json) {
    _state = MatchState.fromJson(json);
    _history.clear();
  }

  /// Updates the engine state from JSON WITHOUT clearing undo history.
  /// Use this for non-destructive state patches (e.g., injecting commentary).
  void patchState(Map<String, dynamic> json) {
    _state = MatchState.fromJson(json);
  }

  Map<String, dynamic> generateScorecard() {
    return {
      "runs": _state.totalRuns,
      "wickets": _state.wickets,
      "overs": '${_state.overs}.${_state.balls}',
      "batting": _state.battingTeam.where((p) => p.hasBatted).map((p) => {
        "name": p.name,
        "runs": p.runs,
        "balls": p.ballsFaced,
        "4s": p.fours,
        "6s": p.sixes,
        "out": p.isOut,
      }).toList(),
      "bowling": _state.bowlingTeam.where((p) => p.hasBowled).map((p) => {
        "name": p.name,
        "overs": p.oversBowledDisplay,
        "runs": p.runsConceded,
        "wickets": p.wicketsTaken,
        "maidens": p.maidens,
      }).toList(),
      "extras": _state.ballHistory.where((b) => b.isExtra).fold(0, (sum, b) => sum + b.extraRuns),
      // E3: Derive fall-of-wickets from ballHistory instead of leaving it empty.
      "fallOfWickets": _computeFallOfWickets(),
      "result": _state.matchStatus == 'MATCH_COMPLETED' ? "completed" : "in_progress",
    };
  }

  // E3: Compute fall-of-wickets from ball history.
  // Filters wicket events and records the team score and over at each dismissal.
  List<Map<String, dynamic>> _computeFallOfWickets() {
    int wicketCount = 0;
    int runningTotal = 0;
    final List<Map<String, dynamic>> fow = [];

    for (final ball in _state.ballHistory) {
      runningTotal += ball.totalRuns;
      if (ball.isWicket) {
        wicketCount++;
        fow.add({
          'wicket': wicketCount,
          'runs': runningTotal,
          'over': '${ball.overNumber}.${ball.ballNumber}',
          'player': ball.batterOutName ?? '',
        });
      }
    }
    return fow;
  }

  void startInnings({required String strikerName, required String nonStrikerName, required String bowlerName}) {
    _saveSnapshot();
    
    final newBatting = _state.battingTeam.map((p) {
      if (p.name == strikerName || p.name == nonStrikerName) {
        return p.copyWith(hasBatted: true, status: PlayerStatus.batter);
      }
      return p;
    }).toList();

    final newBowling = _state.bowlingTeam.map((p) {
      if (p.name == bowlerName) {
        return p.copyWith(hasBowled: true);
      }
      return p;
    }).toList();

    final striker = newBatting.firstWhere((p) => p.name == strikerName);
    final nonStriker = newBatting.firstWhere((p) => p.name == nonStrikerName);
    final bowler = newBowling.firstWhere((p) => p.name == bowlerName);

    _state = _state.copyWith(
      battingTeam: newBatting,
      bowlingTeam: newBowling,
      striker: striker,
      nonStriker: nonStriker,
      currentBowler: bowler,
      matchStatus: _state.inningsNumber == 1 ? 'LIVE_INNINGS_1' : 'LIVE_INNINGS_2',
      partnership: Partnership(batsman1: striker, batsman2: nonStriker),
    );
  }

  void changeBowler(String newBowlerName) {
    final int bowlingSquadSize = _state.bowlingTeam.length;
    final bool isSmallSquad = bowlingSquadSize <= 2;

    // E1: Skip consecutive-over restriction for small squads (<=2 bowlers)
    // where enforcing it would deadlock the match.
    if (!isSmallSquad && _state.currentBowler?.name == newBowlerName) {
      throw Exception('Bowler cannot bowl consecutive overs');
    }
    
    final bowler = _state.bowlingTeam.firstWhere((p) => p.name == newBowlerName);

    // E1: Skip bowler quota restriction for small squads where enforcing it
    // would leave no eligible bowler for remaining overs.
    if (!isSmallSquad && bowler.ballsBowled >= _state.matchConfig.maxOversPerBowler * 6) {
       throw Exception('Bowler has completed their quota of ${_state.matchConfig.maxOversPerBowler} overs');
    }

    _saveSnapshot();
    
    final newBowling = _state.bowlingTeam.map((p) {
      if (p.name == newBowlerName) {
        return p.copyWith(hasBowled: true);
      }
      return p;
    }).toList();

    _state = _state.copyWith(
      bowlingTeam: newBowling,
      previousBowler: _state.currentBowler,
      currentBowler: newBowling.firstWhere((p) => p.name == newBowlerName),
    );
  }

  List<Player> _updateBattingPlayer(Player updatedPlayer) {
    return _state.battingTeam.map((p) => p.name == updatedPlayer.name ? updatedPlayer : p).toList();
  }

  List<Player> _updateBowlingPlayer(Player updatedPlayer) {
    return _state.bowlingTeam.map((p) => p.name == updatedPlayer.name ? updatedPlayer : p).toList();
  }

  // B4: Dedicated retire method that preserves undo history.
  // Unlike restoreState(), this saves a snapshot first so undo still works.
  void retireBatter(String playerName, PlayerStatus status) {
    _saveSnapshot();
    final updatedBatting = _state.battingTeam
        .map((p) => p.name == playerName ? p.copyWith(status: status) : p)
        .toList();

    // Update striker/nonStriker references if the retired player is one of them
    Player? newStriker = _state.striker;
    Player? newNonStriker = _state.nonStriker;
    if (_state.striker?.name == playerName) {
      newStriker = updatedBatting.firstWhere((p) => p.name == playerName);
    }
    if (_state.nonStriker?.name == playerName) {
      newNonStriker = updatedBatting.firstWhere((p) => p.name == playerName);
    }

    _state = _state.copyWith(
      battingTeam: updatedBatting,
      striker: newStriker,
      nonStriker: newNonStriker,
    );
  }

  // Dedicated retire bowler method that preserves undo history
  void retireBowler(String replacementBowlerName) {
    _saveSnapshot();
    final updatedBowling = _state.bowlingTeam.map((p) {
      if (p.name == _state.currentBowler?.name) {
        return p.copyWith(status: PlayerStatus.retiredHurt);
      }
      if (p.name == replacementBowlerName) {
        return p.copyWith(hasBowled: true);
      }
      return p;
    }).toList();

    _state = _state.copyWith(
      bowlingTeam: updatedBowling,
      currentBowler: updatedBowling.firstWhere((p) => p.name == replacementBowlerName),
    );
  }

  // A3: Declare innings — manually end the current innings early.
  void declareInnings() {
    _saveSnapshot();
    if (_state.inningsNumber == 1) {
      _state = _state.copyWith(matchStatus: 'INNINGS_BREAK');
    } else {
      // In 2nd innings, declaration means match is complete
      _state = _state.copyWith(
        matchStatus: 'MATCH_COMPLETED',
        matchResult: _state.targetScore != null && _state.totalRuns >= _state.targetScore!
            ? 'Batting team won'
            : 'Bowling team won by declaration',
      );
    }
  }

  // A3: Abandon match — end match with no result.
  void abandonMatch() {
    _saveSnapshot();
    _state = _state.copyWith(
      matchStatus: 'MATCH_COMPLETED',
      matchResult: 'Match Abandoned — No Result',
    );
  }

  // -------------------------------------------------------------
  // EVENT REDUCER
  // -------------------------------------------------------------
  void dispatch(MatchEvent event) {
    // B5: Engine-level validation — only process events during live innings.
    // This prevents scoring when matchStatus is MATCH_COMPLETED, INNINGS_BREAK,
    // INITIALIZING, or any non-live state.
    final status = _state.matchStatus;
    if (!status.startsWith('LIVE_')) {
      return; // Silently ignore dispatches in non-live states
    }

    _saveSnapshot();

    if (event is DeliveryEvent) {
      _processDelivery(event);
    }
  }

  void _processDelivery(DeliveryEvent event) {
    if (event.isDeadBall) {
      final ball = BallEvent(
        id: const Uuid().v4(),
        runs: 0,
        overNumber: _state.overs,
        ballNumber: _state.balls,
        isLegalDelivery: false,
      );
      _state = _state.copyWith(ballHistory: List.from(_state.ballHistory)..add(ball));
      return; 
    }

    Player newStriker = _state.striker!;
    Player nonStriker = _state.nonStriker!;
    Player newBowler = _state.currentBowler!;
    Partnership newPartnership = _state.partnership!;

    bool isWideOrNoBall = (event.extra == ExtraType.wide || event.extra == ExtraType.noBall);
    bool consumesBall = !isWideOrNoBall && event.extra != ExtraType.penalty;

    int totalPhysicalRunsOffBat = event.runs;
    int overthrowRuns = event.overthrowRuns;
    int extraRunsPenalty = 0;
    
    // Evaluate runs
    if (event.extra == ExtraType.wide) {
      // B2: Wide runs are always extras — never credited to the batter.
      // All R + 1 goes to extraRunsPenalty/team total.
      extraRunsPenalty = 1 + totalPhysicalRunsOffBat + overthrowRuns;
      totalPhysicalRunsOffBat = 0;
      overthrowRuns = 0;
    } else if (event.extra == ExtraType.noBall) {
      extraRunsPenalty = 1;
    } else if (event.extra == ExtraType.bye || event.extra == ExtraType.legBye) {
      extraRunsPenalty = totalPhysicalRunsOffBat + overthrowRuns;
      totalPhysicalRunsOffBat = 0;
      overthrowRuns = 0;
    } else if (event.extra == ExtraType.penalty) {
      extraRunsPenalty = totalPhysicalRunsOffBat; 
      totalPhysicalRunsOffBat = 0;
    }

    // B2: For wides, runAccumulatorForBatter is forced to 0.
    int runAccumulatorForBatter = totalPhysicalRunsOffBat + overthrowRuns;
    int runAccumulatorForBowler = totalPhysicalRunsOffBat + overthrowRuns + extraRunsPenalty;

    // Byes/Legbyes do not credit bowler
    if (event.extra == ExtraType.bye || event.extra == ExtraType.legBye || event.extra == ExtraType.penalty) {
      runAccumulatorForBowler = extraRunsPenalty; // Modifying based on context
      if (event.extra != ExtraType.penalty) runAccumulatorForBowler -= extraRunsPenalty; // Usually Byes are not given to bowler ER
    }

    // Apply Striker metrics
    // B2: On a wide, totalPhysicalRunsOffBat is already 0 so no batter credit.
    newStriker = newStriker.copyWith(
      ballsFaced: consumesBall ? newStriker.ballsFaced + 1 : newStriker.ballsFaced,
      runs: newStriker.runs + runAccumulatorForBatter,
      fours: newStriker.fours + (totalPhysicalRunsOffBat == 4 ? 1 : 0),
      sixes: newStriker.sixes + (totalPhysicalRunsOffBat == 6 ? 1 : 0),
    );

    // Apply Bowler metrics
    if (consumesBall) {
      newBowler = newBowler.copyWith(ballsBowled: newBowler.ballsBowled + 1);
    }
    newBowler = newBowler.copyWith(runsConceded: newBowler.runsConceded + runAccumulatorForBowler);

    // Dot balls
    if (consumesBall && runAccumulatorForBatter == 0 && extraRunsPenalty == 0 && event.wickets.isEmpty) {
      newBowler = newBowler.copyWith(dotBalls: newBowler.dotBalls + 1);
    }

    // Process Wickets
    int wicketsToAdd = 0;
    for (var w in event.wickets) {
       // Free Hit Immunity
       if (_state.isFreeHit && [DismissalType.bowled, DismissalType.caught, DismissalType.lbw, DismissalType.stumped, DismissalType.hitWicket].contains(w.type)) {
         continue; 
       }

       wicketsToAdd++;
       if (w.outPlayerName == newStriker.name) {
          newStriker = newStriker.copyWith(status: PlayerStatus.out);
       } else if (w.outPlayerName == nonStriker.name) {
          nonStriker = nonStriker.copyWith(status: PlayerStatus.out);
       }

       // Bowler credit
       if ([DismissalType.bowled, DismissalType.caught, DismissalType.lbw, DismissalType.stumped, DismissalType.hitWicket].contains(w.type)) {
          newBowler = newBowler.copyWith(wicketsTaken: newBowler.wicketsTaken + 1);
       }

       // Track fielder stats directly to Bowling team models
       if (w.fielderName != null) {
          final bTeamIndex = _state.bowlingTeam.indexWhere((p) => p.name == w.fielderName);
          if (bTeamIndex != -1) {
             Player fielder = _state.bowlingTeam[bTeamIndex];
             if (w.type == DismissalType.caught) fielder = fielder.copyWith(catches: fielder.catches + 1);
             if (w.type == DismissalType.stumped) fielder = fielder.copyWith(stumpings: fielder.stumpings + 1);
             if (w.type == DismissalType.runOut) fielder = fielder.copyWith(runOuts: fielder.runOuts + 1);
             
             List<Player> bTeam = List.from(_state.bowlingTeam);
             bTeam[bTeamIndex] = fielder;
             _state = _state.copyWith(bowlingTeam: bTeam);
          }
       }
    }

    // Sync State updates
    List<Player> updatedBattingTeam = List.from(_state.battingTeam);
    void updateInBattingList(Player p) {
      int idx = updatedBattingTeam.indexWhere((x) => x.name == p.name);
      if (idx != -1) updatedBattingTeam[idx] = p;
    }
    updateInBattingList(newStriker);
    updateInBattingList(nonStriker);

    List<Player> updatedBowlingTeam = List.from(_state.bowlingTeam);
    void updateInBowlingList(Player p) {
      int idx = updatedBowlingTeam.indexWhere((x) => x.name == p.name);
      if (idx != -1) updatedBowlingTeam[idx] = p;
    }
    updateInBowlingList(newBowler);

    // B1: Only re-evaluate isFreeHit when the delivery consumed a ball.
    // On an illegal delivery (wide or another no-ball), leave isFreeHit
    // as it already is — a no-ball re-arms it to true; a wide leaves it
    // untouched so the batter still gets their free-hit legal delivery.
    final bool newFreeHit = consumesBall
        ? false  // Legal delivery consumed — free hit is used up
        : (event.extra == ExtraType.noBall ? true : _state.isFreeHit);

    _state = _state.copyWith(
       striker: newStriker,
       nonStriker: nonStriker,
       currentBowler: newBowler,
       battingTeam: updatedBattingTeam,
       bowlingTeam: updatedBowlingTeam,
       totalRuns: _state.totalRuns + runAccumulatorForBatter + extraRunsPenalty,
       wickets: _state.wickets + wicketsToAdd,
       balls: _state.balls + (consumesBall ? 1 : 0),
       isFreeHit: newFreeHit,
    );


    // Strike Rotation resolution
    int runsCrossed = runAccumulatorForBatter;
    if (event.extra == ExtraType.bye || event.extra == ExtraType.legBye) runsCrossed = extraRunsPenalty;
    
    // Resolve crossing
    bool shouldSwap = false;
    if (runsCrossed % 2 == 1) shouldSwap = true;
    if (event.crossedBeforeThrow) shouldSwap = !shouldSwap;

    // Apply swap (Only if non-striker exists and is not out)
    if (shouldSwap && _state.nonStriker != null && !_state.nonStriker!.isOut) {
       Player? temp = _state.striker;
       _state = _state.copyWith(striker: _state.nonStriker, nonStriker: temp);
    }

    // Inject New Batter
    if (event.newBatterName != null) {
      Player newBat = _state.battingTeam.firstWhere((p) => p.name == event.newBatterName).copyWith(hasBatted: true, status: PlayerStatus.batter);
      _state = _state.copyWith(battingTeam: _updateBattingPlayer(newBat));
      
      bool strikerWasOut = newStriker.isOut;
      
      if (strikerWasOut) {
        if (event.newBatterOnStrike) {
          _state = _state.copyWith(striker: newBat);
        } else {
          _state = _state.copyWith(striker: _state.nonStriker, nonStriker: newBat);
        }
      } else {
        if (event.newBatterOnStrike) {
           _state = _state.copyWith(nonStriker: _state.striker, striker: newBat);
        } else {
           _state = _state.copyWith(nonStriker: newBat);
        }
      }
    }

    _state = _state.copyWith(partnership: Partnership(
        batsman1: _state.striker!,
        batsman2: _state.nonStriker!,
        runs: newPartnership.runs + runAccumulatorForBatter + extraRunsPenalty,
        balls: newPartnership.balls + (consumesBall ? 1 : 0),
    ));

    final ball = BallEvent(
      id: const Uuid().v4(),
      runs: totalPhysicalRunsOffBat,
      extraType: event.extra,
      extraRuns: extraRunsPenalty + overthrowRuns, 
      overNumber: _state.overs,
      ballNumber: _state.balls,
      strikerName: newStriker.name,
      nonStrikerName: nonStriker.name,
      bowlerName: newBowler.name,
      isLegalDelivery: consumesBall,
      // B3: Keep first wicket in legacy fields for backward compatibility,
      // but also store full list of all wickets on this delivery.
      dismissalType: event.wickets.isNotEmpty ? event.wickets.first.type : null,
      batterOutName: event.wickets.isNotEmpty ? event.wickets.first.outPlayerName : null,
      wicketsList: event.wickets,
    );

    _state = _state.copyWith(
       ballHistory: List.from(_state.ballHistory)..add(ball),
       currentOverBalls: List.from(_state.currentOverBalls)..add(ball),
    );

    _updateMatchPhase();
    if (_state.balls == 6) _completeOver();
    
    _checkMatchEnd();
  }

  // B7: Format-aware match phase thresholds derived from maxOvers.
  // Powerplay = first ~30% of overs, Death = last ~25%, Middle = remainder.
  void _updateMatchPhase() {
     final int currentOver = _state.overs;
     final int totalOvers = _state.matchConfig.maxOvers;
     
     // Derive thresholds proportionally
     final int powerplayEnd = (totalOvers * 0.30).ceil().clamp(1, totalOvers);
     final int deathStart = (totalOvers * 0.75).floor().clamp(powerplayEnd, totalOvers);

     String newPhase = 'MIDDLE';
     if (currentOver < powerplayEnd) {
       newPhase = 'POWERPLAY';
     } else if (currentOver >= deathStart) {
       newPhase = 'DEATH';
     }
     if (_state.currentPhase != newPhase) {
       _state = _state.copyWith(currentPhase: newPhase);
     }
  }

  void _rotateStrikeInternally() {
    if (!_state.matchConfig.isFormalRules && _state.wickets == _state.battingTeam.length - 1) {
       return; 
    }
    // Only swap if we have a valid partner
    if (_state.nonStriker == null || _state.nonStriker!.isOut) return;

    Player? temp = _state.striker;
    _state = _state.copyWith(striker: _state.nonStriker, nonStriker: temp);
  }

  void _completeOver() {
    bool isMaiden = false;
    int runInOver = 0;
    for (var ball in _state.currentOverBalls) {
       runInOver += ball.runs;
       if (ball.extraType == ExtraType.wide || ball.extraType == ExtraType.noBall) {
         runInOver += ball.extraRuns;
       }
    }
    if (runInOver == 0 && _state.currentOverBalls.isNotEmpty) isMaiden = true;

    final oldBowler = _state.currentBowler!;
    final newBowler = oldBowler.copyWith(maidens: oldBowler.maidens + (isMaiden ? 1 : 0));

    _state = _state.copyWith(
      overs: _state.overs + 1,
      balls: 0,
      currentOverBalls: [],
      currentBowler: newBowler,
      bowlingTeam: _updateBowlingPlayer(newBowler),
    );
    _rotateStrikeInternally();
  }

  // A1: teamSize is explicitly the number of players in the batting squad
  // (i.e. squadLimit — the playing XI size), NOT including substitutes.
  // maxWickets is derived from this: formal rules = teamSize - 1 (standard
  // cricket all-out at 10 wickets for 11 players), Last Man Standing = teamSize.
  int get maxWickets {
    final bool isFormal = _state.matchConfig.isFormalRules;
    final int teamSize = _state.battingTeam.length; // squadLimit players
    return isFormal ? (teamSize - 1) : teamSize;
  }

  void _checkMatchEnd() {
    final int mw = maxWickets;

    if (_state.inningsNumber == 1) {
       if (_state.wickets >= mw || (_state.overs >= _state.matchConfig.maxOvers && _state.balls == 0)) {
           _state = _state.copyWith(matchStatus: 'INNINGS_BREAK');
       }
    } else if (_state.inningsNumber == 2) {
       bool targetReached = (_state.targetScore != null && _state.totalRuns >= _state.targetScore!);
       bool allOut = (_state.wickets >= mw);
       bool oversFinished = (_state.overs >= _state.matchConfig.maxOvers && _state.balls == 0);

       if (targetReached) {
           _state = _state.copyWith(matchStatus: 'MATCH_COMPLETED', matchResult: '${_state.matchConfig.battingTeamName} won');
       } else if (allOut || oversFinished) {
           if (_state.targetScore != null && _state.totalRuns == _state.targetScore! - 1) {
               _state = _state.copyWith(matchStatus: 'TIE', matchResult: 'Match Tied! Super Over?');
           } else {
               _state = _state.copyWith(matchStatus: 'MATCH_COMPLETED', matchResult: '${_state.matchConfig.bowlingTeamName} won');
           }
       }
    }
  }

  void startSuperOver() {
     _history.clear();
     _state = MatchState(
       totalRuns: 0,
       wickets: 0,
       overs: 0,
       balls: 0,
       inningsNumber: 3, // Super Over 1
       matchStatus: 'LIVE_SUPER_OVER_1', 
       battingTeam: _state.battingTeam.map((p) => p.copyWith(runs: 0, ballsFaced: 0, status: PlayerStatus.batter)).toList(), 
       bowlingTeam: _state.bowlingTeam.map((p) => p.copyWith(ballsBowled: 0, runsConceded: 0, wicketsTaken: 0)).toList(), 
       ballHistory: [],
       currentOverBalls: [],
       matchConfig: _state.matchConfig.copyWith(
         maxOvers: 1, // 1 over only
         // Team names don't inherently swap for a Super Over, depends on rules, but keeping them same for now.
       ), 
     );
  }

  void startSecondInnings() {
     _history.clear();
     int target = _state.totalRuns + 1;
     _state = MatchState(
       totalRuns: 0,
       wickets: 0,
       overs: 0,
       balls: 0,
       inningsNumber: 2,
       targetScore: target,
       matchStatus: 'LIVE_INNINGS_2', 
       battingTeam: _state.bowlingTeam, 
       bowlingTeam: _state.battingTeam, 
       ballHistory: [],
       currentOverBalls: [],
       matchConfig: _state.matchConfig.copyWith(
         battingTeamName: _state.matchConfig.bowlingTeamName,
         bowlingTeamName: _state.matchConfig.battingTeamName,
       ),
     );
  }
}
