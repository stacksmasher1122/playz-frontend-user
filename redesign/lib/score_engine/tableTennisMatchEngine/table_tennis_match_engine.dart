import 'package:uuid/uuid.dart';
import '../../model/User_Models/Home_Models/Scoreboard_Model/Table_Tennis/table_tennis_state_models.dart';

class TableTennisMatchEngine {
  late TableTennisMatchState _state;
  final List<TableTennisMatchState> _history = [];

  TableTennisMatchEngine({
    required List<TableTennisPlayer> sideAPlayers,
    required List<TableTennisPlayer> sideBPlayers,
    TableTennisMatchConfig? config,
    String tossWinner = '',
    String tossDecision = '',
  }) {
    final matchConfig = config ?? const TableTennisMatchConfig();

    String initialServer = 'A';
    if (tossWinner.isNotEmpty) {
      if (tossDecision == 'serve') {
        initialServer = tossWinner == 'A' ? 'A' : 'B';
      } else if (tossDecision == 'receive') {
        initialServer = tossWinner == 'A' ? 'B' : 'A';
      }
    }

    _state = TableTennisMatchState(
      sideAPlayers: sideAPlayers,
      sideBPlayers: sideBPlayers,
      matchConfig: matchConfig,
      servingSide: initialServer,
      gameInitialServer: initialServer,
      servingPlayerIndex: 0,
      receivingPlayerIndex: 0,
      serveCount: 0,
      matchStatus: 'INITIALIZING',
      gameScores: const [
        GameScore(gameNumber: 1),
      ],
      tossWinner: tossWinner,
      tossDecision: tossDecision,
    );
  }

  TableTennisMatchState get state => _state;
  bool get canUndo => _history.isNotEmpty;
  int get undoCount => _history.length;

  void _saveSnapshot() {
    _history.add(TableTennisMatchState.fromJson(_state.toJson()));
  }

  bool undo() {
    if (_history.isNotEmpty) {
      _state = _history.removeLast();
      return true;
    }
    return false;
  }

  void restoreState(Map<String, dynamic> json) {
    _state = TableTennisMatchState.fromJson(json);
    _history.clear();
  }

  void patchState(Map<String, dynamic> json) {
    _state = TableTennisMatchState.fromJson(json);
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
    String outcomeType = 'normalPoint', // 'normalPoint', 'ace', 'serviceFault', 'let', 'edgeBall', 'unforcedError'
  }) {
    if (_state.matchStatus == 'COMPLETED' || _state.matchStatus == 'RETIRED') {
      throw StateError('Cannot record points on a completed or retired match.');
    }

    _saveSnapshot();

    // 1. Update player stats attributed to active players on court
    final newSideA = List<TableTennisPlayer>.from(_state.sideAPlayers);
    final newSideB = List<TableTennisPlayer>.from(_state.sideBPlayers);

    final winnerList = winnerSide == 'A' ? newSideA : newSideB;
    if (winnerList.isNotEmpty) {
      final winnerIdx = winnerSide == _state.servingSide
          ? _state.servingPlayerIndex % winnerList.length
          : _state.receivingPlayerIndex % winnerList.length;

      winnerList[winnerIdx] = winnerList[winnerIdx].copyWith(
        pointsWon: winnerList[winnerIdx].pointsWon + 1,
        aces: outcomeType == 'ace'
            ? winnerList[winnerIdx].aces + 1
            : winnerList[winnerIdx].aces,
        edgeBalls: outcomeType == 'edgeBall'
            ? winnerList[winnerIdx].edgeBalls + 1
            : winnerList[winnerIdx].edgeBalls,
      );
    }

    if (outcomeType == 'unforcedError') {
      final loserList = winnerSide == 'A' ? newSideB : newSideA;
      if (loserList.isNotEmpty) {
        final loserSide = winnerSide == 'A' ? 'B' : 'A';
        final loserIdx = loserSide == _state.servingSide
            ? _state.servingPlayerIndex % loserList.length
            : _state.receivingPlayerIndex % loserList.length;

        loserList[loserIdx] = loserList[loserIdx].copyWith(
          unforcedErrors: loserList[loserIdx].unforcedErrors + 1,
        );
      }
    }

    final scoreBefore = '${_state.sideAPoints}-${_state.sideBPoints}';
    _processPoint(winnerSide, newSideA, newSideB, scoreBefore, outcomeType);
  }

  /// In Table Tennis, a Service Fault awards the point to the receiver immediately
  void recordServiceFault() {
    if (_state.matchStatus == 'COMPLETED' || _state.matchStatus == 'RETIRED') {
      return;
    }
    final receiverSide = _state.servingSide == 'A' ? 'B' : 'A';

    // Track service fault stat for server before recording point
    final newSideA = List<TableTennisPlayer>.from(_state.sideAPlayers);
    final newSideB = List<TableTennisPlayer>.from(_state.sideBPlayers);
    final serverList = _state.servingSide == 'A' ? newSideA : newSideB;
    final serverIdx = _state.servingPlayerIndex % serverList.length;
    serverList[serverIdx] = serverList[serverIdx].copyWith(
      serviceFaults: serverList[serverIdx].serviceFaults + 1,
    );

    recordPoint(winnerSide: receiverSide, outcomeType: 'serviceFault');
  }

  /// A Let replays the point with zero score or serve count change
  void recordLet() {
    if (_state.matchStatus == 'COMPLETED' || _state.matchStatus == 'RETIRED') {
      return;
    }
    _saveSnapshot();

    final currentScoreStr = '${_state.sideAPoints}-${_state.sideBPoints}';
    final event = TableTennisPointEvent(
      id: const Uuid().v4(),
      winnerSide: _state.servingSide,
      outcomeType: 'let',
      serverSide: _state.servingSide,
      serverPlayerIndex: _state.servingPlayerIndex,
      receiverPlayerIndex: _state.receivingPlayerIndex,
      gameNumber: _state.currentGameIndex + 1,
      scoreBefore: currentScoreStr,
      scoreAfter: currentScoreStr,
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
      sideAGamesWon: winningSide == 'A' ? _state.matchConfig.gamesToWin : _state.sideAGamesWon,
      sideBGamesWon: winningSide == 'B' ? _state.matchConfig.gamesToWin : _state.sideBGamesWon,
    );
  }

  void callTimeout({required String side}) {
    if (_state.matchStatus == 'COMPLETED' || _state.matchStatus == 'RETIRED') {
      return;
    }
    if (side == 'A' && _state.sideATimeoutsLeft <= 0) {
      throw StateError('Side A has no timeouts remaining.');
    }
    if (side == 'B' && _state.sideBTimeoutsLeft <= 0) {
      throw StateError('Side B has no timeouts remaining.');
    }

    _saveSnapshot();

    _state = _state.copyWith(
      sideATimeoutsLeft: side == 'A' ? _state.sideATimeoutsLeft - 1 : _state.sideATimeoutsLeft,
      sideBTimeoutsLeft: side == 'B' ? _state.sideBTimeoutsLeft - 1 : _state.sideBTimeoutsLeft,
    );
  }

  void toggleExpedite() {
    _saveSnapshot();
    _state = _state.copyWith(isExpediteActive: !_state.isExpediteActive);
  }

  void changeServer() {
    _saveSnapshot();
    final nextSide = _state.servingSide == 'A' ? 'B' : 'A';
    _state = _state.copyWith(
      servingSide: nextSide,
      serveCount: 0,
    );
  }

  // ════════════════════ PRIVATE ENGINE LOGIC ════════════════════

  void _processPoint(
    String winnerSide,
    List<TableTennisPlayer> sideAPlayers,
    List<TableTennisPlayer> sideBPlayers,
    String scoreBefore,
    String outcomeType,
  ) {
    int pA = _state.sideAPoints;
    int pB = _state.sideBPoints;

    if (winnerSide == 'A') {
      pA++;
    } else {
      pB++;
    }

    final target = _state.matchConfig.pointsPerGame;
    final deuceThreshold = target - 1; // e.g. 10 for 11-pt game, 6 for 7-pt game

    bool gameWon = false;
    String? gameWinner;

    if (pA >= target && (pA - pB) >= 2) {
      gameWon = true;
      gameWinner = 'A';
    } else if (pB >= target && (pB - pA) >= 2) {
      gameWon = true;
      gameWinner = 'B';
    }

    final isDeuceNow = pA >= deuceThreshold && pB >= deuceThreshold;

    if (gameWon && gameWinner != null) {
      _onGameWon(gameWinner, pA, pB, sideAPlayers, sideBPlayers, scoreBefore, outcomeType);
    } else {
      // Game continues — update serve rotation and side switch logic
      int newServeCount = _state.serveCount + 1;
      String nextServerSide = _state.servingSide;
      int nextServerIdx = _state.servingPlayerIndex;
      int nextReceiverIdx = _state.receivingPlayerIndex;

      // At Deuce, serve alternates every point. In 21-pt games, normal serve rotation is 5 serves; otherwise 2 serves.
      int normalRotation = 2;
      if (_state.matchConfig.pointsPerGame == 21) {
        normalRotation = 5;
      }
      final rotationLimit = isDeuceNow ? 1 : normalRotation;

      if (newServeCount >= rotationLimit) {
        newServeCount = 0;
        nextServerSide = _state.servingSide == 'A' ? 'B' : 'A';

        if (_state.matchConfig.format == 'DOUBLES') {
          // ITTF Doubles rotation:
          // The previous receiver becomes the next server,
          // and the partner of the previous server becomes the next receiver!
          final prevServerIdx = _state.servingPlayerIndex;
          final prevReceiverIdx = _state.receivingPlayerIndex;

          nextServerIdx = prevReceiverIdx;
          final prevServerTeamLength = _state.servingSide == 'A'
              ? (sideAPlayers.isNotEmpty ? sideAPlayers.length : 1)
              : (sideBPlayers.isNotEmpty ? sideBPlayers.length : 1);
          nextReceiverIdx = (prevServerIdx + 1) % prevServerTeamLength;
        }
      }

      // Check ITTF Deciding-Game Mid-Game Side Switch (at 5 points in 11-pt game)
      bool newEndsSwitched = _state.isEndsSwitched;
      bool newHasSwitchedEnds = _state.hasSwitchedEndsInDecidingGame;

      final isDecidingGame = (_state.currentGameIndex + 1) == (_state.matchConfig.gamesToWin * 2 - 1) &&
          _state.sideAGamesWon == _state.matchConfig.gamesToWin - 1 &&
          _state.sideBGamesWon == _state.matchConfig.gamesToWin - 1;

      if (isDecidingGame && !newHasSwitchedEnds) {
        final switchThreshold = target ~/ 2; // e.g. 5 points
        if (pA >= switchThreshold || pB >= switchThreshold) {
          // Trigger mid-game side switch ONCE in deciding game
          newEndsSwitched = !_state.isEndsSwitched;
          newHasSwitchedEnds = true;
        }
      }

      final scoreAfterStr = '$pA-$pB';
      final event = TableTennisPointEvent(
        id: const Uuid().v4(),
        winnerSide: winnerSide,
        outcomeType: outcomeType,
        serverSide: _state.servingSide,
        serverPlayerIndex: _state.servingPlayerIndex,
        receiverPlayerIndex: _state.receivingPlayerIndex,
        gameNumber: _state.currentGameIndex + 1,
        scoreBefore: scoreBefore,
        scoreAfter: scoreAfterStr,
      );

      _state = _state.copyWith(
        sideAPoints: pA,
        sideBPoints: pB,
        servingSide: nextServerSide,
        servingPlayerIndex: nextServerIdx,
        receivingPlayerIndex: nextReceiverIdx,
        serveCount: newServeCount,
        isDeuce: isDeuceNow,
        isEndsSwitched: newEndsSwitched,
        hasSwitchedEndsInDecidingGame: newHasSwitchedEnds,
        sideAPlayers: sideAPlayers,
        sideBPlayers: sideBPlayers,
        history: [..._state.history, event],
      );
    }
  }

  void _onGameWon(
    String gameWinner,
    int finalPA,
    int finalPB,
    List<TableTennisPlayer> sideAPlayers,
    List<TableTennisPlayer> sideBPlayers,
    String scoreBefore,
    String outcomeType,
  ) {
    List<GameScore> currentGames = List<GameScore>.from(_state.gameScores);
    if (currentGames.isEmpty) {
      currentGames.add(const GameScore(gameNumber: 1));
    }

    GameScore activeGame = currentGames[_state.currentGameIndex];
    activeGame = activeGame.copyWith(
      sideAPoints: finalPA,
      sideBPoints: finalPB,
      isCompleted: true,
      winnerSide: gameWinner,
    );
    currentGames[_state.currentGameIndex] = activeGame;

    int gA = _state.sideAGamesWon + (gameWinner == 'A' ? 1 : 0);
    int gB = _state.sideBGamesWon + (gameWinner == 'B' ? 1 : 0);

    bool matchWon = false;
    final requiredGames = _state.matchConfig.gamesToWin;

    if (gA >= requiredGames || gB >= requiredGames) {
      matchWon = true;
    }

    final event = TableTennisPointEvent(
      id: const Uuid().v4(),
      winnerSide: gameWinner,
      outcomeType: outcomeType,
      serverSide: _state.servingSide,
      serverPlayerIndex: _state.servingPlayerIndex,
      receiverPlayerIndex: _state.receivingPlayerIndex,
      gameNumber: _state.currentGameIndex + 1,
      scoreBefore: scoreBefore,
      scoreAfter: 'Game $gameWinner ($finalPA-$finalPB)',
    );

    if (matchWon) {
      final winnerTeamName = gA >= requiredGames
          ? _state.matchConfig.homeTeamName
          : _state.matchConfig.awayTeamName;
      final resultStr = '$winnerTeamName won ${_formatMatchResultSummary(currentGames)}';

      _state = _state.copyWith(
        sideAPoints: finalPA,
        sideBPoints: finalPB,
        sideAGamesWon: gA,
        sideBGamesWon: gB,
        gameScores: currentGames,
        matchStatus: 'COMPLETED',
        matchResult: resultStr,
        isDeuce: false,
        sideAPlayers: sideAPlayers,
        sideBPlayers: sideBPlayers,
        history: [..._state.history, event],
      );
    } else {
      // Advance to next game
      final nextGameIdx = _state.currentGameIndex + 1;
      currentGames.add(GameScore(gameNumber: nextGameIdx + 1));

      // Standard ends switch after every game
      final nextEndsSwitched = !_state.isEndsSwitched;

      // Server for next game alternates from previous game's initial server (ITTF Rule 2.13.5)
      final nextGameInitialServer = _state.gameInitialServer == 'A' ? 'B' : 'A';

      _state = _state.copyWith(
        sideAPoints: 0,
        sideBPoints: 0,
        sideAGamesWon: gA,
        sideBGamesWon: gB,
        currentGameIndex: nextGameIdx,
        gameScores: currentGames,
        servingSide: nextGameInitialServer,
        gameInitialServer: nextGameInitialServer,
        servingPlayerIndex: 0,
        receivingPlayerIndex: 0,
        serveCount: 0,
        isDeuce: false,
        isEndsSwitched: nextEndsSwitched,
        hasSwitchedEndsInDecidingGame: false,
        sideAPlayers: sideAPlayers,
        sideBPlayers: sideBPlayers,
        history: [..._state.history, event],
      );
    }
  }

  String _formatMatchResultSummary(List<GameScore> games) {
    final parts = <String>[];
    for (final g in games) {
      if (g.isCompleted) {
        parts.add('${g.sideAPoints}-${g.sideBPoints}');
      }
    }
    return parts.join(', ');
  }
}
