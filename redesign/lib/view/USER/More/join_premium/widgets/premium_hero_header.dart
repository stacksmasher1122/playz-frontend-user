import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PremiumHeroHeader extends StatelessWidget {
  const PremiumHeroHeader({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Column(
      children: [
        // Top Close Button Row
        Align(
          alignment: Alignment.centerLeft,
          child: InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ),
        SizedBox(height: ResponsiveHelper.h(10)),

        // Circular Green Medal Badge
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: const Color(0xFF16251C),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.accent.withValues(alpha: 0.6),
              width: 2,
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.workspace_premium,
              color: AppColors.accent,
              size: 38,
            ),
          ),
        ),
        SizedBox(height: ResponsiveHelper.h(16)),

        // Title: Upgrade to PlayZ Pro
        Text(
          'Upgrade to PlayZ Pro',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: ResponsiveHelper.sp(24),
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: ResponsiveHelper.h(6)),

        // Subtitle: Unlock premium features for every sport
        Text(
          'Unlock premium features for every sport',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            color: Colors.white70,
            fontSize: ResponsiveHelper.sp(14),
          ),
        ),
      ],
    );
  }
}
