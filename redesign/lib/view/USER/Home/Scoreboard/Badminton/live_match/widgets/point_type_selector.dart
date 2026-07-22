import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/badminton_controller.dart';

class PointTypeSelector extends StatelessWidget {
  final BadmintonController controller;

  PointTypeSelector({super.key, required this.controller});

  void _showSelector(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(ResponsiveHelper.w(16)),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(ResponsiveHelper.w(24))),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Tag Last Point", style: AppTypography.headlineSm.copyWith(color: AppColors.onPrimary)),
            SizedBox(height: ResponsiveHelper.h(8)),
            Text("Select a fault type to attach to the most recently scored point.", style: AppTypography.bodySm.copyWith(color: AppColors.muted)),
            SizedBox(height: ResponsiveHelper.h(16)),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildOption("Service Fault", "service_fault"),
                _buildOption("Out", "out"),
                _buildOption("Net Touch", "net_touch"),
                _buildOption("Double Hit", "double_hit"),
                _buildOption("Obstruction", "obstruction"),
                _buildOption("Ceiling Hit", "ceiling_hit"),
              ],
            ),
            SizedBox(height: ResponsiveHelper.h(24)),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(String label, String value) {
    return ActionChip(
      backgroundColor: AppColors.card,
      labelStyle: AppTypography.bodyMd.copyWith(color: AppColors.onPrimary),
      label: Text(label),
      onPressed: () {
        Get.back();
        controller.tagLastPoint(value);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.label, color: AppColors.muted),
      tooltip: "Tag Point Type",
      onPressed: () => _showSelector(context),
    );
  }
}
