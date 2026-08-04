import 'package:uuid/uuid.dart';
import '../../model/User_Models/Home_Models/Scoreboard_Model/Tennis/tennis_state_models.dart';

class TennisMatchEngine {
  late TennisMatchState _state;
  final List<TennisMatchState> _history = [];

  TennisMatchEngine({
    required List<TennisPlayer> sideAPlayers,
    required List<TennisPlayer> sideBPlayers,
    TennisMatchConfig? config,
    String tossWinner = '',
    String tossDecision = '',
  }) {
    final matchConfig = config ?? const TennisMatchConfig();

    // Determine initial server based on toss
    String initialServer = 'A';
    if (tossWinner.isNotEmpty) {
      if (tossDecision == 'serve') {
        initialServer = tossWinner == 'A' ? 'A' : 'B';
      } else if (tossDecision == 'receive') {
        initialServer = tossWinner == 'A' ? 'B' : 'A';
      }
    }

    _state = TennisMatchState(
      sideAPlayers: sideAPlayers,
      sideBPlayers: sideBPlayers,
      matchConfig: matchConfig,
      servingSide: initialServer,
      servingPlayerIndex: 0,
      servingCourt: 'DEUCE',
      matchStatus: 'INITIALIZING',
      setScores: [
        const SetScore(setNumber: 1),
      ],
      tossWinner: tossWinner,
      tossDecision: tossDecision,
    );
  }

  TennisMatchState get state => _state;
  bool get canUndo => _history.isNotEmpty;
  int get undoCount => _history.length;

  void _saveSnapshot() {
    _history.add(TennisMatchState.fromJson(_state.toJson()));
  }

  bool undo() {
    if (_history.isNotEmpty) {
      _state = _history.removeLast();
      return true;
    }
    return false;
  }

  void restoreState(Map<String, dynamic> json) {
    _state = TennisMatchState.fromJson(json);
    _history.clear();
  }

  void patchState(Map<String, dynamic> json) {
    _state = TennisMatchState.fromJson(json);
  }

  void startMatch() {
    if (_state.matchStatus == 'COMPLETED' || _state.matchStatus == 'RETIRED') {
      return;
    }
    _saveSnapshot();
    _state = _state.copyWith(matchStatus: 'LIVE');
  }

  /// Records a point won by side 'A' or 'B'
  void recordPoint({
    required String winnerSide,
    String outcomeType = 'normalPoint', // 'normalPoint', 'ace', 'winner', 'unforcedError', 'doubleFault', etc.
  }) {
    if (_state.matchStatus == 'COMPLETED' || _state.matchStatus == 'RETIRED') {
      throw StateError('Cannot record points on a completed or retired match.');
    }

    _saveSnapshot();

    // 1. Update player stats based on outcome type
    final newSideA = List<TennisPlayer>.from(_state.sideAPlayers);
    final newSideB = List<TennisPlayer>.from(_state.sideBPlayers);

    final serverList = _state.servingSide == 'A' ? newSideA : newSideB;
    final serverIdx = _state.servingPlayerIndex % serverList.length;
    final server = serverList[serverIdx];

    // First serve in stats tracking
    if (!_state.isSecondServe && outcomeType != 'let') {
      serverList[serverIdx] = server.copyWith(
        firstServesTotal: server.firstServesTotal + 1,
        firstServesIn: outcomeType != 'fault' && outcomeType != 'doubleFault'
            ? server.firstServesIn + 1
            : server.firstServesIn,
      );
    }

    if (outcomeType == 'ace') {
      serverList[serverIdx] = serverList[serverIdx].copyWith(
        aces: serverList[serverIdx].aces + 1,
        pointsWon: serverList[serverIdx].pointsWon + 1,
      );
    } else if (outcomeType == 'doubleFault') {
      serverList[serverIdx] = serverList[serverIdx].copyWith(
        doubleFaults: serverList[serverIdx].doubleFaults + 1,
      );
    }

    // Award point winner stats
    final winnerList = winnerSide == 'A' ? newSideA : newSideB;
    if (winnerList.isNotEmpty) {
      final wIdx = 0; // Primary player or default
      winnerList[wIdx] = winnerList[wIdx].copyWith(
        pointsWon: winnerList[wIdx].pointsWon + 1,
        winners: outcomeType == 'winner' ? winnerList[wIdx].winners + 1 : winnerList[wIdx].winners,
      );
    }

    // Unforced errors for loser
    if (outcomeType == 'unforcedError') {
      final loserList = winnerSide == 'A' ? newSideB : newSideA;
      if (loserList.isNotEmpty) {
        loserList[0] = loserList[0].copyWith(
          unforcedErrors: loserList[0].unforcedErrors + 1,
        );
      }
    }

    final scoreBefore = _formatCurrentScoreDisplay();

    // Reset second serve flag on point scored
    bool nextIsSecondServe = false;

    if (_state.isTiebreak || _state.isMatchTiebreak) {
      _processTiebreakPoint(winnerSide, newSideA, newSideB, scoreBefore, outcomeType);
    } else {
      _processNormalPoint(winnerSide, newSideA, newSideB, scoreBefore, outcomeType, nextIsSecondServe);
    }
  }

  void recordFault() {
    if (_state.matchStatus == 'COMPLETED' || _state.matchStatus == 'RETIRED') {
      return;
    }

    if (_state.isSecondServe) {
      // Second serve fault = Double Fault -> point awarded to receiver!
      final receiverSide = _state.servingSide == 'A' ? 'B' : 'A';
      recordPoint(winnerSide: receiverSide, outcomeType: 'doubleFault');
    } else {
      // First serve fault
      _saveSnapshot();

      final newSideA = List<TennisPlayer>.from(_state.sideAPlayers);
      final newSideB = List<TennisPlayer>.from(_state.sideBPlayers);

      final serverList = _state.servingSide == 'A' ? newSideA : newSideB;
      final serverIdx = _state.servingPlayerIndex % serverList.length;
      final server = serverList[serverIdx];
      serverList[serverIdx] = server.copyWith(
        firstServesTotal: server.firstServesTotal + 1,
      );

      _state = _state.copyWith(
        isSecondServe: true,
        sideAPlayers: newSideA,
        sideBPlayers: newSideB,
      );
    }
  }

  void recordLet() {
    if (_state.matchStatus == 'COMPLETED' || _state.matchStatus == 'RETIRED') {
      return;
    }
    _saveSnapshot();
    // A let replays the point with no score or server state change
    final event = TennisPointEvent(
      id: const Uuid().v4(),
      winnerSide: _state.servingSide,
      outcomeType: 'let',
      serverSide: _state.servingSide,
      serverPlayerIndex: _state.servingPlayerIndex,
      servingCourt: _state.servingCourt,
      isSecondServe: _state.isSecondServe,
      setNumber: _state.currentSetIndex + 1,
      gameNumberInSet: _getCurrentSetGamesTotal() + 1,
      scoreBefore: _formatCurrentScoreDisplay(),
      scoreAfter: _formatCurrentScoreDisplay(),
    );

    _state = _state.copyWith(
      history: [..._state.history, event],
    );
  }

  void retirePlayer({required String retiringSide}) {
    if (_state.matchStatus == 'COMPLETED' || _state.matchStatus == 'RETIRED') {
      return;
    }
    _saveSnapshot();

    final winningSide = retiringSide == 'A' ? 'B' : 'A';
    final winningTeamName = winningSide == 'A'
        ? _state.matchConfig.homeTeamName
        : _state.matchConfig.awayTeamName;
    final retiringTeamName = retiringSide == 'A'
        ? _state.matchConfig.homeTeamName
        : _state.matchConfig.awayTeamName;

    final resultStr = '$winningTeamName won (ret. $retiringTeamName)';

    _state = _state.copyWith(
      matchStatus: 'RETIRED',
      matchResult: resultStr,
      sideASetsWon: winningSide == 'A' ? _state.matchConfig.setsToWin : _state.sideASetsWon,
      sideBSetsWon: winningSide == 'B' ? _state.matchConfig.setsToWin : _state.sideBSetsWon,
    );
  }

  void changeServer() {
    _saveSnapshot();
    final nextSide = _state.servingSide == 'A' ? 'B' : 'A';
    _state = _state.copyWith(
      servingSide: nextSide,
      isSecondServe: false,
    );
  }

  // ════════════════════ PRIVATE ENGINE LOGIC ════════════════════

  void _processNormalPoint(
    String winnerSide,
    List<TennisPlayer> sideAPlayers,
    List<TennisPlayer> sideBPlayers,
    String scoreBefore,
    String outcomeType,
    bool nextIsSecondServe,
  ) {
    int pA = _state.sideAPointCount;
    int pB = _state.sideBPointCount;

    if (winnerSide == 'A') {
      pA++;
    } else {
      pB++;
    }

    String sA = '0';
    String sB = '0';
    bool gameWon = false;
    String? gameWinner;

    if (_state.matchConfig.noAdScoring && pA >= 3 && pB >= 3) {
      // No-Ad scoring at 40-40 (3-3 points): next point wins game directly!
      if (pA > pB) {
        gameWon = true;
        gameWinner = 'A';
      } else if (pB > pA) {
        gameWon = true;
        gameWinner = 'B';
      }
    } else {
      // Standard Advantage scoring
      if (pA >= 4 || pB >= 4) {
        final diff = pA - pB;
        if (diff >= 2) {
          gameWon = true;
          gameWinner = 'A';
        } else if (diff <= -2) {
          gameWon = true;
          gameWinner = 'B';
        } else if (diff == 1) {
          sA = 'AD';
          sB = '40';
        } else if (diff == -1) {
          sA = '40';
          sB = 'AD';
        } else {
          // Deuce
          sA = '40';
          sB = '40';
        }
      } else {
        sA = _pointCountToScore(pA);
        sB = _pointCountToScore(pB);
      }
    }

    if (gameWon && gameWinner != null) {
      _onGameWon(gameWinner, sideAPlayers, sideBPlayers, scoreBefore, outcomeType);
    } else {
      // Game continues
      final totalPts = pA + pB;
      final court = (totalPts % 2 == 0) ? 'DEUCE' : 'AD';

      final event = TennisPointEvent(
        id: const Uuid().v4(),
        winnerSide: winnerSide,
        outcomeType: outcomeType,
        serverSide: _state.servingSide,
        serverPlayerIndex: _state.servingPlayerIndex,
        servingCourt: _state.servingCourt,
        isSecondServe: _state.isSecondServe,
        setNumber: _state.currentSetIndex + 1,
        gameNumberInSet: _getCurrentSetGamesTotal() + 1,
        scoreBefore: scoreBefore,
        scoreAfter: '$sA-$sB',
      );

      _state = _state.copyWith(
        sideAPointScore: sA,
        sideBPointScore: sB,
        sideAPointCount: pA,
        sideBPointCount: pB,
        servingCourt: court,
        isSecondServe: false,
        sideAPlayers: sideAPlayers,
        sideBPlayers: sideBPlayers,
        history: [..._state.history, event],
      );
    }
  }

  void _onGameWon(
    String gameWinner,
    List<TennisPlayer> sideAPlayers,
    List<TennisPlayer> sideBPlayers,
    String scoreBefore,
    String outcomeType,
  ) {
    List<SetScore> currentSets = List<SetScore>.from(_state.setScores);
    if (currentSets.isEmpty) {
      currentSets.add(const SetScore(setNumber: 1));
    }
    SetScore activeSet = currentSets[_state.currentSetIndex];

    int gA = activeSet.sideAGames + (gameWinner == 'A' ? 1 : 0);
    int gB = activeSet.sideBGames + (gameWinner == 'B' ? 1 : 0);

    bool setWon = false;
    String? setWinner;
    bool triggerTiebreak = false;
    bool triggerMatchTiebreak = false;

    final targetGames = _state.matchConfig.gamesPerSet;
    final isFinalSet = (_state.currentSetIndex + 1) == (_state.matchConfig.setsToWin * 2 - 1);

    if (gA == targetGames && gB == targetGames) {
      // 6-6 (or 4-4) tiebreak trigger!
      if (isFinalSet && _state.matchConfig.finalSetFormat == 'MATCH_TIEBREAK_10') {
        triggerMatchTiebreak = true;
      } else if (_state.matchConfig.finalSetFormat == 'ADVANTAGE_SET' && isFinalSet) {
        // Advantage set: keep playing games until lead by 2
      } else {
        triggerTiebreak = true;
      }
    } else {
      if (_state.matchConfig.finalSetFormat == 'ADVANTAGE_SET' && isFinalSet) {
        if (gA >= targetGames && (gA - gB) >= 2) {
          setWon = true;
          setWinner = 'A';
        } else if (gB >= targetGames && (gB - gA) >= 2) {
          setWon = true;
          setWinner = 'B';
        }
      } else {
        if (gA >= targetGames && (gA - gB) >= 2) {
          setWon = true;
          setWinner = 'A';
        } else if (gB >= targetGames && (gB - gA) >= 2) {
          setWon = true;
          setWinner = 'B';
        }
      }
    }

    activeSet = activeSet.copyWith(
      sideAGames: gA,
      sideBGames: gB,
      isTiebreak: triggerTiebreak || triggerMatchTiebreak,
    );
    currentSets[_state.currentSetIndex] = activeSet;

    // Standard ends switch logic: after game 1, 3, 5, 7...
    final totalGamesInSet = gA + gB;
    final isOddGame = totalGamesInSet % 2 == 1;

    // Alternate serve side for next game
    final nextServerSide = _state.servingSide == 'A' ? 'B' : 'A';
    int nextServerIdx = _state.servingPlayerIndex;
    if (_state.matchConfig.format == 'DOUBLES') {
      // Toggle doubles server index
      if (nextServerSide == 'A') {
        nextServerIdx = (nextServerIdx + 1) % sideAPlayers.length;
      } else {
        nextServerIdx = (nextServerIdx + 1) % sideBPlayers.length;
      }
    }

    final event = TennisPointEvent(
      id: const Uuid().v4(),
      winnerSide: gameWinner,
      outcomeType: outcomeType,
      serverSide: _state.servingSide,
      serverPlayerIndex: _state.servingPlayerIndex,
      servingCourt: _state.servingCourt,
      isSecondServe: _state.isSecondServe,
      setNumber: _state.currentSetIndex + 1,
      gameNumberInSet: totalGamesInSet,
      scoreBefore: scoreBefore,
      scoreAfter: 'Game $gameWinner ($gA-$gB)',
    );

    if (setWon && setWinner != null) {
      activeSet = activeSet.copyWith(isCompleted: true, winnerSide: setWinner);
      currentSets[_state.currentSetIndex] = activeSet;
      _onSetWon(setWinner, currentSets, sideAPlayers, sideBPlayers, event, isOddGame);
    } else {
      _state = _state.copyWith(
        sideAPointScore: '0',
        sideBPointScore: '0',
        sideAPointCount: 0,
        sideBPointCount: 0,
        isTiebreak: triggerTiebreak,
        isMatchTiebreak: triggerMatchTiebreak,
        setScores: currentSets,
        servingSide: nextServerSide,
        servingPlayerIndex: nextServerIdx,
        servingCourt: 'DEUCE',
        isSecondServe: false,
        isEndsSwitched: isOddGame ? !_state.isEndsSwitched : _state.isEndsSwitched,
        sideAPlayers: sideAPlayers,
        sideBPlayers: sideBPlayers,
        history: [..._state.history, event],
      );
    }
  }

  void _processTiebreakPoint(
    String winnerSide,
    List<TennisPlayer> sideAPlayers,
    List<TennisPlayer> sideBPlayers,
    String scoreBefore,
    String outcomeType,
  ) {
    int tbA = _state.sideATiebreakPoints;
    int tbB = _state.sideBTiebreakPoints;

    if (winnerSide == 'A') {
      tbA++;
    } else {
      tbB++;
    }

    final target = _state.isMatchTiebreak ? 10 : _state.matchConfig.tiebreakTarget;
    bool tbWon = false;
    String? tbWinner;

    if (tbA >= target && (tbA - tbB) >= 2) {
      tbWon = true;
      tbWinner = 'A';
    } else if (tbB >= target && (tbB - tbA) >= 2) {
      tbWon = true;
      tbWinner = 'B';
    }

    final totalTbPts = tbA + tbB;

    // Tiebreak serve rotation: Server 1 serves 1 pt, then alternate server every 2 pts
    String nextServerSide = _state.servingSide;
    if (totalTbPts % 2 == 1) {
      nextServerSide = _state.servingSide == 'A' ? 'B' : 'A';
    }

    // Tiebreak court alternate: odd total pts = AD court, even total pts = DEUCE court
    final nextCourt = (totalTbPts % 2 == 0) ? 'DEUCE' : 'AD';

    // Tiebreak ends switch: every 6 total points
    final switchEnds = (totalTbPts % 6 == 0) && totalTbPts > 0;

    final event = TennisPointEvent(
      id: const Uuid().v4(),
      winnerSide: winnerSide,
      outcomeType: outcomeType,
      serverSide: _state.servingSide,
      serverPlayerIndex: _state.servingPlayerIndex,
      servingCourt: _state.servingCourt,
      isSecondServe: _state.isSecondServe,
      setNumber: _state.currentSetIndex + 1,
      gameNumberInSet: _getCurrentSetGamesTotal() + 1,
      scoreBefore: scoreBefore,
      scoreAfter: '$tbA-$tbB (Tiebreak)',
    );

    if (tbWon && tbWinner != null) {
      List<SetScore> currentSets = List<SetScore>.from(_state.setScores);
      SetScore activeSet = currentSets[_state.currentSetIndex];
      int gA = activeSet.sideAGames + (tbWinner == 'A' ? 1 : 0);
      int gB = activeSet.sideBGames + (tbWinner == 'B' ? 1 : 0);

      activeSet = activeSet.copyWith(
        sideAGames: gA,
        sideBGames: gB,
        tiebreakSideAPoints: tbA,
        tiebreakSideBPoints: tbB,
        isCompleted: true,
        winnerSide: tbWinner,
      );
      currentSets[_state.currentSetIndex] = activeSet;

      _onSetWon(tbWinner, currentSets, sideAPlayers, sideBPlayers, event, switchEnds);
    } else {
      // Update ongoing tiebreak set score
      List<SetScore> currentSets = List<SetScore>.from(_state.setScores);
      currentSets[_state.currentSetIndex] = currentSets[_state.currentSetIndex].copyWith(
        tiebreakSideAPoints: tbA,
        tiebreakSideBPoints: tbB,
      );

      _state = _state.copyWith(
        sideATiebreakPoints: tbA,
        sideBTiebreakPoints: tbB,
        sideAPointScore: '$tbA',
        sideBPointScore: '$tbB',
        setScores: currentSets,
        servingSide: nextServerSide,
        servingCourt: nextCourt,
        isSecondServe: false,
        isEndsSwitched: switchEnds ? !_state.isEndsSwitched : _state.isEndsSwitched,
        sideAPlayers: sideAPlayers,
        sideBPlayers: sideBPlayers,
        history: [..._state.history, event],
      );
    }
  }

  void _onSetWon(
    String setWinner,
    List<SetScore> currentSets,
    List<TennisPlayer> sideAPlayers,
    List<TennisPlayer> sideBPlayers,
    TennisPointEvent event,
    bool switchEnds,
  ) {
    int setsA = _state.sideASetsWon + (setWinner == 'A' ? 1 : 0);
    int setsB = _state.sideBSetsWon + (setWinner == 'B' ? 1 : 0);

    bool matchWon = false;
    final requiredSets = _state.matchConfig.setsToWin;

    if (setsA >= requiredSets || setsB >= requiredSets) {
      matchWon = true;
    }

    if (matchWon) {
      final winnerTeamName = setWinner == 'A'
          ? _state.matchConfig.homeTeamName
          : _state.matchConfig.awayTeamName;
      final resultStr = '$winnerTeamName won ${_formatMatchResultSummary(currentSets)}';

      _state = _state.copyWith(
        sideASetsWon: setsA,
        sideBSetsWon: setsB,
        setScores: currentSets,
        matchStatus: 'COMPLETED',
        matchResult: resultStr,
        sideAPointScore: '0',
        sideBPointScore: '0',
        isTiebreak: false,
        isMatchTiebreak: false,
        isSecondServe: false,
        sideAPlayers: sideAPlayers,
        sideBPlayers: sideBPlayers,
        history: [..._state.history, event],
      );
    } else {
      // Advance to next set
      final nextSetIdx = _state.currentSetIndex + 1;
      currentSets.add(SetScore(setNumber: nextSetIdx + 1));

      final nextServerSide = _state.servingSide == 'A' ? 'B' : 'A';

      _state = _state.copyWith(
        sideASetsWon: setsA,
        sideBSetsWon: setsB,
        currentSetIndex: nextSetIdx,
        setScores: currentSets,
        sideAPointScore: '0',
        sideBPointScore: '0',
        sideAPointCount: 0,
        sideBPointCount: 0,
        sideATiebreakPoints: 0,
        sideBTiebreakPoints: 0,
        isTiebreak: false,
        isMatchTiebreak: false,
        servingSide: nextServerSide,
        servingCourt: 'DEUCE',
        isSecondServe: false,
        isEndsSwitched: switchEnds ? !_state.isEndsSwitched : _state.isEndsSwitched,
        sideAPlayers: sideAPlayers,
        sideBPlayers: sideBPlayers,
        history: [..._state.history, event],
      );
    }
  }

  String _pointCountToScore(int pts) {
    switch (pts) {
      case 0:
        return '0';
      case 1:
        return '15';
      case 2:
        return '30';
      case 3:
        return '40';
      default:
        return '40';
    }
  }

  String _formatCurrentScoreDisplay() {
    if (_state.isTiebreak || _state.isMatchTiebreak) {
      return '${_state.sideATiebreakPoints}-${_state.sideBTiebreakPoints}';
    }
    return '${_state.sideAPointScore}-${_state.sideBPointScore}';
  }

  int _getCurrentSetGamesTotal() {
    if (_state.setScores.isEmpty || _state.currentSetIndex >= _state.setScores.length) {
      return 0;
    }
    final s = _state.setScores[_state.currentSetIndex];
    return s.sideAGames + s.sideBGames;
  }

  String _formatMatchResultSummary(List<SetScore> sets) {
    final parts = <String>[];
    for (final s in sets) {
      if (s.isCompleted) {
        if (s.tiebreakSideAPoints > 0 || s.tiebreakSideBPoints > 0) {
          final loserTb = s.winnerSide == 'A' ? s.tiebreakSideBPoints : s.tiebreakSideAPoints;
          parts.add('${s.sideAGames}-${s.sideBGames}($loserTb)');
        } else {
          parts.add('${s.sideAGames}-${s.sideBGames}');
        }
      }
    }
    return parts.join(', ');
  }
}
