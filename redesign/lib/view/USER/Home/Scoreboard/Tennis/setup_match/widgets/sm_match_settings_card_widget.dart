import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../theme/app_colors.dart';
import '../../../../../../../theme/app_typography.dart';
import '../../../../../../../theme/app_dimensions.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Tennis/setup_match_controller.dart';

class SmMatchSettingsCardWidget extends StatelessWidget {
  const SmMatchSettingsCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SetupMatchController>();

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0x001a1a1a).withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            backgroundBlendMode: BlendMode.dstATop,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MATCH SETTINGS',
                style: AppTypography.labelCaps.copyWith(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: AppDimensions.md),
              Obx(() => _buildToggleRow('No-Ad Scoring', controller.matchSetup.value.noAdScoring, controller.toggleNoAdScoring)),
              const SizedBox(height: AppDimensions.md),
              Obx(() => _buildToggleRow('Advantage Rule', controller.matchSetup.value.advantageRule, controller.toggleAdvantageRule)),
              const SizedBox(height: AppDimensions.md),
              Obx(() => _buildToggleRow('Match Tie-break', controller.matchSetup.value.matchTiebreak, controller.toggleMatchTiebreak)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleRow(String label, bool value, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: AppTypography.bodyMd.copyWith(color: AppColors.onSurface),
        ),
        GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 48,
            height: 24,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: value ? AppColors.primaryContainer : AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(12),
              boxShadow: value
                  ? [
                      BoxShadow(
                        color: AppColors.primaryContainer.withValues(alpha: 0.3),
                        blurRadius: 10,
                      )
                    ]
                  : [],
            ),
            child: Align(
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: value ? AppColors.onPrimaryContainer : AppColors.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
