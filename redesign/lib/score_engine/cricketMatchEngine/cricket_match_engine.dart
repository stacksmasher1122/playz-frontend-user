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

  void _saveSnapshot() {
    _history.add(MatchState.fromJson(_state.toJson()));
  }

  void undo() {
    if (_history.isNotEmpty) {
      _state = _history.removeLast();
    }
  }

  void restoreState(Map<String, dynamic> json) {
    _state = MatchState.fromJson(json);
    _history.clear();
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
      "fallOfWickets": [], // Natively parsed later UI level
      "result": _state.matchStatus == 'MATCH_COMPLETED' ? "completed" : "in_progress",
    };
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
    if (_state.currentBowler?.name == newBowlerName) {
      throw Exception('Bowler cannot bowl consecutive overs');
    }
    
    final bowler = _state.bowlingTeam.firstWhere((p) => p.name == newBowlerName);
    if (bowler.ballsBowled >= _state.matchConfig.maxOversPerBowler * 6) {
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
      currentBowler: newBowling.firstWhere((p) => p.name == newBowlerName),
    );
  }

  List<Player> _updateBattingPlayer(Player updatedPlayer) {
    return _state.battingTeam.map((p) => p.name == updatedPlayer.name ? updatedPlayer : p).toList();
  }

  List<Player> _updateBowlingPlayer(Player updatedPlayer) {
    return _state.bowlingTeam.map((p) => p.name == updatedPlayer.name ? updatedPlayer : p).toList();
  }

  // -------------------------------------------------------------
  // EVENT REDUCER
  // -------------------------------------------------------------
  void dispatch(MatchEvent event) {
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
    if (event.extra == ExtraType.wide || event.extra == ExtraType.noBall) {
      extraRunsPenalty = 1;
    } else if (event.extra == ExtraType.bye || event.extra == ExtraType.legBye) {
      extraRunsPenalty = totalPhysicalRunsOffBat + overthrowRuns;
      totalPhysicalRunsOffBat = 0;
      overthrowRuns = 0;
    } else if (event.extra == ExtraType.penalty) {
      extraRunsPenalty = totalPhysicalRunsOffBat; 
      totalPhysicalRunsOffBat = 0;
    }

    int runAccumulatorForBatter = totalPhysicalRunsOffBat + overthrowRuns;
    int runAccumulatorForBowler = totalPhysicalRunsOffBat + overthrowRuns + extraRunsPenalty;

    // Byes/Legbyes do not credit bowler
    if (event.extra == ExtraType.bye || event.extra == ExtraType.legBye || event.extra == ExtraType.penalty) {
      runAccumulatorForBowler = extraRunsPenalty; // Modifying based on context
      if (event.extra != ExtraType.penalty) runAccumulatorForBowler -= extraRunsPenalty; // Usually Byes are not given to bowler ER
    }

    // Apply Striker metrics
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
       if (_state.isFreeHit && [DismissalType.bowled, DismissalType.caught, DismissalType.lbw, DismissalType.stumped].contains(w.type)) {
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

    _state = _state.copyWith(
       striker: newStriker,
       nonStriker: nonStriker,
       currentBowler: newBowler,
       battingTeam: updatedBattingTeam,
       bowlingTeam: updatedBowlingTeam,
       totalRuns: _state.totalRuns + runAccumulatorForBatter + extraRunsPenalty,
       wickets: _state.wickets + wicketsToAdd,
       balls: _state.balls + (consumesBall ? 1 : 0),
       isFreeHit: event.extra == ExtraType.noBall ? true : false,
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
      dismissalType: event.wickets.isNotEmpty ? event.wickets.first.type : null,
      batterOutName: event.wickets.isNotEmpty ? event.wickets.first.outPlayerName : null,
    );

    _state = _state.copyWith(
       ballHistory: List.from(_state.ballHistory)..add(ball),
       currentOverBalls: List.from(_state.currentOverBalls)..add(ball),
    );

    _updateMatchPhase();
    if (_state.balls == 6) _completeOver();
    
    _checkMatchEnd();
  }

  void _updateMatchPhase() {
     int currentOver = _state.overs;
     String newPhase = 'MIDDLE';
     if (currentOver < 6) {
       newPhase = 'POWERPLAY';
     } else if (currentOver >= 15) {
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

  void _checkMatchEnd() {
    bool isFormal = _state.matchConfig.isFormalRules;
    int teamSize = _state.battingTeam.length;
    int maxWickets = isFormal ? (teamSize - 1) : teamSize;

    if (_state.inningsNumber == 1) {
       if (_state.wickets >= maxWickets || (_state.overs >= _state.matchConfig.maxOvers && _state.balls == 0)) {
           _state = _state.copyWith(matchStatus: 'INNINGS_BREAK');
       }
    } else if (_state.inningsNumber == 2) {
       bool targetReached = (_state.targetScore != null && _state.totalRuns >= _state.targetScore!);
       bool allOut = (_state.wickets >= maxWickets);
       bool oversFinished = (_state.overs >= _state.matchConfig.maxOvers && _state.balls == 0);

       if (targetReached) {
           _state = _state.copyWith(matchStatus: 'MATCH_COMPLETED', matchResult: '${_state.battingTeam[0].name} won');
       } else if (allOut || oversFinished) {
           if (_state.targetScore != null && _state.totalRuns == _state.targetScore! - 1) {
               _state = _state.copyWith(matchStatus: 'TIE', matchResult: 'Match Tied! Super Over?');
           } else {
               _state = _state.copyWith(matchStatus: 'MATCH_COMPLETED', matchResult: '${_state.bowlingTeam[0].name} won');
           }
       }
    }
  }

  void startSuperOver() {
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
       matchConfig: _state.matchConfig.copyWith(maxOvers: 1), // 1 over only
     );
  }

  void startSecondInnings() {
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
       matchConfig: _state.matchConfig,
     );
  }
}
