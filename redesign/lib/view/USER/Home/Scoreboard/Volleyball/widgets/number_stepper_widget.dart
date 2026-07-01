import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/responsive_helper.dart';

class NumberStepperWidget extends StatelessWidget {
  final String label;
  final RxInt value;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  NumberStepperWidget({
    super.key,
    required this.label,
    required this.value,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.labelCaps10.copyWith(color: AppColors.muted, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        SizedBox(height: 8),
        Container(
          height: ResponsiveHelper.h(48),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
            border: Border.all(color: AppColors.surfaceContainerHighest),
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove, color: AppColors.primary),
                onPressed: onDecrement,
                splashRadius: 20,
              ),
              Expanded(
                child: Obx(() => Text(
                  '${value.value}',
                  textAlign: TextAlign.center,
                  style: AppTypography.headlineSm.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                )),
              ),
              IconButton(
                icon: Icon(Icons.add, color: AppColors.primary),
                onPressed: onIncrement,
                splashRadius: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
