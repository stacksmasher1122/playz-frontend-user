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
  // Extract custom tiers
  List<dynamic> get prizeTiers => widget.data['prizePool']?['tiers'] ?? [];
  List<dynamic> get customTiers => prizeTiers.where((t) => t['type'] == 'custom').toList();

  Future<void> _assignCustomTierWinner(String tierTitle) async {
    // 1. Fetch all teams to get all players
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
          'teamName': teamData['name'],
          'userId': p['userId'],
          'name': p['name'],
          'profileImageUrl': p['profileImageUrl'],
        });
      }
    }

    if (allPlayers.isEmpty) {
      Get.snackbar("Notice", "No players registered.");
      return;
    }

    // 2. Show picker dialog
    Map<String, dynamic>? selectedPlayer = await Get.dialog<Map<String, dynamic>>(
      AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text("Select $tierTitle", style: TextStyle(color: Colors.white)),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: ListView.builder(
            itemCount: allPlayers.length,
            itemBuilder: (context, index) {
              final player = allPlayers[index];
              return ListTile(
                title: Text(player['name'], style: TextStyle(color: Colors.white)),
                subtitle: Text(player['teamName'], style: TextStyle(color: AppColors.muted)),
                onTap: () => Get.back(result: player),
              );
            },
          ),
        ),
      )
    );

    if (selectedPlayer != null) {
      // 3. Save to tournament document
      final List currentWinners = widget.data['customTierWinners'] ?? [];
      currentWinners.add({
        'tierTitle': tierTitle,
        'playerId': selectedPlayer['userId'],
        'playerName': selectedPlayer['name'],
      });

      await FirebaseFirestore.instance
          .collection('tournaments')
          .doc(widget.tournamentId)
          .update({'customTierWinners': currentWinners});

      // Note: In a real app we'd refresh the state of the parent or listen via stream.
      // Since this is a simple widget, a stream is best or just a snackbar for now.
      Get.snackbar("Success", "Winner assigned to $tierTitle");
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isCompleted = widget.data['status'] == 'completed';
    if (!isCompleted) return SizedBox.shrink();

    List<dynamic> customWinners = widget.data['customTierWinners'] ?? [];

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
              SizedBox(width: 8),
              Text("Tournament Winners", style: AppTypography.headlineSm.copyWith(color: AppColors.onPrimary)),
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(16)),

          if (customTiers.isNotEmpty)
            ...customTiers.map((tier) {
              String title = tier['title'];
              var winnerEntry = customWinners.firstWhere((w) => w['tierTitle'] == title, orElse: () => null);

              return Padding(
                padding: EdgeInsets.only(bottom: ResponsiveHelper.h(12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: AppTypography.bodyMd.copyWith(color: AppColors.muted)),
                    if (winnerEntry != null)
                      Text(winnerEntry['playerName'], style: AppTypography.bodyLg.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold))
                    else if (widget.isOrganizer)
                      TextButton(
                        onPressed: () => _assignCustomTierWinner(title),
                        child: Text("Assign", style: TextStyle(color: AppColors.accent)),
                      )
                    else
                      Text("TBD", style: AppTypography.bodyMd.copyWith(color: AppColors.muted))
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}
