import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ZCoinsCard extends StatelessWidget {
  ZCoinsCard({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
      child: Container(
        padding: EdgeInsets.all(ResponsiveHelper.w(16)),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.surface, AppColors.surface.withValues(alpha: 0.6)],
          ),
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        ),
        child: Row(
          children: [
            Icon(Icons.monetization_on, color: AppColors.accent),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Z Coins Balance\n340',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
