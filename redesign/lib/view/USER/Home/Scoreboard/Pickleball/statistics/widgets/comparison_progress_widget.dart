import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ComparisonProgressWidget extends StatelessWidget {
  final String label;
  final String summary;
  final double ratioA;
  final String valueA;
  final String valueB;
  final AnimationController animController;

  ComparisonProgressWidget({
    super.key,
    required this.label,
    required this.summary,
    required this.ratioA,
    required this.valueA,
    required this.valueB,
    required this.animController,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTypography.bodyMd.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
            Text(summary, style: AppTypography.labelCaps10.copyWith(color: AppColors.primaryContainer, fontWeight: FontWeight.bold)),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              flex: (ratioA * 100).toInt(),
              child: AnimatedBuilder(
                animation: animController,
                builder: (context, child) {
                  return FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: Curves.easeOut.transform(animController.value),
                    child: Container(
                      height: ResponsiveHelper.h(8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        borderRadius: BorderRadius.horizontal(left: Radius.circular(ResponsiveHelper.w(4))),
                      ),
                    ),
                  );
                }
              ),
            ),
            SizedBox(width: 2),
            Expanded(
              flex: ((1 - ratioA) * 100).toInt(),
              child: AnimatedBuilder(
                animation: animController,
                builder: (context, child) {
                  return FractionallySizedBox(
                    alignment: Alignment.centerRight,
                    widthFactor: Curves.easeOut.transform(animController.value),
                    child: Container(
                      height: ResponsiveHelper.h(8),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHighest,
                        borderRadius: BorderRadius.horizontal(right: Radius.circular(ResponsiveHelper.w(4))),
                      ),
                    ),
                  );
                }
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(valueA, style: AppTypography.bodySm.copyWith(color: AppColors.primaryContainer, fontWeight: FontWeight.bold)),
            Text(valueB, style: AppTypography.bodySm.copyWith(color: AppColors.muted, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}
