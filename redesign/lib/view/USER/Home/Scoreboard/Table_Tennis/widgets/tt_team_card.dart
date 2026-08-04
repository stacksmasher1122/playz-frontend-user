import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Table_Tennis/table_tennis_controller.dart';
import 'tt_friends_selection_sheet.dart';

class TtTeamCard extends StatelessWidget {
  final BuildContext context;
  final TableTennisController controller;
  final String title;
  final Color dotColor;
  final Color accentColor;
  final bool isSideA;
  final TextEditingController? textController;

  const TtTeamCard({
    super.key,
    required this.context,
    required this.controller,
    required this.title,
    required this.dotColor,
    required this.accentColor,
    required this.isSideA,
    this.textController,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
        border: Border(left: BorderSide(color: accentColor, width: 4)),
      ),
      padding: EdgeInsets.all(ResponsiveHelper.w(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title.toUpperCase(),
                style: AppTypography.labelCaps.copyWith(
                  color: accentColor.withValues(alpha: 1.0),
                  fontSize: context.responsiveFont(11),
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
              Container(
                width: ResponsiveHelper.w(10),
                height: ResponsiveHelper.h(10),
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(12)),

          if (textController != null) ...[
            TextField(
              controller: textController,
              style: AppTypography.headlineMd.copyWith(
                color: AppColors.textPrimary,
                fontSize: context.responsiveFont(18),
                fontWeight: FontWeight.w700,
              ),
              decoration: InputDecoration(
                isDense: true,
                hintText: isSideA ? 'Player / Side A Name' : 'Player / Side B Name',
                hintStyle: AppTypography.headlineMd.copyWith(
                  color: AppColors.mutedText,
                  fontSize: context.responsiveFont(18),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
            SizedBox(height: ResponsiveHelper.h(12)),
          ],

          GestureDetector(
            onTap: () => _showFriendsBottomSheet(context, isSideA),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.w(16),
                vertical: ResponsiveHelper.h(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.person_add,
                    color: AppColors.mutedText.withValues(alpha: 0.5),
                  ),
                  SizedBox(width: ResponsiveHelper.w(12)),
                  Expanded(
                    child: Obx(
                      () => Text(
                        controller.format.value == 'SINGLES'
                            ? 'Tap to add player from Friendlist'
                            : 'Tap to add partners from Friendlist',
                        style: AppTypography.bodyMd.copyWith(
                          color: AppColors.mutedText.withValues(alpha: 0.5),
                          fontSize: context.responsiveFont(14),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Obx(() {
            final roster = isSideA
                ? controller.homeTeamRoster
                : controller.awayTeamRoster;
            if (roster.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: EdgeInsets.only(top: ResponsiveHelper.h(12.0)),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: roster.map((friend) {
                  return Chip(
                    backgroundColor: Colors.black26,
                    labelStyle: AppTypography.bodySm.copyWith(
                      color: Colors.white,
                      fontSize: context.responsiveFont(12),
                    ),
                    label: Text(
                      _cleanPlayerName(
                        friend.fullName.isNotEmpty
                            ? friend.fullName
                            : friend.email,
                      ),
                    ),
                    deleteIcon: const Icon(
                      Icons.close,
                      color: AppColors.mutedText,
                      size: 16,
                    ),
                    onDeleted: () =>
                        controller.removeTeamPlayer(isSideA, friend),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(ResponsiveHelper.w(20)),
                      side: BorderSide.none,
                    ),
                  );
                }).toList(),
              ),
            );
          }),
        ],
      ),
    );
  }

  void _showFriendsBottomSheet(BuildContext context, bool isSideA) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(ResponsiveHelper.w(24))),
      ),
      isScrollControlled: true,
      builder: (context) {
        return TtFriendsSelectionSheet(
          controller: controller,
          isSideA: isSideA,
        );
      },
    );
  }

  String _cleanPlayerName(String raw) {
    String cleaned = raw;
    if (raw.contains('@')) {
      final part = raw.split('@').first;
      final formatted = part
          .split(RegExp(r'[._\-]'))
          .map((s) => s.isEmpty ? '' : '${s[0].toUpperCase()}${s.substring(1)}')
          .join(' ');
      cleaned = formatted.isNotEmpty ? formatted : part;
    }
    return cleaned;
  }
}
