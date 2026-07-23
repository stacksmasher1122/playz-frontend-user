import 'package:flutter_test/flutter_test.dart';
import 'package:redesign/score_engine/basketballMatchEngine/basketball_match_engine.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Basketball/basketball_state_models.dart';
import 'package:uuid/uuid.dart';

void main() {
  group('Basketball Match Engine', () {
    late BasketballMatchEngine engine;
    late BasketballMatchConfig config;
    late List<BasketballPlayer> homeRoster;
    late List<BasketballPlayer> awayRoster;

    setUp(() {
      config = const BasketballMatchConfig(
        quarterLengthMinutes: 10,
        shotClockSeconds: 24,
        foulOutLimit: 5,
        technicalFoulsEnabled: true,
        timeoutsPerTeam: 5,
        mode: MatchMode.professional,
      );

      homeRoster = [
        const BasketballPlayer(id: 'home1@example.com', name: 'Home Player 1'),
        const BasketballPlayer(id: 'home2@example.com', name: 'Home Player 2'),
      ];

      awayRoster = [
        const BasketballPlayer(id: 'away1@example.com', name: 'Away Player 1'),
        const BasketballPlayer(id: 'away2@example.com', name: 'Away Player 2'),
      ];

      engine = BasketballMatchEngine(
        config: config,
        homeTeamName: 'Home',
        awayTeamName: 'Away',
        homeRoster: homeRoster,
        awayRoster: awayRoster,
      );
    });

    test('Engine initializes correctly', () {
      expect(engine.state.phase, MatchPhase.setup);
      expect(engine.state.homeTeam.score, 0);
      expect(engine.state.awayTeam.score, 0);
    });

    test('Undo restores score, fouls, and possession', () {
      engine.startMatch(wonTipOffTeamId: 'home', possessionArrowTeamId: 'away');

      // Score +2 for Home
      engine.dispatch(BasketballEvent(
        id: const Uuid().v4(),
        type: EventType.fieldGoalMade,
        teamId: 'home',
        playerId: 'home1@example.com',
        quarter: 1,
        gameClockRemaining: 600,
        points: 2,
        timestamp: DateTime.now(),
      ));

      expect(engine.state.homeTeam.score, 2);
      expect(engine.state.possessionTeamId, 'away'); // Toggled after score

      // Foul on Away
      engine.dispatch(BasketballEvent(
        id: const Uuid().v4(),
        type: EventType.foul,
        teamId: 'away',
        playerId: 'away1@example.com',
        quarter: 1,
        gameClockRemaining: 590,
        foulType: FoulType.personal,
        timestamp: DateTime.now(),
      ));

      expect(engine.state.awayTeam.roster.firstWhere((p) => p.id == 'away1@example.com').fouls, 1);
      expect(engine.state.awayTeam.teamFoulsInQuarter, 1);

      // Undo Foul
      engine.undo();
      expect(engine.state.awayTeam.roster.firstWhere((p) => p.id == 'away1@example.com').fouls, 0);
      expect(engine.state.awayTeam.teamFoulsInQuarter, 0);

      // Undo Score
      engine.undo();
      expect(engine.state.homeTeam.score, 0);
      expect(engine.state.possessionTeamId, 'home'); // Reverts to before score
    });

    test('Bonus is awarded correctly', () {
       engine.startMatch(wonTipOffTeamId: 'home', possessionArrowTeamId: 'away');

       for (int i = 0; i < 5; i++) {
         engine.dispatch(BasketballEvent(
           id: const Uuid().v4(),
           type: EventType.foul,
           teamId: 'away',
           playerId: 'away1@example.com',
           quarter: 1,
           gameClockRemaining: 500,
           foulType: FoulType.personal,
           timestamp: DateTime.now(),
         ));
       }

       expect(engine.state.awayTeam.teamFoulsInQuarter, 5);
       expect(engine.state.awayTeam.isInBonus, true);
       expect(engine.state.awayTeam.roster.firstWhere((p) => p.id == 'away1@example.com').isFouledOut, true);
    });

    test('Overtime triggers correctly on tie at Q4 end', () {
       engine.startMatch(wonTipOffTeamId: 'home', possessionArrowTeamId: 'away');
       engine.updateGameClock(0);

       // Force to Q4
       for (int i = 1; i < 4; i++) {
           engine.dispatch(BasketballEvent(
             id: const Uuid().v4(),
             type: EventType.quarterEnd,
             quarter: i,
             gameClockRemaining: 0,
             timestamp: DateTime.now(),
           ));
           engine.startNextQuarter();
           engine.updateGameClock(0);
       }

       // End Q4 tied 0-0
       engine.dispatch(BasketballEvent(
         id: const Uuid().v4(),
         type: EventType.quarterEnd,
         quarter: 4,
         gameClockRemaining: 0,
         timestamp: DateTime.now(),
       ));

       expect(engine.state.phase, MatchPhase.quarterBreak); // Waiting for OT
       engine.startNextQuarter();
       expect(engine.state.phase, MatchPhase.overtime);
       expect(engine.state.currentQuarter, 5);
    });
  });
}
