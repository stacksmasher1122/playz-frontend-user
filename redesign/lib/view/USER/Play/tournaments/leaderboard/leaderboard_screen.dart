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

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return AppColors.coinsGold;
      case 2:
        return const Color(0xFFE0E0E0);
      case 3:
        return const Color(0xFFCD7F32);
      default:
        return AppColors.muted;
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Leaderboard",
          style: AppTypography.headlineSm.copyWith(
            color: AppColors.textPrimary,
            fontSize: context.responsiveFont(18),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
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
            return const Center(child: CircularProgressIndicator(color: AppColors.accent));
          }

          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.leaderboard_outlined, size: 48, color: AppColors.muted),
                  SizedBox(height: context.heightPct(1.5)),
                  Text(
                    "No leaderboard data available.",
                    style: AppTypography.bodyMd.copyWith(
                      color: AppColors.muted,
                      fontSize: context.responsiveFont(14),
                    ),
                  ),
                ],
              ),
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
                return const Center(child: CircularProgressIndicator(color: AppColors.accent));
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
                if (gDiffA != gDiffB) return gDiffB.compareTo(gDiffA);

                // Tiebreaker account for matches played
                int matchesPlayedA = a['matchesPlayed'] ?? 0;
                int matchesPlayedB = b['matchesPlayed'] ?? 0;
                return matchesPlayedB.compareTo(matchesPlayedA);
              });

              return ListView(
                padding: EdgeInsets.all(context.widthPct(4)),
                children: [
                  _buildHeader(context),
                  SizedBox(height: context.heightPct(1.5)),
                  ...entries.asMap().entries.map((e) => _buildRow(context, e.key + 1, e.value)),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: context.widthPct(8)), // For rank
        Expanded(
          flex: 4,
          child: Text(
            "Team",
            style: AppTypography.labelCaps10.copyWith(
              color: AppColors.muted,
              fontSize: context.responsiveFont(11),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            "W",
            textAlign: TextAlign.center,
            style: AppTypography.labelCaps10.copyWith(
              color: AppColors.muted,
              fontSize: context.responsiveFont(11),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            "L",
            textAlign: TextAlign.center,
            style: AppTypography.labelCaps10.copyWith(
              color: AppColors.muted,
              fontSize: context.responsiveFont(11),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            "Pts",
            textAlign: TextAlign.center,
            style: AppTypography.labelCaps10.copyWith(
              color: AppColors.accent,
              fontSize: context.responsiveFont(11),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRow(BuildContext context, int rank, Map<String, dynamic> entry) {
    final teamData = entry['teamData'] as Map<String, dynamic>;
    final name = teamData['name'] ?? 'Unknown Team';
    final logoUrl = teamData['logoUrl'] ?? '';
    final wins = entry['wins'] ?? 0;
    final losses = entry['losses'] ?? 0;
    final points = entry['points'] ?? 0;

    final rankColor = _getRankColor(rank);

    return Padding(
      padding: EdgeInsets.only(bottom: context.heightPct(1.5)),
      child: Container(
        padding: EdgeInsets.all(context.widthPct(3)),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
          border: Border.all(
            color: rank <= 3 ? rankColor.withValues(alpha: 0.4) : AppColors.borderDark,
            width: rank <= 3 ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: context.widthPct(8),
              child: Text(
                "$rank",
                style: AppTypography.bodyLg.copyWith(
                  color: rankColor,
                  fontWeight: FontWeight.bold,
                  fontSize: context.responsiveFont(14),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: context.minDimensionPct(4).clamp(14.0, 18.0),
                    backgroundColor: AppColors.card,
                    backgroundImage: logoUrl.isNotEmpty ? CachedNetworkImageProvider(logoUrl) : null,
                    child: logoUrl.isEmpty
                        ? const Icon(Icons.group_rounded, color: AppColors.muted, size: 16)
                        : null,
                  ),
                  SizedBox(width: context.widthPct(2)),
                  Expanded(
                    child: Text(
                      name,
                      style: AppTypography.bodyMd.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: context.responsiveFont(13.5),
                        fontWeight: rank <= 3 ? FontWeight.bold : FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                wins.toString(),
                textAlign: TextAlign.center,
                style: AppTypography.bodyMd.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: context.responsiveFont(13.5),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                losses.toString(),
                textAlign: TextAlign.center,
                style: AppTypography.bodyMd.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: context.responsiveFont(13.5),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                points.toString(),
                textAlign: TextAlign.center,
                style: AppTypography.bodyMd.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                  fontSize: context.responsiveFont(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
