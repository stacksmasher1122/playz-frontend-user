import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../../../model/User_Models/Tournament_Model/tournament_team_model.dart';

class FacingTeamCard extends StatelessWidget {
  final TournamentTeamModel team;
  final String sideTitle;

  const FacingTeamCard({
    super.key,
    required this.team,
    required this.sideTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: ResponsiveHelper.w(24),
                backgroundColor: AppColors.background,
                backgroundImage: (team.logoUrl != null && team.logoUrl!.isNotEmpty)
                    ? CachedNetworkImageProvider(team.logoUrl!)
                    : null,
                child: (team.logoUrl == null || team.logoUrl!.isEmpty)
                    ? Icon(Icons.group, color: AppColors.muted, size: 24)
                    : null,
              ),
              SizedBox(width: ResponsiveHelper.w(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(sideTitle, style: AppTypography.labelCaps.copyWith(color: AppColors.accent)),
                    SizedBox(height: 4),
                    Text(team.name, style: AppTypography.bodyLg.copyWith(color: AppColors.onPrimary, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(16)),
          Text("Roster", style: AppTypography.labelCaps.copyWith(color: AppColors.muted)),
          SizedBox(height: ResponsiveHelper.h(8)),
          if (team.players.isEmpty)
            Text("No players found.", style: AppTypography.bodySm.copyWith(color: AppColors.muted))
          else
            ...team.players.map((p) => Padding(
              padding: EdgeInsets.only(bottom: ResponsiveHelper.h(8)),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: AppColors.card,
                    backgroundImage: (p.profileImageUrl.isNotEmpty)
                        ? CachedNetworkImageProvider(p.profileImageUrl)
                        : null,
                    child: (p.profileImageUrl.isEmpty)
                        ? Icon(Icons.person, size: 12, color: AppColors.muted)
                        : null,
                  ),
                  SizedBox(width: ResponsiveHelper.w(8)),
                  Expanded(
                    child: Text(p.name, style: AppTypography.bodyMd.copyWith(color: AppColors.onPrimary)),
                  ),
                  if (p.sportRole.isNotEmpty)
                    Text(p.sportRole, style: AppTypography.bodySm.copyWith(color: AppColors.muted, fontSize: 10)),
                ],
              ),
            )),
        ],
      ),
    );
  }
}
