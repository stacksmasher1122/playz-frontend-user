import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Squash/squash_controller.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Cricket/cricket_setup/widgets/friends_selection_sheet.dart';

class SquashTeamCard extends StatelessWidget {
  final BuildContext context;
  final SquashController controller;
  final String title;
  final Color dotColor;
  final Color accentColor;
  final bool isSideA;
  final TextEditingController textController;

  const SquashTeamCard({
    super.key,
    required this.context,
    required this.controller,
    required this.title,
    required this.dotColor,
    required this.accentColor,
    required this.isSideA,
    required this.textController,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final roster = isSideA ? controller.teamARoster : controller.teamBRoster;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveHelper.w(20)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
        border: Border(left: BorderSide(color: accentColor, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Directly Editable Red/Accent Side Header Text (Badminton Pattern)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextField(
                  controller: textController,
                  style: AppTypography.labelCaps.copyWith(
                    color: accentColor,
                    fontSize: context.responsiveFont(14),
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: title.toUpperCase(),
                    hintStyle: AppTypography.labelCaps.copyWith(
                      color: accentColor.withValues(alpha: 0.6),
                      fontSize: context.responsiveFont(14),
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
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
          SizedBox(height: ResponsiveHelper.h(14)),

          // 2. Search & Add Players from Friendlist Button (Friendlist Only)
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
                        controller.format.value == 'Singles'
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

          // 3. Selected Player Chips
          Obx(
            () => roster.isEmpty
                ? const SizedBox.shrink()
                : Padding(
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
                              friend.fullName.isNotEmpty ? friend.fullName : friend.email,
                            ),
                          ),
                          deleteIcon: const Icon(
                            Icons.close,
                            color: AppColors.mutedText,
                            size: 16,
                          ),
                          onDeleted: () => controller.removeTeamPlayer(isSideA, friend),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
                            side: BorderSide.none,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _showFriendsBottomSheet(BuildContext context, bool isSideA) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(ResponsiveHelper.w(24))),
      ),
      isScrollControlled: true,
      builder: (context) {
        return SquashFriendsSelectionSheet(controller: controller, isSideA: isSideA);
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
    if (cleaned.length <= 12) return cleaned;
    return cleaned.substring(0, 12);
  }
}
