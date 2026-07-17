import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

import '../../../../../model/User_Models/Tournament_Model/team_model.dart';

class RegisteredTeamCard extends StatelessWidget {
  final TeamModel? team;
  final bool isEmptySlot;
  final int openSlots;

  const RegisteredTeamCard({
    super.key,
    this.team,
    this.isEmptySlot = false,
    this.openSlots = 0,
  });

  @override
  Widget build(BuildContext context) {
    if (isEmptySlot) {
      return Container(
        width: ResponsiveHelper.w(150),
        margin: EdgeInsets.only(right: ResponsiveHelper.w(16)),
        padding: EdgeInsets.all(ResponsiveHelper.w(16)),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.card,
            width: 2,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: AppColors.muted, size: ResponsiveHelper.w(32)),
            SizedBox(height: ResponsiveHelper.h(8)),
            Text(
              "$openSlots Slots Open",
              style: AppTypography.bodySm.copyWith(color: AppColors.muted),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Container(
      width: ResponsiveHelper.w(150),
      margin: EdgeInsets.only(right: ResponsiveHelper.w(16)),
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: ResponsiveHelper.w(64),
            height: ResponsiveHelper.w(64),
            margin: EdgeInsets.only(bottom: ResponsiveHelper.h(12)),
            decoration: BoxDecoration(
              color: AppColors.card,
              shape: BoxShape.circle,
            ),
            child: team?.logoUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(team!.logoUrl!, fit: BoxFit.cover),
                  )
                : Icon(Icons.group, color: AppColors.muted, size: ResponsiveHelper.w(32)),
          ),
          Text(
            team?.name ?? "Unknown",
            style: AppTypography.bodyLg.copyWith(
              color: AppColors.onPrimary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: ResponsiveHelper.h(4)),
          Text(
            "${team?.players.length ?? 0} Players",
            style: AppTypography.bodySm.copyWith(color: AppColors.muted),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
