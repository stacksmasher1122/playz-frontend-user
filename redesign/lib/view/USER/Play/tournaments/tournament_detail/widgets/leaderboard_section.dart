import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';

class LeaderboardSection extends StatelessWidget {
  final String tournamentId;

  const LeaderboardSection({
    super.key,
    required this.tournamentId,
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
          Text("Leaderboard", style: AppTypography.headlineSm.copyWith(color: AppColors.onPrimary)),
          SizedBox(height: ResponsiveHelper.h(16)),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('tournaments')
                .doc(tournamentId)
                .collection('teams')
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

              // Sort teams based on points (falling back to 0 if not present)
              var teams = docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
              teams.sort((a, b) {
                int pointsA = a['points'] ?? 0;
                int pointsB = b['points'] ?? 0;
                return pointsB.compareTo(pointsA); // Descending
              });

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
                        child: Text("D", textAlign: TextAlign.center, style: AppTypography.labelCaps.copyWith(color: AppColors.muted)),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text("Pts", textAlign: TextAlign.center, style: AppTypography.labelCaps.copyWith(color: AppColors.accent)),
                      ),
                    ],
                  ),
                  SizedBox(height: ResponsiveHelper.h(12)),
                  ...teams.map((data) {
                    final name = data['name'] ?? 'Unknown Team';
                    final logoUrl = data['logoUrl'] ?? '';
                    final wins = data['wins'] ?? 0;
                    final losses = data['losses'] ?? 0;
                    final draws = data['draws'] ?? 0;
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
                            child: Text(draws.toString(), textAlign: TextAlign.center, style: AppTypography.bodyMd.copyWith(color: AppColors.onPrimary)),
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
          ),
        ],
      ),
    );
  }
}
