import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';

class StatCardWidget extends StatelessWidget {
  final Widget icon;
  final String label;
  final String value;

  const StatCardWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const SizedBox(height: 12),
          Text(label, style: AppTypography.labelCaps10.copyWith(color: AppColors.muted)),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTypography.headlineMd.copyWith(color: AppColors.primaryContainer, fontWeight: FontWeight.w900),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
