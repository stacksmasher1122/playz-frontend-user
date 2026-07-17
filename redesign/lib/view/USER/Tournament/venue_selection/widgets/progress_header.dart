import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ProgressHeader extends StatefulWidget {
  final int currentStep;
  final int totalSteps;
  final String title;

  const ProgressHeader({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.title,
  });

  @override
  State<ProgressHeader> createState() => _ProgressHeaderState();
}

class _ProgressHeaderState extends State<ProgressHeader> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
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
        ),
        SizedBox(height: ResponsiveHelper.h(12)),
        Text(
          widget.title,
          style: AppTypography.bodySm.copyWith(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
