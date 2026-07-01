import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';

class ErrorBreakdownCard extends StatelessWidget {
  final Map<String, dynamic> errors;

  const ErrorBreakdownCard({super.key, required this.errors});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceContainerHighest, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Error Breakdown',
            style: AppTypography.headlineSm.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...errors.entries.map((entry) {
            bool isPositive = entry.key == "Winners";
            return Column(
              children: [
                _buildErrorRow(entry.key, entry.value['A'], entry.value['B'], isPositive),
                if (entry.key != errors.keys.last)
                  const Divider(color: AppColors.surfaceContainerHighest, height: 24),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildErrorRow(String label, int valA, int valB, bool isPositive) {
    Color colorA;
    Color colorB;

    if (isPositive) {
      colorA = valA >= valB ? AppColors.primaryContainer : AppColors.muted;
      colorB = valB > valA ? AppColors.primaryContainer : AppColors.muted;
    } else {
      colorA = valA < valB ? AppColors.primaryContainer : Colors.redAccent;
      colorB = valB <= valA ? AppColors.primaryContainer : Colors.redAccent;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.bodyMd.copyWith(color: AppColors.muted)),
        Row(
          children: [
            Text(
              valA.toString().padLeft(2, '0'),
              style: AppTypography.headlineMd.copyWith(color: colorA, fontWeight: FontWeight.bold),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('|', style: TextStyle(color: AppColors.surfaceContainerHighest, fontSize: 20)),
            ),
            Text(
              valB.toString().padLeft(2, '0'),
              style: AppTypography.headlineMd.copyWith(color: colorB, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
