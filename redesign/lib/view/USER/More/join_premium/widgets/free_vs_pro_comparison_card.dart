import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class FreeVsProComparisonCard extends StatelessWidget {
  const FreeVsProComparisonCard({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Container(
      padding: EdgeInsets.all(context.widthPct(4)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        children: [
          // Header Title
          Text(
            'Free vs Pro',
            style: AppTypography.headlineSm.copyWith(
              color: AppColors.textPrimary,
              fontSize: context.responsiveFont(18),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: context.heightPct(1.8)),

          // Subheader Row: FREE | PRO
          Row(
            children: [
              const Expanded(flex: 4, child: SizedBox.shrink()),
              Expanded(
                flex: 3,
                child: Center(
                  child: Text(
                    'FREE',
                    style: AppTypography.labelCaps10.copyWith(
                      color: AppColors.muted,
                      fontSize: context.responsiveFont(11),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Center(
                  child: Text(
                    'PRO',
                    style: AppTypography.labelCaps10.copyWith(
                      color: AppColors.accent,
                      fontSize: context.responsiveFont(11),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: context.heightPct(1.2)),

          // Row 1: Match History
          const _ComparisonRow(
            feature: 'Match History',
            freeVal: '30 Days',
            proVal: 'Unlimited',
          ),
          const Divider(color: AppColors.borderDark, height: 20),

          // Row 2: Analytics
          const _ComparisonRow(
            feature: 'Analytics',
            freeVal: 'Basic',
            proVal: 'Advanced',
          ),
          const Divider(color: AppColors.borderDark, height: 20),

          // Row 3: AI Insights
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  'AI Insights',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: context.responsiveFont(13),
                  ),
                ),
              ),
              const Expanded(
                flex: 3,
                child: Center(
                  child: Icon(Icons.close, color: AppColors.muted, size: 16),
                ),
              ),
              const Expanded(
                flex: 3,
                child: Center(
                  child: Icon(Icons.check_circle, color: AppColors.accent, size: 18),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ComparisonRow extends StatelessWidget {
  final String feature;
  final String freeVal;
  final String proVal;

  const _ComparisonRow({
    required this.feature,
    required this.freeVal,
    required this.proVal,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Text(
            feature,
            style: AppTypography.bodySm.copyWith(
              color: AppColors.textPrimary,
              fontSize: context.responsiveFont(13),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Center(
            child: Text(
              freeVal,
              style: AppTypography.bodySm.copyWith(
                color: AppColors.muted,
                fontSize: context.responsiveFont(12),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Center(
            child: Text(
              proVal,
              style: AppTypography.bodySm.copyWith(
                color: AppColors.accent,
                fontSize: context.responsiveFont(12),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
