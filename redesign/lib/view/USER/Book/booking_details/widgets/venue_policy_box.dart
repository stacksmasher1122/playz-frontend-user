import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class VenuePolicyBox extends StatelessWidget {
  const VenuePolicyBox({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.widthPct(4)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          /// HEADER
          Row(
            children: [
              const Icon(Icons.info_outline, color: AppColors.accent, size: 18),
              SizedBox(width: context.widthPct(2)),
              Text(
                'Venue Policy',
                style: AppTypography.headlineSm.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: context.responsiveFont(16),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          SizedBox(height: context.heightPct(1.5)),

          /// POLICY ITEMS
          _policyItem(context, 'Non-refundable within 4 hours'),
          _policyItem(context, 'Steel studs are prohibited'),
        ],
      ),
    );
  }

  Widget _policyItem(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.heightPct(0.6)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: context.heightPct(0.6)),
            child: const Icon(Icons.circle, size: 6, color: AppColors.muted),
          ),
          SizedBox(width: context.widthPct(2.5)),
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodySm.copyWith(
                color: AppColors.muted,
                fontSize: context.responsiveFont(13),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
