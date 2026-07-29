import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PremiumActionBottomBar extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const PremiumActionBottomBar({
    super.key,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Container(
      padding: EdgeInsets.only(
        left: context.widthPct(4),
        right: context.widthPct(4),
        top: context.heightPct(1.5),
        bottom: context.heightPct(2),
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            blurRadius: 16,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Main CTA Button
          SizedBox(
            width: double.infinity,
            height: context.heightPct(6.2).clamp(48.0, 56.0),
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.background,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
                ),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  buttonText,
                  style: AppTypography.headlineSm.copyWith(
                    color: AppColors.background,
                    fontSize: context.responsiveFont(16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: context.heightPct(1.5)),

          // Footer links
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Restore Purchases',
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.muted,
                  fontSize: context.responsiveFont(11),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.widthPct(2.5)),
                child: Text(
                  '•',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.muted,
                    fontSize: context.responsiveFont(11),
                  ),
                ),
              ),
              Text(
                'Terms & Privacy',
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.muted,
                  fontSize: context.responsiveFont(11),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
