import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class RewardsCard extends StatelessWidget {
  RewardsCard({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(18)),
        child: InkWell(
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(18)),
          onTap: () {
            // TODO: Navigate to Rewards Center
          },
          child: Container(
            padding: EdgeInsets.all(ResponsiveHelper.w(16)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(18)),

              /// Base surface (separates from black bg)
              color: AppColors.surface,

              /// Soft Spotify glow
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: Offset(0, 0),
                ),
              ],

              /// Subtle gradient overlay
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.surface, AppColors.accent.withValues(alpha: 0.12)],
              ),

              /// Thin border for contrast
              border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
            ),
            child: Row(
              children: [
                /// ICON CONTAINER (Spotify style)
                Container(
                  height: ResponsiveHelper.h(42),
                  width: ResponsiveHelper.w(42),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.accent.withValues(alpha: 0.15),
                  ),
                  child: Icon(
                    Icons.card_giftcard,
                    color: AppColors.accent,
                    size: 22,
                  ),
                ),

                SizedBox(width: 14),

                /// TEXT
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rewards Center',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: ResponsiveHelper.sp(15),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Redeem coins for merch & discounts',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          color: AppColors.muted,
                          fontSize: ResponsiveHelper.sp(12),
                        ),
                      ),
                    ],
                  ),
                ),

                /// CTA
                Container(
                  height: ResponsiveHelper.h(32),
                  width: ResponsiveHelper.w(32),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                  child: Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
