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
      Get.snackbar(
        "Notice",
        "No players registered.",
        backgroundColor: AppColors.card,
        colorText: AppColors.textPrimary,
      );
      return;
    }

    if (!mounted) return;

    Map<String, dynamic>? selectedPlayer = await Get.dialog<Map<String, dynamic>>(
      AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
        ),
        title: Text(
          "Select Winner for $tierTitle",
          style: AppTypography.headlineSm.copyWith(
            color: AppColors.textPrimary,
            fontSize: context.responsiveFont(16),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: context.heightPct(40).clamp(240.0, 320.0),
          child: ListView.builder(
            itemCount: allPlayers.length,
            itemBuilder: (context, index) {
              final player = allPlayers[index];
              return ListTile(
                title: Text(
                  player['name'],
                  style: AppTypography.bodyMd.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: context.responsiveFont(14),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  player['teamName'],
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.muted,
                    fontSize: context.responsiveFont(12),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () => Get.back(result: player),
              );
            },
          ),
        ),
      ),
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

      Get.snackbar(
        "Success",
        "Winner assigned to $tierTitle",
        backgroundColor: AppColors.card,
        colorText: AppColors.accent,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

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

        final isCompleted = status == 'completed';
        final List<dynamic> customWinners = tournamentData['customTierWinners'] as List<dynamic>? ?? [];
        final prizePool = tournamentData['prizePool'] ?? widget.data['prizePool'] ?? {};
        final List<dynamic> prizeTiers = prizePool['tiers'] as List<dynamic>? ?? [];
        final customTiers = prizeTiers.where((t) => (t['type'] ?? '') == 'custom').toList();

        return Container(
          padding: EdgeInsets.all(context.widthPct(4)),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
            border: Border.all(color: AppColors.accent.withValues(alpha: 0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.workspace_premium_rounded, color: AppColors.accent, size: 22),
                  SizedBox(width: context.widthPct(2)),
                  Expanded(
                    child: Text(
                      isCompleted ? "Tournament Winners" : "Live Standings & Leader",
                      style: AppTypography.headlineSm.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: context.responsiveFont(16),
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.heightPct(1.5)),

              if (customTiers.isNotEmpty)
                ...customTiers.map((tier) {
                  final String title = (tier['title'] ?? tier['name'] ?? 'Award').toString();
                  final winnerEntry = customWinners.firstWhere(
                    (w) => w is Map && w['tierTitle'] == title,
                    orElse: () => null,
                  );

                  return Padding(
                    padding: EdgeInsets.only(bottom: context.heightPct(1.2)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: AppTypography.bodyMd.copyWith(
                              color: AppColors.muted,
                              fontSize: context.responsiveFont(13),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: context.widthPct(2)),
                        if (winnerEntry != null && winnerEntry['playerName'] != null)
                          Text(
                            winnerEntry['playerName'].toString(),
                            style: AppTypography.bodyLg.copyWith(
                              color: AppColors.accent,
                              fontWeight: FontWeight.bold,
                              fontSize: context.responsiveFont(14),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        else if (widget.isOrganizer)
                          TextButton(
                            onPressed: () => _assignCustomTierWinner(title),
                            child: Text(
                              "Assign Winner",
                              style: AppTypography.labelCaps10.copyWith(
                                color: AppColors.accent,
                                fontSize: context.responsiveFont(12),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        else
                          Text(
                            "TBD",
                            style: AppTypography.bodyMd.copyWith(
                              color: AppColors.muted,
                              fontSize: context.responsiveFont(13),
                            ),
                          ),
                      ],
                    ),
                  );
                }),

              // Render Rank Tiers via Live Leaderboard
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('tournaments')
                    .doc(widget.tournamentId)
                    .collection('leaderboard')
                    .snapshots(),
                builder: (context, lbSnapshot) {
                  if (lbSnapshot.hasError || !lbSnapshot.hasData || lbSnapshot.data!.docs.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.only(top: context.heightPct(1)),
                      child: Text(
                        "Matches in progress...",
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.muted,
                          fontSize: context.responsiveFont(12),
                        ),
                      ),
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

                  int parseRank(dynamic tier) {
                    if (tier is! Map) return 1;
                    final raw = tier['rankPosition'] ?? tier['rank'];
                    if (raw is num) return raw.toInt();
                    if (raw != null) return int.tryParse(raw.toString()) ?? 1;
                    return 1;
                  }

                  final rankTiers = prizeTiers.where((t) => (t['type'] ?? '') == 'rank').toList();
                  rankTiers.sort((a, b) => parseRank(a).compareTo(parseRank(b)));

                  final displayTiers = rankTiers.isNotEmpty
                      ? rankTiers
                      : [
                          {'rankPosition': 1, 'title': isCompleted ? '1st Place Winner' : 'Current Leader'},
                          if (entries.length > 1) {'rankPosition': 2, 'title': '2nd Place'},
                          if (entries.length > 2) {'rankPosition': 3, 'title': '3rd Place'},
                        ];

                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('tournaments')
                        .doc(widget.tournamentId)
                        .collection('teams')
                        .snapshots(),
                    builder: (context, teamSnapshot) {
                      Map<String, Map<String, dynamic>> teamMap = {};
                      if (teamSnapshot.hasData) {
                        for (var doc in teamSnapshot.data!.docs) {
                          teamMap[doc.id] = doc.data() as Map<String, dynamic>;
                        }
                      }

                      return Column(
                        children: displayTiers.map((tier) {
                          final int rank = parseRank(tier);
                          final String title = (tier['title'] ?? 'Rank $rank').toString();

                          String winnerTeamId = "TBD";
                          if (rank > 0 && rank <= entries.length) {
                            var entry = entries[rank - 1];
                            winnerTeamId = (entry['id'] ?? entry['teamId'] ?? "TBD").toString();
                          }

                          String displayName = "TBD";
                          if (winnerTeamId != "TBD") {
                            final teamData = teamMap[winnerTeamId];
                            displayName = (teamData?['name'] ?? teamData?['teamName'] ?? winnerTeamId).toString();
                          }

                          return Padding(
                            padding: EdgeInsets.only(bottom: context.heightPct(1.2)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    title,
                                    style: AppTypography.bodyMd.copyWith(
                                      color: AppColors.muted,
                                      fontSize: context.responsiveFont(13),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(width: context.widthPct(2)),
                                Text(
                                  displayName,
                                  style: AppTypography.bodyLg.copyWith(
                                    color: displayName == "TBD" ? AppColors.muted : AppColors.accent,
                                    fontWeight: displayName == "TBD" ? FontWeight.normal : FontWeight.bold,
                                    fontSize: context.responsiveFont(14),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
