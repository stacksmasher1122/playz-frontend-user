import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Scoreboard_SQF/cricketSqflite.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Scoreboard_SQF/badmintonSqflite.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Scoreboard_SQF/footballSqflite.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Scoreboard_SQF/tennisSqflite.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Scoreboard_SQF/tableTennisSqflite.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/cricket_controller.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/badminton_controller.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/football_controller.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Tennis/tennis_controller.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Table_Tennis/table_tennis_controller.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Cricket/cricket_scoreboard/cricket_scoreboard_screen.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Badminton/live_match/badminton_scoreboard_screen.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Football/football_scoreboard/football_scoreboard_screen.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Tennis/tennis_scoreboard_screen.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Table_Tennis/table_tennis_scoreboard_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/cricket_model.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/badminton_model.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Tennis/tennis_model.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Table_Tennis/table_tennis_model.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Scoreboard_SQF/squashSqflite.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Squash/squash_controller.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Squash/live_match/squash_scoreboard_screen.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Squash/squash_model.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Scoreboard_SQF/kabaddiSqflite.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Kabaddi/kabaddi_controller.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Kabaddi/live_match/kabaddi_scoreboard_screen.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Scoreboard_SQF/basketballSqflite.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Basketball/basketball_controller.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Basketball/live_match/basketball_scoreboard_screen.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Scoreboard_SQF/volleyballSqflite.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_controller.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Volleyball/live_match/volleyball_scoreboard_screen.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Scoreboard_SQF/hockeySqflite.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Hockey/hockey_controller.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Hockey/live_match/hockey_scoreboard_screen.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Scoreboard_SQF/khokhoSqflite.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Kho_Kho/khokho_controller.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Kho_Kho/live_match/khokho_scoreboard_screen.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Scoreboard_SQF/pickleballSqflite.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Pickleball/pickleball_controller.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Pickleball/live_match/pickleball_scoreboard_screen.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Scoreboard_SQF/boxingSqflite.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Boxing/boxing_controller.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Boxing/live_match/boxing_scoreboard_screen.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Scoreboard_SQF/wrestlingSqflite.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Wrestling/wrestling_controller.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Wrestling/live_match/wrestling_scoreboard_screen.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Scoreboard_SQF/karateSqflite.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Karate/karate_controller.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Karate/live_match/karate_scoreboard_screen.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Scoreboard_SQF/judoSqflite.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Judo/judo_controller.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Judo/live_match/judo_scoreboard_screen.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Scoreboard_SQF/taekwondoSqflite.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Taekwondo/taekwondo_controller.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Taekwondo/live_match/taekwondo_scoreboard_screen.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Scoreboard_SQF/muayThaiSqflite.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/MuayThai/muay_thai_controller.dart';
import 'package:redesign/view/USER/Home/Scoreboard/MuayThai/live_match/muay_thai_scoreboard_screen.dart';




class RecoverableMatchItem {
  final String matchId;
  final String sport;
  final String matchType; // 'SLOT_DEDICATED' vs 'NORMAL'
  final String? bookingId;
  final String title;
  final String subtitle;
  final DateTime lastUpdatedAt;
  final dynamic rawModel;

  const RecoverableMatchItem({
    required this.matchId,
    required this.sport,
    required this.matchType,
    this.bookingId,
    required this.title,
    required this.subtitle,
    required this.lastUpdatedAt,
    this.rawModel,
  });
}

class ScoreboardHubItem {
  final String matchId;
  final String sport;
  final String matchType; // 'SLOT_DEDICATED' vs 'NORMAL'
  final String status; // 'completed' or 'incomplete'
  final String title;
  final String subtitle;
  final DateTime lastUpdatedAt;
  final DateTime? createdAt;
  final dynamic rawModel;

  const ScoreboardHubItem({
    required this.matchId,
    required this.sport,
    required this.matchType,
    required this.status,
    required this.title,
    required this.subtitle,
    required this.lastUpdatedAt,
    this.createdAt,
    this.rawModel,
  });

  bool get isCompleted => status.toLowerCase() == 'completed';
  bool get isBooked => matchType == 'SLOT_DEDICATED' || matchId.startsWith('SLOT_');

  String get statusDisplay {
    if (isCompleted) {
      return isBooked ? 'Completed • Booked Slot' : 'Completed • Manual';
    }
    return 'Incomplete';
  }
}

class ScoreboardRecoveryManager {
  /// Unfinished Booked Slot Matches ONLY (shown in recovery box above Create Tournament)
  static Future<List<RecoverableMatchItem>> getUnfinishedBookedSlotMatches() async {
    final allUnfinished = await getUnfinishedMatches();
    return allUnfinished.where((m) => m.matchType == 'SLOT_DEDICATED' || m.matchId.startsWith('SLOT_')).toList();
  }

  /// All Unfinished Matches
  static Future<List<RecoverableMatchItem>> getUnfinishedMatches() async {
    final List<RecoverableMatchItem> list = [];

    // 1. Check Cricket Matches from SQFlite
    try {
      final cricketMatches = await CricketSqflite.instance.getAllMatches();
      for (final m in cricketMatches) {
        if (m.status.toLowerCase() != 'completed') {
          final isSlot = m.matchId.startsWith('SLOT_');
          final teamA = m.homeTeamName.isNotEmpty ? m.homeTeamName : 'Team A';
          final teamB = m.awayTeamName.isNotEmpty ? m.awayTeamName : 'Team B';

          final DateTime updatedDate = m.lastUpdatedAt;

          list.add(
            RecoverableMatchItem(
              matchId: m.matchId,
              sport: 'Cricket',
              matchType: isSlot ? 'SLOT_DEDICATED' : 'NORMAL',
              title: '$teamA vs $teamB',
              subtitle: 'Cricket • ${m.overs} Overs • ${m.status}',
              lastUpdatedAt: updatedDate,
              rawModel: m,
            ),
          );
        }
      }
    } catch (_) {}

    // 2. Check Badminton Matches from SQFlite
    try {
      final badmintonMatches = await BadmintonSqflite.instance.getAllMatches();
      for (final b in badmintonMatches) {
        if (b.status.toLowerCase() != 'completed') {
          final isSlot = b.matchId.startsWith('SLOT_');
          final teamA = b.teamAPlayers.isNotEmpty ? b.teamAPlayers.join(', ') : 'Team A';
          final teamB = b.teamBPlayers.isNotEmpty ? b.teamBPlayers.join(', ') : 'Team B';

          DateTime updatedDate = DateTime.now();
          if (b.lastUpdatedAt != null) {
            updatedDate = b.lastUpdatedAt!;
          }

          list.add(
            RecoverableMatchItem(
              matchId: b.matchId,
              sport: 'Badminton',
              matchType: isSlot ? 'SLOT_DEDICATED' : 'NORMAL',
              title: '$teamA vs $teamB',
              subtitle: 'Badminton • Best of ${b.gamesToWin * 2 - 1} • ${b.status}',
              lastUpdatedAt: updatedDate,
              rawModel: b,
            ),
          );
        }
      }
    } catch (_) {}

    // 3. Check Football Matches from SQFlite
    try {
      final footballMatches = await FootballSqflite.instance.getAllMatches();
      for (final f in footballMatches) {
        if (f.status.toLowerCase() != 'completed') {
          final isSlot = f.id.startsWith('SLOT_');
          final teamA = f.engineState.homeTeam.name.isNotEmpty ? f.engineState.homeTeam.name : 'Home';
          final teamB = f.engineState.awayTeam.name.isNotEmpty ? f.engineState.awayTeam.name : 'Away';

          list.add(
            RecoverableMatchItem(
              matchId: f.id,
              sport: 'Football',
              matchType: isSlot ? 'SLOT_DEDICATED' : 'NORMAL',
              title: '$teamA vs $teamB',
              subtitle: 'Football • ${f.config['halfDurationMinutes'] ?? 45}m • ${f.status}',
              lastUpdatedAt: f.lastUpdatedAt,
              rawModel: f,
            ),
          );
        }
      }
    } catch (_) {}

    // 4. Check Tennis Matches from SQFlite
    try {
      final tennisMatches = await TennisSqflite.instance.getAllMatches();
      for (final t in tennisMatches) {
        if (t.status.toLowerCase() != 'completed') {
          final isSlot = t.matchId.startsWith('SLOT_');
          final teamA = t.homeTeamName.isNotEmpty ? t.homeTeamName : 'Player A';
          final teamB = t.awayTeamName.isNotEmpty ? t.awayTeamName : 'Player B';

          list.add(
            RecoverableMatchItem(
              matchId: t.matchId,
              sport: 'Tennis',
              matchType: isSlot ? 'SLOT_DEDICATED' : 'NORMAL',
              title: '$teamA vs $teamB',
              subtitle: 'Tennis • ${t.config['setsFormat'] ?? 'Best of 3'} • ${t.status}',
              lastUpdatedAt: t.lastUpdatedAt,
              rawModel: t,
            ),
          );
        }
      }
    } catch (_) {}

    // 5. Check Table Tennis Matches from SQFlite
    try {
      final ttMatches = await TableTennisSqflite.instance.getAllMatches();
      for (final tt in ttMatches) {
        if (tt.status.toLowerCase() != 'completed') {
          final isSlot = tt.matchId.startsWith('SLOT_');
          final teamA = tt.homeTeamName.isNotEmpty ? tt.homeTeamName : 'Player A';
          final teamB = tt.awayTeamName.isNotEmpty ? tt.awayTeamName : 'Player B';

          list.add(
            RecoverableMatchItem(
              matchId: tt.matchId,
              sport: 'Table Tennis',
              matchType: isSlot ? 'SLOT_DEDICATED' : 'NORMAL',
              title: '$teamA vs $teamB',
              subtitle: 'Table Tennis • ${tt.config['gamesFormat'] ?? 'Best of 5'} • ${tt.status}',
              lastUpdatedAt: tt.lastUpdatedAt,
              rawModel: tt,
            ),
          );
        }
      }
    } catch (_) {}


    // 6. Check Squash Matches from SQFlite
    try {
      final squashMatches = await SquashSqflite.instance.getAllMatches();
      for (final sq in squashMatches) {
        if (sq.status.toLowerCase() != 'completed') {
          final isSlot = sq.matchId.startsWith('SLOT_');
          final teamA = sq.teamAPlayers.isNotEmpty ? sq.teamAPlayers.join(', ') : 'Team A';
          final teamB = sq.teamBPlayers.isNotEmpty ? sq.teamBPlayers.join(', ') : 'Team B';

          list.add(
            RecoverableMatchItem(
              matchId: sq.matchId,
              sport: 'Squash',
              matchType: isSlot ? 'SLOT_DEDICATED' : 'NORMAL',
              title: '$teamA vs $teamB',
              subtitle: 'Squash • Best of ${sq.gamesToWin * 2 - 1} • ${sq.status}',
              lastUpdatedAt: sq.lastUpdatedAt ?? sq.createdAt,
              rawModel: sq,
            ),
          );
        }
      }
    } catch (_) {}

    // 7. Check Kabaddi Matches from SQFlite
    try {
      final kabaddiMatches = await KabaddiSqfliteService.getUnfinishedMatches();
      for (final kb in kabaddiMatches) {
        final isSlot = kb.matchId.startsWith('SLOT_');
        list.add(
          RecoverableMatchItem(
            matchId: kb.matchId,
            sport: 'Kabaddi',
            matchType: isSlot ? 'SLOT_DEDICATED' : 'NORMAL',
            title: '${kb.homeTeam} vs ${kb.awayTeam}',
            subtitle: 'Kabaddi • ${kb.currentHalf} • ${kb.homeScore} - ${kb.awayScore}',
            lastUpdatedAt: kb.updatedAt,
            rawModel: kb,
          ),
        );
      }
    } catch (_) {}

    // 8. Check Basketball Matches from SQFlite
    try {
      final basketballMatches = await BasketballSqfliteService.getUnfinishedMatches();
      for (final bk in basketballMatches) {
        final isSlot = bk.matchId.startsWith('SLOT_');
        list.add(
          RecoverableMatchItem(
            matchId: bk.matchId,
            sport: 'Basketball',
            matchType: isSlot ? 'SLOT_DEDICATED' : 'NORMAL',
            title: '${bk.homeTeam} vs ${bk.awayTeam}',
            subtitle: 'Basketball • ${bk.currentQuarter} • ${bk.homeScore} - ${bk.awayScore}',
            lastUpdatedAt: bk.updatedAt,
            rawModel: bk,
          ),
        );
      }
    } catch (_) {}

    // 9. Check Volleyball Matches from SQFlite
    try {
      final volleyballMatches = await VolleyballSqfliteService.getUnfinishedMatches();
      for (final vl in volleyballMatches) {
        final isSlot = vl.matchId.startsWith('SLOT_');
        list.add(
          RecoverableMatchItem(
            matchId: vl.matchId,
            sport: 'Volleyball',
            matchType: isSlot ? 'SLOT_DEDICATED' : 'NORMAL',
            title: '${vl.homeTeam} vs ${vl.awayTeam}',
            subtitle: 'Volleyball • ${vl.currentSetDisplay} • ${vl.homeSetsWon} - ${vl.awaySetsWon}',
            lastUpdatedAt: vl.updatedAt,
            rawModel: vl,
          ),
        );
      }
    } catch (_) {}

    // 10. Check Hockey Matches from SQFlite
    try {
      final hockeyMatches = await HockeySqfliteService.getUnfinishedMatches();
      for (final hk in hockeyMatches) {
        final isSlot = hk.matchId.startsWith('SLOT_');
        list.add(
          RecoverableMatchItem(
            matchId: hk.matchId,
            sport: 'Hockey',
            matchType: isSlot ? 'SLOT_DEDICATED' : 'NORMAL',
            title: '${hk.homeTeam} vs ${hk.awayTeam}',
            subtitle: 'Hockey • ${hk.currentPeriodDisplay} • ${hk.homeGoals} - ${hk.awayGoals}',
            lastUpdatedAt: hk.updatedAt,
            rawModel: hk,
          ),
        );
      }
    } catch (_) {}

    // 11. Check Kho Kho Matches from SQFlite
    try {
      final khokhoMatches = await KhoKhoSqfliteService.getUnfinishedMatches();
      for (final kk in khokhoMatches) {
        final isSlot = kk.matchId.startsWith('SLOT_');
        list.add(
          RecoverableMatchItem(
            matchId: kk.matchId,
            sport: 'Kho Kho',
            matchType: isSlot ? 'SLOT_DEDICATED' : 'NORMAL',
            title: '${kk.homeTeam} vs ${kk.awayTeam}',
            subtitle: 'Kho Kho • ${kk.currentTurnDisplay} • ${kk.homePoints} - ${kk.awayPoints} pts',
            lastUpdatedAt: kk.updatedAt,
            rawModel: kk,
          ),
        );
      }
    } catch (_) {}

    // 12. Check Pickleball Matches from SQFlite
    try {
      final pickleballMatches = await PickleballSqfliteService.getUnfinishedMatches();
      for (final pb in pickleballMatches) {
        final isSlot = pb.matchId.startsWith('SLOT_');
        list.add(
          RecoverableMatchItem(
            matchId: pb.matchId,
            sport: 'Pickleball',
            matchType: isSlot ? 'SLOT_DEDICATED' : 'NORMAL',
            title: '${pb.homeTeam} vs ${pb.awayTeam}',
            subtitle: 'Pickleball • ${pb.currentScoreDisplay} • ${pb.homeGamesWon} - ${pb.awayGamesWon} games',
            lastUpdatedAt: pb.updatedAt,
            rawModel: pb,
          ),
        );
      }
    } catch (_) {}

    // 13. Check Boxing Matches from SQFlite
    try {
      final boxingMatches = await BoxingSqfliteService.getUnfinishedMatches();
      for (final bx in boxingMatches) {
        final isSlot = bx.matchId.startsWith('SLOT_');
        list.add(
          RecoverableMatchItem(
            matchId: bx.matchId,
            sport: 'Boxing',
            matchType: isSlot ? 'SLOT_DEDICATED' : 'NORMAL',
            title: '${bx.fighterA} vs ${bx.fighterB}',
            subtitle: 'Boxing • ${bx.currentRoundDisplay} • ${bx.fighterAScore} - ${bx.fighterBScore} pts',
            lastUpdatedAt: bx.updatedAt,
            rawModel: bx,
          ),
        );
      }
    } catch (_) {}

    // 14. Check Wrestling Matches from SQFlite
    try {
      final wrestlingMatches = await WrestlingSqfliteService.getUnfinishedMatches();
      for (final wr in wrestlingMatches) {
        final isSlot = wr.matchId.startsWith('SLOT_');
        list.add(
          RecoverableMatchItem(
            matchId: wr.matchId,
            sport: 'Wrestling',
            matchType: isSlot ? 'SLOT_DEDICATED' : 'NORMAL',
            title: '${wr.wrestlerA} vs ${wr.wrestlerB}',
            subtitle: 'Wrestling • ${wr.currentPeriodDisplay} • ${wr.wrestlerAScore} - ${wr.wrestlerBScore} pts',
            lastUpdatedAt: wr.updatedAt,
            rawModel: wr,
          ),
        );
      }
    } catch (_) {}

    // 15. Check Karate Matches from SQFlite
    try {
      final karateMatches = await KarateSqfliteService.getUnfinishedMatches();
      for (final kr in karateMatches) {
        final isSlot = kr.matchId.startsWith('SLOT_');
        list.add(
          RecoverableMatchItem(
            matchId: kr.matchId,
            sport: 'Karate',
            matchType: isSlot ? 'SLOT_DEDICATED' : 'NORMAL',
            title: '${kr.akaFighter} vs ${kr.aoFighter}',
            subtitle: 'Karate • ${kr.currentBoutDisplay} • ${kr.akaScore} - ${kr.aoScore} pts',
            lastUpdatedAt: kr.updatedAt,
            rawModel: kr,
          ),
        );
      }
    } catch (_) {}

    // 16. Check Judo Matches from SQFlite
    try {
      final judoMatches = await JudoSqfliteService.getUnfinishedMatches();
      for (final jd in judoMatches) {
        final isSlot = jd.matchId.startsWith('SLOT_');
        list.add(
          RecoverableMatchItem(
            matchId: jd.matchId,
            sport: 'Judo',
            matchType: isSlot ? 'SLOT_DEDICATED' : 'NORMAL',
            title: '${jd.whiteFighter} vs ${jd.blueFighter}',
            subtitle: 'Judo • ${jd.currentContestDisplay} • W:${jd.whiteWazaAri} - W:${jd.blueWazaAri}',
            lastUpdatedAt: jd.updatedAt,
            rawModel: jd,
          ),
        );
      }
    } catch (_) {}

    // 17. Check Taekwondo Matches from SQFlite
    try {
      final tkdMatches = await TaekwondoSqfliteService.getUnfinishedMatches();
      for (final tk in tkdMatches) {
        final isSlot = tk.matchId.startsWith('SLOT_');
        list.add(
          RecoverableMatchItem(
            matchId: tk.matchId,
            sport: 'Taekwondo',
            matchType: isSlot ? 'SLOT_DEDICATED' : 'NORMAL',
            title: '${tk.hongFighter} vs ${tk.chongFighter}',
            subtitle: 'Taekwondo • ${tk.currentRoundDisplay} • ${tk.hongScore} - ${tk.chongScore} pts',
            lastUpdatedAt: tk.updatedAt,
            rawModel: tk,
          ),
        );
      }
    } catch (_) {}

    // 18. Check Muay Thai Matches from SQFlite
    try {
      final mtMatches = await MuayThaiSqfliteService.getUnfinishedMatches();
      for (final mt in mtMatches) {
        final isSlot = mt.matchId.startsWith('SLOT_');
        list.add(
          RecoverableMatchItem(
            matchId: mt.matchId,
            sport: 'Muay Thai',
            matchType: isSlot ? 'SLOT_DEDICATED' : 'NORMAL',
            title: '${mt.fighterA} vs ${mt.fighterB}',
            subtitle: 'Muay Thai • ${mt.currentRoundDisplay} • ${mt.fighterAScore} - ${mt.fighterBScore} pts',
            lastUpdatedAt: mt.updatedAt,
            rawModel: mt,
          ),
        );
      }
    } catch (_) {}

    list.sort((a, b) => b.lastUpdatedAt.compareTo(a.lastUpdatedAt));
    return list;
  }

  /// Scoreboards displayed below Create Scoreboard Hero Card
  static Future<List<ScoreboardHubItem>> getHubScoreboardMatches() async {
    final List<ScoreboardHubItem> list = [];

    // 1. Cricket Matches from SQFlite
    try {
      final cricketMatches = await CricketSqflite.instance.getAllMatches();
      for (final m in cricketMatches) {
        final isSlot = m.matchId.startsWith('SLOT_');
        final isCompleted = m.status.toLowerCase() == 'completed' || m.matchResult.isNotEmpty;
        final matchType = isSlot ? 'SLOT_DEDICATED' : 'NORMAL';

        if (isCompleted || (!isCompleted && !isSlot)) {
          final teamA = m.homeTeamName.isNotEmpty ? m.homeTeamName : 'Team Red';
          final teamB = m.awayTeamName.isNotEmpty ? m.awayTeamName : 'Team Blue';

          String sub = 'Cricket • ${m.overs} Overs';
          if (isCompleted && m.matchResult.isNotEmpty) {
            sub = m.matchResult;
          } else {
            sub = 'Cricket • ${m.overs} Overs • ${m.status}';
          }

          list.add(
            ScoreboardHubItem(
              matchId: m.matchId,
              sport: 'Cricket',
              matchType: matchType,
              status: isCompleted ? 'completed' : 'incomplete',
              title: '${_truncate8(teamA)} vs ${_truncate8(teamB)}',
              subtitle: sub,
              lastUpdatedAt: m.lastUpdatedAt,
              createdAt: m.createdAt,
              rawModel: m,
            ),
          );
        }
      }
    } catch (_) {}

    // 2. Badminton Matches from SQFlite
    try {
      final badmintonMatches = await BadmintonSqflite.instance.getAllMatches();
      for (final b in badmintonMatches) {
        final isSlot = b.matchId.startsWith('SLOT_');
        final isCompleted = b.status.toLowerCase() == 'completed' || b.matchResult.isNotEmpty;
        final matchType = isSlot ? 'SLOT_DEDICATED' : 'NORMAL';

        if (isCompleted || (!isCompleted && !isSlot)) {
          final teamA = _formatBadmintonTeamNames(b, true);
          final teamB = _formatBadmintonTeamNames(b, false);

          DateTime updatedDate = b.lastUpdatedAt ?? DateTime.now();

          String sub = 'Badminton • Best of ${b.gamesToWin * 2 - 1}';
          if (isCompleted && b.matchResult.isNotEmpty) {
            sub = b.matchResult;
          }

          list.add(
            ScoreboardHubItem(
              matchId: b.matchId,
              sport: 'Badminton',
              matchType: matchType,
              status: isCompleted ? 'completed' : 'incomplete',
              title: '${_truncate8(teamA)} vs ${_truncate8(teamB)}',
              subtitle: sub,
              lastUpdatedAt: updatedDate,
              createdAt: b.createdAt,
              rawModel: b,
            ),
          );
        }
      }
    } catch (_) {}

    // 3. Football Matches from SQFlite
    try {
      final footballMatches = await FootballSqflite.instance.getAllMatches();
      for (final f in footballMatches) {
        final isSlot = f.id.startsWith('SLOT_');
        final isCompleted = f.status.toLowerCase() == 'completed' || f.matchResult.isNotEmpty;
        final matchType = isSlot ? 'SLOT_DEDICATED' : 'NORMAL';

        if (isCompleted || (!isCompleted && !isSlot)) {
          final teamA = f.engineState.homeTeam.name.isNotEmpty ? f.engineState.homeTeam.name : 'Home';
          final teamB = f.engineState.awayTeam.name.isNotEmpty ? f.engineState.awayTeam.name : 'Away';

          String sub = 'Football • ${f.config['halfDurationMinutes'] ?? 45}m';
          if (isCompleted && f.matchResult.isNotEmpty) {
            sub = f.matchResult;
          }

          list.add(
            ScoreboardHubItem(
              matchId: f.id,
              sport: 'Football',
              matchType: matchType,
              status: isCompleted ? 'completed' : 'incomplete',
              title: '${_truncate8(teamA)} vs ${_truncate8(teamB)}',
              subtitle: sub,
              lastUpdatedAt: f.lastUpdatedAt,
              createdAt: f.createdAt,
              rawModel: f,
            ),
          );
        }
      }
    } catch (_) {}

    // 4. Tennis Matches from SQFlite
    try {
      final tennisMatches = await TennisSqflite.instance.getAllMatches();
      for (final t in tennisMatches) {
        final isSlot = t.matchId.startsWith('SLOT_');
        final isCompleted = t.status.toLowerCase() == 'completed' || t.matchResult.isNotEmpty;
        final matchType = isSlot ? 'SLOT_DEDICATED' : 'NORMAL';

        if (isCompleted || (!isCompleted && !isSlot)) {
          final teamA = t.homeTeamName.isNotEmpty ? t.homeTeamName : 'Player A';
          final teamB = t.awayTeamName.isNotEmpty ? t.awayTeamName : 'Player B';

          String sub = 'Tennis • ${t.config['setsFormat'] ?? 'Best of 3'}';
          if (isCompleted && t.matchResult.isNotEmpty) {
            sub = t.matchResult;
          }

          list.add(
            ScoreboardHubItem(
              matchId: t.matchId,
              sport: 'Tennis',
              matchType: matchType,
              status: isCompleted ? 'completed' : 'incomplete',
              title: '${_truncate8(teamA)} vs ${_truncate8(teamB)}',
              subtitle: sub,
              lastUpdatedAt: t.lastUpdatedAt,
              createdAt: t.createdAt,
              rawModel: t,
            ),
          );
        }
      }
    } catch (_) {}

    // 5. Table Tennis Matches from SQFlite
    try {
      final ttMatches = await TableTennisSqflite.instance.getAllMatches();
      for (final tt in ttMatches) {
        final isSlot = tt.matchId.startsWith('SLOT_');
        final isCompleted = tt.status.toLowerCase() == 'completed' || tt.matchResult.isNotEmpty;
        final matchType = isSlot ? 'SLOT_DEDICATED' : 'NORMAL';

        if (isCompleted || (!isCompleted && !isSlot)) {
          final teamA = tt.homeTeamName.isNotEmpty ? tt.homeTeamName : 'Player A';
          final teamB = tt.awayTeamName.isNotEmpty ? tt.awayTeamName : 'Player B';

          String sub = 'Table Tennis • ${tt.config['gamesFormat'] ?? 'Best of 5'}';
          if (isCompleted && tt.matchResult.isNotEmpty) {
            sub = tt.matchResult;
          }

          list.add(
            ScoreboardHubItem(
              matchId: tt.matchId,
              sport: 'Table Tennis',
              matchType: matchType,
              status: isCompleted ? 'completed' : 'incomplete',
              title: '${_truncate8(teamA)} vs ${_truncate8(teamB)}',
              subtitle: sub,
              lastUpdatedAt: tt.lastUpdatedAt,
              createdAt: tt.createdAt,
              rawModel: tt,
            ),
          );
        }
      }
    } catch (_) {}

    // 6. Squash Matches from SQFlite
    try {
      final squashMatches = await SquashSqflite.instance.getAllMatches();
      for (final sq in squashMatches) {
        final isSlot = sq.matchId.startsWith('SLOT_');
        final isCompleted = sq.status.toLowerCase() == 'completed' || sq.matchResult.isNotEmpty;
        final matchType = isSlot ? 'SLOT_DEDICATED' : 'NORMAL';

        if (isCompleted || (!isCompleted && !isSlot)) {
          final teamA = sq.teamAPlayers.isNotEmpty ? sq.teamAPlayers.join(', ') : 'Side A';
          final teamB = sq.teamBPlayers.isNotEmpty ? sq.teamBPlayers.join(', ') : 'Side B';

          String sub = 'Squash • Best of ${sq.gamesToWin * 2 - 1}';
          if (isCompleted && sq.matchResult.isNotEmpty) {
            sub = sq.matchResult;
          }

          list.add(
            ScoreboardHubItem(
              matchId: sq.matchId,
              sport: 'Squash',
              matchType: matchType,
              status: isCompleted ? 'completed' : 'incomplete',
              title: '${_truncate8(teamA)} vs ${_truncate8(teamB)}',
              subtitle: sub,
              lastUpdatedAt: sq.lastUpdatedAt ?? sq.createdAt,
              createdAt: sq.createdAt,
              rawModel: sq,
            ),
          );
        }
      }
    } catch (_) {}

    // 7. Kabaddi Matches from SQFlite
    try {
      final kabaddiMatches = await KabaddiSqfliteService.getAllMatches();
      for (final kb in kabaddiMatches) {
        final isSlot = kb.matchId.startsWith('SLOT_');
        final isCompleted = kb.isCompleted || kb.matchResult.isNotEmpty;
        final matchType = isSlot ? 'SLOT_DEDICATED' : 'NORMAL';

        if (isCompleted || (!isCompleted && !isSlot)) {
          final teamA = kb.homeTeam.isNotEmpty ? kb.homeTeam : 'Side A';
          final teamB = kb.awayTeam.isNotEmpty ? kb.awayTeam : 'Side B';

          String sub = 'Kabaddi • ${kb.currentHalf} • ${kb.homeScore} - ${kb.awayScore}';
          if (isCompleted && kb.matchResult.isNotEmpty) {
            sub = kb.matchResult;
          }

          list.add(
            ScoreboardHubItem(
              matchId: kb.matchId,
              sport: 'Kabaddi',
              matchType: matchType,
              status: isCompleted ? 'completed' : 'incomplete',
              title: '${_truncate8(teamA)} vs ${_truncate8(teamB)}',
              subtitle: sub,
              lastUpdatedAt: kb.updatedAt,
              createdAt: kb.createdAt,
              rawModel: kb,
            ),
          );
        }
      }
    } catch (_) {}

    // 8. Basketball Matches from SQFlite
    try {
      final basketballMatches = await BasketballSqfliteService.getAllMatches();
      for (final bk in basketballMatches) {
        final isSlot = bk.matchId.startsWith('SLOT_');
        final isCompleted = bk.isCompleted || bk.matchResult.isNotEmpty;
        final matchType = isSlot ? 'SLOT_DEDICATED' : 'NORMAL';

        if (isCompleted || (!isCompleted && !isSlot)) {
          final teamA = bk.homeTeam.isNotEmpty ? bk.homeTeam : 'Side A';
          final teamB = bk.awayTeam.isNotEmpty ? bk.awayTeam : 'Side B';

          String sub = 'Basketball • ${bk.currentQuarter} • ${bk.homeScore} - ${bk.awayScore}';
          if (isCompleted && bk.matchResult.isNotEmpty) {
            sub = bk.matchResult;
          }

          list.add(
            ScoreboardHubItem(
              matchId: bk.matchId,
              sport: 'Basketball',
              matchType: matchType,
              status: isCompleted ? 'completed' : 'incomplete',
              title: '${_truncate8(teamA)} vs ${_truncate8(teamB)}',
              subtitle: sub,
              lastUpdatedAt: bk.updatedAt,
              createdAt: bk.createdAt,
              rawModel: bk,
            ),
          );
        }
      }
    } catch (_) {}

    // 9. Volleyball Matches from SQFlite
    try {
      final volleyballMatches = await VolleyballSqfliteService.getAllMatches();
      for (final vl in volleyballMatches) {
        final isSlot = vl.matchId.startsWith('SLOT_');
        final isCompleted = vl.isCompleted || vl.matchResult.isNotEmpty;
        final matchType = isSlot ? 'SLOT_DEDICATED' : 'NORMAL';

        if (isCompleted || (!isCompleted && !isSlot)) {
          final teamA = vl.homeTeam.isNotEmpty ? vl.homeTeam : 'Side A';
          final teamB = vl.awayTeam.isNotEmpty ? vl.awayTeam : 'Side B';

          String sub = 'Volleyball • ${vl.currentSetDisplay} • ${vl.homeSetsWon} - ${vl.awaySetsWon}';
          if (isCompleted && vl.matchResult.isNotEmpty) {
            sub = vl.matchResult;
          }

          list.add(
            ScoreboardHubItem(
              matchId: vl.matchId,
              sport: 'Volleyball',
              matchType: matchType,
              status: isCompleted ? 'completed' : 'incomplete',
              title: '${_truncate8(teamA)} vs ${_truncate8(teamB)}',
              subtitle: sub,
              lastUpdatedAt: vl.updatedAt,
              createdAt: vl.createdAt,
              rawModel: vl,
            ),
          );
        }
      }
    } catch (_) {}

    // 10. Hockey Matches from SQFlite
    try {
      final hockeyMatches = await HockeySqfliteService.getAllMatches();
      for (final hk in hockeyMatches) {
        final isSlot = hk.matchId.startsWith('SLOT_');
        final isCompleted = hk.isCompleted || hk.matchResult.isNotEmpty;
        final matchType = isSlot ? 'SLOT_DEDICATED' : 'NORMAL';

        if (isCompleted || (!isCompleted && !isSlot)) {
          final teamA = hk.homeTeam.isNotEmpty ? hk.homeTeam : 'Side A';
          final teamB = hk.awayTeam.isNotEmpty ? hk.awayTeam : 'Side B';

          String sub = 'Hockey • ${hk.currentPeriodDisplay} • ${hk.homeGoals} - ${hk.awayGoals}';
          if (isCompleted && hk.matchResult.isNotEmpty) {
            sub = hk.matchResult;
          }

          list.add(
            ScoreboardHubItem(
              matchId: hk.matchId,
              sport: 'Hockey',
              matchType: matchType,
              status: isCompleted ? 'completed' : 'incomplete',
              title: '${_truncate8(teamA)} vs ${_truncate8(teamB)}',
              subtitle: sub,
              lastUpdatedAt: hk.updatedAt,
              createdAt: hk.createdAt,
              rawModel: hk,
            ),
          );
        }
      }
    } catch (_) {}

    // 11. Kho Kho Matches from SQFlite
    try {
      final khokhoMatches = await KhoKhoSqfliteService.getAllMatches();
      for (final kk in khokhoMatches) {
        final isSlot = kk.matchId.startsWith('SLOT_');
        final isCompleted = kk.isCompleted || kk.matchResult.isNotEmpty;
        final matchType = isSlot ? 'SLOT_DEDICATED' : 'NORMAL';

        if (isCompleted || (!isCompleted && !isSlot)) {
          final teamA = kk.homeTeam.isNotEmpty ? kk.homeTeam : 'Side A';
          final teamB = kk.awayTeam.isNotEmpty ? kk.awayTeam : 'Side B';

          String sub = 'Kho Kho • ${kk.currentTurnDisplay} • ${kk.homePoints} - ${kk.awayPoints} pts';
          if (isCompleted && kk.matchResult.isNotEmpty) {
            sub = kk.matchResult;
          }

          list.add(
            ScoreboardHubItem(
              matchId: kk.matchId,
              sport: 'Kho Kho',
              matchType: matchType,
              status: isCompleted ? 'completed' : 'incomplete',
              title: '${_truncate8(teamA)} vs ${_truncate8(teamB)}',
              subtitle: sub,
              lastUpdatedAt: kk.updatedAt,
              createdAt: kk.createdAt,
              rawModel: kk,
            ),
          );
        }
      }
    } catch (_) {}

    // 12. Pickleball Matches from SQFlite
    try {
      final pickleballMatches = await PickleballSqfliteService.getAllMatches();
      for (final pb in pickleballMatches) {
        final isSlot = pb.matchId.startsWith('SLOT_');
        final isCompleted = pb.isCompleted || pb.matchResult.isNotEmpty;
        final matchType = isSlot ? 'SLOT_DEDICATED' : 'NORMAL';

        if (isCompleted || (!isCompleted && !isSlot)) {
          final teamA = pb.homeTeam.isNotEmpty ? pb.homeTeam : 'Side A';
          final teamB = pb.awayTeam.isNotEmpty ? pb.awayTeam : 'Side B';

          String sub = 'Pickleball • ${pb.currentScoreDisplay} • ${pb.homeGamesWon} - ${pb.awayGamesWon} games';
          if (isCompleted && pb.matchResult.isNotEmpty) {
            sub = pb.matchResult;
          }

          list.add(
            ScoreboardHubItem(
              matchId: pb.matchId,
              sport: 'Pickleball',
              matchType: matchType,
              status: isCompleted ? 'completed' : 'incomplete',
              title: '${_truncate8(teamA)} vs ${_truncate8(teamB)}',
              subtitle: sub,
              lastUpdatedAt: pb.updatedAt,
              createdAt: pb.createdAt,
              rawModel: pb,
            ),
          );
        }
      }
    } catch (_) {}

    // 13. Boxing Matches from SQFlite
    try {
      final boxingMatches = await BoxingSqfliteService.getAllMatches();
      for (final bx in boxingMatches) {
        final isSlot = bx.matchId.startsWith('SLOT_');
        final isCompleted = bx.isCompleted || bx.matchResult.isNotEmpty;
        final matchType = isSlot ? 'SLOT_DEDICATED' : 'NORMAL';

        if (isCompleted || (!isCompleted && !isSlot)) {
          final fA = bx.fighterA.isNotEmpty ? bx.fighterA : 'Red Corner';
          final fB = bx.fighterB.isNotEmpty ? bx.fighterB : 'Blue Corner';

          String sub = 'Boxing • ${bx.currentRoundDisplay} • ${bx.fighterAScore} - ${bx.fighterBScore} pts';
          if (isCompleted && bx.matchResult.isNotEmpty) {
            sub = bx.matchResult;
          }

          list.add(
            ScoreboardHubItem(
              matchId: bx.matchId,
              sport: 'Boxing',
              matchType: matchType,
              status: isCompleted ? 'completed' : 'incomplete',
              title: '${_truncate8(fA)} vs ${_truncate8(fB)}',
              subtitle: sub,
              lastUpdatedAt: bx.updatedAt,
              createdAt: bx.createdAt,
              rawModel: bx,
            ),
          );
        }
      }
    } catch (_) {}

    // 14. Wrestling Matches from SQFlite
    try {
      final wrestlingMatches = await WrestlingSqfliteService.getAllMatches();
      for (final wr in wrestlingMatches) {
        final isSlot = wr.matchId.startsWith('SLOT_');
        final isCompleted = wr.isCompleted || wr.matchResult.isNotEmpty;
        final matchType = isSlot ? 'SLOT_DEDICATED' : 'NORMAL';

        if (isCompleted || (!isCompleted && !isSlot)) {
          final wA = wr.wrestlerA.isNotEmpty ? wr.wrestlerA : 'Red Corner';
          final wB = wr.wrestlerB.isNotEmpty ? wr.wrestlerB : 'Blue Corner';

          String sub = 'Wrestling • ${wr.currentPeriodDisplay} • ${wr.wrestlerAScore} - ${wr.wrestlerBScore} pts';
          if (isCompleted && wr.matchResult.isNotEmpty) {
            sub = wr.matchResult;
          }

          list.add(
            ScoreboardHubItem(
              matchId: wr.matchId,
              sport: 'Wrestling',
              matchType: matchType,
              status: isCompleted ? 'completed' : 'incomplete',
              title: '${_truncate8(wA)} vs ${_truncate8(wB)}',
              subtitle: sub,
              lastUpdatedAt: wr.updatedAt,
              createdAt: wr.createdAt,
              rawModel: wr,
            ),
          );
        }
      }
    } catch (_) {}

    // 15. Karate Matches from SQFlite
    try {
      final karateMatches = await KarateSqfliteService.getAllMatches();
      for (final kr in karateMatches) {
        final isSlot = kr.matchId.startsWith('SLOT_');
        final isCompleted = kr.isCompleted || kr.matchResult.isNotEmpty;
        final matchType = isSlot ? 'SLOT_DEDICATED' : 'NORMAL';

        if (isCompleted || (!isCompleted && !isSlot)) {
          final ak = kr.akaFighter.isNotEmpty ? kr.akaFighter : 'AKA Red';
          final ao = kr.aoFighter.isNotEmpty ? kr.aoFighter : 'AO Blue';

          String sub = 'Karate • ${kr.currentBoutDisplay} • ${kr.akaScore} - ${kr.aoScore} pts';
          if (isCompleted && kr.matchResult.isNotEmpty) {
            sub = kr.matchResult;
          }

          list.add(
            ScoreboardHubItem(
              matchId: kr.matchId,
              sport: 'Karate',
              matchType: matchType,
              status: isCompleted ? 'completed' : 'incomplete',
              title: '${_truncate8(ak)} vs ${_truncate8(ao)}',
              subtitle: sub,
              lastUpdatedAt: kr.updatedAt,
              createdAt: kr.createdAt,
              rawModel: kr,
            ),
          );
        }
      }
    } catch (_) {}

    // 16. Judo Matches from SQFlite
    try {
      final judoMatches = await JudoSqfliteService.getAllMatches();
      for (final jd in judoMatches) {
        final isSlot = jd.matchId.startsWith('SLOT_');
        final isCompleted = jd.isCompleted || jd.matchResult.isNotEmpty;
        final matchType = isSlot ? 'SLOT_DEDICATED' : 'NORMAL';

        if (isCompleted || (!isCompleted && !isSlot)) {
          final wA = jd.whiteFighter.isNotEmpty ? jd.whiteFighter : 'White Corner';
          final wB = jd.blueFighter.isNotEmpty ? jd.blueFighter : 'Blue Corner';

          String sub = 'Judo • ${jd.currentContestDisplay} • W:${jd.whiteWazaAri} - W:${jd.blueWazaAri}';
          if (isCompleted && jd.matchResult.isNotEmpty) {
            sub = jd.matchResult;
          }

          list.add(
            ScoreboardHubItem(
              matchId: jd.matchId,
              sport: 'Judo',
              matchType: matchType,
              status: isCompleted ? 'completed' : 'incomplete',
              title: '${_truncate8(wA)} vs ${_truncate8(wB)}',
              subtitle: sub,
              lastUpdatedAt: jd.updatedAt,
              createdAt: jd.createdAt,
              rawModel: jd,
            ),
          );
        }
      }
    } catch (_) {}

    // 17. Taekwondo Matches from SQFlite
    try {
      final tkdMatches = await TaekwondoSqfliteService.getAllMatches();
      for (final tk in tkdMatches) {
        final isSlot = tk.matchId.startsWith('SLOT_');
        final isCompleted = tk.isCompleted || tk.matchResult.isNotEmpty;
        final matchType = isSlot ? 'SLOT_DEDICATED' : 'NORMAL';

        if (isCompleted || (!isCompleted && !isSlot)) {
          final hg = tk.hongFighter.isNotEmpty ? tk.hongFighter : 'Hong Red';
          final cg = tk.chongFighter.isNotEmpty ? tk.chongFighter : 'Chong Blue';

          String sub = 'Taekwondo • ${tk.currentRoundDisplay} • ${tk.hongScore} - ${tk.chongScore} pts';
          if (isCompleted && tk.matchResult.isNotEmpty) {
            sub = tk.matchResult;
          }

          list.add(
            ScoreboardHubItem(
              matchId: tk.matchId,
              sport: 'Taekwondo',
              matchType: matchType,
              status: isCompleted ? 'completed' : 'incomplete',
              title: '${_truncate8(hg)} vs ${_truncate8(cg)}',
              subtitle: sub,
              lastUpdatedAt: tk.updatedAt,
              createdAt: tk.createdAt,
              rawModel: tk,
            ),
          );
        }
      }
    } catch (_) {}

    // 18. Muay Thai Matches from SQFlite
    try {
      final mtMatches = await MuayThaiSqfliteService.getAllMatches();
      for (final mt in mtMatches) {
        final isSlot = mt.matchId.startsWith('SLOT_');
        final isCompleted = mt.isCompleted || mt.matchResult.isNotEmpty;
        final matchType = isSlot ? 'SLOT_DEDICATED' : 'NORMAL';

        if (isCompleted || (!isCompleted && !isSlot)) {
          final fA = mt.fighterA.isNotEmpty ? mt.fighterA : 'Red Corner';
          final fB = mt.fighterB.isNotEmpty ? mt.fighterB : 'Blue Corner';

          String sub = 'Muay Thai • ${mt.currentRoundDisplay} • ${mt.fighterAScore} - ${mt.fighterBScore} pts';
          if (isCompleted && mt.matchResult.isNotEmpty) {
            sub = mt.matchResult;
          }

          list.add(
            ScoreboardHubItem(
              matchId: mt.matchId,
              sport: 'Muay Thai',
              matchType: matchType,
              status: isCompleted ? 'completed' : 'incomplete',
              title: '${_truncate8(fA)} vs ${_truncate8(fB)}',
              subtitle: sub,
              lastUpdatedAt: mt.updatedAt,
              createdAt: mt.createdAt,
              rawModel: mt,
            ),
          );
        }
      }
    } catch (_) {}

    // 7. Fetch from Firestore for participating teammates (completed matches)

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('matches')
            .where('allPlayers', arrayContains: uid)
            .where('status', isEqualTo: 'completed')
            .get();

        for (final doc in querySnapshot.docs) {
          final data = doc.data();
          final matchId = doc.id;

          if (list.any((item) => item.matchId == matchId)) {
            continue;
          }

          final isSlot = matchId.startsWith('SLOT_');
          final matchType = isSlot ? 'SLOT_DEDICATED' : 'NORMAL';

          if (data['sport'] == 'table_tennis') {
            final tt = TableTennisMatchModel.fromFirebaseJson(data);
            final teamA = tt.homeTeamName.isNotEmpty ? tt.homeTeamName : 'Player A';
            final teamB = tt.awayTeamName.isNotEmpty ? tt.awayTeamName : 'Player B';

            String sub = tt.matchResult.isNotEmpty ? tt.matchResult : 'Table Tennis';

            list.add(
              ScoreboardHubItem(
                matchId: tt.matchId,
                sport: 'Table Tennis',
                matchType: matchType,
                status: 'completed',
                title: '${_truncate8(teamA)} vs ${_truncate8(teamB)}',
                subtitle: sub,
                lastUpdatedAt: tt.lastUpdatedAt,
                createdAt: tt.createdAt,
                rawModel: tt,
              ),
            );
          } else if (data['sport'] == 'tennis' ||
              (data.containsKey('engineState') &&
                  data['engineState'] != null &&
                  (data['engineState'] as Map).containsKey('sideAPointScore'))) {
            final t = TennisMatchModel.fromFirebaseJson(data);
            final teamA = t.homeTeamName.isNotEmpty ? t.homeTeamName : 'Player A';
            final teamB = t.awayTeamName.isNotEmpty ? t.awayTeamName : 'Player B';

            String sub = t.matchResult.isNotEmpty ? t.matchResult : 'Tennis';

            list.add(
              ScoreboardHubItem(
                matchId: t.matchId,
                sport: 'Tennis',
                matchType: matchType,
                status: 'completed',
                title: '${_truncate8(teamA)} vs ${_truncate8(teamB)}',
                subtitle: sub,
                lastUpdatedAt: t.lastUpdatedAt,
                createdAt: t.createdAt,
                rawModel: t,
              ),
            );
          } else if (data.containsKey('homeTeamName')) {
            final m = CricketMatchModel.fromJson(data);
            final teamA = m.homeTeamName.isNotEmpty ? m.homeTeamName : 'Team Red';
            final teamB = m.awayTeamName.isNotEmpty ? m.awayTeamName : 'Team Blue';

            String sub = m.matchResult.isNotEmpty ? m.matchResult : 'Cricket • ${m.overs} Overs';

            list.add(
              ScoreboardHubItem(
                matchId: m.matchId,
                sport: 'Cricket',
                matchType: matchType,
                status: 'completed',
                title: '${_truncate8(teamA)} vs ${_truncate8(teamB)}',
                subtitle: sub,
                lastUpdatedAt: m.lastUpdatedAt,
                createdAt: m.createdAt,
                rawModel: m,
              ),
            );
          } else if (data.containsKey('teamAPlayers')) {
            final b = BadmintonMatchModel.fromJson(data);
            final teamA = _formatBadmintonTeamNames(b, true);
            final teamB = _formatBadmintonTeamNames(b, false);

            DateTime updatedDate = b.lastUpdatedAt ?? DateTime.now();
            String sub = b.matchResult.isNotEmpty ? b.matchResult : 'Badminton';

            list.add(
              ScoreboardHubItem(
                matchId: b.matchId,
                sport: 'Badminton',
                matchType: matchType,
                status: 'completed',
                title: '${_truncate8(teamA)} vs ${_truncate8(teamB)}',
                subtitle: sub,
                lastUpdatedAt: updatedDate,
                createdAt: b.createdAt,
                rawModel: b,
              ),
            );
          } else if (data['sport'] == 'squash') {
            final sq = SquashMatchModel.fromJson(data);
            final teamA = sq.teamAPlayers.isNotEmpty ? sq.teamAPlayers.join(', ') : 'Side A';
            final teamB = sq.teamBPlayers.isNotEmpty ? sq.teamBPlayers.join(', ') : 'Side B';

            DateTime updatedDate = sq.lastUpdatedAt ?? DateTime.now();
            String sub = sq.matchResult.isNotEmpty ? sq.matchResult : 'Squash';

            list.add(
              ScoreboardHubItem(
                matchId: sq.matchId,
                sport: 'Squash',
                matchType: matchType,
                status: 'completed',
                title: '${_truncate8(teamA)} vs ${_truncate8(teamB)}',
                subtitle: sub,
                lastUpdatedAt: updatedDate,
                createdAt: sq.createdAt,
                rawModel: sq,
              ),
            );
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching teammates' matches from Firestore: $e");
    }

    list.sort((a, b) => b.lastUpdatedAt.compareTo(a.lastUpdatedAt));
    return list;
  }

  static String _formatBadmintonTeamNames(BadmintonMatchModel b, bool isTeamA) {
    if (b.engineState != null) {
      try {
        final teamKey = isTeamA ? 'teamA' : 'teamB';
        final playersList = b.engineState![teamKey] as List?;
        if (playersList != null && playersList.isNotEmpty) {
          final names = playersList
              .map((p) => p is Map ? (p['name'] ?? '').toString() : '')
              .where((n) => n.isNotEmpty)
              .toList();
          if (names.isNotEmpty) {
            return names.map(_cleanPlayerName).join(', ');
          }
        }
      } catch (_) {}
    }

    final rawList = isTeamA ? b.teamAPlayers : b.teamBPlayers;
    if (rawList.isEmpty) return isTeamA ? 'Side A' : 'Side B';
    return rawList.map(_cleanPlayerName).join(', ');
  }

  static String _truncate8(String str) {
    if (str.length <= 8) return str;
    return str.substring(0, 8);
  }

  static String _cleanPlayerName(String raw) {
    String cleaned = raw;
    if (raw.contains('@')) {
      final part = raw.split('@').first;
      final formatted = part
          .split(RegExp(r'[._\-]'))
          .map((s) => s.isEmpty ? '' : '${s[0].toUpperCase()}${s.substring(1)}')
          .join(' ');
      cleaned = formatted.isNotEmpty ? formatted : part;
    }
    return _truncate8(cleaned);
  }

  static Future<void> resumeMatch(BuildContext context, RecoverableMatchItem item) async {
    if (item.sport == 'Cricket') {
      final controller = Get.isRegistered<CricketController>()
          ? Get.find<CricketController>()
          : Get.put(CricketController());

      final matchData = await CricketSqflite.instance.getMatch(item.matchId);
      if (matchData != null) {
        controller.restoreCricketMatchFromSqflite(matchData);
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CricketScoreboardScreen()),
          );
        }
      }
    } else if (item.sport == 'Badminton') {
      final controller = Get.isRegistered<BadmintonController>()
          ? Get.find<BadmintonController>()
          : Get.put(BadmintonController());

      final matchData = await BadmintonSqflite.instance.getMatch(item.matchId);
      if (matchData != null) {
        controller.restoreBadmintonMatchFromSqflite(matchData);
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => BadmintonScoreboardScreen()),
          );
        }
      }
    } else if (item.sport == 'Football') {
      final controller = Get.isRegistered<FootballController>()
          ? Get.find<FootballController>()
          : Get.put(FootballController());

      final matchData = await FootballSqflite.instance.getMatch(item.matchId);
      if (matchData != null) {
        controller.restoreFootballMatchFromSqflite(matchData);
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => FootballScoreboardScreen()),
          );
        }
      }
    } else if (item.sport == 'Tennis') {
      final controller = Get.isRegistered<TennisController>()
          ? Get.find<TennisController>()
          : Get.put(TennisController());

      final matchData = await TennisSqflite.instance.getMatch(item.matchId);
      if (matchData != null) {
        controller.restoreTennisMatchFromSqflite(matchData);
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TennisScoreboardScreen()),
          );
        }
      }
    } else if (item.sport == 'Table Tennis') {
      final controller = Get.isRegistered<TableTennisController>()
          ? Get.find<TableTennisController>()
          : Get.put(TableTennisController());

      final matchData = await TableTennisSqflite.instance.getMatch(item.matchId);
      if (matchData != null) {
        controller.restoreTableTennisMatchFromSqflite(matchData);
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TableTennisScoreboardScreen()),
          );
        }
      }
    } else if (item.sport == 'Squash') {
      final controller = Get.isRegistered<SquashController>()
          ? Get.find<SquashController>()
          : Get.put(SquashController());

      final matchData = await SquashSqflite.instance.getMatch(item.matchId);
      if (matchData != null) {
        controller.restoreSquashMatchFromSqflite(matchData);
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SquashScoreboardScreen()),
          );
        }
      }
    } else if (item.sport == 'Kabaddi') {
      final controller = Get.isRegistered<KabaddiController>()
          ? Get.find<KabaddiController>()
          : Get.put(KabaddiController());

      final matchData = await KabaddiSqfliteService.getMatchById(item.matchId);
      if (matchData != null) {
        controller.restoreKabaddiMatchFromSqflite(matchData);
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const KabaddiScoreboardScreen()),
          );
        }
      }
    } else if (item.sport == 'Basketball') {
      final controller = Get.isRegistered<BasketballController>()
          ? Get.find<BasketballController>()
          : Get.put(BasketballController());

      final matchData = await BasketballSqfliteService.getMatchById(item.matchId);
      if (matchData != null) {
        await controller.restoreBasketballMatchFromSqflite(matchData);
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BasketballScoreboardScreen()),
          );
        }
      }
    } else if (item.sport == 'Volleyball') {
      final controller = Get.isRegistered<VolleyballController>()
          ? Get.find<VolleyballController>()
          : Get.put(VolleyballController());

      final matchData = await VolleyballSqfliteService.getMatchById(item.matchId);
      if (matchData != null) {
        await controller.restoreVolleyballMatchFromSqflite(matchData);
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const VolleyballScoreboardScreen()),
          );
        }
      }
    } else if (item.sport == 'Hockey') {
      final controller = Get.isRegistered<HockeyController>()
          ? Get.find<HockeyController>()
          : Get.put(HockeyController());

      final matchData = await HockeySqfliteService.getMatchById(item.matchId);
      if (matchData != null) {
        await controller.restoreHockeyMatchFromSqflite(matchData);
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const HockeyScoreboardScreen()),
          );
        }
      }
    } else if (item.sport == 'Kho Kho') {
      final controller = Get.isRegistered<KhoKhoController>()
          ? Get.find<KhoKhoController>()
          : Get.put(KhoKhoController());

      final matchData = await KhoKhoSqfliteService.getMatchById(item.matchId);
      if (matchData != null) {
        await controller.restoreKhoKhoMatchFromSqflite(matchData);
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const KhoKhoScoreboardScreen()),
          );
        }
      }
    } else if (item.sport == 'Pickleball') {
      final controller = Get.isRegistered<PickleballController>()
          ? Get.find<PickleballController>()
          : Get.put(PickleballController());

      final matchData = await PickleballSqfliteService.getMatchById(item.matchId);
      if (matchData != null) {
        await controller.restorePickleballMatchFromSqflite(matchData);
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PickleballScoreboardScreen()),
          );
        }
      }
    } else if (item.sport == 'Boxing') {
      final controller = Get.isRegistered<BoxingController>()
          ? Get.find<BoxingController>()
          : Get.put(BoxingController());

      final matchData = await BoxingSqfliteService.getMatchById(item.matchId);
      if (matchData != null) {
        await controller.restoreBoxingMatchFromSqflite(matchData);
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BoxingScoreboardScreen()),
          );
        }
      }
    } else if (item.sport == 'Wrestling') {
      final controller = Get.isRegistered<WrestlingController>()
          ? Get.find<WrestlingController>()
          : Get.put(WrestlingController());

      final matchData = await WrestlingSqfliteService.getMatchById(item.matchId);
      if (matchData != null) {
        await controller.restoreWrestlingMatchFromSqflite(matchData);
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const WrestlingScoreboardScreen()),
          );
        }
      }
    } else if (item.sport == 'Karate') {
      final controller = Get.isRegistered<KarateController>()
          ? Get.find<KarateController>()
          : Get.put(KarateController());

      final matchData = await KarateSqfliteService.getMatchById(item.matchId);
      if (matchData != null) {
        await controller.restoreKarateMatchFromSqflite(matchData);
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const KarateScoreboardScreen()),
          );
        }
      }
    } else if (item.sport == 'Judo') {
      final controller = Get.isRegistered<JudoController>()
          ? Get.find<JudoController>()
          : Get.put(JudoController());

      final matchData = await JudoSqfliteService.getMatchById(item.matchId);
      if (matchData != null) {
        await controller.restoreJudoMatchFromSqflite(matchData);
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const JudoScoreboardScreen()),
          );
        }
      }
    } else if (item.sport == 'Taekwondo') {
      final controller = Get.isRegistered<TaekwondoController>()
          ? Get.find<TaekwondoController>()
          : Get.put(TaekwondoController());

      final matchData = await TaekwondoSqfliteService.getMatchById(item.matchId);
      if (matchData != null) {
        await controller.restoreTaekwondoMatchFromSqflite(matchData);
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TaekwondoScoreboardScreen()),
          );
        }
      }
    } else if (item.sport == 'Muay Thai') {
      final controller = Get.isRegistered<MuayThaiController>()
          ? Get.find<MuayThaiController>()
          : Get.put(MuayThaiController());

      final matchData = await MuayThaiSqfliteService.getMatchById(item.matchId);
      if (matchData != null) {
        await controller.restoreMuayThaiMatchFromSqflite(matchData);
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MuayThaiScoreboardScreen()),
          );
        }
      }
    }
  }

  static Future<void> discardMatch(RecoverableMatchItem item) async {
    if (item.sport == 'Cricket') {
      await CricketSqflite.instance.deleteMatch(item.matchId);
    } else if (item.sport == 'Badminton') {
      await BadmintonSqflite.instance.deleteMatch(item.matchId);
    } else if (item.sport == 'Football') {
      await FootballSqflite.instance.deleteMatch(item.matchId);
    } else if (item.sport == 'Tennis') {
      await TennisSqflite.instance.deleteMatch(item.matchId);
    } else if (item.sport == 'Table Tennis') {
      await TableTennisSqflite.instance.deleteMatch(item.matchId);
    } else if (item.sport == 'Squash') {
      await SquashSqflite.instance.deleteMatch(item.matchId);
    } else if (item.sport == 'Kabaddi') {
      await KabaddiSqfliteService.deleteMatch(item.matchId);
    } else if (item.sport == 'Basketball') {
      await BasketballSqfliteService.deleteMatch(item.matchId);
    } else if (item.sport == 'Volleyball') {
      await VolleyballSqfliteService.deleteMatch(item.matchId);
    } else if (item.sport == 'Hockey') {
      await HockeySqfliteService.deleteMatch(item.matchId);
    } else if (item.sport == 'Kho Kho') {
      await KhoKhoSqfliteService.deleteMatch(item.matchId);
    } else if (item.sport == 'Pickleball') {
      await PickleballSqfliteService.deleteMatch(item.matchId);
    } else if (item.sport == 'Boxing') {
      await BoxingSqfliteService.deleteMatch(item.matchId);
    } else if (item.sport == 'Wrestling') {
      await WrestlingSqfliteService.deleteMatch(item.matchId);
    } else if (item.sport == 'Karate') {
      await KarateSqfliteService.deleteMatch(item.matchId);
    } else if (item.sport == 'Judo') {
      await JudoSqfliteService.deleteMatch(item.matchId);
    } else if (item.sport == 'Taekwondo') {
      await TaekwondoSqfliteService.deleteMatch(item.matchId);
    } else if (item.sport == 'Muay Thai') {
      await MuayThaiSqfliteService.deleteMatch(item.matchId);
    }
  }
}
