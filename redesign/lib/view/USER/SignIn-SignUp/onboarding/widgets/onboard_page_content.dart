import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import '../onboarding_models.dart';

class OnboardPageContent extends StatelessWidget {
  final OnboardData data;

  const OnboardPageContent({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.widthPct(6),
        vertical: context.heightPct(2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Illustration / Image Container
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(context.minDimensionPct(6)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.background.withValues(alpha: 0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(context.minDimensionPct(6)),
                child: Image.network(
                  data.image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.card,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.sports_soccer_rounded,
                      size: context.minDimensionPct(18),
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: context.heightPct(3)),

          /// Tag / Chip
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.widthPct(3.5),
              vertical: context.heightPct(0.8),
            ),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
              border: Border.all(
                color: AppColors.accent.withValues(alpha: 0.3),
              ),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                data.tag,
                style: AppTypography.labelCaps10.copyWith(
                  color: AppColors.accent,
                  fontSize: context.responsiveFont(11),
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
          SizedBox(height: context.heightPct(1.8)),

          /// Title
          Text(
            data.title,
            style: AppTypography.headlineXl.copyWith(
              fontSize: context.responsiveFont(26),
              fontWeight: FontWeight.w900,
              height: 1.2,
              color: AppColors.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: context.heightPct(1.2)),

          /// Subtitle
          Text(
            data.subtitle,
            style: AppTypography.bodyMd.copyWith(
              fontSize: context.responsiveFont(14),
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
