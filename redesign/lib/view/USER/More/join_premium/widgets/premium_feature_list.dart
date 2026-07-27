import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PremiumFeatureList extends StatelessWidget {
  const PremiumFeatureList({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final features = [
      'Unlimited Match History',
      'Advanced Performance Analytics',
      'AI-Powered Coaching Insights',
      'Exclusive Premium Badges',
      'Priority Booking at Partner Venues',
    ];

    return Column(
      children: features.map((feature) {
        return Padding(
          padding: EdgeInsets.only(bottom: ResponsiveHelper.h(12)),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Color(0xFF16251C),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: AppColors.accent,
                  size: 20,
                ),
              ),
              SizedBox(width: ResponsiveHelper.w(12)),
              Expanded(
                child: Text(
                  feature,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.sp(14),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
