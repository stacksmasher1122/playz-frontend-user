import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

Color kCard = Color(0xFF1A1A1A);

class CertificationsBadges extends StatelessWidget {
  CertificationsBadges({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Certifications',
          style: TextStyle(
            color: Colors.white,
            fontSize: ResponsiveHelper.sp(18),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        Wrap(
          spacing: 12,
          children: [
            CertBadge(label: 'ACE Personal Trainer'),
            CertBadge(label: 'Sports Nutrition L1'),
          ],
        ),
      ],
    );
  }
}

class CertBadge extends StatelessWidget {
  final String label;
  CertBadge({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(14), vertical: ResponsiveHelper.h(10)),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
