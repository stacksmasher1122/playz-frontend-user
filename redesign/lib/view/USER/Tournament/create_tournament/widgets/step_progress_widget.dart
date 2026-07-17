import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class StepProgressWidget extends StatefulWidget {
  final int currentStep;
  final int totalSteps;

  const StepProgressWidget({
    super.key,
    required this.currentStep,
    this.totalSteps = 6,
  });

  
  @override
  State<StepProgressWidget> createState() => _StepProgressWidgetState();
}

class _StepProgressWidgetState extends State<StepProgressWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
      child: Row(
        children: List.generate(widget.totalSteps, (index) {
          final isActive = index < widget.currentStep;
          return Expanded(
            child: Container(
              height: ResponsiveHelper.h(4),
              margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(3)),
              decoration: BoxDecoration(
                color: isActive ? AppColors.accent : AppColors.card,
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(2)),
              ),
            ),
          );
        }),
      ),
    );
  }
}
