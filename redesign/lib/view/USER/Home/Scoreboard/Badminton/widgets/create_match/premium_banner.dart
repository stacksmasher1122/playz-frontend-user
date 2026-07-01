import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PremiumBanner extends StatelessWidget {
  PremiumBanner({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      width: double.infinity,
      height: ResponsiveHelper.h(140),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
        gradient: LinearGradient(
          colors: [Color(0xFF1E1E1E), Color(0xFF1E1E1E).withValues(alpha: 0.5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Color(0xFF1E1E1E), width: 1),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.2,
              child: Icon(Icons.sports_tennis, size: 100, color: AppColors.accent),
            ),
          ),
          Positioned(
            bottom: ResponsiveHelper.h(12),
            left: ResponsiveHelper.w(12),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(10), vertical: ResponsiveHelper.h(4)),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(4)),
              ),
              child: Text(
                "PREMIUM TRACKING",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: ResponsiveHelper.sp(10),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
