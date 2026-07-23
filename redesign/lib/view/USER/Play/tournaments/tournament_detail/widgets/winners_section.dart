import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class WinnersSection extends StatefulWidget {
  final String tournamentId;
  final Map<String, dynamic> data;
  final bool isOrganizer;

  const WinnersSection({
    super.key,
    required this.tournamentId,
    required this.data,
    required this.isOrganizer,
  });

  @override
  State<WinnersSection> createState() => _WinnersSectionState();
}

class _WinnersSectionState extends State<WinnersSection> {
  List<dynamic> get prizeTiers => widget.data['prizePool']?['tiers'] ?? [];
  List<dynamic> get customTiers => prizeTiers.where((t) => (t['type'] ?? '') == 'custom').toList();

  Future<void> _assignCustomTierWinner(String tierTitle) async {
    final teamsSnapshot = await FirebaseFirestore.instance
        .collection('tournaments')
        .doc(widget.tournamentId)
        .collection('teams')
        .get();

    List<Map<String, dynamic>> allPlayers = [];
    for (var doc in teamsSnapshot.docs) {
      final teamData = doc.data();
      final players = teamData['players'] as List<dynamic>? ?? [];
      for (var p in players) {
        allPlayers.add({
          'teamId': doc.id,
          'teamName': teamData['name'] ?? 'Team',
          'userId': p['userId'] ?? '',
          'name': p['name'] ?? 'Player',
          'profileImageUrl': p['profileImageUrl'] ?? '',
        });
      }
    }

    if (allPlayers.isEmpty) {
      Get.snackbar("Notice", "No players registered.");
      return;
    }

    Map<String, dynamic>? selectedPlayer = await Get.dialog<Map<String, dynamic>>(
      AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text("Select Winner for $tierTitle", style: const TextStyle(color: Colors.white)),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: ListView.builder(
            itemCount: allPlayers.length,
            itemBuilder: (context, index) {
              final player = allPlayers[index];
              return ListTile(
                title: Text(player['name'], style: const TextStyle(color: Colors.white)),
                subtitle: Text(player['teamName'], style: TextStyle(color: AppColors.muted)),
                onTap: () => Get.back(result: player),
              );
            },
          ),
        ),
      )
    );

    if (selectedPlayer != null) {
      final tourneyDoc = await FirebaseFirestore.instance
          .collection('tournaments')
          .doc(widget.tournamentId)
          .get();
      final List currentWinners = tourneyDoc.data()?['customTierWinners'] ?? [];
      
      currentWinners.removeWhere((w) => w is Map && w['tierTitle'] == tierTitle);
      currentWinners.add({
        'tierTitle': tierTitle,
        'playerId': selectedPlayer['userId'],
        'playerName': selectedPlayer['name'],
        'teamName': selectedPlayer['teamName'],
      });

      await FirebaseFirestore.instance
          .collection('tournaments')
          .doc(widget.tournamentId)
          .update({'customTierWinners': currentWinners});

      Get.snackbar("Success", "Winner assigned to $tierTitle", backgroundColor: Colors.green, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('tournaments').doc(widget.tournamentId).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!.exists) return const SizedBox.shrink();

        final tournamentData = snapshot.data!.data() as Map<String, dynamic>? ?? {};
        final status = (tournamentData['status'] ?? widget.data['status'] ?? '').toString();

        // Show section if tournament is in_progress or completed
        if (status != 'completed' && status != 'in_progress') {
          return const SizedBox.shrink();
        }

        final List<dynamic> customWinners = tournamentData['customTierWinners'] as List<dynamic>? ?? [];
        final isCompleted = status == 'completed';

        return Container(
          padding: EdgeInsets.all(ResponsiveHelper.w(16)),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
            border: Border.all(color: AppColors.accent.withValues(alpha: 0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.workspace_premium, color: AppColors.accent),
                  const SizedBox(width: 8),
                  Text(
                    isCompleted ? "Tournament Winners" : "Live Standings & Leader",
                    style: AppTypography.headlineSm.copyWith(color: AppColors.onPrimary),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveHelper.h(16)),

              if (customTiers.isNotEmpty)
                ...customTiers.map((tier) {
                  final String title = (tier['title'] ?? tier['name'] ?? 'Award').toString();
                  final winnerEntry = customWinners.firstWhere(
                    (w) => w is Map && w['tierTitle'] == title,
                    orElse: () => null,
                  );

                  return Padding(
                    padding: EdgeInsets.only(bottom: ResponsiveHelper.h(12)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(title, style: AppTypography.bodyMd.copyWith(color: AppColors.muted)),
                        if (winnerEntry != null && winnerEntry['playerName'] != null)
                          Text(
                            winnerEntry['playerName'].toString(),
                            style: AppTypography.bodyLg.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
                          )
                        else if (widget.isOrganizer)
                          TextButton(
                            onPressed: () => _assignCustomTierWinner(title),
                            child: Text("Assign Winner", style: TextStyle(color: AppColors.accent)),
                          )
                        else
                          Text("TBD", style: AppTypography.bodyMd.copyWith(color: AppColors.muted))
                      ],
                    ),
                  );
                }),

              // Render Rank Tiers via Live Leaderboard
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('tournaments').doc(widget.tournamentId).collection('leaderboard').snapshots(),
                builder: (context, lbSnapshot) {
                  if (lbSnapshot.hasError || !lbSnapshot.hasData || lbSnapshot.data!.docs.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.only(top: ResponsiveHelper.h(8)),
                      child: Text("Matches in progress...", style: AppTypography.bodySm.copyWith(color: AppColors.muted)),
                    );
                  }

                  var entries = lbSnapshot.data!.docs.map((d) {
                    var data = d.data() as Map<String, dynamic>? ?? {};
                    data['id'] = d.id;
                    return data;
                  }).toList();

                  entries.sort((a, b) {
                    int pointsA = (a['points'] as num?)?.toInt() ?? 0;
                    int pointsB = (b['points'] as num?)?.toInt() ?? 0;
                    if (pointsA != pointsB) return pointsB.compareTo(pointsA);

                    int gDiffA = ((a['gamesWon'] as num?)?.toInt() ?? 0) - ((a['gamesLost'] as num?)?.toInt() ?? 0);
                    int gDiffB = ((b['gamesWon'] as num?)?.toInt() ?? 0) - ((b['gamesLost'] as num?)?.toInt() ?? 0);
                    if (gDiffA != gDiffB) return gDiffB.compareTo(gDiffA);

                    int matchesPlayedA = (a['matchesPlayed'] as num?)?.toInt() ?? 0;
                    int matchesPlayedB = (b['matchesPlayed'] as num?)?.toInt() ?? 0;
                    return matchesPlayedB.compareTo(matchesPlayedA);
                  });

                  final rankTiers = prizeTiers.where((t) => (t['type'] ?? '') == 'rank').toList();
                  final displayTiers = rankTiers.isNotEmpty ? rankTiers : [
                    {'rank': 1, 'title': isCompleted ? '1st Place Winner' : 'Current Leader'},
                    if (entries.length > 1) {'rank': 2, 'title': '2nd Place'},
                    if (entries.length > 2) {'rank': 3, 'title': '3rd Place'},
                  ];

                  return Column(
                    children: displayTiers.map((tier) {
                      int rank = 1;
                      if (tier['rank'] is int) {
                        rank = tier['rank'];
                      } else if (tier['rank'] != null) {
                        rank = int.tryParse(tier['rank'].toString()) ?? 1;
                      }

                      final String title = (tier['title'] ?? 'Rank $rank').toString();

                      String winnerTeamId = "TBD";
                      if (rank > 0 && rank <= entries.length) {
                        var entry = entries[rank - 1];
                        winnerTeamId = (entry['id'] ?? "TBD").toString();
                      }

                      if (winnerTeamId == "TBD") {
                        return Padding(
                          padding: EdgeInsets.only(bottom: ResponsiveHelper.h(12)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(title, style: AppTypography.bodyMd.copyWith(color: AppColors.muted)),
                              Text("TBD", style: AppTypography.bodyMd.copyWith(color: AppColors.muted)),
                            ],
                          ),
                        );
                      }

                      return Padding(
                        padding: EdgeInsets.only(bottom: ResponsiveHelper.h(12)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(title, style: AppTypography.bodyMd.copyWith(color: AppColors.muted)),
                            FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance.collection('tournaments').doc(widget.tournamentId).collection('teams').doc(winnerTeamId).get(),
                              builder: (context, teamSnapshot) {
                                String displayName = winnerTeamId;
                                if (teamSnapshot.hasData && teamSnapshot.data?.data() != null) {
                                  final tData = teamSnapshot.data!.data() as Map<String, dynamic>;
                                  displayName = (tData['name'] ?? tData['teamName'] ?? winnerTeamId).toString();
                                }
                                return Text(
                                  displayName,
                                  style: AppTypography.bodyLg.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
                                );
                              }
                            )
                          ],
                        ),
                      );
                    }).toList(),
                  );
                }
              ),
            ],
          ),
        );
      }
    );
  }
}
