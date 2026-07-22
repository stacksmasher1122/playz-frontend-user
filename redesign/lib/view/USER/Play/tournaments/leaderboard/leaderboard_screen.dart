import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';

class LeaderboardScreen extends StatelessWidget {
  final String tournamentId;
  final String matchType;

  const LeaderboardScreen({
    super.key,
    required this.tournamentId,
    required this.matchType,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: Text("Leaderboard", style: AppTypography.headlineSm.copyWith(color: AppColors.onPrimary)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.onPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tournaments')
            .doc(tournamentId)
            .collection('leaderboard')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: AppColors.accent));
          }

          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("No leaderboard data available.", style: AppTypography.bodyMd.copyWith(color: AppColors.muted)),
            );
          }

          final docs = snapshot.data!.docs;

          // Fetch teams mapping for names/logos
          return FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection('tournaments')
                .doc(tournamentId)
                .collection('teams')
                .get(),
            builder: (context, teamSnapshot) {
              if (teamSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator(color: AppColors.accent));
              }

              Map<String, Map<String, dynamic>> teamMap = {};
              if (teamSnapshot.hasData) {
                for (var doc in teamSnapshot.data!.docs) {
                  teamMap[doc.id] = doc.data() as Map<String, dynamic>;
                }
              }

              // Combine and sort
              List<Map<String, dynamic>> entries = docs.map((doc) {
                var data = doc.data() as Map<String, dynamic>;
                data['id'] = doc.id;
                data['teamData'] = teamMap[doc.id] ?? {};
                return data;
              }).toList();

              entries.sort((a, b) {
                int pointsA = a['points'] ?? 0;
                int pointsB = b['points'] ?? 0;
                if (pointsA != pointsB) return pointsB.compareTo(pointsA);

                // Tiebreaker: Game Differential
                int gDiffA = (a['gamesWon'] ?? 0) - (a['gamesLost'] ?? 0);
                int gDiffB = (b['gamesWon'] ?? 0) - (b['gamesLost'] ?? 0);
                return gDiffB.compareTo(gDiffA);
              });

              return ListView(
                padding: EdgeInsets.all(ResponsiveHelper.w(16)),
                children: [
                  _buildHeader(),
                  SizedBox(height: ResponsiveHelper.h(12)),
                  ...entries.asMap().entries.map((e) => _buildRow(e.key + 1, e.value)),
                ],
              );
            }
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        SizedBox(width: ResponsiveHelper.w(30)), // For rank
        Expanded(
          flex: 4,
          child: Text("Team", style: AppTypography.labelCaps.copyWith(color: AppColors.muted)),
        ),
        Expanded(
          flex: 1,
          child: Text("W", textAlign: TextAlign.center, style: AppTypography.labelCaps.copyWith(color: AppColors.muted)),
        ),
        Expanded(
          flex: 1,
          child: Text("L", textAlign: TextAlign.center, style: AppTypography.labelCaps.copyWith(color: AppColors.muted)),
        ),
        Expanded(
          flex: 1,
          child: Text("Pts", textAlign: TextAlign.center, style: AppTypography.labelCaps.copyWith(color: AppColors.accent)),
        ),
      ],
    );
  }

  Widget _buildRow(int rank, Map<String, dynamic> entry) {
    final teamData = entry['teamData'] as Map<String, dynamic>;
    final name = teamData['name'] ?? 'Unknown Team';
    final logoUrl = teamData['logoUrl'] ?? '';
    final wins = entry['wins'] ?? 0;
    final losses = entry['losses'] ?? 0;
    final points = entry['points'] ?? 0;

    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveHelper.h(12)),
      child: Container(
        padding: EdgeInsets.all(ResponsiveHelper.w(12)),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
        ),
        child: Row(
          children: [
            SizedBox(
              width: ResponsiveHelper.w(30),
              child: Text("$rank", style: AppTypography.bodyLg.copyWith(color: AppColors.muted, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              flex: 4,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: ResponsiveHelper.w(16),
                    backgroundColor: AppColors.card,
                    backgroundImage: logoUrl.isNotEmpty ? CachedNetworkImageProvider(logoUrl) : null,
                    child: logoUrl.isEmpty ? Icon(Icons.group, color: AppColors.muted, size: 16) : null,
                  ),
                  SizedBox(width: ResponsiveHelper.w(8)),
                  Expanded(
                    child: Text(name, style: AppTypography.bodyMd.copyWith(color: AppColors.onPrimary), overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(wins.toString(), textAlign: TextAlign.center, style: AppTypography.bodyMd.copyWith(color: AppColors.onPrimary)),
            ),
            Expanded(
              flex: 1,
              child: Text(losses.toString(), textAlign: TextAlign.center, style: AppTypography.bodyMd.copyWith(color: AppColors.onPrimary)),
            ),
            Expanded(
              flex: 1,
              child: Text(points.toString(), textAlign: TextAlign.center, style: AppTypography.bodyMd.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
