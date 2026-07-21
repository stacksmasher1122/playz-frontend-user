import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
    final String name = data['name'] ?? 'Tournament';
    final String sport = data['sport'] ?? 'Sport';
    final Timestamp? start = data['startDate'];
    final Timestamp? end = data['endDate'];
    final String venueName = data['venue']?['name'] ?? 'TBD';
    final Map<String, dynamic>? entryFee = data['entryFee'];
    final bool isFree = entryFee?['isFree'] ?? true;
    final num? amount = entryFee?['amount'];
    final int teamCount = data['teamCount'] ?? 0;

    String dateStr = "TBD";
    if (start != null && end != null) {
      final formatter = DateFormat('MMM d');
      dateStr = "${formatter.format(start.toDate())} - ${formatter.format(end.toDate())}";
    }

    String feeStr = isFree ? "Free Entry" : "₹$amount";

    return GestureDetector(
      onTap: () {
        Get.to(() => TournamentDetailScreen(
          tournamentId: tournamentId,
          data: data,
          currentUserId: currentUserId,
        ));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: ResponsiveHelper.h(16)),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
          border: Border.all(color: AppColors.card),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Header: Sport Icon, Dates, Fee Badge
            Padding(
              padding: EdgeInsets.all(ResponsiveHelper.w(16)),
              child: Row(
                children: [
                  Icon(Icons.sports_soccer, color: AppColors.accent, size: ResponsiveHelper.w(24)),
                  SizedBox(width: ResponsiveHelper.w(12)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sport,
                          style: AppTypography.bodySm.copyWith(color: AppColors.muted),
                        ),
                        Text(
                          dateStr,
                          style: AppTypography.labelCaps.copyWith(color: AppColors.onPrimary),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(10), vertical: ResponsiveHelper.h(4)),
                    decoration: BoxDecoration(
                      color: isFree ? AppColors.accent.withOpacity(0.2) : AppColors.surface,
                      borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                      border: Border.all(color: isFree ? AppColors.accent : AppColors.outlineVariant),
                    ),
                    child: Text(
                      feeStr,
                      style: AppTypography.labelCaps.copyWith(
                        color: isFree ? AppColors.accent : AppColors.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Divider(color: AppColors.surface, height: 1),

            // Body: Title and Venue
            Padding(
              padding: EdgeInsets.all(ResponsiveHelper.w(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTypography.headlineSm.copyWith(color: AppColors.onPrimary),
                  ),
                  SizedBox(height: ResponsiveHelper.h(8)),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: AppColors.muted, size: ResponsiveHelper.w(16)),
                      SizedBox(width: ResponsiveHelper.w(6)),
                      Text(
                        venueName,
                        style: AppTypography.bodyMd.copyWith(color: AppColors.muted),
                      ),
                    ],
                  ),
                  SizedBox(height: ResponsiveHelper.h(16)),
                  Row(
                    children: [
                      Icon(Icons.groups, color: AppColors.accent, size: ResponsiveHelper.w(16)),
                      SizedBox(width: ResponsiveHelper.w(6)),
                      Text(
                        "$teamCount Teams Registered",
                        style: AppTypography.bodyMd.copyWith(color: AppColors.accent),
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
