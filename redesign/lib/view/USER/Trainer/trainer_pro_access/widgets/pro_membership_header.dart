import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

const kGreen = AppColors.accent;

class ProMembershipHeader extends StatelessWidget {
  const ProMembershipHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'SELECT MEMBERSHIP',
          style: TextStyle(
            color: Colors.white,
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        const Spacer(),
        Row(
          children: const [
            Icon(Icons.lock_outline_rounded, size: 14, color: kGreen),
            SizedBox(width: 6),
            Text(
              'SECURE PAYMENT',
              style: TextStyle(
                color: kGreen,
                fontSize: 12,
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
