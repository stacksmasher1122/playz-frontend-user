import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class InfoActionButtons extends StatelessWidget {
  const InfoActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildActionButton(context, Icons.search, "SEARCH", () {}),
        SizedBox(width: context.widthPct(4)),
        _buildActionButton(context, Icons.share, "SHARE", () {}),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    final size = context.minDimensionPct(20).clamp(70.0, 90.0);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
          border: Border.all(color: AppColors.borderDark),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.textPrimary, size: 28),
            SizedBox(height: context.heightPct(0.8)),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: AppTypography.labelCaps10.copyWith(
                  color: AppColors.muted,
                  fontSize: context.responsiveFont(10),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
