import 'package:redesign/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/football_create_match_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MatchFormatCard extends StatelessWidget {
  const MatchFormatCard({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<FootballCreateMatchController>();

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.w(16.0),
        vertical: ResponsiveHelper.h(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: ResponsiveHelper.w(4),
                height: ResponsiveHelper.h(16),
                color: AppColors.accent, // Lime Green
              ),
              SizedBox(width: 8),
              Text(
                'SQUAD & FORMAT CONFIGURATION',
                style: TextStyle(
                  color: AppColors.accent,
                  fontSize: ResponsiveHelper.sp(12),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          // Squad Limit Card
          _buildStepperCard(
            title: 'SQUAD LIMIT',
            mainText: 'Players per Team',
            valueStream: controller.maxAllowedPlayers,
            onDecrement: controller.decrementSquadLimit,
            onIncrement: controller.incrementSquadLimit,
          ),
          SizedBox(height: 12),

          // Substitute Players Switch Card
          _buildSwitchCard(
            title: 'Substitute Players',
            subtitle: 'Enable mid-match rotations',
            icon: Icons.swap_horiz_rounded,
            valueStream: controller.subsEnabled,
            onChanged: controller.toggleSubs,
          ),

          // Reserves Stepper Card
          Obx(() {
            if (!controller.subsEnabled.value) return const SizedBox.shrink();
            return Padding(
              padding: EdgeInsets.only(top: 12.0),
              child: _buildStepperCard(
                title: 'RESERVES',
                mainText: 'Max Substitutes',
                valueStream: controller.maxSubs,
                onDecrement: controller.decrementSubs,
                onIncrement: controller.incrementSubs,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStepperCard({
    required String title,
    required String mainText,
    required RxInt valueStream,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        border: Border.all(color: Color(0xFF2A2A2A)),
      ),
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.accent,
                    fontSize: ResponsiveHelper.sp(11),
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  mainText,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.sp(16),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.w(6),
              vertical: ResponsiveHelper.h(6),
            ),
            decoration: BoxDecoration(
              color: Color(0xFF121212),
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(30)),
            ),
            child: Row(
              children: [
                _buildCircleBtn(
                  icon: Icons.remove,
                  bgColor: Color(0xFF2C2C2C),
                  iconColor: AppColors.accent,
                  onTap: onDecrement,
                ),
                SizedBox(width: ResponsiveHelper.w(14)),
                Obx(
                  () => Text(
                    valueStream.value.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveHelper.sp(18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(14)),
                _buildCircleBtn(
                  icon: Icons.add,
                  bgColor: AppColors.accent,
                  iconColor: Colors.black,
                  onTap: onIncrement,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required RxBool valueStream,
    required Function(bool) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        border: Border.all(color: Color(0xFF2A2A2A)),
      ),
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(ResponsiveHelper.w(10)),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
            ),
            child: Icon(
              icon,
              color: AppColors.accent,
              size: 22,
            ),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.sp(15),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: ResponsiveHelper.sp(12),
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () => Switch(
              value: valueStream.value,
              onChanged: onChanged,
              activeThumbColor: AppColors.accent,
              activeTrackColor: AppColors.accent.withValues(alpha: 0.4),
              inactiveThumbColor: Colors.grey,
              inactiveTrackColor: Color(0xFF2C2C2C),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleBtn({
    required IconData icon,
    required Color bgColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: ResponsiveHelper.w(32),
        height: ResponsiveHelper.w(32),
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 18,
        ),
      ),
    );
  }
}
