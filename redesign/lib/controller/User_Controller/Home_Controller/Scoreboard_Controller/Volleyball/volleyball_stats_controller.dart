import 'dart:math';
import 'package:get/get.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_player_model.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_statistics_model.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/timeline_event_model.dart';

class VolleyballStatsController extends GetxController {
  RxBool isLoading = true.obs;

  // Header Details
  String teamAName = "KRAKOW GIANTS";
  String teamBName = "BERLIN WOLVES";
  int teamAScore = 24;
  int teamBScore = 22;
  int currentSet = 3;
  bool isMatchPoint = true;
  bool isTeamAServing = true;

  // Data
  Rx<TeamStatisticsModel?> teamAStats = Rx<TeamStatisticsModel?>(null);
  Rx<TeamStatisticsModel?> teamBStats = Rx<TeamStatisticsModel?>(null);
  
  RxList<double> momentumTeamA = <double>[].obs;
  RxList<double> momentumTeamB = <double>[].obs;
  
  RxList<PlayerStatisticsModel> topScorers = <PlayerStatisticsModel>[].obs;
  RxList<TimelineEventModel> timelineEvents = <TimelineEventModel>[].obs;
  
  RxList<String> matchInsights = <String>[].obs;
  
  RxString selectedTimelineFilter = "All Events".obs;

  @override
  void onInit() {
    super.onInit();
    loadAllData();
  }

  Future<void> loadAllData() async {
    isLoading.value = true;
    
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));

    _generateTeamStats();
    _generateMomentum();
    _generateTopScorers();
    _generateTimelineEvents();
    _generateInsights();

    isLoading.value = false;
  }

  void _generateTeamStats() {
    teamAStats.value = TeamStatisticsModel(
      attackSuccessPercent: 54,
      blocks: 12,
      aces: 6,
      digs: 28,
      receptionQualityPercent: 62,
      kills: 45,
      errors: 12,
    );
    teamBStats.value = TeamStatisticsModel(
      attackSuccessPercent: 42,
      blocks: 8,
      aces: 9,
      digs: 31,
      receptionQualityPercent: 55,
      kills: 38,
      errors: 18,
    );
  }

  void _generateMomentum() {
    final rand = Random();
    momentumTeamA.value = List.generate(20, (i) => rand.nextDouble() * 0.8 + 0.2);
    momentumTeamB.value = List.generate(20, (i) => rand.nextDouble() * 0.6 + 0.1);
  }

  void _generateTopScorers() {
    topScorers.assignAll([
      PlayerStatisticsModel(
        player: VolleyballPlayerModel(id: '1', name: 'LEON, Wilfredo', jerseyNumber: '9', position: 'Outside Hitter'),
        totalPoints: 18, aces: 2, blocks: 1, kills: 15, attackSuccessPercent: 60,
      ),
      PlayerStatisticsModel(
        player: VolleyballPlayerModel(id: '2', name: 'HUBER, Norbert', jerseyNumber: '99', position: 'Middle Blocker'),
        totalPoints: 12, aces: 1, blocks: 5, kills: 6, attackSuccessPercent: 65,
      ),
      PlayerStatisticsModel(
        player: VolleyballPlayerModel(id: '3', name: 'FORNAL, Tomasz', jerseyNumber: '11', position: 'Outside Hitter'),
        totalPoints: 11, aces: 0, blocks: 2, kills: 9, attackSuccessPercent: 52,
      ),
      PlayerStatisticsModel(
        player: VolleyballPlayerModel(id: '4', name: 'GROZER, Gyorgy', jerseyNumber: '10', position: 'Opposite'),
        totalPoints: 16, aces: 4, blocks: 1, kills: 11, attackSuccessPercent: 48,
      ),
    ]);
  }

  void _generateTimelineEvents() {
    timelineEvents.assignAll([
      TimelineEventModel(
        id: '1', type: TimelineEventType.point,
        title: 'Point scored by Krakow Giants', description: 'SPIKE BY LEON - 24 - 22',
        time: '22:14', scoreAtTime: '24-22', isTeamA: true,
      ),
      TimelineEventModel(
        id: '2', type: TimelineEventType.substitution,
        title: 'Berlin Wolves Substitution', description: 'IN: KRICK #18 | OUT: BREHME #12',
        time: '22:11', scoreAtTime: '23-22', isTeamA: false,
      ),
      TimelineEventModel(
        id: '3', type: TimelineEventType.timeout,
        title: 'Timeout: Berlin Wolves', description: 'COACH REQUEST - DURATION 0:30',
        time: '22:08', scoreAtTime: '23-22', isTeamA: false,
      ),
      TimelineEventModel(
        id: '4', type: TimelineEventType.ace,
        title: 'ACE! Krakow Giants', description: 'SERVICE BY HUBER - 23 - 22',
        time: '22:05', scoreAtTime: '23-22', isTeamA: true,
      ),
      TimelineEventModel(
        id: '5', type: TimelineEventType.block,
        title: 'MONSTER BLOCK!', description: 'BLOCK BY HUBER - 22 - 22',
        time: '22:02', scoreAtTime: '22-22', isTeamA: true,
      ),
    ]);
  }

  void _generateInsights() {
    matchInsights.assignAll([
      "Krakow Giants dominate middle attacks with 65% efficiency.",
      "Serve pressure increased. Wolves struggling in reception.",
      "Leon, W. has the highest efficiency rating (60%)."
    ]);
  }
}
