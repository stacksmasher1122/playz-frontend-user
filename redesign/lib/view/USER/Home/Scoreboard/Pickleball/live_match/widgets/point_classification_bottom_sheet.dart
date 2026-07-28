import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Pickleball/pickleball_rule_engine.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Pickleball/live_pickleball_match_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PointClassificationBottomSheet extends StatelessWidget {
  final LivePickleballMatchController controller;
  final String teamName;

  PointClassificationBottomSheet({
    super.key,
    required this.controller,
    required this.teamName,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ResponsiveHelper.w(24)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(ResponsiveHelper.w(16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Point Awarded to \$teamName',
                  style: AppTypography.headlineSm.copyWith(color: AppColors.accent),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: AppColors.muted),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
          ),
          Divider(color: AppColors.outlineVariant),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(ResponsiveHelper.w(16)),
              children: [
                _buildSectionHeader('POINT TYPE'),
                _buildOption(
                  icon: Icons.sports_tennis,
                  title: 'Rally Winner',
                  onTap: () {
                    controller.processPoint(teamName, PointType.rallyWinner);
                    Get.back();
                  },
                ),
                _buildOption(
                  icon: Icons.error_outline,
                  title: 'Opponent Fault',
                  onTap: () => _showFaultOptions(context),
                ),
                _buildOption(
                  icon: Icons.flash_on,
                  title: 'Ace (Serve Winner)',
                  onTap: () {
                    controller.processPoint(teamName, PointType.ace);
                    Get.back();
                  },
                ),
                _buildOption(
                  icon: Icons.call_missed_outgoing,
                  title: 'Forced Error',
                  onTap: () {
                    controller.processPoint(teamName, PointType.forcedError);
                    Get.back();
                  },
                ),
                _buildOption(
                  icon: Icons.cancel_outlined,
                  title: 'Unforced Error',
                  onTap: () {
                    controller.processPoint(teamName, PointType.unforcedError);
                    Get.back();
                  },
                ),
                _buildOption(
                  icon: Icons.refresh,
                  title: 'Replay (Does not count)',
                  onTap: () {
                    controller.processPoint(teamName, PointType.replay);
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showFaultOptions(BuildContext context) {
    Get.back(); // Close this sheet
    Get.bottomSheet(
      FaultOptionsBottomSheet(
        controller: controller,
        teamName: teamName,
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveHelper.h(12)),
      child: Text(
        title,
        style: AppTypography.labelCaps.copyWith(color: AppColors.muted),
      ),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: ResponsiveHelper.h(16),
          horizontal: ResponsiveHelper.w(12),
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.outlineVariant, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.accent, size: ResponsiveHelper.w(24)),
            SizedBox(width: ResponsiveHelper.w(16)),
            Text(title, style: AppTypography.bodyMd),
            Spacer(),
            Icon(Icons.chevron_right, color: AppColors.muted),
          ],
        ),
      ),
    );
  }
}

class FaultOptionsBottomSheet extends StatelessWidget {
  final LivePickleballMatchController controller;
  final String teamName;

  FaultOptionsBottomSheet({
    super.key,
    required this.controller,
    required this.teamName,
  });

  @override
  Widget build(BuildContext context) {
    bool isPro = controller.rules.profileName == "Professional Tournament";

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ResponsiveHelper.w(24)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(ResponsiveHelper.w(16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Opponent Fault',
                  style: AppTypography.headlineSm.copyWith(color: AppColors.accent),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: AppColors.muted),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
          ),
          Divider(color: AppColors.outlineVariant),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(ResponsiveHelper.w(16)),
              children: [
                _buildSectionHeader('LOCAL RULES'),
                _buildFaultOption(title: 'Net Fault', faultType: FaultType.netFault),
                _buildFaultOption(title: 'Out Ball', faultType: FaultType.outBall),
                _buildFaultOption(title: 'Double Bounce', faultType: FaultType.doubleBounce),
                _buildFaultOption(title: 'Wrong Server', faultType: FaultType.wrongServer),
                _buildFaultOption(title: 'Wrong Receiver', faultType: FaultType.wrongReceiver),
                _buildFaultOption(title: 'Foot Fault', faultType: FaultType.footFault),
                _buildFaultOption(title: 'Kitchen Fault', faultType: FaultType.kitchenFault),
                
                if (isPro) ...[
                  SizedBox(height: 24),
                  _buildSectionHeader('PROFESSIONAL RULES'),
                  _buildFaultOption(title: 'Incorrect Server Sequence', faultType: FaultType.incorrectServerSequence),
                  _buildFaultOption(title: 'Incorrect Receiver Position', faultType: FaultType.incorrectReceiverPosition),
                  _buildFaultOption(title: 'Illegal Serve', faultType: FaultType.illegalServe),
                  _buildFaultOption(title: 'Distraction Fault', faultType: FaultType.distractionFault),
                  _buildFaultOption(title: 'Technical Warning', faultType: FaultType.technicalWarning),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveHelper.h(12)),
      child: Text(
        title,
        style: AppTypography.labelCaps.copyWith(color: AppColors.muted),
      ),
    );
  }

  Widget _buildFaultOption({
    required String title,
    required FaultType faultType,
  }) {
    return InkWell(
      onTap: () {
        controller.processPoint(teamName, PointType.opponentFault, fault: faultType);
        Get.back();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: ResponsiveHelper.h(16),
          horizontal: ResponsiveHelper.w(12),
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.outlineVariant, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            Text(title, style: AppTypography.bodyMd),
            Spacer(),
            Icon(Icons.add_circle_outline, color: AppColors.accent),
          ],
        ),
      ),
    );
  }
}
