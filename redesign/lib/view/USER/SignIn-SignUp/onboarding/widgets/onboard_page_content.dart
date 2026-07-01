import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import '../onboarding_models.dart';
import 'package:redesign/theme/responsive_helper.dart';

class OnboardPageContent extends StatelessWidget {
  final OnboardData data;

  OnboardPageContent({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.all(ResponsiveHelper.w(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Illustration / Image
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(28)),
              child: Image.network(
                data.image,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          SizedBox(height: 32),

          /// Tag / Chip
          Container(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(12), vertical: ResponsiveHelper.h(6)),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
            ),
            child: Text(
              data.tag,
              style: TextStyle(
                color: AppColors.accent,
                fontSize: ResponsiveHelper.sp(12),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 16),

          /// Title
          Text(
            data.title,
            style: TextStyle(
              fontSize: ResponsiveHelper.sp(28),
              fontWeight: FontWeight.w800,
              height: ResponsiveHelper.h(1.2),
              color: Colors.white,
            ),
          ),
          SizedBox(height: 12),

          /// Subtitle
          Text(
            data.subtitle,
            style: TextStyle(
              fontSize: ResponsiveHelper.sp(14),
              color: Color(0xFF9CA3AF),
              height: ResponsiveHelper.h(1.5),
            ),
          ),
        ],
      ),
    );
  }
}
