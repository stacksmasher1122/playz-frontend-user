import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/cricket_model.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/badminton_model.dart';
import 'package:redesign/services/scoreboard_recovery_manager.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

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
                    item.sport == 'Cricket' ? Icons.sports_cricket : Icons.sports_tennis,
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
                        '${item.sport} • ${item.statusDisplay}',
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
        ],
      ),
    );
  }

  Widget _buildSportContent() {
    if (item.rawModel is CricketMatchModel) {
      return _buildCricketTable(item.rawModel as CricketMatchModel);
    } else if (item.rawModel is BadmintonMatchModel) {
      return _buildBadmintonTable(item.rawModel as BadmintonMatchModel);
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
            final String name = map['name'] ?? map['batterName'] ?? 'Player';
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
            final String name = map['name'] ?? map['bowlerName'] ?? 'Bowler';
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
    final teamA = badminton.teamAPlayers.isNotEmpty ? badminton.teamAPlayers.join(', ') : 'Team A';
    final teamB = badminton.teamBPlayers.isNotEmpty ? badminton.teamBPlayers.join(', ') : 'Team B';

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
}
