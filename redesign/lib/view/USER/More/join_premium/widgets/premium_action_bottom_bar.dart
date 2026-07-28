import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
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
        left: ResponsiveHelper.w(16),
        right: ResponsiveHelper.w(16),
        top: ResponsiveHelper.h(12),
        bottom: ResponsiveHelper.h(16),
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
            height: ResponsiveHelper.h(52),
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.black,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                buttonText,
                style: GoogleFonts.inter(
                  fontSize: ResponsiveHelper.sp(16),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(12)),

          // Footer links
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Restore Purchases',
                style: GoogleFonts.inter(
                  color: AppColors.muted,
                  fontSize: ResponsiveHelper.sp(11),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '•',
                  style: GoogleFonts.inter(color: AppColors.muted, fontSize: 11),
                ),
              ),
              Text(
                'Terms & Privacy',
                style: GoogleFonts.inter(
                  color: AppColors.muted,
                  fontSize: ResponsiveHelper.sp(11),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
