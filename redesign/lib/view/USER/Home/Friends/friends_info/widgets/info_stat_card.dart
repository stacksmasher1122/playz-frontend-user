import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class InfoStatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const InfoStatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
      child: Container(
        height: context.heightPct(17),
        decoration: const BoxDecoration(color: AppColors.card),
        child: Stack(
          children: [
            // Background arc decoration
            Positioned(
              top: -30,
              right: -30,
              child: Container(
                width: context.widthPct(26),
                height: context.widthPct(26),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.accent.withValues(alpha: 0.15),
                    width: context.widthPct(4),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(context.widthPct(4)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(icon, color: AppColors.accent, size: 26),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          value,
                          style: AppTypography.displayLg.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: context.responsiveFont(30),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: context.heightPct(0.3)),
                      Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.labelCaps10.copyWith(
                          color: AppColors.muted,
                          fontSize: context.responsiveFont(9),
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
