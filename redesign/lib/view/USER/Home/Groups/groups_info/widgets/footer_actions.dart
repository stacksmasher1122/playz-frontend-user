import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Groups_Controller/group_info_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

class FooterActions extends StatelessWidget {
  final GroupInfoController ctrl;

  const FooterActions({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      children: [
        _buildFooterTile(context, Icons.logout, "Leave Group", AppColors.error, () {
          _showConfirmation(context, "Leave Group", "Are you sure you want to leave this group?", ctrl.leaveGroup);
        }),
        SizedBox(height: context.heightPct(1)),
        _buildFooterTile(context, Icons.thumb_down_alt_outlined, "Report Group", AppColors.error, () {
           Get.snackbar(
             'Reported',
             'The group has been reported for review.',
             backgroundColor: AppColors.surface,
             colorText: AppColors.textPrimary,
           );
        }),
      ],
    );
  }

  Widget _buildFooterTile(BuildContext context, IconData icon, String title, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
          border: Border.all(color: AppColors.borderDark),
        ),
        padding: EdgeInsets.all(context.widthPct(4)),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            SizedBox(width: context.widthPct(4)),
            Text(
              title,
              style: AppTypography.headlineSm.copyWith(
                color: color,
                fontSize: context.responsiveFont(14),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmation(BuildContext context, String title, String content, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          title,
          style: AppTypography.headlineSm.copyWith(
            color: AppColors.textPrimary,
            fontSize: context.responsiveFont(16),
          ),
        ),
        content: Text(
          content,
          style: AppTypography.bodySm.copyWith(
            color: AppColors.muted,
            fontSize: context.responsiveFont(14),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: AppTypography.bodySm.copyWith(
                color: AppColors.textPrimary,
                fontSize: context.responsiveFont(14),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: Text(
              "Confirm",
              style: AppTypography.bodySm.copyWith(
                color: AppColors.textPrimary,
                fontSize: context.responsiveFont(14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
