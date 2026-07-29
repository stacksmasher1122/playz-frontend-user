import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class QrSupportFooter extends StatelessWidget {
  const QrSupportFooter({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Center(
      child: RichText(
        text: TextSpan(
          text: 'Having trouble at the venue? ',
          style: AppTypography.bodySm.copyWith(
            color: AppColors.muted,
            fontSize: context.responsiveFont(13),
          ),
          children: [
            TextSpan(
              text: 'Contact Support',
              style: AppTypography.bodySm.copyWith(
                color: AppColors.textPrimary,
                decoration: TextDecoration.underline,
                fontSize: context.responsiveFont(13),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
