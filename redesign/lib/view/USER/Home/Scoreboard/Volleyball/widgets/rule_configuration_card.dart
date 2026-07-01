import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_initialize_match_controller.dart';
import 'number_stepper_widget.dart';
import 'toggle_rule_tile.dart';

class RuleConfigurationCard extends StatelessWidget {
  final VolleyballInitializeMatchController controller;

  const RuleConfigurationCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.surfaceContainerHighest),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Rule\nConfiguration', style: AppTypography.headlineMd.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold, height: 1.2)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text('PRO STANDARDS', style: AppTypography.labelCaps10.copyWith(color: AppColors.onPrimaryContainer, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          NumberStepperWidget(
            label: 'PTS PER SET',
            value: controller.pointsPerSet,
            onIncrement: () => controller.incrementPoints(controller.pointsPerSet),
            onDecrement: () => controller.decrementPoints(controller.pointsPerSet, min: 1),
          ),
          const SizedBox(height: 16),
          NumberStepperWidget(
            label: 'FINAL SET PTS',
            value: controller.finalSetPoints,
            onIncrement: () => controller.incrementPoints(controller.finalSetPoints),
            onDecrement: () => controller.decrementPoints(controller.finalSetPoints, min: 1),
          ),
          const SizedBox(height: 16),
          ToggleRuleTile(
            label: 'WIN BY 2',
            value: controller.winByTwo,
            onChanged: (val) => controller.toggleWinByTwo(val),
          ),
          const SizedBox(height: 16),
          NumberStepperWidget(
            label: 'T-OUTS / SET',
            value: controller.timeouts,
            onIncrement: () => controller.incrementPoints(controller.timeouts),
            onDecrement: () => controller.decrementPoints(controller.timeouts, min: 0),
          ),
          const SizedBox(height: 16),
          NumberStepperWidget(
            label: 'SUB LIMITS / SET',
            value: controller.substitutions,
            onIncrement: () => controller.incrementPoints(controller.substitutions),
            onDecrement: () => controller.decrementPoints(controller.substitutions, min: 0),
          ),
          const SizedBox(height: 16),
          ToggleRuleTile(
            label: 'TECH TIMEOUTS (8/16)',
            value: controller.technicalTimeout,
            onChanged: (val) => controller.toggleTechnicalTimeout(val),
          ),
        ],
      ),
    );
  }
}
