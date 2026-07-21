import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../register_team/register_team_screen.dart';

class TeamsSection extends StatelessWidget {
  final String tournamentId;
  final int maxTeams;
  final Map<String, dynamic> data;
  final String currentUserId;
  final bool isOrganizer;
  final bool isOpen;
  final bool userHasRegisteredTeam;

  const TeamsSection({
    super.key,
    required this.tournamentId,
    required this.maxTeams,
    required this.data,
    required this.currentUserId,
    required this.isOrganizer,
    required this.isOpen,
    required this.userHasRegisteredTeam,
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
              Text("Registered Teams", style: AppTypography.headlineSm.copyWith(color: AppColors.onPrimary)),
              if (isOpen && !userHasRegisteredTeam && !isOrganizer)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ResponsiveHelper.w(8))),
                    padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(8)),
                  ),
                  onPressed: () {
                    Get.to(() => RegisterTeamScreen(
                      tournamentId: tournamentId,
                      tournamentData: data,
                      currentUserId: currentUserId,
                    ));
                  },
                  child: Text(
                    "Register Team",
                    style: AppTypography.labelCaps.copyWith(color: AppColors.background, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
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
                      "No teams registered yet.",
                      style: AppTypography.bodyMd.copyWith(color: AppColors.muted),
                    ),
                  ),
                );
              }

              final docs = snapshot.data!.docs;
              return Column(
                children: docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final name = data['name'] ?? 'Unknown Team';
                  final logoUrl = data['logoUrl'] ?? '';
                  final players = data['players'] as List<dynamic>? ?? [];

                  return Padding(
                    padding: EdgeInsets.only(bottom: ResponsiveHelper.h(12)),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: ResponsiveHelper.w(20),
                          backgroundColor: AppColors.surface,
                          backgroundImage: logoUrl.isNotEmpty ? CachedNetworkImageProvider(logoUrl) : null,
                          child: logoUrl.isEmpty ? Icon(Icons.group, color: AppColors.muted) : null,
                        ),
                        SizedBox(width: ResponsiveHelper.w(12)),
                        Expanded(
                          child: Text(name, style: AppTypography.bodyLg.copyWith(color: AppColors.onPrimary)),
                        ),
                        Text(
                          "${players.length} players",
                          style: AppTypography.bodySm.copyWith(color: AppColors.muted),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
