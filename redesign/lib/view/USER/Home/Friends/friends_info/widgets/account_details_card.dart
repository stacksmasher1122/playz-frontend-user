import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/model/User_Models/Home_Models/Friends_Model/player_info_model.dart';
import 'info_detail_row.dart';
import 'package:redesign/theme/responsive_helper.dart';

class AccountDetailsCard extends StatelessWidget {
  final PlayerInfoModel info;

  const AccountDetailsCard({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "ACCOUNT DETAILS",
            style: AppTypography.labelCaps10.copyWith(
              color: AppColors.textPrimary,
              fontSize: context.responsiveFont(12),
              fontWeight: FontWeight.w800,
              letterSpacing: 2.0,
            ),
          ),
        ),
        SizedBox(height: context.heightPct(1.5)),
        Container(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
            border: Border.all(color: AppColors.borderDark),
          ),
          child: Column(
            children: [
              InfoDetailRow(
                icon: Icons.alternate_email,
                title: "Username",
                value: info.username,
                valueColor: AppColors.accent,
              ),
              Divider(
                color: AppColors.borderDark,
                height: context.heightPct(0.1),
                indent: context.widthPct(4),
                endIndent: context.widthPct(4),
              ),
              InfoDetailRow(
                icon: Icons.calendar_today_outlined,
                title: "Joined",
                value: info.joinedAt != null
                    ? DateFormat('MMM yyyy').format(info.joinedAt!)
                    : "-",
                valueColor: AppColors.textPrimary,
              ),
              Divider(
                color: AppColors.borderDark,
                height: context.heightPct(0.1),
                indent: context.widthPct(4),
                endIndent: context.widthPct(4),
              ),
              InfoDetailRow(
                icon: Icons.people_outline,
                title: "Friends since",
                value: info.friendsSince != null
                    ? DateFormat('MMM yyyy').format(info.friendsSince!)
                    : "-",
                valueColor: AppColors.textPrimary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
