import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_team_management_controller.dart';

class BulkActionButtons extends StatelessWidget {
  final VolleyballTeamManagementController controller;

  const BulkActionButtons({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: ResponsiveHelper.h(56),
          child: OutlinedButton(
            onPressed: () => controller.importPreviousTeam(),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.accent,
              side: BorderSide(color: AppColors.outlineVariant),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.group_add_outlined, color: AppColors.muted),
                SizedBox(width: 12),
                Text(
                  'Import Tournament Team',
                  style: AppTypography.bodyMd.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: ResponsiveHelper.h(56),
                child: OutlinedButton(
                  onPressed: () => controller.cloneTeam(true),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.accent,
                    side: BorderSide(color: AppColors.outlineVariant),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.w(12),
                      ),
                    ),
                  ),
                  child: Text(
                    'Clone Team',
                    style: AppTypography.bodyMd.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: ResponsiveHelper.h(56),
                child: OutlinedButton(
                  onPressed: () => controller.randomizeNumbers(true),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.accent,
                    side: BorderSide(color: AppColors.outlineVariant),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.w(12),
                      ),
                    ),
                  ),
                  child: Text(
                    'Randomize #',
                    style: AppTypography.bodyMd.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
