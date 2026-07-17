import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_rotation_subs_controller.dart';
import 'court_player_card.dart';
import 'package:redesign/theme/responsive_helper.dart';

class RotationCourtWidget extends StatelessWidget {
  final VolleyballRotationSubsController controller;

  RotationCourtWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Rotation Map', style: AppTypography.headlineMd.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold)),
            Obx(() => Container(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(8), vertical: ResponsiveHelper.h(4)),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.outlineVariant),
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(4)),
              ),
              child: Text('ROTATION ${controller.rotationNumber.value}', style: AppTypography.labelCaps10.copyWith(color: AppColors.accent)),
            )),
          ],
        ),
        SizedBox(height: 16),
        Container(
          height: ResponsiveHelper.h(300),
          decoration: BoxDecoration(
            color: Color(0xFF161616),
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
            border: Border.all(color: AppColors.outlineVariant),
          ),
          child: Stack(
            children: [
              // Court lines
              Center(
                child: Container(
                  width: ResponsiveHelper.w(2),
                  color: AppColors.accent.withOpacity(0.2), // Attack line
                ),
              ),
              // Players
              Obx(() {
                if (controller.courtPositions.isEmpty) return SizedBox.shrink();
                return Row(
                  children: [
                    // Back Row (P5, P6, P1)
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildPos(4), // Front Left (Wait, Volleyball positions: net is right. Front row is 4, 3, 2. Back row is 5, 6, 1)
                          _buildPos(5),
                        ],
                      ), // Actually, let's map visually to match the prompt's rotation map.
                    ),
                  ],
                );
              }),
              
              // Actual correct Volleyball visual layout mapping
              // Front Row (left side of screen if net is middle, or right side of screen).
              // Assuming net is at the top of the container:
              // Front Row: P4 (left), P3 (center), P2 (right)
              // Back Row: P5 (left), P6 (center), P1 (right)
              Obx(() {
                if (controller.courtPositions.isEmpty) return SizedBox.shrink();
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Front Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildPos(4),
                        _buildPos(3),
                        _buildPos(2),
                      ],
                    ),
                    // Attack Line visual divider
                    Divider(color: AppColors.accent.withOpacity(0.2), thickness: 2, indent: 32, endIndent: 32),
                    // Back Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildPos(5),
                        _buildPos(6),
                        _buildPos(1),
                      ],
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPos(int posIndex) {
    var courtPlayer = controller.courtPositions[posIndex];
    if (courtPlayer == null) return SizedBox(width: ResponsiveHelper.w(80), height: 100);

    bool isCaptain = controller.captain.value?.id == courtPlayer.player.id;
    bool isLibero = controller.libero.value?.id == courtPlayer.player.id;

    return CourtPlayerCard(
      courtPlayer: courtPlayer,
      isCaptain: isCaptain,
      isLibero: isLibero,
    );
  }
}
