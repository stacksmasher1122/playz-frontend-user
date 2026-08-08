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
          "Leaderboard & Standings",
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

          return FutureBuilder<List<dynamic>>(
            future: Future.wait([
              FirebaseFirestore.instance
                  .collection('tournaments')
                  .doc(tournamentId)
                  .collection('teams')
                  .get(),
              FirebaseFirestore.instance
                  .collection('tournaments')
                  .doc(tournamentId)
                  .get(),
            ]),
            builder: (context, asyncSnap) {
              if (asyncSnap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: AppColors.accent));
              }

              Map<String, Map<String, dynamic>> teamMap = {};
              String sportName = 'Cricket';

              if (asyncSnap.hasData && asyncSnap.data != null) {
                final teamSnap = asyncSnap.data![0] as QuerySnapshot;
                for (var doc in teamSnap.docs) {
                  teamMap[doc.id] = doc.data() as Map<String, dynamic>;
                }
                final tourneyDoc = asyncSnap.data![1] as DocumentSnapshot;
                if (tourneyDoc.exists) {
                  sportName = (tourneyDoc.data() as Map<String, dynamic>?)?['sport'] ?? 'Cricket';
                }
              }

              final String sportLower = sportName.toLowerCase();

              // Combine and sort entries
              List<Map<String, dynamic>> entries = docs.map((doc) {
                var data = doc.data() as Map<String, dynamic>;
                data['id'] = doc.id;
                data['teamData'] = teamMap[doc.id] ?? {};

                // Calculate Net Run Rate if cricket statistics are present
                double runsScored = (data['runsScored'] as num?)?.toDouble() ?? 0.0;
                double runsConceded = (data['runsConceded'] as num?)?.toDouble() ?? 0.0;
                double oversFaced = (data['oversFaced'] as num?)?.toDouble() ?? 0.0;
                double oversBowled = (data['oversBowled'] as num?)?.toDouble() ?? 0.0;

                double computedNrr = 0.0;
                if (oversFaced > 0 && oversBowled > 0) {
                  computedNrr = (runsScored / oversFaced) - (runsConceded / oversBowled);
                } else if (data['nrr'] != null) {
                  computedNrr = (data['nrr'] as num).toDouble();
                }
                data['computedNrr'] = computedNrr;

                return data;
              }).toList();

              entries.sort((a, b) {
                int pointsA = a['points'] ?? 0;
                int pointsB = b['points'] ?? 0;
                if (pointsA != pointsB) return pointsB.compareTo(pointsA);

                if (sportLower == 'cricket') {
                  double nrrA = (a['computedNrr'] as num?)?.toDouble() ?? 0.0;
                  double nrrB = (b['computedNrr'] as num?)?.toDouble() ?? 0.0;
                  if (nrrA != nrrB) return nrrB.compareTo(nrrA);
                } else if (sportLower == 'football') {
                  int gdA = (a['goalDifference'] as num?)?.toInt() ??
                      (((a['goalsScored'] as num?)?.toInt() ?? 0) - ((a['goalsConceded'] as num?)?.toInt() ?? 0));
                  int gdB = (b['goalDifference'] as num?)?.toInt() ??
                      (((b['goalsScored'] as num?)?.toInt() ?? 0) - ((b['goalsConceded'] as num?)?.toInt() ?? 0));
                  if (gdA != gdB) return gdB.compareTo(gdA);

                  int gsA = (a['goalsScored'] as num?)?.toInt() ?? 0;
                  int gsB = (b['goalsScored'] as num?)?.toInt() ?? 0;
                  if (gsA != gsB) return gsB.compareTo(gsA);
                } else {
                  int gDiffA = (a['gamesWon'] ?? 0) - (a['gamesLost'] ?? 0);
                  int gDiffB = (b['gamesWon'] ?? 0) - (b['gamesLost'] ?? 0);
                  if (gDiffA != gDiffB) return gDiffB.compareTo(gDiffA);
                }

                int matchesPlayedA = a['matchesPlayed'] ?? 0;
                int matchesPlayedB = b['matchesPlayed'] ?? 0;
                return matchesPlayedB.compareTo(matchesPlayedA);
              });

              return ListView(
                padding: EdgeInsets.all(context.widthPct(4)),
                children: [
                  _buildHeader(context, sportLower),
                  SizedBox(height: context.heightPct(1.5)),
                  ...entries.asMap().entries.map((e) => _buildRow(context, e.key + 1, e.value, sportLower)),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String sportLower) {
    String col4 = "L";
    String col5 = "NRR";
    if (sportLower == 'football') {
      col4 = "D";
      col5 = "GD";
    } else if (sportLower == 'badminton') {
      col4 = "GW";
      col5 = "GL";
    }

    return Row(
      children: [
        SizedBox(width: context.widthPct(7)), // For rank
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
            "P",
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
            col4,
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
            col5,
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

  Widget _buildRow(BuildContext context, int rank, Map<String, dynamic> entry, String sportLower) {
    final teamData = entry['teamData'] as Map<String, dynamic>;
    final name = teamData['name'] ?? 'Unknown Team';
    final logoUrl = teamData['logoUrl'] ?? '';
    final played = entry['matchesPlayed'] ?? 0;
    final wins = entry['wins'] ?? 0;
    final losses = entry['losses'] ?? 0;
    final draws = entry['draws'] ?? 0;
    final points = entry['points'] ?? 0;
    final double nrr = (entry['computedNrr'] as num?)?.toDouble() ?? 0.0;
    final int gd = (entry['goalDifference'] as num?)?.toInt() ??
        (((entry['goalsScored'] as num?)?.toInt() ?? 0) - ((entry['goalsConceded'] as num?)?.toInt() ?? 0));
    final int gw = entry['gamesWon'] ?? 0;
    final int gl = entry['gamesLost'] ?? 0;

    final rankColor = _getRankColor(rank);

    Widget col4Widget;
    Widget col5Widget;

    if (sportLower == 'football') {
      col4Widget = Text(
        draws.toString(),
        textAlign: TextAlign.center,
        style: AppTypography.bodyMd.copyWith(
          color: AppColors.textPrimary,
          fontSize: context.responsiveFont(12.5),
        ),
      );
      col5Widget = Text(
        gd >= 0 ? "+$gd" : "$gd",
        textAlign: TextAlign.center,
        style: AppTypography.bodySm.copyWith(
          color: gd >= 0 ? Colors.greenAccent : Colors.redAccent,
          fontSize: context.responsiveFont(11.0),
          fontWeight: FontWeight.w600,
        ),
      );
    } else if (sportLower == 'badminton') {
      col4Widget = Text(
        gw.toString(),
        textAlign: TextAlign.center,
        style: AppTypography.bodyMd.copyWith(
          color: AppColors.textPrimary,
          fontSize: context.responsiveFont(12.5),
        ),
      );
      col5Widget = Text(
        gl.toString(),
        textAlign: TextAlign.center,
        style: AppTypography.bodyMd.copyWith(
          color: AppColors.textPrimary,
          fontSize: context.responsiveFont(12.5),
        ),
      );
    } else {
      col4Widget = Text(
        losses.toString(),
        textAlign: TextAlign.center,
        style: AppTypography.bodyMd.copyWith(
          color: AppColors.textPrimary,
          fontSize: context.responsiveFont(12.5),
        ),
      );
      col5Widget = Text(
        nrr >= 0 ? "+${nrr.toStringAsFixed(2)}" : nrr.toStringAsFixed(2),
        textAlign: TextAlign.center,
        style: AppTypography.bodySm.copyWith(
          color: nrr >= 0 ? Colors.greenAccent : Colors.redAccent,
          fontSize: context.responsiveFont(11.0),
          fontWeight: FontWeight.w600,
        ),
      );
    }

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
              width: context.widthPct(7),
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
                        fontSize: context.responsiveFont(13.0),
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
                played.toString(),
                textAlign: TextAlign.center,
                style: AppTypography.bodyMd.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: context.responsiveFont(12.5),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                wins.toString(),
                textAlign: TextAlign.center,
                style: AppTypography.bodyMd.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: context.responsiveFont(12.5),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: col4Widget,
            ),
            Expanded(
              flex: 1,
              child: col5Widget,
            ),
            Expanded(
              flex: 1,
              child: Text(
                points.toString(),
                textAlign: TextAlign.center,
                style: AppTypography.bodyMd.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                  fontSize: context.responsiveFont(13.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
