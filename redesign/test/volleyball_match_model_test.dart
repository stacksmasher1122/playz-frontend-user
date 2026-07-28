import 'package:flutter_test/flutter_test.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_match_model.dart';

void main() {
  group('VolleyballMatchModel', () {
    test('round-trips to and from map correctly', () {
      final match = VolleyballMatchModel(
        matchId: 'match-1',
        createdBy: 'user-1',
        matchName: 'Inter-City Finals',
        tournament: 'National Open',
        venue: 'Arena 01',
        court: 'Court A',
        referee: 'Alex',
        assistantReferee: 'Riley',
        category: 'Mixed',
        format: 'B3',
        date: '28-07-2026',
        time: '19:30',
        pointsPerSet: 25,
        finalSetPoints: 15,
        timeouts: 2,
        substitutions: 6,
        technicalTimeout: true,
        liberoEnabled: true,
        challengeEnabled: false,
        videoReview: false,
        winByTwo: true,
        status: 'setup',
        createdAt: DateTime(2026, 7, 28, 19, 30),
      );

      final map = match.toMap();
      final restored = VolleyballMatchModel.fromMap(map);

      expect(restored.matchId, 'match-1');
      expect(restored.matchName, 'Inter-City Finals');
      expect(restored.pointsPerSet, 25);
      expect(restored.winByTwo, isTrue);
      expect(restored.status, 'setup');
    });
  });
}
