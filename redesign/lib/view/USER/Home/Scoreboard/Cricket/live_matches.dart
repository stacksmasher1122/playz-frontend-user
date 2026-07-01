import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/cricket_model.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/cricket_controller.dart';
import 'package:intl/intl.dart';

const kBg = AppColors.background;
const kSurface = Color(0xFF0E0E0E);
const kGreen = AppColors.accent;
const kRed = Color(0xFFE53935);
const kMuted = Color(0xFFA7A7A7);

class LiveMatchesScreen extends StatelessWidget {
  const LiveMatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    
    final Query<Map<String, dynamic>> matchesQuery = FirebaseFirestore.instance
        .collection('matches')
        .where('allPlayers', arrayContains: currentUserId)
        .where('status', isEqualTo: 'live');

    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kBg,
        title: const Text('Live Matches', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: matchesQuery.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: kGreen));
          }
          if (snapshot.hasError) {
             return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: kRed)));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No live matches found.", style: TextStyle(color: kMuted)));
          }

          final matches = snapshot.data!.docs.map((doc) => CricketMatchModel.fromMap(doc.data())).toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: matches.length,
            itemBuilder: (context, index) {
              return _LiveMatchCard(match: matches[index]);
            },
          );
        },
      ),
    );
  }
}

class _LiveMatchCard extends StatelessWidget {
  final CricketMatchModel match;
  const _LiveMatchCard({required this.match});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy · hh:mm a');
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: kRed.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: kRed.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: kRed.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6, height: 6,
                      decoration: const BoxDecoration(color: kRed, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 6),
                    const Text('LIVE', style: TextStyle(color: kRed, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                  ],
                ),
              ),
              Text(
                dateFormat.format(match.createdAt),
                style: const TextStyle(color: kMuted, fontSize: 11, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildTeamRow(match.homeTeamName, match.battingFirstTeam == match.homeTeamName ? 1 : 2, match),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(color: Colors.white10),
          ),
          _buildTeamRow(match.awayTeamName, match.battingFirstTeam == match.awayTeamName ? 1 : 2, match),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    final controller = Get.find<CricketController>();
                    controller.resumeMatch(match.matchId);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kGreen,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text('Join Scoring', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTeamRow(String name, int innings, CricketMatchModel match) {
    int runs = 0, wickets = 0, overs = 0, balls = 0;
    
    if (innings == 1) {
      runs = match.innings1Score;
      wickets = match.innings1Wickets;
      overs = match.innings1Overs;
      balls = match.innings1Balls;
    } else {
      runs = match.innings2Score;
      wickets = match.innings2Wickets;
      overs = match.innings2Overs;
      balls = match.innings2Balls;
    }

    final isBatting = (match.currentInnings == innings);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              name,
              style: TextStyle(
                color: isBatting ? Colors.white : Colors.white60,
                fontSize: 16,
                fontWeight: isBatting ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
            if (isBatting) ...[
              const SizedBox(width: 8),
              const Icon(Icons.sports_cricket, color: kGreen, size: 16),
            ]
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              '$runs',
              style: TextStyle(
                color: isBatting ? kGreen : Colors.white70,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              '/$wickets',
              style: const TextStyle(color: kMuted, fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 8),
            Text(
              '($overs.$balls)',
              style: const TextStyle(color: kMuted, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}
