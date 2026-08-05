import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/Home_Models/Friends_Model/friends_model.dart';

class MuayThaiFighterCard extends StatelessWidget {
  final String cornerTitle;
  final TextEditingController nameController;
  final Color accentColor;
  final Color dotColor;
  final Rxn<FriendModel> selectedFriend;
  final VoidCallback onSelectFriend;

  const MuayThaiFighterCard({
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
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: accentColor, width: 4),
          ),
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
        ),
        padding: EdgeInsets.all(ResponsiveHelper.w(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Corner Header Row
            Row(
              children: [
                Container(
                  width: ResponsiveHelper.w(10),
                  height: ResponsiveHelper.w(10),
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(8)),
                Text(
                  cornerTitle.toUpperCase(),
                  style: AppTypography.labelCaps.copyWith(
                    color: accentColor,
                    fontSize: ResponsiveHelper.sp(12),
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ).responsive(context),
                ),
              ],
            ),
            SizedBox(height: ResponsiveHelper.h(16)),

            // Name Input Field
            TextField(
              controller: nameController,
              style: AppTypography.headlineSm.copyWith(
                color: AppColors.textPrimary,
                fontSize: ResponsiveHelper.sp(16),
                fontWeight: FontWeight.bold,
              ).responsive(context),
              decoration: InputDecoration(
                hintText: 'Enter Nak Muay Name',
                hintStyle: AppTypography.bodySm.copyWith(
                  color: AppColors.mutedText,
                  fontSize: ResponsiveHelper.sp(14),
                ).responsive(context),
                filled: true,
                fillColor: const Color(0xFF131313),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.w(16),
                  vertical: ResponsiveHelper.h(14),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
                  borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
                  borderSide: BorderSide(color: accentColor, width: 1.5),
                ),
              ),
            ),
            SizedBox(height: ResponsiveHelper.h(14)),

            // Friend Selection Chip / Button
            Obx(() {
              final friend = selectedFriend.value;
              return InkWell(
                onTap: onSelectFriend,
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.w(14),
                    vertical: ResponsiveHelper.h(10),
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF131313),
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
                    border: Border.all(
                      color: friend != null ? accentColor : Colors.white.withValues(alpha: 0.05),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        friend != null ? Icons.person : Icons.person_add_alt_1,
                        color: friend != null ? accentColor : AppColors.mutedText,
                        size: ResponsiveHelper.w(18),
                      ),
                      SizedBox(width: ResponsiveHelper.w(10)),
                      Expanded(
                        child: Text(
                          friend != null
                              ? (friend.fullName.isNotEmpty ? friend.fullName : friend.email)
                              : 'Select from Friends',
                          style: AppTypography.bodySm.copyWith(
                            color: friend != null ? AppColors.textPrimary : AppColors.mutedText,
                            fontSize: ResponsiveHelper.sp(13),
                            fontWeight: friend != null ? FontWeight.bold : FontWeight.normal,
                          ).responsive(context),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: AppColors.mutedText,
                        size: ResponsiveHelper.w(18),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
