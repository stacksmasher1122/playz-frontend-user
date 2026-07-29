import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class VenueTitleSection extends StatelessWidget {
  final String turfName;
  final String location;
  final bool isOpen;

  const VenueTitleSection({
    super.key,
    required this.turfName,
    required this.location,
    required this.isOpen,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// VENUE INFO
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: context.heightPct(1)),
              Text(
                turfName,
                style: AppTypography.displayLg.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: context.responsiveFont(24),
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: context.heightPct(0.6)),
              Row(
                children: [
                  const Icon(Icons.location_on, color: AppColors.muted, size: 16),
                  SizedBox(width: context.widthPct(1)),
                  Expanded(
                    child: Text(
                      location,
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.muted,
                        fontSize: context.responsiveFont(13),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.widthPct(3),
                        vertical: context.heightPct(0.6),
                      ),
                      backgroundColor: isOpen
                          ? AppColors.accent.withValues(alpha: 0.15)
                          : AppColors.error.withValues(alpha: 0.15),
                      foregroundColor: isOpen ? AppColors.accent : AppColors.error,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
                      ),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        isOpen ? 'Open Now' : 'Closed',
                        style: AppTypography.headlineSm.copyWith(
                          fontSize: context.responsiveFont(12),
                          fontWeight: FontWeight.w600,
                          color: isOpen ? AppColors.accent : AppColors.error,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: context.heightPct(1)),

        /// RATING ROW
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
          child: Row(
            children: [
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    Icons.star,
                    size: 16,
                    color: index < 4 ? Colors.amber : AppColors.muted,
                  ),
                ),
              ),
              SizedBox(width: context.widthPct(2)),
              Text(
                '5.0',
                style: AppTypography.headlineSm.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: context.responsiveFont(14),
                ),
              ),
              SizedBox(width: context.widthPct(1.5)),
              Text(
                '(128 Reviews)',
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.muted,
                  fontSize: context.responsiveFont(13),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
