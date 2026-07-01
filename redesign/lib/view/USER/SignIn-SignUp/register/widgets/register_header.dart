import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class RegisterHeader extends StatelessWidget {
  RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      children: [
        Image.asset(
          'assets/logo.png',
          height: ResponsiveHelper.h(60),
          width: ResponsiveHelper.w(60),
          fit: BoxFit.contain,
        ),
        SizedBox(height: 16),
        Text(
          'Create Account',
          style: TextStyle(
            fontSize: ResponsiveHelper.sp(24),
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Join the PlayZ sports community',
          style: TextStyle(
            fontSize: ResponsiveHelper.sp(14),
            color: Colors.white.withValues(alpha: 0.65),
          ),
        ),
      ],
    );
  }
}
