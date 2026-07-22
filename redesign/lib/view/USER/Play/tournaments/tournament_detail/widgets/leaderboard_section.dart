import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import '../../leaderboard/leaderboard_screen.dart';

class LeaderboardSection extends StatelessWidget {
  final String tournamentId;
  final String matchType;

  const LeaderboardSection({
    super.key,
    required this.tournamentId,
    required this.matchType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Leaderboard", style: AppTypography.headlineSm.copyWith(color: AppColors.onPrimary)),
              TextButton(
                onPressed: () {
                  Get.to(() => LeaderboardScreen(
                    tournamentId: tournamentId,
                    matchType: matchType,
                  ));
                },
                child: Text("View All", style: AppTypography.labelCaps.copyWith(color: AppColors.accent)),
              )
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(16)),
          StreamBuilder<QuerySnapshot>(
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
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
                    child: Text(
                      "No data available yet.",
                      style: AppTypography.bodyMd.copyWith(color: AppColors.muted),
                    ),
                  ),
                );
              }

              final docs = snapshot.data!.docs;

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

                    int gDiffA = (a['gamesWon'] ?? 0) - (a['gamesLost'] ?? 0);
                    int gDiffB = (b['gamesWon'] ?? 0) - (b['gamesLost'] ?? 0);
                    if (gDiffA != gDiffB) return gDiffB.compareTo(gDiffA);

                    // A13 Fix: Leaderboard tiebreaker should account for matches played
                    int matchesPlayedA = a['matchesPlayed'] ?? 0;
                    int matchesPlayedB = b['matchesPlayed'] ?? 0;
                    return matchesPlayedB.compareTo(matchesPlayedA);
                  });

                  // Just show top 5 in preview
                  var teams = entries.take(5).toList();

                  return Column(
                    children: [
                      Row(
                        children: [
                      Expanded(
                        flex: 3,
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
                  ),
                  SizedBox(height: ResponsiveHelper.h(12)),
                  ...teams.map((data) {
                    final teamData = data['teamData'] as Map<String, dynamic>? ?? {};
                    final name = teamData['name'] ?? 'Unknown Team';
                    final logoUrl = teamData['logoUrl'] ?? '';
                    final wins = data['wins'] ?? 0;
                    final losses = data['losses'] ?? 0;
                    final points = data['points'] ?? 0;

                    return Padding(
                      padding: EdgeInsets.only(bottom: ResponsiveHelper.h(12)),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: ResponsiveHelper.w(16),
                                  backgroundColor: AppColors.surface,
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
                    );
                  }).toList(),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
