import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class VenuePolicyBox extends StatelessWidget {
  final List<String>? rules;

  const VenuePolicyBox({
    super.key,
    this.rules,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final effectiveRules = rules != null && rules!.isNotEmpty
        ? rules!
        : const [
            'Full refund if cancelled at least 5 days prior to booking date. No refund thereafter.',
            'Appropriate sports footwear (rubber studs/non-marking shoes) required.',
            'Arrive 10-15 minutes prior to your booked slot time.',
            'Smoking, alcohol, and glass containers are strictly prohibited.',
            'Maintain cleanliness and dispose of trash in designated bins.',
          ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
      child: Container(
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
                const Icon(Icons.verified_user_outlined, color: AppColors.accent, size: 20),
                SizedBox(width: context.widthPct(2.5)),
                Text(
                  'Venue Policy & Rules',
                  style: AppTypography.headlineSm.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: context.responsiveFont(16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            SizedBox(height: context.heightPct(1.5)),

            /// POLICY ITEMS
            ...effectiveRules.map((rule) => _policyItem(context, rule)),
          ],
        ),
      ),
    );
  }

  Widget _policyItem(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.heightPct(0.8)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: context.heightPct(0.6)),
            child: const Icon(Icons.circle, size: 6, color: AppColors.accent),
          ),
          SizedBox(width: context.widthPct(2.5)),
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodySm.copyWith(
                color: AppColors.textSecondary,
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
