import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/cricket_model.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/badminton_model.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Tennis/tennis_model.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Table_Tennis/table_tennis_model.dart';
import 'package:redesign/services/scoreboard_recovery_manager.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Kabaddi/kabaddi_model.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Kabaddi/kabaddi_controller.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Kabaddi/live_match/kabaddi_scoreboard_screen.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Basketball/basketball_model.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Basketball/basketball_controller.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Basketball/live_match/basketball_scoreboard_screen.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_model.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_controller.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Volleyball/live_match/volleyball_scoreboard_screen.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Hockey/hockey_model.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Hockey/hockey_controller.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Hockey/live_match/hockey_scoreboard_screen.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Kho_Kho/khokho_model.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Kho_Kho/khokho_controller.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Kho_Kho/live_match/khokho_scoreboard_screen.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Pickleball/pickleball_model.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Pickleball/pickleball_controller.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Pickleball/live_match/pickleball_scoreboard_screen.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Boxing/boxing_model.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Boxing/boxing_controller.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Boxing/live_match/boxing_scoreboard_screen.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Wrestling/wrestling_model.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Wrestling/wrestling_controller.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Wrestling/live_match/wrestling_scoreboard_screen.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Karate/karate_model.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Karate/karate_controller.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Karate/live_match/karate_scoreboard_screen.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Judo/judo_model.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Judo/judo_controller.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Judo/live_match/judo_scoreboard_screen.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Taekwondo/taekwondo_model.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Taekwondo/taekwondo_controller.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Taekwondo/live_match/taekwondo_scoreboard_screen.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/MuayThai/muay_thai_model.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/MuayThai/muay_thai_controller.dart';
import 'package:redesign/view/USER/Home/Scoreboard/MuayThai/live_match/muay_thai_scoreboard_screen.dart';

class ScorecardDetailSheet extends StatelessWidget {
  final ScoreboardHubItem item;

  const ScorecardDetailSheet({super.key, required this.item});

  static void show(BuildContext context, ScoreboardHubItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ScorecardDetailSheet(item: item),
    );
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final maxHeight = MediaQuery.of(context).size.height * 0.88;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(20), vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    item.sport == 'Cricket'
                        ? Icons.sports_cricket
                        : (item.sport == 'Kabaddi' ? Icons.directions_run : Icons.sports_tennis),
                    color: AppColors.accent,
                    size: 24,
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(12)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: ResponsiveHelper.sp(18),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${item.sport} • ${item.createdAt != null ? DateFormat('dd MMM yyyy').format(item.createdAt!) : "02 Aug 2026"} • ${item.statusDisplay}',
                        style: GoogleFonts.inter(
                          color: AppColors.accent,
                          fontSize: ResponsiveHelper.sp(12),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          const Divider(color: Colors.white10, height: 1),

          // Content body
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(ResponsiveHelper.w(16)),
              child: _buildSportContent(),
            ),
          ),

          if (!item.isCompleted)
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    ScoreboardRecoveryManager.resumeMatch(
                      context,
                      RecoverableMatchItem(
                        matchId: item.matchId,
                        sport: item.sport,
                        matchType: item.matchType,
                        title: item.title,
                        subtitle: item.subtitle,
                        lastUpdatedAt: item.lastUpdatedAt,
                        rawModel: item.rawModel,
                      ),
                    );
                  },
                  icon: const Icon(Icons.play_arrow, color: Colors.black),
                  label: const Text(
                    'RESUME UNFINISHED MATCH NOW',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSportContent() {
    if (item.rawModel is CricketMatchModel) {
      return _buildCricketTable(item.rawModel as CricketMatchModel);
    } else if (item.rawModel is BadmintonMatchModel) {
      return _buildBadmintonTable(item.rawModel as BadmintonMatchModel);
    } else if (item.rawModel is TennisMatchModel) {
      return _buildTennisTable(item.rawModel as TennisMatchModel);
    } else if (item.rawModel is TableTennisMatchModel) {
      return _buildTableTennisTable(item.rawModel as TableTennisMatchModel);
    } else if (item.rawModel is KabaddiMatchModel) {
      return _buildKabaddiTable(item.rawModel as KabaddiMatchModel);
    } else if (item.rawModel is BasketballMatchModel) {
      return _buildBasketballTable(item.rawModel as BasketballMatchModel);
    } else if (item.rawModel is VolleyballMatchModel) {
      return _buildVolleyballTable(item.rawModel as VolleyballMatchModel);
    } else if (item.rawModel is HockeyMatchModel) {
      return _buildHockeyTable(item.rawModel as HockeyMatchModel);
    } else if (item.rawModel is KhoKhoMatchModel) {
      return _buildKhoKhoTable(item.rawModel as KhoKhoMatchModel);
    } else if (item.rawModel is PickleballMatchModel) {
      return _buildPickleballTable(item.rawModel as PickleballMatchModel);
    } else if (item.rawModel is BoxingMatchModel) {
      return _buildBoxingTable(item.rawModel as BoxingMatchModel);
    } else if (item.rawModel is WrestlingMatchModel) {
      return _buildWrestlingTable(item.rawModel as WrestlingMatchModel);
    } else if (item.rawModel is KarateMatchModel) {
      return _buildKarateTable(item.rawModel as KarateMatchModel);
    } else if (item.rawModel is JudoMatchModel) {
      return _buildJudoTable(item.rawModel as JudoMatchModel);
    } else if (item.rawModel is TaekwondoMatchModel) {
      return _buildTaekwondoTable(item.rawModel as TaekwondoMatchModel);
    } else if (item.rawModel is MuayThaiMatchModel) {
      return _buildMuayThaiTable(item.rawModel as MuayThaiMatchModel);
    }

    // Generic display fallback
    return Container(
      padding: const EdgeInsets.all(20),
      child: Text(
        item.subtitle,
        style: GoogleFonts.inter(color: Colors.white70, fontSize: 14),
      ),
    );
  }

  // ════════════════════ CRICKET TABLES ════════════════════
  Widget _buildCricketTable(CricketMatchModel cricket) {
    final Map<String, dynamic> sc = cricket.scorecard;
    final Map<String, dynamic> inn1 = sc['innings1'] as Map<String, dynamic>? ?? {};
    final Map<String, dynamic> inn2 = sc['innings2'] as Map<String, dynamic>? ?? {};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Result Card
        if (cricket.matchResult.isNotEmpty)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF14241B),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                const Icon(Icons.emoji_events_outlined, color: AppColors.accent, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    cricket.matchResult,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Score summary header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF141414),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildScoreTile(
                cricket.battingFirstTeam.isNotEmpty ? cricket.battingFirstTeam : cricket.homeTeamName,
                '${cricket.innings1Score}/${cricket.innings1Wickets}',
                '(${cricket.innings1Overs}.${cricket.innings1Balls} ov)',
              ),
              Container(height: 36, width: 1, color: Colors.white10),
              _buildScoreTile(
                cricket.bowlingFirstTeam.isNotEmpty ? cricket.bowlingFirstTeam : cricket.awayTeamName,
                '${cricket.innings2Score}/${cricket.innings2Wickets}',
                '(${cricket.innings2Overs}.${cricket.innings2Balls} ov)',
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Inning 1 Tables
        if (inn1.isNotEmpty) ...[
          _sectionHeader('1st Innings - Batting'),
          const SizedBox(height: 8),
          _buildCricketBattingTable(inn1['batting'] as List? ?? []),
          const SizedBox(height: 16),
          _sectionHeader('1st Innings - Bowling'),
          const SizedBox(height: 8),
          _buildCricketBowlingTable(inn1['bowling'] as List? ?? []),
          const SizedBox(height: 20),
        ],

        // Inning 2 Tables
        if (inn2.isNotEmpty) ...[
          _sectionHeader('2nd Innings - Batting'),
          const SizedBox(height: 8),
          _buildCricketBattingTable(inn2['batting'] as List? ?? []),
          const SizedBox(height: 16),
          _sectionHeader('2nd Innings - Bowling'),
          const SizedBox(height: 8),
          _buildCricketBowlingTable(inn2['bowling'] as List? ?? []),
        ],

        if (inn1.isEmpty && inn2.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                'No detailed ball/player scorecard available yet.',
                style: GoogleFonts.inter(color: Colors.white54, fontSize: 13),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildScoreTile(String team, String score, String overs) {
    return Column(
      children: [
        Text(
          team,
          style: GoogleFonts.inter(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          score,
          style: GoogleFonts.inter(color: AppColors.accent, fontSize: 22, fontWeight: FontWeight.w800),
        ),
        Text(
          overs,
          style: GoogleFonts.inter(color: Colors.white38, fontSize: 11),
        ),
      ],
    );
  }

  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  String _truncate8(String str) {
    if (str.length <= 8) return str;
    return str.substring(0, 8);
  }

  Widget _buildCricketBattingTable(List battingList) {
    if (battingList.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFF141414), borderRadius: BorderRadius.circular(10)),
        child: Text('No batting data', style: GoogleFonts.inter(color: Colors.white38, fontSize: 12)),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: DataTable(
          headingRowHeight: 36,
          dataRowMinHeight: 36,
          dataRowMaxHeight: 44,
          horizontalMargin: 12,
          columnSpacing: 10,
          headingRowColor: WidgetStateProperty.all(const Color(0xFF1E1E1E)),
          columns: const [
            DataColumn(label: Text('Batter', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 11))),
            DataColumn(label: Text('R', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11))),
            DataColumn(label: Text('B', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11))),
            DataColumn(label: Text('4s', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11))),
            DataColumn(label: Text('6s', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11))),
            DataColumn(label: Text('SR', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11))),
          ],
          rows: battingList.map((item) {
            final map = item as Map<String, dynamic>;
            final String rawName = map['name'] ?? map['batterName'] ?? 'Player';
            final String name = _truncate8(rawName);
            final int r = map['runs'] ?? map['r'] ?? 0;
            final int b = map['ballsFaced'] ?? map['balls'] ?? map['b'] ?? 0;
            final int f4 = map['fours'] ?? map['4s'] ?? 0;
            final int s6 = map['sixes'] ?? map['6s'] ?? 0;
            final double sr = b > 0 ? (r / b) * 100 : 0.0;

            return DataRow(
              cells: [
                DataCell(
                  Text(
                    name,
                    style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                DataCell(Text('$r', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
                DataCell(Text('$b', style: GoogleFonts.inter(color: Colors.white70, fontSize: 12))),
                DataCell(Text('$f4', style: GoogleFonts.inter(color: Colors.white70, fontSize: 12))),
                DataCell(Text('$s6', style: GoogleFonts.inter(color: Colors.white70, fontSize: 12))),
                DataCell(Text(sr.toStringAsFixed(1), style: GoogleFonts.inter(color: AppColors.accent, fontSize: 11))),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCricketBowlingTable(List bowlingList) {
    if (bowlingList.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFF141414), borderRadius: BorderRadius.circular(10)),
        child: Text('No bowling data', style: GoogleFonts.inter(color: Colors.white38, fontSize: 12)),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: DataTable(
          headingRowHeight: 36,
          dataRowMinHeight: 36,
          dataRowMaxHeight: 44,
          horizontalMargin: 12,
          columnSpacing: 10,
          headingRowColor: WidgetStateProperty.all(const Color(0xFF1E1E1E)),
          columns: const [
            DataColumn(label: Text('Bowler', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 11))),
            DataColumn(label: Text('O', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11))),
            DataColumn(label: Text('M', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11))),
            DataColumn(label: Text('R', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11))),
            DataColumn(label: Text('W', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11))),
            DataColumn(label: Text('Econ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11))),
          ],
          rows: bowlingList.map((item) {
            final map = item as Map<String, dynamic>;
            final String rawName = map['name'] ?? map['bowlerName'] ?? 'Bowler';
            final String name = _truncate8(rawName);
            final int balls = map['ballsBowled'] ?? map['balls'] ?? 0;
            final int maidens = map['maidens'] ?? map['m'] ?? 0;
            final int runs = map['runsConceded'] ?? map['runs'] ?? map['r'] ?? 0;
            final int wickets = map['wicketsTaken'] ?? map['wickets'] ?? map['w'] ?? 0;

            final String oversStr = '${balls ~/ 6}.${balls % 6}';
            final double oversNum = (balls ~/ 6) + (balls % 6) / 6.0;
            final double econ = oversNum > 0 ? (runs / oversNum) : 0.0;

            return DataRow(
              cells: [
                DataCell(
                  Text(
                    name,
                    style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                DataCell(Text(oversStr, style: GoogleFonts.inter(color: Colors.white, fontSize: 12))),
                DataCell(Text('$maidens', style: GoogleFonts.inter(color: Colors.white70, fontSize: 12))),
                DataCell(Text('$runs', style: GoogleFonts.inter(color: Colors.white70, fontSize: 12))),
                DataCell(Text('$wickets', style: GoogleFonts.inter(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 12))),
                DataCell(Text(econ.toStringAsFixed(1), style: GoogleFonts.inter(color: Colors.white70, fontSize: 11))),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  // ════════════════════ BADMINTON TABLES ════════════════════
  Widget _buildBadmintonTable(BadmintonMatchModel badminton) {
    final teamA = badminton.teamAPlayers.isNotEmpty
        ? badminton.teamAPlayers.map(_truncate8).join(', ')
        : 'Team A';
    final teamB = badminton.teamBPlayers.isNotEmpty
        ? badminton.teamBPlayers.map(_truncate8).join(', ')
        : 'Team B';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (badminton.matchResult.isNotEmpty)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF14241B),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                const Icon(Icons.emoji_events_outlined, color: AppColors.accent, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    badminton.matchResult,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

        _sectionHeader('Badminton Match Scorecard'),
        const SizedBox(height: 12),

        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF141414),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: DataTable(
              headingRowHeight: 40,
              dataRowMinHeight: 44,
              dataRowMaxHeight: 52,
              horizontalMargin: 16,
              columnSpacing: 16,
              headingRowColor: WidgetStateProperty.all(const Color(0xFF1E1E1E)),
              columns: const [
                DataColumn(label: Text('Player / Team', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 12))),
                DataColumn(label: Text('Status', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
                DataColumn(label: Text('Rules', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
              ],
              rows: [
                DataRow(
                  cells: [
                    DataCell(Text(teamA, style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                    DataCell(Text(badminton.status, style: GoogleFonts.inter(color: AppColors.accent, fontSize: 12))),
                    DataCell(Text('${badminton.pointsToWin} Pts Cap', style: GoogleFonts.inter(color: Colors.white70, fontSize: 11))),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text(teamB, style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                    DataCell(Text(badminton.status, style: GoogleFonts.inter(color: AppColors.accent, fontSize: 12))),
                    DataCell(Text('Best of ${badminton.gamesToWin * 2 - 1}', style: GoogleFonts.inter(color: Colors.white70, fontSize: 11))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ════════════════════ TENNIS TABLES ════════════════════
  Widget _buildTennisTable(TennisMatchModel tennis) {
    final teamA = tennis.homeTeamName.isNotEmpty ? _truncate8(tennis.homeTeamName) : 'Player A';
    final teamB = tennis.awayTeamName.isNotEmpty ? _truncate8(tennis.awayTeamName) : 'Player B';
    final formatStr = tennis.config['setsFormat']?.toString() ?? 'Best of 3';

    String scoreSummaryA = '0 Sets';
    String scoreSummaryB = '0 Sets';

    try {
      if (tennis.parsedEngineState != null) {
        final state = tennis.parsedEngineState!;
        final setsA = state.sideASetsWon;
        final setsB = state.sideBSetsWon;
        scoreSummaryA = '$setsA Sets';
        scoreSummaryB = '$setsB Sets';
      }
    } catch (_) {}

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (tennis.matchResult.isNotEmpty)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF14241B),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                const Icon(Icons.emoji_events_outlined, color: AppColors.accent, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    tennis.matchResult,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

        _sectionHeader('Tennis Match Scorecard'),
        const SizedBox(height: 12),

        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF141414),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: DataTable(
              headingRowHeight: 40,
              dataRowMinHeight: 44,
              dataRowMaxHeight: 52,
              horizontalMargin: 16,
              columnSpacing: 16,
              headingRowColor: WidgetStateProperty.all(const Color(0xFF1E1E1E)),
              columns: const [
                DataColumn(label: Text('Player / Team', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 12))),
                DataColumn(label: Text('Score', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
                DataColumn(label: Text('Format', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
              ],
              rows: [
                DataRow(
                  cells: [
                    DataCell(Text(teamA, style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                    DataCell(Text(scoreSummaryA, style: GoogleFonts.inter(color: AppColors.accent, fontSize: 12))),
                    DataCell(Text(formatStr, style: GoogleFonts.inter(color: Colors.white70, fontSize: 11))),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text(teamB, style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                    DataCell(Text(scoreSummaryB, style: GoogleFonts.inter(color: AppColors.accent, fontSize: 12))),
                    DataCell(Text(tennis.status, style: GoogleFonts.inter(color: Colors.white70, fontSize: 11))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ════════════════════ TABLE TENNIS TABLES ════════════════════
  Widget _buildTableTennisTable(TableTennisMatchModel tt) {
    final teamA = tt.homeTeamName.isNotEmpty ? _truncate8(tt.homeTeamName) : 'Player A';
    final teamB = tt.awayTeamName.isNotEmpty ? _truncate8(tt.awayTeamName) : 'Player B';
    final gamesFormatStr = tt.config['gamesFormat']?.toString() ?? 'Best of 5';

    String gamesWonA = '0';
    String gamesWonB = '0';

    if (tt.parsedEngineState != null) {
      final state = tt.parsedEngineState!;
      gamesWonA = '${state.sideAGamesWon} Games';
      gamesWonB = '${state.sideBGamesWon} Games';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (tt.matchResult.isNotEmpty)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF14241B),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                const Icon(Icons.emoji_events_outlined, color: AppColors.accent, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    tt.matchResult,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

        _sectionHeader('Table Tennis Match Scorecard'),
        const SizedBox(height: 12),

        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF141414),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: DataTable(
              headingRowHeight: 40,
              dataRowMinHeight: 44,
              dataRowMaxHeight: 52,
              horizontalMargin: 16,
              columnSpacing: 16,
              headingRowColor: WidgetStateProperty.all(const Color(0xFF1E1E1E)),
              columns: const [
                DataColumn(label: Text('Player / Team', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 12))),
                DataColumn(label: Text('Games Won', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
                DataColumn(label: Text('Format', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
              ],
              rows: [
                DataRow(
                  cells: [
                    DataCell(Text(teamA, style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                    DataCell(Text(gamesWonA, style: GoogleFonts.inter(color: AppColors.accent, fontSize: 12))),
                    DataCell(Text(gamesFormatStr, style: GoogleFonts.inter(color: Colors.white70, fontSize: 11))),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text(teamB, style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                    DataCell(Text(gamesWonB, style: GoogleFonts.inter(color: AppColors.accent, fontSize: 12))),
                    DataCell(Text(tt.status, style: GoogleFonts.inter(color: Colors.white70, fontSize: 11))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ════════════════════ KABADDI TABLE ════════════════════
  Widget _buildKabaddiTable(KabaddiMatchModel kb) {
    final teamA = kb.homeTeam.isNotEmpty ? kb.homeTeam : 'Side A';
    final teamB = kb.awayTeam.isNotEmpty ? kb.awayTeam : 'Side B';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (kb.matchResult.isNotEmpty)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF14241B),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                const Icon(Icons.emoji_events_outlined, color: AppColors.accent, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    kb.matchResult,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

        _sectionHeader('Kabaddi Match Scorecard'),
        const SizedBox(height: 12),

        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF141414),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: DataTable(
              headingRowHeight: 40,
              dataRowMinHeight: 44,
              dataRowMaxHeight: 52,
              horizontalMargin: 16,
              columnSpacing: 16,
              headingRowColor: WidgetStateProperty.all(const Color(0xFF1E1E1E)),
              columns: const [
                DataColumn(label: Text('Team Side', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 12))),
                DataColumn(label: Text('Total Points', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
                DataColumn(label: Text('Half', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
              ],
              rows: [
                DataRow(
                  cells: [
                    DataCell(Text(teamA, style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                    DataCell(Text('${kb.homeScore}', style: GoogleFonts.inter(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.bold))),
                    DataCell(Text(kb.currentHalf, style: GoogleFonts.inter(color: Colors.white70, fontSize: 11))),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text(teamB, style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                    DataCell(Text('${kb.awayScore}', style: GoogleFonts.inter(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.bold))),
                    DataCell(Text(kb.currentHalf, style: GoogleFonts.inter(color: Colors.white70, fontSize: 11))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ════════════════════ BASKETBALL TABLE ════════════════════
  Widget _buildBasketballTable(BasketballMatchModel bk) {
    final teamA = bk.homeTeam.isNotEmpty ? bk.homeTeam : 'Side A';
    final teamB = bk.awayTeam.isNotEmpty ? bk.awayTeam : 'Side B';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (bk.matchResult.isNotEmpty)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF14241B),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                const Icon(Icons.emoji_events_outlined, color: AppColors.accent, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    bk.matchResult,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

        _sectionHeader('Basketball Match Scorecard'),
        const SizedBox(height: 12),

        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF141414),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: DataTable(
              headingRowHeight: 40,
              dataRowMinHeight: 44,
              dataRowMaxHeight: 52,
              horizontalMargin: 16,
              columnSpacing: 16,
              headingRowColor: WidgetStateProperty.all(const Color(0xFF1E1E1E)),
              columns: const [
                DataColumn(label: Text('Team Side', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 12))),
                DataColumn(label: Text('Total Points', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
                DataColumn(label: Text('Quarter', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
              ],
              rows: [
                DataRow(
                  cells: [
                    DataCell(Text(teamA, style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                    DataCell(Text('${bk.homeScore}', style: GoogleFonts.inter(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.bold))),
                    DataCell(Text(bk.currentQuarter, style: GoogleFonts.inter(color: Colors.white70, fontSize: 11))),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text(teamB, style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                    DataCell(Text('${bk.awayScore}', style: GoogleFonts.inter(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.bold))),
                    DataCell(Text(bk.currentQuarter, style: GoogleFonts.inter(color: Colors.white70, fontSize: 11))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ════════════════════ VOLLEYBALL TABLE ════════════════════
  Widget _buildVolleyballTable(VolleyballMatchModel vl) {
    final teamA = vl.homeTeam.isNotEmpty ? vl.homeTeam : 'Side A';
    final teamB = vl.awayTeam.isNotEmpty ? vl.awayTeam : 'Side B';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (vl.matchResult.isNotEmpty)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF14241B),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                const Icon(Icons.emoji_events_outlined, color: AppColors.accent, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    vl.matchResult,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

        _sectionHeader('Volleyball Match Scorecard'),
        const SizedBox(height: 12),

        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF141414),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: DataTable(
              headingRowHeight: 40,
              dataRowMinHeight: 44,
              dataRowMaxHeight: 52,
              horizontalMargin: 16,
              columnSpacing: 16,
              headingRowColor: WidgetStateProperty.all(const Color(0xFF1E1E1E)),
              columns: const [
                DataColumn(label: Text('Team Side', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 12))),
                DataColumn(label: Text('Sets Won', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
                DataColumn(label: Text('Set Progress', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
              ],
              rows: [
                DataRow(
                  cells: [
                    DataCell(Text(teamA, style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                    DataCell(Text('${vl.homeSetsWon}', style: GoogleFonts.inter(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.bold))),
                    DataCell(Text(vl.currentSetDisplay, style: GoogleFonts.inter(color: Colors.white70, fontSize: 11))),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text(teamB, style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                    DataCell(Text('${vl.awaySetsWon}', style: GoogleFonts.inter(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.bold))),
                    DataCell(Text(vl.currentSetDisplay, style: GoogleFonts.inter(color: Colors.white70, fontSize: 11))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ════════════════════ HOCKEY TABLE ════════════════════
  Widget _buildHockeyTable(HockeyMatchModel hk) {
    final teamA = hk.homeTeam.isNotEmpty ? hk.homeTeam : 'Side A';
    final teamB = hk.awayTeam.isNotEmpty ? hk.awayTeam : 'Side B';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hk.matchResult.isNotEmpty)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF14241B),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                const Icon(Icons.emoji_events_outlined, color: AppColors.accent, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    hk.matchResult,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

        _sectionHeader('Field Hockey Match Scorecard'),
        const SizedBox(height: 12),

        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF141414),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: DataTable(
              headingRowHeight: 40,
              dataRowMinHeight: 44,
              dataRowMaxHeight: 52,
              horizontalMargin: 16,
              columnSpacing: 16,
              headingRowColor: WidgetStateProperty.all(const Color(0xFF1E1E1E)),
              columns: const [
                DataColumn(label: Text('Team Side', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 12))),
                DataColumn(label: Text('Total Goals', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
                DataColumn(label: Text('Period', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
              ],
              rows: [
                DataRow(
                  cells: [
                    DataCell(Text(teamA, style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                    DataCell(Text('${hk.homeGoals}', style: GoogleFonts.inter(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.bold))),
                    DataCell(Text(hk.currentPeriodDisplay, style: GoogleFonts.inter(color: Colors.white70, fontSize: 11))),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text(teamB, style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                    DataCell(Text('${hk.awayGoals}', style: GoogleFonts.inter(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.bold))),
                    DataCell(Text(hk.currentPeriodDisplay, style: GoogleFonts.inter(color: Colors.white70, fontSize: 11))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ════════════════════ KHO KHO TABLE ════════════════════
  Widget _buildKhoKhoTable(KhoKhoMatchModel kk) {
    final teamA = kk.homeTeam.isNotEmpty ? kk.homeTeam : 'Side A';
    final teamB = kk.awayTeam.isNotEmpty ? kk.awayTeam : 'Side B';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (kk.matchResult.isNotEmpty)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF14241B),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                const Icon(Icons.emoji_events_outlined, color: AppColors.accent, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    kk.matchResult,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

        _sectionHeader('Kho Kho Match Scorecard'),
        const SizedBox(height: 12),

        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF141414),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: DataTable(
              headingRowHeight: 40,
              dataRowMinHeight: 44,
              dataRowMaxHeight: 52,
              horizontalMargin: 16,
              columnSpacing: 16,
              headingRowColor: WidgetStateProperty.all(const Color(0xFF1E1E1E)),
              columns: const [
                DataColumn(label: Text('Team Side', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 12))),
                DataColumn(label: Text('Total Points', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
                DataColumn(label: Text('Turn', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
              ],
              rows: [
                DataRow(
                  cells: [
                    DataCell(Text(teamA, style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                    DataCell(Text('${kk.homePoints}', style: GoogleFonts.inter(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.bold))),
                    DataCell(Text(kk.currentTurnDisplay, style: GoogleFonts.inter(color: Colors.white70, fontSize: 11))),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text(teamB, style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                    DataCell(Text('${kk.awayPoints}', style: GoogleFonts.inter(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.bold))),
                    DataCell(Text(kk.currentTurnDisplay, style: GoogleFonts.inter(color: Colors.white70, fontSize: 11))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ════════════════════ PICKLEBALL TABLE ════════════════════
  Widget _buildPickleballTable(PickleballMatchModel pb) {
    final teamA = pb.homeTeam.isNotEmpty ? pb.homeTeam : 'Side A';
    final teamB = pb.awayTeam.isNotEmpty ? pb.awayTeam : 'Side B';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (pb.matchResult.isNotEmpty)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF14241B),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                const Icon(Icons.emoji_events_outlined, color: AppColors.accent, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    pb.matchResult,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

        _sectionHeader('Pickleball Match Scorecard'),
        const SizedBox(height: 12),

        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF141414),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: DataTable(
              headingRowHeight: 40,
              dataRowMinHeight: 44,
              dataRowMaxHeight: 52,
              horizontalMargin: 16,
              columnSpacing: 16,
              headingRowColor: WidgetStateProperty.all(const Color(0xFF1E1E1E)),
              columns: const [
                DataColumn(label: Text('Team / Player', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 12))),
                DataColumn(label: Text('Games Won', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
                DataColumn(label: Text('Current', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
              ],
              rows: [
                DataRow(
                  cells: [
                    DataCell(Text(teamA, style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                    DataCell(Text('${pb.homeGamesWon}', style: GoogleFonts.inter(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.bold))),
                    DataCell(Text(pb.currentScoreDisplay, style: GoogleFonts.inter(color: Colors.white70, fontSize: 11))),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text(teamB, style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                    DataCell(Text('${pb.awayGamesWon}', style: GoogleFonts.inter(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.bold))),
                    DataCell(Text(pb.currentScoreDisplay, style: GoogleFonts.inter(color: Colors.white70, fontSize: 11))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ════════════════════ BOXING TABLE ════════════════════
  Widget _buildBoxingTable(BoxingMatchModel bx) {
    final fA = bx.fighterA.isNotEmpty ? bx.fighterA : 'Red Corner';
    final fB = bx.fighterB.isNotEmpty ? bx.fighterB : 'Blue Corner';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (bx.matchResult.isNotEmpty)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF2B1414),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFFF4D4D).withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                const Icon(Icons.sports_mma, color: Color(0xFFFF4D4D), size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    bx.matchResult,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

        _sectionHeader('Boxing Fight Scorecard'),
        const SizedBox(height: 12),

        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF141414),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: DataTable(
              headingRowHeight: 40,
              dataRowMinHeight: 44,
              dataRowMaxHeight: 52,
              horizontalMargin: 16,
              columnSpacing: 16,
              headingRowColor: WidgetStateProperty.all(const Color(0xFF1E1E1E)),
              columns: const [
                DataColumn(label: Text('Fighter', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 12))),
                DataColumn(label: Text('Score', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
                DataColumn(label: Text('Round', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
              ],
              rows: [
                DataRow(
                  cells: [
                    DataCell(Text(fA, style: GoogleFonts.inter(color: const Color(0xFFFF4D4D), fontWeight: FontWeight.bold, fontSize: 13))),
                    DataCell(Text('${bx.fighterAScore}', style: GoogleFonts.inter(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.bold))),
                    DataCell(Text(bx.currentRoundDisplay, style: GoogleFonts.inter(color: Colors.white70, fontSize: 11))),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text(fB, style: GoogleFonts.inter(color: const Color(0xFF4D96FF), fontWeight: FontWeight.bold, fontSize: 13))),
                    DataCell(Text('${bx.fighterBScore}', style: GoogleFonts.inter(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.bold))),
                    DataCell(Text(bx.currentRoundDisplay, style: GoogleFonts.inter(color: Colors.white70, fontSize: 11))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ════════════════════ WRESTLING TABLE ════════════════════
  Widget _buildWrestlingTable(WrestlingMatchModel wr) {
    final wA = wr.wrestlerA.isNotEmpty ? wr.wrestlerA : 'Red Corner';
    final wB = wr.wrestlerB.isNotEmpty ? wr.wrestlerB : 'Blue Corner';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (wr.matchResult.isNotEmpty)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF2B1414),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFFF4D4D).withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                const Icon(Icons.sports_kabaddi, color: Color(0xFFFF4D4D), size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    wr.matchResult,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

        _sectionHeader('Wrestling Match Scorecard'),
        const SizedBox(height: 12),

        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF141414),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: DataTable(
              headingRowHeight: 40,
              dataRowMinHeight: 44,
              dataRowMaxHeight: 52,
              horizontalMargin: 16,
              columnSpacing: 16,
              headingRowColor: WidgetStateProperty.all(const Color(0xFF1E1E1E)),
              columns: const [
                DataColumn(label: Text('Wrestler', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 12))),
                DataColumn(label: Text('Tech Pts', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
                DataColumn(label: Text('Period', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
              ],
              rows: [
                DataRow(
                  cells: [
                    DataCell(Text(wA, style: GoogleFonts.inter(color: const Color(0xFFFF4D4D), fontWeight: FontWeight.bold, fontSize: 13))),
                    DataCell(Text('${wr.wrestlerAScore}', style: GoogleFonts.inter(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.bold))),
                    DataCell(Text(wr.currentPeriodDisplay, style: GoogleFonts.inter(color: Colors.white70, fontSize: 11))),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text(wB, style: GoogleFonts.inter(color: const Color(0xFF4D96FF), fontWeight: FontWeight.bold, fontSize: 13))),
                    DataCell(Text('${wr.wrestlerBScore}', style: GoogleFonts.inter(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.bold))),
                    DataCell(Text(wr.currentPeriodDisplay, style: GoogleFonts.inter(color: Colors.white70, fontSize: 11))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ════════════════════ KARATE TABLE ════════════════════
  Widget _buildKarateTable(KarateMatchModel kr) {
    final ak = kr.akaFighter.isNotEmpty ? kr.akaFighter : 'AKA (Red)';
    final ao = kr.aoFighter.isNotEmpty ? kr.aoFighter : 'AO (Blue)';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (kr.matchResult.isNotEmpty)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF2B1414),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFFF4D4D).withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                const Icon(Icons.sports_martial_arts, color: Color(0xFFFF4D4D), size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    kr.matchResult,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

        _sectionHeader('Karate Kumite Scorecard'),
        const SizedBox(height: 12),

        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF141414),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: DataTable(
              headingRowHeight: 40,
              dataRowMinHeight: 44,
              dataRowMaxHeight: 52,
              horizontalMargin: 16,
              columnSpacing: 16,
              headingRowColor: WidgetStateProperty.all(const Color(0xFF1E1E1E)),
              columns: const [
                DataColumn(label: Text('Karateka', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 12))),
                DataColumn(label: Text('Points', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
                DataColumn(label: Text('Bout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
              ],
              rows: [
                DataRow(
                  cells: [
                    DataCell(Text(ak, style: GoogleFonts.inter(color: const Color(0xFFFF4D4D), fontWeight: FontWeight.bold, fontSize: 13))),
                    DataCell(Text('${kr.akaScore}', style: GoogleFonts.inter(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.bold))),
                    DataCell(Text(kr.currentBoutDisplay, style: GoogleFonts.inter(color: Colors.white70, fontSize: 11))),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text(ao, style: GoogleFonts.inter(color: const Color(0xFF4D96FF), fontWeight: FontWeight.bold, fontSize: 13))),
                    DataCell(Text('${kr.aoScore}', style: GoogleFonts.inter(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.bold))),
                    DataCell(Text(kr.currentBoutDisplay, style: GoogleFonts.inter(color: Colors.white70, fontSize: 11))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ════════════════════ JUDO TABLE ════════════════════
  Widget _buildJudoTable(JudoMatchModel jd) {
    final wA = jd.whiteFighter.isNotEmpty ? jd.whiteFighter : 'WHITE Corner';
    final wB = jd.blueFighter.isNotEmpty ? jd.blueFighter : 'BLUE Corner';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (jd.matchResult.isNotEmpty)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF2B1414),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF4D96FF).withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                const Icon(Icons.sports_martial_arts, color: Color(0xFF4D96FF), size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    jd.matchResult,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

        _sectionHeader('Judo Contest Scorecard'),
        const SizedBox(height: 12),

        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF141414),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: DataTable(
              headingRowHeight: 40,
              dataRowMinHeight: 44,
              dataRowMaxHeight: 52,
              horizontalMargin: 16,
              columnSpacing: 16,
              headingRowColor: WidgetStateProperty.all(const Color(0xFF1E1E1E)),
              columns: const [
                DataColumn(label: Text('Judoka', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 12))),
                DataColumn(label: Text('Waza-ari', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
                DataColumn(label: Text('Contest', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
              ],
              rows: [
                DataRow(
                  cells: [
                    DataCell(Text(wA, style: GoogleFonts.inter(color: const Color(0xFFE0E0E0), fontWeight: FontWeight.bold, fontSize: 13))),
                    DataCell(Text('${jd.whiteWazaAri}', style: GoogleFonts.inter(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.bold))),
                    DataCell(Text(jd.currentContestDisplay, style: GoogleFonts.inter(color: Colors.white70, fontSize: 11))),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text(wB, style: GoogleFonts.inter(color: const Color(0xFF4D96FF), fontWeight: FontWeight.bold, fontSize: 13))),
                    DataCell(Text('${jd.blueWazaAri}', style: GoogleFonts.inter(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.bold))),
                    DataCell(Text(jd.currentContestDisplay, style: GoogleFonts.inter(color: Colors.white70, fontSize: 11))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ════════════════════ TAEKWONDO TABLE ════════════════════
  Widget _buildTaekwondoTable(TaekwondoMatchModel tk) {
    final hg = tk.hongFighter.isNotEmpty ? tk.hongFighter : 'HONG (Red)';
    final cg = tk.chongFighter.isNotEmpty ? tk.chongFighter : 'CHONG (Blue)';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (tk.matchResult.isNotEmpty)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF2B1414),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFFF4D4D).withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                const Icon(Icons.sports_martial_arts, color: Color(0xFFFF4D4D), size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    tk.matchResult,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

        _sectionHeader('Taekwondo Kyorugi Scorecard'),
        const SizedBox(height: 12),

        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF141414),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: DataTable(
              headingRowHeight: 40,
              dataRowMinHeight: 44,
              dataRowMaxHeight: 52,
              horizontalMargin: 16,
              columnSpacing: 16,
              headingRowColor: WidgetStateProperty.all(const Color(0xFF1E1E1E)),
              columns: const [
                DataColumn(label: Text('Taekwondoin', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 12))),
                DataColumn(label: Text('Points', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
                DataColumn(label: Text('Round', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
              ],
              rows: [
                DataRow(
                  cells: [
                    DataCell(Text(hg, style: GoogleFonts.inter(color: const Color(0xFFFF4D4D), fontWeight: FontWeight.bold, fontSize: 13))),
                    DataCell(Text('${tk.hongScore}', style: GoogleFonts.inter(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.bold))),
                    DataCell(Text(tk.currentRoundDisplay, style: GoogleFonts.inter(color: Colors.white70, fontSize: 11))),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text(cg, style: GoogleFonts.inter(color: const Color(0xFF4D96FF), fontWeight: FontWeight.bold, fontSize: 13))),
                    DataCell(Text('${tk.chongScore}', style: GoogleFonts.inter(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.bold))),
                    DataCell(Text(tk.currentRoundDisplay, style: GoogleFonts.inter(color: Colors.white70, fontSize: 11))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ════════════════════ MUAY THAI TABLE ════════════════════
  Widget _buildMuayThaiTable(MuayThaiMatchModel mt) {
    final fA = mt.fighterA.isNotEmpty ? mt.fighterA : 'RED Corner';
    final fB = mt.fighterB.isNotEmpty ? mt.fighterB : 'BLUE Corner';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (mt.matchResult.isNotEmpty)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF2B1414),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFFF4D4D).withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                const Icon(Icons.sports_mma, color: Color(0xFFFF4D4D), size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    mt.matchResult,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

        _sectionHeader('Muay Thai Scorecard (10-Point Must)'),
        const SizedBox(height: 12),

        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF141414),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: DataTable(
              headingRowHeight: 40,
              dataRowMinHeight: 44,
              dataRowMaxHeight: 52,
              horizontalMargin: 16,
              columnSpacing: 16,
              headingRowColor: WidgetStateProperty.all(const Color(0xFF1E1E1E)),
              columns: const [
                DataColumn(label: Text('Nak Muay', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 12))),
                DataColumn(label: Text('Total Pts', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
                DataColumn(label: Text('Round', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
              ],
              rows: [
                DataRow(
                  cells: [
                    DataCell(Text(fA, style: GoogleFonts.inter(color: const Color(0xFFFF4D4D), fontWeight: FontWeight.bold, fontSize: 13))),
                    DataCell(Text('${mt.fighterAScore}', style: GoogleFonts.inter(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.bold))),
                    DataCell(Text(mt.currentRoundDisplay, style: GoogleFonts.inter(color: Colors.white70, fontSize: 11))),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text(fB, style: GoogleFonts.inter(color: const Color(0xFF4D96FF), fontWeight: FontWeight.bold, fontSize: 13))),
                    DataCell(Text('${mt.fighterBScore}', style: GoogleFonts.inter(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.bold))),
                    DataCell(Text(mt.currentRoundDisplay, style: GoogleFonts.inter(color: Colors.white70, fontSize: 11))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
