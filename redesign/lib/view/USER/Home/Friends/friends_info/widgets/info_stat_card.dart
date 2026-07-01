import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

Color _kGreen = AppColors.accent;
Color _kSurface = Color(0xFF222222);
Color _kMuted = Colors.white60;

class InfoStatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  InfoStatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(ResponsiveHelper.w(24)),
      child: Container(
        height: ResponsiveHelper.h(145),
        decoration: BoxDecoration(color: _kSurface),
        child: Stack(
          children: [
            // Background arc decoration
            Positioned(
              top: -40,
              right: -40,
              child: Container(
                width: ResponsiveHelper.w(110),
                height: ResponsiveHelper.h(110),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _kGreen.withValues(alpha: 0.15),
                    width: ResponsiveHelper.w(18),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(ResponsiveHelper.w(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(icon, color: _kGreen, size: 26),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        value,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ResponsiveHelper.sp(34),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        label,
                        style: TextStyle(
                          color: _kMuted,
                          fontSize: ResponsiveHelper.sp(9),
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
