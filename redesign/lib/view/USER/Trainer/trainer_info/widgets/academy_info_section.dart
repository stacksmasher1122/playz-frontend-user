import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

Color kCard = Color(0xFF1A1A1A);
Color kMuted = Color(0xFFA7A7A7);
Color kGreen = AppColors.accent;
Color kYellow = Color(0xFFFFC107);

class AcademyInfoSection extends StatelessWidget {
  AcademyInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'PowerPlay Cricket Academy',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.sp(22),
                  fontWeight: FontWeight.bold,
                  height: ResponsiveHelper.h(1.2),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(8), vertical: ResponsiveHelper.h(4)),
              decoration: BoxDecoration(
                color: kCard,
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
              ),
              child: Row(
                children: [
                  Icon(Icons.star, color: kYellow, size: 14),
                  SizedBox(width: 4),
                  Text('4.9', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// LOCATION
            Row(
              children: [
                Icon(Icons.location_on_outlined, size: 16, color: kMuted),
                SizedBox(width: 6),
                Text(
                  'Kothrud, Pune • 2.3 km away',
                  style: TextStyle(color: kMuted, fontSize: 14),
                ),
              ],
            ),

            SizedBox(height: 6),

            /// OPEN STATUS (RichText)
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: kMuted),
                SizedBox(width: 6),
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: ResponsiveHelper.sp(14), color: kMuted),
                    children: [
                      TextSpan(
                        text: 'Open Now',
                        style: TextStyle(
                          color: kGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: ' • Closes at 10:00 PM',
                        style: TextStyle(
                          color: kMuted,
                          fontWeight: FontWeight.w600,
                          fontSize: ResponsiveHelper.sp(14),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 6),

            /// CERTIFICATION
            Row(
              children: [
                Icon(Icons.verified_outlined, size: 16, color: kGreen),
                SizedBox(width: 6),
                Text(
                  'Govt. Certified Sports Facility',
                  style: TextStyle(color: kMuted, fontSize: 14),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 12),
        Text(
          'A premier cricket training center equipped with turf wickets, bowling machines, and expert coaching staff. We focus on technique, fitness, and match temperament for aspiring cricketers.',
          style: TextStyle(color: kMuted, height: 1.45),
        ),
      ],
    );
  }
}
