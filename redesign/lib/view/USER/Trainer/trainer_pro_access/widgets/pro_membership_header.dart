import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kGreen = AppColors.accent;

class ProMembershipHeader extends StatelessWidget {
  ProMembershipHeader({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Row(
      children: [
        Text(
          'SELECT MEMBERSHIP',
          style: TextStyle(
            color: Colors.white,
            fontSize: ResponsiveHelper.sp(13.5),
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        Spacer(),
        Row(
          children: [
            Icon(Icons.lock_outline_rounded, size: 14, color: kGreen),
            SizedBox(width: 6),
            Text(
              'SECURE PAYMENT',
              style: TextStyle(
                color: kGreen,
                fontSize: ResponsiveHelper.sp(12),
                fontWeight: FontWeight.w600,
                letterSpacing: 0.6,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
