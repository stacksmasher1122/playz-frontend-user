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
    ResponsiveHelper.init(context);

    return Container(
      padding: EdgeInsets.all(context.widthPct(4)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: context.minDimensionPct(5.5).clamp(20.0, 26.0),
                backgroundColor: AppColors.card,
                backgroundImage: (team.logoUrl != null && team.logoUrl!.isNotEmpty)
                    ? CachedNetworkImageProvider(team.logoUrl!)
                    : null,
                child: (team.logoUrl == null || team.logoUrl!.isEmpty)
                    ? const Icon(Icons.group_rounded, color: AppColors.muted, size: 22)
                    : null,
              ),
              SizedBox(width: context.widthPct(3)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sideTitle,
                      style: AppTypography.labelCaps10.copyWith(
                        color: AppColors.accent,
                        fontSize: context.responsiveFont(11),
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: context.heightPct(0.3)),
                    Text(
                      team.name,
                      style: AppTypography.bodyLg.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: context.responsiveFont(16),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: context.heightPct(2)),
          Text(
            "Roster",
            style: AppTypography.labelCaps10.copyWith(
              color: AppColors.muted,
              fontSize: context.responsiveFont(11),
            ),
          ),
          SizedBox(height: context.heightPct(1)),
          if (team.players.isEmpty)
            Text(
              "No players found.",
              style: AppTypography.bodySm.copyWith(
                color: AppColors.muted,
                fontSize: context.responsiveFont(12),
              ),
            )
          else
            ...team.players.map((p) => Padding(
              padding: EdgeInsets.only(bottom: context.heightPct(1)),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: context.minDimensionPct(3).clamp(10.0, 14.0),
                    backgroundColor: AppColors.card,
                    backgroundImage: (p.profileImageUrl.isNotEmpty)
                        ? CachedNetworkImageProvider(p.profileImageUrl)
                        : null,
                    child: (p.profileImageUrl.isEmpty)
                        ? const Icon(Icons.person_rounded, size: 12, color: AppColors.muted)
                        : null,
                  ),
                  SizedBox(width: context.widthPct(2.5)),
                  Expanded(
                    child: Text(
                      p.name,
                      style: AppTypography.bodyMd.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: context.responsiveFont(13.5),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (p.sportRole.isNotEmpty) ...[
                    SizedBox(width: context.widthPct(1.5)),
                    Text(
                      p.sportRole,
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.muted,
                        fontSize: context.responsiveFont(10),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            )),
        ],
      ),
    );
  }
}
