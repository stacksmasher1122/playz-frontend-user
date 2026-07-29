import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class QrVenueInfoCard extends StatelessWidget {
  const QrVenueInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.all(context.widthPct(4)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: AppColors.accent),
          SizedBox(width: context.widthPct(3)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Venue',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.muted,
                    fontSize: context.responsiveFont(12),
                  ),
                ),
                SizedBox(height: context.heightPct(0.4)),
                Text(
                  'Shivajinagar, Pune',
                  style: AppTypography.headlineSm.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: context.responsiveFont(14),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Gate Access',
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.muted,
                  fontSize: context.responsiveFont(12),
                ),
              ),
              SizedBox(height: context.heightPct(0.4)),
              Text(
                'QR Scan Required',
                style: AppTypography.headlineSm.copyWith(
                  color: AppColors.accent,
                  fontSize: context.responsiveFont(13),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: context.heightPct(0.8)),
              OutlinedButton.icon(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.accent),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
                  ),
                ),
                icon: const Icon(Icons.navigation, size: 16, color: AppColors.accent),
                label: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Get Directions',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.accent,
                      fontSize: context.responsiveFont(12),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
