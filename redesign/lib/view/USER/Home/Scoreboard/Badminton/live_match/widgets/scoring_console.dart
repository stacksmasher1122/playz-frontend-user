import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/badminton_controller.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/badminton_state_models.dart';
import 'professional_match_controls.dart';
import 'point_type_selector.dart';

class ScoringConsole extends StatelessWidget {
  final VoidCallback onUndo;
  final VoidCallback onPointSideA;
  final VoidCallback onPointSideB;
  final BadmintonController? controller;

  ScoringConsole({
    super.key,
    required this.onUndo,
    required this.onPointSideA,
    required this.onPointSideB,
    this.controller,
  });

  void _showConductSheet(BuildContext context) {
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
            Text("Conduct Penalty", style: AppTypography.headlineSm.copyWith(color: AppColors.onPrimary)),
            SizedBox(height: ResponsiveHelper.h(16)),
            _buildConductAction(context, "Warning", "warning", "Log a warning (no score change)"),
            _buildConductAction(context, "Fault", "fault", "Award a point to the opponent"),
            _buildConductAction(context, "Disqualify", "disqualify", "End match immediately"),
            SizedBox(height: ResponsiveHelper.h(24)),
          ],
        ),
      ),
    );
  }

  Widget _buildConductAction(BuildContext context, String label, String type, String desc) {
    return ListTile(
      title: Text(label, style: TextStyle(color: type == 'disqualify' ? AppColors.error : AppColors.onPrimary, fontWeight: FontWeight.bold)),
      subtitle: Text(desc, style: TextStyle(color: AppColors.muted)),
      onTap: () {
        Get.back();
        _confirmConduct(context, label, type);
      },
    );
  }

  void _confirmConduct(BuildContext context, String label, String type) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.card,
        title: Text("Apply $label?", style: TextStyle(color: AppColors.onPrimary)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Which side?", style: TextStyle(color: AppColors.muted)),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                  onPressed: () {
                    Get.back();
                    controller?.addConduct(PlayerSide.sideA, type);
                  },
                  child: Text("Side A"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  onPressed: () {
                    Get.back();
                    controller?.addConduct(PlayerSide.sideB, type);
                  },
                  child: Text("Side B"),
                ),
              ],
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Cancel", style: TextStyle(color: AppColors.muted)),
          ),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    bool showProControls = controller != null && !(controller!.isFriendlyRules.value);

    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(ResponsiveHelper.w(32))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showProControls)
              ProfessionalMatchControls(
                onLet: () {
                  // Quick confirm let
                  controller?.addPointWithType(PlayerSide.sideA, 'let'); // Side doesn't matter for let
                },
                onConduct: () => _showConductSheet(context),
                onTimeout: () {
                  Get.snackbar("Timeout", "Medical timeout started (3 min)", backgroundColor: AppColors.surface, colorText: Colors.white);
                },
              ),
            Row(
              children: [
                _actionButton(
                  'UNDO',
                  Icons.undo_rounded,
                  Colors.white24,
                  onUndo,
                ),
                SizedBox(width: 12),
                if (showProControls)
                  PointTypeSelector(controller: controller!),
                SizedBox(width: showProControls ? 12 : 0),
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      _pointButton(
                        '+1 SIDE A',
                        AppColors.error.withValues(alpha: 0.2),
                        onPointSideA,
                        textColor: AppColors.error,
                      ),
                      SizedBox(width: 12),
                      _pointButton(
                        '+1 SIDE B',
                        AppColors.primary.withValues(alpha: 0.2),
                        onPointSideB,
                        textColor: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(
    String label,
    IconData icon,
    Color bg,
    VoidCallback onTap, {
    Color textColor = Colors.white,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(12)),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
          ),
          child: Column(
            children: [
              Icon(icon, color: textColor, size: 20),
              SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontSize: ResponsiveHelper.sp(10),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pointButton(
    String label,
    Color bg,
    VoidCallback onTap, {
    Color textColor = Colors.white,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
            border: Border.all(color: textColor.withValues(alpha: 0.5), width: 1),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: ResponsiveHelper.sp(14),
              fontWeight: FontWeight.w800,
              letterSpacing: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
