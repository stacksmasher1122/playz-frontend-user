import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:intl/intl.dart';

import '../tournament_detail/tournament_detail_screen.dart';

class TournamentCard extends StatelessWidget {
  final String tournamentId;
  final Map<String, dynamic> data;
  final String currentUserId;

  const TournamentCard({
    super.key,
    required this.tournamentId,
    required this.data,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final String name = data['name'] ?? 'Tournament';
    final String sport = data['sport'] ?? 'Sport';
    final Timestamp? start = data['startDate'];
    final Timestamp? end = data['endDate'];
    final String venueName = data['venue']?['name'] ?? 'TBD';
    final Map<String, dynamic>? entryFee = data['entryFee'];
    final bool isFree = entryFee?['isFree'] ?? true;
    final num? amount = entryFee?['amount'];
    final int teamCount = data['teamCount'] ?? 0;
    final int maxTeams = (data['format']?['maxTeams'] as num?)?.toInt() ??
        (data['format']?['participantCount'] as num?)?.toInt() ??
        (data['format']?['totalTeams'] as num?)?.toInt() ??
        0;
    final String status = (data['status'] ?? '').toString();

    String dateStr = "TBD";
    if (start != null && end != null) {
      final formatter = DateFormat('MMM d');
      dateStr = "${formatter.format(start.toDate())} - ${formatter.format(end.toDate())}";
    }

    String feeStr = isFree ? "Free Entry" : "₹$amount";

    final bool isCompleted = status == 'completed';
    final bool isInProgress = status == 'in_progress';

    return GestureDetector(
      onTap: () {
        Get.to(() => TournamentDetailScreen(
          tournamentId: tournamentId,
          data: data,
          currentUserId: currentUserId,
        ));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: context.heightPct(2)),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
          border: Border.all(
            color: isCompleted
                ? AppColors.accent.withValues(alpha: 0.6)
                : (isInProgress ? AppColors.warning.withValues(alpha: 0.6) : AppColors.borderDark),
            width: isCompleted || isInProgress ? 1.5 : 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Header: Sport Icon, Dates, Status & Fee Badges
            Padding(
              padding: EdgeInsets.all(context.widthPct(4)),
              child: Row(
                children: [
                  Icon(
                    Icons.sports_soccer_rounded,
                    color: AppColors.accent,
                    size: context.minDimensionPct(6).clamp(20.0, 26.0),
                  ),
                  SizedBox(width: context.widthPct(3)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sport,
                          style: AppTypography.bodySm.copyWith(
                            color: AppColors.muted,
                            fontSize: context.responsiveFont(12),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          dateStr,
                          style: AppTypography.labelCaps10.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: context.responsiveFont(12),
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (isCompleted)
                    Container(
                      margin: EdgeInsets.only(right: context.widthPct(2)),
                      padding: EdgeInsets.symmetric(
                        horizontal: context.widthPct(2),
                        vertical: context.heightPct(0.5),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(context.minDimensionPct(2)),
                        border: Border.all(color: AppColors.accent.withValues(alpha: 0.6)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check_circle_rounded, color: AppColors.accent, size: 12),
                          SizedBox(width: context.widthPct(1)),
                          Text(
                            "COMPLETED",
                            style: AppTypography.labelCaps10.copyWith(
                              color: AppColors.accent,
                              fontWeight: FontWeight.bold,
                              fontSize: context.responsiveFont(10),
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (isInProgress)
                    Container(
                      margin: EdgeInsets.only(right: context.widthPct(2)),
                      padding: EdgeInsets.symmetric(
                        horizontal: context.widthPct(2),
                        vertical: context.heightPct(0.5),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(context.minDimensionPct(2)),
                        border: Border.all(color: AppColors.warning.withValues(alpha: 0.6)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.play_circle_fill_rounded, color: AppColors.warning, size: 12),
                          SizedBox(width: context.widthPct(1)),
                          Text(
                            "LIVE",
                            style: AppTypography.labelCaps10.copyWith(
                              color: AppColors.warning,
                              fontWeight: FontWeight.bold,
                              fontSize: context.responsiveFont(10),
                            ),
                          ),
                        ],
                      ),
                    ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.widthPct(2.5),
                      vertical: context.heightPct(0.5),
                    ),
                    decoration: BoxDecoration(
                      color: isFree ? AppColors.accent.withValues(alpha: 0.2) : AppColors.surface,
                      borderRadius: BorderRadius.circular(context.minDimensionPct(2)),
                      border: Border.all(color: isFree ? AppColors.accent : AppColors.borderDark),
                    ),
                    child: Text(
                      feeStr,
                      style: AppTypography.labelCaps10.copyWith(
                        color: isFree ? AppColors.accent : AppColors.textPrimary,
                        fontSize: context.responsiveFont(11),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(color: AppColors.borderDark, height: 1),

            // Body: Title and Venue
            Padding(
              padding: EdgeInsets.all(context.widthPct(4)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTypography.headlineSm.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: context.responsiveFont(16),
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: context.heightPct(1)),
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded, color: AppColors.muted, size: 16),
                      SizedBox(width: context.widthPct(1.5)),
                      Expanded(
                        child: Text(
                          venueName,
                          style: AppTypography.bodyMd.copyWith(
                            color: AppColors.muted,
                            fontSize: context.responsiveFont(13),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.heightPct(1.5)),
                  Row(
                    children: [
                      const Icon(Icons.groups_rounded, color: AppColors.accent, size: 18),
                      SizedBox(width: context.widthPct(1.5)),
                      Expanded(
                        child: Text(
                          maxTeams > 0 ? "$teamCount/$maxTeams registered" : "$teamCount Teams Registered",
                          style: AppTypography.bodyMd.copyWith(
                            color: AppColors.accent,
                            fontWeight: FontWeight.bold,
                            fontSize: context.responsiveFont(13.5),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
