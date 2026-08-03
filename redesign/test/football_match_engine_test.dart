import 'package:flutter_test/flutter_test.dart';
import 'package:redesign/score_engine/footballMatchEngine/football_match_engine.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MatchEngine engine;
  late MatchTeam homeTeam;
  late MatchTeam awayTeam;

  setUp(() {
    homeTeam = MatchTeam(
      id: 'home',
      name: 'Strikers FC',
      color: '0xFF1DB954',
      squad: [
        MatchPlayer(id: 'p1', name: 'Alice', number: 9, isStarter: true, isOnPitch: true),
        MatchPlayer(id: 'p2', name: 'Bob', number: 10, isStarter: true, isOnPitch: true),
        MatchPlayer(id: 'p3', name: 'Charlie', number: 14, isStarter: false, isOnPitch: false),
      ],
    );

    awayTeam = MatchTeam(
      id: 'away',
      name: 'United FC',
      color: '0xFFE53935',
      squad: [
        MatchPlayer(id: 'p4', name: 'David', number: 7, isStarter: true, isOnPitch: true),
        MatchPlayer(id: 'p5', name: 'Eve', number: 11, isStarter: true, isOnPitch: true),
        MatchPlayer(id: 'p6', name: 'Frank', number: 8, isStarter: false, isOnPitch: false),
      ],
    );

    engine = MatchEngine(
      halfDuration: 45,
      extraTimeEnabled: true,
      penaltiesEnabled: true,
      maxSubs: 2,
    );

    final initialState = FootballMatchState();
    initialState.homeTeam = homeTeam;
    initialState.awayTeam = awayTeam;
    engine.loadState(initialState);
  });

  test('Start match transitions to firstHalf phase', () {
    expect(engine.state.phase, MatchPhase.preMatch);
    engine.endPhase();
    expect(engine.state.phase, MatchPhase.firstHalf);
  });

  test('Process goal increments score and scorer goal count', () {
    engine.endPhase(); // start first half
    final p1 = engine.state.homeTeam.squad.firstWhere((p) => p.id == 'p1');

    engine.processGoal(TeamSide.home, p1, null);
    expect(engine.state.homeScore, 1);
    expect(p1.goals, 1);
    expect(engine.canUndo, isTrue);
  });

  test('Process own goal increments opponent score', () {
    engine.endPhase(); // start first half
    final p1 = engine.state.homeTeam.squad.firstWhere((p) => p.id == 'p1');

    engine.processOwnGoal(TeamSide.home, p1);
    expect(engine.state.homeScore, 0);
    expect(engine.state.awayScore, 1);
  });

  test('In-match penalty conversion increments match score', () {
    engine.endPhase(); // start first half
    final p1 = engine.state.homeTeam.squad.firstWhere((p) => p.id == 'p1');

    engine.processPenalty(TeamSide.home, p1, true);
    expect(engine.state.homeScore, 1);
    expect(p1.goals, 1);
  });

  test('Second yellow card triggers red card and send off', () {
    engine.endPhase(); // start first half
    final p1 = engine.state.homeTeam.squad.firstWhere((p) => p.id == 'p1');

    engine.processCard(TeamSide.home, p1, EventType.yellowCard, 'Foul');
    expect(p1.yellowCards, 1);
    expect(p1.isSentOff, isFalse);

    engine.processCard(TeamSide.home, p1, EventType.yellowCard, 'Foul');
    expect(p1.yellowCards, 2);
    expect(p1.redCards, 1);
    expect(p1.isSentOff, isTrue);
    expect(p1.isOnPitch, isFalse);
  });

  test('Process substitution updates player on-pitch status and maxSubs', () {
    engine.endPhase(); // start first half
    final p1 = engine.state.homeTeam.squad.firstWhere((p) => p.id == 'p1');
    final p3 = engine.state.homeTeam.squad.firstWhere((p) => p.id == 'p3');

    final success = engine.processSubstitution(TeamSide.home, p1, p3);
    expect(success, isTrue);
    expect(p1.isOnPitch, isFalse);
    expect(p3.isOnPitch, isTrue);
    expect(engine.state.homeTeam.substitutionsUsed, 1);
  });

  test('Undo reverts previous snapshot atomically', () {
    engine.endPhase(); // first half
    final p1 = engine.state.homeTeam.squad.firstWhere((p) => p.id == 'p1');

    engine.processGoal(TeamSide.home, p1, null);
    expect(engine.state.homeScore, 1);

    engine.undo();
    expect(engine.state.homeScore, 0);
    expect(engine.state.homeTeam.squad.firstWhere((p) => p.id == 'p1').goals, 0);
  });

  test('Halftime advance auto-swaps ends', () {
    engine.endPhase(); // preMatch -> firstHalf
    expect(engine.state.endsSwapped, isFalse);

    engine.endPhase(); // firstHalf -> halfTime
    expect(engine.state.endsSwapped, isTrue);
  });

  test('Match completion generates matchResult string', () {
    engine.endPhase(); // start 1st half
    final p1 = engine.state.homeTeam.squad.firstWhere((p) => p.id == 'p1');
    engine.processGoal(TeamSide.home, p1, null);

    engine.endPhase(); // halftime
    engine.endPhase(); // 2nd half
    engine.endPhase(); // full time

    expect(engine.state.phase, MatchPhase.fullTime);
    expect(engine.state.matchResult, contains('Strikers FC 1 – 0 United FC'));
  });
}
