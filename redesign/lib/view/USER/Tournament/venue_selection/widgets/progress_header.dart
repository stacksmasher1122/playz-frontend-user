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
    ResponsiveHelper.init(context);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
          child: Row(
            children: List.generate(widget.totalSteps, (index) {
              final isActive = index < widget.currentStep;
              return Expanded(
                child: Container(
                  height: context.heightPct(0.5).clamp(3.0, 4.0),
                  margin: EdgeInsets.symmetric(horizontal: context.widthPct(0.8)),
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.accent : AppColors.card,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
        ),
        SizedBox(height: context.heightPct(1.2)),
        Text(
          widget.title,
          style: AppTypography.bodySm.copyWith(
            color: AppColors.textPrimary,
            fontSize: context.responsiveFont(13),
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
