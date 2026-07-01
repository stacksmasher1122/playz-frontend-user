import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Scoreboard_SQF/cricketSqflite.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/cricket_model.dart';
import 'package:intl/intl.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kBg = AppColors.background;
const kSurface = Color(0xFF0E0E0E);
const kGreen = AppColors.accent;
const kMuted = Color(0xFFA7A7A7);

class PreviousMatchesScreen extends StatefulWidget {
  PreviousMatchesScreen({super.key});

  @override
  State<PreviousMatchesScreen> createState() => _PreviousMatchesScreenState();
}

class _PreviousMatchesScreenState extends State<PreviousMatchesScreen> {
  late Future<List<CricketMatchModel>> _matchesFuture;

  @override
  void initState() {
    super.initState();
    _matchesFuture = _fetchMatches();
  }

  Future<List<CricketMatchModel>> _fetchMatches() async {
    final allMatches = await CricketSqflite.instance.getAllMatches();
    allMatches.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return allMatches.where((m) => m.status == 'completed' || m.matchResult.isNotEmpty).toList();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kBg,
        title: Text('Previous Matches', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: FutureBuilder<List<CricketMatchModel>>(
        future: _matchesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: kGreen));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No previous matches found.", style: TextStyle(color: kMuted)));
          }

          final matches = snapshot.data!;
          return ListView.builder(
            padding: EdgeInsets.all(ResponsiveHelper.w(16)),
            itemCount: matches.length,
            itemBuilder: (context, index) {
              final match = matches[index];
              return _MatchCard(match: match);
            },
          );
        },
      ),
    );
  }
}

class _MatchCard extends StatelessWidget {
  final CricketMatchModel match;
  _MatchCard({required this.match});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final dateFormat = DateFormat('MMM d, yyyy');
    
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateFormat.format(match.createdAt),
                style: TextStyle(color: kMuted, fontSize: 12),
              ),
              if (match.matchResult.isNotEmpty)
                Text(
                  match.matchResult,
                  style: TextStyle(color: kGreen, fontSize: ResponsiveHelper.sp(12), fontWeight: FontWeight.w600),
                )
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                match.homeTeamName,
                style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.sp(16), fontWeight: FontWeight.bold),
              ),
              Text('vs', style: TextStyle(color: kMuted, fontSize: 12)),
              Text(
                match.awayTeamName,
                style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.sp(16), fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 12),
          // Use inningsArray if available (Super Over ready), fallback to legacy fields
          Builder(
            builder: (_) {
              int homeRuns, homeWkts, awayRuns, awayWkts;
              if (match.inningsArray.length >= 2) {
                final i1 = match.inningsArray[0];
                final i2 = match.inningsArray[1];
                homeRuns = match.battingFirstTeam == match.homeTeamName ? (i1['runs'] ?? 0) : (i2['runs'] ?? 0);
                homeWkts = match.battingFirstTeam == match.homeTeamName ? (i1['wickets'] ?? 0) : (i2['wickets'] ?? 0);
                awayRuns = match.battingFirstTeam == match.homeTeamName ? (i2['runs'] ?? 0) : (i1['runs'] ?? 0);
                awayWkts = match.battingFirstTeam == match.homeTeamName ? (i2['wickets'] ?? 0) : (i1['wickets'] ?? 0);
              } else {
                homeRuns = match.battingFirstTeam == match.homeTeamName ? match.innings1Score : match.innings2Score;
                homeWkts = match.battingFirstTeam == match.homeTeamName ? match.innings1Wickets : match.innings2Wickets;
                awayRuns = match.battingFirstTeam == match.homeTeamName ? match.innings2Score : match.innings1Score;
                awayWkts = match.battingFirstTeam == match.homeTeamName ? match.innings2Wickets : match.innings1Wickets;
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildScore(homeRuns, homeWkts),
                  _buildScore(awayRuns, awayWkts),
                ],
              );
            },
          ),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                // Future improvement: View full scorecard
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.05),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ResponsiveHelper.w(8))),
              ),
              child: Text('View Scorecard', style: TextStyle(color: Colors.white70)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildScore(int runs, int wickets) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          '$runs',
          style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.sp(24), fontWeight: FontWeight.w800),
        ),
        Text(
          ' /$wickets',
          style: TextStyle(color: kMuted, fontSize: 14),
        ),
      ],
    );
  }
}
