import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PremiumGuaranteeRating extends StatelessWidget {
  const PremiumGuaranteeRating({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Column(
      children: [
        // Star Rating Row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...List.generate(
              5,
              (index) => const Padding(
                padding: EdgeInsets.symmetric(horizontal: 2),
                child: Icon(Icons.star, color: AppColors.accent, size: 18),
              ),
            ),
            SizedBox(width: ResponsiveHelper.w(8)),
            Text(
              '4.9/5 Rating',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: ResponsiveHelper.sp(13),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: ResponsiveHelper.h(8)),

        // 7-Day Money Back Guarantee Row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shield_outlined, color: AppColors.muted, size: 14),
            SizedBox(width: ResponsiveHelper.w(6)),
            Text(
              '7-Day Money Back Guarantee',
              style: GoogleFonts.inter(
                color: AppColors.muted,
                fontSize: ResponsiveHelper.sp(12),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
