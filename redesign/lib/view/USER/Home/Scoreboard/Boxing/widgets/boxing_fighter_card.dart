import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/Home_Models/Friends_Model/friends_model.dart';

class BoxingFighterCard extends StatelessWidget {
  final String cornerTitle;
  final TextEditingController nameController;
  final Color accentColor;
  final Color dotColor;
  final Rxn<FriendModel> selectedFriend;
  final VoidCallback onSelectFriend;

  const BoxingFighterCard({
    super.key,
    required this.cornerTitle,
    required this.nameController,
    required this.accentColor,
    required this.dotColor,
    required this.selectedFriend,
    required this.onSelectFriend,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
        border: Border(
          left: BorderSide(color: accentColor, width: ResponsiveHelper.w(4)),
        ),
      ),
      padding: EdgeInsets.all(ResponsiveHelper.w(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: ResponsiveHelper.w(8),
                    height: ResponsiveHelper.w(8),
                    decoration: BoxDecoration(
                      color: dotColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.w(8)),
                  Text(
                    cornerTitle.toUpperCase(),
                    style: AppTypography.labelCaps.copyWith(
                      color: AppColors.mutedText,
                      fontSize: ResponsiveHelper.sp(11),
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ).responsive(context),
                  ),
                ],
              ),
              InkWell(
                onTap: onSelectFriend,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.w(10),
                    vertical: ResponsiveHelper.h(4),
                  ),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: accentColor.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.person_add_alt_1, size: 14, color: accentColor),
                      SizedBox(width: ResponsiveHelper.w(4)),
                      Text(
                        'Select Profile',
                        style: AppTypography.bodySm.copyWith(
                          color: accentColor,
                          fontSize: ResponsiveHelper.sp(11),
                          fontWeight: FontWeight.bold,
                        ).responsive(context),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(12)),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF131313),
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
            ),
            padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(14)),
            child: TextField(
              controller: nameController,
              style: AppTypography.bodyMd.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ).responsive(context),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter Fighter Name',
                hintStyle: AppTypography.bodyMd.copyWith(
                  color: AppColors.mutedText,
                ).responsive(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
