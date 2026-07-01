import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class LoginHeader extends StatelessWidget {
  LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    const kMuted = Color(0xFFA7A7A7);

    return Column(
      children: [
        SizedBox(height: 16),
        Text(
          'Welcome back',
          style: TextStyle(
            fontSize: ResponsiveHelper.sp(22),
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: -0.2,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Ready to get back on the field?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: ResponsiveHelper.sp(13.5),
            color: kMuted,
            height: ResponsiveHelper.h(1.4),
          ),
        ),
      ],
    );
  }
}
